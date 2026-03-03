package com.elearning.quiz.service;

import com.elearning.quiz.dto.QuizAttemptResponseDTO;
import com.elearning.quiz.dto.QuizAttemptSubmitDTO;

import java.util.List;

public interface QuizAttemptService {
    
    QuizAttemptResponseDTO submitAttempt(QuizAttemptSubmitDTO dto);
    
    List<QuizAttemptResponseDTO> getAttemptsByQuiz(Long quizId);
    
    List<QuizAttemptResponseDTO> getAttemptsByStudent(Long studentId);
    
    QuizAttemptResponseDTO getAttemptById(Long id);
}
