package com.elearning.ai.service;

import com.elearning.ai.dto.GeneratedQuizDTO;
import com.elearning.ai.dto.QuizGenerationRequest;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class QuizGeneratorService {
    
    private static final Logger logger = LoggerFactory.getLogger(QuizGeneratorService.class);
    
    private final GeminiService geminiService;
    private final ObjectMapper objectMapper;
    
    public QuizGeneratorService(GeminiService geminiService) {
        this.geminiService = geminiService;
        this.objectMapper = new ObjectMapper();
    }
    
    public GeneratedQuizDTO generateQuiz(QuizGenerationRequest request) {
        try {
            logger.info("Génération quiz avec Gemini 1.5 Flash: {}", request.getTopic());
            
            // Prompt système optimisé pour Gemini 1.5 Flash
            String systemPrompt = """
                You are an expert English language quiz generator for an e-learning platform focused on teaching English.
                Create educational English language quizzes in perfect JSON format.
                
                CRITICAL: Return ONLY valid JSON, no markdown, no explanations, no code blocks.
                
                JSON Structure (EXACT format required):
                {
                  "title": "Quiz Title Here",
                  "description": "Brief description of the quiz",
                  "suggestedPassingScore": 70,
                  "suggestedTimeLimit": 15,
                  "questions": [
                    {
                      "text": "Question text here?",
                      "type": "MULTIPLE_CHOICE",
                      "options": ["Option A", "Option B", "Option C", "Option D"],
                      "correctAnswer": "Option A",
                      "explanation": "Why this answer is correct",
                      "points": 2
                    }
                  ]
                }
                
                Rules:
                - Create exactly the requested number of questions
                - All questions must be about English language learning (grammar, vocabulary, reading, writing, speaking)
                - Make questions educational and relevant to English learners
                - Provide clear, distinct options
                - Include helpful explanations
                - Use appropriate difficulty level
                """;
            
            String userMessage = String.format(
                """
                Create an English language learning quiz with these specifications:
                - Topic: %s
                - Difficulty: %s
                - Number of questions: %d
                - Question type: %s
                
                Focus on English grammar, vocabulary, reading comprehension, or communication skills.
                Make the quiz educational and appropriate for English learners at the given difficulty level.
                Return ONLY the JSON, nothing else.
                """,
                request.getTopic(),
                request.getDifficulty(),
                request.getQuestionCount(),
                request.getQuestionType()
            );
            
            String response = geminiService.chat(systemPrompt, userMessage);
            
            // Nettoyer et parser la réponse
            String cleanJson = cleanJsonResponse(response);
            logger.info("JSON nettoyé: {}", cleanJson.substring(0, Math.min(200, cleanJson.length())));
            
            GeneratedQuizDTO quiz = objectMapper.readValue(cleanJson, GeneratedQuizDTO.class);
            
            // Validation
            if (quiz.getQuestions() == null || quiz.getQuestions().isEmpty()) {
                throw new RuntimeException("Quiz généré sans questions");
            }
            
            logger.info("Quiz généré avec succès: {} questions", quiz.getQuestions().size());
            return quiz;
            
        } catch (Exception e) {
            logger.error("Erreur génération quiz: {}", e.getMessage());
            throw new RuntimeException("Erreur lors de la génération du quiz: " + e.getMessage(), e);
        }
    }
    
    private String cleanJsonResponse(String response) {
        if (response == null || response.trim().isEmpty()) {
            throw new RuntimeException("Réponse vide de Gemini");
        }
        
        // Supprimer les markdown et formatages
        response = response.trim();
        
        // Supprimer les blocs de code markdown
        if (response.startsWith("```json")) {
            response = response.substring(7);
        }
        if (response.startsWith("```")) {
            response = response.substring(3);
        }
        if (response.endsWith("```")) {
            response = response.substring(0, response.length() - 3);
        }
        
        // Trouver le JSON valide
        int start = response.indexOf("{");
        int end = response.lastIndexOf("}") + 1;
        
        if (start >= 0 && end > start) {
            return response.substring(start, end).trim();
        }
        
        throw new RuntimeException("Pas de JSON valide trouvé dans la réponse");
    }
    
    public List<String> getSuggestedTopics() {
        return List.of(
            "English Grammar Basics",
            "Verb Tenses",
            "Vocabulary Building",
            "Reading Comprehension",
            "Business English",
            "Idioms and Phrases",
            "Prepositions",
            "Articles and Determiners",
            "Conditionals",
            "Passive Voice",
            "Reported Speech",
            "Punctuation and Spelling",
            "Formal vs Informal English",
            "Listening and Speaking",
            "English Pronunciation"
        );
    }
    
    public GeneratedQuizDTO generateKidsGame(String category, int questionCount) {
        try {
            logger.info("Génération Kids Game avec Gemini: category={}, count={}", category, questionCount);
            
            String systemPrompt = """
                You are an expert at creating educational games for children aged 5-10 learning English.
                Create a "Match the Word" game in perfect JSON format.
                
                CRITICAL: Return ONLY valid JSON, no markdown, no explanations, no code blocks.
                
                JSON Structure (EXACT format required):
                {
                  "title": "Game Title",
                  "description": "Fun description for kids",
                  "suggestedPassingScore": 70,
                  "suggestedTimeLimit": 10,
                  "questions": [
                    {
                      "text": "What is this? 🐱",
                      "type": "MULTIPLE_CHOICE",
                      "imageEmoji": "🐱",
                      "options": ["cat", "dog", "bird", "fish"],
                      "correctAnswer": "cat",
                      "explanation": "This is a cat! Meow!",
                      "points": 1
                    }
                  ]
                }
                
                Rules:
                - Use simple, common English words appropriate for young children
                - Include an emoji in the imageEmoji field
                - Provide 4 options (1 correct + 3 wrong from the same category)
                - Keep explanations fun and encouraging
                - All words should be basic vocabulary
                """;
            
            String categoryDescription = getCategoryDescription(category);
            
            String userMessage = String.format(
                """
                Create a kids game for category: %s
                Number of questions: %d
                
                %s
                
                Make it fun, educational, and appropriate for children aged 5-10.
                Use emojis that children will recognize.
                Return ONLY the JSON, nothing else.
                """,
                category,
                questionCount,
                categoryDescription
            );
            
            String response = geminiService.chat(systemPrompt, userMessage);
            String cleanJson = cleanJsonResponse(response);
            
            GeneratedQuizDTO game = objectMapper.readValue(cleanJson, GeneratedQuizDTO.class);
            
            if (game.getQuestions() == null || game.getQuestions().isEmpty()) {
                throw new RuntimeException("Kids game généré sans questions");
            }
            
            logger.info("Kids game généré avec succès: {} questions", game.getQuestions().size());
            return game;
            
        } catch (Exception e) {
            logger.error("Erreur génération kids game: {}", e.getMessage());
            throw new RuntimeException("Erreur lors de la génération du kids game: " + e.getMessage(), e);
        }
    }
    
    private String getCategoryDescription(String category) {
        return switch (category.toLowerCase()) {
            case "animals" -> """
                Create questions about common animals (cat, dog, bird, fish, rabbit, lion, elephant, etc.).
                Use animal emojis like 🐱 🐶 🐦 🐠 🐰 🦁 🐘
                Focus on animals that children know and love.
                """;
            case "colors" -> """
                Create questions about basic colors (red, blue, green, yellow, purple, orange, pink, etc.).
                Use color emojis like 🔴 🔵 🟢 🟡 🟣 🟠 🩷
                Focus on primary and common colors.
                """;
            case "numbers" -> """
                Create questions about numbers 1-10 (one, two, three, four, five, six, seven, eight, nine, ten).
                Use number emojis like 1️⃣ 2️⃣ 3️⃣ 4️⃣ 5️⃣ 6️⃣ 7️⃣ 8️⃣ 9️⃣ 🔟
                Focus on basic counting numbers.
                """;
            case "fruits" -> """
                Create questions about common fruits (apple, banana, orange, grape, strawberry, etc.).
                Use fruit emojis like 🍎 🍌 🍊 🍇 🍓 🍑 🍒
                Focus on fruits that children know and eat.
                """;
            case "vehicles" -> """
                Create questions about vehicles (car, bus, train, plane, bike, boat, etc.).
                Use vehicle emojis like 🚗 🚌 🚂 ✈️ 🚲 🚢
                Focus on common transportation methods.
                """;
            case "food" -> """
                Create questions about common foods (bread, milk, cheese, pizza, cake, etc.).
                Use food emojis like 🍞 🥛 🧀 🍕 🎂 🍪
                Focus on foods that children know and like.
                """;
            case "toys" -> """
                Create questions about toys (ball, doll, car, puzzle, blocks, etc.).
                Use toy emojis like ⚽ 🪆 🚗 🧩 🧸
                Focus on common children's toys.
                """;
            case "shapes" -> """
                Create questions about basic shapes (circle, square, triangle, rectangle, star, etc.).
                Use shape emojis like ⭕ ⬜ 🔺 ▭ ⭐
                Focus on geometric shapes children learn.
                """;
            default -> String.format("""
                Create questions about %s that are appropriate for young children aged 5-10.
                Use relevant emojis that represent items in this category.
                Focus on simple, common items that children would recognize.
                Make the vocabulary age-appropriate and fun.
                """, category);
        };
    }
}
