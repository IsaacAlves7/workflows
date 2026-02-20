import { IVideo } from './IVideo';
import { Video } from '../models/Video';

export class RealVideo implements IVideo {
  constructor(private video: Video) {}

  play(): void {
    console.log(`▶️ Reproduzindo vídeo: ${this.video.title}`);
  }
}
