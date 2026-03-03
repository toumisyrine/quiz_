@echo off
echo ========================================
echo COMPILATION COMPLETE DU PROJET LEARNIFY
echo ========================================
echo.

REM Couleurs pour les messages
set "SUCCESS=[92m"
set "ERROR=[91m"
set "INFO=[94m"
set "RESET=[0m"

echo %INFO%[1/5] Compilation Eureka Server...%RESET%
cd backend\eureka-server
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo %ERROR%Erreur lors de la compilation d'Eureka Server%RESET%
    pause
    exit /b 1
)
echo %SUCCESS%Eureka Server compile avec succes!%RESET%
echo.
cd ..\..

echo %INFO%[2/5] Compilation API Gateway...%RESET%
cd backend\api-gateway
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo %ERROR%Erreur lors de la compilation de l'API Gateway%RESET%
    pause
    exit /b 1
)
echo %SUCCESS%API Gateway compile avec succes!%RESET%
echo.
cd ..\..

echo %INFO%[3/5] Compilation Quiz-Feedback Service...%RESET%
cd backend\quiz-feedback-service
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo %ERROR%Erreur lors de la compilation du Quiz-Feedback Service%RESET%
    pause
    exit /b 1
)
echo %SUCCESS%Quiz-Feedback Service compile avec succes!%RESET%
echo.
cd ..\..

echo %INFO%[4/5] Compilation AI Service...%RESET%
cd backend\ai-service
call mvn clean install -DskipTests
if %errorlevel% neq 0 (
    echo %ERROR%Erreur lors de la compilation de l'AI Service%RESET%
    pause
    exit /b 1
)
echo %SUCCESS%AI Service compile avec succes!%RESET%
echo.
cd ..\..

echo %INFO%[5/5] Compilation Frontend Angular...%RESET%
call ng build
if %errorlevel% neq 0 (
    echo %ERROR%Erreur lors de la compilation du Frontend%RESET%
    pause
    exit /b 1
)
echo %SUCCESS%Frontend compile avec succes!%RESET%
echo.

echo.
echo ========================================
echo %SUCCESS%COMPILATION TERMINEE AVEC SUCCES!%RESET%
echo ========================================
echo.
echo Tous les services ont ete compiles:
echo   - Eureka Server (8761)
echo   - API Gateway (8080)
echo   - Quiz-Feedback Service (8081)
echo   - AI Service (8082)
echo   - Frontend Angular
echo.
echo Pour demarrer tous les services, lance:
echo   start-all-services.bat
echo.
pause
