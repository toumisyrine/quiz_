# Dockerfile pour AI Service
FROM openjdk:17-jdk-slim

LABEL maintainer="syrinaaa"
LABEL service="ai-service"

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8090

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8090/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]