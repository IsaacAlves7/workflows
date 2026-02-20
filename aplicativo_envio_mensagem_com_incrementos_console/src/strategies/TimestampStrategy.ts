import { MessageStrategy } from './MessageStrategy';

export class TimestampStrategy implements MessageStrategy {
  apply(content: string): string {
    const now = new Date();
    const timeString = now.toLocaleTimeString('pt-BR', { 
      hour: '2-digit', 
      minute: '2-digit', 
      second: '2-digit' 
    });
    return `[${timeString}] ${content}`;
  }
}