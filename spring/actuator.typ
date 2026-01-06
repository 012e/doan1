== Spring Boot Actuator & Prometheus
<spring-boot-actuator-prometheus>

=== Giới thiệu về Spring Boot Actuator
<giới-thiệu-actuator>
Spring Boot Actuator là một module cung cấp các tính năng "production-ready" giúp bạn giám sát và quản lý ứng dụng khi nó đã được deploy. Actuator cung cấp các endpoint HTTP (hoặc JMX) để trích xuất thông tin về sức khỏe (health), số liệu (metrics), cấu hình, logs, và nhiều thông tin nội bộ khác của ứng dụng.

Để sử dụng, thêm dependency sau:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

=== Các Endpoint quan trọng
<các-endpoint-quan-trọng>
Mặc định, chỉ có `/health` và `/info` là được bật qua HTTP. Dưới đây là các endpoint hữu ích thường dùng:

- #strong[`/actuator/health`]: Trạng thái sức khỏe của ứng dụng (UP, DOWN, OUT_OF_SERVICE). Nó tự động kiểm tra kết nối DB, RabbitMQ, Redis nếu có các thư viện tương ứng.
- #strong[`/actuator/info`]: Hiển thị thông tin tùy ý về ứng dụng (phiên bản, git commit, build time...).
- #strong[`/actuator/metrics`]: Hiển thị các metrics chi tiết (CPU, RAM, JVM, HTTP request stats).
- #strong[`/actuator/loggers`]: Xem và thay đổi dynamic log level (ví dụ: chuyển từ INFO sang DEBUG mà không cần restart).
- #strong[`/actuator/env`]: Xem các biến môi trường và properties cấu hình (cần cẩn thận vì có thể lộ secret).
- #strong[`/actuator/threaddump`]: Dump thread hiện tại, hữu ích để debug vấn đề deadlock hoặc performance.
- #strong[`/actuator/heapdump`]: Tải về file HPROF dump heap memory để phân tích memory leak.
- #strong[`/actuator/mappings`]: Liệt kê tất cả các request mapping (URL) đã đăng ký.

Để bật tất cả các endpoint (chỉ nên dùng cho môi trường dev hoặc được bảo mật kỹ):

```yaml
management:
  endpoints:
    web:
      exposure:
        include: "*" # Hoặc liệt kê cụ thể: "health,info,metrics,prometheus"
```

=== Bảo mật Actuator Endpoint
<bảo-mật-actuator>
Vì Actuator lộ ra nhiều thông tin nhạy cảm, việc bảo mật là bắt buộc. Thường sử dụng Spring Security để yêu cầu quyền Admin mới truy cập được.

```java
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
    http.requestMatcher(EndpointRequest.toAnyEndpoint())
        .authorizeRequests((requests) -> requests.anyRequest().hasRole("ADMIN"));
    // ... cấu hình khác
    return http.build();
}
```

Ngoài ra, có thể đổi port hoặc context path cho management endpoint để tách biệt với business API:

```yaml
management:
  server:
    port: 8081 # Chạy actuator trên port riêng
    base-path: /manage
```

=== Tích hợp Prometheus và Grafana
<tích-hợp-prometheus>
Prometheus là hệ thống monitoring theo cơ chế *pull* (kéo dữ liệu), và Grafana dùng để *visualize* (hiển thị) dữ liệu đó. Spring Boot sử dụng Micrometer làm facade để xuất metrics.

#strong[1. Cài đặt Dependency]

```xml
<dependency>
    <groupId>io.micrometer</groupId>
    <artifactId>micrometer-registry-prometheus</artifactId>
</dependency>
```

#strong[2. Cấu hình]
Kích hoạt endpoint cho Prometheus scrape dữ liệu:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
  metrics:
    tags:
      application: ${spring.application.name} # Gắn tag tên app vào mọi metric
```

Khi chạy, endpoint `/actuator/prometheus` sẽ trả về dữ liệu định dạng text mà Prometheus server có thể đọc được.

=== Custom Metrics với Micrometer
<custom-metrics>
Đôi khi các metric mặc định (JVM, HTTP) là chưa đủ, bạn cần đo lường các chỉ số nghiệp vụ (ví dụ: số đơn hàng tạo mới, số lần thanh toán lỗi).

#strong[Ví dụ: Đếm số lượng đơn hàng]

```java
import io.micrometer.core.instrument.MeterRegistry;
import io.micrometer.core.instrument.Counter;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
    private final Counter orderCounter;

    public OrderService(MeterRegistry registry) {
        // Tạo một counter metric tên "orders.created"
        this.orderCounter = Counter.builder("orders.created")
            .description("Tổng số đơn hàng đã tạo")
            .register(registry);
    }

    public void createOrder() {
        // Logic tạo đơn hàng...
        
        // Tăng metric
        orderCounter.increment();
    }
}
```

Các loại metric phổ biến khác:
- #strong[Gauge]: Giá trị biến thiên theo thời gian (ví dụ: kích thước hàng đợi hiện tại).
- #strong[Timer]: Đo thời gian thực thi và tần suất (ví dụ: thời gian xử lý hàm `processPayment`).
- #strong[DistributionSummary]: Đo phân phối các giá trị (ví dụ: kích thước payload request).

=== Tùy biến Health Indicator
<custom-health-indicator>
Bạn có thể tự định nghĩa logic kiểm tra sức khỏe hệ thống (ví dụ: kiểm tra file server có phản hồi không).

```java
@Component
public class ExternalServiceHealthIndicator implements HealthIndicator {
    @Override
    public Health health() {
        boolean isUp = checkExternalService(); // Logic kiểm tra
        if (isUp) {
            return Health.up().withDetail("service", "External API is running").build();
        }
        return Health.down().withDetail("error", "Connection timeout").build();
    }
}
```

Kết quả sẽ xuất hiện trong JSON của `/actuator/health`.