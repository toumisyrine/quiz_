import { Component, OnInit, OnDestroy } from '@angular/core';
import { ActivatedRoute, Router, RouterModule } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { Quiz, QuizStats, Question, QuizAttemptResponse, Feedback } from '../../../models/quiz-feedback.models';
import { QuizService, QuestionService, QuizAttemptService, FeedbackService } from '../../../services/quiz-feedback.services';

@Component({
  selector: 'app-quiz-detail',
  standalone: true,
  imports: [CommonModule, RouterModule, FormsModule],
  templateUrl: './quiz-detail.component.html',
  styleUrls: ['./quiz-detail.component.scss']
})
export class QuizDetailComponent implements OnInit, OnDestroy {
  quiz?: Quiz;
  questions: Question[] = [];
  attempts: QuizAttemptResponse[] = [];
  feedbacks: Feedback[] = [];
  stats?: QuizStats;
  activeTab = 'questions';
  loading = false;
  showQuestionForm = false;
  editingQuestion?: Question;
  
  newQuestion: Partial<Question> = {
    type: 'MULTIPLE_CHOICE',
    points: 10,
    options: ['', '', '', ''],
    correctAnswer: '',
    questionText: ''
  };
  
  private destroy$ = new Subject<void>();

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private quizService: QuizService,
    private questionService: QuestionService,
    private attemptService: QuizAttemptService,
    private feedbackService: FeedbackService
  ) {}

  ngOnInit(): void {
    this.route.params.pipe(takeUntil(this.destroy$)).subscribe(params => {
      const id = +params['id'];
      if (id) {
        this.loadQuizDetails(id);
      }
    });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  goBack(): void {
    const isDashboard = this.router.url.includes('/dashboard');
    if (isDashboard) {
      this.router.navigate(['/dashboard/quizzes']);
    } else {
      this.router.navigate(['/quizzes']);
    }
  }

  loadQuizDetails(id: number): void {
    this.loading = true;
    
    this.quizService.getById(id).pipe(takeUntil(this.destroy$)).subscribe({
      next: (quiz) => {
        this.quiz = quiz;
        this.loadQuestions(id);
        this.loadStats(id);
        this.loadAttempts(id);
        this.loadFeedbacks(id);
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading quiz:', error);
        this.loading = false;
      }
    });
  }

  loadQuestions(quizId: number): void {
    this.questionService.getByQuiz(quizId).pipe(takeUntil(this.destroy$)).subscribe({
      next: (questions) => this.questions = questions,
      error: (error) => console.error('Error loading questions:', error)
    });
  }

  loadStats(quizId: number): void {
    this.quizService.getStats(quizId).pipe(takeUntil(this.destroy$)).subscribe({
      next: (stats) => this.stats = stats,
      error: (error) => console.error('Error loading stats:', error)
    });
  }

  loadAttempts(quizId: number): void {
    this.attemptService.getByQuiz(quizId).pipe(takeUntil(this.destroy$)).subscribe({
      next: (attempts) => this.attempts = attempts,
      error: (error) => console.error('Error loading attempts:', error)
    });
  }

  loadFeedbacks(quizId: number): void {
    this.feedbackService.getByQuiz(quizId).pipe(takeUntil(this.destroy$)).subscribe({
      next: (feedbacks) => this.feedbacks = feedbacks,
      error: (error) => console.error('Error loading feedbacks:', error)
    });
  }

  takeQuiz(): void {
    if (this.quiz?.id) {
      const isDashboard = this.router.url.includes('/dashboard');
      if (isDashboard) {
        this.router.navigate(['/dashboard/quizzes', this.quiz.id, 'take']);
      } else {
        this.router.navigate(['/quizzes', this.quiz.id, 'take']);
      }
    }
  }

  editQuiz(): void {
    if (this.quiz?.id) {
      // L'édition est toujours dans le dashboard
      this.router.navigate(['/dashboard/quizzes', this.quiz.id, 'edit']);
    }
  }

  deleteQuestion(id: number): void {
    if (confirm('Are you sure you want to delete this question?')) {
      this.questionService.delete(id).pipe(takeUntil(this.destroy$)).subscribe({
        next: () => {
          if (this.quiz?.id) this.loadQuestions(this.quiz.id);
        },
        error: (error) => console.error('Error deleting question:', error)
      });
    }
  }

  getStarArray(rating: number): number[] {
    return Array(5).fill(0).map((_, i) => i < rating ? 1 : 0);
  }

  openQuestionForm(question?: Question): void {
    this.showQuestionForm = true;
    if (question) {
      this.editingQuestion = question;
      this.newQuestion = { ...question };
    } else {
      this.editingQuestion = undefined;
      this.newQuestion = {
        quizId: this.quiz?.id,
        type: 'MULTIPLE_CHOICE',
        points: 10,
        options: ['', '', '', ''],
        correctAnswer: '',
        questionText: '',
        explanation: ''
      };
    }
  }

  closeQuestionForm(): void {
    this.showQuestionForm = false;
    this.editingQuestion = undefined;
  }

  saveQuestion(): void {
    if (!this.newQuestion.questionText || !this.newQuestion.correctAnswer) {
      alert('Please fill all required fields');
      return;
    }

    if (this.editingQuestion?.id) {
      this.questionService.update(this.editingQuestion.id, this.newQuestion)
        .pipe(takeUntil(this.destroy$))
        .subscribe({
          next: () => {
            if (this.quiz?.id) this.loadQuestions(this.quiz.id);
            this.closeQuestionForm();
          },
          error: (error) => console.error('Error updating question:', error)
        });
    } else {
      this.questionService.create(this.newQuestion as Question)
        .pipe(takeUntil(this.destroy$))
        .subscribe({
          next: () => {
            if (this.quiz?.id) this.loadQuestions(this.quiz.id);
            this.closeQuestionForm();
          },
          error: (error) => console.error('Error creating question:', error)
        });
    }
  }

  addOption(): void {
    if (!this.newQuestion.options) this.newQuestion.options = [];
    this.newQuestion.options.push('');
  }

  removeOption(index: number): void {
    this.newQuestion.options?.splice(index, 1);
  }
}
