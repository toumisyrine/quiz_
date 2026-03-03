# Structure des Routes - LearnHub

## Routes Publiques (Interface Étudiants)
Accessibles sans authentification, avec interface publique simple.

### Pages Principales
- `/` - Page d'accueil
- `/courses` - Liste des cours publics
- `/courses/:id` - Détails d'un cours
- `/events` - Liste des événements publics
- `/events/:id` - Détails d'un événement
- `/clubs` - Liste des clubs publics
- `/clubs/:id` - Détails d'un club

### Quiz Publics
- `/quizzes` - Liste des quiz publiés uniquement
- `/quizzes/:id` - Détails d'un quiz
- `/quizzes/:id/take` - Passer un quiz

### Résultats et Feedbacks
- `/attempts/:id/result` - Résultat d'une tentative de quiz
- `/feedbacks` - Liste des feedbacks publics
- `/feedbacks/new` - Créer un nouveau feedback
- `/feedbacks/:id/edit` - Modifier un feedback

## Routes Admin (Dashboard)
Interface d'administration avec sidebar et navbar complètes.

### Dashboard Principal
- `/dashboard` - Redirection vers `/dashboard/dashboard`
- `/dashboard/dashboard` - Tableau de bord principal

### Gestion des Utilisateurs
- `/dashboard/users` - Gestion des utilisateurs

### Gestion des Cours
- `/dashboard/courses` - Liste de tous les cours
- `/dashboard/courses/create` - Créer un nouveau cours
- `/dashboard/courses/:id` - Détails d'un cours (admin)
- `/dashboard/courses/:id/edit` - Modifier un cours

### Gestion des Événements
- `/dashboard/events` - Liste de tous les événements
- `/dashboard/events/create` - Créer un nouvel événement
- `/dashboard/events/:id` - Détails d'un événement (admin)
- `/dashboard/events/:id/edit` - Modifier un événement

### Gestion des Clubs
- `/dashboard/clubs` - Liste de tous les clubs
- `/dashboard/clubs/create` - Créer un nouveau club
- `/dashboard/clubs/:id` - Détails d'un club (admin)
- `/dashboard/clubs/:id/edit` - Modifier un club

### Gestion des Quiz (Admin)
Affiche TOUS les quiz (PUBLISHED, DRAFT, ARCHIVED)
- `/dashboard/quizzes` - Liste de tous les quiz
- `/dashboard/quizzes/new` - Créer un nouveau quiz
- `/dashboard/quizzes/:id` - Détails d'un quiz (admin)
- `/dashboard/quizzes/:id/edit` - Modifier un quiz
- `/dashboard/quizzes/:id/take` - Tester un quiz (admin)

### Gestion des Tentatives
- `/dashboard/attempts` - Redirection vers les quiz
- `/dashboard/attempts/:id/result` - Résultat d'une tentative (admin)

### Gestion des Feedbacks (Admin)
- `/dashboard/feedbacks` - Liste de tous les feedbacks
- `/dashboard/feedbacks/new` - Créer un nouveau feedback
- `/dashboard/feedbacks/:id/edit` - Modifier un feedback

### Fonctionnalités IA
- `/dashboard/ai` - Redirection vers `/dashboard/ai/generator`
- `/dashboard/ai/generator` - Générateur de quiz IA
- `/dashboard/ai/feedback/:attemptId` - Feedback IA personnalisé

## Navigation Sidebar (Dashboard)

1. **Dashboard** - `/dashboard/dashboard`
2. **Users** - `/dashboard/users`
3. **Courses** - `/dashboard/courses`
4. **Events** - `/dashboard/events`
5. **Clubs** - `/dashboard/clubs`
6. **Quizzes** - `/dashboard/quizzes`
7. **Quiz Attempts** - `/dashboard/attempts`
8. **Feedbacks** - `/dashboard/feedbacks`
9. **AI Quiz Generator** - `/dashboard/ai/generator`

## Redirections

- `/admin` → `/dashboard`
- `/student` → `/` (page d'accueil)
- `/**` → `/` (toute route non trouvée)

## Notes Importantes

1. **Différence Public/Admin** :
   - Routes publiques : Interface simple pour étudiants
   - Routes admin : Interface complète avec sidebar pour gestion

2. **Quiz Visibility** :
   - Public : Seulement les quiz PUBLISHED
   - Admin : Tous les quiz (PUBLISHED, DRAFT, ARCHIVED)

3. **Lazy Loading** :
   - Tous les composants quiz/feedback utilisent le lazy loading
   - Module admin chargé de manière lazy

4. **Suggestions IA** :
   - Disponibles sur `/feedbacks/new?quizId=X&attemptId=Y`
   - Génération automatique basée sur les résultats du quiz