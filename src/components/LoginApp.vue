<template>
  <div class="max-w-4xl mx-auto">
    <!-- Loading State -->
    <div v-if="authStore.loading && !authStore.user" class="text-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-500 mx-auto"></div>
      <p class="text-gray-600 mt-4">Loading your account...</p>
    </div>

    <!-- Authentication Form (when not logged in) -->
    <AuthForm 
      v-else-if="!authStore.isAuthenticated"
      @auth-success="handleAuthSuccess"
    />

    <!-- User Profile (when logged in) -->
    <UserProfile 
      v-else
      @signed-out="handleSignOut"
      @view-orders="handleViewOrders"
      @browse-products="handleBrowseProducts"
      @admin-dashboard="handleAdminDashboard"
    />
  </div>
</template>

<script setup>
import { useAuthStore } from '../stores/authStore.js'
import AuthForm from './AuthForm.vue'
import UserProfile from './UserProfile.vue'

const authStore = useAuthStore()

// Initialize auth store
authStore.initialize()

// Event handlers
const handleAuthSuccess = (data) => {
  console.log('🎉 Authentication successful:', data.type)
}

const handleSignOut = () => {
  console.log('👋 User signed out')
}

const handleViewOrders = () => {
  console.log('📋 Redirecting to orders page')
  window.location.href = '/orders'
}

const handleBrowseProducts = () => {
  console.log('🛒 Redirecting to products page')
  window.location.href = '/products'
}

const handleAdminDashboard = () => {
  console.log('⚙️ Redirecting to admin dashboard')
  window.location.href = '/admin'
}
</script>

<style scoped>
/* Loading animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}
</style> 