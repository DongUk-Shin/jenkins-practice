pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        REMOTE_DIR  = '/root/deploy'
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'  // Jenkins 홈 기준 키
        JAR_FILE    = 'build/libs/myapp.jar'
    }

    stages {

        stage('Build') {
            steps {
                sh 'chmod +x ./gradlew'
                sh './gradlew clean build'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying JAR to remote server via SSH'

                sh """
                # 원격 디렉터리 생성 및 권한 설정
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}"

                # JAR 파일 전송
                scp -o StrictHostKeyChecking=no -i ${SSH_KEY} ${JAR_FILE} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/

                # 배포 확인
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "ls -l ${REMOTE_DIR}/"
                """
            }
        }
    }

    post {
        success {
            echo 'Build & Deploy SUCCESS!'
        }
        failure {
            echo 'Build or Deploy FAILED!'
        }
    }
}
