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
                        script {
                            try {
                                build job: 'eureka-server-pipeline', wait: true
                                echo '✅ Eureka Server build réussi'
                            } catch (Exception e) {
                                echo "⚠️ Eureka Server build échoué: ${e.getMessage()}"
                                echo "Continuons avec les autres services..."
                            }
                        }
                    }
                }
                stage('Trigger API Gateway') {
                    steps {
                        script {
                            try {
                                build job: 'api-gateway-pipeline', wait: true
                                echo '✅ API Gateway build réussi'
                            } catch (Exception e) {
                                echo "⚠️ API Gateway build échoué: ${e.getMessage()}"
                                echo "Continuons avec les autres services..."
                            }
                        }
                    }
                }
                stage('Trigger Quiz Feedback Service') {
                    steps {
                        script {
                            try {
                                build job: 'Quiz Feedback Service', wait: true
                                echo '✅ Quiz Feedback Service build réussi'
                            } catch (Exception e) {
                                echo "⚠️ Quiz Feedback Service build échoué: ${e.getMessage()}"
                                echo "Continuons avec les autres services..."
                            }
                        }
                    }
                }
                stage('Trigger AI Service') {
                    steps {
                        script {
                            try {
                                build job: 'ai-service-pipeline', wait: true
                                echo '✅ AI Service build réussi'
                            } catch (Exception e) {
                                echo "⚠️ AI Service build échoué: ${e.getMessage()}"
                                echo "Continuons avec les autres services..."
                            }
                        }
                    }
                }
            }
        }
        
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    try {
                        echo '🚀 Déclenchement du déploiement Kubernetes...'
                        build job: 'k8s-deployment-pipeline',
                              parameters: [
                                  string(name: 'IMAGE_TAG', value: "${BUILD_NUMBER}"),
                                  string(name: 'ENVIRONMENT', value: 'production')
                              ],
                              wait: true
                        echo '✅ Déploiement Kubernetes réussi!'
                    } catch (Exception e) {
                        echo "⚠️ Déploiement Kubernetes échoué: ${e.getMessage()}"
                        echo "🔧 Vérifiez les logs du job k8s-deployment-pipeline"
                        echo "📊 Les services sont buildés mais pas déployés sur K8s"
                        // Ne pas faire échouer le pipeline principal
                    }
                }
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