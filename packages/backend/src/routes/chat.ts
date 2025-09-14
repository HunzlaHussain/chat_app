import { Router } from 'express';
import { chatController } from '../controllers/chatController';

const router = Router();

// Chat routes
router.get('/rooms', chatController.getRooms);
router.post('/rooms', chatController.createRoom);
router.get('/rooms/:id/messages', chatController.getMessages);
router.post('/rooms/:id/messages', chatController.sendMessage);

export { router as chatRoutes };
