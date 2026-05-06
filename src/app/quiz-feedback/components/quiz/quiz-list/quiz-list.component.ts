import { Component, OnInit, OnDestroy } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { Subject } from 'rxjs';
import { takeUntil } from 'rxjs/operators';
import { Quiz } from '../../../models/quiz-feedback.models';
import { QuizService } from '../../../services/quiz-feedback.services';
import { NavbarComponent } from '../../../../core/components/navbar/navbar.component';
import { FooterComponent } from '../../../../core/components/footer/footer.component';

@Component({
  selector: 'app-quiz-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule, NavbarComponent, FooterComponent],
  templateUrl: './quiz-list.component.html',
  styleUrls: ['./quiz-list.component.scss']
})
export class QuizListComponent implements OnInit, OnDestroy {
  quizzes: Quiz[] = [];
  filteredQuizzes: Quiz[] = [];
  loading = false;
  searchTerm = '';
  
  // Détection du mode (admin ou étudiant)
  isAdminMode = false;
  
  // Filtres (seulement pour admin)
  filterStatus: string = 'ALL';
  filterCourse: number | null = null;
  sortBy: string = 'createdAt';
  sortOrder: 'asc' | 'desc' = 'desc';
  
  // Modal de suppression
  showDeleteModal = false;
  quizToDelete: Quiz | null = null;
  
  // Options pour les filtres
  statusOptions = ['ALL', 'PUBLISHED', 'DRAFT', 'ARCHIVED'];
  sortOptions = [
    { value: 'title', label: 'Titre' },
    { value: 'createdAt', label: 'Date de création' },
    { value: 'averageScore', label: 'Score moyen' },
    { value: 'questionCount', label: 'Nombre de questions' }
  ];
  
  private destroy$ = new Subject<void>();

  constructor(
    private quizService: QuizService,
    private router: Router
  ) {}

  ngOnInit(): void {
    // Détecter si on est en mode admin ou étudiant
    this.isAdminMode = this.router.url.includes('/dashboard');
    console.log('Mode:', this.isAdminMode ? 'ADMIN' : 'ÉTUDIANT');
    this.loadQuizzes();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

  loadQuizzes(): void {
    this.loading = true;
    this.quizService.getAll()
      .pipe(takeUntil(this.destroy$))
      .subscribe({
        next: (data) => {
          this.quizzes = data;
          
          // Si mode étudiant, filtrer seulement les quiz PUBLISHED
          if (!this.isAdminMode) {
            this.quizzes = data.filter(quiz => quiz.status === 'PUBLISHED');
            console.log('Mode étudiant: Affichage de', this.quizzes.length, 'quiz publiés');
          }
          
          this.filteredQuizzes = this.quizzes;
          this.loading = false;
        },
        error: (error) => {
          console.error('Error loading quizzes:', error);
          this.loading = false;
        }
      });
  }

  // Méthodes supprimées: searchQuizzes() - remplacée par applyFilters() directement

  applyFilters(): void {
    let result = [...this.quizzes];

    // Filtre par recherche
    if (this.searchTerm.trim()) {
      const term = this.searchTerm.toLowerCase();
      result = result.filter(quiz =>
        quiz.title.toLowerCase().includes(term) ||
        (quiz.description && quiz.description.toLowerCase().includes(term))
      );
    }

    // Filtre par statut
    if (this.filterStatus !== 'ALL') {
      result = result.filter(quiz => quiz.status === this.filterStatus);
    }

    // Filtre par cours
    if (this.filterCourse !== null) {
      result = result.filter(quiz => quiz.courseId === this.filterCourse);
    }

    // Tri
    result.sort((a, b) => {
      let aVal: any = a[this.sortBy as keyof Quiz];
      let bVal: any = b[this.sortBy as keyof Quiz];

      if (aVal === undefined || aVal === null) aVal = 0;
      if (bVal === undefined || bVal === null) bVal = 0;

      if (typeof aVal === 'string') {
        aVal = aVal.toLowerCase();
        bVal = bVal.toLowerCase();
      }

      if (this.sortOrder === 'asc') {
        return aVal > bVal ? 1 : aVal < bVal ? -1 : 0;
      } else {
        return aVal < bVal ? 1 : aVal > bVal ? -1 : 0;
      }
    });

    this.filteredQuizzes = result;
  }

  // Nouvelles méthodes pour les statistiques et filtres
  setStatusFilter(status: string): void {
    this.filterStatus = status;
    this.applyFilters();
  }

  getPublishedQuizzesCount(): number {
    return this.quizzes.filter(quiz => quiz.status === 'PUBLISHED').length;
  }

  getTotalQuestionsCount(): number {
    return this.quizzes.reduce((total, quiz) => total + (quiz.questionCount || 0), 0);
  }

  trackByQuiz(index: number, quiz: Quiz): any {
    return quiz.id || index;
  }

  resetFilters(): void {
    this.searchTerm = '';
    this.filterStatus = 'ALL';
    this.filterCourse = null;
    this.sortBy = 'createdAt';
    this.sortOrder = 'desc';
    this.applyFilters();
  }

  viewQuiz(id: number): void {
    if (this.isAdminMode) {
      this.router.navigate(['/dashboard/quizzes', id]);
    } else {
      this.router.navigate(['/quizzes', id]);
    }
  }

  takeQuiz(id: number): void {
    // Action pour les étudiants uniquement: passer le quiz
    // Les admins ne peuvent pas passer de quiz depuis le dashboard
    if (!this.isAdminMode) {
      this.router.navigate(['/quizzes', id, 'take']);
    }
  }

  editQuiz(id: number): void {
    // L'édition est toujours dans le dashboard
    this.router.navigate(['/dashboard/quizzes', id, 'edit']);
  }

  createQuiz(): void {
    // La création est toujours dans le dashboard
    this.router.navigate(['/dashboard/quizzes/new']);
  }

  toggleStatus(quiz: Quiz): void {
    if (quiz.status === 'PUBLISHED') {
      this.archiveQuiz(quiz);
    } else {
      this.publishQuiz(quiz);
    }
  }

  publishQuiz(quiz: Quiz): void {
    if (!quiz.id) return;
    
    this.quizService.publish(quiz.id)
      .pipe(takeUntil(this.destroy$))
      .subscribe({
        next: () => {
          this.loadQuizzes();
        },
        error: (error) => console.error('Error publishing quiz:', error)
      });
  }

  archiveQuiz(quiz: Quiz): void {
    if (!quiz.id) return;
    
    this.quizService.archive(quiz.id)
      .pipe(takeUntil(this.destroy$))
      .subscribe({
        next: () => {
          this.loadQuizzes();
        },
        error: (error) => console.error('Error archiving quiz:', error)
      });
  }



  getStatusBadgeClass(status: string): string {
    switch (status) {
      case 'PUBLISHED': return 'badge bg-success';
      case 'ARCHIVED': return 'badge bg-warning';
      default: return 'badge bg-secondary';
    }
  }

  getViewLink(id: number): string {
    return this.isAdminMode ? `/dashboard/quizzes/${id}` : `/quizzes/${id}`;
  }

  confirmDelete(quiz: Quiz): void {
    this.quizToDelete = quiz;
    this.showDeleteModal = true;
  }

  cancelDelete(): void {
    this.quizToDelete = null;
    this.showDeleteModal = false;
  }

  deleteQuiz(): void {
    if (this.quizToDelete?.id) {
      this.quizService.delete(this.quizToDelete.id)
        .pipe(takeUntil(this.destroy$))
        .subscribe({
          next: () => {
            this.loadQuizzes();
            this.cancelDelete();
          },
          error: (error) => console.error('Error deleting quiz:', error)
        });
    }
  }
}
