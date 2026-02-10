pipeline {
    agent any
    
    environment {
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '737026300147'
        ECR_BACKEND_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/devops-challenge/backend"
        ECR_FRONTEND_REPO = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/devops-challenge/frontend"
        ECS_CLUSTER = 'devops-challenge-dev-cluster'
        ECS_BACKEND_SERVICE = 'devops-challenge-dev-backend-service'
        ECS_FRONTEND_SERVICE = 'devops-challenge-dev-frontend-service'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Docker Images') {
            parallel {
                stage('Build Backend') {
                    steps {
                        dir('backend') {
                            sh 'docker build -t backend:${IMAGE_TAG} .'
                        }
                    }
                }
                stage('Build Frontend') {
                    steps {
                        dir('frontend') {
                            sh 'docker build -t frontend:${IMAGE_TAG} .'
                        }
                    }
                }
            }
        }
        
        stage('Security Scan with Trivy') {
            parallel {
                stage('Scan Backend') {
                    steps {
                        sh 'trivy image --no-progress --cache-dir /tmp/trivy-cache-backend --severity HIGH,CRITICAL --exit-code 0 backend:${IMAGE_TAG}'
                    }
                }
                stage('Scan Frontend') {
                    steps {
                        sh 'trivy image --no-progress --cache-dir /tmp/trivy-cache-frontend --severity HIGH,CRITICAL --exit-code 0 frontend:${IMAGE_TAG}'
                    }
                }
            }
        }
        
        stage('Push to ECR') {
            steps {
                script {
                    // Login to ECR
                    sh '''
                        aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                    '''
                    
                    // Tag and push backend
                    sh '''
                        docker tag backend:${IMAGE_TAG} ${ECR_BACKEND_REPO}:${IMAGE_TAG}
                        docker tag backend:${IMAGE_TAG} ${ECR_BACKEND_REPO}:latest
                        docker push ${ECR_BACKEND_REPO}:${IMAGE_TAG}
                        docker push ${ECR_BACKEND_REPO}:latest
                    '''
                    
                    // Tag and push frontend
                    sh '''
                        docker tag frontend:${IMAGE_TAG} ${ECR_FRONTEND_REPO}:${IMAGE_TAG}
                        docker tag frontend:${IMAGE_TAG} ${ECR_FRONTEND_REPO}:latest
                        docker push ${ECR_FRONTEND_REPO}:${IMAGE_TAG}
                        docker push ${ECR_FRONTEND_REPO}:latest
                    '''
                }
            }
        }
        
        stage('Deploy to ECS') {
            steps {
                script {
                    // Update backend task definition
                    sh '''
                        TASK_DEF=$(aws ecs describe-task-definition --task-definition devops-challenge-dev-backend --region ${AWS_REGION})
                        NEW_TASK_DEF=$(echo $TASK_DEF | jq --arg IMAGE "${ECR_BACKEND_REPO}:${IMAGE_TAG}" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) | del(.registeredAt) | del(.registeredBy)')
                        aws ecs register-task-definition --cli-input-json "$NEW_TASK_DEF" --region ${AWS_REGION}
                        aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_BACKEND_SERVICE} --task-definition devops-challenge-dev-backend --region ${AWS_REGION}
                    '''
                    
                    // Update frontend task definition
                    sh '''
                        TASK_DEF=$(aws ecs describe-task-definition --task-definition devops-challenge-dev-frontend --region ${AWS_REGION})
                        NEW_TASK_DEF=$(echo $TASK_DEF | jq --arg IMAGE "${ECR_FRONTEND_REPO}:${IMAGE_TAG}" '.taskDefinition | .containerDefinitions[0].image = $IMAGE | del(.taskDefinitionArn) | del(.revision) | del(.status) | del(.requiresAttributes) | del(.compatibilities) | del(.registeredAt) | del(.registeredBy)')
                        aws ecs register-task-definition --cli-input-json "$NEW_TASK_DEF" --region ${AWS_REGION}
                        aws ecs update-service --cluster ${ECS_CLUSTER} --service ${ECS_FRONTEND_SERVICE} --task-definition devops-challenge-dev-frontend --region ${AWS_REGION}
                    '''
                }
            }
        }
    }
    
    post {
        always {
            // Clean up Docker images to save space
            sh '''
                docker rmi backend:${IMAGE_TAG} || true
                docker rmi frontend:${IMAGE_TAG} || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}