package com.elearning.quiz.dto;

import com.elearning.quiz.model.QuizStatus;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuizUpdateDTO {
    
    private String title;
    
    private String description;
    
    private Long courseId;
    
    private Long tutorId;
    
    private Integer timeLimitMinutes;
    
    private Float passingScore;
    
    private Integer totalPoints;
    
    private QuizStatus status;
}
