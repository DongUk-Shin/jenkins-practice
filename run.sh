#!/bin/bash

# 배포 디렉터리
DEPLOY_DIR="/root/deploy"
LOG_FILE="app.log"

cd "$DEPLOY_DIR" || { echo "Cannot cd to $DEPLOY_DIR"; exit 1; }

# 최신 JAR 파일 찾기 (*.jar)
JAR_FILE=$(ls -t *.jar 2>/dev/null | head -n 1)

if [ -z "$JAR_FILE" ]; then
    echo "No JAR file found in $DEPLOY_DIR"
    exit 1
fi

# 이전 프로세스 종료
PID=$(pgrep -f "$JAR_FILE")
if [ ! -z "$PID" ]; then
    echo "Stopping existing process (PID: $PID)"
    kill -9 "$PID"
    sleep 2
fi

# JAR 실행
echo "Starting $JAR_FILE..."
nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &

echo "$JAR_FILE started. Logs: $DEPLOY_DIR/$LOG_FILE"
