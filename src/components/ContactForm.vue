<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <div>
      <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
        Full Name *
      </label>
      <input 
        v-model="formData.name"
        type="text" 
        id="name" 
        name="name" 
        required
        :class="[
          'w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-300',
          errors.name ? 'border-red-500 bg-red-50' : 'border-gray-300'
        ]"
        placeholder="Your full name"
        @blur="validateField('name')"
      >
      <p v-if="errors.name" class="text-red-500 text-sm mt-1">{{ errors.name }}</p>
    </div>

    <div>
      <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
        Email Address *
      </label>
      <input 
        v-model="formData.email"
        type="email" 
        id="email" 
        name="email" 
        required
        :class="[
          'w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-300',
          errors.email ? 'border-red-500 bg-red-50' : 'border-gray-300'
        ]"
        placeholder="your.email@example.com"
        @blur="validateField('email')"
      >
      <p v-if="errors.email" class="text-red-500 text-sm mt-1">{{ errors.email }}</p>
    </div>

    <div>
      <label for="phone" class="block text-sm font-medium text-gray-700 mb-2">
        Phone Number
      </label>
      <input 
        v-model="formData.phone"
        type="tel" 
        id="phone" 
        name="phone"
        class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-300"
        placeholder="(123) 456-7890"
      >
    </div>

    <div>
      <label for="subject" class="block text-sm font-medium text-gray-700 mb-2">
        Subject *
      </label>
      <select 
        v-model="formData.subject"
        id="subject" 
        name="subject" 
        required
        :class="[
          'w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-300',
          errors.subject ? 'border-red-500 bg-red-50' : 'border-gray-300'
        ]"
        @change="validateField('subject')"
      >
        <option value="">Please select a subject</option>
        <option value="general">General Inquiry</option>
        <option value="order">Order Question</option>
        <option value="feedback">Feedback</option>
        <option value="catering">Catering Request</option>
        <option value="other">Other</option>
      </select>
      <p v-if="errors.subject" class="text-red-500 text-sm mt-1">{{ errors.subject }}</p>
    </div>

    <div>
      <label for="message" class="block text-sm font-medium text-gray-700 mb-2">
        Message *
      </label>
      <textarea 
        v-model="formData.message"
        id="message" 
        name="message" 
        rows="5" 
        required
        :class="[
          'w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent transition duration-300',
          errors.message ? 'border-red-500 bg-red-50' : 'border-gray-300'
        ]"
        placeholder="Tell us how we can help you..."
        @blur="validateField('message')"
      ></textarea>
      <p v-if="errors.message" class="text-red-500 text-sm mt-1">{{ errors.message }}</p>
      <p class="text-sm text-gray-500 mt-1">{{ messageLength }}/500 characters</p>
    </div>

    <!-- Form Status Display -->
    <div v-if="submitStatus" class="p-4 rounded-lg" :class="submitStatusClass">
      <p class="font-medium">{{ submitStatus }}</p>
    </div>

    <button 
      type="submit"
      :disabled="isSubmitting || !isFormValid"
      :class="[
        'w-full font-semibold py-3 px-6 rounded-lg transition duration-300',
        isSubmitting || !isFormValid
          ? 'bg-gray-400 text-gray-600 cursor-not-allowed'
          : 'bg-blue-500 hover:bg-blue-600 text-white transform hover:scale-105'
      ]"
    >
      {{ submitButtonText }}
    </button>

    <!-- Real-time Validation Status -->
    <div class="text-center">
      <p class="text-sm" :class="isFormValid ? 'text-green-600' : 'text-gray-500'">
        {{ isFormValid ? '✅ Form is valid and ready to submit!' : '⚠️ Please fill in all required fields correctly' }}
      </p>
    </div>
  </form>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { supabase } from '../lib/supabase.js'

// Form data
const formData = reactive({
  name: '',
  email: '',
  phone: '',
  subject: '',
  message: ''
})

// Validation errors
const errors = reactive({
  name: '',
  email: '',
  subject: '',
  message: ''
})

// Form state
const isSubmitting = ref(false)
const submitStatus = ref('')

// Computed properties
const messageLength = computed(() => formData.message.length)

const isFormValid = computed(() => {
  return formData.name && 
         formData.email && 
         formData.subject && 
         formData.message &&
         !errors.name && 
         !errors.email && 
         !errors.subject && 
         !errors.message
})

const submitButtonText = computed(() => {
  return isSubmitting.value ? '🚀 Sending...' : 'Send Message'
})

const submitStatusClass = computed(() => {
  return submitStatus.value.includes('Error') 
    ? 'bg-red-100 text-red-700 border border-red-300'
    : 'bg-green-100 text-green-700 border border-green-300'
})

// Validation methods
const validateField = (fieldName) => {
  errors[fieldName] = ''
  
  switch (fieldName) {
    case 'name':
      if (!formData.name.trim()) {
        errors.name = 'Name is required'
      } else if (formData.name.trim().length < 2) {
        errors.name = 'Name must be at least 2 characters'
      }
      break
    
    case 'email':
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
      if (!formData.email.trim()) {
        errors.email = 'Email is required'
      } else if (!emailRegex.test(formData.email)) {
        errors.email = 'Please enter a valid email address'
      }
      break
    
    case 'subject':
      if (!formData.subject) {
        errors.subject = 'Please select a subject'
      }
      break
    
    case 'message':
      if (!formData.message.trim()) {
        errors.message = 'Message is required'
      } else if (formData.message.trim().length < 10) {
        errors.message = 'Message must be at least 10 characters'
      } else if (formData.message.length > 500) {
        errors.message = 'Message must be less than 500 characters'
      }
      break
  }
}

const validateForm = () => {
  Object.keys(formData).forEach(field => {
    if (field !== 'phone') { // Phone is optional
      validateField(field)
    }
  })
  return isFormValid.value
}

// Form submission
const handleSubmit = async () => {
  console.log('📩 Form submission started')
  
  // Validate all fields
  if (!validateForm()) {
    console.log('❌ Form validation failed')
    submitStatus.value = 'Error: Please fix the errors above and try again.'
    setTimeout(() => {
      submitStatus.value = ''
    }, 5000)
    return
  }

  isSubmitting.value = true
  submitStatus.value = ''

  try {
    console.log('📤 Sending form data to Supabase:', formData)
    
    // Submit to Supabase contact_messages table
    const { data, error } = await supabase
      .from('contact_messages')
      .insert([{
        name: formData.name.trim(),
        email: formData.email.trim(),
        phone: formData.phone.trim() || null,
        subject: formData.subject,
        message: formData.message.trim(),
        status: 'new'
      }])
      .select()
    
    if (error) {
      throw error
    }
    
    console.log('✅ Contact message saved to Supabase:', data)
    submitStatus.value = '✅ Thank you! Your message has been sent successfully. We\'ll get back to you within 24 hours.'
    
    // Reset form
    Object.keys(formData).forEach(key => {
      formData[key] = ''
    })
    
    // Clear validation errors
    Object.keys(errors).forEach(key => {
      errors[key] = ''
    })
    
    // Clear status after 8 seconds
    setTimeout(() => {
      submitStatus.value = ''
    }, 8000)
    
  } catch (error) {
    console.error('❌ Form submission error:', error)
    
    // Provide user-friendly error messages
    let errorMessage = 'Failed to send message. Please try again later.'
    
    if (error.message.includes('duplicate key')) {
      errorMessage = 'It looks like you\'ve already sent this message. Please wait before sending another.'
    } else if (error.message.includes('network')) {
      errorMessage = 'Network error. Please check your connection and try again.'
    } else if (error.code === '23505') {
      errorMessage = 'This message has already been submitted.'
    }
    
    submitStatus.value = `Error: ${errorMessage}`
    
    setTimeout(() => {
      submitStatus.value = ''
    }, 5000)
  } finally {
    isSubmitting.value = false
  }
}
</script>

<style scoped>
/* Custom styles can go here if needed */
/* Most styling is handled by Tailwind CSS */
</style> 