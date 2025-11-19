# Build stage
FROM maven:3.8.6-eclipse-temurin-8 AS build

WORKDIR /app

# Copy pom files for dependency resolution
COPY pom.xml .
COPY yudao-dependencies/pom.xml yudao-dependencies/
COPY yudao-framework/pom.xml yudao-framework/
COPY yudao-server/pom.xml yudao-server/
COPY yudao-module-system/pom.xml yudao-module-system/
COPY yudao-module-infra/pom.xml yudao-module-infra/
COPY yudao-module-member/pom.xml yudao-module-member/
COPY yudao-module-bpm/pom.xml yudao-module-bpm/
COPY yudao-module-mall/pom.xml yudao-module-mall/
COPY yudao-module-mall/yudao-module-product/pom.xml yudao-module-mall/yudao-module-product/
COPY yudao-module-mall/yudao-module-promotion/pom.xml yudao-module-mall/yudao-module-promotion/
COPY yudao-module-mall/yudao-module-trade/pom.xml yudao-module-mall/yudao-module-trade/
COPY yudao-module-mall/yudao-module-statistics/pom.xml yudao-module-mall/yudao-module-statistics/
COPY yudao-module-crm/pom.xml yudao-module-crm/
COPY yudao-module-erp/pom.xml yudao-module-erp/

# Download dependencies (cached layer)
RUN mvn dependency:go-offline -B

# Copy source code
COPY . .

# Build application
RUN mvn clean package -DskipTests -Dmaven.test.skip=true

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
