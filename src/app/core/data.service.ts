import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, of } from 'rxjs';

export interface Course {
  id: number;
  title: string;
  description: string;
  category: string;
  level: string;
  badge: string;
  badgeClass: string;
  duration: string;
  instructor: string;
  teacher: string; // Alias for instructor
  price: number;
  image: string;
  createdAt?: Date | string;
}

@Injectable({
  providedIn: 'root'
})
export class DataService {
  private apiUrl = 'http://localhost:8888/api'; // API Gateway URL
  
  private mockCourses: Course[] = [
    {
      id: 1,
      title: 'Angular Fundamentals',
      description: 'Learn the basics of Angular framework',
      category: 'Web Development',
      level: 'beginner',
      badge: 'New',
      badgeClass: 'badge-success',
      duration: '4 weeks',
      instructor: 'John Doe',
      teacher: 'John Doe',
      price: 99,
      image: 'assets/images/angular-course.jpg'
    },
    {
      id: 2,
      title: 'Spring Boot Microservices',
      description: 'Build scalable microservices with Spring Boot',
      category: 'Backend Development',
      level: 'intermediate',
      badge: 'Popular',
      badgeClass: 'badge-primary',
      duration: '6 weeks',
      instructor: 'Jane Smith',
      teacher: 'Jane Smith',
      price: 149,
      image: 'assets/images/spring-course.jpg'
    }
  ];

  constructor(private http: HttpClient) { }

  // Course methods
  getCourses(): Course[] {
    return this.mockCourses;
  }

  getCourseById(id: number): Course | undefined {
    return this.mockCourses.find(course => course.id === id);
  }

  addCourse(course: Partial<Course>): void {
    const newCourse: Course = {
      id: this.mockCourses.length + 1,
      title: course.title || '',
      description: course.description || '',
      category: course.category || '',
      level: course.level || 'beginner',
      badge: course.badge || '',
      badgeClass: course.badgeClass || 'badge-secondary',
      duration: course.duration || '',
      instructor: course.instructor || course.teacher || '',
      teacher: course.teacher || course.instructor || '',
      price: course.price || 0,
      image: course.image || ''
    };
    this.mockCourses.push(newCourse);
  }

  updateCourse(id: number, course: Partial<Course>): void {
    const index = this.mockCourses.findIndex(c => c.id === id);
    if (index !== -1) {
      this.mockCourses[index] = { ...this.mockCourses[index], ...course };
    }
  }

  deleteCourse(id: number): void {
    const index = this.mockCourses.findIndex(c => c.id === id);
    if (index !== -1) {
      this.mockCourses.splice(index, 1);
    }
  }

  getCourseLevelLabel(level: string): string {
    const labels: { [key: string]: string } = {
      'beginner': 'Débutant',
      'intermediate': 'Intermédiaire',
      'advanced': 'Avancé'
    };
    return labels[level] || level;
  }

  // API methods (for future backend integration)
  getCoursesFromAPI(): Observable<Course[]> {
    return this.http.get<Course[]>(`${this.apiUrl}/courses`);
  }

  getCourseByIdFromAPI(id: number): Observable<Course> {
    return this.http.get<Course>(`${this.apiUrl}/courses/${id}`);
  }
}