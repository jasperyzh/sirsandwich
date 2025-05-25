<template>
  <div class="space-y-8">
    <!-- Loading State -->
    <div v-if="loading" class="text-center py-8">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
      <p class="mt-4 text-gray-600">Loading admin dashboard...</p>
    </div>

    <!-- Error State -->
    <div v-if="error" class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
      <strong>Error:</strong> {{ error }}
      <button @click="loadData" class="ml-4 text-red-500 hover:text-red-700">
        🔄 Retry
      </button>
    </div>

    <!-- Stats Overview -->
    <section v-if="!loading" class="grid md:grid-cols-5 gap-6">
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Total Products</h3>
        <p class="text-3xl font-bold text-blue-600">{{ products.length }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Categories</h3>
        <p class="text-3xl font-bold text-green-600">{{ categories.length }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Active Products</h3>
        <p class="text-3xl font-bold text-purple-600">{{ activeProducts }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Total Orders</h3>
        <p class="text-3xl font-bold text-orange-600">{{ orders.length }}</p>
      </div>
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h3 class="text-sm font-medium text-gray-500 mb-2">Contact Messages</h3>
        <p class="text-3xl font-bold text-red-600">{{ newContactMessages }}</p>
        <p class="text-xs text-gray-500 mt-1">{{ contactMessages.length }} total</p>
      </div>
    </section>

    <!-- Action Buttons -->
    <section v-if="!loading" class="flex flex-wrap gap-4 justify-center">
      <button
        @click="showAddForm = true"
        class="bg-green-500 hover:bg-green-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        ➕ Add New Product
      </button>
      <button
        @click="loadData"
        class="bg-blue-500 hover:bg-blue-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        🔄 Refresh Data
      </button>
      <button
        @click="showOrders = !showOrders"
        class="bg-purple-500 hover:bg-purple-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        📋 {{ showOrders ? 'Hide' : 'Show' }} Orders
      </button>
      <button
        @click="showContactMessages = !showContactMessages"
        class="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300"
      >
        📧 {{ showContactMessages ? 'Hide' : 'Show' }} Messages
      </button>
    </section>

    <!-- Add/Edit Product Form -->
    <section v-if="showAddForm" class="bg-white p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">
        {{ newProduct.id ? 'Edit Product' : 'Add New Product' }}
      </h3>
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
            v-model="newProduct.category_id"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          >
            <option value="">Select category</option>
            <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
          </select>
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Stock Quantity</label>
          <input
            v-model.number="newProduct.stock_quantity"
            type="number"
            min="0"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            placeholder="50"
          >
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Image URL/Emoji</label>
          <input
            v-model="newProduct.image_url"
            type="text"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
            placeholder="🥪 or https://..."
          >
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-2">Active</label>
          <select
            v-model="newProduct.is_active"
            class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
          >
            <option :value="true">Active</option>
            <option :value="false">Inactive</option>
          </select>
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
            :disabled="submitting"
            class="bg-green-500 hover:bg-green-600 disabled:bg-gray-400 text-white px-6 py-2 rounded-lg transition duration-300"
          >
            {{ submitting ? (newProduct.id ? 'Updating...' : 'Adding...') : (newProduct.id ? 'Update Product' : 'Add Product') }}
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
    <section v-if="!loading" class="bg-white p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">Manage Products</h3>
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-2 text-left">Product</th>
              <th class="px-4 py-2 text-left">Category</th>
              <th class="px-4 py-2 text-left">Price</th>
              <th class="px-4 py-2 text-left">Stock</th>
              <th class="px-4 py-2 text-left">Status</th>
              <th class="px-4 py-2 text-left">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in products" :key="product.id" class="border-t">
              <td class="px-4 py-3">
                <div class="flex items-center space-x-3">
                  <span class="text-2xl">{{ product.image_url || '🥪' }}</span>
                  <div>
                    <p class="font-medium">{{ product.name }}</p>
                    <p class="text-gray-500 text-xs">{{ product.description.substring(0, 50) }}...</p>
                  </div>
                </div>
              </td>
              <td class="px-4 py-3">
                <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">
                  {{ getCategoryName(product.category_id) }}
                </span>
              </td>
              <td class="px-4 py-3 font-semibold text-green-600">${{ product.price }}</td>
              <td class="px-4 py-3">
                <input
                  :value="product.stock_quantity"
                  @change="updateStock(product.id, $event.target.value)"
                  type="number"
                  min="0"
                  class="w-16 px-2 py-1 border border-gray-300 rounded text-center"
                >
              </td>
              <td class="px-4 py-3">
                <span :class="[
                  'text-xs px-2 py-1 rounded-full',
                  product.is_active ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                ]">
                  {{ product.is_active ? 'Active' : 'Inactive' }}
                </span>
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
                    @click="toggleProductStatus(product)"
                    class="text-yellow-600 hover:text-yellow-800 text-sm"
                  >
                    {{ product.is_active ? '⏸️ Disable' : '▶️ Enable' }}
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

    <!-- Orders Management -->
    <section v-if="showOrders && !loading" class="bg-white p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">Recent Orders</h3>
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-2 text-left">Order ID</th>
              <th class="px-4 py-2 text-left">Customer</th>
              <th class="px-4 py-2 text-left">Total</th>
              <th class="px-4 py-2 text-left">Status</th>
              <th class="px-4 py-2 text-left">Date</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="order in orders" :key="order.id" class="border-t">
              <td class="px-4 py-3 font-mono text-xs">#{{ order.id }}</td>
              <td class="px-4 py-3">{{ order.customer_name || order.customer_email }}</td>
              <td class="px-4 py-3 font-semibold text-green-600">${{ order.total_amount }}</td>
              <td class="px-4 py-3">
                <span :class="getOrderStatusClass(order.status)">
                  {{ order.status }}
                </span>
              </td>
              <td class="px-4 py-3 text-gray-500">{{ formatDate(order.created_at) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Contact Messages Management -->
    <section v-if="showContactMessages && !loading" class="bg-white p-6 rounded-lg shadow-md">
      <h3 class="text-xl font-semibold text-gray-800 mb-4">Contact Messages</h3>
      <div class="overflow-x-auto">
        <table class="w-full text-sm">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-4 py-2 text-left">From</th>
              <th class="px-4 py-2 text-left">Subject</th>
              <th class="px-4 py-2 text-left">Message</th>
              <th class="px-4 py-2 text-left">Status</th>
              <th class="px-4 py-2 text-left">Date</th>
              <th class="px-4 py-2 text-left">Actions</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="message in contactMessages" :key="message.id" class="border-t">
              <td class="px-4 py-3">
                <div>
                  <p class="font-medium">{{ message.name }}</p>
                  <p class="text-gray-500 text-xs">{{ message.email }}</p>
                  <p v-if="message.phone" class="text-gray-500 text-xs">{{ message.phone }}</p>
                </div>
              </td>
              <td class="px-4 py-3">
                <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">
                  {{ message.subject }}
                </span>
              </td>
              <td class="px-4 py-3 max-w-xs">
                <p class="text-gray-700 text-sm truncate">{{ message.message }}</p>
              </td>
              <td class="px-4 py-3">
                <select
                  :value="message.status"
                  @change="updateMessageStatus(message.id, $event.target.value)"
                  :class="getMessageStatusClass(message.status)"
                  class="text-xs px-2 py-1 rounded-full border-0"
                >
                  <option value="new">New</option>
                  <option value="read">Read</option>
                  <option value="replied">Replied</option>
                  <option value="resolved">Resolved</option>
                </select>
              </td>
              <td class="px-4 py-3 text-gray-500">{{ formatDate(message.created_at) }}</td>
              <td class="px-4 py-3">
                <div class="flex space-x-2">
                  <button
                    @click="viewMessage(message)"
                    class="text-blue-600 hover:text-blue-800 text-sm"
                  >
                    👁️ View
                  </button>
                  <button
                    @click="replyToMessage(message)"
                    class="text-green-600 hover:text-green-800 text-sm"
                  >
                    ↩️ Reply
                  </button>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Success Message -->
    <div v-if="successMessage" class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded">
      {{ successMessage }}
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, createApp } from 'vue'
import { supabase } from '../lib/supabase.js'
import { useAuthStore } from '../stores/authStore.js'
import { pinia } from '../stores/pinia.js'

// Initialize Pinia and auth store
const app = createApp({})
app.use(pinia)
const authStore = useAuthStore()

// Component state
const loading = ref(true)
const error = ref(null)
const successMessage = ref('')
const submitting = ref(false)
const showAddForm = ref(false)
const showOrders = ref(false)
const showContactMessages = ref(false)

// Data
const products = ref([])
const categories = ref([])
const orders = ref([])
const contactMessages = ref([])

// Form data
const newProduct = reactive({
  name: '',
  description: '',
  price: 0,
  image_url: '',
  stock_quantity: 0,
  category_id: '',
  is_active: true,
  id: null
})

// Computed
const activeProducts = computed(() => products.value.filter(p => p.is_active).length)
const newContactMessages = computed(() => contactMessages.value.filter(m => m.status === 'new').length)

// Methods
const loadData = async () => {
  loading.value = true
  error.value = null
  
  try {
    // Load categories
    const { data: categoriesData, error: categoriesError } = await supabase
      .from('categories')
      .select('*')
      .order('name')
    
    if (categoriesError) throw categoriesError
    categories.value = categoriesData || []

    // Load products with category info
    const { data: productsData, error: productsError } = await supabase
      .from('products')
      .select(`
        *,
        categories (
          id,
          name
        )
      `)
      .order('created_at', { ascending: false })
    
    if (productsError) throw productsError
    products.value = productsData || []

    // Load recent orders
    const { data: ordersData, error: ordersError } = await supabase
      .from('orders')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(10)
    
    if (ordersError) throw ordersError
    orders.value = ordersData || []

    // Load contact messages
    const { data: contactData, error: contactError } = await supabase
      .from('contact_messages')
      .select('*')
      .order('created_at', { ascending: false })
      .limit(20)
    
    if (contactError) throw contactError
    contactMessages.value = contactData || []

    console.log('✅ Admin data loaded:', {
      products: products.value.length,
      categories: categories.value.length,
      orders: orders.value.length,
      contactMessages: contactMessages.value.length
    })

  } catch (err) {
    console.error('❌ Error loading admin data:', err)
    error.value = err.message
  } finally {
    loading.value = false
  }
}

const addProduct = async () => {
  submitting.value = true
  error.value = null
  
  try {
    const productData = {
      name: newProduct.name,
      description: newProduct.description,
      price: newProduct.price,
      image_url: newProduct.image_url,
      stock_quantity: newProduct.stock_quantity,
      category_id: newProduct.category_id,
      is_active: newProduct.is_active
    }

    let data, operationError
    
    if (newProduct.id) {
      // Update existing product
      const result = await supabase
        .from('products')
        .update(productData)
        .eq('id', newProduct.id)
        .select()
      
      data = result.data
      operationError = result.error
      
      console.log('✅ Product updated:', data)
      successMessage.value = `Product "${newProduct.name}" updated successfully!`
    } else {
      // Insert new product
      const result = await supabase
        .from('products')
        .insert([productData])
        .select()
      
      data = result.data
      operationError = result.error
      
      console.log('✅ Product added:', data)
      successMessage.value = `Product "${newProduct.name}" added successfully!`
    }
    
    if (operationError) throw operationError
    
    // Reset form and reload data
    cancelAdd()
    await loadData()
    
    // Clear success message after 3 seconds
    setTimeout(() => {
      successMessage.value = ''
    }, 3000)

  } catch (err) {
    console.error('❌ Error saving product:', err)
    error.value = err.message
  } finally {
    submitting.value = false
  }
}

const updateStock = async (productId, newStock) => {
  try {
    const { error: updateError } = await supabase
      .from('products')
      .update({ stock_quantity: parseInt(newStock) })
      .eq('id', productId)
    
    if (updateError) throw updateError
    
    console.log('✅ Stock updated for product:', productId)
    successMessage.value = 'Stock updated successfully!'
    
    // Update local data
    const product = products.value.find(p => p.id === productId)
    if (product) {
      product.stock_quantity = parseInt(newStock)
    }
    
    setTimeout(() => {
      successMessage.value = ''
    }, 2000)

  } catch (err) {
    console.error('❌ Error updating stock:', err)
    error.value = err.message
  }
}

const toggleProductStatus = async (product) => {
  try {
    const { error: updateError } = await supabase
      .from('products')
      .update({ is_active: !product.is_active })
      .eq('id', product.id)
    
    if (updateError) throw updateError
    
    console.log('✅ Product status toggled:', product.id)
    successMessage.value = `Product ${product.is_active ? 'disabled' : 'enabled'} successfully!`
    
    // Update local data
    product.is_active = !product.is_active
    
    setTimeout(() => {
      successMessage.value = ''
    }, 2000)

  } catch (err) {
    console.error('❌ Error toggling product status:', err)
    error.value = err.message
  }
}

const editProduct = (product) => {
  // For now, we'll populate the add form with the product data for editing
  // In a full implementation, you'd have a separate edit modal
  Object.assign(newProduct, {
    name: product.name,
    description: product.description,
    price: product.price,
    image_url: product.image_url,
    stock_quantity: product.stock_quantity,
    category_id: product.category_id,
    is_active: product.is_active
  })
  
  // Store the product ID for updating instead of creating
  newProduct.id = product.id
  showAddForm.value = true
  
  console.log('✏️ Editing product:', product.name)
}

const deleteProduct = async (productId) => {
  if (!confirm('Are you sure you want to delete this product?')) return
  
  try {
    const { error: deleteError } = await supabase
      .from('products')
      .delete()
      .eq('id', productId)
    
    if (deleteError) throw deleteError
    
    console.log('✅ Product deleted:', productId)
    successMessage.value = 'Product deleted successfully!'
    
    // Remove from local data
    products.value = products.value.filter(p => p.id !== productId)
    
    setTimeout(() => {
      successMessage.value = ''
    }, 2000)

  } catch (err) {
    console.error('❌ Error deleting product:', err)
    error.value = err.message
  }
}

const cancelAdd = () => {
  showAddForm.value = false
  // Reset form
  Object.assign(newProduct, {
    name: '',
    description: '',
    price: 0,
    image_url: '',
    stock_quantity: 0,
    category_id: '',
    is_active: true,
    id: null // Clear the ID for editing
  })
}

const getCategoryName = (categoryId) => {
  const category = categories.value.find(c => c.id === categoryId)
  return category ? category.name : 'Unknown'
}

const getOrderStatusClass = (status) => {
  const classes = {
    pending: 'bg-yellow-100 text-yellow-800',
    confirmed: 'bg-blue-100 text-blue-800',
    preparing: 'bg-orange-100 text-orange-800',
    ready: 'bg-green-100 text-green-800',
    delivered: 'bg-gray-100 text-gray-800',
    cancelled: 'bg-red-100 text-red-800'
  }
  return `text-xs px-2 py-1 rounded-full ${classes[status] || 'bg-gray-100 text-gray-800'}`
}

const formatDate = (dateString) => {
  return new Date(dateString).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// Contact message functions
const updateMessageStatus = async (messageId, newStatus) => {
  try {
    const { error: updateError } = await supabase
      .from('contact_messages')
      .update({ status: newStatus })
      .eq('id', messageId)
    
    if (updateError) throw updateError
    
    console.log('✅ Message status updated:', messageId, newStatus)
    successMessage.value = `Message status updated to ${newStatus}!`
    
    // Update local data
    const message = contactMessages.value.find(m => m.id === messageId)
    if (message) {
      message.status = newStatus
    }
    
    setTimeout(() => {
      successMessage.value = ''
    }, 2000)

  } catch (err) {
    console.error('❌ Error updating message status:', err)
    error.value = err.message
  }
}

const viewMessage = (message) => {
  // For now, just show an alert with the full message
  // In a full implementation, you'd open a modal
  alert(`From: ${message.name} (${message.email})\nSubject: ${message.subject}\n\nMessage:\n${message.message}`)
  
  // Mark as read if it's new
  if (message.status === 'new') {
    updateMessageStatus(message.id, 'read')
  }
}

const replyToMessage = (message) => {
  // For now, just open the user's email client
  // In a full implementation, you'd have an integrated email system
  const subject = `Re: ${message.subject}`
  const body = `Hi ${message.name},\n\nThank you for contacting Sirsandwich Shop.\n\n---\nOriginal message:\n${message.message}`
  
  const mailtoLink = `mailto:${message.email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`
  window.open(mailtoLink)
  
  // Mark as replied
  updateMessageStatus(message.id, 'replied')
}

const getMessageStatusClass = (status) => {
  const classes = {
    new: 'bg-red-100 text-red-800',
    read: 'bg-yellow-100 text-yellow-800',
    replied: 'bg-blue-100 text-blue-800',
    resolved: 'bg-green-100 text-green-800'
  }
  return classes[status] || 'bg-gray-100 text-gray-800'
}

// Initialize
onMounted(async () => {
  await authStore.initialize()
  await loadData()
})
</script>

<style scoped>
/* Component-specific styles */
.animate-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}
</style> 