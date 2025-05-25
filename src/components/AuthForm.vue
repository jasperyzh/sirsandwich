<template>
  <div class="max-w-md mx-auto bg-white p-6 rounded-lg shadow-md">
    <!-- Form Header -->
    <div class="text-center mb-6">
      <h2 class="text-2xl font-bold text-gray-800">
        {{ isLogin ? 'Welcome Back!' : 'Join Sirsandwich' }}
      </h2>
      <p class="text-gray-600 mt-2">
        {{ isLogin ? 'Sign in to your account' : 'Create your account to start ordering' }}
      </p>
    </div>

    <!-- Error Display -->
    <div v-if="authStore.error" class="mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded">
      {{ authStore.error }}
      <button @click="authStore.clearError()" class="float-right text-red-500 hover:text-red-700">
        ✕
      </button>
    </div>

    <!-- Auth Form -->
    <form @submit.prevent="handleSubmit" class="space-y-4">
      <!-- Full Name (Sign Up Only) -->
      <div v-if="!isLogin">
        <label class="block text-sm font-medium text-gray-700 mb-2">Full Name</label>
        <input
          v-model="formData.fullName"
          type="text"
          :class="[
            'w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500',
            errors.fullName ? 'border-red-500' : 'border-gray-300'
          ]"
          placeholder="Enter your full name"
          @blur="validateField('fullName')"
        >
        <p v-if="errors.fullName" class="text-red-500 text-sm mt-1">{{ errors.fullName }}</p>
      </div>

      <!-- Email -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">Email Address</label>
        <input
          v-model="formData.email"
          type="email"
          required
          :class="[
            'w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500',
            errors.email ? 'border-red-500' : 'border-gray-300'
          ]"
          placeholder="Enter your email"
          @blur="validateField('email')"
        >
        <p v-if="errors.email" class="text-red-500 text-sm mt-1">{{ errors.email }}</p>
      </div>

      <!-- Password -->
      <div>
        <label class="block text-sm font-medium text-gray-700 mb-2">Password</label>
        <div class="relative">
          <input
            v-model="formData.password"
            :type="showPassword ? 'text' : 'password'"
            required
            :class="[
              'w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500 pr-10',
              errors.password ? 'border-red-500' : 'border-gray-300'
            ]"
            :placeholder="isLogin ? 'Enter your password' : 'Create a password (min 6 characters)'"
            @blur="validateField('password')"
          >
          <button
            type="button"
            @click="showPassword = !showPassword"
            class="absolute right-3 top-2.5 text-gray-500 hover:text-gray-700"
          >
            {{ showPassword ? '👁️' : '👁️‍🗨️' }}
          </button>
        </div>
        <p v-if="errors.password" class="text-red-500 text-sm mt-1">{{ errors.password }}</p>
      </div>

      <!-- Confirm Password (Sign Up Only) -->
      <div v-if="!isLogin">
        <label class="block text-sm font-medium text-gray-700 mb-2">Confirm Password</label>
        <input
          v-model="formData.confirmPassword"
          type="password"
          required
          :class="[
            'w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-blue-500',
            errors.confirmPassword ? 'border-red-500' : 'border-gray-300'
          ]"
          placeholder="Confirm your password"
          @blur="validateField('confirmPassword')"
        >
        <p v-if="errors.confirmPassword" class="text-red-500 text-sm mt-1">{{ errors.confirmPassword }}</p>
      </div>

      <!-- Submit Button -->
      <button
        type="submit"
        :disabled="authStore.loading || !isFormValid"
        :class="[
          'w-full py-2 px-4 rounded-lg font-semibold transition duration-300',
          authStore.loading || !isFormValid
            ? 'bg-gray-400 cursor-not-allowed'
            : 'bg-blue-500 hover:bg-blue-600 text-white'
        ]"
      >
        <span v-if="authStore.loading">
          {{ isLogin ? 'Signing In...' : 'Creating Account...' }}
        </span>
        <span v-else>
          {{ isLogin ? 'Sign In' : 'Create Account' }}
        </span>
      </button>
    </form>

    <!-- Toggle Form Mode -->
    <div class="mt-6 text-center">
      <p class="text-gray-600">
        {{ isLogin ? "Don't have an account?" : "Already have an account?" }}
        <button
          @click="toggleMode"
          class="text-blue-500 hover:text-blue-700 font-semibold ml-1"
        >
          {{ isLogin ? 'Sign Up' : 'Sign In' }}
        </button>
      </p>
    </div>

    <!-- Account Info -->
    <div class="mt-4 space-y-3">
      <!-- Demo Accounts -->
      <div class="p-3 bg-blue-50 border border-blue-200 rounded-lg">
        <p class="text-sm text-blue-800">
          <strong>🧪 Demo Accounts (Development):</strong><br>
          <strong>Admin:</strong> admin@sirsandwich.com / admin123<br>
          <strong>Customer:</strong> customer@sirsandwich.com / customer123
        </p>
      </div>
      
      <!-- Real Accounts -->
      <div class="p-3 bg-green-50 border border-green-200 rounded-lg">
        <p class="text-sm text-green-800">
          <strong>🔐 Live Accounts (Production):</strong><br>
          <strong>Admin:</strong> live_admin@sirsandwich.com / SecureAdmin123!<br>
          <strong>Customer:</strong> live_customer@emailtest.com / SecureCustomer123!
        </p>
      </div>
      
      <!-- Instructions -->
      <div class="p-3 bg-yellow-50 border border-yellow-200 rounded-lg">
        <p class="text-sm text-yellow-800">
          <strong>📝 Note:</strong> Live accounts need to be created in Supabase first. 
          Run the SQL script in <code>docs/create-real-users.sql</code> to set up the database.
        </p>
      </div>
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
const isLogin = ref(true)
const showPassword = ref(false)

const formData = reactive({
  fullName: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const errors = reactive({})

// Computed properties
const isFormValid = computed(() => {
  const hasRequiredFields = formData.email && formData.password
  const hasNoErrors = Object.keys(errors).length === 0
  
  if (!isLogin.value) {
    return hasRequiredFields && formData.fullName && formData.confirmPassword && hasNoErrors
  }
  
  return hasRequiredFields && hasNoErrors
})

// Validation functions
const validateField = (field) => {
  switch (field) {
    case 'fullName':
      if (!isLogin.value && (!formData.fullName || formData.fullName.length < 2)) {
        errors.fullName = 'Full name must be at least 2 characters'
      } else {
        delete errors.fullName
      }
      break
      
    case 'email':
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!formData.email) {
        errors.email = 'Email is required'
      } else if (!emailRegex.test(formData.email)) {
        errors.email = 'Please enter a valid email address'
      } else {
        delete errors.email
      }
      break
      
    case 'password':
      if (!formData.password) {
        errors.password = 'Password is required'
      } else if (!isLogin.value && formData.password.length < 6) {
        errors.password = 'Password must be at least 6 characters'
      } else {
        delete errors.password
        // Re-validate confirm password if it exists
        if (!isLogin.value && formData.confirmPassword) {
          validateField('confirmPassword')
        }
      }
      break
      
    case 'confirmPassword':
      if (!isLogin.value) {
        if (!formData.confirmPassword) {
          errors.confirmPassword = 'Please confirm your password'
        } else if (formData.password !== formData.confirmPassword) {
          errors.confirmPassword = 'Passwords do not match'
        } else {
          delete errors.confirmPassword
        }
      }
      break
  }
}

// Form handlers
const handleSubmit = async () => {
  console.log(`🔐 ${isLogin.value ? 'Login' : 'Sign up'} attempt:`, formData.email)
  
  // Validate all fields
  validateField('email')
  validateField('password')
  if (!isLogin.value) {
    validateField('fullName')
    validateField('confirmPassword')
  }
  
  if (!isFormValid.value) {
    console.log('❌ Form validation failed')
    return
  }

  try {
    let result
    
    if (isLogin.value) {
      result = await authStore.signIn(formData.email, formData.password)
    } else {
      result = await authStore.signUp(formData.email, formData.password, {
        full_name: formData.fullName
      })
    }

    if (result.success) {
      console.log(`✅ ${isLogin.value ? 'Login' : 'Sign up'} successful`)
      // Emit success event to parent component
      emit('auth-success', { type: isLogin.value ? 'login' : 'signup', user: result.user })
    }
  } catch (error) {
    console.error(`❌ ${isLogin.value ? 'Login' : 'Sign up'} error:`, error)
  }
}

const toggleMode = () => {
  isLogin.value = !isLogin.value
  // Clear form and errors when switching modes
  Object.keys(formData).forEach(key => {
    formData[key] = ''
  })
  Object.keys(errors).forEach(key => {
    delete errors[key]
  })
  authStore.clearError()
  console.log(`🔄 Switched to ${isLogin.value ? 'login' : 'signup'} mode`)
}

// Define emits
const emit = defineEmits(['auth-success'])
</script>

<style scoped>
/* Component-specific styles */
.transition {
  transition-property: all;
  transition-timing-function: cubic-bezier(0.4, 0, 0.2, 1);
  transition-duration: 300ms;
}

/* Focus styles for better accessibility */
input:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

/* Button hover effects */
button:hover:not(:disabled) {
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}
</style> 