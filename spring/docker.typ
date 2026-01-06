== Spring Boot Docker
<spring-boot-docker>
=== Dockerfile cơ bản (Multi-stage build)
<dockerfile-cơ-bản-multi-stage-build>
```dockerfile
FROM eclipse-temurin:17-jdk as build
WORKDIR /app
COPY pom.xml mvnw .
COPY src ./src
RUN ./mvnw -DskipTests package

FROM eclipse-temurin:17-jre
COPY --from=build /app/target/app.jar /app/app.jar
ENTRYPOINT ["java","-jar","/app/app.jar"]
```

=== Docker Compose
<docker-compose>
```yaml
services:
  app:
    build: .
    ports:
      - "8080:8080"
    depends_on:
      - db
```
