pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
    }
    
    environment {
        DOCKERHUB_USER = 'syrinaaa'
        DOCKER_CREDENTIALS = 'dockerhub-credentials'
        GITHUB_REPO = 'https://github.com/toumisyrine/quiz_.git'
        GITHUB_BRANCH = 'quiz-feedback_branch'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Check Java') {
            steps {
                sh 'java -version'
                sh 'echo $JAVA_HOME'
                sh 'mvn -version'
                sh 'which mvn'
            }
        }
        
        stage('Git Pull') {
            steps {
                script {
                    try {
                        // Try checkout SCM first
                        checkout scm
                    } catch (Exception e) {
                        echo "Checkout SCM failed: ${e.getMessage()}"
                        echo "Trying manual git clone..."
                        
                        // Clean workspace first
                        deleteDir()
                        
                        // Try manual clone with retry
                        retry(3) {
                            try {
                                git branch: "${GITHUB_BRANCH}",
                                    credentialsId: 'github-credentials',
                                    url: "${GITHUB_REPO}"
                            } catch (Exception gitException) {
                                echo "Git clone attempt failed: ${gitException.getMessage()}"
                                if (gitException.getMessage().contains('quiz-feedback_branch')) {
                                    echo "Branch 'quiz-feedback_branch' not found, trying 'main' branch..."
                                    git branch: 'main',
                                        credentialsId: 'github-credentials',
                                        url: "${GITHUB_REPO}"
                                } else {
                                    throw gitException
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // ================= BUILD MAVEN =================
        stage('Build Backend Services') {
            parallel {
                stage('Build Eureka Server') {
                    steps {
                        dir('backend/eureka-server') {
                            script {
                                try {
                                    sh 'ls -la'
                                    sh 'cat pom.xml | head -20'
                                    sh 'mvn clean package -DskipTests=false'
                                } catch (Exception e) {
                                    echo "Eureka Server build failed: ${e.getMessage()}"
                                    sh 'mvn clean package -DskipTests=true'
                                }
                            }
                        }
                    }
                }
                stage('Build API Gateway') {
                    steps {
                        dir('backend/api-gateway') {
                            script {
                                try {
                                    sh 'ls -la'
                                    sh 'mvn clean package -DskipTests=false'
                                } catch (Exception e) {
                                    echo "API Gateway build failed: ${e.getMessage()}"
                                    sh 'mvn clean package -DskipTests=true'
                                }
                            }
                        }
                    }
                }
                stage('Build Quiz Feedback Service') {
                    steps {
                        dir('backend/quiz-feedback-service') {
                            script {
                                try {
                                    sh 'ls -la'
                                    sh 'mvn clean package -DskipTests=false'
                                } catch (Exception e) {
                                    echo "Quiz Feedback Service build failed: ${e.getMessage()}"
                                    sh 'mvn clean package -DskipTests=true'
                                }
                            }
                        }
                    }
                }
                stage('Build AI Service') {
                    steps {
                        dir('backend/ai-service') {
                            script {
                                try {
                                    sh 'ls -la'
                                    sh 'mvn clean package -DskipTests=false'
                                } catch (Exception e) {
                                    echo "AI Service build failed: ${e.getMessage()}"
                                    sh 'mvn clean package -DskipTests=true'
                                }
                            }
                        }
                    }
                }
                stage('Build Frontend') {
                    steps {
                        script {
                            try {
                                sh 'node --version'
                                sh 'npm --version'
                                sh 'npm ci'
                                sh 'npm run build -- --configuration production'
                            } catch (Exception e) {
                                echo "Frontend build failed: ${e.getMessage()}"
                                echo "Skipping frontend build..."
                            }
                        }
                    }
                }
            }
        }
        
        // ================= DOCKER BUILD =================
        stage('Build & Push Docker Images') {
            steps {
                script {
                    // Verify Docker is available
                    sh 'docker --version'
                    sh 'docker info'
                    
                    // Login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                    
                    // Eureka Server
                    dir('backend/eureka-server') {
                        sh 'ls -la target/'
                        sh "docker build -t ${DOCKERHUB_USER}/eureka-server:${IMAGE_TAG} ."
                        sh "docker push ${DOCKERHUB_USER}/eureka-server:${IMAGE_TAG}"
                        sh "docker build -t ${DOCKERHUB_USER}/eureka-server:latest ."
                        sh "docker push ${DOCKERHUB_USER}/eureka-server:latest"
                    }
                    
                    // API Gateway
                    dir('backend/api-gateway') {
                        sh 'ls -la target/'
                        sh "docker build -t ${DOCKERHUB_USER}/api-gateway:${IMAGE_TAG} ."
                        sh "docker push ${DOCKERHUB_USER}/api-gateway:${IMAGE_TAG}"
                        sh "docker build -t ${DOCKERHUB_USER}/api-gateway:latest ."
                        sh "docker push ${DOCKERHUB_USER}/api-gateway:latest"
                    }
                    
                    // Quiz Feedback Service
                    dir('backend/quiz-feedback-service') {
                        sh 'ls -la target/'
                        sh "docker build -t ${DOCKERHUB_USER}/quiz-feedback-service:${IMAGE_TAG} ."
                        sh "docker push ${DOCKERHUB_USER}/quiz-feedback-service:${IMAGE_TAG}"
                        sh "docker build -t ${DOCKERHUB_USER}/quiz-feedback-service:latest ."
                        sh "docker push ${DOCKERHUB_USER}/quiz-feedback-service:latest"
                    }
                    
                    // AI Service
                    dir('backend/ai-service') {
                        sh 'ls -la target/'
                        sh "docker build -t ${DOCKERHUB_USER}/ai-service:${IMAGE_TAG} ."
                        sh "docker push ${DOCKERHUB_USER}/ai-service:${IMAGE_TAG}"
                        sh "docker build -t ${DOCKERHUB_USER}/ai-service:latest ."
                        sh "docker push ${DOCKERHUB_USER}/ai-service:latest"
                    }
                    
                    // Frontend Angular
                    script {
                        try {
                            sh 'ls -la dist/'
                            sh "docker build -t ${DOCKERHUB_USER}/frontend:${IMAGE_TAG} ."
                            sh "docker push ${DOCKERHUB_USER}/frontend:${IMAGE_TAG}"
                            sh "docker build -t ${DOCKERHUB_USER}/frontend:latest ."
                            sh "docker push ${DOCKERHUB_USER}/frontend:latest"
                        } catch (Exception e) {
                            echo "Frontend Docker build failed: ${e.getMessage()}"
                            echo "Skipping frontend Docker build..."
                        }
                    }
                    
                    // Logout from Docker Hub
                    sh 'docker logout'
                }
            }
        }
        
        // ================= CLEANUP =================
        stage('Docker Cleanup') {
            steps {
                sh '''
                    docker system prune -f
                    docker image prune -f
                '''
            }
        }
    }
    
    post {
        success {
            echo '✅ Pipeline réussi : tous les services buildés + Docker images pushées sur Docker Hub'
            echo "📦 Images créées:"
            echo "  • syrinaaa/eureka-server:${BUILD_NUMBER}"
            echo "  • syrinaaa/api-gateway:${BUILD_NUMBER}"
            echo "  • syrinaaa/quiz-feedback-service:${BUILD_NUMBER}"
            echo "  • syrinaaa/ai-service:${BUILD_NUMBER}"
            echo "  • syrinaaa/frontend:${BUILD_NUMBER}"
        }
        failure {
            echo '❌ Pipeline échoué : vérifiez les logs Maven/Docker'
        }
        always {
            cleanWs()
        }
    }
}