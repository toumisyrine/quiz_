package com.elearning.ai.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

import jakarta.annotation.PostConstruct;

@Configuration
public class GeminiConfig {
    
    private static final Logger logger = LoggerFactory.getLogger(GeminiConfig.class);
    
    @Value("${gemini.api.key}")
    private String apiKey;
    
    @Value("${gemini.api.url}")
    private String apiUrl;
    
    @PostConstruct
    public void validateConfig() {
        logger.info("=== Configuration Gemini API ===");
        logger.info("API Key configurée: {}", apiKey != null && !apiKey.isEmpty() ? "OUI (longueur: " + apiKey.length() + ")" : "NON");
        logger.info("API URL configurée: {}", apiUrl);
        
        if (apiKey == null || apiKey.isEmpty()) {
            logger.error("ERREUR: Clé API Gemini manquante dans application.yml");
            throw new IllegalStateException("Clé API Gemini non configurée");
        }
        
        if (apiUrl == null || apiUrl.isEmpty()) {
            logger.error("ERREUR: URL API Gemini manquante dans application.yml");
            throw new IllegalStateException("URL API Gemini non configurée");
        }
        
        logger.info("Configuration Gemini validée avec succès");
    }
    
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
    
    public String getApiKey() {
        return apiKey;
    }
    
    public String getApiUrl() {
        return apiUrl;
    }
}
