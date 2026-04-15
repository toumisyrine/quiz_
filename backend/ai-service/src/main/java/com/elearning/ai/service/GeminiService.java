package com.elearning.ai.service;

import com.elearning.ai.config.GeminiConfig;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GeminiService {
    
    private static final Logger logger = LoggerFactory.getLogger(GeminiService.class);
    
    private final GeminiConfig geminiConfig;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;
    
    public GeminiService(GeminiConfig geminiConfig, RestTemplate restTemplate) {
        this.geminiConfig = geminiConfig;
        this.restTemplate = restTemplate;
        this.objectMapper = new ObjectMapper();
    }
    
    public String chat(String systemPrompt, String userMessage) {
        try {
            // Construire le prompt complet optimisé pour Gemini
            String fullPrompt = systemPrompt + "\n\nUser: " + userMessage + "\n\nAssistant:";
            
            // Construire le body de la requête selon l'API Gemini
            Map<String, Object> requestBody = new HashMap<>();
            
            Map<String, Object> part = new HashMap<>();
            part.put("text", fullPrompt);
            
            Map<String, Object> content = new HashMap<>();
            content.put("parts", List.of(part));
            
            requestBody.put("contents", List.of(content));
            
            // Configuration optimisée pour Gemini 1.5 Flash
            Map<String, Object> generationConfig = new HashMap<>();
            generationConfig.put("temperature", 0.7);
            generationConfig.put("maxOutputTokens", 8192);
            generationConfig.put("topP", 0.95);
            generationConfig.put("topK", 64);
            requestBody.put("generationConfig", generationConfig);
            
            // Safety settings pour éviter les blocages
            Map<String, Object> safetySettings = Map.of(
                "category", "HARM_CATEGORY_HARASSMENT",
                "threshold", "BLOCK_MEDIUM_AND_ABOVE"
            );
            requestBody.put("safetySettings", List.of(safetySettings));
            
            // Headers optimisés
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.set("User-Agent", "LearnHub-AI/1.0");
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            
            // URL avec clé API
            String url = geminiConfig.getApiUrl() + "?key=" + geminiConfig.getApiKey();
            
            logger.info("Appel Gemini 1.5 Flash...");
            
            // Appel API avec timeout
            ResponseEntity<String> response = restTemplate.exchange(
                url,
                HttpMethod.POST,
                entity,
                String.class
            );
            
            logger.info("Réponse Gemini reçue: {}", response.getStatusCode());
            
            // Parser la réponse JSON
            JsonNode root = objectMapper.readTree(response.getBody());
            
            if (root.has("candidates") && root.get("candidates").size() > 0) {
                JsonNode candidate = root.get("candidates").get(0);
                
                if (candidate.has("content") && candidate.get("content").has("parts")) {
                    JsonNode parts = candidate.get("content").get("parts");
                    if (parts.size() > 0 && parts.get(0).has("text")) {
                        String result = parts.get(0).get("text").asText();
                        logger.info("Texte extrait avec succès (longueur: {})", result.length());
                        return result.trim();
                    }
                }
                
                // Vérifier si bloqué par safety
                if (candidate.has("finishReason")) {
                    String finishReason = candidate.get("finishReason").asText();
                    if ("SAFETY".equals(finishReason)) {
                        throw new RuntimeException("Contenu bloqué par les filtres de sécurité Gemini");
                    }
                }
            }
            
            // Si pas de contenu valide
            logger.error("Réponse Gemini invalide: {}", response.getBody());
            throw new RuntimeException("Réponse Gemini invalide - pas de contenu");
                      
        } catch (Exception e) {
            logger.error("Erreur Gemini API: {}", e.getMessage());
            throw new RuntimeException("Erreur API Gemini: " + e.getMessage(), e);
        }
    }
}
