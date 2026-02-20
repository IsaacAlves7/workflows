import { FileSystemComponent } from './FileSystemComponent';

export class File extends FileSystemComponent {
    list(level: number = 0): void {
        console.log('  '.repeat(level) + `📄 ${this.name}`);
    }

    add(component: FileSystemComponent): void {
        throw new Error('Cannot add to a file');
    }

    remove(component: FileSystemComponent): void {
        throw new Error('Cannot remove from a file');
    }

    getChildren(): FileSystemComponent[] {
        return [];
    }
}