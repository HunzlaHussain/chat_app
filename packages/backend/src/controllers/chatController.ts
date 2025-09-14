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
