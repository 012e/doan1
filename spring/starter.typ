== Spring Boot starter
<spring-boot-starter>
=== Tổng quan
<tổng-quan>
Spring Boot starter là các dependency tiền cấu hình giúp khởi tạo nhanh
các thành phần trong Spring Boot. Mỗi starter gom nhóm các thư viện liên
quan vào một artifact dễ dùng. Ví dụ: `spring-boot-starter-web`,
`spring-boot-starter-data-jpa`, `spring-boot-starter-security`.

=== Mục tiêu
<mục-tiêu>
- Hiểu công dụng của starter.
- Học cách tạo project với starter phù hợp.
- Hiểu cách tùy biến dependency và exclude các transitive dependency
  không cần thiết.

=== Các starter phổ biến
<các-starter-phổ-biến>
- `spring-boot-starter-web`: hỗ trợ xây REST API (Spring MVC,
  Tomcat/embedded container).
- `spring-boot-starter-data-jpa`: JPA + Hibernate.
- `spring-boot-starter-validation`: JSR-303 validation.
- `spring-boot-starter-actuator`: health, metrics, traces.
- `spring-boot-starter-test`: JUnit, Mockito, Spring Test.

=== Sử dụng Maven
<sử-dụng-maven>
Thêm dependency vào file `pom.xml`:

```xml
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

=== Tùy chỉnh starter
<tùy-chỉnh-starter>
- Exclude transitive dependencies khi cần (ví dụ: exclude Tomcat để dùng
  Undertow).
- Thêm starter riêng cho các nền tảng: `spring-boot-starter-data-redis`,
  `spring-boot-starter-amqp`.

=== Cách viết starter cho thư viện nội bộ
<cách-viết-starter-cho-thư-viện-nội-bộ>
Nếu cần chuẩn hóa dependency cho tổ chức, có thể tạo internal starter:
một artifact pom `packaging="pom"` chứa `dependencyManagement` và
`dependencies`.

=== Các lưu ý thực hành
<các-lưu-ý-thực-hành>
- Kết hợp starters với Spring Boot BOM để quản lý version.
- Tránh import quá nhiều starter không dùng, gây tăng kích thước
  jar/war.
