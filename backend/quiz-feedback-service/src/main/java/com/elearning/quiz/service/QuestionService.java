package com.elearning.quiz.service;

import com.elearning.quiz.dto.QuestionCreateDTO;
import com.elearning.quiz.dto.QuestionResponseDTO;
import com.elearning.quiz.dto.QuestionUpdateDTO;

import java.util.List;

public interface QuestionService {
    
    QuestionResponseDTO addQuestion(QuestionCreateDTO dto);
    
    QuestionResponseDTO getQuestion(Long id);
    
    QuestionResponseDTO updateQuestion(Long id, QuestionUpdateDTO dto);
    
    void deleteQuestion(Long id);
    
    List<QuestionResponseDTO> getQuestionsByQuiz(Long quizId);
    
    void reorderQuestions(Long quizId, List<Long> orderedIds);
}
