# Use a Maven image with JDK to build and run the app
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Set the working directory
WORKDIR /app

# Copy project files
COPY . .

# Make mvnw executable
RUN chmod +x mvnw

# Expose the port Tomcat will use
EXPOSE 8080

# Run the app using Maven Wrapper and Cargo plugin for Tomcat
CMD ["./mvnw", "cargo:run", "-P", "tomcat90"]
