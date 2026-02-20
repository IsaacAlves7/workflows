import { MessageStrategy } from '../strategies/MessageStrategy';

export class Message {
  constructor(
    private content: string,
    private strategies: MessageStrategy[] = []
  ) {}

  public addStrategy(strategy: MessageStrategy): void {
    this.strategies.push(strategy);
  }

  public getContent(): string {
    let decoratedContent = this.content;
    
    for (const strategy of this.strategies) {
      decoratedContent = strategy.apply(decoratedContent);
    }
    
    return decoratedContent;
  }

  public getOriginalContent(): string {
    return this.content;
  }
}