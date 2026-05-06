# Dockerfile pour API Gateway
FROM eclipse-temurin:17-jre-alpine

LABEL maintainer="syrinaaa"
LABEL service="api-gateway"

# Install curl for health check
RUN apk add --no-cache curl

WORKDIR /app

COPY target/*.jar app.jar

EXPOSE 8888

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:8888/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]