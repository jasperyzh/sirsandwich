<template>
  <div class="max-w-4xl mx-auto">
    <!-- Authentication Check -->
    <div v-if="!authStore.isAuthenticated" class="bg-yellow-50 border border-yellow-200 rounded-lg p-6 mb-8">
      <div class="flex items-center">
        <svg class="w-6 h-6 text-yellow-600 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L3.732 16.5c-.77.833.192 2.5 1.732 2.5z" />
        </svg>
        <div>
          <h3 class="text-lg font-medium text-yellow-800">Authentication Required</h3>
          <p class="text-yellow-700 mt-1">Please log in to complete your order.</p>
          <a href="/login" class="inline-block mt-3 bg-yellow-600 text-white px-4 py-2 rounded-md hover:bg-yellow-700 transition-colors">
            Go to Login
          </a>
        </div>
      </div>
    </div>

    <!-- Empty Cart Check -->
    <div v-else-if="cartStore.isEmpty" class="bg-gray-50 border border-gray-200 rounded-lg p-8 text-center">
      <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4m0 0L7 13m0 0l-1.5 6M7 13l-1.5-6m0 0h15.5M17 21a2 2 0 100-4 2 2 0 000 4zM9 21a2 2 0 100-4 2 2 0 000 4z" />
      </svg>
      <h3 class="text-xl font-medium text-gray-900 mb-2">Your cart is empty</h3>
      <p class="text-gray-600 mb-4">Add some delicious sandwiches to your cart before checking out.</p>
      <a href="/products" class="inline-block bg-orange-600 text-white px-6 py-3 rounded-md hover:bg-orange-700 transition-colors">
        Browse Products
      </a>
    </div>

    <!-- Checkout Form -->
    <div v-else class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <!-- Order Summary -->
      <div class="lg:order-2">
        <div class="bg-white rounded-lg shadow-md p-6 sticky top-8">
          <h2 class="text-xl font-semibold text-gray-900 mb-4">Order Summary</h2>
          
          <!-- Cart Items -->
          <div class="space-y-4 mb-6">
            <div v-for="item in cartStore.items" :key="item.id" class="flex items-center space-x-4">
              <img :src="item.image" :alt="item.name" class="w-16 h-16 object-cover rounded-md">
              <div class="flex-1">
                <h3 class="font-medium text-gray-900">{{ item.name }}</h3>
                <p class="text-sm text-gray-600">{{ item.category }}</p>
                <p class="text-sm text-gray-600">Qty: {{ item.quantity }}</p>
              </div>
              <div class="text-right">
                <p class="font-medium text-gray-900">${{ (item.price * item.quantity).toFixed(2) }}</p>
              </div>
            </div>
          </div>

          <!-- Order Totals -->
          <div class="border-t pt-4 space-y-2">
            <div class="flex justify-between text-sm">
              <span class="text-gray-600">Subtotal</span>
              <span class="text-gray-900">{{ cartStore.formattedTotal }}</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-gray-600">Tax (8.5%)</span>
              <span class="text-gray-900">${{ tax.toFixed(2) }}</span>
            </div>
            <div class="flex justify-between text-sm">
              <span class="text-gray-600">Delivery Fee</span>
              <span class="text-gray-900">${{ deliveryFee.toFixed(2) }}</span>
            </div>
            <div class="border-t pt-2 flex justify-between text-lg font-semibold">
              <span class="text-gray-900">Total</span>
              <span class="text-gray-900">${{ orderTotal.toFixed(2) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Checkout Form -->
      <div class="lg:order-1">
        <form @submit.prevent="handleSubmit" class="space-y-8">
          <!-- Customer Information -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Customer Information</h2>
            
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <label for="firstName" class="block text-sm font-medium text-gray-700 mb-1">First Name</label>
                <input
                  type="text"
                  id="firstName"
                  v-model="form.firstName"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>
              <div>
                <label for="lastName" class="block text-sm font-medium text-gray-700 mb-1">Last Name</label>
                <input
                  type="text"
                  id="lastName"
                  v-model="form.lastName"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>
            </div>

            <div class="mt-4">
              <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
              <input
                type="email"
                id="email"
                v-model="form.email"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              >
            </div>

            <div class="mt-4">
              <label for="phone" class="block text-sm font-medium text-gray-700 mb-1">Phone Number</label>
              <input
                type="tel"
                id="phone"
                v-model="form.phone"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              >
            </div>
          </div>

          <!-- Delivery Information -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Delivery Information</h2>
            
            <div class="mb-4">
              <label for="address" class="block text-sm font-medium text-gray-700 mb-1">Street Address</label>
              <input
                type="text"
                id="address"
                v-model="form.address"
                required
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              >
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label for="city" class="block text-sm font-medium text-gray-700 mb-1">City</label>
                <input
                  type="text"
                  id="city"
                  v-model="form.city"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>
              <div>
                <label for="state" class="block text-sm font-medium text-gray-700 mb-1">State</label>
                <input
                  type="text"
                  id="state"
                  v-model="form.state"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>
              <div>
                <label for="zipCode" class="block text-sm font-medium text-gray-700 mb-1">ZIP Code</label>
                <input
                  type="text"
                  id="zipCode"
                  v-model="form.zipCode"
                  required
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>
            </div>

            <div class="mt-4">
              <label for="deliveryInstructions" class="block text-sm font-medium text-gray-700 mb-1">Delivery Instructions (Optional)</label>
              <textarea
                id="deliveryInstructions"
                v-model="form.deliveryInstructions"
                rows="3"
                class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                placeholder="Any special delivery instructions..."
              ></textarea>
            </div>
          </div>

          <!-- Payment Information -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Payment Information</h2>
            
            <!-- Payment Method Selection -->
            <div class="mb-6">
              <label class="block text-sm font-medium text-gray-700 mb-3">Payment Method</label>
              <div class="space-y-3">
                <label class="flex items-center">
                  <input
                    type="radio"
                    v-model="form.paymentMethod"
                    value="card"
                    class="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300"
                  >
                  <span class="ml-3 text-sm text-gray-700">Credit/Debit Card</span>
                </label>
                <label class="flex items-center">
                  <input
                    type="radio"
                    v-model="form.paymentMethod"
                    value="cash"
                    class="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300"
                  >
                  <span class="ml-3 text-sm text-gray-700">Cash on Delivery</span>
                </label>
              </div>
            </div>

            <!-- Card Payment Form (shown when card is selected) -->
            <div v-if="form.paymentMethod === 'card'" class="space-y-4">
              <div>
                <label for="cardNumber" class="block text-sm font-medium text-gray-700 mb-1">Card Number</label>
                <input
                  type="text"
                  id="cardNumber"
                  v-model="form.cardNumber"
                  placeholder="1234 5678 9012 3456"
                  maxlength="19"
                  @input="formatCardNumber"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>

              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label for="expiryDate" class="block text-sm font-medium text-gray-700 mb-1">Expiry Date</label>
                  <input
                    type="text"
                    id="expiryDate"
                    v-model="form.expiryDate"
                    placeholder="MM/YY"
                    maxlength="5"
                    @input="formatExpiryDate"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  >
                </div>
                <div>
                  <label for="cvv" class="block text-sm font-medium text-gray-700 mb-1">CVV</label>
                  <input
                    type="text"
                    id="cvv"
                    v-model="form.cvv"
                    placeholder="123"
                    maxlength="4"
                    class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                  >
                </div>
              </div>

              <div>
                <label for="cardName" class="block text-sm font-medium text-gray-700 mb-1">Name on Card</label>
                <input
                  type="text"
                  id="cardName"
                  v-model="form.cardName"
                  class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                >
              </div>
            </div>

            <!-- Cash on Delivery Info -->
            <div v-else-if="form.paymentMethod === 'cash'" class="bg-blue-50 border border-blue-200 rounded-md p-4">
              <div class="flex items-start">
                <svg class="w-5 h-5 text-blue-600 mt-0.5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
                <div>
                  <h4 class="text-sm font-medium text-blue-800">Cash on Delivery</h4>
                  <p class="text-sm text-blue-700 mt-1">
                    You will pay in cash when your order is delivered. Please have the exact amount ready: <strong>${{ orderTotal.toFixed(2) }}</strong>
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Order Notes -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <h2 class="text-xl font-semibold text-gray-900 mb-4">Order Notes (Optional)</h2>
            <textarea
              v-model="form.orderNotes"
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              placeholder="Any special requests or notes for your order..."
            ></textarea>
          </div>

          <!-- Submit Button -->
          <div class="bg-white rounded-lg shadow-md p-6">
            <button
              type="submit"
              :disabled="cartStore.isCheckingOut || isSubmitting"
              class="w-full bg-orange-600 text-white py-3 px-6 rounded-md font-semibold hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-orange-500 focus:ring-offset-2 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
            >
              <span v-if="cartStore.isCheckingOut || isSubmitting" class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Processing Order...
              </span>
              <span v-else>
                Place Order - ${{ orderTotal.toFixed(2) }}
              </span>
            </button>

            <!-- Terms and Conditions -->
            <p class="text-xs text-gray-500 text-center mt-4">
              By placing this order, you agree to our 
              <a href="/terms" class="text-orange-600 hover:text-orange-700">Terms of Service</a> 
              and 
              <a href="/privacy" class="text-orange-600 hover:text-orange-700">Privacy Policy</a>.
            </p>
          </div>
        </form>
      </div>
    </div>

    <!-- Success Modal -->
    <div v-if="showSuccessModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg p-8 max-w-md mx-4">
        <div class="text-center">
          <svg class="w-16 h-16 text-green-600 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <h3 class="text-xl font-semibold text-gray-900 mb-2">Order Placed Successfully!</h3>
          <p class="text-gray-600 mb-4">
            Your order #{{ orderNumber }} has been received and is being prepared.
          </p>
          <p class="text-sm text-gray-500 mb-6">
            You will receive a confirmation email shortly.
          </p>
          <div class="space-y-3">
            <button
              @click="goToOrders"
              class="w-full bg-orange-600 text-white py-2 px-4 rounded-md hover:bg-orange-700 transition-colors"
            >
              View My Orders
            </button>
            <button
              @click="continueShopping"
              class="w-full bg-gray-200 text-gray-800 py-2 px-4 rounded-md hover:bg-gray-300 transition-colors"
            >
              Continue Shopping
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useCartStore } from '../stores/cartStore.js'
import { useAuthStore } from '../stores/authStore.js'

// Stores
const cartStore = useCartStore()
const authStore = useAuthStore()

// Form state
const form = ref({
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  address: '',
  city: '',
  state: '',
  zipCode: '',
  deliveryInstructions: '',
  paymentMethod: 'card',
  cardNumber: '',
  expiryDate: '',
  cvv: '',
  cardName: '',
  orderNotes: ''
})

// Component state
const isSubmitting = ref(false)
const showSuccessModal = ref(false)
const orderNumber = ref('')

// Computed values
const tax = computed(() => cartStore.totalPrice * 0.085) // 8.5% tax
const deliveryFee = computed(() => 5.99) // Fixed delivery fee
const orderTotal = computed(() => cartStore.totalPrice + tax.value + deliveryFee.value)

// Initialize form with user data
onMounted(async () => {
  await authStore.initializeAuth()
  await cartStore.initializeCart()
  
  if (authStore.user) {
    form.value.email = authStore.user.email || ''
    // You could also load saved address info from user profile
  }
})

// Form formatting functions
const formatCardNumber = (event) => {
  let value = event.target.value.replace(/\s/g, '').replace(/[^0-9]/gi, '')
  let formattedValue = value.match(/.{1,4}/g)?.join(' ') || value
  form.value.cardNumber = formattedValue
}

const formatExpiryDate = (event) => {
  let value = event.target.value.replace(/\D/g, '')
  if (value.length >= 2) {
    value = value.substring(0, 2) + '/' + value.substring(2, 4)
  }
  form.value.expiryDate = value
}

// Form validation
const validateForm = () => {
  const errors = []
  
  if (!form.value.firstName.trim()) errors.push('First name is required')
  if (!form.value.lastName.trim()) errors.push('Last name is required')
  if (!form.value.email.trim()) errors.push('Email is required')
  if (!form.value.phone.trim()) errors.push('Phone number is required')
  if (!form.value.address.trim()) errors.push('Address is required')
  if (!form.value.city.trim()) errors.push('City is required')
  if (!form.value.state.trim()) errors.push('State is required')
  if (!form.value.zipCode.trim()) errors.push('ZIP code is required')
  
  if (form.value.paymentMethod === 'card') {
    if (!form.value.cardNumber.trim()) errors.push('Card number is required')
    if (!form.value.expiryDate.trim()) errors.push('Expiry date is required')
    if (!form.value.cvv.trim()) errors.push('CVV is required')
    if (!form.value.cardName.trim()) errors.push('Name on card is required')
  }
  
  return errors
}

// Submit handler
const handleSubmit = async () => {
  try {
    isSubmitting.value = true
    
    // Validate form
    const errors = validateForm()
    if (errors.length > 0) {
      alert('Please fix the following errors:\n' + errors.join('\n'))
      return
    }
    
    // Prepare order data
    const orderData = {
      customer: {
        firstName: form.value.firstName,
        lastName: form.value.lastName,
        email: form.value.email,
        phone: form.value.phone
      },
      delivery: {
        address: form.value.address,
        city: form.value.city,
        state: form.value.state,
        zipCode: form.value.zipCode,
        instructions: form.value.deliveryInstructions
      },
      payment: {
        method: form.value.paymentMethod,
        ...(form.value.paymentMethod === 'card' && {
          cardLast4: form.value.cardNumber.slice(-4),
          cardName: form.value.cardName
        })
      },
      totals: {
        subtotal: cartStore.totalPrice,
        tax: tax.value,
        deliveryFee: deliveryFee.value,
        total: orderTotal.value
      },
      notes: form.value.orderNotes
    }
    
    // Place order
    const order = await cartStore.checkout(orderData)
    
    // Show success modal
    orderNumber.value = order.id.slice(0, 8).toUpperCase()
    showSuccessModal.value = true
    
    console.log('✅ Order placed successfully:', order)
    
  } catch (error) {
    console.error('❌ Order placement failed:', error)
    alert('Failed to place order. Please try again.')
  } finally {
    isSubmitting.value = false
  }
}

// Success modal actions
const goToOrders = () => {
  window.location.href = '/orders'
}

const continueShopping = () => {
  window.location.href = '/products'
}
</script> 