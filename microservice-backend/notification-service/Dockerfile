# Build stage
FROM amazoncorretto:17-alpine-jdk AS build
RUN apk add --no-cache maven
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Runtime stage
FROM amazoncorretto:17-alpine-jdk
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 9020
ENTRYPOINT ["java", "-jar", "app.jar"]