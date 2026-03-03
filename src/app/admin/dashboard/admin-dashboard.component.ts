import { Component, OnInit } from '@angular/core';
import { QuizService, FeedbackService } from '../../quiz-feedback/services/quiz-feedback.services';

@Component({
    selector: 'app-admin-dashboard',
    templateUrl: './admin-dashboard.component.html',
    styleUrl: './admin-dashboard.component.scss',
    standalone: false,
})
export class AdminDashboardComponent implements OnInit {
    stats = [
        { label: 'Total Users', value: '12,847', icon: 'ti ti-users', trend: '+12.5%', trendUp: true, color: '#6366f1' },
        { label: 'Active Courses', value: '284', icon: 'ti ti-book', trend: '+8.2%', trendUp: true, color: '#10b981' },
        { label: 'Total Quizzes', value: '0', icon: 'ti ti-clipboard-list', trend: '+15.3%', trendUp: true, color: '#8b5cf6' },
        { label: 'Avg Rating', value: '0', icon: 'ti ti-star', trend: '+5.2%', trendUp: true, color: '#f59e0b' },
    ];

    recentActivity = [
        { action: 'New user registered', user: 'Sarah Johnson', time: '2 minutes ago', icon: 'ti ti-user-plus', color: '#6366f1' },
        { action: 'Course published', user: 'Mark Davis', time: '15 minutes ago', icon: 'ti ti-book-upload', color: '#10b981' },
        { action: 'Quiz completed', user: 'Emily Chen', time: '1 hour ago', icon: 'ti ti-clipboard-check', color: '#8b5cf6' },
        { action: 'Feedback received', user: 'Alex Rivera', time: '2 hours ago', icon: 'ti ti-message-star', color: '#f59e0b' },
        { action: 'Course completed', user: 'Jordan Lee', time: '3 hours ago', icon: 'ti ti-certificate', color: '#6366f1' },
        { action: 'New quiz created', user: 'Chris Park', time: '5 hours ago', icon: 'ti ti-plus', color: '#8b5cf6' },
    ];

    quickActions = [
        { label: 'Add New User', icon: 'ti ti-user-plus', link: '/admin/users' },
        { label: 'Create Course', icon: 'ti ti-plus', link: '/admin/courses' },
        { label: 'Create Quiz', icon: 'ti ti-clipboard-plus', link: '/quizzes/new' },
        { label: 'View Feedbacks', icon: 'ti ti-message-star', link: '/quizzes/feedbacks' },
    ];

    constructor(
        private quizService: QuizService,
        private feedbackService: FeedbackService
    ) {}

    ngOnInit(): void {
        this.loadQuizStats();
        this.loadFeedbackStats();
    }

    loadQuizStats(): void {
        this.quizService.getAll().subscribe({
            next: (quizzes) => {
                const quizStat = this.stats.find(s => s.label === 'Total Quizzes');
                if (quizStat) {
                    quizStat.value = quizzes.length.toString();
                }
            },
            error: (error) => console.error('Error loading quiz stats:', error)
        });
    }

    loadFeedbackStats(): void {
        this.feedbackService.getAll().subscribe({
            next: (feedbacks) => {
                if (feedbacks.length > 0) {
                    const avgRating = feedbacks.reduce((sum, f) => sum + f.rating, 0) / feedbacks.length;
                    const ratingStat = this.stats.find(s => s.label === 'Avg Rating');
                    if (ratingStat) {
                        ratingStat.value = avgRating.toFixed(1) + ' ★';
                    }
                }
            },
            error: (error) => console.error('Error loading feedback stats:', error)
        });
    }
}
