export interface QuizGenerationRequest {
  topic: string;
  difficulty: string;
  questionCount: number;
  questionType: string;
}

export interface GeneratedQuiz {
  title: string;
  description: string;
  suggestedPassingScore?: number;
  suggestedTimeLimit?: number;
  questions: GeneratedQuestion[];
}

export interface GeneratedQuestion {
  text: string;
  type: string;
  options: string[];
  correctAnswer: string;
  points: number;
  explanation: string;
}

export interface FeedbackAnalysisRequest {
  attemptId: number;
  quizTitle: string;
  score: number;
  totalPoints: number;
  questionResults: QuestionResult[];
}

export interface QuestionResult {
  questionText: string;
  userAnswer: string;
  correctAnswer: string;
  isCorrect: boolean;
}

export interface PersonalizedFeedback {
  overallFeedback: string;
  strengths: string[];
  weaknesses: string[];
  recommendations: string[];
  motivationalMessage: string;
}

export interface FeedbackSuggestionRequest {
  quizId?: number;
  quizTitle: string;
  attemptId?: number;
  score: number;
  totalPoints: number;
  difficulty?: string;
  topic?: string;
}

export interface FeedbackSuggestion {
  suggestions: string[];
  tone: string;
  focusArea: string;
}
