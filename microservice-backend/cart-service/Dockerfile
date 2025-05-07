# Stage 1: Build the application using Maven and JDK 21
FROM amazoncorretto:21-alpine-jdk AS builder

RUN apk add maven
WORKDIR /build
# Copy only pom.xml first to leverage Docker cache
COPY pom.xml .
# Download dependencies (requires an empty src folder if not present)
RUN mkdir -p src/main && mkdir -p src/test
RUN mvn dependency:go-offline -B
# Copy the complete source code and build the app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Create the runtime image using a slim JDK image
FROM amazoncorretto:21-alpine-jdk



EXPOSE ${SERVICE_REGISTRY_PORT}
# Copy the jar built in the previous stage
ARG JAR_FILE=/build/target/service-registry-0.0.1-SNAPSHOT.jar
COPY --from=builder ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]