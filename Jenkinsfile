pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        REMOTE_DIR  = '/root/deploy'
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'
        JAR_FILE    = 'build/libs/jenkins-practice-0.0.1-SNAPSHOT.jar'
        APP_PORT    = '8081'
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
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}"
                scp -o StrictHostKeyChecking=no -i ${SSH_KEY} ${JAR_FILE} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "ls -l ${REMOTE_DIR}/"
                """
            }
        }

        stage('Run Application') {
            steps {
                echo 'Starting Spring Boot application on remote server'
                sh """
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "
                pkill -f 'java.*/root/deploy' || true
                nohup java -jar ${REMOTE_DIR}/jenkins-practice-0.0.1-SNAPSHOT.jar --server.port=${APP_PORT} > ${REMOTE_DIR}/app.log 2>&1 &
                "
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
