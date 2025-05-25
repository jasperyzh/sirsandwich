<template>
  <div class="bg-white rounded-lg shadow-md p-6">
    <!-- Role Header -->
    <div class="flex items-center justify-between mb-6">
      <div class="flex items-center space-x-3">
        <div :class="roleIconClass" class="w-12 h-12 rounded-full flex items-center justify-center text-white text-xl font-bold">
          {{ roleIcon }}
        </div>
        <div>
          <h2 class="text-2xl font-bold text-gray-800">{{ roleDisplayName }}</h2>
          <p class="text-gray-600">{{ roleDescription }}</p>
        </div>
      </div>
      <div class="text-right">
        <div class="text-sm text-gray-500">Account Type</div>
        <div :class="roleBadgeClass" class="inline-block px-3 py-1 rounded-full text-sm font-semibold">
          {{ authStore.userRole.toUpperCase() }}
        </div>
      </div>
    </div>

    <!-- Quick Stats -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
      <div class="bg-blue-50 p-4 rounded-lg">
        <div class="text-blue-600 text-sm font-medium">Total Permissions</div>
        <div class="text-2xl font-bold text-blue-800">{{ authStore.userPermissions.length }}</div>
      </div>
      <div class="bg-green-50 p-4 rounded-lg">
        <div class="text-green-600 text-sm font-medium">Resources Access</div>
        <div class="text-2xl font-bold text-green-800">{{ uniqueResources.length }}</div>
      </div>
      <div class="bg-purple-50 p-4 rounded-lg">
        <div class="text-purple-600 text-sm font-medium">Account Status</div>
        <div class="text-2xl font-bold text-purple-800">Active</div>
      </div>
    </div>

    <!-- Permissions Overview -->
    <div class="mb-6">
      <h3 class="text-lg font-semibold text-gray-800 mb-4">🔐 Your Permissions</h3>
      
      <div v-if="authStore.userPermissions.length === 0" class="text-center py-8 text-gray-500">
        <div class="text-4xl mb-2">🔒</div>
        <p>Loading permissions...</p>
      </div>

      <div v-else class="space-y-4">
        <div v-for="resource in groupedPermissions" :key="resource.name" class="border rounded-lg p-4">
          <div class="flex items-center justify-between mb-3">
            <h4 class="font-semibold text-gray-800 flex items-center">
              <span class="mr-2">{{ getResourceIcon(resource.name) }}</span>
              {{ formatResourceName(resource.name) }}
            </h4>
            <span class="text-sm text-gray-500">{{ resource.permissions.length }} permissions</span>
          </div>
          
          <div class="grid grid-cols-2 md:grid-cols-4 gap-2">
            <div 
              v-for="permission in resource.permissions" 
              :key="permission.permission"
              :class="getPermissionBadgeClass(permission.permission)"
              class="px-3 py-1 rounded-full text-xs font-medium text-center"
            >
              {{ formatPermissionName(permission.permission) }}
            </div>
          </div>
          
          <div class="mt-2 text-sm text-gray-600">
            <strong>What you can do:</strong>
            <ul class="list-disc list-inside mt-1 space-y-1">
              <li v-for="permission in resource.permissions" :key="permission.permission">
                {{ permission.description }}
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>

    <!-- Role Capabilities -->
    <div class="mb-6">
      <h3 class="text-lg font-semibold text-gray-800 mb-4">⚡ What You Can Do</h3>
      
      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div v-for="capability in roleCapabilities" :key="capability.title" class="border rounded-lg p-4">
          <div class="flex items-start space-x-3">
            <div :class="capability.iconClass" class="w-8 h-8 rounded-full flex items-center justify-center text-white text-sm">
              {{ capability.icon }}
            </div>
            <div class="flex-1">
              <h5 class="font-semibold text-gray-800">{{ capability.title }}</h5>
              <p class="text-sm text-gray-600 mt-1">{{ capability.description }}</p>
              <div class="mt-2">
                <span v-for="action in capability.actions" :key="action" class="inline-block bg-gray-100 text-gray-700 px-2 py-1 rounded text-xs mr-1 mb-1">
                  {{ action }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Quick Actions -->
    <div>
      <h3 class="text-lg font-semibold text-gray-800 mb-4">🚀 Quick Actions</h3>
      
      <div class="grid grid-cols-2 md:grid-cols-4 gap-3">
        <button 
          v-for="action in quickActions" 
          :key="action.name"
          @click="action.handler"
          :disabled="!action.enabled"
          :class="[
            'p-3 rounded-lg border text-center transition-colors',
            action.enabled 
              ? 'border-blue-200 hover:border-blue-300 hover:bg-blue-50 text-blue-700' 
              : 'border-gray-200 text-gray-400 cursor-not-allowed'
          ]"
        >
          <div class="text-lg mb-1">{{ action.icon }}</div>
          <div class="text-sm font-medium">{{ action.name }}</div>
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useAuthStore } from '../stores/authStore.js'

const authStore = useAuthStore()

// Role display information
const roleDisplayName = computed(() => {
  const role = authStore.userRole
  const names = {
    admin: 'System Administrator',
    staff: 'Staff Member',
    customer: 'Customer'
  }
  return names[role] || 'User'
})

const roleDescription = computed(() => {
  const role = authStore.userRole
  const descriptions = {
    admin: 'Full system access with all administrative privileges',
    staff: 'Limited administrative access for daily operations',
    customer: 'Standard user access for shopping and orders'
  }
  return descriptions[role] || 'Standard user access'
})

const roleIcon = computed(() => {
  const role = authStore.userRole
  const icons = {
    admin: '👑',
    staff: '👨‍💼',
    customer: '👤'
  }
  return icons[role] || '👤'
})

const roleIconClass = computed(() => {
  const role = authStore.userRole
  const classes = {
    admin: 'bg-red-500',
    staff: 'bg-blue-500',
    customer: 'bg-green-500'
  }
  return classes[role] || 'bg-gray-500'
})

const roleBadgeClass = computed(() => {
  const role = authStore.userRole
  const classes = {
    admin: 'bg-red-100 text-red-800',
    staff: 'bg-blue-100 text-blue-800',
    customer: 'bg-green-100 text-green-800'
  }
  return classes[role] || 'bg-gray-100 text-gray-800'
})

// Permissions grouping
const groupedPermissions = computed(() => {
  const groups = {}
  
  authStore.userPermissions.forEach(permission => {
    if (!groups[permission.resource]) {
      groups[permission.resource] = {
        name: permission.resource,
        permissions: []
      }
    }
    groups[permission.resource].permissions.push(permission)
  })
  
  return Object.values(groups)
})

const uniqueResources = computed(() => {
  return [...new Set(authStore.userPermissions.map(p => p.resource))]
})

// Helper functions
const getResourceIcon = (resource) => {
  const icons = {
    products: '📦',
    categories: '📂',
    orders: '🛒',
    users: '👥',
    analytics: '📊',
    system: '⚙️',
    profile: '👤'
  }
  return icons[resource] || '📄'
}

const formatResourceName = (resource) => {
  return resource.charAt(0).toUpperCase() + resource.slice(1)
}

const formatPermissionName = (permission) => {
  const names = {
    create: 'Create',
    read: 'View',
    update: 'Edit',
    delete: 'Delete',
    manage: 'Manage'
  }
  return names[permission] || permission
}

const getPermissionBadgeClass = (permission) => {
  const classes = {
    create: 'bg-green-100 text-green-800',
    read: 'bg-blue-100 text-blue-800',
    update: 'bg-yellow-100 text-yellow-800',
    delete: 'bg-red-100 text-red-800',
    manage: 'bg-purple-100 text-purple-800'
  }
  return classes[permission] || 'bg-gray-100 text-gray-800'
}

// Role capabilities
const roleCapabilities = computed(() => {
  const role = authStore.userRole
  
  const capabilities = {
    admin: [
      {
        title: 'Product Management',
        description: 'Full control over product catalog and inventory',
        icon: '📦',
        iconClass: 'bg-blue-500',
        actions: ['Add Products', 'Edit Details', 'Manage Stock', 'Delete Items']
      },
      {
        title: 'Order Management',
        description: 'View and manage all customer orders',
        icon: '🛒',
        iconClass: 'bg-green-500',
        actions: ['View All Orders', 'Update Status', 'Cancel Orders', 'Process Refunds']
      },
      {
        title: 'User Management',
        description: 'Manage user accounts and permissions',
        icon: '👥',
        iconClass: 'bg-purple-500',
        actions: ['View Users', 'Change Roles', 'Manage Access', 'User Support']
      },
      {
        title: 'Analytics & Reports',
        description: 'Access to sales data and business insights',
        icon: '📊',
        iconClass: 'bg-orange-500',
        actions: ['Sales Reports', 'User Analytics', 'Performance Metrics', 'Export Data']
      }
    ],
    staff: [
      {
        title: 'Order Processing',
        description: 'Handle customer orders and fulfillment',
        icon: '🛒',
        iconClass: 'bg-green-500',
        actions: ['View Orders', 'Update Status', 'Customer Support']
      },
      {
        title: 'Inventory Updates',
        description: 'Manage product stock and availability',
        icon: '📦',
        iconClass: 'bg-blue-500',
        actions: ['Update Stock', 'Check Inventory', 'Product Status']
      }
    ],
    customer: [
      {
        title: 'Shopping',
        description: 'Browse and purchase products',
        icon: '🛒',
        iconClass: 'bg-green-500',
        actions: ['Browse Products', 'Add to Cart', 'Place Orders', 'Track Orders']
      },
      {
        title: 'Account Management',
        description: 'Manage your personal account and preferences',
        icon: '👤',
        iconClass: 'bg-blue-500',
        actions: ['Update Profile', 'View Orders', 'Change Password', 'Preferences']
      }
    ]
  }
  
  return capabilities[role] || []
})

// Quick actions
const quickActions = computed(() => {
  const role = authStore.userRole
  
  const actions = {
    admin: [
      { name: 'Add Product', icon: '➕', enabled: authStore.hasPermission('create', 'products'), handler: () => navigateTo('/admin/products/new') },
      { name: 'View Orders', icon: '📋', enabled: authStore.hasPermission('read', 'orders'), handler: () => navigateTo('/admin/orders') },
      { name: 'Analytics', icon: '📊', enabled: authStore.hasPermission('read', 'analytics'), handler: () => navigateTo('/admin/analytics') },
      { name: 'Settings', icon: '⚙️', enabled: authStore.hasPermission('manage', 'system'), handler: () => navigateTo('/admin/settings') }
    ],
    staff: [
      { name: 'View Orders', icon: '📋', enabled: authStore.hasPermission('read', 'orders'), handler: () => navigateTo('/admin/orders') },
      { name: 'Update Stock', icon: '📦', enabled: authStore.hasPermission('update', 'products'), handler: () => navigateTo('/admin/products') },
      { name: 'Reports', icon: '📊', enabled: authStore.hasPermission('read', 'analytics'), handler: () => navigateTo('/admin/reports') },
      { name: 'Support', icon: '💬', enabled: true, handler: () => navigateTo('/support') }
    ],
    customer: [
      { name: 'Shop Now', icon: '🛒', enabled: true, handler: () => navigateTo('/products') },
      { name: 'My Orders', icon: '📋', enabled: authStore.hasPermission('read', 'orders'), handler: () => navigateTo('/orders') },
      { name: 'Profile', icon: '👤', enabled: authStore.hasPermission('update', 'profile'), handler: () => navigateTo('/profile') },
      { name: 'Support', icon: '💬', enabled: true, handler: () => navigateTo('/contact') }
    ]
  }
  
  return actions[role] || []
})

// Navigation helper
const navigateTo = (path) => {
  window.location.href = path
}
</script>

<style scoped>
/* Custom animations */
.fade-in {
  animation: fadeIn 0.5s ease-in;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style> 