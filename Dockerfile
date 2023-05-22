# Use an appropriate base image that has Maven and Java installed
FROM maven:3.8.4-openjdk-11-slim AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml file to the container
COPY pom.xml .

# Download the dependencies specified in the pom.xml
RUN mvn dependency:go-offline

# Copy the source code to the container
COPY src ./src

# Build the application using Maven
RUN mvn package -DskipTests

# Use an appropriate NGINX base image
FROM tomcat:latest

# Copy the built application artifact from the previous stage to the NGINX container
COPY --from=build /app/target/mvn-hello-world.war /usr/share/local/webapps

# Expose the default NGINX port (80)
EXPOSE 8080

# Start NGINX when the container starts
CMD ["catalina.sh" "run"]
