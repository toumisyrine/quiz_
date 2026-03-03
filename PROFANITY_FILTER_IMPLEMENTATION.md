# Système de Filtrage des Mots Inappropriés - LearnHub

## ✅ Implémentation Complète

### 1. Backend (Java Spring Boot)

#### Service de Filtrage (`ProfanityFilterService`)
- **Localisation :** `backend/quiz-feedback-service/src/main/java/com/elearning/quiz/service/ProfanityFilterService.java`
- **Fonctionnalités :**
  - Détection de mots inappropriés en français et anglais
  - Support des variantes avec caractères spéciaux (`f*ck`, `m3rd3`, etc.)
  - Normalisation du texte (suppression accents, espaces multiples)
  - Filtrage avec remplacement par des astérisques
  - Validation avec exception personnalisée

#### Mots Interdits Inclus
**Français :** merde, putain, connard, salaud, enculé, etc.
**Anglais :** fuck, shit, bitch, asshole, bastard, etc.
**Variantes :** f*ck, sh*t, m3rd3, put@in, etc.

#### Exception Personnalisée
- **Classe :** `InappropriateContentException`
- **Retourne :** Message d'erreur + liste des mots détectés
- **Gestion :** Dans `GlobalExceptionHandler` avec code HTTP 400

#### Intégration dans FeedbackService
```java
// Validation avant création/modification
validateFeedbackContent(dto.getComment());

// Filtrage automatique
String filteredComment = profanityFilterService.filterProfanity(dto.getComment());
feedback.setComment(filteredComment);
```

### 2. Frontend (Angular)

#### Service de Filtrage (`ProfanityFilterService`)
- **Localisation :** `src/app/shared/services/profanity-filter.service.ts`
- **Fonctionnalités :**
  - Validation côté client en temps réel
  - Même liste de mots que le backend
  - Normalisation du texte identique
  - Méthodes de validation et filtrage

#### Intégration dans FeedbackForm
- **Validation en temps réel :** `(input)="onCommentChange()"`
- **Affichage d'erreurs :** Messages d'erreur avec icônes Bootstrap
- **Validation avant soumission :** Double vérification côté client
- **Gestion des erreurs serveur :** Affichage des mots détectés par le backend

### 3. Interface Utilisateur

#### Validation en Temps Réel
```html
<textarea
  class="form-control"
  formControlName="comment"
  (input)="onCommentChange()"
  [class.is-invalid]="feedbackForm.get('comment')?.errors?.['profanity']"
></textarea>

<div *ngIf="feedbackForm.get('comment')?.errors?.['profanity']" class="invalid-feedback">
  <i class="bi bi-exclamation-triangle me-1"></i>
  {{ getCommentErrorMessage() }}
</div>
```

#### Messages d'Erreur
- **Côté client :** "Votre commentaire contient des mots inappropriés. Veuillez le modifier."
- **Côté serveur :** "Le feedback contient du contenu inapproprié. Veuillez modifier votre commentaire."
- **Détails :** Liste des mots détectés affichée à l'utilisateur

## 🔧 Fonctionnalités Avancées

### 1. Normalisation du Texte
- Suppression des accents (`àáâ` → `a`)
- Espaces multiples → espace simple
- Conversion en minuscules
- Gestion des caractères spéciaux

### 2. Détection Intelligente
- Regex avec limites de mots (`\b`)
- Support des substitutions de caractères
- Insensible à la casse
- Détection des variantes créatives

### 3. Gestion Administrative
```java
// Ajouter un mot interdit
profanityFilterService.addBadWord("nouveauMot");

// Supprimer un mot
profanityFilterService.removeBadWord("motÀSupprimer");

// Lister tous les mots
Set<String> badWords = profanityFilterService.getBadWords();
```

## 🧪 Tests et Validation

### Script de Test Automatisé
```bash
./test-profanity-filter.ps1
```

**Tests inclus :**
1. ✅ Contenu approprié → Accepté
2. ✅ Contenu inapproprié français → Rejeté
3. ✅ Contenu inapproprié anglais → Rejeté
4. ✅ Variantes avec caractères spéciaux → Rejetées
5. ✅ Gestion des erreurs → Messages clairs

### Cas de Test Manuels
- **Feedback normal :** "Excellent quiz, très instructif!"
- **Français inapproprié :** "Ce quiz est vraiment merde"
- **Anglais inapproprié :** "This quiz is fucking terrible"
- **Variantes :** "C'est de la m3rd3" ou "f*ck this"

## 🚀 Déploiement et Configuration

### 1. Backend
```bash
cd backend/quiz-feedback-service
mvn compile
mvn spring-boot:run
```

### 2. Frontend
```bash
ng build --configuration development
ng serve
```

### 3. URLs de Test
- **Public :** http://localhost:4200/feedbacks/new
- **Admin :** http://localhost:4200/dashboard/feedbacks/new
- **Avec contexte :** http://localhost:4200/feedbacks/new?quizId=1&attemptId=32

## 📊 Statistiques d'Implémentation

- **Mots interdits :** 50+ (français + anglais + variantes)
- **Langues supportées :** Français, Anglais
- **Validation :** Double (client + serveur)
- **Performance :** Regex optimisée avec cache
- **Sécurité :** Validation côté serveur obligatoire

## 🔮 Améliorations Futures

1. **Base de données des mots interdits** pour gestion dynamique
2. **Niveaux de sévérité** (avertissement vs blocage)
3. **Apprentissage automatique** pour détecter de nouveaux patterns
4. **Modération manuelle** avec file d'attente
5. **Statistiques** de détection et rapports
6. **API d'administration** pour gérer les mots interdits
7. **Support multilingue étendu** (espagnol, italien, etc.)

## ✨ Résultat Final

Le système de filtrage des mots inappropriés est maintenant :
- ✅ **Fonctionnel** - Détection et blocage efficaces
- ✅ **Multilingue** - Français et anglais supportés
- ✅ **Intelligent** - Gestion des variantes et substitutions
- ✅ **User-friendly** - Messages d'erreur clairs
- ✅ **Sécurisé** - Validation double côté client/serveur
- ✅ **Testé** - Scripts de test automatisés inclus