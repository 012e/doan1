== Spring Boot & Apollo (Config Center)
<spring-boot-apollo>

=== Giới thiệu Apollo
<giới-thiệu-apollo>
Apollo (được phát triển bởi Ctrip) là một hệ thống quản lý cấu hình phân tán (Distributed Configuration Center).
Trong kiến trúc Microservices, việc sửa file `application.yml` rồi restart từng service là rất tốn kém. Apollo cho phép thay đổi cấu hình #strong[Real-time] mà không cần restart service.

#strong[Tính năng nổi bật:]
- Quản lý tập trung tất cả config của các môi trường (DEV, TEST, PROD).
- Real-time push: Đẩy config mới xuống client ngay lập tức (1-2s).
- Version control: Rollback config cũ dễ dàng.
- Phân quyền user chi tiết.

=== Kiến trúc Apollo
<kiến-trúc-apollo>
Gồm 4 module chính:
1. #strong[Config Service]: Cung cấp config cho Client.
2. #strong[Admin Service]: API quản lý config (cho Portal).
3. #strong[Portal]: Giao diện Web UI để người dùng sửa config.
4. #strong[Client]: Thư viện nhúng trong Spring Boot app.

=== Tích hợp Apollo vào Spring Boot
<apollo-integration>

#strong[1. Dependency]
```xml
<dependency>
    <groupId>com.ctrip.framework.apollo</groupId>
    <artifactId>apollo-client</artifactId>
    <version>2.1.0</version>
</dependency>
```

#strong[2. Cấu hình kết nối]
Cần file `src/main/resources/application.yml` (hoặc `bootstrap.yml`) để định danh App ID.

```yaml
app:
  id: my-payment-service # ID duy nhất của ứng dụng trên Apollo Portal
apollo:
  bootstrap:
    enabled: true # Tự động load config khi khởi động
    namespaces: application,common.db-config # Các namespace cần load
  meta: http://localhost:8080 # Địa chỉ Apollo Config Service
```

=== Sử dụng Config trong Code
<apollo-usage>

#strong[Cách 1: `@Value` (Auto Refresh)]
Mặc định `@Value` #strong[không] tự cập nhật khi config đổi. Với Apollo, nó hỗ trợ tự động.

```java
@Component
public class PaymentConfig {
    
    @Value("${payment.timeout:5000}")
    private int timeout;
    
    // Khi đổi trên Portal -> biến timeout tự đổi giá trị mới
}
```

#strong[Cách 2: `@ConfigurationProperties`]
Apollo hỗ trợ refresh bean này (cần thêm `@RefreshScope` nếu dùng Spring Cloud Config, nhưng Apollo client xử lý native tốt hơn).

```java
@Configuration
@ConfigurationProperties(prefix = "payment")
@Data
public class PaymentProperties {
    private int timeout;
    private String gatewayUrl;
}
```

#strong[Cách 3: Apollo Config API (Programmatic)]
Dùng khi cần xử lý logic mỗi khi config thay đổi (Callback).

```java
@ApolloConfigChangeListener(interestedKeys = {"payment.timeout"})
private void onChange(ConfigChangeEvent changeEvent) {
    ConfigChange change = changeEvent.getChange("payment.timeout");
    System.out.println("Old value: " + change.getOldValue());
    System.out.println("New value: " + change.getNewValue());
    
    // Logic: Reset lại kết nối DB, xóa cache...
}
```