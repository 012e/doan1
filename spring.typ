= Xây dựng hệ thống với Spring Boot
<xây-dựng-hệ-thống-với-spring-boot>
== Giới thiệu chương
<giới-thiệu-chương>
Chương này trình bày hướng dẫn chi tiết để xây dựng hệ thống với Spring
Boot. Nội dung bao gồm khái niệm, các starter phổ biến, tích hợp với thư
viện (MyBatis-Plus), cache, message broker (RabbitMQ), tìm kiếm
(Elasticsearch), containerization (Docker), logging & observability
(ELK), quản trị ứng dụng (Spring Boot Admin), cấu hình phân tán
(Apollo), bảo mật (Spring Security, OAuth2, JWT), giám sát (Actuator +
Prometheus), giao dịch phân tán (Seata), validation (JSR-303), discovery
(Eureka), cũng như các mô-đun liên quan đến microservices: Ribbon,
Feign, Hystrix, Turbine, Dashboard.

Tài liệu được viết nhằm mục đích:

- Cung cấp hướng dẫn thực tế, có ví dụ cấu hình.
- Phù hợp cho người phát triển backend, kiến trúc sư hệ thống hoặc sinh
  viên nắm bắt mẫu thiết kế microservices với Spring Boot.
- Có thể dùng làm tài liệu nội bộ hoặc làm tài liệu học tập.

#strong[Phạm vi và giả định]

- Giả định người đọc đã có kiến thức cơ bản về Java và Maven/Gradle.
- Sử dụng Spring Boot 2.x hoặc 3.x (nếu có khác biệt, sẽ ghi chú rõ
  ràng).
- Các ví dụ tập trung vào tính thực tiễn: cấu hình `application.yml`,
  Dockerfile, và các đoạn code minh họa.

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

== Spring Boot MyBatis-Plus
<spring-boot-mybatis-plus>
=== Tổng quan MyBatis-Plus
<tổng-quan-mybatis-plus>
MyBatis-Plus (MBP) là một lớp mở rộng cho MyBatis, cung cấp CRUD tự
động, generator cho entity/mapper, query wrapper tiện dụng, và các tính
năng nâng cao khác.

=== Khi nào dùng MyBatis-Plus
<khi-nào-dùng-mybatis-plus>
- Khi muốn kiểm soát SQL chi tiết nhưng vẫn cần CRUD nhanh.
- Khi ứng dụng cần tối ưu câu SQL và tránh overhead của JPA/Hibernate.

=== Cài đặt và cấu hình cơ bản
<cài-đặt-và-cấu-hình-cơ-bản>
#strong[Dependency:]

```xml
<dependency>
  <groupId>com.baomidou</groupId>
  <artifactId>mybatis-plus-boot-starter</artifactId>
  <version>x.x.x</version>
</dependency>
```

#strong[application.yml cơ bản:]

```yaml
mybatis-plus:
  configuration:
    map-underscore-to-camel-case: true
  global-config:
    db-config:
      id-type: auto
      logic-delete-value: 1
      logic-not-delete-value: 0
```

=== Ví dụ Entity/Mapper/Service
<ví-dụ-entitymapperservice>
- #strong[Entity]: dùng `@TableName`, `@TableId`.
- #strong[Mapper]: extends `BaseMapper<T>`.
- #strong[Service]: extends `ServiceImpl<Mapper, Entity>` hoặc tự
  implement.

=== Các tính năng hữu ích
<các-tính-năng-hữu-ích>
- `QueryWrapper`, `LambdaQueryWrapper` để xây dựng điều kiện linh hoạt.
- Pagination với `IPage` / `Page<T>`.
- #strong[Auto-fill]: `@TableField(fill = FieldFill.INSERT)` cho
  createdAt/updatedAt.
- #strong[Optimistic Locking]: `@Version` và cấu hình plugin.
- #strong[Logic delete]: cấu hình thông qua `@TableLogic`.

=== Tối ưu và best practices
<tối-ưu-và-best-practices>
- Sử dụng XML mapper khi cần tối ưu SQL phức tạp.
- Không dùng auto-generate trong production mà không kiểm soát.
- Dùng batch insert/update khi xử lý hàng loạt.

== Spring Boot Spring Cache
<spring-boot-spring-cache>
=== Giới thiệu
<giới-thiệu>
Spring Cache cung cấp abstraction để cache dữ liệu ở nhiều provider
(Redis, Ehcache, Caffeine…). Spring Boot tự động cấu hình nếu dependency
cache có trong classpath.

=== Lý do dùng cache
<lý-do-dùng-cache>
- Giảm tải DB, cải thiện latency cho API đọc nhiều.

=== Cài đặt với Redis
<cài-đặt-với-redis>
#strong[Dependency:] `spring-boot-starter-data-redis`.

#strong[application.yml:]

```yaml
spring:
  redis:
    host: localhost
    port: 6379
```

=== Kích hoạt cache trong ứng dụng
<kích-hoạt-cache-trong-ứng-dụng>
- `@EnableCaching` trên class cấu hình chính.
- `@Cacheable`, `@CachePut`, `@CacheEvict` trên method/service.

=== Chiến lược cache
<chiến-lược-cache>
- #strong[Cache key design]: dùng prefix + id để tránh collision.
- #strong[Time-to-live (TTL)]: cấu hình theo business.
- #strong[Eviction strategy]: xóa cache khi dữ liệu thay đổi để tránh
  stale.

=== Ví dụ code
<ví-dụ-code>
```java
@Cacheable(value="users", key="#id")
public User findById(Long id) { 
    // Logic tìm user từ DB
}
```

== Spring Boot RabbitMQ
<spring-boot-rabbitmq>
=== Tổng quan
<tổng-quan-1>
RabbitMQ là message broker phổ biến sử dụng AMQP. Spring Boot hỗ trợ
RabbitMQ thông qua `spring-boot-starter-amqp`.

=== Cài đặt
<cài-đặt>
#strong[application.yml:]

```yaml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
```

=== Cấu hình cơ bản
<cấu-hình-cơ-bản>
- `RabbitTemplate` để publish message.
- `@RabbitListener` để tiêu thụ message.
- Tạo queue, exchange, binding bằng `@Bean` trong cấu hình.

=== Reliable messaging
<reliable-messaging>
- #strong[Acknowledgement modes]: auto, manual.
- #strong[Retry, DLX (dead-letter exchange)] cho message xử lý thất bại.
- #strong[Message converter]: `Jackson2JsonMessageConverter` để gửi
  JSON.

== Spring Boot Elasticsearch
<spring-boot-elasticsearch>
=== Mục tiêu
<mục-tiêu-1>
Kết hợp ElasticSearch để cung cấp khả năng tìm kiếm full-text,
aggregation, và analytics.

=== Cấu hình
<cấu-hình>
#strong[application.yml:]

```yaml
spring:
  elasticsearch:
    rest:
      uris: http://localhost:9200
```

=== CRUD và Search
<crud-và-search>
- Spring Data Elasticsearch cung cấp repository và native query.
- Dùng `BulkRequest` để nhập dữ liệu lớn, xử lý batch size hợp lý.

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

== Spring Boot ELK (Elasticsearch, Logstash, Kibana)
<spring-boot-elk-elasticsearch-logstash-kibana>
- #strong[Logging]: Mặc định dùng Logback. Sử dụng
  `logstash-logback-encoder` để format JSON.
- #strong[Logstash]: Nhận logs từ Filebeat hoặc trực tiếp từ app để ship
  vào Elasticsearch.
- #strong[Kibana]: Visualize và tạo dashboard.



== Spring Boot Admin 2.0
<spring-boot-admin-2.0>
=== Cài đặt Server
<cài-đặt-server>
Dùng `spring-boot-admin-server-ui` và `spring-boot-admin-server`.

```yaml
server:
  port: 8081
```

=== Các client
<các-client>
Thêm dependency `spring-boot-admin-starter-client`.

```yaml
management:
  endpoints:
    web:
      exposure:
        include: "*"
spring:
  boot:
    admin:
      client:
        url: http://admin-server:8081
```



== Spring Boot Apollo
<spring-boot-apollo>
Apollo là hệ thống configuration center cho phép cấu hình ứng dụng phân
tán với dynamic refresh. Thêm dependency `apollo-client` và cấu hình
bootstrap properties.



== Spring Boot Security (OAuth2, JWT)
<spring-boot-security-oauth2-jwt>
- #strong[Spring Security]: Bảo vệ endpoint bằng `@PreAuthorize` hoặc
  `hasRole`.
- #strong[OAuth2]: Xử lý Authorization Server (Keycloak) và Resource
  Server.
- #strong[JWT]: Truyền thông tin xác thực giữa client và server.

#strong[Ví dụ cấu hình Resource Server:]

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          jwk-set-uri: <url_to_jwks>
```



== Spring Boot Actuator Prometheus
<spring-boot-actuator-prometheus>
Thêm dependency `micrometer-registry-prometheus` và bật endpoint:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
```



== Spring Boot Seata
<spring-boot-seata>
Giải pháp giao dịch phân tán (distributed transaction). Đánh dấu service
method với `@GlobalTransactional` để quản lý transaction xuyên suốt các
microservices (AT mode).



== Spring Boot JSR-303
<spring-boot-jsr-303>
Sử dụng `spring-boot-starter-validation` để validate dữ liệu input:

```java
public ResponseEntity create(@Valid @RequestBody DTO dto, BindingResult result) { ... }
```



== Microservices Modules
<microservices-modules>
=== Eureka
<eureka>
Service discovery giúp các instance tự đăng ký và tìm thấy nhau.

- #strong[Server]: `@EnableEurekaServer`.
- #strong[Client]: `@EnableEurekaClient`.

=== Ribbon / Spring Cloud LoadBalancer
<ribbon-spring-cloud-loadbalancer>
Client-side load balancer để phân phối request giữa các instance.

=== Feign
<feign>
Declarative REST client. Định nghĩa interface với `@FeignClient` để gọi
service khác một cách dễ dàng.

=== Hystrix / Resilience4j
<hystrix-resilience4j>
Cung cấp Circuit Breaker để ngăn chặn lỗi dây chuyền (cascading
failures).



== Phần kết luận chương
<phần-kết-luận-chương>
Chúng ta đã đi qua chuỗi công nghệ cần thiết khi xây dựng hệ thống với
Spring Boot, từ persistence, messaging đến microservices patterns.