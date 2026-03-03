import { Component, OnInit } from '@angular/core';
import { FeedbackService, QuizService } from '../../quiz-feedback/services/quiz-feedback.services';
import { Feedback, Quiz } from '../../quiz-feedback/models/quiz-feedback.models';

@Component({
  selector: 'app-feedback',
  templateUrl: './feedback.component.html',
  styleUrl: './feedback.component.scss',
  standalone: false,
})
export class FeedbackComponent implements OnInit {
  feedbackList: Feedback[] = [];
  quizzes: Quiz[] = [];
  loading = false;
  submitting = false;
  error: string | null = null;

  newFeedback = {
    quizId: 0,
    studentId: 1, // TODO: Get from auth service
    rating: 0,
    comment: '',
  };

  constructor(
    private feedbackService: FeedbackService,
    private quizService: QuizService
  ) {}

  ngOnInit(): void {
    this.loadQuizzes();
    this.loadFeedbacks();
  }

  loadQuizzes(): void {
    this.quizService.getPublished().subscribe({
      next: (quizzes) => {
        this.quizzes = quizzes;
      },
      error: (err) => {
        console.error('Error loading quizzes:', err);
      }
    });
  }

  loadFeedbacks(): void {
    this.loading = true;
    this.feedbackService.getAll().subscribe({
      next: (feedbacks) => {
        this.feedbackList = feedbacks;
        this.loading = false;
      },
      error: (err) => {
        console.error('Error loading feedbacks:', err);
        this.error = 'Failed to load feedbacks';
        this.loading = false;
      }
    });
  }

  submitFeedback(): void {
    if (!this.newFeedback.quizId || !this.newFeedback.rating || !this.newFeedback.comment) {
      alert('Please fill all fields');
      return;
    }

    this.submitting = true;
    this.feedbackService.create({
      quizId: this.newFeedback.quizId,
      studentId: this.newFeedback.studentId,
      rating: this.newFeedback.rating,
      comment: this.newFeedback.comment,
      type: 'QUIZ_FEEDBACK'
    }).subscribe({
      next: (feedback) => {
        this.feedbackList.unshift(feedback);
        this.newFeedback = { quizId: 0, studentId: 1, rating: 0, comment: '' };
        this.submitting = false;
        alert('Feedback submitted successfully!');
      },
      error: (err) => {
        console.error('Error submitting feedback:', err);
        alert('Failed to submit feedback. Please try again.');
        this.submitting = false;
      }
    });
  }

  setRating(r: number): void {
    this.newFeedback.rating = r;
  }

  getQuizTitle(quizId: number | undefined): string {
    if (!quizId) return 'Unknown Quiz';
    const quiz = this.quizzes.find(q => q.id === quizId);
    return quiz ? quiz.title : 'Unknown Quiz';
  }
}
