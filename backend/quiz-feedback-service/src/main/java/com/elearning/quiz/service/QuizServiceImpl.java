package com.elearning.quiz.service;

import com.elearning.quiz.dto.*;
import com.elearning.quiz.exception.ResourceNotFoundException;
import com.elearning.quiz.model.Quiz;
import com.elearning.quiz.model.QuizStatus;
import com.elearning.quiz.repository.FeedbackRepository;
import com.elearning.quiz.repository.QuestionRepository;
import com.elearning.quiz.repository.QuizAttemptRepository;
import com.elearning.quiz.repository.QuizRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class QuizServiceImpl implements QuizService {
    
    private final QuizRepository quizRepository;
    private final QuestionRepository questionRepository;
    private final QuizAttemptRepository attemptRepository;
    private final FeedbackRepository feedbackRepository;
    
    @Override
    @Transactional
    public QuizResponseDTO createQuiz(QuizCreateDTO dto) {
        Quiz quiz = new Quiz();
        quiz.setTitle(dto.getTitle());
        quiz.setDescription(dto.getDescription());
        quiz.setCourseId(dto.getCourseId());
        quiz.setTutorId(dto.getTutorId());
        quiz.setTimeLimitMinutes(dto.getTimeLimitMinutes());
        quiz.setPassingScore(dto.getPassingScore());
        quiz.setTotalPoints(dto.getTotalPoints());
        quiz.setStatus(dto.getStatus() != null ? dto.getStatus() : QuizStatus.DRAFT);
        quiz.setType(dto.getType() != null ? dto.getType() : com.elearning.quiz.model.QuizType.REGULAR);
        quiz.setCategory(dto.getCategory());
        
        Quiz saved = quizRepository.save(quiz);
        return mapToResponseDTO(saved);
    }
    
    @Override
    public QuizResponseDTO getQuizById(Long id) {
        Quiz quiz = quizRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quiz", "id", id));
        return mapToResponseDTO(quiz);
    }
    
    @Override
    public List<QuizResponseDTO> getAllQuizzes() {
        return quizRepository.findAll().stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    @Transactional
    public QuizResponseDTO updateQuiz(Long id, QuizUpdateDTO dto) {
        Quiz quiz = quizRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quiz", "id", id));
        
        if (dto.getTitle() != null) quiz.setTitle(dto.getTitle());
        if (dto.getDescription() != null) quiz.setDescription(dto.getDescription());
        if (dto.getCourseId() != null) quiz.setCourseId(dto.getCourseId());
        if (dto.getTutorId() != null) quiz.setTutorId(dto.getTutorId());
        if (dto.getTimeLimitMinutes() != null) quiz.setTimeLimitMinutes(dto.getTimeLimitMinutes());
        if (dto.getPassingScore() != null) quiz.setPassingScore(dto.getPassingScore());
        if (dto.getTotalPoints() != null) quiz.setTotalPoints(dto.getTotalPoints());
        if (dto.getStatus() != null) quiz.setStatus(dto.getStatus());
        if (dto.getType() != null) quiz.setType(dto.getType());
        if (dto.getCategory() != null) quiz.setCategory(dto.getCategory());
        
        Quiz updated = quizRepository.save(quiz);
        return mapToResponseDTO(updated);
    }
    
    @Override
    @Transactional
    public void deleteQuiz(Long id) {
        if (!quizRepository.existsById(id)) {
            throw new ResourceNotFoundException("Quiz", "id", id);
        }
        
        // Delete all related data first to avoid foreign key constraint violations
        // 1. Delete feedbacks related to this quiz
        feedbackRepository.deleteByQuizId(id);
        
        // 2. Delete all attempts for this quiz
        attemptRepository.deleteByQuizId(id);
        
        // 3. Delete all questions (cascade will handle question_options)
        questionRepository.deleteByQuizId(id);
        
        // 4. Finally delete the quiz itself
        quizRepository.deleteById(id);
    }
    
    @Override
    public List<QuizResponseDTO> getQuizzesByCourse(Long courseId) {
        return quizRepository.findByCourseId(courseId).stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    public List<QuizResponseDTO> getPublishedQuizzes() {
        return quizRepository.findByStatus(QuizStatus.PUBLISHED).stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    @Transactional
    public QuizResponseDTO publishQuiz(Long id) {
        Quiz quiz = quizRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quiz", "id", id));
        quiz.setStatus(QuizStatus.PUBLISHED);
        Quiz updated = quizRepository.save(quiz);
        return mapToResponseDTO(updated);
    }
    
    @Override
    @Transactional
    public QuizResponseDTO archiveQuiz(Long id) {
        Quiz quiz = quizRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quiz", "id", id));
        quiz.setStatus(QuizStatus.ARCHIVED);
        Quiz updated = quizRepository.save(quiz);
        return mapToResponseDTO(updated);
    }
    
    @Override
    public Quiz getQuizWithQuestions(Long id) {
        return quizRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Quiz", "id", id));
    }
    
    @Override
    public QuizStatsDTO getQuizStats(Long id) {
        if (!quizRepository.existsById(id)) {
            throw new ResourceNotFoundException("Quiz", "id", id);
        }
        
        Long totalAttempts = (long) attemptRepository.findByQuizId(id).size();
        Double averageScore = attemptRepository.getAverageScoreByQuizId(id);
        Long passedCount = attemptRepository.countPassedAttemptsByQuizId(id);
        Double passRate = totalAttempts > 0 ? (passedCount.doubleValue() / totalAttempts) * 100 : 0.0;
        Double averageRating = feedbackRepository.getAverageRatingByQuizId(id);
        
        return new QuizStatsDTO(
                totalAttempts,
                averageScore != null ? averageScore : 0.0,
                passRate,
                averageRating != null ? averageRating : 0.0
        );
    }
    
    @Override
    public List<QuizResponseDTO> getKidsGames() {
        return quizRepository.findByType(com.elearning.quiz.model.QuizType.KIDS_GAME).stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
    
    @Override
    public List<QuizResponseDTO> getKidsGamesByCategory(String category) {
        return quizRepository.findByTypeAndCategory(
                com.elearning.quiz.model.QuizType.KIDS_GAME, 
                category
        ).stream()
                .map(this::mapToResponseDTO)
                .collect(Collectors.toList());
    }
    
    private QuizResponseDTO mapToResponseDTO(Quiz quiz) {
        Long questionCount = questionRepository.countByQuizId(quiz.getId());
        Double averageScore = attemptRepository.getAverageScoreByQuizId(quiz.getId());
        
        return new QuizResponseDTO(
                quiz.getId(),
                quiz.getTitle(),
                quiz.getDescription(),
                quiz.getCourseId(),
                quiz.getTutorId(),
                quiz.getTimeLimitMinutes(),
                quiz.getPassingScore(),
                quiz.getTotalPoints(),
                quiz.getStatus(),
                quiz.getType(),
                quiz.getCategory(),
                quiz.getCreatedAt(),
                quiz.getUpdatedAt(),
                questionCount,
                averageScore
        );
    }
}
