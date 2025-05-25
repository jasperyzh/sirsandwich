<template>
  <div class="relative mb-6">
    <div class="relative">
      <input
        v-model="searchQuery"
        @input="handleSearch"
        type="text"
        placeholder="Search sandwiches by name, description, or category..."
        class="w-full px-4 py-3 pl-12 pr-10 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-300"
      >
      <!-- Search Icon -->
      <div class="absolute left-4 top-1/2 transform -translate-y-1/2 text-gray-400">
        🔍
      </div>
      <!-- Clear Button -->
      <button
        v-if="searchQuery"
        @click="clearSearch"
        class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600 text-xl"
      >
        ×
      </button>
    </div>
    
    <!-- Search Results Summary -->
    <div v-if="searchQuery" class="mt-2 text-sm text-gray-600 text-center">
      <span v-if="resultsCount > 0">
        Found {{ resultsCount }} sandwich{{ resultsCount !== 1 ? 'es' : '' }} matching "{{ searchQuery }}"
      </span>
      <span v-else class="text-orange-600">
        No sandwiches found matching "{{ searchQuery }}" - try a different search term
      </span>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, createApp } from 'vue'
import { useProductsStore } from '../stores/productsStore.js'
import { pinia } from '../stores/pinia.js'

// Initialize Pinia and use the products store
const app = createApp({})
app.use(pinia)
const productsStore = useProductsStore()

// Local reactive state for input
const searchQuery = ref(productsStore.searchQuery)

// Computed properties
const resultsCount = computed(() => productsStore.filteredProducts.length)

// Methods
const handleSearch = () => {
  console.log('🔍 Searching for:', searchQuery.value)
  productsStore.setSearchQuery(searchQuery.value)
}

const clearSearch = () => {
  console.log('🧹 Clearing search')
  searchQuery.value = ''
  productsStore.setSearchQuery('')
}
</script>

<style scoped>
/* Custom styles for the search input */
input::placeholder {
  color: #9CA3AF;
}
</style> 