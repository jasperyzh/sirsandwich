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
    
    <!-- Phase 3 Implementation -->
    <div class="text-center mt-6 bg-green-50 rounded-lg p-4 max-w-2xl mx-auto">
      <p class="text-sm text-green-800">
        <strong>✅ Phase 3 Complete:</strong> This filter now uses Pinia state management and actually filters the products below!
      </p>
    </div>
  </section>
</template>

<script setup>
import { computed, createApp } from 'vue'
import { useProductsStore } from '../stores/productsStore.js'
import { pinia } from '../stores/pinia.js'

// Initialize Pinia and use the products store
const app = createApp({})
app.use(pinia)
const productsStore = useProductsStore()

// Computed properties from the store
const categories = computed(() => productsStore.categories)
const selectedCategory = computed(() => productsStore.selectedCategory)
const totalProducts = computed(() => productsStore.totalProducts)
const filteredCount = computed(() => productsStore.filteredProducts.length)

// Methods
const getCategoryCount = (category) => {
  return productsStore.categoryCount[category] || 0
}

const selectCategory = (category) => {
  console.log('🏷️ Category selected:', category)
  productsStore.setCategory(category)
  console.log(`✅ Now showing ${filteredCount.value} products in "${category}" category`)
}

const clearFilter = () => {
  selectCategory('All')
}
</script>

<style scoped>
/* Component-specific styles */
/* Most styling handled by Tailwind CSS */
</style> 