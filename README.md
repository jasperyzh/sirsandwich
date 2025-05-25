# 🥪 Sirsandwich Shop - Modern E-commerce Platform

A modern, high-performance e-commerce platform built with cutting-edge web technologies, serving as a storefront for a premium sandwich shop.

## 🚀 Current Status: Phase 3 Complete

### ✅ What's Been Implemented (Phases 1-3)

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

### 🛠️ Tech Stack

- **Frontend Framework**: Astro.js (Static Site Generation) + Vue.js 3 (Interactivity)
- **UI Components**: Vue.js with Composition API
- **Styling**: Tailwind CSS (Utility-first CSS framework)
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
│   ├── index.astro          # Home page
│   ├── about.astro          # About page
│   ├── products.astro       # Menu/Products page
│   ├── contact.astro        # Contact page
│   └── order.astro          # Order page (placeholder)
├── styles/
│   └── global.css           # Global Tailwind CSS
└── components/              # Future Vue.js components
```

## 🎯 Next Steps (Phase 4)

The next phase will focus on backend integration and authentication:

- [ ] Integrate Supabase for backend services
- [ ] Add user authentication (sign up, login, logout)
- [ ] Replace localStorage with Supabase database
- [ ] Implement Row Level Security (RLS) policies
- [ ] Add file upload for product images
- [ ] Create order management system

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

## 🔮 Future Phases

- **Phase 4**: Backend integration with Supabase
- **Phase 5**: E-commerce functionality and deployment

## 🤝 Contributing

This is a learning project following the comprehensive roadmap in `brief.md`. Each phase builds upon the previous one to create a complete e-commerce platform.

## 📝 License

This project is for educational purposes as part of a full-stack development learning journey.

---

**Current Phase**: 3/5 - ✅ State Management with Pinia and CRUD Operations Complete
**Next Milestone**: Backend Integration with Supabase

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
