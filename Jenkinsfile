pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        REMOTE_DIR  = '/root/deploy'
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'
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

                sh """
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}"
                scp -o StrictHostKeyChecking=no -i ${SSH_KEY} ${JAR_FILE} ${RUN_SCRIPT} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "ls -l ${REMOTE_DIR}/"
                """
            }
        }

        stage('Run Application') {
            steps {
                echo 'Starting Spring Boot application on remote server'
                sh """
                ssh -o StrictHostKeyChecking=no -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} "cd ${REMOTE_DIR} && ./run.sh"
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
