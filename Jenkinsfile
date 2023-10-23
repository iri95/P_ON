pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'config-deploy-image:latest'
        DOCKERFILE_PATH = './Dockerfile' // Dockerfile의 경로
    }

    stages {
        stage('Checkout') {
            steps {
                // GitLab에서 소스 코드 가져옴
                checkout scm
            }
        }

        stage('Project Build') {
            steps {
                // 작업 디렉토리를 'config'로 변경
                dir('config') {
                    // Spring Boot 프로젝트 빌드
                    sh 'chmod +x gradlew'
                    sh './gradlew clean build'
                }
            }
        }

        stage('Docker Build and Deploy') {
            steps {
                script {
                    // 작업 디렉토리를 'config'로 변경
                    dir('config') {
                        // Docker 이미지 빌드
                        docker.build(DOCKER_IMAGE, "--file $DOCKERFILE_PATH --build-arg JAR_FILE=build/libs/*.jar .")

                        // Docker 이미지를 실행할 컨테이너 이름
                        def CONTAINER_NAME = 'config-deploy-container'

                        // 기존 컨테이너가 실행 중인지 확인하고 중지합니다.
                        sh "docker stop -f $CONTAINER_NAME || true"
                        sh "docker rm -f $CONTAINER_NAME || true"

                        // Docker 컨테이너 실행
                        sh "docker run -d -p 8888:8888 --name $CONTAINER_NAME $DOCKER_IMAGE"
                    }
                }
            }
        }
    }

    post {
        success {
            echo '배포 성공!'
        }
        failure {
            echo '배포 실패.'
        }
    }
}