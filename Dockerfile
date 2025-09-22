FROM gradle:8.4.0-jdk17 as builder
WORKDIR /app
COPY . .

# 성능 TEST
RUN gradle clean build --no-daemon --rerun-tasks
RUN gradle clean build --no-daemon --rerun-tasks
RUN gradle clean build --no-daemon --rerun-tasks
RUN gradle clean build --no-daemon --rerun-tasks
RUN gradle clean build --no-daemon --rerun-tasks

FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=builder /app/build/libs/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]