import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { AiService } from '../../services/ai.service';
import { QuizService, QuestionService } from '../../../quiz-feedback/services/quiz-feedback.services';
import { GeneratedQuiz, QuizGenerationRequest } from '../../models/ai.models';

@Component({
  selector: 'app-quiz-generator',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './quiz-generator.component.html',
  styleUrls: ['./quiz-generator.component.scss']
})
export class QuizGeneratorComponent implements OnInit {
  request: QuizGenerationRequest = {
    topic: '',
    difficulty: 'MEDIUM',
    questionCount: 5,
    questionType: 'MULTIPLE_CHOICE'
  };

  generatedQuiz: GeneratedQuiz | null = null;
  loading = false;
  error = '';
  successMessage = '';
  courseId = 1;
  suggestedTopics: string[] = [];

  constructor(
    private aiService: AiService,
    private quizService: QuizService,
    private questionService: QuestionService
  ) {}

  ngOnInit() {
    this.loadSuggestedTopics();
  }

  loadSuggestedTopics() {
    // Sujets d'anglais suggérés
    this.suggestedTopics = [
      'English Grammar Basics',
      'Verb Tenses',
      'Vocabulary Building',
      'Reading Comprehension',
      'Business English',
      'Idioms and Phrases',
      'Prepositions',
      'Articles and Determiners',
      'Conditionals',
      'Passive Voice',
      'Reported Speech',
      'Punctuation and Spelling',
      'Formal vs Informal English',
      'Listening and Speaking',
      'English Pronunciation'
    ];
  }

  selectTopic(topic: string) {
    this.request.topic = topic;
  }

  generateQuiz() {
    if (!this.request.topic.trim()) {
      this.error = 'Veuillez entrer un sujet';
      return;
    }

    this.loading = true;
    this.error = '';
    this.successMessage = '';
    this.generatedQuiz = null;

    this.aiService.generateQuiz(this.request).subscribe({
      next: (quiz) => {
        this.generatedQuiz = quiz;
        this.loading = false;
      },
      error: (err) => {
        console.error('Erreur génération quiz:', err);
        this.loading = false;
        
        if (err.status === 0) {
          this.error = 'Service IA non disponible. Vérifiez que le service est démarré.';
        } else if (err.error?.message) {
          this.error = err.error.message;
        } else if (err.error?.error) {
          this.error = err.error.error;
        } else {
          this.error = 'Erreur lors de la génération du quiz. Veuillez réessayer.';
        }
      }
    });
  }

  saveQuiz() {
    if (!this.generatedQuiz) return;

    this.loading = true;
    this.error = '';

    const quiz = {
      title: this.generatedQuiz.title,
      description: this.generatedQuiz.description,
      courseId: this.courseId,
      passingScore: this.generatedQuiz.suggestedPassingScore || 70,
      timeLimit: this.generatedQuiz.suggestedTimeLimit || 15,
      status: 'PUBLISHED' as const
    };

    this.quizService.create(quiz).subscribe({
      next: (savedQuiz) => {
        if (savedQuiz.id) {
          this.saveQuestions(savedQuiz.id);
        }
      },
      error: (err) => {
        this.error = 'Échec de la sauvegarde du quiz: ' + err.message;
        this.loading = false;
      }
    });
  }

  private saveQuestions(quizId: number) {
    if (!this.generatedQuiz) return;

    let saved = 0;
    const total = this.generatedQuiz.questions.length;

    this.generatedQuiz.questions.forEach(q => {
      const question = {
        quizId,
        questionText: q.text,
        type: q.type as 'MULTIPLE_CHOICE' | 'TRUE_FALSE' | 'SHORT_ANSWER',
        options: q.options,
        correctAnswer: q.correctAnswer,
        points: q.points,
        explanation: q.explanation
      };

      this.questionService.create(question).subscribe({
        next: () => {
          saved++;
          if (saved === total) {
            this.successMessage = 'Quiz sauvegardé avec succès!';
            this.loading = false;
            setTimeout(() => this.reset(), 2000);
          }
        },
        error: (err) => {
          this.error = 'Erreur lors de la sauvegarde des questions: ' + err.message;
          this.loading = false;
        }
      });
    });
  }

  regenerate() {
    this.generateQuiz();
  }

  reset() {
    this.generatedQuiz = null;
    this.successMessage = '';
    this.error = '';
    this.request = {
      topic: '',
      difficulty: 'MEDIUM',
      questionCount: 5,
      questionType: 'MULTIPLE_CHOICE'
    };
  }
}
