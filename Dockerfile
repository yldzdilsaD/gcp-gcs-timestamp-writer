# -------- BUILD STAGE --------
FROM gradle:8.6-jdk21 AS builder

WORKDIR /app

# Gradle cache
COPY build.gradle.kts settings.gradle.kts gradle.properties* ./
COPY gradle ./gradle
RUN gradle dependencies --no-daemon

# Source
COPY src ./src

# Build jar
RUN gradle clean build --no-daemon

# -------- RUNTIME STAGE --------
FROM eclipse-temurin:21-jre

WORKDIR /app

COPY --from=builder /app/build/libs/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]
