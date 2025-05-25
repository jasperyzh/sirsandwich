import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase, supabaseHelpers } from '../lib/supabase.js'

export const useAuthStore = defineStore('auth', () => {
  // State
  const user = ref(null)
  const profile = ref(null)
  const loading = ref(false)
  const error = ref(null)

  // Getters
  const isAuthenticated = computed(() => !!user.value)
  const isAdmin = computed(() => profile.value?.role === 'admin')
  const isStaff = computed(() => ['admin', 'staff'].includes(profile.value?.role))
  const userDisplayName = computed(() => {
    return profile.value?.full_name || user.value?.email || 'User'
  })

  // Actions
  const initialize = async () => {
    console.log('🔐 Initializing auth store...')
    loading.value = true
    
    try {
      // Get current session
      const { data: { session }, error: sessionError } = await supabase.auth.getSession()
      
      if (sessionError) {
        console.error('❌ Session error:', sessionError)
        throw sessionError
      }

      if (session?.user) {
        console.log('✅ Found existing session for:', session.user.email)
        await setUser(session.user)
      } else {
        console.log('ℹ️ No existing session found')
      }

      // Listen for auth changes
      supabase.auth.onAuthStateChange(async (event, session) => {
        console.log('🔄 Auth state changed:', event)
        
        if (event === 'SIGNED_IN' && session?.user) {
          await setUser(session.user)
        } else if (event === 'SIGNED_OUT') {
          clearUser()
        }
      })

    } catch (err) {
      console.error('❌ Auth initialization error:', err)
      error.value = err.message
    } finally {
      loading.value = false
    }
  }

  const setUser = async (authUser) => {
    console.log('👤 Setting user:', authUser.email)
    user.value = authUser
    
    // Fetch user profile
    try {
      const { data, error: profileError } = await supabase
        .from('user_profiles')
        .select('*')
        .eq('id', authUser.id)
        .single()

      if (profileError && profileError.code !== 'PGRST116') { // PGRST116 = no rows returned
        console.error('❌ Profile fetch error:', profileError)
        throw profileError
      }

      if (data) {
        console.log('✅ Profile loaded:', data.full_name || data.role)
        profile.value = data
      } else {
        console.log('ℹ️ No profile found, creating default...')
        // Create default profile if none exists
        const { data: newProfile, error: createError } = await supabase
          .from('user_profiles')
          .insert([{
            id: authUser.id,
            full_name: authUser.user_metadata?.full_name || '',
            role: 'customer'
          }])
          .select()
          .single()

        if (createError) {
          console.error('❌ Profile creation error:', createError)
        } else {
          console.log('✅ Profile created:', newProfile)
          profile.value = newProfile
        }
      }
    } catch (err) {
      console.error('❌ Error setting user profile:', err)
      error.value = err.message
    }
  }

  const clearUser = () => {
    console.log('🚪 Clearing user session')
    user.value = null
    profile.value = null
    error.value = null
  }

  const signUp = async (email, password, userData = {}) => {
    console.log('📝 Signing up user:', email)
    loading.value = true
    error.value = null

    try {
      const { user: newUser, error: signUpError } = await supabaseHelpers.signUp(
        email, 
        password, 
        userData
      )

      if (signUpError) {
        console.error('❌ Sign up error:', signUpError)
        throw signUpError
      }

      console.log('✅ Sign up successful:', email)
      return { success: true, user: newUser }

    } catch (err) {
      console.error('❌ Sign up failed:', err)
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  const signIn = async (email, password) => {
    console.log('🔑 Signing in user:', email)
    loading.value = true
    error.value = null

    try {
      const { user: signedInUser, error: signInError } = await supabaseHelpers.signIn(
        email, 
        password
      )

      if (signInError) {
        console.error('❌ Sign in error:', signInError)
        throw signInError
      }

      console.log('✅ Sign in successful:', email)
      return { success: true, user: signedInUser }

    } catch (err) {
      console.error('❌ Sign in failed:', err)
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  const signOut = async () => {
    console.log('🚪 Signing out user')
    loading.value = true
    error.value = null

    try {
      const { success, error: signOutError } = await supabaseHelpers.signOut()

      if (signOutError) {
        console.error('❌ Sign out error:', signOutError)
        throw signOutError
      }

      console.log('✅ Sign out successful')
      return { success: true }

    } catch (err) {
      console.error('❌ Sign out failed:', err)
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  const updateProfile = async (updates) => {
    console.log('📝 Updating user profile:', updates)
    loading.value = true
    error.value = null

    try {
      if (!user.value) {
        throw new Error('No authenticated user')
      }

      const { data, error: updateError } = await supabase
        .from('user_profiles')
        .update(updates)
        .eq('id', user.value.id)
        .select()
        .single()

      if (updateError) {
        console.error('❌ Profile update error:', updateError)
        throw updateError
      }

      console.log('✅ Profile updated successfully')
      profile.value = data
      return { success: true, profile: data }

    } catch (err) {
      console.error('❌ Profile update failed:', err)
      error.value = err.message
      return { success: false, error: err.message }
    } finally {
      loading.value = false
    }
  }

  const clearError = () => {
    error.value = null
  }

  // Return store interface
  return {
    // State
    user,
    profile,
    loading,
    error,
    
    // Getters
    isAuthenticated,
    isAdmin,
    isStaff,
    userDisplayName,
    
    // Actions
    initialize,
    signUp,
    signIn,
    signOut,
    updateProfile,
    clearError
  }
}) 