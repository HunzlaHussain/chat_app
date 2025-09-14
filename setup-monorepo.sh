#!/bin/bash

# Lerna Monorepo Setup Script
# This script creates a Lerna monorepo with frontend (Next.js) and backend (Node.js/Express) packages

set -e

echo "🚀 Setting up Lerna Monorepo with Frontend and Backend..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    print_error "Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    print_error "npm is not installed. Please install npm first."
    exit 1
fi

# Install Lerna globally if not already installed
if ! command -v lerna &> /dev/null; then
    print_status "Installing Lerna globally..."
    npm install -g lerna
    print_success "Lerna installed globally"
else
    print_success "Lerna is already installed"
fi

# Initialize Lerna workspace
print_status "Initializing Lerna workspace..."
lerna init --independent

# Create package.json for root
print_status "Creating root package.json..."
cat > package.json << 'EOF'
{
  "name": "chat-app-monorepo",
  "version": "1.0.0",
  "description": "A Lerna monorepo for chat application with Next.js frontend and Node.js backend",
  "private": true,
  "workspaces": [
    "packages/*"
  ],
  "scripts": {
    "bootstrap": "lerna bootstrap",
    "clean": "lerna clean",
    "build": "lerna run build",
    "dev": "lerna run dev --parallel",
    "test": "lerna run test",
    "lint": "lerna run lint",
    "frontend:dev": "cd packages/frontend && npm run dev",
    "backend:dev": "cd packages/backend && npm run dev",
    "frontend:build": "cd packages/frontend && npm run build",
    "backend:build": "cd packages/backend && npm run build"
  },
  "devDependencies": {
    "lerna": "^8.0.0"
  }
}
EOF

# Create packages directory
mkdir -p packages

# Setup Frontend Package (Next.js with all specified dependencies)
print_status "Setting up Frontend package (Next.js + Tailwind + Shadcn UI + Framer Motion + TanStack Query + React Hook Form)..."

mkdir -p packages/frontend
cd packages/frontend

# Initialize Next.js project
npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias "@/*" --yes

# Install additional dependencies
print_status "Installing frontend dependencies..."
npm install @tanstack/react-query @tanstack/react-query-devtools
npm install react-hook-form @hookform/resolvers zod
npm install framer-motion
npm install lucide-react class-variance-authority clsx tailwind-merge
npm install @radix-ui/react-slot

# Install Shadcn UI
npx shadcn-ui@latest init --yes

# Create frontend package.json with proper scripts
cat > package.json << 'EOF'
{
  "name": "@chat-app/frontend",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "next": "14.0.0",
    "react": "^18.0.0",
    "react-dom": "^18.0.0",
    "@tanstack/react-query": "^5.0.0",
    "@tanstack/react-query-devtools": "^5.0.0",
    "react-hook-form": "^7.0.0",
    "@hookform/resolvers": "^3.0.0",
    "zod": "^3.0.0",
    "framer-motion": "^10.0.0",
    "lucide-react": "^0.300.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.0.0",
    "tailwind-merge": "^2.0.0",
    "@radix-ui/react-slot": "^1.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/react": "^18.0.0",
    "@types/react-dom": "^18.0.0",
    "autoprefixer": "^10.0.0",
    "postcss": "^8.0.0",
    "tailwindcss": "^3.0.0",
    "eslint": "^8.0.0",
    "eslint-config-next": "14.0.0"
  }
}
EOF

# Create a basic layout with providers
mkdir -p src/app
cat > src/app/layout.tsx << 'EOF'
import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Providers } from './providers'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Chat App',
  description: 'A modern chat application',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Providers>
          {children}
        </Providers>
      </body>
    </html>
  )
}
EOF

# Create providers file
cat > src/app/providers.tsx << 'EOF'
'use client'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { ReactQueryDevtools } from '@tanstack/react-query-devtools'
import { useState } from 'react'

export function Providers({ children }: { children: React.ReactNode }) {
  const [queryClient] = useState(() => new QueryClient({
    defaultOptions: {
      queries: {
        staleTime: 60 * 1000,
      },
    },
  }))

  return (
    <QueryClientProvider client={queryClient}>
      {children}
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  )
}
EOF

# Create a basic home page
cat > src/app/page.tsx << 'EOF'
'use client'

import { motion } from 'framer-motion'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  message: z.string().min(1, 'Message is required'),
})

type FormData = z.infer<typeof schema>

export default function Home() {
  const { register, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema)
  })

  const onSubmit = (data: FormData) => {
    console.log('Message:', data.message)
  }

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 p-8">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="max-w-4xl mx-auto"
      >
        <h1 className="text-4xl font-bold text-gray-900 mb-8 text-center">
          Welcome to Chat App
        </h1>
        
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.5, delay: 0.2 }}
          className="bg-white rounded-lg shadow-lg p-6"
        >
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div>
              <label htmlFor="message" className="block text-sm font-medium text-gray-700 mb-2">
                Send a message
              </label>
              <input
                {...register('message')}
                type="text"
                id="message"
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                placeholder="Type your message here..."
              />
              {errors.message && (
                <p className="text-red-500 text-sm mt-1">{errors.message.message}</p>
              )}
            </div>
            <button
              type="submit"
              className="w-full bg-blue-600 text-white py-2 px-4 rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2 transition-colors"
            >
              Send Message
            </button>
          </form>
        </motion.div>
      </motion.div>
    </main>
  )
}
EOF

# Create components directory and a basic component
mkdir -p src/components/ui
cat > src/components/ui/button.tsx << 'EOF'
import * as React from "react"
import { Slot } from "@radix-ui/react-slot"
import { cva, type VariantProps } from "class-variance-authority"
import { cn } from "@/lib/utils"

const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        default: "bg-primary text-primary-foreground hover:bg-primary/90",
        destructive:
          "bg-destructive text-destructive-foreground hover:bg-destructive/90",
        outline:
          "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary:
          "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      size: {
        default: "h-10 px-4 py-2",
        sm: "h-9 rounded-md px-3",
        lg: "h-11 rounded-md px-8",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "default",
      size: "default",
    },
  }
)

export interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {
  asChild?: boolean
}

const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant, size, asChild = false, ...props }, ref) => {
    const Comp = asChild ? Slot : "button"
    return (
      <Comp
        className={cn(buttonVariants({ variant, size, className }))}
        ref={ref}
        {...props}
      />
    )
  }
)
Button.displayName = "Button"

export { Button, buttonVariants }
EOF

# Create utils file
mkdir -p src/lib
cat > src/lib/utils.ts << 'EOF'
import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}
EOF

print_success "Frontend package created successfully"

# Go back to root and setup Backend Package
cd ../..

# Setup Backend Package (Node.js + Express + TypeScript + TypeORM)
print_status "Setting up Backend package (Node.js + Express + TypeScript + TypeORM)..."

mkdir -p packages/backend
cd packages/backend

# Initialize npm package
npm init -y

# Install dependencies
print_status "Installing backend dependencies..."
npm install express cors helmet morgan dotenv
npm install typeorm reflect-metadata
npm install mysql2  # or pg for PostgreSQL, sqlite3 for SQLite
npm install bcryptjs jsonwebtoken
npm install socket.io

# Install dev dependencies
npm install -D typescript @types/node @types/express @types/cors @types/morgan @types/bcryptjs @types/jsonwebtoken
npm install -D ts-node nodemon @typescript-eslint/eslint-plugin @typescript-eslint/parser eslint
npm install -D jest @types/jest ts-jest supertest @types/supertest

# Create backend package.json
cat > package.json << 'EOF'
{
  "name": "@chat-app/backend",
  "version": "1.0.0",
  "description": "Backend API for chat application",
  "main": "dist/index.js",
  "scripts": {
    "dev": "nodemon src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint src/**/*.ts",
    "lint:fix": "eslint src/**/*.ts --fix",
    "type-check": "tsc --noEmit"
  },
  "dependencies": {
    "express": "^4.18.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "morgan": "^1.10.0",
    "dotenv": "^16.0.0",
    "typeorm": "^0.3.17",
    "reflect-metadata": "^0.1.13",
    "mysql2": "^3.6.0",
    "bcryptjs": "^2.4.3",
    "jsonwebtoken": "^9.0.0",
    "socket.io": "^4.7.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "@types/node": "^20.0.0",
    "@types/express": "^4.17.0",
    "@types/cors": "^2.8.0",
    "@types/morgan": "^1.9.0",
    "@types/bcryptjs": "^2.4.0",
    "@types/jsonwebtoken": "^9.0.0",
    "ts-node": "^10.9.0",
    "nodemon": "^3.0.0",
    "@typescript-eslint/eslint-plugin": "^6.0.0",
    "@typescript-eslint/parser": "^6.0.0",
    "eslint": "^8.0.0",
    "jest": "^29.0.0",
    "@types/jest": "^29.0.0",
    "ts-jest": "^29.0.0",
    "supertest": "^6.0.0",
    "@types/supertest": "^2.0.0"
  }
}
EOF

# Create TypeScript configuration
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "lib": ["ES2020"],
    "outDir": "./dist",
    "rootDir": "./src",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "experimentalDecorators": true,
    "emitDecoratorMetadata": true,
    "strictPropertyInitialization": false
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist", "**/*.test.ts"]
}
EOF

# Create nodemon configuration
cat > nodemon.json << 'EOF'
{
  "watch": ["src"],
  "ext": "ts,json",
  "ignore": ["src/**/*.test.ts"],
  "exec": "ts-node src/index.ts"
}
EOF

# Create ESLint configuration
cat > .eslintrc.js << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
  ],
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  rules: {
    '@typescript-eslint/no-unused-vars': ['error', { argsIgnorePattern: '^_' }],
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
  },
};
EOF

# Create Jest configuration
cat > jest.config.js << 'EOF'
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src'],
  testMatch: ['**/__tests__/**/*.ts', '**/?(*.)+(spec|test).ts'],
  transform: {
    '^.+\\.ts$': 'ts-jest',
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
    '!src/**/*.spec.ts',
  ],
};
EOF

# Create source directory structure
mkdir -p src/{controllers,services,entities,repositories,middleware,routes,config,types}

# Create main entry point
cat > src/index.ts << 'EOF'
import 'reflect-metadata';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import { createConnection } from 'typeorm';
import { createServer } from 'http';
import { Server } from 'socket.io';

import { errorHandler } from './middleware/errorHandler';
import { authRoutes } from './routes/auth';
import { chatRoutes } from './routes/chat';

// Load environment variables
dotenv.config();

const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: process.env.FRONTEND_URL || 'http://localhost:3000',
    methods: ['GET', 'POST']
  }
});

const PORT = process.env.PORT || 5000;

// Middleware
app.use(helmet());
app.use(cors({
  origin: process.env.FRONTEND_URL || 'http://localhost:3000',
  credentials: true
}));
app.use(morgan('combined'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Database connection
createConnection()
  .then(() => {
    console.log('✅ Database connected successfully');
  })
  .catch((error) => {
    console.error('❌ Database connection failed:', error);
    process.exit(1);
  });

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/chat', chatRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Socket.io connection handling
io.on('connection', (socket) => {
  console.log('User connected:', socket.id);
  
  socket.on('join-room', (roomId: string) => {
    socket.join(roomId);
    console.log(`User ${socket.id} joined room ${roomId}`);
  });
  
  socket.on('send-message', (data: { roomId: string; message: string; userId: string }) => {
    socket.to(data.roomId).emit('receive-message', {
      ...data,
      timestamp: new Date().toISOString()
    });
  });
  
  socket.on('disconnect', () => {
    console.log('User disconnected:', socket.id);
  });
});

// Error handling middleware
app.use(errorHandler);

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ message: 'Route not found' });
});

server.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📱 Frontend URL: ${process.env.FRONTEND_URL || 'http://localhost:3000'}`);
  console.log(`🔗 API URL: http://localhost:${PORT}`);
});

export { io };
EOF

# Create error handler middleware
cat > src/middleware/errorHandler.ts << 'EOF'
import { Request, Response, NextFunction } from 'express';

export interface AppError extends Error {
  statusCode?: number;
  isOperational?: boolean;
}

export const errorHandler = (
  err: AppError,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  console.error('Error:', {
    message: err.message,
    stack: err.stack,
    statusCode,
    url: req.url,
    method: req.method,
  });

  res.status(statusCode).json({
    success: false,
    message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack }),
  });
};
EOF

# Create auth routes
cat > src/routes/auth.ts << 'EOF'
import { Router } from 'express';
import { authController } from '../controllers/authController';

const router = Router();

// Auth routes
router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/logout', authController.logout);
router.get('/me', authController.getProfile);

export { router as authRoutes };
EOF

# Create chat routes
cat > src/routes/chat.ts << 'EOF'
import { Router } from 'express';
import { chatController } from '../controllers/chatController';

const router = Router();

// Chat routes
router.get('/rooms', chatController.getRooms);
router.post('/rooms', chatController.createRoom);
router.get('/rooms/:id/messages', chatController.getMessages);
router.post('/rooms/:id/messages', chatController.sendMessage);

export { router as chatRoutes };
EOF

# Create auth controller
cat > src/controllers/authController.ts << 'EOF'
import { Request, Response } from 'express';
import { authService } from '../services/authService';

export const authController = {
  async register(req: Request, res: Response) {
    try {
      const { username, email, password } = req.body;
      
      if (!username || !email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Username, email, and password are required'
        });
      }

      const user = await authService.register({ username, email, password });
      
      res.status(201).json({
        success: true,
        message: 'User registered successfully',
        data: { user }
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  },

  async login(req: Request, res: Response) {
    try {
      const { email, password } = req.body;
      
      if (!email || !password) {
        return res.status(400).json({
          success: false,
          message: 'Email and password are required'
        });
      }

      const result = await authService.login(email, password);
      
      res.json({
        success: true,
        message: 'Login successful',
        data: result
      });
    } catch (error: any) {
      res.status(401).json({
        success: false,
        message: error.message
      });
    }
  },

  async logout(req: Request, res: Response) {
    // In a real app, you might want to blacklist the token
    res.json({
      success: true,
      message: 'Logout successful'
    });
  },

  async getProfile(req: Request, res: Response) {
    try {
      // This would typically get user from JWT token
      res.json({
        success: true,
        message: 'Profile retrieved successfully',
        data: { user: 'User profile data' }
      });
    } catch (error: any) {
      res.status(401).json({
        success: false,
        message: error.message
      });
    }
  }
};
EOF

# Create chat controller
cat > src/controllers/chatController.ts << 'EOF'
import { Request, Response } from 'express';
import { chatService } from '../services/chatService';

export const chatController = {
  async getRooms(req: Request, res: Response) {
    try {
      const rooms = await chatService.getRooms();
      res.json({
        success: true,
        data: rooms
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  },

  async createRoom(req: Request, res: Response) {
    try {
      const { name, description } = req.body;
      const room = await chatService.createRoom({ name, description });
      
      res.status(201).json({
        success: true,
        message: 'Room created successfully',
        data: room
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  },

  async getMessages(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const messages = await chatService.getMessages(id);
      
      res.json({
        success: true,
        data: messages
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        message: error.message
      });
    }
  },

  async sendMessage(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const { content, userId } = req.body;
      
      const message = await chatService.sendMessage({
        roomId: id,
        content,
        userId
      });
      
      res.status(201).json({
        success: true,
        message: 'Message sent successfully',
        data: message
      });
    } catch (error: any) {
      res.status(400).json({
        success: false,
        message: error.message
      });
    }
  }
};
EOF

# Create auth service
cat > src/services/authService.ts << 'EOF'
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { userRepository } from '../repositories/userRepository';

export const authService = {
  async register({ username, email, password }: { username: string; email: string; password: string }) {
    // Check if user already exists
    const existingUser = await userRepository.findByEmail(email);
    if (existingUser) {
      throw new Error('User with this email already exists');
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 12);

    // Create user
    const user = await userRepository.create({
      username,
      email,
      password: hashedPassword
    });

    // Generate JWT token
    const token = jwt.sign(
      { userId: user.id, email: user.email },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '7d' }
    );

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      },
      token
    };
  },

  async login(email: string, password: string) {
    // Find user by email
    const user = await userRepository.findByEmail(email);
    if (!user) {
      throw new Error('Invalid credentials');
    }

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      throw new Error('Invalid credentials');
    }

    // Generate JWT token
    const token = jwt.sign(
      { userId: user.id, email: user.email },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '7d' }
    );

    return {
      user: {
        id: user.id,
        username: user.username,
        email: user.email
      },
      token
    };
  }
};
EOF

# Create chat service
cat > src/services/chatService.ts << 'EOF'
import { roomRepository } from '../repositories/roomRepository';
import { messageRepository } from '../repositories/messageRepository';

export const chatService = {
  async getRooms() {
    return await roomRepository.findAll();
  },

  async createRoom({ name, description }: { name: string; description?: string }) {
    return await roomRepository.create({ name, description });
  },

  async getMessages(roomId: string) {
    return await messageRepository.findByRoomId(roomId);
  },

  async sendMessage({ roomId, content, userId }: { roomId: string; content: string; userId: string }) {
    return await messageRepository.create({
      roomId,
      content,
      userId
    });
  }
};
EOF

# Create user repository
cat > src/repositories/userRepository.ts << 'EOF'
import { User } from '../entities/User';

// Mock implementation - replace with actual TypeORM repository
export const userRepository = {
  async findByEmail(email: string): Promise<User | null> {
    // Mock implementation
    return null;
  },

  async create(userData: Partial<User>): Promise<User> {
    // Mock implementation
    return {
      id: '1',
      username: userData.username || '',
      email: userData.email || '',
      password: userData.password || '',
      createdAt: new Date(),
      updatedAt: new Date()
    } as User;
  }
};
EOF

# Create room repository
cat > src/repositories/roomRepository.ts << 'EOF'
import { Room } from '../entities/Room';

// Mock implementation - replace with actual TypeORM repository
export const roomRepository = {
  async findAll(): Promise<Room[]> {
    // Mock implementation
    return [
      {
        id: '1',
        name: 'General',
        description: 'General chat room',
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ];
  },

  async create(roomData: Partial<Room>): Promise<Room> {
    // Mock implementation
    return {
      id: '2',
      name: roomData.name || '',
      description: roomData.description || '',
      createdAt: new Date(),
      updatedAt: new Date()
    } as Room;
  }
};
EOF

# Create message repository
cat > src/repositories/messageRepository.ts << 'EOF'
import { Message } from '../entities/Message';

// Mock implementation - replace with actual TypeORM repository
export const messageRepository = {
  async findByRoomId(roomId: string): Promise<Message[]> {
    // Mock implementation
    return [
      {
        id: '1',
        content: 'Hello world!',
        userId: '1',
        roomId,
        createdAt: new Date(),
        updatedAt: new Date()
      }
    ];
  },

  async create(messageData: Partial<Message>): Promise<Message> {
    // Mock implementation
    return {
      id: '2',
      content: messageData.content || '',
      userId: messageData.userId || '',
      roomId: messageData.roomId || '',
      createdAt: new Date(),
      updatedAt: new Date()
    } as Message;
  }
};
EOF

# Create User entity
cat > src/entities/User.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  username: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# Create Room entity
cat > src/entities/Room.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('rooms')
export class Room {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  description?: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# Create Message entity
cat > src/entities/Message.ts << 'EOF'
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { User } from './User';
import { Room } from './Room';

@Entity('messages')
export class Message {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('text')
  content: string;

  @Column()
  userId: string;

  @Column()
  roomId: string;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'userId' })
  user: User;

  @ManyToOne(() => Room)
  @JoinColumn({ name: 'roomId' })
  room: Room;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
EOF

# Create environment file
cat > .env.example << 'EOF'
# Database
DB_HOST=localhost
DB_PORT=3306
DB_USERNAME=root
DB_PASSWORD=password
DB_DATABASE=chat_app

# JWT
JWT_SECRET=your-super-secret-jwt-key

# Server
PORT=5000
NODE_ENV=development

# Frontend
FRONTEND_URL=http://localhost:3000
EOF

print_success "Backend package created successfully"

# Go back to root
cd ../..

# Create lerna.json configuration
print_status "Configuring Lerna..."
cat > lerna.json << 'EOF'
{
  "version": "independent",
  "npmClient": "npm",
  "command": {
    "bootstrap": {
      "ignore": "npm-*",
      "npmClientArgs": ["--no-package-lock"]
    },
    "publish": {
      "conventionalCommits": true,
      "message": "chore(release): publish"
    }
  },
  "packages": ["packages/*"]
}
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Production builds
dist/
build/
.next/

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db

# Logs
logs
*.log

# Runtime data
pids
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/

# TypeScript cache
*.tsbuildinfo

# Optional npm cache directory
.npm

# Optional eslint cache
.eslintcache

# Lerna
lerna-debug.log
EOF

# Create README
cat > README.md << 'EOF'
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
EOF

# Install dependencies and bootstrap
print_status "Installing dependencies and bootstrapping packages..."
npm install
lerna bootstrap

print_success "🎉 Lerna monorepo setup completed successfully!"
print_status "📁 Project structure created:"
print_status "  ├── packages/frontend/ (Next.js + Tailwind + Shadcn UI + Framer Motion + TanStack Query + React Hook Form)"
print_status "  └── packages/backend/ (Node.js + Express + TypeScript + TypeORM)"
print_status ""
print_status "🚀 To start development:"
print_status "  npm run dev"
print_status ""
print_status "📖 For more information, see README.md"
print_status ""
print_warning "⚠️  Don't forget to:"
print_warning "  1. Set up your database and update packages/backend/.env"
print_warning "  2. Configure your database connection in the backend"
print_warning "  3. Run 'npm run bootstrap' if you encounter any dependency issues"
