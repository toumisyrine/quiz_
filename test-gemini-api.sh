#!/bin/bash

echo "=== Test 1: Get Suggested Topics ==="
curl -X GET http://localhost:8082/api/ai/quiz/topics
echo -e "\n\n"

echo "=== Test 2: Generate Quiz ==="
curl -X POST http://localhost:8082/api/ai/quiz/generate \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Java OOP",
    "difficulty": "MEDIUM",
    "questionCount": 3,
    "questionType": "MULTIPLE_CHOICE"
  }'
echo -e "\n"
