# Stage 1: Build the application using Maven and JDK 21
FROM amazoncorretto:21-alpine-jdk AS builder

ARG MONGODB_HOST=127.0.0.1
ARG MONGODB_PORT=27017
ARG MONGODB_DATABASE=purely_auth_service
ARG USER_SERVICE_PORT=9050
ARG EUREKA_SERVICE_URL=http://localhost:8761/eureka
ENV MONGODB_HOST=${MONGODB_HOST}
ENV MONGODB_PORT=${MONGODB_PORT}
ENV MONGODB_DATABASE=${MONGODB_DATABASE}
ENV USER_SERVICE_PORT=${USER_SERVICE_PORT}
ENV EUREKA_SERVICE_URL=${EUREKA_SERVICE_URL}

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

ARG MONGODB_HOST=127.0.0.1
ARG MONGODB_PORT=27017
ARG MONGODB_DATABASE=purely_auth_service
ARG USER_SERVICE_PORT=9050
ARG EUREKA_SERVICE_URL=http://localhost:8761/eureka
ENV MONGODB_HOST=${MONGODB_HOST}
ENV MONGODB_PORT=${MONGODB_PORT}
ENV MONGODB_DATABASE=${MONGODB_DATABASE}
ENV USER_SERVICE_PORT=${USER_SERVICE_PORT}
ENV EUREKA_SERVICE_URL=${EUREKA_SERVICE_URL}
# Expose the port your service-registry is configured to run on (default Eureka port is 8761)
EXPOSE 9050
# Copy the jar built in the previous stage
ARG JAR_FILE=/build/target/user-service-0.0.1-SNAPSHOT.jar
COPY --from=builder ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]