import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { CoreModule } from './core/core.module';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';
import { QuizFeedbackModule } from './quiz-feedback/quiz-feedback.module';
import { VoiceCommandComponent } from './shared/components/voice-command/voice-command.component';
import { LearnbotComponent } from './shared/components/learnbot/learnbot.component';

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    CoreModule,
    QuizFeedbackModule,
    VoiceCommandComponent,
    LearnbotComponent
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
