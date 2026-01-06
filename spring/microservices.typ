== Spring Cloud Microservices
<microservices-modules>

Hệ sinh thái Spring Cloud cung cấp các mảnh ghép để xây dựng hệ thống phân tán mạnh mẽ.

=== Service Discovery (Eureka)
<eureka>
Thay vì hard-code IP (vốn thay đổi liên tục), các service tìm nhau qua tên.

#strong[1. Eureka Server]
Là danh bạ điện thoại lưu danh sách các service đang chạy.
- Dependency: `spring-cloud-starter-netflix-eureka-server`
- App: `@EnableEurekaServer`
- Config: `register-with-eureka: false` (vì nó là server).

#strong[2. Eureka Client]
Là các service nghiệp vụ (Order, User...).
- Dependency: `spring-cloud-starter-netflix-eureka-client`
- App: `@EnableDiscoveryClient`
- Khi khởi động, nó gửi IP/Port lên Server. Nó cũng định kỳ gửi "heartbeat" để báo "tôi còn sống".

=== Load Balancing (Spring Cloud LoadBalancer)
<load-balancer>
Trước đây dùng Ribbon (đã maintenance mode), giờ dùng Spring Cloud LoadBalancer.
Nó nằm ở phía Client (Client-side LB). Khi Service A gọi Service B (có 3 instance), LB tại A sẽ quyết định gọi instance nào.

- #strong[Round Robin]: Lần lượt.
- #strong[Random]: Ngẫu nhiên.
- #strong[Weighted Response Time]: Ưu tiên instance trả lời nhanh.

=== Declarative HTTP Client (OpenFeign)
<feign>
Giúp gọi API giữa các service như gọi hàm Java thông thường, ẩn đi việc tạo HTTP Request.

#strong[Cách dùng:]
1. `@EnableFeignClients` ở Main class.
2. Định nghĩa Interface:
```java
@FeignClient(name = "user-service") // Tên service trong Eureka
public interface UserClient {
    @GetMapping("/users/{id}")
    UserDTO getUser(@PathVariable("id") Long id);
}
```
3. Inject và dùng: `userClient.getUser(1)`.

=== Circuit Breaker (Resilience4j)
<resilience4j>
Ngắt mạch để ngăn lỗi dây chuyền (Cascading Failure). Nếu Service B chết, Service A không nên chờ timeout mà trả về lỗi ngay hoặc dữ liệu dự phòng (Fallback).

#strong[Trạng thái của Circuit Breaker:]
1. #strong[CLOSED]: Bình thường, request đi qua.
2. #strong[OPEN]: Lỗi vượt ngưỡng (vd: 50% request lỗi). Ngắt mạch, mọi request bị chặn ngay lập tức.
3. #strong[HALF-OPEN]: Sau một khoảng thời gian, cho phép vài request đi qua test thử. Nếu OK -> CLOSED, nếu lỗi -> OPEN.

#strong[Cấu hình với Feign:]
```yaml
feign:
  circuitbreaker:
    enabled: true
```

```java
@FeignClient(name = "user-service", fallback = UserClientFallback.class)
public interface UserClient { ... }

@Component
public class UserClientFallback implements UserClient {
    @Override
    public UserDTO getUser(Long id) {
        return new UserDTO(id, "Anonymous", "Backup Data");
    }
}
```

=== API Gateway (Spring Cloud Gateway)
<api-gateway>
Cổng vào duy nhất cho toàn bộ hệ thống.
- #strong[Routing]: Điều hướng request tới service tương ứng (`/api/users` -> user-service).
- #strong[Filter]: Authentication, Rate Limiting, Logging, modify Header.
- #strong[Cross-Cutting Concerns]: Xử lý CORS, Security tập trung.

```yaml
spring:
  cloud:
    gateway:
      routes:
        - id: user-route
          uri: lb://user-service
          predicates:
            - Path=/api/users/**
          filters:
            - AddRequestHeader=X-Source, Gateway
```