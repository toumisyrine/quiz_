package com.elearning.quiz.dto;

import com.elearning.quiz.model.QuestionType;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuestionCreateDTO {
    
    @NotBlank(message = "Question text is required")
    private String questionText;
    
    @NotNull(message = "Question type is required")
    private QuestionType type;
    
    private List<String> options;
    
    @NotBlank(message = "Correct answer is required")
    private String correctAnswer;
    
    private Integer points = 1;
    
    private String explanation;
    
    private Integer orderIndex;
    
    private String imageEmoji;
    
    @NotNull(message = "Quiz ID is required")
    private Long quizId;
}
