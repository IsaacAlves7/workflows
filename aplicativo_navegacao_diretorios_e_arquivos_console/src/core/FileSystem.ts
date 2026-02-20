import { File } from '../models/File';
import { Folder } from '../models/Folder';

export class FileSystem {
    private root: Folder;
    private currentFolder: Folder;
    private folderStack: Folder[] = [];

    constructor() {
        this.root = new Folder('root');
        this.currentFolder = this.root;
    }

    public createFile(name: string): boolean {
        // Verifica se já existe arquivo ou pasta com esse nome
        if (this.currentFolder.getChildByName(name)) {
            console.log(`❌ Já existe um item com o nome "${name}" nesta pasta`);
            return false;
        }

        const file = new File(name);
        this.currentFolder.add(file);
        console.log(`✅ Arquivo "${name}" criado em "${this.currentFolder.name}"`);
        return true;
    }

    public createFolder(name: string): boolean {
        // Verifica se já existe arquivo ou pasta com esse nome
        if (this.currentFolder.getChildByName(name)) {
            console.log(`❌ Já existe um item com o nome "${name}" nesta pasta`);
            return false;
        }

        const folder = new Folder(name);
        this.currentFolder.add(folder);
        console.log(`✅ Pasta "${name}" criada em "${this.currentFolder.name}"`);
        return true;
    }

    public enterFolder(name: string): boolean {
        const folder = this.currentFolder.getChildByName(name);
        
        if (folder && folder instanceof Folder) {
            this.folderStack.push(this.currentFolder);
            this.currentFolder = folder;
            console.log(`📂 Entrou na pasta "${name}"`);
            return true;
        } else {
            console.log(`❌ Pasta "${name}" não encontrada`);
            return false;
        }
    }

    public goBack(): boolean {
        if (this.folderStack.length > 0) {
            this.currentFolder = this.folderStack.pop()!;
            console.log(`↩️ Voltou para a pasta "${this.currentFolder.name}"`);
            return true;
        } else {
            console.log('ℹ️ Já está na pasta raiz');
            return false;
        }
    }

    public list(): void {
        console.log(`\n📁 Conteúdo de "${this.currentFolder.name}":`);
        if (this.currentFolder.getChildren().length === 0) {
            console.log('  (vazio)');
        } else {
            this.currentFolder.list();
        }
        console.log('');
    }

    public getCurrentPath(): string {
        const path = [this.currentFolder.name];
        let current = this.currentFolder;
        
        // Reconstruir o caminho atual (simplificado)
        return path.join('/') + '/';
    }

    // Método auxiliar para verificar se um nome já existe
    private nameExists(name: string): boolean {
        return this.currentFolder.getChildByName(name) !== undefined;
    }
}