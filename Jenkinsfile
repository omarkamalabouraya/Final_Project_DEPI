pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE = "omarkamalabouraya/jpetstore2"
        DOCKER_TAG = "latest"
    }
    
    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            options {
                timeout(time: 15, unit: 'MINUTES')
            }
            steps {
                sh 'docker run --rm -v $PWD:/app -w /app maven:3.9.2-eclipse-temurin-17 mvn clean package'
            }
        }
        
        stage('Test') {
            options {
                timeout(time: 10, unit: 'MINUTES')
            }
            steps {
                sh 'chmod +x mvnw'
                sh './mvnw test'
            }
            post {
                always {
                    junit '**/target/surefire-reports/*.xml'
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}", "--no-cache .")
                }
            }
        }
        
        stage('Login to DockerHub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                }
            }
        }
        
        stage('Push Docker Image') {
            steps {
                sh "docker push ${DOCKER_IMAGE}:${DOCKER_TAG}"
            }
            post {
                always {
                    sh 'docker logout'
                }
            }
        }
        
        stage('Deploy with Ansible') {
            steps {
                ansiblePlaybook(
                    playbook: 'deploy.yml',
                    inventory: 'inventory.ini',
                    extraVars: [
                        docker_image: "${DOCKER_IMAGE}",
                        docker_tag: "${DOCKER_TAG}"
                    ]
                )
            }
        }
        
        stage('Setup Monitoring') {
            steps {
                ansiblePlaybook(
                    playbook: 'prometheus-setup.yml',
                    inventory: 'inventory.ini'
                )
            }
        }
    }
    
    post {
        always {
            node('built-in') {
                cleanWs()
            }
        }
        success {
            node('built-in') {
                echo 'Pipeline completed successfully!'
            }
        }
        failure {
            node('built-in') {
                echo 'Pipeline failed!'
            }
        }
    }
}
