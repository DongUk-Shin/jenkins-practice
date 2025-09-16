pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'       // 타겟 서버 IP
        REMOTE_USER = 'root'               // SSH 접속 사용자
        REMOTE_DIR  = '/root/deploy'       // 배포 디렉터리
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'  // Jenkins 서버 SSH 키
        JAR_FILE    = 'build/libs/jenkins-practice-0.0.1-SNAPSHOT.jar' // 빌드된 JAR
        RUN_SCRIPT  = 'run.sh'             // 실행 스크립트
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
                echo 'Deploying JAR and run script to remote server'

                sh """
                    # 원격 디렉터리 생성
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}'

                    # JAR와 스크립트 전송
                    scp -o StrictHostKeyChecking=no -i ${SSH_KEY} ${JAR_FILE} ${RUN_SCRIPT} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/

                    # 실행 권한 부여
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'chmod +x ${REMOTE_DIR}/${RUN_SCRIPT}'

                    # 전송 확인
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'ls -l ${REMOTE_DIR}/'
                """
            }
        }

        stage('Run Application') {
            steps {
                echo 'Starting Spring Boot application on remote server'

                sh """
                    # 스크립트 실행
                    ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'cd ${REMOTE_DIR} && ./run.sh'
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
