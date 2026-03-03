import { Injectable } from '@angular/core';
import { ApiBaseService } from './api-base.service';
import { Observable } from 'rxjs';
import { Event, EventCreate, EventUpdate } from '../models/event.model';

@Injectable({ providedIn: 'root' })
export class EventService {
  constructor(private api: ApiBaseService) {}

  /** GET /api/events - list all events */
  getAll(): Observable<Event[]> {
    return this.api.get<Event[]>('/events');
  }

  /** GET /api/events/:id - get one event by id */
  getById(id: number): Observable<Event> {
    return this.api.get<Event>(`/events/${id}`);
  }

  /** POST /api/events - create event */
  create(payload: EventCreate): Observable<Event> {
    return this.api.post<EventCreate, Event>('/events', payload);
  }

  /** PUT /api/events/:id - update event */
  update(id: number, payload: EventUpdate): Observable<Event> {
    return this.api.put<EventUpdate, Event>(`/events/${id}`, payload);
  }

  /** DELETE /api/events/:id - delete event */
  delete(id: number): Observable<void> {
    return this.api.delete<void>(`/events/${id}`);
  }
}
