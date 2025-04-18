pipeline {
    agent any
    
    environment {
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
        DOCKER_IMAGE = "omarkamalabouraya/jpetstore"
        DOCKER_TAG = "latest"
    }
    
    stages {
        stage('Clone') {
            steps {
                checkout scm
            }
        }
        
        stage('Setup Maven Wrapper') {
            steps {
                sh 'mvn -N io.takari:maven:wrapper'
            }
        }
        
        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }
        
        stage('Test') {
            steps {
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
