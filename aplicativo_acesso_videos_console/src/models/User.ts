export type UserType = 'normal' | 'premium';

export class User {
  constructor(
    public name: string,
    public type: UserType
  ) {}
}
