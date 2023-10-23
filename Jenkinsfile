pipeline {
    agent any // 사용 가능한 에이전트를 선택하거나 빈 문자열을 사용하여 자유 스타일 프로젝트를 실행

    environment {
        DOCKER_IMAGE = 'config-deploy:latest'
    }

    stages {
        stage('Checkout') {
            steps {
                // GitLab에서 소스 코드를 가져옴
                checkout scm
            }
        }

        stage('Build') {
            steps {
                // Spring Boot 프로젝트 빌드
                sh './gradlew clean build'
            }
        }

        stage('Docker Build') {
            steps {
                // Docker 이미지 빌드
                sh "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Deploy') {
            steps {
                // Docker 컨테이너 실행
                sh "docker run -d -p 8081:8080 --name your-container-name ${DOCKER_IMAGE}"
            }
        }
    }

    post {
        success {
            // 배포 성공 시 
        }
        failure {
            // 배포가 실패했을 때 실행할 작업을 정의할 수 있습니다.
        }
    }
}
