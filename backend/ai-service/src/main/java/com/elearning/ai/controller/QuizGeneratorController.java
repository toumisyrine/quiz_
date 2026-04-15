package com.elearning.ai.controller;

import com.elearning.ai.dto.GeneratedQuizDTO;
import com.elearning.ai.dto.QuizGenerationRequest;
import com.elearning.ai.service.QuizGeneratorService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/ai/quiz")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:56269"})
public class QuizGeneratorController {
    
    private static final Logger logger = LoggerFactory.getLogger(QuizGeneratorController.class);
    private final QuizGeneratorService quizGeneratorService;
    
    public QuizGeneratorController(QuizGeneratorService quizGeneratorService) {
        this.quizGeneratorService = quizGeneratorService;
    }
    
    @PostMapping("/generate")
    public ResponseEntity<?> generateQuiz(@RequestBody QuizGenerationRequest request) {
        try {
            logger.info("Génération quiz: topic={}, difficulty={}, count={}", 
                request.getTopic(), request.getDifficulty(), request.getQuestionCount());
            
            // Validation des paramètres
            if (request.getTopic() == null || request.getTopic().trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Le sujet du quiz est requis"));
            }
            
            if (request.getQuestionCount() <= 0 || request.getQuestionCount() > 20) {
                return ResponseEntity.badRequest().body(Map.of("error", "Le nombre de questions doit être entre 1 et 20"));
            }
            
            GeneratedQuizDTO quiz = quizGeneratorService.generateQuiz(request);
            
            logger.info("Quiz généré avec succès: {}", quiz.getTitle());
            return ResponseEntity.ok(quiz);
            
        } catch (Exception e) {
            logger.error("Erreur génération quiz", e);
            
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la génération du quiz");
            error.put("message", e.getMessage());
            
            return ResponseEntity.status(500).body(error);
        }
    }
    
    @GetMapping("/topics")
    public ResponseEntity<List<String>> getSuggestedTopics() {
        try {
            return ResponseEntity.ok(quizGeneratorService.getSuggestedTopics());
        } catch (Exception e) {
            logger.error("Erreur récupération topics", e);
            return ResponseEntity.ok(List.of("Java", "Python", "JavaScript"));
        }
    }
    
    @PostMapping("/generate-kids-game")
    public ResponseEntity<?> generateKidsGame(
            @RequestParam String category,
            @RequestParam(defaultValue = "5") int questionCount) {
        try {
            logger.info("Génération kids game: category={}, count={}", category, questionCount);
            
            // Validation basique
            if (category == null || category.trim().isEmpty()) {
                return ResponseEntity.badRequest().body(Map.of("error", "Catégorie requise"));
            }
            
            if (questionCount <= 0 || questionCount > 10) {
                return ResponseEntity.badRequest().body(Map.of("error", "Le nombre de questions doit être entre 1 et 10"));
            }
            
            GeneratedQuizDTO game = quizGeneratorService.generateKidsGame(category.toLowerCase(), questionCount);
            
            logger.info("Kids game généré avec succès: {}", game.getTitle());
            return ResponseEntity.ok(game);
            
        } catch (Exception e) {
            logger.error("Erreur génération kids game", e);
            
            Map<String, String> error = new HashMap<>();
            error.put("error", "Erreur lors de la génération du kids game");
            error.put("message", e.getMessage());
            
            return ResponseEntity.status(500).body(error);
        }
    }
    
    @GetMapping("/generate-kids-game")
    public ResponseEntity<?> generateKidsGameGet(
            @RequestParam String category,
            @RequestParam(defaultValue = "5") int questionCount) {
        return generateKidsGame(category, questionCount);
    }
}