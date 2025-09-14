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
