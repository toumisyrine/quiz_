import { Component } from '@angular/core';

@Component({
    selector: 'app-admin-layout',
    templateUrl: './admin-layout.component.html',
    styleUrl: './admin-layout.component.scss',
    standalone: false,
})
export class AdminLayoutComponent {
    sidebarCollapsed = false;
    currentDate = new Date();

    toggleSidebar(): void {
        this.sidebarCollapsed = !this.sidebarCollapsed;
    }

    navItems = [
        { path: '/dashboard/dashboard', icon: 'ti ti-dashboard', label: 'Dashboard' },
        { path: '/dashboard/users', icon: 'ti ti-users', label: 'Users' },
        { path: '/dashboard/courses', icon: 'ti ti-book', label: 'Courses' },
        { path: '/dashboard/events', icon: 'ti ti-calendar-event', label: 'Events' },
        { path: '/dashboard/clubs', icon: 'ti ti-users-group', label: 'Clubs' },
        { path: '/dashboard/quizzes', icon: 'ti ti-clipboard-list', label: 'Quizzes' },
        { path: '/dashboard/feedbacks', icon: 'ti ti-message-star', label: 'Feedbacks' },
        { path: '/dashboard/ai/generator', icon: 'ti ti-sparkles', label: 'AI Quiz Generator' },
    ];
}
