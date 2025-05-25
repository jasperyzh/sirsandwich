# 🥪 Sirsandwich Shop - Modern E-commerce Platform

A modern, high-performance e-commerce platform built with cutting-edge web technologies, serving as a storefront for a premium sandwich shop.

## 🚀 Current Status: Phase 5 In Progress

### ✅ What's Been Implemented (Phases 1-5)

- **Modern Tech Stack Setup**: Astro.js + Vue.js + Tailwind CSS + Pinia
- **Responsive Design**: Mobile-first, beautiful UI
- **Multi-page Architecture**: 
  - Home page with hero section and features
  - About page with company story and team
  - **Interactive Products page** with real shopping cart and filtering
  - **Interactive Contact page** with real-time form validation
  - **Admin Dashboard** with full CRUD operations
  - Order page placeholder for future development
- **State Management with Pinia**:
  - `cartStore.js` - Shopping cart with localStorage persistence
  - `productsStore.js` - Product management and filtering logic
- **Vue.js Interactive Components**:
  - `ProductCard.vue` - Interactive product display with real cart integration
  - `ContactForm.vue` - Real-time form validation and submission simulation
  - `CategoryFilter.vue` - Real category filtering using Pinia store
  - `SearchBar.vue` - Live product search functionality
  - `ShoppingCart.vue` - Full shopping cart with quantity management
  - `ProductsGrid.vue` - Dynamic product display with filtering
  - `AdminDashboard.vue` - Complete CRUD interface for product management
- **Enhanced User Experience**: Real cart functionality, live search, persistent data
- **Phase 4 - Backend Integration (Complete)**:
  - ✅ **Supabase Setup**: Client configuration and environment setup
  - ✅ **Database Schema**: PostgreSQL tables with RLS policies
  - ✅ **Authentication System**: Complete user auth with Pinia store
  - ✅ **Auth Components**: Login/signup forms and user profile management
  - ✅ **Real User Accounts**: Live admin and customer accounts with role-based permissions
  - ✅ **Admin Dashboard Integration**: Connected to real Supabase database
  - ✅ **Contact Form Integration**: Form connected to Supabase (RLS issue pending)
  - ⚠️ **Known Issue**: Contact form RLS policy needs refinement (documented for future learning)
- **Phase 5 - E-commerce Functionality (In Progress)**:
  - ✅ **Shopping Cart Persistence**: Database-backed cart for authenticated users
  - ✅ **Checkout System**: Complete order placement workflow with validation
  - ✅ **Order Management**: User order history and tracking interface
  - ✅ **Email Notifications**: Order confirmation emails via serverless functions
  - ✅ **Payment UI**: Credit card and cash on delivery options
  - 🔄 **Pending**: File upload integration (Supabase Storage)
  - 🔄 **Pending**: Live payment processing (Stripe integration)
  - 🔄 **Pending**: Production deployment (Vercel)

### 🛠️ Tech Stack

- **Frontend Framework**: Astro.js (Static Site Generation) + Vue.js 3 (Interactivity)
- **UI Components**: Vue.js with Composition API
- **Styling**: Tailwind CSS (Utility-first CSS framework)
- **Backend Services**: Supabase (PostgreSQL, Auth, Real-time)
- **State Management**: Pinia (Vue.js store)
- **Development**: Node.js, npm
- **Version Control**: Git

## 🏗️ Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd proto-sandwichshop
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open your browser and visit `http://localhost:4321`

### Available Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run preview` - Preview production build locally

## 📁 Project Structure

```
src/
├── layouts/
│   └── Layout.astro          # Base layout component
├── pages/
│   ├── index.astro          # Home page with admin link
│   ├── about.astro          # About page
│   ├── products.astro       # Interactive menu with cart and filtering
│   ├── contact.astro        # Contact page with Vue form
│   ├── admin.astro          # Admin dashboard for CRUD operations
│   └── order.astro          # Order page (placeholder)
├── components/              # Vue.js components
│   ├── ProductCard.vue      # Interactive product display with cart
│   ├── ContactForm.vue      # Real-time form validation
│   ├── CategoryFilter.vue   # Product category filtering
│   ├── SearchBar.vue        # Live product search
│   ├── ShoppingCart.vue     # Complete cart interface
│   ├── ProductsGrid.vue     # Dynamic product rendering
│   └── AdminDashboard.vue   # Full CRUD admin interface
├── stores/                  # Pinia state management
│   ├── pinia.js            # Pinia setup and exports
│   ├── cartStore.js        # Shopping cart state
│   ├── productsStore.js    # Products and filtering state
│   └── authStore.js        # Authentication and user state
├── styles/
│   └── global.css           # Global Tailwind CSS
├── lib/
│   └── supabase.js         # Supabase client configuration
└── docs/                    # Documentation and SQL scripts
    ├── phase1.md           # Phase 1 development log
    ├── phase2.md           # Phase 2 development log
    ├── phase3.md           # Phase 3 development log
    ├── supabase-setup.md   # Supabase setup guide
    ├── database-schema.sql # Database schema and RLS policies
    ├── email-templates.md  # Authentication email templates
    └── contact-form-troubleshooting.md # RLS troubleshooting guide
```

## 🎯 Current Phase 5 Progress

E-commerce functionality and deployment:

- [x] **Shopping Cart Enhancement**: Database persistence for authenticated users
- [x] **Checkout System**: Complete order placement workflow
- [x] **Order Management**: User order history and tracking
- [x] **Email Notifications**: Order confirmation emails via serverless functions
- [x] **Payment UI**: Credit card and cash on delivery interfaces
- [x] **Navigation Updates**: Checkout and orders page integration
- [ ] **File Upload Integration**: Supabase Storage for product images
- [ ] **Live Payment Processing**: Stripe integration with webhooks
- [ ] **Production Deployment**: Vercel deployment with environment management

## 🚨 Known Issues & Learning Notes

### Contact Form RLS Policy Issue
**Status**: Documented for future learning  
**Error**: `403 Forbidden - new row violates row-level security policy for table "contact_messages"`

**What we learned:**
- RLS policies can be complex and require careful permission management
- Anonymous users (`anon` role) need explicit INSERT permissions
- Schema permissions must be granted before table permissions
- Multiple solutions exist but require deeper PostgreSQL/RLS understanding

**Resources created:**
- `docs/fix-contact-rls-final.sql` - Comprehensive fix script
- `docs/contact-form-troubleshooting.md` - Detailed troubleshooting guide
- Multiple Stack Overflow solutions researched and documented

**Next steps**: Return to this issue after gaining more RLS experience in Phase 5

## 📋 Learning Objectives Completed

**Phase 1:**
- [x] **Astro Basics**: Project setup, routing, layouts, components
- [x] **Tailwind CSS**: Responsive design, utility classes, component styling
- [x] **Static Site Generation**: Multi-page static website
- [x] **Project Structure**: Organized, scalable folder structure
- [x] **Git Workflow**: Version control setup

**Phase 2:**
- [x] **Vue.js Fundamentals**: Components, props, reactivity, lifecycle hooks
- [x] **Astro Islands**: Vue component integration with `client:visible`
- [x] **Component Communication**: Props, events, and data flow
- [x] **Interactive Elements**: Forms, buttons, toggles, and user feedback
- [x] **State Management**: Using `ref()`, `reactive()`, and `computed()`

**Phase 3:**
- [x] **Pinia State Management**: Global stores for cart and products
- [x] **Data Persistence**: localStorage integration for cart and product data
- [x] **CRUD Operations**: Full Create, Read, Update, Delete functionality
- [x] **Real-time Filtering**: Dynamic product filtering and search
- [x] **Shopping Cart**: Complete cart functionality with quantity management
- [x] **Admin Interface**: Product management dashboard with form validation

**Phase 4 (In Progress):**
- [x] **Supabase Integration**: Backend services setup and configuration
- [x] **PostgreSQL Database**: Schema design with tables and relationships
- [x] **Authentication System**: Complete user auth with role-based permissions
- [x] **Row Level Security**: RLS policies for data protection (learning in progress)
- [x] **Real Database Operations**: Admin dashboard connected to Supabase
- [x] **User Management**: Live accounts with admin/customer roles
- [x] **State Management Evolution**: Pinia stores enhanced for backend integration

## 🔮 Future Phases

- **Phase 4**: Backend integration with Supabase (95% complete - RLS learning pending)
- **Phase 5**: E-commerce functionality, file uploads, and deployment

## 🤝 Contributing

This is a learning project following the comprehensive roadmap in `brief.md`. Each phase builds upon the previous one to create a complete e-commerce platform.

## 📝 License

This project is for educational purposes as part of a full-stack development learning journey.

---

**Current Phase**: 5/5 - 🔄 E-commerce Functionality (85% Complete)
**Next Milestone**: Production deployment with live payment processing and file uploads

```sh
npm create astro@latest -- --template minimal
```

[![Open in StackBlitz](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/github/withastro/astro/tree/latest/examples/minimal)
[![Open with CodeSandbox](https://assets.codesandbox.io/github/button-edit-lime.svg)](https://codesandbox.io/p/sandbox/github/withastro/astro/tree/latest/examples/minimal)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/withastro/astro?devcontainer_path=.devcontainer/minimal/devcontainer.json)

> 🧑‍🚀 **Seasoned astronaut?** Delete this file. Have fun!

## 🚀 Project Structure

Inside of your Astro project, you'll see the following folders and files:

```text
/
├── public/
├── src/
│   └── pages/
│       └── index.astro
└── package.json
```

Astro looks for `.astro` or `.md` files in the `src/pages/` directory. Each page is exposed as a route based on its file name.

There's nothing special about `src/components/`, but that's where we like to put any Astro/React/Vue/Svelte/Preact components.

Any static assets, like images, can be placed in the `public/` directory.

## 🧞 Commands

All commands are run from the root of the project, from a terminal:

| Command                   | Action                                           |
| :------------------------ | :----------------------------------------------- |
| `npm install`             | Installs dependencies                            |
| `npm run dev`             | Starts local dev server at `localhost:4321`      |
| `npm run build`           | Build your production site to `./dist/`          |
| `npm run preview`         | Preview your build locally, before deploying     |
| `npm run astro ...`       | Run CLI commands like `astro add`, `astro check` |
| `npm run astro -- --help` | Get help using the Astro CLI                     |

## 👀 Want to learn more?

Feel free to check [our documentation](https://docs.astro.build) or jump into our [Discord server](https://astro.build/chat).
