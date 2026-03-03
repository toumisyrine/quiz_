import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { Router } from '@angular/router';
import { QuizService } from '../../../quiz-feedback/services/quiz-feedback.services';
import { Quiz } from '../../../quiz-feedback/models/quiz-feedback.models';

@Component({
  selector: 'app-quizzes',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './quizzes.component.html',
  styleUrls: ['./quizzes.component.scss']
})
export class QuizzesComponent implements OnInit {
  quizzes: Quiz[] = [];
  loading = false;

  constructor(
    private quizService: QuizService,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.loadQuizzes();
  }

  loadQuizzes(): void {
    this.loading = true;
    this.quizService.getAll().subscribe({
      next: (data) => {
        // Afficher seulement les 3 premiers quiz publiés
        this.quizzes = data
          .filter(quiz => quiz.status === 'PUBLISHED')
          .slice(0, 3);
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading quizzes:', error);
        this.loading = false;
      }
    });
  }

  viewAllQuizzes(): void {
    this.router.navigate(['/quizzes']);
  }

  takeQuiz(id: number): void {
    this.router.navigate(['/quizzes', id, 'take']);
  }
}
