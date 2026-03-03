import { Component } from '@angular/core';
import { VoiceCommandComponent } from './shared/components/voice-command/voice-command.component';
import { LearnbotComponent } from './shared/components/learnbot/learnbot.component';

@Component({
  selector: 'app-root',
  template: `
    <router-outlet></router-outlet>
    <app-voice-command></app-voice-command>
    <app-learnbot></app-learnbot>
  `,
  styles: [],
  standalone: false,
})
export class AppComponent {}
