import { createClient } from '@supabase/supabase-js'

// Supabase configuration
const supabaseUrl = import.meta.env.PUBLIC_SUPABASE_URL || 'https://your-project.supabase.co'
const supabaseAnonKey = import.meta.env.PUBLIC_SUPABASE_ANON_KEY || 'your-anon-key'

// Create Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: true
  }
})

// Database table names
export const TABLES = {
  PRODUCTS: 'products',
  CATEGORIES: 'categories', 
  ORDERS: 'orders',
  ORDER_ITEMS: 'order_items',
  USERS: 'users' // This will be managed by Supabase Auth
}

// Helper functions for common operations
export const supabaseHelpers = {
  // Products
  async getProducts() {
    const { data, error } = await supabase
      .from(TABLES.PRODUCTS)
      .select('*')
      .order('created_at', { ascending: false })
    
    if (error) {
      console.error('Error fetching products:', error)
      return { data: [], error }
    }
    
    return { data, error: null }
  },

  async createProduct(productData) {
    const { data, error } = await supabase
      .from(TABLES.PRODUCTS)
      .insert([productData])
      .select()
    
    if (error) {
      console.error('Error creating product:', error)
      return { data: null, error }
    }
    
    return { data: data[0], error: null }
  },

  async updateProduct(id, updates) {
    const { data, error } = await supabase
      .from(TABLES.PRODUCTS)
      .update(updates)
      .eq('id', id)
      .select()
    
    if (error) {
      console.error('Error updating product:', error)
      return { data: null, error }
    }
    
    return { data: data[0], error: null }
  },

  async deleteProduct(id) {
    const { data, error } = await supabase
      .from(TABLES.PRODUCTS)
      .delete()
      .eq('id', id)
    
    if (error) {
      console.error('Error deleting product:', error)
      return { success: false, error }
    }
    
    return { success: true, error: null }
  },

  // Orders
  async createOrder(orderData) {
    const { data, error } = await supabase
      .from(TABLES.ORDERS)
      .insert([orderData])
      .select()
    
    if (error) {
      console.error('Error creating order:', error)
      return { data: null, error }
    }
    
    return { data: data[0], error: null }
  },

  async getOrdersByUser(userId) {
    const { data, error } = await supabase
      .from(TABLES.ORDERS)
      .select('*, order_items(*)')
      .eq('user_id', userId)
      .order('created_at', { ascending: false })
    
    if (error) {
      console.error('Error fetching orders:', error)
      return { data: [], error }
    }
    
    return { data, error: null }
  },

  // Authentication helpers
  async signUp(email, password, userData = {}) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: {
        data: userData
      }
    })
    
    if (error) {
      console.error('Error signing up:', error)
      return { user: null, error }
    }
    
    return { user: data.user, error: null }
  },

  async signIn(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({
      email,
      password
    })
    
    if (error) {
      console.error('Error signing in:', error)
      return { user: null, error }
    }
    
    return { user: data.user, error: null }
  },

  async signOut() {
    const { error } = await supabase.auth.signOut()
    
    if (error) {
      console.error('Error signing out:', error)
      return { success: false, error }
    }
    
    return { success: true, error: null }
  },

  async getCurrentUser() {
    const { data: { user }, error } = await supabase.auth.getUser()
    
    if (error) {
      console.error('Error getting current user:', error)
      return { user: null, error }
    }
    
    return { user, error: null }
  },

  // Real-time subscriptions
  subscribeToProducts(callback) {
    return supabase
      .channel('products-changes')
      .on('postgres_changes', 
        { event: '*', schema: 'public', table: TABLES.PRODUCTS },
        callback
      )
      .subscribe()
  },

  subscribeToOrders(userId, callback) {
    return supabase
      .channel('user-orders')
      .on('postgres_changes',
        { 
          event: '*', 
          schema: 'public', 
          table: TABLES.ORDERS,
          filter: `user_id=eq.${userId}`
        },
        callback
      )
      .subscribe()
  }
}

// Export default client for direct use
export default supabase 