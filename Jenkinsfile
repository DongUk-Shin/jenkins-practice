pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        REMOTE_DIR  = '/root/deploy'
        SSH_KEY     = '/var/lib/jenkins/.ssh/id_rsa'
        BUILD_DIR   = 'build/libs'
        RUN_SCRIPT  = 'run.sh'
        JAR_FILE    = 'app.jar'
    }

    stages {
        stage('Build') {
            steps {
                sh 'chmod +x ./gradlew'
                sh "./gradlew clean build"
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying JAR and run script'
                sh """
                    ssh -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'mkdir -p ${REMOTE_DIR} && chmod 755 ${REMOTE_DIR}'
                    scp -i ${SSH_KEY} ${BUILD_DIR}/*.jar ${RUN_SCRIPT} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/
                """
            }
        }

        stage('Run') {
            steps {
                echo 'Running the application'
                sh """
                    ssh -i ${SSH_KEY} ${REMOTE_USER}@${REMOTE_HOST} 'chmod +x ${REMOTE_DIR}/${RUN_SCRIPT} && bash ${REMOTE_DIR}/${RUN_SCRIPT}'
                """
            }
        }
    }

    post {
        success { echo 'Build & Deploy SUCCESS!' }
        failure { echo 'Build or Deploy FAILED!' }
    }
}
