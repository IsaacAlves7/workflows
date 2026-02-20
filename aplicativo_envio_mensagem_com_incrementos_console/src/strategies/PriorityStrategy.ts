import { MessageStrategy } from './MessageStrategy';

export class PriorityStrategy implements MessageStrategy {
  apply(content: string): string {
    return `IPRIORIDADE ${content}`;
  }
}