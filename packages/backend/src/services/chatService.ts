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
