export interface MessageStrategy {
  apply(content: string): string;
}