<template>
  <div class="bg-white rounded-lg shadow-md overflow-hidden hover:shadow-lg transition duration-300">
    <!-- Product Image Placeholder -->
    <div class="bg-gray-200 h-48 flex items-center justify-center text-6xl">
      {{ product.image }}
    </div>
    
    <!-- Product Info -->
    <div class="p-6">
      <div class="flex justify-between items-start mb-2">
        <h3 class="text-xl font-semibold text-gray-800">{{ product.name }}</h3>
        <span class="text-sm bg-blue-100 text-blue-800 px-2 py-1 rounded-full">
          {{ product.category }}
        </span>
      </div>
      
      <!-- Short description or full description based on toggle -->
      <p class="text-gray-600 mb-4 text-sm leading-relaxed">
        {{ showDetails ? product.description : truncatedDescription }}
        <button 
          v-if="product.description.length > 60"
          @click="toggleDetails"
          class="text-blue-500 hover:text-blue-700 ml-1 font-medium"
        >
          {{ showDetails ? 'Show less' : 'Read more' }}
        </button>
      </p>
      
      <!-- Additional details when expanded -->
      <div v-if="showDetails && product.specs" class="mb-4 p-3 bg-gray-50 rounded-lg">
        <h4 class="font-semibold text-gray-700 mb-2">Details:</h4>
        <ul class="text-sm text-gray-600 space-y-1">
          <li v-if="product.specs.calories">🔥 {{ product.specs.calories }} calories</li>
          <li v-if="product.specs.allergens">⚠️ Contains: {{ product.specs.allergens.join(', ') }}</li>
          <li v-if="product.specs.prepTime">⏱️ Prep time: {{ product.specs.prepTime }}</li>
        </ul>
      </div>
      
      <div class="flex justify-between items-center">
        <span class="text-2xl font-bold text-green-600">
          ${{ product.price.toFixed(2) }}
        </span>
        <div class="flex gap-2">
          <button 
            @click="viewDetails"
            class="bg-gray-500 hover:bg-gray-600 text-white px-3 py-2 rounded-lg transition duration-300 text-sm"
          >
            View Details
          </button>
          <button 
            @click="addToCart"
            :disabled="isAddingToCart"
            :class="[
              'px-4 py-2 rounded-lg transition duration-300 transform text-sm font-medium',
              isAddingToCart 
                ? 'bg-green-500 text-white cursor-not-allowed' 
                : 'bg-blue-500 hover:bg-blue-600 text-white hover:scale-105'
            ]"
          >
            {{ buttonText }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, defineProps } from 'vue'

// Props definition
const props = defineProps({
  product: {
    type: Object,
    required: true,
    default: () => ({
      id: 0,
      name: '',
      description: '',
      price: 0,
      image: '🥪',
      category: '',
      specs: {}
    })
  }
})

// Reactive state
const showDetails = ref(false)
const isAddingToCart = ref(false)

// Computed properties
const truncatedDescription = computed(() => {
  return props.product.description.length > 60 
    ? props.product.description.substring(0, 60) + '...'
    : props.product.description
})

const buttonText = computed(() => {
  return isAddingToCart.value ? '✓ Added!' : 'Add to Cart'
})

// Methods
const toggleDetails = () => {
  showDetails.value = !showDetails.value
}

const viewDetails = () => {
  console.log('📋 Viewing details for:', props.product.name)
  // Future: Navigate to detailed product page
  alert(`📋 Product Details\n\n${props.product.name}\n${props.product.description}\n\nPrice: $${props.product.price}`)
}

const addToCart = () => {
  console.log('🛒 Adding to cart:', props.product.name, `$${props.product.price}`)
  
  // Mock adding to cart with visual feedback
  isAddingToCart.value = true
  
  // Simulate async operation
  setTimeout(() => {
    isAddingToCart.value = false
    console.log('✅ Successfully added to cart:', props.product.name)
  }, 1000)
  
  // Future: Add to actual cart state/localStorage
}
</script>

<style scoped>
/* Any component-specific styles can go here */
/* Tailwind classes handle most of our styling */
</style> 