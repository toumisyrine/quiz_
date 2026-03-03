import { Component, OnInit, OnDestroy } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { QuizService } from '../../../services/quiz-feedback.services';
import { Quiz } from '../../../models/quiz-feedback.models';

@Component({
  selector: 'app-quiz-form',
  standalone: true,
  imports: [CommonModule, ReactiveFormsModule],
  templateUrl: './quiz-form.component.html',
  styleUrls: ['./quiz-form.component.scss']
})
export class QuizFormComponent implements OnInit, OnDestroy {
  quizForm!: FormGroup;
  isEditMode = false;
  quizId?: number;
  loading = false;
  private destroy$ = new Subject<void>();

  constructor(
    private fb: FormBuilder,
    private quizService: QuizService,
    private route: ActivatedRoute,
    private router: Router
  ) {}

  ngOnInit(): void {
    this.initForm();
    
    this.route.params.pipe(takeUntil(this.destroy$)).subscribe(params => {
      if (params['id'] && params['id'] !== 'new') {
        this.isEditMode = true;
        this.quizId = +params['id'];
        this.loadQuiz();
      }
    });
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  initForm(): void {
    this.quizForm = this.fb.group({
      title: ['', Validators.required],
      description: [''],
      courseId: ['', Validators.required],
      tutorId: [''],
      timeLimitMinutes: [''],
      passingScore: [''],
      totalPoints: [''],
      status: ['DRAFT']
    });
  }

  loadQuiz(): void {
    if (!this.quizId) return;
    
    this.loading = true;
    this.quizService.getById(this.quizId)
      .pipe(takeUntil(this.destroy$))
      .subscribe({
        next: (quiz) => {
          this.quizForm.patchValue(quiz);
          this.loading = false;
        },
        error: (error) => {
          console.error('Error loading quiz:', error);
          this.loading = false;
        }
      });
  }

  onSubmit(): void {
    if (this.quizForm.invalid) {
      return;
    }

    this.loading = true;
    const quizData: Quiz = this.quizForm.value;

    const operation = this.isEditMode && this.quizId
      ? this.quizService.update(this.quizId, quizData)
      : this.quizService.create(quizData);

    operation.pipe(takeUntil(this.destroy$)).subscribe({
      next: (result) => {
        this.loading = false;
        // Toujours rediriger vers la liste des quiz après sauvegarde
        this.router.navigate(['/dashboard/quizzes']);
      },
      error: (error) => {
        console.error('Error saving quiz:', error);
        this.loading = false;
        alert('Error saving quiz. Please try again.');
      }
    });
  }

  cancel(): void {
    if (this.isEditMode && this.quizId) {
      this.router.navigate(['/dashboard/quizzes', this.quizId]);
    } else {
      this.router.navigate(['/dashboard/quizzes']);
    }
  }
}
