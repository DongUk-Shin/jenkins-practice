pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'          // 타겟 서버 IP
        REMOTE_USER = 'root'                  // SSH 접속 사용자
        REMOTE_DIR  = '/root/deploy'          // 배포 디렉터리
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'  // Jenkins 서버 SSH 키
        JAR_FILE    = 'build/libs/jenkins-practice-0.0.1-SNAPSHOT.jar'
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
                echo 'Deploying JAR and run script to remote server'

                // 원격 디렉터리 생성
                sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}'"

                // JAR + run.sh 전송
                sh "scp -o StrictHostKeyChecking=no -i ${SSH_KEY} ${JAR_FILE} ${RUN_SCRIPT} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"

                // 실행
                sh "ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_DIR} && ./run.sh'"
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
