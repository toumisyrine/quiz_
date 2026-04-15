package com.elearning.ai.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class GeneratedQuizDTO {
    private String title;
    private String description;
    private Integer suggestedPassingScore;
    private Integer suggestedTimeLimit;
    private List<Question> questions;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class Question {
        private String text;
        private String type;
        private String imageEmoji;
        private List<String> options;
        private String correctAnswer;
        private int points;
        private String explanation;
    }
}
