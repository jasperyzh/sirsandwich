<template>
  <div class="grid md:grid-cols-2 lg:grid-cols-3 gap-8 mb-12">
    <ProductCard
      v-for="product in filteredProducts"
      :key="product.id"
      :product="product"
    />
  </div>
  
  <!-- No Results Message -->
  <div v-if="filteredProducts.length === 0" class="text-center py-12">
    <div class="text-6xl mb-4">🔍</div>
    <h3 class="text-xl font-semibold text-gray-700 mb-2">No sandwiches found</h3>
    <p class="text-gray-500 mb-4">
      <span v-if="productsStore.searchQuery">
        No results match your search for "{{ productsStore.searchQuery }}"
      </span>
      <span v-else-if="productsStore.selectedCategory !== 'All'">
        No sandwiches found in the {{ productsStore.selectedCategory }} category
      </span>
      <span v-else>
        No products available at the moment
      </span>
    </p>
    <button
      @click="clearFilters"
      class="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg transition duration-300"
    >
      Clear Filters
    </button>
  </div>
</template>

<script setup>
import { computed, createApp } from 'vue'
import { useProductsStore } from '../stores/productsStore.js'
import { pinia } from '../stores/pinia.js'
import ProductCard from './ProductCard.vue'

// Initialize Pinia and use the products store
const app = createApp({})
app.use(pinia)
const productsStore = useProductsStore()

// Computed properties
const filteredProducts = computed(() => productsStore.filteredProducts)

// Methods
const clearFilters = () => {
  productsStore.clearFilters()
}
</script>

<style scoped>
/* Component styles handled by Tailwind */
</style> 