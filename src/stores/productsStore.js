import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useProductsStore = defineStore('products', () => {
  // State
  const products = ref([
    {
      id: 1,
      name: "The Classic Club",
      description: "A timeless favorite featuring layers of fresh turkey, smoky ham, crispy bacon, crisp lettuce, ripe tomato, and creamy mayo on toasted white bread",
      price: 12.99,
      image: "🥪",
      category: "Classics",
      stock: 25,
      specs: {
        calories: 520,
        allergens: ["gluten", "dairy"],
        prepTime: "5-7 minutes"
      }
    },
    {
      id: 2,
      name: "Italian Supreme",
      description: "A Mediterranean masterpiece with premium salami, spicy pepperoni, savory ham, melted provolone, fresh lettuce, ripe tomato, and zesty Italian dressing",
      price: 14.99,
      image: "🥙",
      category: "Gourmet",
      stock: 18,
      specs: {
        calories: 610,
        allergens: ["gluten", "dairy"],
        prepTime: "6-8 minutes"
      }
    },
    {
      id: 3,
      name: "Veggie Delight",
      description: "A garden-fresh creation with crisp vegetables, creamy avocado, protein-rich hummus, fresh sprouts, and our special herb blend on whole grain bread",
      price: 10.99,
      image: "🥗",
      category: "Vegetarian",
      stock: 30,
      specs: {
        calories: 380,
        allergens: ["gluten"],
        prepTime: "4-6 minutes"
      }
    },
    {
      id: 4,
      name: "BBQ Pulled Pork",
      description: "Tender slow-cooked pulled pork smothered in our signature BBQ sauce, topped with creamy coleslaw and tangy pickles on a brioche bun",
      price: 13.99,
      image: "🍖",
      category: "BBQ",
      stock: 22,
      specs: {
        calories: 580,
        allergens: ["gluten", "dairy"],
        prepTime: "7-9 minutes"
      }
    },
    {
      id: 5,
      name: "Grilled Chicken Caesar",
      description: "Perfectly grilled chicken breast with crisp romaine lettuce, aged parmesan cheese, creamy caesar dressing, and crunchy croutons",
      price: 11.99,
      image: "🍗",
      category: "Chicken",
      stock: 20,
      specs: {
        calories: 450,
        allergens: ["gluten", "dairy", "eggs"],
        prepTime: "6-8 minutes"
      }
    },
    {
      id: 6,
      name: "Tuna Melt",
      description: "Fresh albacore tuna salad with melted aged cheddar cheese and ripe tomato slices on golden toasted sourdough bread",
      price: 10.49,
      image: "🐟",
      category: "Seafood",
      stock: 15,
      specs: {
        calories: 420,
        allergens: ["gluten", "dairy", "fish"],
        prepTime: "5-7 minutes"
      }
    }
  ])

  const categories = ref(["All", "Classics", "Gourmet", "Vegetarian", "BBQ", "Chicken", "Seafood"])
  const selectedCategory = ref("All")
  const searchQuery = ref("")

  // Getters (computed)
  const filteredProducts = computed(() => {
    let filtered = products.value

    // Filter by category
    if (selectedCategory.value && selectedCategory.value !== "All") {
      filtered = filtered.filter(product => product.category === selectedCategory.value)
    }

    // Filter by search query
    if (searchQuery.value.trim()) {
      const query = searchQuery.value.toLowerCase().trim()
      filtered = filtered.filter(product => 
        product.name.toLowerCase().includes(query) ||
        product.description.toLowerCase().includes(query) ||
        product.category.toLowerCase().includes(query)
      )
    }

    return filtered
  })

  const categoryCount = computed(() => {
    const counts = {}
    products.value.forEach(product => {
      counts[product.category] = (counts[product.category] || 0) + 1
    })
    counts["All"] = products.value.length
    return counts
  })

  const productById = computed(() => {
    return (id) => products.value.find(product => product.id === id)
  })

  const totalProducts = computed(() => products.value.length)

  // Actions
  const setCategory = (category) => {
    console.log('🏷️ Setting category filter to:', category)
    selectedCategory.value = category
  }

  const setSearchQuery = (query) => {
    console.log('🔍 Setting search query to:', query)
    searchQuery.value = query
  }

  const clearFilters = () => {
    console.log('🧹 Clearing all filters')
    selectedCategory.value = "All"
    searchQuery.value = ""
  }

  const addProduct = (productData) => {
    console.log('➕ Adding new product:', productData.name)
    const newId = Math.max(...products.value.map(p => p.id)) + 1
    const newProduct = {
      id: newId,
      stock: 0,
      ...productData
    }
    products.value.push(newProduct)
    saveToLocalStorage()
    return newProduct
  }

  const updateProduct = (id, updates) => {
    console.log('✏️ Updating product:', id, updates)
    const product = products.value.find(p => p.id === id)
    if (product) {
      Object.assign(product, updates)
      saveToLocalStorage()
      return true
    }
    return false
  }

  const deleteProduct = (id) => {
    console.log('🗑️ Deleting product:', id)
    const index = products.value.findIndex(p => p.id === id)
    if (index > -1) {
      const deleted = products.value.splice(index, 1)[0]
      saveToLocalStorage()
      return deleted
    }
    return null
  }

  const updateStock = (id, newStock) => {
    console.log('📦 Updating stock for product:', id, 'to:', newStock)
    return updateProduct(id, { stock: newStock })
  }

  // Local Storage persistence for admin changes
  const saveToLocalStorage = () => {
    try {
      localStorage.setItem('sirsandwich-products', JSON.stringify(products.value))
      console.log('💾 Products saved to localStorage')
    } catch (error) {
      console.error('❌ Failed to save products to localStorage:', error)
    }
  }

  const loadFromLocalStorage = () => {
    try {
      const savedProducts = localStorage.getItem('sirsandwich-products')
      if (savedProducts) {
        products.value = JSON.parse(savedProducts)
        console.log('📥 Products loaded from localStorage:', products.value.length, 'products')
      }
    } catch (error) {
      console.error('❌ Failed to load products from localStorage:', error)
    }
  }

  // Initialize products from localStorage on store creation
  if (typeof window !== 'undefined') {
    loadFromLocalStorage()
  }

  return {
    // State
    products,
    categories,
    selectedCategory,
    searchQuery,
    
    // Getters
    filteredProducts,
    categoryCount,
    productById,
    totalProducts,
    
    // Actions
    setCategory,
    setSearchQuery,
    clearFilters,
    addProduct,
    updateProduct,
    deleteProduct,
    updateStock,
    loadFromLocalStorage
  }
}) 