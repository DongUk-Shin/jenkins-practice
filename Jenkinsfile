pipeline {
    agent any

    environment {
        REMOTE_HOST = '172.18.121.6'
        REMOTE_USER = 'root'
        JAR_FILE = 'build/libs/jenkins-practice-0.0.1-SNAPSHOT.jar'
    }

    stages {
        stage('Build') {
            steps {
                sh './gradlew clean build'
            }
        }

        stage('Deploy & Run') {
            steps {
                sh """
                scp ${JAR_FILE} ${REMOTE_USER}@${REMOTE_HOST}:/root/deploy/
                ssh ${REMOTE_USER}@${REMOTE_HOST} 'nohup java -jar /root/deploy/$(basename ${JAR_FILE}) --server.port=8081 > /root/deploy/app.log 2>&1 &'
                """
            }
        }
    }
}
