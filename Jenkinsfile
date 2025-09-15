pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                // 10초 대기
                sleep(time: 10, unit: 'SECONDS')

                sh 'chmod +x ./gradlew'
                sh './gradlew clean build'
            }
        }
    }

    post {
        success {
            echo 'Build SUCCESS!'
        }
        failure {
            echo 'Build FAILED!'
        }
    }
}