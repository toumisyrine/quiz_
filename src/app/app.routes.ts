import { Routes } from '@angular/router';

export const routes: Routes = [
  // Page d'accueil → liste des quiz
  {
    path: '',
    loadComponent: () => import('./quiz-feedback/components/quiz/quiz-list/quiz-list.component')
      .then(m => m.QuizListComponent)
  },

  // ============================================
  // QUIZ FEEDBACK - Votre travail
  // ============================================

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

  {
    path: 'attempts/:id/result',
    loadComponent: () => import('./quiz-feedback/components/quiz-attempt/attempt-result/attempt-result.component')
      .then(m => m.AttemptResultComponent)
  },

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
  // AI SERVICE - Votre travail
  // ============================================

  {
    path: 'ai/advice',
    loadComponent: () => import('./ai/components/ai-advice/ai-advice.component')
      .then(m => m.AiAdviceComponent)
  },

  // ============================================
  // ADMIN DASHBOARD
  // ============================================

  {
    path: 'dashboard',
    loadChildren: () => import('./admin/admin.module').then(m => m.AdminModule),
  },

  // Redirection par défaut
  { path: '**', redirectTo: 'quizzes' },
];
