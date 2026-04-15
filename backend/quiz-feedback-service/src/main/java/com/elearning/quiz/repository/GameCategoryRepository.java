package com.elearning.quiz.repository;

import com.elearning.quiz.model.GameCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface GameCategoryRepository extends JpaRepository<GameCategory, Long> {
    Optional<GameCategory> findByName(String name);
    boolean existsByName(String name);
}
