# Multi-stage build for Workshop Organizer API
# Stage 1: Build with JDK
FROM eclipse-temurin:21-jdk-jammy as builder

WORKDIR /build

# Copy Gradle wrapper and configuration
COPY gradlew gradlew.bat ./
COPY gradle ./gradle
COPY build.gradle settings.gradle ./

# Copy source code
COPY src ./src

# Make gradlew executable and fix line endings
RUN chmod +x ./gradlew && sed -i 's/\r$//' ./gradlew

# Build the application JAR
RUN ./gradlew clean bootJar --no-daemon

# Stage 2: Runtime with minimal JRE
FROM eclipse-temurin:21-jre-jammy

WORKDIR /app

# Install curl for healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Copy the built JAR from builder stage
COPY --from=builder /build/build/libs/*.jar app.jar

# Expose the application port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=40s \
    CMD curl -f http://localhost:8080/api/workshops || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
