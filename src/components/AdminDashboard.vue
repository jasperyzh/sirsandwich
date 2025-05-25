<template>
  <div class="space-y-8">
    <!-- Stats Overview -->
    <section class="grid md:grid-cols-4 gap-6">
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Total Products</h3>
        <p class="text-3xl font-bold text-blue-600">{{ productsStore.totalProducts }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Cart Items</h3>
        <p class="text-3xl font-bold text-green-600">{{ cartStore.itemCount }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Cart Value</h3>
        <p class="text-3xl font-bold text-purple-600">${{ cartStore.totalPrice.toFixed(2) }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Categories</h3>
        <p class="text-3xl font-bold text-orange-600">{{ productsStore.categories.length - 1 }}</p>
      </div>
    </section>

    <!-- Action Buttons -->
    <section class="flex flex-wrap gap-4 justify-center">
      <button
        @click="showAddForm = true"
        class="bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        ➕ Add New Product
      </button>
      <button
        @click="resetDemo"
        class="bg-orange-500 hover:bg-orange-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        🔄 Reset Demo Data
      </button>
      <button
        @click="cartStore.clearCart()"
        class="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        🧹 Clear Cart
      </button>
    </section>

    <!-- Add Product Form -->
    <section v-if="showAddForm" class="bg-white p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">Add New Product</h3>
      <form @submit.prevent="addProduct" class="grid md:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Product Name *</label>
          <input
            v-model="newProduct.name"
            type="text"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            placeholder="e.g., Spicy Turkey Club"
          >
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Price *</label>
          <input
            v-model.number="newProduct.price"
            type="number"
            step="0.01"
            min="0"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            placeholder="12.99"
          >
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Category *</label>
          <select
            v-model="newProduct.category"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Select category</option>
            <option v-for="cat in availableCategories" :key="cat" :value="cat">{{ cat }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Emoji Icon</label>
          <input
            v-model="newProduct.image"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            placeholder="🥪"
          >
        </div>
        <div class="md:col-span-2">
          <label class="block text-sm font-medium text-gray-700 mb-2">Description *</label>
          <textarea
            v-model="newProduct.description"
            required
            rows="3"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            placeholder="Describe the sandwich ingredients and preparation..."
          ></textarea>
        </div>
        <div class="md:col-span-2 flex space-x-4">
          <button
            type="submit"
            class="bg-green-500 hover:bg-green-600 text-white px-6 py-2 rounded-lg transition duration-300"
          >
            Add Product
          </button>
          <button
            type="button"
            @click="cancelAdd"
            class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg transition duration-300"
          >
            Cancel
          </button>
        </div>
      </form>
    </section>

    <!-- Products Management -->
    <section class="bg-white p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">Manage Products</h3>
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-2 text-left">Product</th>
              <th class="px-4 py-2 text-left">Category</th>
              <th class="px-4 py-2 text-left">Price</th>
              <th class="px-4 py-2 text-left">Stock</th>
              <th class="px-4 py-2 text-left">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in productsStore.products" :key="product.id" class="border-t">
              <td class="px-4 py-3">
                <div class="flex items-center space-x-3">
                  <span class="text-2xl">{{ product.image }}</span>
                  <div>
                    <p class="font-medium">{{ product.name }}</p>
                    <p class="text-gray-500 text-xs">{{ product.description.substring(0, 50) }}...</p>
                  </div>
                </div>
              </td>
              <td class="px-4 py-3">
                <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">
                  {{ product.category }}
                </span>
              </td>
              <td class="px-4 py-3 font-semibold text-green-600">${{ product.price.toFixed(2) }}</td>
              <td class="px-4 py-3">
                <input
                  :value="product.stock"
                  @change="updateStock(product.id, $event.target.value)"
                  type="number"
                  min="0"
                  class="w-16 px-2 py-1 border border-gray-300 rounded text-center"
                >
              </td>
              <td class="px-4 py-3">
                <div class="flex space-x-2">
                  <button
                    @click="editProduct(product)"
                    class="text-blue-600 hover:text-blue-800 text-sm"
                  >
                    ✏️ Edit
                  </button>
                  <button
                    @click="deleteProduct(product.id)"
                    class="text-red-600 hover:text-red-800 text-sm"
                  >
                    🗑️ Delete
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Edit Product Modal -->
    <div v-if="editingProduct" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white p-6 rounded-lg shadow-xl max-w-md w-full mx-4">
        <h3 class="text-xl font-semibold text-gray-800 mb-4">Edit Product</h3>
        <form @submit.prevent="updateProduct" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Product Name</label>
            <input
              v-model="editingProduct.name"
              type="text"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Price</label>
            <input
              v-model.number="editingProduct.price"
              type="number"
              step="0.01"
              min="0"
              required
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            >
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
            <textarea
              v-model="editingProduct.description"
              required
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            ></textarea>
          </div>
          <div class="flex space-x-4">
            <button
              type="submit"
              class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg transition duration-300"
            >
              Update
            </button>
            <button
              type="button"
              @click="cancelEdit"
              class="bg-gray-500 hover:bg-gray-600 text-white px-4 py-2 rounded-lg transition duration-300"
            >
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, createApp } from 'vue'
import { useProductsStore } from '../stores/productsStore.js'
import { useCartStore } from '../stores/cartStore.js'
import { pinia } from '../stores/pinia.js'

// Initialize Pinia and use stores
const app = createApp({})
app.use(pinia)
const productsStore = useProductsStore()
const cartStore = useCartStore()

// Reactive state
const showAddForm = ref(false)
const editingProduct = ref(null)

const newProduct = reactive({
  name: '',
  description: '',
  price: 0,
  image: '🥪',
  category: ''
})

// Computed properties
const availableCategories = computed(() => 
  productsStore.categories.filter(cat => cat !== 'All')
)

// Methods
const addProduct = () => {
  console.log('➕ Adding new product:', newProduct.name)
  
  const productData = {
    name: newProduct.name,
    description: newProduct.description,
    price: newProduct.price,
    image: newProduct.image || '🥪',
    category: newProduct.category,
    specs: {
      calories: Math.floor(Math.random() * 400) + 300, // Random calories 300-700
      allergens: ['gluten'], // Default allergen
      prepTime: '5-8 minutes'
    }
  }
  
  const result = productsStore.addProduct(productData)
  if (result) {
    console.log('✅ Product added successfully')
    cancelAdd()
  }
}

const cancelAdd = () => {
  showAddForm.value = false
  Object.keys(newProduct).forEach(key => {
    newProduct[key] = key === 'image' ? '🥪' : key === 'price' ? 0 : ''
  })
}

const editProduct = (product) => {
  console.log('✏️ Editing product:', product.name)
  editingProduct.value = { ...product }
}

const updateProduct = () => {
  console.log('💾 Updating product:', editingProduct.value.name)
  const success = productsStore.updateProduct(editingProduct.value.id, editingProduct.value)
  if (success) {
    console.log('✅ Product updated successfully')
    cancelEdit()
  }
}

const cancelEdit = () => {
  editingProduct.value = null
}

const updateStock = (productId, newStock) => {
  console.log('📦 Updating stock for product', productId, 'to:', newStock)
  productsStore.updateStock(productId, parseInt(newStock))
}

const deleteProduct = (productId) => {
  console.log('🗑️ Deleting product:', productId)
  if (confirm('Are you sure you want to delete this product?')) {
    const deleted = productsStore.deleteProduct(productId)
    if (deleted) {
      console.log('✅ Product deleted successfully')
    }
  }
}

const resetDemo = () => {
  console.log('🔄 Resetting demo data')
  if (confirm('This will reset all products to the original demo data. Continue?')) {
    // Clear localStorage and reload original data
    localStorage.removeItem('sirsandwich-products')
    localStorage.removeItem('sirsandwich-cart')
    
    // Reload the page to get fresh demo data
    window.location.reload()
  }
}
</script>

<style scoped>
/* Component-specific styles */
table {
  border-collapse: collapse;
}

/* Modal backdrop animation */
.fixed {
  animation: fadeIn 0.2s ease-out;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
</style> 