# Stage 1: Build the application using Maven and JDK 21
FROM amazoncorretto:21-alpine-jdk AS builder

ARG MONGODB_HOST=mongodb
ARG MONGODB_PORT=27017
ARG MONGODB_DATABASE=purely_auth_service
ARG MONGODB_USERNAME=admin
ARG MONGODB_PASSWORD=password
ARG MONGODB_AUTHSOURCE=admin
ARG USER_SERVICE_PORT=9050
ARG SERVICE_REGISTRY_SERVICE_URL=http://localhost:8761/eureka
ARG SERVICE_REGISTRY_HOSTNAME=localhost

ENV MONGODB_HOST=${MONGODB_HOST}
ENV MONGODB_PORT=${MONGODB_PORT}
ENV MONGODB_DATABASE=${MONGODB_DATABASE}
ENV MONGODB_USERNAME=${MONGODB_USERNAME}
ENV MONGODB_PASSWORD=${MONGODB_PASSWORD}
ENV MONGODB_AUTHSOURCE=${MONGODB_AUTHSOURCE}
ENV USER_SERVICE_PORT=${USER_SERVICE_PORT}
ENV SERVICE_REGISTRY_SERVICE_URL=${SERVICE_REGISTRY_SERVICE_URL}
ENV SERVICE_REGISTRY_HOSTNAME=${SERVICE_REGISTRY_HOSTNAME}


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

ARG MONGODB_HOST=mongodb
ARG MONGODB_PORT=27017
ARG MONGODB_DATABASE=purely_auth_service
ARG MONGODB_USERNAME=admin
ARG MONGODB_PASSWORD=password
ARG MONGODB_AUTHSOURCE=admin
ARG USER_SERVICE_PORT=9050
ARG SERVICE_REGISTRY_SERVICE_URL=http://localhost:8761/eureka
ARG SERVICE_REGISTRY_HOSTNAME=localhost


ENV MONGODB_HOST=${MONGODB_HOST}
ENV MONGODB_PORT=${MONGODB_PORT}
ENV MONGODB_DATABASE=${MONGODB_DATABASE}
ENV MONGODB_USERNAME=${MONGODB_USERNAME}
ENV MONGODB_PASSWORD=${MONGODB_PASSWORD}
ENV MONGODB_AUTHSOURCE=${MONGODB_AUTHSOURCE}
ENV USER_SERVICE_PORT=${USER_SERVICE_PORT}
ENV SERVICE_REGISTRY_SERVICE_URL=${SERVICE_REGISTRY_SERVICE_URL}
ENV SERVICE_REGISTRY_HOSTNAME=${SERVICE_REGISTRY_HOSTNAME}
# Expose the port your service-registry is configured to run on (default Eureka port is 8761)
EXPOSE ${USER_SERVICE_PORT}
# Copy the jar built in the previous stage
ARG JAR_FILE=/build/target/user-service-0.0.1-SNAPSHOT.jar
COPY --from=builder ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]