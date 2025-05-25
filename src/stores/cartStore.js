import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useCartStore = defineStore('cart', () => {
  // State
  const items = ref([])
  const isOpen = ref(false)

  // Getters (computed)
  const itemCount = computed(() => {
    return items.value.reduce((total, item) => total + item.quantity, 0)
  })

  const totalPrice = computed(() => {
    return items.value.reduce((total, item) => total + (item.price * item.quantity), 0)
  })

  const isEmpty = computed(() => items.value.length === 0)

  // Actions
  const addItem = (product) => {
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
    
    saveToLocalStorage()
    return true
  }

  const removeItem = (productId) => {
    const index = items.value.findIndex(item => item.id === productId)
    if (index > -1) {
      const removedItem = items.value.splice(index, 1)[0]
      console.log(`🗑️ Removed ${removedItem.name} from cart`)
      saveToLocalStorage()
      return true
    }
    return false
  }

  const updateQuantity = (productId, newQuantity) => {
    if (newQuantity <= 0) {
      return removeItem(productId)
    }
    
    const item = items.value.find(item => item.id === productId)
    if (item) {
      item.quantity = newQuantity
      console.log(`📊 Updated ${item.name} quantity to ${newQuantity}`)
      saveToLocalStorage()
      return true
    }
    return false
  }

  const clearCart = () => {
    console.log('🧹 Clearing cart')
    items.value = []
    saveToLocalStorage()
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

  // Local Storage persistence
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

  // Initialize cart from localStorage on store creation
  if (typeof window !== 'undefined') {
    loadFromLocalStorage()
  }

  return {
    // State
    items,
    isOpen,
    
    // Getters
    itemCount,
    totalPrice,
    isEmpty,
    
    // Actions
    addItem,
    removeItem,
    updateQuantity,
    clearCart,
    toggleCart,
    openCart,
    closeCart,
    loadFromLocalStorage
  }
}) 