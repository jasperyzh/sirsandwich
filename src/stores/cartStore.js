import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase } from '../lib/supabase.js'
import { useAuthStore } from './authStore.js'

export const useCartStore = defineStore('cart', () => {
  // State
  const items = ref([])
  const isOpen = ref(false)
  const isLoading = ref(false)
  const isCheckingOut = ref(false)

  // Getters (computed)
  const itemCount = computed(() => {
    return items.value.reduce((total, item) => total + item.quantity, 0)
  })

  const totalPrice = computed(() => {
    return items.value.reduce((total, item) => total + (item.price * item.quantity), 0)
  })

  const isEmpty = computed(() => items.value.length === 0)

  const formattedTotal = computed(() => {
    return `$${totalPrice.value.toFixed(2)}`
  })

  // Actions
  const addItem = async (product) => {
    console.log('🛒 Adding item to cart:', product.name)
    
    const existingItem = items.value.find(item => item.id === product.id)
    
    if (existingItem) {
      existingItem.quantity += 1
      console.log(`📈 Increased quantity of ${product.name} to ${existingItem.quantity}`)
    } else {
      const cartItem = {
        id: product.id,
        name: product.name,
        price: product.price,
        image: product.image,
        category: product.category,
        quantity: 1
      }
      items.value.push(cartItem)
      console.log(`✅ Added new item to cart: ${product.name}`)
    }
    
    await saveCart()
    return true
  }

  const removeItem = async (productId) => {
    const index = items.value.findIndex(item => item.id === productId)
    if (index > -1) {
      const removedItem = items.value.splice(index, 1)[0]
      console.log(`🗑️ Removed ${removedItem.name} from cart`)
      await saveCart()
      return true
    }
    return false
  }

  const updateQuantity = async (productId, newQuantity) => {
    if (newQuantity <= 0) {
      return await removeItem(productId)
    }
    
    const item = items.value.find(item => item.id === productId)
    if (item) {
      item.quantity = newQuantity
      console.log(`📊 Updated ${item.name} quantity to ${newQuantity}`)
      await saveCart()
      return true
    }
    return false
  }

  const clearCart = async () => {
    console.log('🧹 Clearing cart')
    items.value = []
    await saveCart()
  }

  const toggleCart = () => {
    isOpen.value = !isOpen.value
    console.log(`🛒 Cart ${isOpen.value ? 'opened' : 'closed'}`)
  }

  const openCart = () => {
    isOpen.value = true
  }

  const closeCart = () => {
    isOpen.value = false
  }

  // Enhanced persistence - supports both localStorage and Supabase
  const saveCart = async () => {
    const authStore = useAuthStore()
    
    if (authStore.isAuthenticated) {
      // Save to Supabase for authenticated users
      await saveToSupabase()
    } else {
      // Save to localStorage for guest users
      saveToLocalStorage()
    }
  }

  const loadCart = async () => {
    const authStore = useAuthStore()
    
    if (authStore.isAuthenticated) {
      // Load from Supabase for authenticated users
      await loadFromSupabase()
    } else {
      // Load from localStorage for guest users
      loadFromLocalStorage()
    }
  }

  // Local Storage persistence (for guest users)
  const saveToLocalStorage = () => {
    try {
      localStorage.setItem('sirsandwich-cart', JSON.stringify(items.value))
      console.log('💾 Cart saved to localStorage')
    } catch (error) {
      console.error('❌ Failed to save cart to localStorage:', error)
    }
  }

  const loadFromLocalStorage = () => {
    try {
      const savedCart = localStorage.getItem('sirsandwich-cart')
      if (savedCart) {
        items.value = JSON.parse(savedCart)
        console.log('📥 Cart loaded from localStorage:', items.value.length, 'items')
      }
    } catch (error) {
      console.error('❌ Failed to load cart from localStorage:', error)
      items.value = []
    }
  }

  // Supabase persistence (for authenticated users)
  const saveToSupabase = async () => {
    try {
      const authStore = useAuthStore()
      if (!authStore.user) return

      isLoading.value = true

      // First, clear existing cart items for this user
      await supabase
        .from('cart_items')
        .delete()
        .eq('user_id', authStore.user.id)

      // Then insert current cart items
      if (items.value.length > 0) {
        const cartItems = items.value.map(item => ({
          user_id: authStore.user.id,
          product_id: item.id,
          quantity: item.quantity,
          price: item.price
        }))

        const { error } = await supabase
          .from('cart_items')
          .insert(cartItems)

        if (error) throw error
      }

      console.log('💾 Cart saved to Supabase')
    } catch (error) {
      console.error('❌ Failed to save cart to Supabase:', error)
    } finally {
      isLoading.value = false
    }
  }

  const loadFromSupabase = async () => {
    try {
      const authStore = useAuthStore()
      if (!authStore.user) return

      isLoading.value = true

      const { data, error } = await supabase
        .from('cart_items')
        .select(`
          quantity,
          price,
          products (
            id,
            name,
            price,
            image_url,
            category_id,
            categories (name)
          )
        `)
        .eq('user_id', authStore.user.id)

      if (error) throw error

      // Transform Supabase data to cart format
      items.value = data.map(item => ({
        id: item.products.id,
        name: item.products.name,
        price: item.price,
        image: item.products.image_url,
        category: item.products.categories?.name || 'Unknown',
        quantity: item.quantity
      }))

      console.log('📥 Cart loaded from Supabase:', items.value.length, 'items')
    } catch (error) {
      console.error('❌ Failed to load cart from Supabase:', error)
      items.value = []
    } finally {
      isLoading.value = false
    }
  }

  // Migrate cart from localStorage to Supabase when user logs in
  const migrateGuestCart = async () => {
    try {
      const guestCart = localStorage.getItem('sirsandwich-cart')
      if (guestCart) {
        const guestItems = JSON.parse(guestCart)
        
        // Merge guest cart with any existing user cart
        for (const guestItem of guestItems) {
          const existingItem = items.value.find(item => item.id === guestItem.id)
          if (existingItem) {
            existingItem.quantity += guestItem.quantity
          } else {
            items.value.push(guestItem)
          }
        }

        // Save merged cart to Supabase
        await saveToSupabase()
        
        // Clear localStorage cart
        localStorage.removeItem('sirsandwich-cart')
        
        console.log('🔄 Guest cart migrated to user account')
      }
    } catch (error) {
      console.error('❌ Failed to migrate guest cart:', error)
    }
  }

  // Checkout functionality
  const checkout = async (orderData) => {
    try {
      isCheckingOut.value = true
      const authStore = useAuthStore()

      if (!authStore.isAuthenticated) {
        throw new Error('User must be authenticated to place an order')
      }

      if (isEmpty.value) {
        throw new Error('Cart is empty')
      }

      // Create order in Supabase
      const order = {
        user_id: authStore.user.id,
        total_amount: totalPrice.value,
        status: 'pending',
        items: items.value.map(item => ({
          product_id: item.id,
          product_name: item.name,
          quantity: item.quantity,
          price: item.price,
          subtotal: item.price * item.quantity
        })),
        customer_info: orderData
      }

      const { data: orderResult, error: orderError } = await supabase
        .from('orders')
        .insert(order)
        .select()
        .single()

      if (orderError) throw orderError

      // Create order items
      const orderItems = items.value.map(item => ({
        order_id: orderResult.id,
        product_id: item.id,
        quantity: item.quantity,
        price: item.price
      }))

      const { error: itemsError } = await supabase
        .from('order_items')
        .insert(orderItems)

      if (itemsError) throw itemsError

      // Send order confirmation email
      try {
        const emailResponse = await fetch('/api/send-order-email', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            order: orderResult,
            customer: orderData.customer
          })
        })

        if (emailResponse.ok) {
          console.log('📧 Order confirmation email sent successfully')
        } else {
          console.warn('⚠️ Failed to send order confirmation email')
        }
      } catch (emailError) {
        console.warn('⚠️ Email sending failed:', emailError)
        // Don't fail the entire checkout if email fails
      }

      // Clear cart after successful order
      await clearCart()

      console.log('✅ Order placed successfully:', orderResult.id)
      return orderResult

    } catch (error) {
      console.error('❌ Checkout failed:', error)
      throw error
    } finally {
      isCheckingOut.value = false
    }
  }

  // Initialize cart from appropriate source
  const initializeCart = async () => {
    const authStore = useAuthStore()
    
    if (typeof window !== 'undefined') {
      if (authStore.isAuthenticated) {
        await loadFromSupabase()
      } else {
        loadFromLocalStorage()
      }
    }
  }

  return {
    // State
    items,
    isOpen,
    isLoading,
    isCheckingOut,
    
    // Getters
    itemCount,
    totalPrice,
    formattedTotal,
    isEmpty,
    
    // Actions
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
    toggleCart,
    openCart,
    closeCart,
    
    // Persistence
    saveCart,
    loadCart,
    migrateGuestCart,
    initializeCart,
    
    // Checkout
    checkout
  }
}) 