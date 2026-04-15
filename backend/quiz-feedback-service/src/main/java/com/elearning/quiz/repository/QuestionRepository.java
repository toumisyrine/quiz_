package com.elearning.quiz.repository;

import com.elearning.quiz.model.Question;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuestionRepository extends JpaRepository<Question, Long> {
    
    List<Question> findByQuizIdOrderByOrderIndex(Long quizId);
    
    Long countByQuizId(Long quizId);
    
    @Modifying
    void deleteByQuizId(Long quizId);
}
