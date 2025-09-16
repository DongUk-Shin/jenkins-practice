pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'              // 타겟 서버 IP
        REMOTE_USER = 'root'                      // SSH 접속 사용자
        REMOTE_DIR  = '/root/deploy'              // 배포 디렉터리
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa' // Jenkins 서버의 SSH 키 경로
        JAR_FILE    = 'build/libs/*.jar'          // 빌드된 JAR 파일 (와일드카드 사용)
    }

    stages {

        stage('Build') {
            steps {
                echo 'Building Spring Boot JAR'
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
