import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';

// Client Interface Components
import { ClientCoursesListComponent } from './pages/courses/client-courses-list/client-courses-list.component';
import { ClientCourseDetailsComponent } from './pages/courses/client-course-details/client-course-details.component';
import { ClientEventsListComponent } from './pages/events/client-events-list/client-events-list.component';
import { ClientEventDetailsComponent } from './pages/events/client-event-details/client-event-details.component';
import { ClientClubsListComponent } from './pages/clubs/client-clubs-list/client-clubs-list.component';
import { ClientClubDetailsComponent } from './pages/clubs/client-club-details/client-club-details.component';

export const routes: Routes = [
  // ============================================
  // ROUTES PUBLIQUES (sans sidebar/navbar)
  // Pour les étudiants et visiteurs
  // ============================================
  
  { path: '', component: HomeComponent },
  
  // Cours publics
  { path: 'courses', component: ClientCoursesListComponent },
  { path: 'courses/:id', component: ClientCourseDetailsComponent },
  
  // Événements publics
  { path: 'events', component: ClientEventsListComponent },
  { path: 'events/:id', component: ClientEventDetailsComponent },
  
  // Clubs publics
  { path: 'clubs', component: ClientClubsListComponent },
  { path: 'clubs/:id', component: ClientClubDetailsComponent },
  
  // Quiz publics (SEULEMENT les quiz PUBLISHED)
  {
    path: 'quizzes',
    children: [
      { 
        path: '', 
        loadComponent: () => import('./quiz-feedback/components/quiz/quiz-list/quiz-list.component')
          .then(m => m.QuizListComponent) 
      },
      { 
        path: ':id', 
        loadComponent: () => import('./quiz-feedback/components/quiz/quiz-detail/quiz-detail.component')
          .then(m => m.QuizDetailComponent) 
      },
      { 
        path: ':id/take', 
        loadComponent: () => import('./quiz-feedback/components/quiz-attempt/take-quiz/take-quiz.component')
          .then(m => m.TakeQuizComponent) 
      }
    ]
  },
  
  // Résultats des tentatives
  {
    path: 'attempts/:id/result', 
    loadComponent: () => import('./quiz-feedback/components/quiz-attempt/attempt-result/attempt-result.component')
      .then(m => m.AttemptResultComponent)
  },
  
  // Feedbacks publics
  {
    path: 'feedbacks',
    children: [
      { 
        path: '', 
        loadComponent: () => import('./quiz-feedback/components/feedback/feedback-list/feedback-list.component')
          .then(m => m.FeedbackListComponent) 
      },
      { 
        path: 'new', 
        loadComponent: () => import('./quiz-feedback/components/feedback/feedback-form/feedback-form.component')
          .then(m => m.FeedbackFormComponent) 
      },
      { 
        path: ':id/edit', 
        loadComponent: () => import('./quiz-feedback/components/feedback/feedback-form/feedback-form.component')
          .then(m => m.FeedbackFormComponent) 
      }
    ]
  },
  
  // ============================================
  // ROUTES ADMIN (avec sidebar/navbar)
  // Pour les administrateurs et enseignants
  // ============================================
  
  {
    path: 'dashboard',
    loadChildren: () => import('./admin/admin.module').then(m => m.AdminModule),
  },
  
  // ============================================
  // REDIRECTIONS (pour compatibilité)
  // ============================================
  
  { path: 'admin', redirectTo: 'dashboard', pathMatch: 'prefix' },
  { path: 'student', redirectTo: '', pathMatch: 'prefix' },
  
  // Redirection par défaut
  { path: '**', redirectTo: '' },
];
