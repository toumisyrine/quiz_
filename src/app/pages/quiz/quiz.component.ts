import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { QuizService } from '../../quiz-feedback/services/quiz-feedback.services';
import { Quiz } from '../../quiz-feedback/models/quiz-feedback.models';

@Component({
  selector: 'app-quiz',
  templateUrl: './quiz.component.html',
  styleUrl: './quiz.component.scss',
  standalone: false,
})
export class QuizComponent implements OnInit {
  quizzes: Quiz[] = [];
  loading = true;
  error: string | null = null;

  constructor(
    private quizService: QuizService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadQuizzes();
  }

  loadQuizzes(): void {
    this.loading = true;
    this.quizService.getPublished().subscribe({
      next: (quizzes: Quiz[]) => {
        this.quizzes = quizzes;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error loading quizzes:', err);
        this.error = 'Failed to load quizzes';
        this.loading = false;
      }
    });
  }

  takeQuiz(quizId: number | undefined): void {
    if (quizId) {
      this.router.navigate(['/quizzes', quizId, 'take']);
    }
  }

  viewQuizDetails(quizId: number | undefined): void {
    if (quizId) {
      this.router.navigate(['/quizzes', quizId]);
    }
  }
}
