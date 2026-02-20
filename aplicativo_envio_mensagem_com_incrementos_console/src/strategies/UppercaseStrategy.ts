import { MessageStrategy } from './MessageStrategy';

export class UppercaseStrategy implements MessageStrategy {
  apply(content: string): string {
    return content.toUpperCase();
  }
}