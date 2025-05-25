<template>
  <section class="mb-8">
    <div class="flex flex-wrap justify-center gap-4">
      <button
        v-for="category in categories"
        :key="category"
        @click="selectCategory(category)"
        :class="[
          'px-4 py-2 border rounded-lg transition duration-300 font-medium transform',
          selectedCategory === category
            ? 'bg-blue-500 text-white border-blue-500 shadow-md scale-105'
            : 'bg-white text-gray-700 border-gray-300 hover:bg-gray-50 hover:border-gray-400'
        ]"
      >
        {{ category }}
        <span 
          v-if="category !== 'All'" 
          class="ml-2 text-xs opacity-75"
        >
          ({{ getCategoryCount(category) }})
        </span>
      </button>
    </div>
    
    <!-- Active Filter Display -->
    <div class="text-center mt-4">
      <p class="text-sm text-gray-600">
        <span v-if="selectedCategory === 'All'">
          Showing all {{ totalProducts }} sandwiches
        </span>
        <span v-else>
          Showing {{ filteredCount }} {{ selectedCategory.toLowerCase() }} sandwiches
        </span>
      </p>
      
      <!-- Clear Filter Button -->
      <button
        v-if="selectedCategory !== 'All'"
        @click="clearFilter"
        class="mt-2 text-sm text-blue-600 hover:text-blue-800 underline transition duration-200"
      >
        Clear filter
      </button>
    </div>
    
    <!-- Phase 3 Notice -->
    <div class="text-center mt-6 bg-yellow-50 rounded-lg p-4 max-w-2xl mx-auto">
      <p class="text-sm text-yellow-800">
        <strong>💡 Phase 2 Demo:</strong> This filter shows visual feedback but doesn't actually filter products yet. 
        <br>Full filtering functionality coming in Phase 3!
      </p>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, defineProps, defineEmits } from 'vue'

// Props
const props = defineProps({
  categories: {
    type: Array,
    required: true,
    default: () => []
  },
  products: {
    type: Array,
    required: true,
    default: () => []
  }
})

// Emits
const emit = defineEmits(['category-changed'])

// Reactive state
const selectedCategory = ref('All')

// Computed properties
const totalProducts = computed(() => props.products.length)

const filteredCount = computed(() => {
  if (selectedCategory.value === 'All') {
    return totalProducts.value
  }
  return props.products.filter(product => 
    product.category === selectedCategory.value
  ).length
})

// Methods
const getCategoryCount = (category) => {
  if (category === 'All') {
    return totalProducts.value
  }
  return props.products.filter(product => product.category === category).length
}

const selectCategory = (category) => {
  console.log('🏷️ Category selected:', category)
  selectedCategory.value = category
  
  // Emit event to parent (for future implementation)
  emit('category-changed', {
    category,
    filteredProducts: getFilteredProducts(category)
  })
  
  // Visual feedback
  console.log(`✅ Now showing ${filteredCount.value} products in "${category}" category`)
}

const clearFilter = () => {
  selectCategory('All')
}

const getFilteredProducts = (category) => {
  if (category === 'All') {
    return props.products
  }
  return props.products.filter(product => product.category === category)
}

// Initialize with 'All' category
selectCategory('All')
</script>

<style scoped>
/* Component-specific styles */
/* Most styling handled by Tailwind CSS */
</style> 