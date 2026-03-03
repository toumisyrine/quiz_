package com.elearning.quiz.controller;

import com.elearning.quiz.dto.QuestionCreateDTO;
import com.elearning.quiz.dto.QuestionResponseDTO;
import com.elearning.quiz.dto.QuestionUpdateDTO;
import com.elearning.quiz.service.QuestionService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
@CrossOrigin(origins = "http://localhost:4200")
@RequiredArgsConstructor
public class QuestionController {
    
    private final QuestionService questionService;
    
    @GetMapping("/quiz/{quizId}")
    public ResponseEntity<List<QuestionResponseDTO>> getQuestionsByQuiz(@PathVariable Long quizId) {
        return ResponseEntity.ok(questionService.getQuestionsByQuiz(quizId));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<QuestionResponseDTO> getQuestionById(@PathVariable Long id) {
        return ResponseEntity.ok(questionService.getQuestion(id));
    }
    
    @PostMapping
    public ResponseEntity<QuestionResponseDTO> addQuestion(@Valid @RequestBody QuestionCreateDTO dto) {
        return new ResponseEntity<>(questionService.addQuestion(dto), HttpStatus.CREATED);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<QuestionResponseDTO> updateQuestion(
            @PathVariable Long id,
            @RequestBody QuestionUpdateDTO dto) {
        return ResponseEntity.ok(questionService.updateQuestion(id, dto));
    }
    
    @PutMapping("/quiz/{quizId}/reorder")
    public ResponseEntity<Void> reorderQuestions(
            @PathVariable Long quizId,
            @RequestBody List<Long> orderedIds) {
        questionService.reorderQuestions(quizId, orderedIds);
        return ResponseEntity.ok().build();
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteQuestion(@PathVariable Long id) {
        questionService.deleteQuestion(id);
        return ResponseEntity.noContent().build();
    }
}
