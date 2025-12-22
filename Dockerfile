# Build stage
FROM maven:3.9-eclipse-temurin-17 AS builder

WORKDIR /build

# Copy project files
COPY pom.xml .
COPY src ./src

# Build the WAR file
RUN mvn clean package -DskipTests

# Runtime stage
FROM quay.io/wildfly/wildfly:26.1.3.Final-jdk17

# Copy the WAR file from builder stage
COPY --from=builder /build/target/jboss-demo.war /opt/jboss/wildfly/standalone/deployments/

# Set environment variables
ENV APP_NAME="JBoss Demo Application"
ENV APP_VERSION="1.0.0"
ENV APP_ENVIRONMENT="production"

# Expose ports
EXPOSE 8080 9990

# Start WildFly
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]
