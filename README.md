# 🥪 Sirsandwich Shop - Modern E-commerce Platform

A modern, high-performance e-commerce platform built with cutting-edge web technologies, serving as a storefront for a premium sandwich shop.

## 🚀 Current Status: Phase 2 Complete

### ✅ What's Been Implemented (Phases 1-2)

- **Modern Tech Stack Setup**: Astro.js + Vue.js + Tailwind CSS
- **Responsive Design**: Mobile-first, beautiful UI
- **Multi-page Architecture**: 
  - Home page with hero section and features
  - About page with company story and team
  - **Interactive Products page** with Vue.js product cards
  - **Interactive Contact page** with real-time form validation
  - Order page placeholder for future development
- **Vue.js Interactive Components**:
  - `ProductCard.vue` - Interactive product display with details toggle and mock cart
  - `ContactForm.vue` - Real-time form validation and submission simulation
  - `CategoryFilter.vue` - Visual category filtering with product counts
- **Enhanced User Experience**: Hover effects, loading states, visual feedback

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

## 🎯 Next Steps (Phase 3)

The next phase will focus on state management and data persistence:

- [ ] Add Pinia for global state management
- [ ] Implement shopping cart with localStorage persistence
- [ ] Add real product filtering functionality
- [ ] Create user session management
- [ ] Build admin interface for product management

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

## 🔮 Future Phases

- **Phase 2**: Vue.js integration and interactivity
- **Phase 3**: State management with Pinia
- **Phase 4**: Backend integration with Supabase
- **Phase 5**: E-commerce functionality and deployment

## 🤝 Contributing

This is a learning project following the comprehensive roadmap in `brief.md`. Each phase builds upon the previous one to create a complete e-commerce platform.

## 📝 License

This project is for educational purposes as part of a full-stack development learning journey.

---

**Current Phase**: 2/5 - ✅ Vue.js Integration and Interactive Components Complete
**Next Milestone**: State Management with Pinia and Data Persistence

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
