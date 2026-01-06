== Spring Boot & Docker
<spring-boot-docker>

=== Tại sao dùng Docker cho Spring Boot?
<why-docker>
Containerization giúp đóng gói ứng dụng cùng với mọi thư viện, môi trường runtime (JDK) và cấu hình vào một "container" duy nhất. Điều này giải quyết triệt để vấn đề "Works on my machine".

=== Dockerfile tối ưu (Multi-stage Build)
<dockerfile-optimized>
Sử dụng multi-stage build giúp giảm kích thước image cuối cùng (chỉ chứa JRE và file JAR, không chứa source code hay Maven repository).

```dockerfile
# Stage 1: Build
FROM eclipse-temurin:17-jdk-alpine as builder
WORKDIR /app
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
# Tải dependency trước để tận dụng cache layer
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
# Tạo user non-root để tăng bảo mật
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

COPY --from=builder /app/target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]
```

=== Google Jib (Build không cần Dockerfile)
<google-jib>
Jib là plugin của Google giúp build Docker image trực tiếp từ Maven/Gradle mà không cần cài Docker Daemon hay viết Dockerfile. Nó tối ưu layer cực tốt.

Thêm vào `pom.xml`:
```xml
<plugin>
    <groupId>com.google.cloud.tools</groupId>
    <artifactId>jib-maven-plugin</artifactId>
    <version>3.3.1</version>
    <configuration>
        <to>
            <image>my-docker-hub-username/my-app</image>
        </to>
    </configuration>
</plugin>
```
Chạy lệnh: `mvn jib:build` (đẩy lên registry) hoặc `mvn jib:dockerBuild` (build vào daemon local).

=== Docker Compose cho môi trường Dev
<docker-compose-full>
Dựng toàn bộ hệ thống (App + DB + Redis + RabbitMQ) chỉ với 1 lệnh.

```yaml
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/mydb
      - SPRING_REDIS_HOST=redis
    depends_on:
      - db
      - redis
  
  db:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: mydb
    ports:
      - "3306:3306"
    volumes:
      - db_data:/var/lib/mysql
      
  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

volumes:
  db_data:
```

=== Best Practices khi chạy trong Container
<docker-best-practices>
1. #strong[Graceful Shutdown]: Spring Boot hỗ trợ tắt từ từ. Đảm bảo Docker gửi signal `SIGTERM` (không phải `SIGKILL` ngay lập tức).
   Trong `application.yml`:
   ```yaml
   server:
     shutdown: graceful
   spring:
     lifecycle:
       timeout-per-shutdown-phase: 20s
   ```
2. #strong[Memory Limit]: JVM không tự nhận biết giới hạn RAM của container (trước Java 10).
   Luôn thêm flag: `-XX:+UseContainerSupport -XX:MaxRAMPercentage=75.0` để JVM dùng tối đa 75% RAM container.
3. #strong[Health Check]: Khai báo HEALTHCHECK trong Dockerfile hoặc docker-compose dùng `curl -f http://localhost:8080/actuator/health || exit 1`.