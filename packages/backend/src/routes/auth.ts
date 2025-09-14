import { Router } from 'express';
import { authController } from '../controllers/authController';

const router = Router();

// Auth routes
router.post('/register', authController.register);
router.post('/login', authController.login);
router.post('/logout', authController.logout);
router.get('/me', authController.getProfile);

export { router as authRoutes };
