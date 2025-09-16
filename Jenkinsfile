pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        REMOTE_DIR  = '/root/deploy'
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'
        JAR_FILE    = 'build/libs/jenkins-practice-0.0.1-SNAPSHOT.jar'
        SERVER_PORT = '8081'
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
                echo 'Deploying JAR to remote server'
                sh """
                    # 원격 디렉터리 생성
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} \
                        "mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}"

                    # JAR 파일 전송
                    scp -o StrictHostKeyChecking=no -i ${SSH_KEY} ${JAR_FILE} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/

                    # 배포 확인
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} \
                        "ls -l ${REMOTE_DIR}/"
                """
            }
        }

        stage('Run Application') {
            steps {
                echo 'Starting Spring Boot application on remote server'
                sh """
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} '
                        # 이전 실행 중인 JAR 프로세스 종료 (배포 대상 JAR만)
                        CURRENT_PID=\$(pgrep -f "jenkins-practice-.*\\.jar") || true
                        if [ ! -z "\$CURRENT_PID" ]; then
                            echo "Stopping existing process \$CURRENT_PID"
                            kill -15 \$CURRENT_PID || true
                        fi

                        # JAR 실행 (백그라운드, SSH 종료에도 유지)
                        nohup java -jar ${REMOTE_DIR}/jenkins-practice-0.0.1-SNAPSHOT.jar --server.port=${SERVER_PORT} \
                            > ${REMOTE_DIR}/app.log 2>&1 &
                    '
                """
            }
        }
    }

    post {
        success {
            echo 'Build, Deploy & Run SUCCESS!'
        }
        failure {
            echo 'Build, Deploy or Run FAILED!'
        }
    }
}
