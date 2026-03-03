package com.elearning.quiz.dto;

import com.elearning.quiz.model.QuestionType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class QuestionUpdateDTO {
    
    private String questionText;
    private QuestionType type;
    private List<String> options;
    private String correctAnswer;
    private Integer points;
    private String explanation;
    private Integer orderIndex;
}
