<template>
  <div class="bg-white p-6 rounded-lg shadow-md">
    <!-- Profile Header -->
    <div class="flex items-center justify-between mb-6">
      <div class="flex items-center space-x-4">
        <div class="w-16 h-16 bg-blue-500 rounded-full flex items-center justify-center text-white text-2xl font-bold">
          {{ userInitials }}
        </div>
        <div>
          <h2 class="text-2xl font-bold text-gray-800">{{ authStore.userDisplayName }}</h2>
          <p class="text-gray-600">{{ authStore.user?.email }}</p>
          <span :class="[
            'inline-block px-2 py-1 text-xs font-semibold rounded-full',
            authStore.isAdmin ? 'bg-red-100 text-red-800' : 
            authStore.isStaff ? 'bg-yellow-100 text-yellow-800' : 
            'bg-green-100 text-green-800'
          ]">
            {{ authStore.profile?.role || 'customer' }}
          </span>
        </div>
      </div>
      <button
        @click="signOut"
        class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition duration-300"
      >
        Sign Out
      </button>
    </div>

    <!-- Profile Information -->
    <div class="space-y-6">
      <!-- Edit Profile Form -->
      <div v-if="isEditing" class="border-t pt-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">Edit Profile</h3>
        <form @submit.prevent="updateProfile" class="space-y-4">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
            <input
              v-model="editForm.full_name"
              type="text"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
              placeholder="Enter your full name"
            >
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Phone Number</label>
            <input
              v-model="editForm.phone"
              type="tel"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
              placeholder="Enter your phone number"
            >
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2">Address</label>
            <textarea
              v-model="editForm.address"
              rows="3"
              class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500"
              placeholder="Enter your address"
            ></textarea>
          </div>
          <div class="flex space-x-4">
            <button
              type="submit"
              :disabled="authStore.loading"
              class="bg-blue-500 hover:bg-blue-600 text-white px-6 py-2 rounded-lg transition duration-300"
            >
              {{ authStore.loading ? 'Updating...' : 'Update Profile' }}
            </button>
            <button
              type="button"
              @click="cancelEdit"
              class="bg-gray-500 hover:bg-gray-600 text-white px-6 py-2 rounded-lg transition duration-300"
            >
              Cancel
            </button>
          </div>
        </form>
      </div>

      <!-- Profile Display -->
      <div v-else class="border-t pt-6">
        <div class="flex justify-between items-center mb-4">
          <h3 class="text-lg font-semibold text-gray-800">Profile Information</h3>
          <button
            @click="startEdit"
            class="text-blue-500 hover:text-blue-700 font-semibold"
          >
            ✏️ Edit Profile
          </button>
        </div>
        
        <div class="grid md:grid-cols-2 gap-4">
          <div>
            <label class="block text-sm font-medium text-gray-500">Full Name</label>
            <p class="text-gray-800">{{ authStore.profile?.full_name || 'Not provided' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Email</label>
            <p class="text-gray-800">{{ authStore.user?.email }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Phone</label>
            <p class="text-gray-800">{{ authStore.profile?.phone || 'Not provided' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-500">Role</label>
            <p class="text-gray-800 capitalize">{{ authStore.profile?.role || 'customer' }}</p>
          </div>
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-500">Address</label>
            <p class="text-gray-800">{{ authStore.profile?.address || 'Not provided' }}</p>
          </div>
          <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-500">Member Since</label>
            <p class="text-gray-800">{{ formatDate(authStore.profile?.created_at) }}</p>
          </div>
        </div>
      </div>

      <!-- Account Statistics -->
      <div class="border-t pt-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">Account Statistics</h3>
        <div class="grid md:grid-cols-3 gap-4">
          <div class="bg-blue-50 p-4 rounded-lg">
            <h4 class="text-sm font-medium text-blue-600">Total Orders</h4>
            <p class="text-2xl font-bold text-blue-800">{{ userStats.totalOrders }}</p>
          </div>
          <div class="bg-green-50 p-4 rounded-lg">
            <h4 class="text-sm font-medium text-green-600">Total Spent</h4>
            <p class="text-2xl font-bold text-green-800">${{ userStats.totalSpent.toFixed(2) }}</p>
          </div>
          <div class="bg-purple-50 p-4 rounded-lg">
            <h4 class="text-sm font-medium text-purple-600">Favorite Category</h4>
            <p class="text-2xl font-bold text-purple-800">{{ userStats.favoriteCategory }}</p>
          </div>
        </div>
      </div>

      <!-- Quick Actions -->
      <div class="border-t pt-6">
        <h3 class="text-lg font-semibold text-gray-800 mb-4">Quick Actions</h3>
        <div class="flex flex-wrap gap-4">
          <button
            @click="$emit('view-orders')"
            class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg transition duration-300"
          >
            📋 View My Orders
          </button>
          <button
            @click="$emit('browse-products')"
            class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg transition duration-300"
          >
            🛒 Browse Products
          </button>
          <button
            v-if="authStore.isAdmin"
            @click="$emit('admin-dashboard')"
            class="bg-purple-500 hover:bg-purple-600 text-white px-4 py-2 rounded-lg transition duration-300"
          >
            ⚙️ Admin Dashboard
          </button>
        </div>
      </div>
    </div>

    <!-- Error Display -->
    <div v-if="authStore.error" class="mt-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
      {{ authStore.error }}
      <button @click="authStore.clearError()" class="float-right text-red-500 hover:text-red-700">
        ✕
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, createApp } from 'vue'
import { useAuthStore } from '../stores/authStore.js'
import { pinia } from '../stores/pinia.js'

// Initialize Pinia and use auth store
const app = createApp({})
app.use(pinia)
const authStore = useAuthStore()

// Component state
const isEditing = ref(false)
const editForm = reactive({
  full_name: '',
  phone: '',
  address: ''
})

// Mock user statistics (in real app, this would come from backend)
const userStats = reactive({
  totalOrders: 12,
  totalSpent: 156.78,
  favoriteCategory: 'Classics'
})

// Computed properties
const userInitials = computed(() => {
  const name = authStore.profile?.full_name || authStore.user?.email || 'U'
  return name.split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2)
})

// Methods
const startEdit = () => {
  console.log('✏️ Starting profile edit')
  isEditing.value = true
  // Populate form with current data
  editForm.full_name = authStore.profile?.full_name || ''
  editForm.phone = authStore.profile?.phone || ''
  editForm.address = authStore.profile?.address || ''
}

const cancelEdit = () => {
  console.log('❌ Cancelling profile edit')
  isEditing.value = false
  // Reset form
  editForm.full_name = ''
  editForm.phone = ''
  editForm.address = ''
  authStore.clearError()
}

const updateProfile = async () => {
  console.log('💾 Updating profile:', editForm)
  
  try {
    const result = await authStore.updateProfile(editForm)
    
    if (result.success) {
      console.log('✅ Profile updated successfully')
      isEditing.value = false
    }
  } catch (error) {
    console.error('❌ Profile update failed:', error)
  }
}

const signOut = async () => {
  console.log('🚪 Signing out user')
  
  if (confirm('Are you sure you want to sign out?')) {
    try {
      const result = await authStore.signOut()
      
      if (result.success) {
        console.log('✅ Sign out successful')
        // Emit sign out event to parent component
        emit('signed-out')
      }
    } catch (error) {
      console.error('❌ Sign out failed:', error)
    }
  }
}

const formatDate = (dateString) => {
  if (!dateString) return 'Unknown'
  
  try {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    })
  } catch (error) {
    return 'Unknown'
  }
}

// Define emits
const emit = defineEmits(['signed-out', 'view-orders', 'browse-products', 'admin-dashboard'])
</script>

<style scoped>
/* Component-specific styles */
.transition {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

/* Hover effects */
button:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

/* Focus styles */
input:focus, textarea:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}
</style> 