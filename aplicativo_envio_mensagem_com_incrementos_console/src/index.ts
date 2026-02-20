import { MessageApp } from './service/MessageApp';

const app = new MessageApp();
app.run().catch(console.error);