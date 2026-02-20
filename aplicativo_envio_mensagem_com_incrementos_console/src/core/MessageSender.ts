import { Message } from './Message';

export class MessageSender {
  public send(message: Message): void {
    const finalMessage = message.getContent();
    console.log(`Mensagem final: ${finalMessage}`);
    console.log('---');
  }
}