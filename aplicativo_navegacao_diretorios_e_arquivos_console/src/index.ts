import { FileSystemApp } from './service/FileSystemApp';

const app = new FileSystemApp();
app.run().catch(console.error);