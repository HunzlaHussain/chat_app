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
