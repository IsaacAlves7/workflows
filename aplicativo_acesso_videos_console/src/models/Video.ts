export type VideoAccessLevel = 'gratuito' | 'premium';

export class Video {
  constructor(
    public title: string,
    public accessLevel: VideoAccessLevel
  ) {}
}
