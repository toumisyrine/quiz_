import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

import { AdminLayoutComponent } from './layout/admin-layout.component';
import { AdminDashboardComponent } from './dashboard/admin-dashboard.component';
import { AdminUsersComponent } from './users/admin-users.component';

// CRUD Components
import { CoursesListComponent } from './courses/courses-list/courses-list.component';
import { CourseFormComponent } from './courses/course-form/course-form.component';
import { CourseDetailsComponent } from './courses/course-details/course-details.component';
import { EventsListComponent } from './events/events-list/events-list.component';
import { EventFormComponent } from './events/event-form/event-form.component';
import { EventDetailsComponent } from './events/event-details/event-details.component';
import { ClubsListComponent } from './clubs/clubs-list/clubs-list.component';
import { ClubFormComponent } from './clubs/club-form/club-form.component';
import { ClubDetailsComponent } from './clubs/club-details/club-details.component';

const routes: Routes = [
    {
        path: '',
        component: AdminLayoutComponent,
        children: [
            // ============================================
            // DASHBOARD PRINCIPAL
            // ============================================
            { path: '', redirectTo: 'dashboard', pathMatch: 'full' },
            { path: 'dashboard', component: AdminDashboardComponent },
            
            // ============================================
            // GESTION DES UTILISATEURS
            // ============================================
            { path: 'users', component: AdminUsersComponent },
            
            // ============================================
            // GESTION DES COURS
            // ============================================
            { path: 'courses', component: CoursesListComponent },
            { path: 'courses/create', component: CourseFormComponent },
            { path: 'courses/:id', component: CourseDetailsComponent },
            { path: 'courses/:id/edit', component: CourseFormComponent },
            
            // ============================================
            // GESTION DES ÉVÉNEMENTS
            // ============================================
            { path: 'events', component: EventsListComponent },
            { path: 'events/create', component: EventFormComponent },
            { path: 'events/:id', component: EventDetailsComponent },
            { path: 'events/:id/edit', component: EventFormComponent },
            
            // ============================================
            // GESTION DES CLUBS
            // ============================================
            { path: 'clubs', component: ClubsListComponent },
            { path: 'clubs/create', component: ClubFormComponent },
            { path: 'clubs/:id', component: ClubDetailsComponent },
            { path: 'clubs/:id/edit', component: ClubFormComponent },
            
            // ============================================
            // GESTION DES QUIZ (ADMIN)
            // Affiche TOUS les quiz (PUBLISHED, DRAFT, ARCHIVED)
            // ============================================
            {
                path: 'quizzes',
                children: [
                    { 
                        path: '', 
                        loadComponent: () => import('../quiz-feedback/components/quiz/quiz-list/quiz-list.component')
                            .then(m => m.QuizListComponent) 
                    },
                    { 
                        path: 'new', 
                        loadComponent: () => import('../quiz-feedback/components/quiz/quiz-form/quiz-form.component')
                            .then(m => m.QuizFormComponent) 
                    },
                    { 
                        path: ':id', 
                        loadComponent: () => import('../quiz-feedback/components/quiz/quiz-detail/quiz-detail.component')
                            .then(m => m.QuizDetailComponent) 
                    },
                    { 
                        path: ':id/edit', 
                        loadComponent: () => import('../quiz-feedback/components/quiz/quiz-form/quiz-form.component')
                            .then(m => m.QuizFormComponent) 
                    }
                ]
            },
            
            // ============================================
            // GESTION DES FEEDBACKS (ADMIN)
            // ============================================
            {
                path: 'feedbacks',
                children: [
                    { 
                        path: '', 
                        loadComponent: () => import('../quiz-feedback/components/feedback/feedback-list/feedback-list.component')
                            .then(m => m.FeedbackListComponent) 
                    },
                    { 
                        path: 'new', 
                        loadComponent: () => import('../quiz-feedback/components/feedback/feedback-form/feedback-form.component')
                            .then(m => m.FeedbackFormComponent) 
                    },
                    { 
                        path: ':id/edit', 
                        loadComponent: () => import('../quiz-feedback/components/feedback/feedback-form/feedback-form.component')
                            .then(m => m.FeedbackFormComponent) 
                    }
                ]
            },
            
            // ============================================
            // RÉSULTATS DES TENTATIVES (ADMIN)
            // ============================================
            {
                path: 'attempts',
                children: [
                    { path: '', redirectTo: '/dashboard/quizzes', pathMatch: 'full' },
                    {
                        path: ':id/result', 
                        loadComponent: () => import('../quiz-feedback/components/quiz-attempt/attempt-result/attempt-result.component')
                            .then(m => m.AttemptResultComponent)
                    }
                ]
            },
            
            // ============================================
            // FONCTIONNALITÉS IA
            // ============================================
            {
                path: 'ai',
                children: [
                    { path: '', redirectTo: 'generator', pathMatch: 'full' },
                    { 
                        path: 'generator', 
                        loadComponent: () => import('../ai/components/quiz-generator/quiz-generator.component')
                            .then(m => m.QuizGeneratorComponent) 
                    },
                    { 
                        path: 'feedback/:attemptId', 
                        loadComponent: () => import('../ai/components/ai-feedback/ai-feedback.component')
                            .then(m => m.AiFeedbackComponent) 
                    }
                ]
            },
        ],
    },
];

@NgModule({
    imports: [RouterModule.forChild(routes)],
    exports: [RouterModule],
})
export class AdminRoutingModule { }
