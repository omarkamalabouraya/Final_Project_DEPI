# First stage: Build the application
FROM maven:3.9.2-eclipse-temurin-17 AS builder

WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Second stage: Run the app using Tomcat
FROM tomcat:9.0-jdk17-temurin

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the generated WAR from the builder stage
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/jpetstore.war

EXPOSE 8080
CMD ["catalina.sh", "run"]