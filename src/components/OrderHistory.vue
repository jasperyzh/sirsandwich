<template>
  <div class="max-w-6xl mx-auto">
    <!-- Authentication Check -->
    <div v-if="!authStore.isAuthenticated" class="bg-yellow-50 border border-yellow-200 rounded-lg p-6">
      <div class="flex items-center">
        <svg class="w-6 h-6 text-yellow-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
        </svg>
        <div>
          <h3 class="text-lg font-medium text-yellow-800">Authentication Required</h3>
          <p class="text-yellow-700 mt-1">Please log in to view your orders.</p>
          <a href="/login" class="inline-block mt-3 bg-yellow-600 text-white px-4 py-2 rounded-md hover:bg-yellow-700 transition-colors">
            Go to Login
          </a>
        </div>
      </div>
    </div>

    <!-- Loading State -->
    <div v-else-if="isLoading" class="text-center py-12">
      <svg class="animate-spin h-12 w-12 text-orange-600 mx-auto mb-4" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
      </svg>
      <p class="text-gray-600">Loading your orders...</p>
    </div>

    <!-- No Orders -->
    <div v-else-if="orders.length === 0" class="bg-white rounded-lg shadow-md p-8 text-center">
      <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v10a2 2 0 002 2h8a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
      </svg>
      <h3 class="text-xl font-medium text-gray-900 mb-2">No orders yet</h3>
      <p class="text-gray-600 mb-4">You haven't placed any orders yet. Start shopping to see your orders here!</p>
      <a href="/products" class="inline-block bg-orange-600 text-white px-6 py-3 rounded-md hover:bg-orange-700 transition-colors">
        Browse Products
      </a>
    </div>

    <!-- Orders List -->
    <div v-else class="space-y-6">
      <div v-for="order in orders" :key="order.id" class="bg-white rounded-lg shadow-md overflow-hidden">
        <!-- Order Header -->
        <div class="p-6 border-b border-gray-200">
          <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between">
            <div class="mb-4 sm:mb-0">
              <h3 class="text-lg font-semibold text-gray-900">
                Order #{{ order.id.slice(0, 8).toUpperCase() }}
              </h3>
              <p class="text-sm text-gray-600">
                Placed on {{ formatDate(order.created_at) }}
              </p>
            </div>
            <div class="flex flex-col sm:items-end">
              <span :class="getStatusClass(order.status)" class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium mb-2">
                {{ getStatusText(order.status) }}
              </span>
              <p class="text-lg font-semibold text-gray-900">
                ${{ order.total_amount.toFixed(2) }}
              </p>
            </div>
          </div>
        </div>

        <!-- Order Items -->
        <div class="p-6">
          <h4 class="text-md font-medium text-gray-900 mb-4">Order Items</h4>
          <div class="space-y-3">
            <div v-for="item in order.items" :key="item.product_id" class="flex items-center justify-between py-2 border-b border-gray-100 last:border-b-0">
              <div class="flex items-center space-x-3">
                <div class="text-2xl">🥪</div>
                <div>
                  <p class="font-medium text-gray-900">{{ item.product_name }}</p>
                  <p class="text-sm text-gray-600">Quantity: {{ item.quantity }}</p>
                </div>
              </div>
              <div class="text-right">
                <p class="font-medium text-gray-900">${{ item.subtotal.toFixed(2) }}</p>
                <p class="text-sm text-gray-600">${{ item.price.toFixed(2) }} each</p>
              </div>
            </div>
          </div>
        </div>

        <!-- Order Details -->
        <div class="px-6 pb-6">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Delivery Information -->
            <div v-if="order.customer_info?.delivery">
              <h5 class="text-sm font-medium text-gray-900 mb-2">Delivery Address</h5>
              <div class="text-sm text-gray-600">
                <p>{{ order.customer_info.delivery.address }}</p>
                <p>{{ order.customer_info.delivery.city }}, {{ order.customer_info.delivery.state }} {{ order.customer_info.delivery.zipCode }}</p>
                <p v-if="order.customer_info.delivery.instructions" class="mt-1 italic">
                  Instructions: {{ order.customer_info.delivery.instructions }}
                </p>
              </div>
            </div>

            <!-- Payment Information -->
            <div v-if="order.customer_info?.payment">
              <h5 class="text-sm font-medium text-gray-900 mb-2">Payment Method</h5>
              <div class="text-sm text-gray-600">
                <p v-if="order.customer_info.payment.method === 'card'">
                  Credit Card ending in {{ order.customer_info.payment.cardLast4 }}
                </p>
                <p v-else-if="order.customer_info.payment.method === 'cash'">
                  Cash on Delivery
                </p>
              </div>
            </div>
          </div>

          <!-- Order Notes -->
          <div v-if="order.notes" class="mt-4">
            <h5 class="text-sm font-medium text-gray-900 mb-2">Order Notes</h5>
            <p class="text-sm text-gray-600 italic">{{ order.notes }}</p>
          </div>
        </div>

        <!-- Order Actions -->
        <div class="px-6 py-4 bg-gray-50 border-t border-gray-200">
          <div class="flex flex-col sm:flex-row sm:justify-between sm:items-center space-y-2 sm:space-y-0">
            <div class="flex space-x-3">
              <button
                v-if="order.status === 'pending'"
                @click="cancelOrder(order.id)"
                class="text-sm text-red-600 hover:text-red-700 font-medium"
              >
                Cancel Order
              </button>
              <button
                @click="reorderItems(order)"
                class="text-sm text-orange-600 hover:text-orange-700 font-medium"
              >
                Reorder
              </button>
            </div>
            <button
              @click="toggleOrderDetails(order.id)"
              class="text-sm text-gray-600 hover:text-gray-700 font-medium"
            >
              {{ expandedOrders.includes(order.id) ? 'Hide Details' : 'View Details' }}
            </button>
          </div>
        </div>

        <!-- Expanded Order Details -->
        <div v-if="expandedOrders.includes(order.id)" class="px-6 py-4 bg-gray-50 border-t border-gray-200">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <!-- Order Timeline -->
            <div>
              <h5 class="text-sm font-medium text-gray-900 mb-3">Order Timeline</h5>
              <div class="space-y-2">
                <div class="flex items-center text-sm">
                  <div class="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
                  <span class="text-gray-600">Order placed - {{ formatDate(order.created_at) }}</span>
                </div>
                <div v-if="order.status !== 'pending'" class="flex items-center text-sm">
                  <div class="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
                  <span class="text-gray-600">Order confirmed</span>
                </div>
                <div v-if="order.status === 'preparing' || order.status === 'ready' || order.status === 'delivered'" class="flex items-center text-sm">
                  <div class="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
                  <span class="text-gray-600">Preparing your order</span>
                </div>
                <div v-if="order.status === 'ready' || order.status === 'delivered'" class="flex items-center text-sm">
                  <div class="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
                  <span class="text-gray-600">Order ready for delivery</span>
                </div>
                <div v-if="order.status === 'delivered'" class="flex items-center text-sm">
                  <div class="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
                  <span class="text-gray-600">Order delivered</span>
                </div>
              </div>
            </div>

            <!-- Order Totals Breakdown -->
            <div>
              <h5 class="text-sm font-medium text-gray-900 mb-3">Order Summary</h5>
              <div class="space-y-1 text-sm">
                <div class="flex justify-between">
                  <span class="text-gray-600">Subtotal</span>
                  <span class="text-gray-900">${{ order.customer_info?.totals?.subtotal?.toFixed(2) || '0.00' }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="text-gray-600">Tax</span>
                  <span class="text-gray-900">${{ order.customer_info?.totals?.tax?.toFixed(2) || '0.00' }}</span>
                </div>
                <div class="flex justify-between">
                  <span class="text-gray-600">Delivery Fee</span>
                  <span class="text-gray-900">${{ order.customer_info?.totals?.deliveryFee?.toFixed(2) || '0.00' }}</span>
                </div>
                <div class="flex justify-between font-medium border-t pt-1">
                  <span class="text-gray-900">Total</span>
                  <span class="text-gray-900">${{ order.total_amount.toFixed(2) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '../stores/authStore.js'
import { useCartStore } from '../stores/cartStore.js'
import { supabase } from '../lib/supabase.js'

// Stores
const authStore = useAuthStore()
const cartStore = useCartStore()

// Component state
const orders = ref([])
const isLoading = ref(false)
const expandedOrders = ref([])

// Load orders on component mount
onMounted(async () => {
  await authStore.initializeAuth()
  if (authStore.isAuthenticated) {
    await loadOrders()
  }
})

// Load user orders from Supabase
const loadOrders = async () => {
  try {
    isLoading.value = true

    const { data, error } = await supabase
      .from('orders')
      .select('*')
      .eq('user_id', authStore.user.id)
      .order('created_at', { ascending: false })

    if (error) throw error

    orders.value = data || []
    console.log('📦 Loaded orders:', orders.value.length)

  } catch (error) {
    console.error('❌ Failed to load orders:', error)
  } finally {
    isLoading.value = false
  }
}

// Utility functions
const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

const getStatusClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800',
    confirmed: 'bg-blue-100 text-blue-800',
    preparing: 'bg-orange-100 text-orange-800',
    ready: 'bg-purple-100 text-purple-800',
    delivered: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

const getStatusText = (status) => {
  const texts = {
    pending: 'Pending',
    confirmed: 'Confirmed',
    preparing: 'Preparing',
    ready: 'Ready for Delivery',
    delivered: 'Delivered',
    cancelled: 'Cancelled'
  }
  return texts[status] || 'Unknown'
}

// Order actions
const toggleOrderDetails = (orderId) => {
  const index = expandedOrders.value.indexOf(orderId)
  if (index > -1) {
    expandedOrders.value.splice(index, 1)
  } else {
    expandedOrders.value.push(orderId)
  }
}

const cancelOrder = async (orderId) => {
  if (!confirm('Are you sure you want to cancel this order?')) {
    return
  }

  try {
    const { error } = await supabase
      .from('orders')
      .update({ status: 'cancelled' })
      .eq('id', orderId)
      .eq('user_id', authStore.user.id)

    if (error) throw error

    // Update local state
    const order = orders.value.find(o => o.id === orderId)
    if (order) {
      order.status = 'cancelled'
    }

    console.log('✅ Order cancelled successfully')

  } catch (error) {
    console.error('❌ Failed to cancel order:', error)
    alert('Failed to cancel order. Please try again.')
  }
}

const reorderItems = async (order) => {
  try {
    // Add all items from the order back to cart
    for (const item of order.items) {
      // You might need to fetch the current product data to ensure it's still available
      const product = {
        id: item.product_id,
        name: item.product_name,
        price: item.price,
        image: '🥪', // You might want to fetch this from products table
        category: 'Sandwich' // You might want to fetch this from products table
      }

      for (let i = 0; i < item.quantity; i++) {
        await cartStore.addItem(product)
      }
    }

    alert(`Added ${order.items.length} items to your cart!`)
    
  } catch (error) {
    console.error('❌ Failed to reorder items:', error)
    alert('Failed to add items to cart. Please try again.')
  }
}
</script> 