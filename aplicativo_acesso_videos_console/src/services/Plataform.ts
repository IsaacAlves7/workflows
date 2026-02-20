import { User } from '../models/User';
import { Video } from '../models/Video';
import { ProxyVideo } from '../proxy/ProxyVideo';
import * as readline from 'readline';

export class Platform {
  private currentUser: User | null = null;
  private videos: Video[] = [
    new Video('Introdução ao TypeScript', 'gratuito'),
    new Video('Padrões de Projeto Avançados', 'premium'),
    new Video('Proxy Pattern na Prática', 'premium'),
    new Video('Programação Assíncrona', 'gratuito')
  ];

  private rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
  });

  start(): void {
    console.log('🎓 Bem-vindo à plataforma de vídeos educativos!');
    
    console.log("=== Sistema de Videos Educativos (TypeScript) ===");
    console.log("Comandos:\n\n-> entrar <usuario> \n-> assistir <video> \n-> sair\n");

    this.showPrompt();
  }

  private showPrompt(): void {
    this.rl.question('> ', (command) => {
      this.handleCommand(command.trim());
    });
  }

  private handleCommand(command: string): void {
    const [action, arg] = command.split(' ');

    switch (action) {
      case 'entrar':
        this.login(arg);
        break;
      case 'assistir':
        this.watch(arg);
        break;
      case 'sair':
        console.log('👋 Saindo da plataforma...');
        this.rl.close();
        return;
      default:
        console.log('❓ Comando não reconhecido.');
    }

    this.showPrompt();
  }

  private login(name: string): void {
    if (!name) {
      console.log('⚠️ Digite: entrar <nome>');
      return;
    }

    const type = name.toLowerCase().includes('premium') ? 'premium' : 'normal';
    this.currentUser = new User(name, type);
    console.log(`✅ Usuário "${name}" logado como ${type}.`);
  }

  private watch(videoTitle: string): void {
    if (!this.currentUser) {
      console.log('⚠️ Faça login primeiro com "entrar <usuario>".');
      return;
    }

    const video = this.videos.find(v => v.title.toLowerCase().includes(videoTitle.toLowerCase()));
    if (!video) {
      console.log(`🎬 Vídeo "${videoTitle}" não encontrado.`);
      return;
    }

    const proxy = new ProxyVideo(this.currentUser, video);
    proxy.play();
  }
}
