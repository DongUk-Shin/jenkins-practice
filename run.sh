#!/bin/bash

DEPLOY_DIR="/root/deploy"
LOG_FILE="app.log"
JAR_FILE="$DEPLOY_DIR/app.jar"

cd "$DEPLOY_DIR" || exit 1

# 이전 프로세스 종료
PID=$(pgrep -f "$JAR_FILE") || true
if [ ! -z "$PID" ]; then
    echo "Stopping existing process (PID: $PID)"
    kill -9 "$PID"
    sleep 2
fi

# JAR 실행
echo "Starting $JAR_FILE..."
nohup java -jar "$JAR_FILE" > "$LOG_FILE" 2>&1 &
echo "$JAR_FILE started. Logs: $DEPLOY_DIR/$LOG_FILE"
