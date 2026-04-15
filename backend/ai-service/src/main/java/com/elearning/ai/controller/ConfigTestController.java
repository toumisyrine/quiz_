package com.elearning.ai.controller;

import com.elearning.ai.config.GeminiConfig;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/ai/config")
public class ConfigTestController {

    @Autowired
    private GeminiConfig geminiConfig;

    @GetMapping("/test")
    public ResponseEntity<Map<String, Object>> testConfig() {
        Map<String, Object> response = new HashMap<>();
        
        try {
            String apiKey = geminiConfig.getApiKey();
            String apiUrl = geminiConfig.getApiUrl();
            
            response.put("status", "SUCCESS");
            response.put("apiKeyConfigured", apiKey != null && !apiKey.isEmpty());
            response.put("apiKeyLength", apiKey != null ? apiKey.length() : 0);
            response.put("apiUrl", apiUrl);
            response.put("message", "Configuration Gemini chargée avec succès");
            
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            response.put("status", "ERROR");
            response.put("message", "Erreur de configuration: " + e.getMessage());
            return ResponseEntity.badRequest().body(response);
        }
    }
}