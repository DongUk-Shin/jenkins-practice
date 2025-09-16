#!/bin/bash

DEPLOY_DIR="/root/deploy"
JAR_NAME="jenkins-practice-0.0.1-SNAPSHOT.jar"
PORT=8081
LOG_FILE="$DEPLOY_DIR/app.log"

cd $DEPLOY_DIR

# 이전 실행 중인 JAR 프로세스 종료 (배포 대상 JAR만)
CURRENT_PID=$(pgrep -f "$JAR_NAME") || true
if [ ! -z "$CURRENT_PID" ]; then
    echo "Stopping existing process $CURRENT_PID"
    kill -15 $CURRENT_PID || true
fi

# JAR 실행 (백그라운드, SSH 종료에도 유지)
nohup java -jar $JAR_NAME --server.port=$PORT > $LOG_FILE 2>&1 &
echo "Application started on port $PORT"
