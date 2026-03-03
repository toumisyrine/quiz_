import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import {
  QuizGenerationRequest,
  GeneratedQuiz,
  FeedbackAnalysisRequest,
  PersonalizedFeedback,
  FeedbackSuggestionRequest,
  FeedbackSuggestion
} from '../models/ai.models';

@Injectable({
  providedIn: 'root'
})
export class AiService {
  private apiUrl = 'http://localhost:8082/api/ai';

  constructor(private http: HttpClient) {}

  generateQuiz(request: QuizGenerationRequest): Observable<GeneratedQuiz> {
    return this.http.post<GeneratedQuiz>(`${this.apiUrl}/quiz/generate`, request);
  }

  chat(message: string): Observable<any> {
    return this.http.post(`${this.apiUrl}/chatbot/chat`, { message });
  }

  analyzeFeedback(request: FeedbackAnalysisRequest): Observable<PersonalizedFeedback> {
    return this.http.post<PersonalizedFeedback>(`${this.apiUrl}/feedback/analyze`, request);
  }
  
  generateFeedbackSuggestions(request: FeedbackSuggestionRequest): Observable<FeedbackSuggestion> {
    return this.http.post<FeedbackSuggestion>(`${this.apiUrl}/feedback/suggestions`, request);
  }
  
  getSuggestedTopics(): Observable<string[]> {
    return this.http.get<string[]>(`${this.apiUrl}/quiz/topics`);
  }
}
