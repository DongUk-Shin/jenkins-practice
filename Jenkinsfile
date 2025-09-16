pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        REMOTE_DIR  = '/root/deploy'
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'
        BUILD_DIR   = 'build/libs'
        RUN_SCRIPT  = 'run.sh'
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
                echo 'Deploying latest JAR and run script'

                sh """
                    # 원격 디렉터리 생성
                    ssh -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}'

                    # 최신 JAR 파일 찾기
                    LATEST_JAR=\$(ls -t ${BUILD_DIR}/*.jar | head -n 1)

                    if [ -z "\$LATEST_JAR" ]; then
                        echo "No JAR file found!"
                        exit 1
                    fi

                    # JAR와 run.sh 전송
                    scp -i ${SSH_KEY} "\$LATEST_JAR" ${RUN_SCRIPT} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/

                    # 실행 권한 부여
                    ssh -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'chmod +x ${REMOTE_DIR}/${RUN_SCRIPT}'

                    # run.sh 실행
                    ssh -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'bash ${REMOTE_DIR}/${RUN_SCRIPT}'

                    # 전송 및 실행 확인
                    ssh -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'ls -l ${REMOTE_DIR}/'
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
