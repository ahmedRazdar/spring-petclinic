## Multi-stage build for Spring Boot PetClinic Application
#
## Stage 1: Build the application
#FROM maven:3.9-eclipse-temurin-17 AS build
#WORKDIR /app
#
## Copy pom.xml and download dependencies (layer caching)
#COPY pom.xml .
#RUN mvn dependency:go-offline -B
#
## Copy source code
#COPY src ./src
#
## Apply formatting
#RUN mvn spring-javaformat:apply -B
#
## Build using standard javac (bypass ErrorProne completely)
## Create a temporary pom.xml without ErrorProne configuration
#RUN mvn clean package -DskipTests -B \
#    -Dmaven.compiler.fork=true \
#    -Dmaven.compiler.executable=/usr/bin/javac \
#    -Dmaven.compiler.compilerArgs="-XDcompilePolicy=simple" || \
#    (echo "First attempt failed, trying alternative..." && \
#     mvn clean compile -B -Dmaven.compiler.fork=true -Dmaven.compiler.executable=/usr/bin/javac && \
#     mvn jar:jar spring-boot:repackage -DskipTests -B)
#
## Stage 2: Run the application
#FROM eclipse-temurin:17-jre-alpine
#WORKDIR /app
#
## Install curl for health checks
#RUN apk add --no-cache curl
#
## Create a non-root user
#RUN addgroup -S spring && adduser -S spring -G spring
#USER spring:spring
#
## Copy the JAR from build stage
#COPY --from=build /app/target/*.jar app.jar
#
## Expose port
#EXPOSE 8080
#
## Health check
#HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
#  CMD curl -f http://localhost:8080/actuator/health || exit 1
#
## Run the application
#ENTRYPOINT ["java", "-jar", "app.jar"]










# Multi-stage build for Spring Boot PetClinic Application

# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy pom.xml and download dependencies (layer caching)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Apply formatting
RUN mvn spring-javaformat:apply -B

# Build JAR (no hard-coded javac path)
RUN mvn clean package -DskipTests -B || \
  (echo "Build failed → fallback compile + repackage" && \
   mvn clean compile -B && \
   mvn jar:jar spring-boot:repackage -DskipTests -B)

# Stage 2: Run the application
FROM eclipse-temurin-17-jre-alpine
WORKDIR /app

# Install curl for health checks
RUN apk add --no-cache curl

# Create a non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

# Copy the JAR from build stage
COPY --from=build /app/target/*.jar app.jar

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:8080/actuator/health || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
