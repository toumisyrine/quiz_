pipeline {
    agent any

    environment {
        DOCKERHUB_USER = 'syrinaaa'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Build All Services') {
            parallel {
                stage('Trigger Eureka Server') {
                    steps {
                        build job: 'eureka-server-pipeline', 
                              parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME ?: 'quiz-feedback_branch')]
                    }
                }
                stage('Trigger API Gateway') {
                    steps {
                        build job: 'api-gateway-pipeline',
                              parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME ?: 'quiz-feedback_branch')]
                    }
                }
                stage('Trigger Quiz Feedback Service') {
                    steps {
                        build job: 'quiz-feedback-service-pipeline',
                              parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME ?: 'quiz-feedback_branch')]
                    }
                }
                stage('Trigger AI Service') {
                    steps {
                        build job: 'ai-service-pipeline',
                              parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME ?: 'quiz-feedback_branch')]
                    }
                }
                // stage('Trigger Frontend') {
                //     steps {
                //         build job: 'frontend-pipeline',
                //               parameters: [string(name: 'BRANCH', value: env.BRANCH_NAME ?: 'quiz-feedback_branch')]
                //     }
                // }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                echo '🚀 Déclenchement du déploiement Kubernetes...'
                build job: 'k8s-deployment-pipeline',
                      parameters: [
                          string(name: 'IMAGE_TAG', value: "${BUILD_NUMBER}"),
                          string(name: 'ENVIRONMENT', value: 'production')
                      ]
            }
        }
    }

    post {
        success {
            echo '🎉 TOUS LES SERVICES ONT ÉTÉ BUILDÉS AVEC SUCCÈS!'
            echo "📦 Images Docker créées:"
            echo "  • ${DOCKERHUB_USER}/eureka-server:${IMAGE_TAG}"
            echo "  • ${DOCKERHUB_USER}/api-gateway:${IMAGE_TAG}"
            echo "  • ${DOCKERHUB_USER}/quiz-feedback-service:${IMAGE_TAG}"
            echo "  • ${DOCKERHUB_USER}/ai-service:${IMAGE_TAG}"
            // echo "  • ${DOCKERHUB_USER}/frontend:${IMAGE_TAG}"
            echo ""
            echo "☸️ Déploiement Kubernetes lancé automatiquement!"
        }
        failure {
            echo '❌ Un ou plusieurs services ont échoué!'
        }
    }
}
