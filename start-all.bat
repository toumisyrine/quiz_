@echo off
echo ========================================
echo Compilation Backend + Frontend
echo ========================================

cd backend
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo Erreur compilation backend!
    pause
    exit /b %errorlevel%
)

cd ..
call ng build
if %errorlevel% neq 0 (
    echo Erreur compilation frontend!
    pause
    exit /b %errorlevel%
)

echo.
echo ========================================
echo Compilation terminee avec succes!
echo ========================================
echo.
echo Pour demarrer les services:
echo 1. Eureka: cd backend\eureka-server ^&^& mvn spring-boot:run
echo 2. Gateway: cd backend\api-gateway ^&^& mvn spring-boot:run
echo 3. Quiz: cd backend\quiz-feedback-service ^&^& mvn spring-boot:run
echo 4. AI: cd backend\ai-service ^&^& mvn spring-boot:run
echo 5. Frontend: ng serve
echo.
pause
