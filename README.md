# Chat App Monorepo

A modern chat application built with a Lerna monorepo structure.

## 🏗️ Architecture

- **Frontend**: Next.js 14 with TypeScript, Tailwind CSS, Shadcn UI, Framer Motion, TanStack Query, and React Hook Form
- **Backend**: Node.js with Express, TypeScript, and TypeORM
- **Monorepo**: Lerna for package management

## 📦 Packages

- `@chat-app/frontend` - Next.js frontend application
- `@chat-app/backend` - Node.js backend API

## 🚀 Getting Started

### Prerequisites

- Node.js 18+ 
- npm or yarn
- MySQL/PostgreSQL (for backend)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   npm run bootstrap
   ```

3. Set up environment variables:
   ```bash
   cp packages/backend/.env.example packages/backend/.env
   # Edit the .env file with your database credentials
   ```

4. Start development servers:
   ```bash
   npm run dev
   ```

This will start both frontend (http://localhost:3000) and backend (http://localhost:5000) in parallel.

### Individual Package Commands

#### Frontend
```bash
npm run frontend:dev    # Start frontend development server
npm run frontend:build  # Build frontend for production
```

#### Backend
```bash
npm run backend:dev     # Start backend development server
npm run backend:build   # Build backend for production
```

## 🛠️ Development

### Available Scripts

- `npm run bootstrap` - Install dependencies for all packages
- `npm run dev` - Start all packages in development mode
- `npm run build` - Build all packages
- `npm run test` - Run tests for all packages
- `npm run lint` - Lint all packages
- `npm run clean` - Clean all packages

### Package Management

This monorepo uses Lerna for package management. You can:

- Add dependencies to specific packages: `lerna add <package> --scope=@chat-app/frontend`
- Run commands in specific packages: `lerna run dev --scope=@chat-app/backend`
- Publish packages: `lerna publish`

## 🏛️ Project Structure

```
chat-app-monorepo/
├── packages/
│   ├── frontend/          # Next.js frontend
│   │   ├── src/
│   │   │   ├── app/       # Next.js app directory
│   │   │   ├── components/ # React components
│   │   │   └── lib/       # Utility functions
│   │   └── package.json
│   └── backend/           # Node.js backend
│       ├── src/
│       │   ├── controllers/ # Route controllers
│       │   ├── services/    # Business logic
│       │   ├── entities/    # TypeORM entities
│       │   ├── repositories/ # Data access layer
│       │   ├── middleware/   # Express middleware
│       │   └── routes/       # API routes
│       └── package.json
├── lerna.json             # Lerna configuration
└── package.json           # Root package.json
```

## 🔧 Technologies Used

### Frontend
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type safety
- **Tailwind CSS** - Utility-first CSS framework
- **Shadcn UI** - Beautiful, accessible components
- **Framer Motion** - Animation library
- **TanStack Query** - Data fetching and caching
- **React Hook Form** - Form handling with validation

### Backend
- **Node.js** - JavaScript runtime
- **Express.js** - Web framework
- **TypeScript** - Type safety
- **TypeORM** - Object-relational mapping
- **Socket.io** - Real-time communication
- **JWT** - Authentication
- **bcryptjs** - Password hashing

## 📝 License

MIT
