<template>
  <!-- Cart Toggle Button -->
  <div class="relative">
    <button
      @click="cartStore.toggleCart()"
      class="relative bg-blue-500 hover:bg-blue-600 text-white p-3 rounded-full transition duration-300 shadow-lg"
      :class="{ 'scale-110': cartStore.itemCount > 0 }"
    >
      🛒
      <!-- Cart Badge -->
      <span
        v-if="cartStore.itemCount > 0"
        class="absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full h-6 w-6 flex items-center justify-center font-bold animate-pulse"
      >
        {{ cartStore.itemCount }}
      </span>
    </button>

    <!-- Cart Dropdown -->
    <div
      v-if="cartStore.isOpen"
      class="absolute right-0 mt-2 w-96 bg-white border border-gray-200 rounded-lg shadow-xl z-50 overflow-hidden"
    >
      <!-- Cart Header -->
      <div class="p-4 border-b border-gray-200 bg-gray-50">
        <div class="flex justify-between items-center">
          <h3 class="text-lg font-semibold text-gray-800">
            Shopping Cart ({{ cartStore.itemCount }})
          </h3>
          <button
            @click="cartStore.closeCart()"
            class="text-gray-500 hover:text-gray-700 text-xl font-bold"
          >
            ×
          </button>
        </div>
      </div>

      <!-- Cart Items -->
      <div v-if="!cartStore.isEmpty" class="max-h-64 overflow-y-auto">
        <div
          v-for="item in cartStore.items"
          :key="item.id"
          class="p-4 border-b border-gray-100 hover:bg-gray-50 transition duration-200"
        >
          <div class="flex items-center space-x-3">
            <!-- Product Image -->
            <div class="text-2xl">{{ item.image }}</div>
            
            <!-- Product Info -->
            <div class="flex-1">
              <h4 class="font-medium text-gray-800">{{ item.name }}</h4>
              <p class="text-sm text-gray-600">{{ item.category }}</p>
              <p class="text-sm font-semibold text-green-600">${{ item.price.toFixed(2) }}</p>
            </div>
            
            <!-- Quantity Controls -->
            <div class="flex items-center space-x-2">
              <button
                @click="updateQuantity(item.id, item.quantity - 1)"
                class="w-6 h-6 bg-gray-200 hover:bg-gray-300 rounded text-sm font-bold transition duration-200"
              >
                -
              </button>
              <span class="text-sm font-medium w-8 text-center">{{ item.quantity }}</span>
              <button
                @click="updateQuantity(item.id, item.quantity + 1)"
                class="w-6 h-6 bg-gray-200 hover:bg-gray-300 rounded text-sm font-bold transition duration-200"
              >
                +
              </button>
              <button
                @click="removeItem(item.id)"
                class="ml-2 text-red-500 hover:text-red-700 text-sm font-bold"
              >
                🗑️
              </button>
            </div>
          </div>
        </div>
      </div>

      <!-- Empty Cart Message -->
      <div v-else class="p-8 text-center text-gray-500">
        <div class="text-4xl mb-2">🛒</div>
        <p class="text-lg">Your cart is empty</p>
        <p class="text-sm">Add some delicious sandwiches!</p>
      </div>

      <!-- Cart Footer -->
      <div v-if="!cartStore.isEmpty" class="p-4 border-t border-gray-200 bg-gray-50">
        <div class="flex justify-between items-center mb-3">
          <span class="text-lg font-semibold text-gray-800">Total:</span>
          <span class="text-xl font-bold text-green-600">
            ${{ cartStore.totalPrice.toFixed(2) }}
          </span>
        </div>
        
        <div class="flex space-x-2">
          <button
            @click="clearCart"
            class="flex-1 bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded-lg transition duration-300 text-sm"
          >
            Clear Cart
          </button>
          <button
            @click="checkout"
            class="flex-2 bg-green-500 hover:bg-green-600 text-white py-2 px-6 rounded-lg transition duration-300 font-medium"
          >
            Checkout 🚀
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { createApp } from 'vue'
import { useCartStore } from '../stores/cartStore.js'
import { pinia } from '../stores/pinia.js'

// Initialize Pinia and use the cart store
const app = createApp({})
app.use(pinia)
const cartStore = useCartStore()

// Methods
const updateQuantity = (productId, newQuantity) => {
  cartStore.updateQuantity(productId, newQuantity)
}

const removeItem = (productId) => {
  cartStore.removeItem(productId)
}

const clearCart = () => {
  if (confirm('Are you sure you want to clear your cart?')) {
    cartStore.clearCart()
  }
}

const checkout = () => {
  console.log('🚀 Proceeding to checkout with items:', cartStore.items)
  cartStore.closeCart()
  // Navigate to checkout page
  window.location.href = '/checkout'
}
</script>

<style scoped>
/* Custom scrollbar for cart items */
.max-h-64::-webkit-scrollbar {
  width: 4px;
}

.max-h-64::-webkit-scrollbar-track {
  background: #f1f1f1;
}

.max-h-64::-webkit-scrollbar-thumb {
  background: #c1c1c1;
  border-radius: 2px;
}

.max-h-64::-webkit-scrollbar-thumb:hover {
  background: #a1a1a1;
}
</style> 