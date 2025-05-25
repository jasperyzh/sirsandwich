import { createPinia } from 'pinia'

// Create the main Pinia instance
export const pinia = createPinia()

// Export for use in components
export { useCartStore } from './cartStore.js'
export { useProductsStore } from './productsStore.js'
export { useAuthStore } from './authStore.js' 