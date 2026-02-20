export abstract class FileSystemComponent {
    constructor(public name: string) {}
    
    abstract list(level?: number): void;
    abstract add(component: FileSystemComponent): void;
    abstract remove(component: FileSystemComponent): void;
    abstract getChildren(): FileSystemComponent[];
}