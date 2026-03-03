package com.elearning.quiz.service;

import com.elearning.quiz.dto.FeedbackCreateDTO;
import com.elearning.quiz.dto.FeedbackResponseDTO;

import java.util.List;

public interface FeedbackService {
    
    FeedbackResponseDTO createFeedback(FeedbackCreateDTO dto);
    
    FeedbackResponseDTO getFeedbackById(Long id);
    
    List<FeedbackResponseDTO> getAllFeedbacks();
    
    FeedbackResponseDTO updateFeedback(Long id, FeedbackCreateDTO dto);
    
    void deleteFeedback(Long id);
    
    List<FeedbackResponseDTO> getFeedbackByQuiz(Long quizId);
    
    List<FeedbackResponseDTO> getFeedbackByCourse(Long courseId);
    
    List<FeedbackResponseDTO> getFeedbackByStudent(Long studentId);
    
    Double getAverageRating(Long quizId);
}
