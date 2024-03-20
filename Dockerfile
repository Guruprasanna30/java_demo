FROM maven:3.8.4-openjdk-17 as build
WORKDIR /app

#Copy your project files into the image
COPY src ./src
COPY pom.xml .

#Build the application, skipping tests to speed up the build
RUN mvn clean package -DskipTests

#Stage 2: Create the final Docker image with just the built jar file
FROM openjdk:17-jdk-slim as runtime
WORKDIR /app

#Copy the built jar file from the build stage
COPY --from=build /app/target/demo-0.0.1-SNAPSHOT.jar app.jar

#Expose the application's port
EXPOSE 8080

#Define the container's entry point here
ENTRYPOINT ["java", "-jar", "app.jar"]