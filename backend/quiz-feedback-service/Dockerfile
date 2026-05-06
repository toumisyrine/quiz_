# Dockerfile pour Quiz Feedback Service
FROM openjdk:17-jdk-slim

LABEL maintainer="syrinaaa"
LABEL service="quiz-feedback-service"

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8089

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8089/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]