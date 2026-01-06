== Spring Boot Admin (SBA)
<spring-boot-admin>

=== Giới thiệu
<giới-thiệu-sba>
Spring Boot Admin (SBA) là một giao diện web cộng đồng (community project) dùng để quản lý và giám sát các ứng dụng Spring Boot. Nó hiển thị trực quan các thông tin từ Actuator (Health, Info, Metrics, Loggers...).

#strong[Tính năng chính:]
- Xem chi tiết Health Check (Service Up/Down).
- Xem và thay đổi Log Level (Runtime).
- Xem JVM Metrics (Memory, Threads, GC).
- Xem Environment Variables & System Properties.
- Quản lý các phiên làm việc (Sessions).

=== Kiến trúc
<kiến-trúc-sba>
Mô hình Client-Server:
- #strong[SBA Server]: Nơi chạy giao diện Dashboard, thu thập dữ liệu.
- #strong[SBA Client]: Các microservice cần được giám sát, gửi dữ liệu về Server.

=== Cài đặt SBA Server
<setup-server>

#strong[1. Dependency]
```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-server</artifactId>
    <version>3.1.0</version>
</dependency>
```

#strong[2. Enable Server]
```java
@SpringBootApplication
@EnableAdminServer // Quan trọng!
public class AdminServerApplication {
    public static void main(String[] args) {
        SpringApplication.run(AdminServerApplication.class, args);
    }
}
```

#strong[3. Config Port]
```yaml
server:
  port: 8081 # Tránh trùng port 8080 của app khác
```

=== Cài đặt SBA Client
<setup-client>
Tại các microservice (ví dụ: Product Service, Order Service).

#strong[1. Dependency]
```xml
<dependency>
    <groupId>de.codecentric</groupId>
    <artifactId>spring-boot-admin-starter-client</artifactId>
    <version>3.1.0</version>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

#strong[2. Config `application.yml`]
```yaml
spring:
  boot:
    admin:
      client:
        url: http://localhost:8081 # Địa chỉ của SBA Server
        instance:
          name: Product-Service # Tên hiển thị trên Dashboard
management:
  endpoints:
    web:
      exposure:
        include: "*" # Bật full actuator để SBA lấy dữ liệu
  endpoint:
    health:
      show-details: always
```

=== Bảo mật SBA (Security)
<secure-sba>
Vì SBA cho phép thay đổi log level và xem env vars, #strong[bắt buộc] phải bảo mật nó.

#strong[Server Side:] Thêm Spring Security và cấu hình login form.
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```
Cấu hình SecurityConfig để cho phép login và access vào các file static (js/css) của dashboard.

#strong[Client Side:] Nếu Server có pass, Client phải khai báo để register.
```yaml
spring:
  boot:
    admin:
      client:
        username: admin
        password: secure_password
```

=== Thông báo (Notifications)
<sba-notifications>
SBA hỗ trợ gửi thông báo khi một service bị DOWN qua Email, Slack, Microsoft Teams, Discord, Telegram...

Ví dụ cấu hình gửi mail:
```yaml
spring:
  boot:
    admin:
      notify:
        mail:
          to: admin@company.com
          from: sba@company.com
```