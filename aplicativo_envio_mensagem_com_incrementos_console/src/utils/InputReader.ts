import * as readline from 'readline';

export class InputReader {
  private rl: readline.Interface;

  constructor() {
    this.rl = readline.createInterface({
      input: process.stdin,
      output: process.stdout
    });
  }

  public async question(prompt: string): Promise<string> {
    return new Promise((resolve) => {
      this.rl.question(prompt, (answer) => {
        resolve(answer.trim().toLowerCase());
      });
    });
  }

  public close(): void {
    this.rl.close();
  }
}