import { Message } from '../core/Message';
import { MessageSender } from '../core/MessageSender';
import { InputReader } from '../utils/InputReader';
import { TimestampStrategy } from '../strategies/TimestampStrategy';
import { UppercaseStrategy } from '../strategies/UppercaseStrategy';
import { PriorityStrategy } from '../strategies/PriorityStrategy';

export class MessageApp {
  private inputReader: InputReader;
  private messageSender: MessageSender;

  constructor() {
    this.inputReader = new InputReader();
    this.messageSender = new MessageSender();
  }

  public async run(): Promise<void> {
    console.log('=== Sistema de Mensagens Decoradas (TypeScript) ===');
    console.log('Comandos:\n\n-> enviar <mensagem> \n-> sair');

    while (true) {
      const command = await this.inputReader.question('> ');

      if (command === 'sair') {
        console.log('Saindo do sistema...');
        break;
      }

      if (command.startsWith('enviar ')) {
        await this.handleSendCommand(command);
      } else {
        console.log('Comando inválido. Use: enviar "<mensagem>" ou sair');
      }
    }

    this.inputReader.close();
  }

  private async handleSendCommand(command: string): Promise<void> {
    const originalMessage = command.substring(7).trim();
    
    if (!originalMessage) {
        console.log('Por favor, digite uma mensagem. Use: enviar <sua mensagem>');
        return;
    }

    const message = new Message(originalMessage);

    const applyTimestamp = await this.inputReader.question('Aplicar timestamp? (s/n) ');
    if (applyTimestamp === 's') {
      message.addStrategy(new TimestampStrategy());
    }

    const applyUppercase = await this.inputReader.question('Transformar em maiúsculas? (s/n) ');
    if (applyUppercase === 's') {
      message.addStrategy(new UppercaseStrategy());
    }

    const applyPriority = await this.inputReader.question('Adicionar prioridade? (s/n) ');
    if (applyPriority === 's') {
      message.addStrategy(new PriorityStrategy());
    }

    this.messageSender.send(message);
  }
}