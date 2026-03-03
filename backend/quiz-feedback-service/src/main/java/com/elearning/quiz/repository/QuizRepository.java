package com.elearning.quiz.repository;

import com.elearning.quiz.model.Quiz;
import com.elearning.quiz.model.QuizStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {
    
    List<Quiz> findByCourseId(Long courseId);
    
    List<Quiz> findByTutorId(Long tutorId);
    
    List<Quiz> findByStatus(QuizStatus status);
    
    List<Quiz> findByTitleContainingIgnoreCase(String title);
}
