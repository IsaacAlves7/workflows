import { IVideo } from './IVideo';
import { RealVideo } from './RealVideo';
import { Video } from '../models/Video';
import { User } from '../models/User';

export class ProxyVideo implements IVideo {
  private realVideo: RealVideo | null = null;

  constructor(
    private user: User,
    private video: Video
  ) {}

  play(): void {
    if (this.video.accessLevel === 'premium' && this.user.type !== 'premium') {
      console.log(`❌ Acesso negado! O vídeo "${this.video.title}" é premium.`);
      return;
    }

    console.log(`✅ Acesso permitido ao vídeo "${this.video.title}".`);
    if (!this.realVideo) {
      this.realVideo = new RealVideo(this.video);
    }
    this.realVideo.play();
  }
}
