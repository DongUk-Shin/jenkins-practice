#!/bin/bash

# 이전 실행 중인 JAR 종료 (배포 대상 JAR만)
CURRENT_PID=$(pgrep -f "jenkins-practice-.*\.jar") || true
if [ ! -z "$CURRENT_PID" ]; then
    echo "Stopping existing process $CURRENT_PID"
    kill -15 $CURRENT_PID || true
fi

# JAR 실행 (백그라운드, 로그 저장)
nohup java -jar jenkins-practice-0.0.1-SNAPSHOT.jar --server.port=8081 > app.log 2>&1 &
echo "Application started, logs: app.log"
