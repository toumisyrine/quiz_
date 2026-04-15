package com.elearning.quiz.dto;

import com.elearning.quiz.model.QuizStatus;
import com.elearning.quiz.model.QuizType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuizResponseDTO {
    
    private Long id;
    private String title;
    private String description;
    private Long courseId;
    private Long tutorId;
    private Integer timeLimitMinutes;
    private Float passingScore;
    private Integer totalPoints;
    private QuizStatus status;
    private QuizType type;
    private String category;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Long questionCount;
    private Double averageScore;
}
