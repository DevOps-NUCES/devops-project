# Stage 1: Build the application using Maven and JDK 21
FROM amazoncorretto:21-alpine-jdk AS builder

ARG API_GATEWAY_PORT=8080
ARG SERVICE_REGISTRY_SERVICE_URL=http://localhost:8761/eureka/
ARG SERVICE_REGISTRY_HOSTNAME=localhost

ENV SERVICE_REGISTRY_SERVICE_URL=${SERVICE_REGISTRY_SERVICE_URL}
ENV SERVICE_REGISTRY_HOSTNAME=${SERVICE_REGISTRY_HOSTNAME}
ENV API_GATEWAY_PORT=${API_GATEWAY_PORT}

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

ARG SERVICE_REGISTRY_SERVICE_URL=http://localhost:8761/eureka/
ARG SERVICE_REGISTRY_HOSTNAME=localhost
ARG API_GATEWAY_PORT=8080
ENV SERVICE_REGISTRY_SERVICE_URL=${SERVICE_REGISTRY_SERVICE_URL}
ENV SERVICE_REGISTRY_HOSTNAME=${SERVICE_REGISTRY_HOSTNAME}
ENV API_GATEWAY_PORT=${API_GATEWAY_PORT}

# Expose the port your service-registry is configured to run on (default Eureka port is 8761)
EXPOSE ${API_GATEWAY_PORT}
# Copy the jar built in the previous stage
ARG JAR_FILE=/build/target/api-gateway-0.0.1-SNAPSHOT.jar
COPY --from=builder ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "/app.jar"]