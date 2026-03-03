package com.elearning.ai.controller;

import com.elearning.ai.dto.FeedbackAnalysisRequest;
import com.elearning.ai.dto.FeedbackSuggestionRequest;
import com.elearning.ai.dto.FeedbackSuggestionDTO;
import com.elearning.ai.dto.PersonalizedFeedbackDTO;
import com.elearning.ai.service.PersonalizedFeedbackService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai/feedback")
@CrossOrigin(origins = {"http://localhost:4200", "http://localhost:56269"})
public class PersonalizedFeedbackController {
    
    private final PersonalizedFeedbackService feedbackService;
    
    public PersonalizedFeedbackController(PersonalizedFeedbackService feedbackService) {
        this.feedbackService = feedbackService;
    }
    
    @PostMapping("/analyze")
    public ResponseEntity<PersonalizedFeedbackDTO> analyzeFeedback(@RequestBody FeedbackAnalysisRequest request) {
        PersonalizedFeedbackDTO feedback = feedbackService.generateFeedback(request);
        return ResponseEntity.ok(feedback);
    }
    
    @PostMapping("/suggestions")
    public ResponseEntity<FeedbackSuggestionDTO> generateSuggestions(@RequestBody FeedbackSuggestionRequest request) {
        FeedbackSuggestionDTO suggestions = feedbackService.generateFeedbackSuggestions(request);
        return ResponseEntity.ok(suggestions);
    }
}
