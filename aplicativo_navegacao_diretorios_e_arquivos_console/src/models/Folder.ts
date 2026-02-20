import { FileSystemComponent } from './FileSystemComponent';

export class Folder extends FileSystemComponent {
    private children: FileSystemComponent[] = [];

    list(level: number = 0): void {
        console.log('  '.repeat(level) + `📁 ${this.name}/`);
        
        for (const child of this.children) {
            child.list(level + 1);
        }
    }

    add(component: FileSystemComponent): void {
        this.children.push(component);
    }

    remove(component: FileSystemComponent): void {
        const index = this.children.indexOf(component);
        if (index > -1) {
            this.children.splice(index, 1);
        }
    }

    getChildren(): FileSystemComponent[] {
        return this.children;
    }

    getChildByName(name: string): FileSystemComponent | undefined {
        return this.children.find(child => child.name === name);
    }
}