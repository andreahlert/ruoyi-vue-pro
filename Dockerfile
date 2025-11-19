# Build stage
FROM maven:3.8.6-eclipse-temurin-8 AS build

WORKDIR /app

# Copy all source code (simpler, more reliable)
COPY . .

# Build application
RUN mvn clean package -DskipTests -Dmaven.test.skip=true -B

# Runtime stage
FROM eclipse-temurin:8-jre-alpine

WORKDIR /app

# Copy the built jar from build stage
COPY --from=build /app/yudao-server/target/yudao-server.jar app.jar

# Expose application port
EXPOSE 48080

# Set timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Run the application
ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
