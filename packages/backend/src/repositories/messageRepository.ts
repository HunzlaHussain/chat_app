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
