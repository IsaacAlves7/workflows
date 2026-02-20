import { FileSystem } from '../core/FileSystem';
import { InputReader } from '../utils/InputReader';

export class FileSystemApp {
    private inputReader: InputReader;
    private fileSystem: FileSystem;

    constructor() {
        this.inputReader = new InputReader();
        this.fileSystem = new FileSystem();
    }

    public async run(): Promise<void> {
        console.log('=== Sistema de Arquivos Simples (TypeScript) ===');
        console.log('Comandos\n\n-> criar arquivo <nome> \n-> criar pasta <nome>\n-> entrar <nome_pasta>\n-> voltar \n-> listar \n-> sair');

        while (true) {
            const currentPath = this.fileSystem.getCurrentPath();
            const command = await this.inputReader.question(`${currentPath} > `);

            if (command === 'sair') {
                console.log('Saindo do sistema de arquivos...');
                break;
            }

            await this.handleCommand(command);
        }

        this.inputReader.close();
    }

    private async handleCommand(command: string): Promise<void> {
        const parts = command.split(' ');
        const action = parts[0];
        const target = parts[1];
        const name = parts.slice(2).join(' ') || parts.slice(1).join(' ');

        try {
            switch (action) {
                case 'criar':
                    if (target === 'arquivo' && name) {
                        this.fileSystem.createFile(name);
                    } else if (target === 'pasta' && name) {
                        this.fileSystem.createFolder(name);
                    } else {
                        console.log('Uso: criar arquivo <nome> ou criar pasta <nome>');
                    }
                    break;

                case 'entrar':
                    if (name) {
                        this.fileSystem.enterFolder(name);
                    } else {
                        console.log('Uso: entrar <nome_pasta>');
                    }
                    break;

                case 'voltar':
                    this.fileSystem.goBack();
                    break;

                case 'listar':
                    this.fileSystem.list();
                    break;

                default:
                    console.log('Comando não reconhecido. Comandos: criar, entrar, voltar, listar, sair');
            }
        } catch (error) {
            console.log(`Erro: ${error instanceof Error ? error.message : error}`);
        }
    }
}
