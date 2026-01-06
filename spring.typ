Chương 9: Xây dựng hệ thống với Spring Boot

Giới thiệu chương

Chương này trình bày hướng dẫn chi tiết để xây dựng hệ thống với Spring Boot. Nội dung bao gồm khái niệm, các starter phổ biến, tích hợp với thư viện (MyBatis-Plus), cache, message broker (RabbitMQ), tìm kiếm (Elasticsearch), containerization (Docker), logging & observability (ELK), quản trị ứng dụng (Spring Boot Admin), cấu hình phân tán (Apollo), bảo mật (Spring Security, OAuth2, JWT), giám sát (Actuator + Prometheus), giao dịch phân tán (Seata), validation (JSR-303), discovery (Eureka), cũng như các mô-đun liên quan đến microservices: Ribbon, Feign, Hystrix, Turbine, Dashboard.

Tài liệu được viết nhằm mục đích:
- Cung cấp hướng dẫn thực tế, có ví dụ cấu hình.
- Phù hợp cho người phát triển backend, kiến trúc sư hệ thống hoặc sinh viên nắm bắt mẫu thiết kế microservices với Spring Boot.
- Có thể dùng làm tài liệu nội bộ hoặc làm tài liệu học tập.

Phạm vi và giả định
- Giả định người đọc đã có kiến thức cơ bản về Java và Maven/Gradle.
- Sử dụng Spring Boot 2.x hoặc 3.x (nếu có khác biệt, sẽ ghi chú rõ ràng).
- Các ví dụ tập trung vào tính thực tiễn: cấu hình application.yml, Dockerfile, và các đoạn code minh họa.

---

9.1. Spring Boot starter

Tổng quan
Spring Boot starter là các dependency tiền cấu hình giúp khởi tạo nhanh các thành phần trong Spring Boot. Mỗi starter gom nhóm các thư viện liên quan vào một artifact dễ dùng. Ví dụ: spring-boot-starter-web, spring-boot-starter-data-jpa, spring-boot-starter-security.

Mục tiêu
- Hiểu công dụng của starter.
- Học cách tạo project với starter phù hợp.
- Hiểu cách tùy biến dependency và exclude các transitive dependency không cần thiết.

Các starter phổ biến
- spring-boot-starter-web: hỗ trợ xây REST API (Spring MVC, Tomcat/embedded container).
- spring-boot-starter-data-jpa: JPA + Hibernate.
- spring-boot-starter-validation: JSR-303 validation.
- spring-boot-starter-actuator: health, metrics, traces.
- spring-boot-starter-test: JUnit, Mockito, Spring Test.

Sử dụng Maven
<project dependencies>
- Thêm dependency: spring-boot-starter-web
- Example:
  <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
  </dependency>

Tùy chỉnh starter
- Exclude transitive dependencies khi cần (ví dụ: exclude Tomcat để dùng Undertow).
- Thêm starter riêng cho các nền tảng: spring-boot-starter-data-redis, spring-boot-starter-amqp.

Cách viết starter cho thư viện nội bộ
- Nếu cần chuẩn hóa dependency cho tổ chức, có thể tạo internal starter: một artifact pom packaging= "pom" chứa dependencyManagement và dependencies.

Các lưu ý thực hành
- Kết hợp starters với Spring Boot BOM để quản lý version.
- Tránh import quá nhiều starter không dùng, gây tăng kích thước jar/war.

Tài liệu thêm
- Link tham khảo: chính thức Spring Boot docs (tham khảo code mẫu trong repo).

---

9.2. Spring Boot MyBatis-Plus

Tổng quan MyBatis-Plus
MyBatis-Plus (MBP) là một lớp mở rộng cho MyBatis, cung cấp CRUD tự động, generator cho entity/mapper, query wrapper tiện dụng, và các tính năng nâng cao khác.

Khi nào dùng MyBatis-Plus
- Khi muốn kiểm soát SQL chi tiết nhưng vẫn cần CRUD nhanh.
- Khi ứng dụng cần tối ưu câu SQL và tránh overhead của JPA/Hibernate.

Cài đặt và cấu hình cơ bản
- dependency:
  <dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>x.x.x</version>
  </dependency>

- application.yml cơ bản:
  mybatis-plus:
    configuration:
      map-underscore-to-camel-case: true
    global-config:
      db-config:
        id-type: auto
        logic-delete-value: 1
        logic-not-delete-value: 0

Ví dụ Entity/Mapper/Service
- Entity: dùng @TableName, @TableId.
- Mapper: extends BaseMapper<T>.
- Service: extends ServiceImpl<Mapper, Entity> hoặc tự implement.

Các tính năng hữu ích
- QueryWrapper, LambdaQueryWrapper để xây dựng điều kiện linh hoạt.
- Pagination với IPage / Page<T>.
- Auto-fill: @TableField(fill = FieldFill.INSERT) cho createdAt/updatedAt.
- Optimistic Locking: @Version và cấu hình plugin.
- Logic delete cấu hình thông qua @TableLogic.

Tối ưu và best practices
- Sử dụng XML mapper khi cần tối ưu SQL phức tạp.
- Không dùng auto-generate trong production mà không kiểm soát.
- Dùng batch insert/update khi xử lý hàng loạt.

Ví dụ triển khai Endpoint CRUD
- Controller -> Service -> Mapper -> DB.
- Sử dụng DTO cho input/output, chuyển đổi bằng ModelMapper hoặc MapStruct.

Trao đổi log và profiling
- Bật logging SQL chừng cần trong environment staging, dùng datasource-proxy hoặc p6spy cho production.

---

9.3. Spring Boot Spring Cache

Giới thiệu
Spring Cache cung cấp abstraction để cache dữ liệu ở nhiều provider (Redis, Ehcache, Caffeine...). Spring Boot tự động cấu hình nếu dependency cache có trong classpath.

Lý do dùng cache
- Giảm tải DB, cải thiện latency cho API đọc nhiều.

Cài đặt với Redis
- Thêm dependency: spring-boot-starter-data-redis.
- application.yml:
  spring:
    redis:
      host: localhost
      port: 6379

Kích hoạt cache trong ứng dụng
- @EnableCaching trên class cấu hình chính.
- @Cacheable, @CachePut, @CacheEvict trên method/service.

Chiến lược cache
- Cache key design: dùng prefix + id để tránh collision.
- Time-to-live (TTL) cấu hình theo business.
- Eviction strategy: xóa cache khi dữ liệu thay đổi để tránh stale.

Provider khác: Caffeine/Ehcache
- Caffeine: in-memory, rất nhanh cho JVM-local.
- Ehcache: backup to disk, native integration.

Cân nhắc
- Consistency: cache-aside vs write-through.
- Cache stampede: dùng locking hoặc request coalescing.

Ví dụ code
- Service:
  @Cacheable(value="users", key="#id")
  public User findById(Long id) { ... }

Testing
- Sử dụng embedded Redis hoặc testcontainers để test integration.

---

9.4. Spring Boot RabbitMQ

Tổng quan
RabbitMQ là message broker phổ biến sử dụng AMQP. Spring Boot hỗ trợ RabbitMQ thông qua spring-boot-starter-amqp và Spring AMQP.

Cài đặt
- dependency: spring-boot-starter-amqp.
- application.yml:
  spring:
    rabbitmq:
      host: localhost
      port: 5672
      username: guest
      password: guest

Cấu hình cơ bản
- RabbitTemplate để publish message.
- @RabbitListener để tiêu thụ message.
- Tạo queue, exchange, binding bằng @Bean trong cấu hình hoặc declare thông qua management.

Patterns thường dùng
- Work queues (task queues)
- Publish/Subscribe (fanout exchange)
- Routing (direct exchange)
- Topic exchange cho routing theo pattern

Reliable messaging
- Acknowledgement modes: auto, manual.
- Retry, DLX (dead-letter exchange) cho message xử lý thất bại.
- Message converter: Jackson2JsonMessageConverter để gửi JSON.

Transactional
- Có thể dùng publisher confirms và transactions nhưng cần cân nhắc performance.

Monitoring
- RabbitMQ Management Plugin để quan sát queues, rates, consumers.

Ví dụ
- Producer: rabbitTemplate.convertAndSend(exchange, routingKey, payload);
- Consumer: @RabbitListener(queues = "taskQueue") public void handle(Task t) { ... }

---

9.5. Spring Boot Elasticsearch

Mục tiêu
Kết hợp ElasticSearch để cung cấp khả năng tìm kiếm full-text, aggregation, và analytics cho dịch vụ.

Thư viện
- spring-boot-starter-data-elasticsearch (phiên bản phù hợp với ES server).
- Hoặc sử dụng Elasticsearch RestHighLevelClient trực tiếp cho các version cụ thể.

Cấu hình
- application.yml:
  spring:
    elasticsearch:
      rest:
        uris: http://localhost:9200

Mapping và Index
- Định nghĩa mapping cho entity (analysis, tokenizer, fields).
- Sử dụng Index API để tạo index trước khi insert data.

CRUD và Search
- Spring Data Elasticsearch cung cấp repository, query by example và native query.
- Ví dụ search bằng match/queryString để tìm full-text.

Bulk import
- Dùng BulkRequest để nhập dữ liệu lớn, xử lý batch size hợp lý.

Reindex và version compatibility
- Chú ý độ tương thích giữa client và server; thường cần đồng bộ major versions.

Tối ưu hiệu năng
- Sử dụng refresh/flush hợp lý, tránh làm refresh quá thường xuyên trong batch inserts.
- Throttling, shards/replicas cấu hình cho production.

---

9.6. Spring Boot Docker

Mục tiêu
Đóng gói ứng dụng Spring Boot thành container để triển khai nhất quán.

Dockerfile cơ bản
- Multi-stage build cho kích thước nhỏ hơn:
  FROM eclipse-temurin:17-jdk as build
  WORKDIR /app
  COPY pom.xml mvnw .
  COPY src ./src
  RUN ./mvnw -DskipTests package

  FROM eclipse-temurin:17-jre
  COPY --from=build /app/target/app.jar /app/app.jar
  ENTRYPOINT ["java","-jar","/app/app.jar"]

Kỹ thuật tối ưu
- Sử dụng JLink hoặc distroless image để giảm kích thước.
- Sử dụng layer cache: copy pom.xml + mvnw trước, sau đó copy src.

Docker Compose
- Dùng docker-compose để khởi tạo stack: app + db + redis + rabbitmq.
- Compose file ví dụ: services: app: build: . ports: - "8080:8080" depends_on: - db

CI/CD
- Build image trong pipeline (GitHub Actions, GitLab CI), push lên registry (Docker Hub, GCR, ECR).

Security
- Không lưu secrets trong Dockerfile; dùng secret manager hoặc environment variable qua orchestrator.

---

9.7. Spring Boot ELK (Elasticsearch, Logstash, Kibana)

Mục tiêu
- Thu thập logs ứng dụng, phân tích và hiển thị dashboard bằng Kibana.

Logging
- Spring Boot dùng Logback theo mặc định.
- Gửi logs tới stdout để Docker/Container orchestration thu thập.

Cấu hình Logback để JSON
- Sử dụng encoder (logstash-logback-encoder) để format JSON, chứa trường traceId, spanId.

Logstash pipeline
- Logstash lấy logs từ file/stdout hoặc sử dụng beats (Filebeat) để ship logs tới Logstash -> Elasticsearch.

Kibana
- Tạo index pattern, visualize và dashboard cho logs, metrics.

Tracing integration
- Kết hợp với Sleuth/Zipkin hoặc OpenTelemetry để gắn traceId vào logs.

Monitoring best practices
- Định cấu hình retention policy cho indices.
- Thiết lập ILM (Index Lifecycle Management).

---

9.8. Spring Boot Admin 2.0

Mục tiêu
- Quản trị và giám sát các instance Spring Boot (actuator endpoints, metrics) qua giao diện.

Cài đặt Server
- Dùng spring-boot-admin-server-ui và spring-boot-admin-server.
- application.yml cho admin server: server.port: 8081

Các client
- Thêm dependency spring-boot-admin-starter-client vào các ứng dụng.
- cấu hình: management.endpoints.web.exposure.include: "*"; spring.boot.admin.client.url: http://admin-server:8081

Authentication
- Bảo vệ admin server bằng cơ chế auth (basic auth, OAuth2).

Tính năng
- Hiển thị health, metrics, loggers, thread dump, traces.
- Có thể dùng để trigger garbage collection, thu thập heap dump.

---

9.9. Spring Boot Apollo

Giới thiệu
- Apollo (by Ctrip) là hệ thống configuration center, cho phép cấu hình ứng dụng phân tán với dynamic refresh.

Tích hợp với Spring Boot
- Dùng apollo-client để lấy config từ Apollo server.
- Thêm dependency: apollo-client, cấu hình bootstrap properties để kết nối namespace.

Cấu hình và namespace
- Sử dụng application.yml/ bootstrap.yml cho connection info, env, cluster, namespace.
- Hỗ trợ override theo environment.

Dynamic refresh
- Khi config thay đổi trên Apollo, client có thể lắng nghe và cập nhật cấu hình runtime mà không cần restart.

Quyền và audit
- Phân quyền trên giao diện Apollo để ai có thể publish config.

---

9.10. Spring Boot Security, OAuth2 + API, JWT + API, OAuth2 + JWT

Mục tiêu
- Bảo vệ API, xác thực và ủy quyền, tích hợp OAuth2 và JWT.

Spring Security cơ bản
- Thêm dependency spring-boot-starter-security.
- Cấu hình WebSecurityConfigurerAdapter (Spring Boot 2) hoặc SecurityFilterChain (Spring Boot 3).

Authentication & Authorization
- In-memory, JDBC, LDAP hoặc custom UserDetailsService.
- Roles & Authorities để phân quyền endpoint bằng @PreAuthorize hoặc hasRole.

OAuth2
- Spring Security OAuth2 (client & resource server) để xử lý OAuth2 flows.
- Cấu hình Authorization Server (sử dụng Keycloak hoặc Spring Authorization Server).

JWT
- JWT (JSON Web Token) dùng để truyền thông tin xác thực giữa client và server.
- Resource server có thể verify JWT bằng public key (RSA) hoặc shared secret.

Kết hợp OAuth2 + JWT
- Authorization Server cấp JWT (access token) cho client sau khi xác thực.
- Resource Server cấu hình để xác minh token.

API Security best practices
- Always use HTTPS.
- Token expiration & rotation.
- Revoke/blacklist tokens nếu cần.
- Use scopes for fine-grained access control.

Ví dụ cấu hình Resource Server
- application.yml: spring.security.oauth2.resourceserver.jwt.jwk-set-uri: <url>
- Security config: http.oauth2ResourceServer().jwt();

---

9.11. Spring Boot Actuator Prometheus

Mục tiêu
- Cung cấp metrics cho Prometheus từ Spring Boot Actuator.

Cài đặt
- Thêm dependency micrometer-registry-prometheus.
- Bật actuator endpoints: management.endpoints.web.exposure.include: health,info,prometheus

Prometheus
- Prometheus sẽ scrape endpoint /actuator/prometheus.
- Cấu hình job trong prometheus.yml.

Grafana
- Visualize metrics bằng Grafana, import dashboard cho JVM, Spring Boot.

Custom metrics
- Dùng MeterRegistry để định nghĩa metrics custom: counter, gauge, timer.

Health & alerting
- Sử dụng health checks và tạo alerts trên Prometheus Alertmanager.

---

9.12. Spring Boot Seata

Giới thiệu
- Seata là giải pháp giao dịch phân tán (distributed transaction) cho microservices, hỗ trợ mô hình TCC/AT.

Khi nào dùng
- Khi cần giao dịch xuyên service (chẳng hạn: đặt hàng tạo record, trừ kho, tạo hóa đơn) để đảm bảo consistency.

Tích hợp
- Dùng seata-spring-boot-starter.
- Cấu hình transaction.service.group và registry.conf (nacos/etcd/kubernetes).

Modes
- AT mode: automatic bằng undo log (phổ biến nhất).
- TCC: explicit try/confirm/cancel.

Các lưu ý
- Seata làm việc tốt với DB hỗ trợ undo log, cần cấu hình datasource proxy (TM/TCC gọi RM).
- Performance overhead: cân nhắc khi dùng ở các transaction nhỏ, tần suất cao.

Ví dụ
- Đánh dấu service method với @GlobalTransactional để mở transaction phân tán.

---

9.13. Spring Boot JSR-303

Giới thiệu
- JSR-303 (Bean Validation) dùng để validate dữ liệu input bằng annotation: @NotNull, @Size, @Email, @Pattern, cùng với Hibernate Validator implementation.

Sử dụng trong Spring Boot
- Thêm dependency: spring-boot-starter-validation.
- Trong controller: public ResponseEntity create(@Valid @RequestBody DTO dto, BindingResult result) { ... }

Tạo custom validator
- Implement ConstraintValidator và tạo annotation tùy chỉnh.

Validation groups
- Dùng groups để phân biệt validate trong create vs update.

Thông báo lỗi quốc tế hóa
- messages.properties và messageSource bean để cấu hình.

---

9.14. Spring Boot với Eureka

Tổng quan
- Eureka là service discovery của Netflix OSS, cho phép service đăng ký (register) và discover nhau.

Cài đặt
- Eureka Server dependency: spring-cloud-starter-netflix-eureka-server.
- Eureka Client: spring-cloud-starter-netflix-eureka-client.

Cấu hình
- Server: @EnableEurekaServer, application.yml: eureka.client.register-with-eureka: false
- Client: spring.application.name, eureka.client.service-url.defaultZone

Load balancing
- Với Eureka, Ribbon (client-side load balancer) có thể lấy danh sách instance.

Resilience
- Kết hợp với Ribbon/Feign/Hystrix để tăng resilience.

---

9.15. Spring Boot với REST + Ribbon

Tổng quan
- Ribbon là client-side load balancer, dùng để phân phối request giữa các instance lấy từ Discovery (Eureka) hoặc static list.

Cấu hình
- Thêm dependency spring-cloud-starter-netflix-ribbon (đã được thay thế ở Spring Cloud mới, nên cân nhắc dùng Spring Cloud LoadBalancer).
- Sử dụng RestTemplate + @LoadBalanced để gọi service khác: restTemplate.getForObject("http://SERVICE-NAME/path", ...)

Lưu ý
- Ribbon không còn active trong Spring Cloud Hoxton+; chuyển sang Spring Cloud LoadBalancer.

---

9.16. Spring Boot với Feign

Tổng quan
- Feign (OpenFeign) là declarative REST client, cho phép định nghĩa interface để gọi remote service.

Cài đặt
- spring-cloud-starter-openfeign.
- @EnableFeignClients và tạo interface annotated với @FeignClient(name = "service-name").

Tích hợp với Eureka/Ribbon
- Feign có thể dùng discovery để resolve service-name; có thể kết hợp với Ribbon để load-balance.

Error handling
- Dùng Feign ErrorDecoder để map lỗi sang exception application.

Retry và timeout
- Cấu hình timeout và retry policies (client config hoặc Resilience4j).

---

9.17. Spring Boot với Hystrix, Turbine and Dashboard

Tổng quan
- Hystrix cung cấp circuit breaker để ngăn cascaded failures trong microservices.
- Turbine aggregate Hystrix stream từ nhiều instance để hiển thị trên Hystrix Dashboard.

Cài đặt
- spring-cloud-starter-netflix-hystrix, hystrix-dashboard, turbine.
- @EnableHystrix trên ứng dụng và @HystrixCommand trên method cần bảo vệ.

Patterns
- Circuit Breaker: fallback method khi downstream failing.
- Bulkhead, Timeout để giới hạn resource.

Turbine
- Turbine cấu hình để aggregate streams: turbine.appConfig, turbine.clusterNameExpression.
- Dashboard hiển thị metrics theo stream.

Lưu ý hiện đại
- Hystrix đã được put into maintenance mode; khuyến nghị dùng Resilience4j cho circuit breaker hiện đại.

---

Phần kết luận chương

Trong chương này, chúng ta đã đi qua một chuỗi các công nghệ và mô-đun liên quan khi xây dựng hệ thống với Spring Boot. Mỗi phần cung cấp một điểm khởi đầu thực tế: dependency chính, cấu hình thường gặp, ví dụ code, và những lưu ý vận hành.

Gợi ý thực hành
- Tạo một dự án mẫu bao gồm: Spring Boot app + MyBatis-Plus + Redis Cache + RabbitMQ + Elasticsearch. Triển khai bằng Docker Compose, giám sát bằng Prometheus + Grafana.
- Thử cài đặt Flow: đặt hàng -> publish event -> inventory service consume -> update ES index -> expose search API.

Tiếp theo
- Phần tiếp theo (nếu cần) có thể trình bày bài tập thực hành: một hệ thống microservice mẫu, mã nguồn ví dụ, và pipeline CI/CD với Docker image build & deployment.

Tài liệu tham khảo
- Spring Boot Documentation
- Spring Cloud Documentation
- MyBatis-Plus docs
- RabbitMQ docs
- Elasticsearch docs
- Seata docs
- Apollo docs
- Micrometer & Prometheus docs


---

Ghi chú tác giả

Tài liệu này được biên soạn tham khảo cấu trúc từ repo: https://github.com/gf-huanchupk/SpringBootLearning và các tài liệu chính thức của từng project. Nội dung đã được viết bằng tiếng Việt, mục tiêu phục vụ làm tài liệu học và tham khảo nhanh.

---

Phụ lục: Bài tập thực hành và hướng dẫn chi tiết

Phần mở đầu
Phụ lục này cung cấp một loạt bài tập thực hành từ cơ bản đến nâng cao, kèm theo gợi ý, bước thực hiện và các lưu ý vận hành. Mục tiêu là giúp người học biến lý thuyết ở chương thành các hệ thống chạy được, có thể triển khai và giám sát.

Hướng dẫn chung khi thực hiện bài tập
- Mỗi bài tập nên được triển khai trong một Git repository riêng hoặc trong multi-module repo.
- Sử dụng Docker Compose để khởi tạo các phụ trợ (DB, Redis, RabbitMQ, Elasticsearch...).
- Viết test (unit + integration) cho các phần quan trọng như service logic, repository.
- Dùng CI (GitHub Actions / GitLab CI) để auto-build và chạy test.

Bài tập 1: Tạo project Spring Boot cơ bản
Mục tiêu: Tạo ứng dụng REST đơn giản trả về danh sách "products".
Các bước:
1. Khởi tạo project dùng Spring Initializr (Maven), thêm starter: web, validation, actuator.
2. Tạo entity Product (id, name, price, createdAt).
3. Tạo controller với endpoint GET /products và POST /products.
4. Viết validation cho input (JSR-303).
5. Chạy ứng dụng và kiểm thử bằng curl hoặc Postman.
Gợi ý: Dùng in-memory H2 để dễ test.

Bài tập 2: Thêm MyBatis-Plus cho persistence
Mục tiêu: Sử dụng MyBatis-Plus để thay thế repository mặc định.
Các bước:
1. Thêm dependency mybatis-plus-boot-starter.
2. Tạo datasource đến H2 hoặc MySQL.
3. Tạo mapper extends BaseMapper<Product>.
4. Thêm service dùng ServiceImpl để sử dụng CRUD tự động.
5. Viết unit test cho mapper (integration test với DB trong Docker hoặc H2).
Gợi ý: Bật SQL logging khi debug.

Bài tập 3: Cache hóa endpoint GET /products
Mục tiêu: Sử dụng Spring Cache với Caffeine hoặc Redis.
Các bước:
1. Thêm dependency tương ứng (Caffeine/Redis).
2. Cấu hình @EnableCaching.
3. Đánh dấu method service với @Cacheable(value="products", key="#id") hoặc cache list.
4. Kiểm tra: call nhiều lần, thấy giảm truy vấn DB.
Gợi ý: Đo latency trước/sau để thấy lợi ích.

Bài tập 4: Event-driven với RabbitMQ
Mục tiêu: Khi product được tạo, publish event và có 1 consumer ghi log/tiến hành xử lý khác.
Các bước:
1. Thêm spring-boot-starter-amqp.
2. Cấu hình RabbitMQ trong docker-compose.
3. Tạo producer dùng RabbitTemplate để gửi ProductCreatedEvent.
4. Tạo consumer với @RabbitListener để nhận và xử lý event.
5. Thử gửi event và quan sát consumer hoạt động.
Gợi ý: Dùng JSON message converter.

Bài tập 5: Tìm kiếm product với Elasticsearch
Mục tiêu: Khi product tạo hoặc cập nhật, index vào Elasticsearch; tạo endpoint search.
Các bước:
1. Thêm spring-data-elasticsearch hoặc client thích hợp.
2. Tạo index mapping cho product (name: text with analyzer).
3. Khi product được lưu, push data vào ES (index/update).
4. Tạo endpoint GET /products/search?q=xxx trả về kết quả tìm kiếm.
5. Viết integration test với Testcontainers Elasticsearch.
Gợi ý: Sử dụng bulk API cho batch indexing.

Bài tập 6: Đóng gói bằng Docker và chạy bằng Docker Compose
Mục tiêu: Tạo Dockerfile, Docker Compose để chạy app cùng Redis, MySQL, RabbitMQ.
Các bước:
1. Viết Dockerfile multi-stage.
2. Tạo docker-compose.yml khai báo services: app, mysql, redis, rabbitmq, elasticsearch.
3. Chạy docker-compose up và kiểm tra app hoạt động.
4. Thực hiện migrate DB (Flyway/DDL schema) trong startup.
Gợi ý: Map volumes cho DB để persist data khi khởi lại.

Bài tập 7: Tích hợp Actuator và metrics cho Prometheus
Mục tiêu: Expose metrics và scrape bởi Prometheus.
Các bước:
1. Thêm micrometer-registry-prometheus.
2. Bật endpoint /actuator/prometheus.
3. Cấu hình Prometheus trong docker-compose và scrape app.
4. Mở Grafana và tạo dashboard từ metrics.
Gợi ý: Thêm custom metric cho số lượng product tạo mỗi phút.

Bài tập 8: Logging JSON và ship logs tới ELK
Mục tiêu: Cấu hình Logback để xuất JSON, sử dụng Filebeat/Logstash đưa logs vào Elasticsearch.
Các bước:
1. Thêm logstash-logback-encoder và cấu hình logback-spring.xml để xuất JSON.
2. Cấu hình Filebeat trong Docker Compose để thu logs từ container.
3. Cấu hình Logstash pipeline nhận JSON và gửi vào ES.
4. Dùng Kibana để tạo dashboard logs.
Gợi ý: Thêm traceId từ Sleuth để dễ trace request.

Bài tập 9: Bảo mật API với JWT
Mục tiêu: Thực hiện authentication bằng JWT cho API.
Các bước:
1. Thêm spring-boot-starter-security.
2. Tạo endpoint /auth/login nhận username/password trả về JWT.
3. Middleware filter đọc Authorization: Bearer <token> và validate.
4. Bảo vệ các endpoint product bằng @PreAuthorize.
Gợi ý: Lưu token expire ngắn và cung cấp refresh token.

Bài tập 10: Triển khai OAuth2 Resource Server
Mục tiêu: Cấu hình app làm resource server và validate token từ Authorization Server (Keycloak).
Các bước:
1. Cài đặt Keycloak trong docker-compose hoặc dùng dịch vụ cloud.
2. Cấu hình client trong Keycloak và cấp scope phù hợp.
3. Configure application.yml với jwk-set-uri hoặc issuer-uri.
4. Kiểm tra truy cập bằng token từ Keycloak.
Gợi ý: Thử các flow: client credentials, authorization code.

Bài tập 11: Giao dịch phân tán với Seata (AT mode)
Mục tiêu: Thiết lập transaction phân tán giữa order service và inventory service.
Các bước:
1. Cài đặt Seata server trong docker-compose.
2. Thêm seata-spring-boot-starter vào hai service.
3. Đánh dấu @GlobalTransactional ở method tạo order.
4. Kiểm tra rollback khi inventory service bị lỗi.
Gợi ý: Dùng MySQL cho RM và cấu hình undo log.

Bài tập 12: Tạo gateway + discovery (Eureka)
Mục tiêu: Triển khai Eureka server + set of services và Spring Cloud Gateway.
Các bước:
1. Tạo Eureka server và client apps, config eureka.
2. Tạo Spring Cloud Gateway chuyển hướng tới service khác bằng serviceId.
3. Thử shutdown một instance để quan sát load balancing.
Gợi ý: Kết hợp với Hystrix/Resilience4j cho fallback.

Bài tập 13: Dùng Feign và circuit breaker
Mục tiêu: Gọi một microservice bằng Feign kèm circuit breaker hành xử khi downstream lỗi.
Các bước:
1. thêm openfeign dependency và @FeignClient.
2. Thêm Resilience4j hoặc Hystrix để wrap call.
3. Cấu hình fallback method trả về dữ liệu mặc định.
4. Viết test mô phỏng lỗi downstream.
Gợi ý: Cấu hình timeout để test circuit open.

Bài tập 14: Cấu hình dynamic qua Apollo
Mục tiêu: Dùng Apollo để thay đổi cấu hình runtime (ví dụ TTL cache) mà không restart app.
Các bước:
1. Deploy Apollo server (cần cấu hình môi trường hỗ trợ).
2. Thêm client và trỏ đến namespace.
3. Tạo config key cache.ttl và sử dụng trong ứng dụng.
4. Sửa giá trị trên Apollo và quan sát app refresh nếu bật listener.

Bài tập 15: Viết integration tests với Testcontainers
Mục tiêu: Thay thế Docker Compose bằng Testcontainers cho CI.
Các bước:
1. Thêm dependency testcontainers (mysql, rabbitmq, elasticsearch).
2. Viết test khởi container trong lifecycle của test.
3. Chạy test trong pipeline để đảm bảo tính nhất quán.
Gợi ý: Không khởi quá nhiều container trên cùng 1 runner để tránh chậm.

Bài tập 16: Audit và tracing request (OpenTelemetry)
Mục tiêu: Thêm tracing end-to-end và ghi audit log cho actions quan trọng.
Các bước:
1. Tích hợp opentelemetry-javaagent hoặc SDK.
2. Gắn traceId vào logs.
3. Thiết lập collector hoặc Zipkin để thu traces.
4. Sử dụng Jaeger/Grafana Tempo để hiển thị trace.

Bài tập 17: Rate limiting & throttling
Mục tiêu: Bảo vệ API khỏi quá tải bằng rate limiting.
Các bước:
1. Dùng bucket4j hoặc redis-rate-limiter.
2. Áp rate limit trên gateway hoặc endpoint cụ thể.
3. Thử stress test để kiểm chứng.

Bài tập 18: Multi-tenancy cơ bản
Mục tiêu: Thiết kế app hỗ trợ multi-tenant theo schema hoặc column.
Các bước:
1. Lựa chọn chiến lược (separate schema, shared schema + tenant_id).
2. Middleware để resolve tenant từ header hoặc token.
3. Cấu hình datasource routing nếu cần.
Gợi ý: Bắt đầu với shared schema cho đơn giản.

Bài tập 19: Scheduled tasks và batch processing
Mục tiêu: Thực hiện xử lý theo lịch và xử lý batch lớn.
Các bước:
1. Dùng @Scheduled cho task nhẹ.
2. Dùng Spring Batch cho job batch lớn, checkpoint và restart.
3. Giám sát job status qua Admin hoặc DB table.

Bài tập 20: Implement health checks nâng cao
Mục tiêu: Tạo health indicators cho DB, queue, external services.
Các bước:
1. Implement HealthIndicator cho dịch vụ tùy chỉnh.
2. Kết hợp readiness/liveness probes nếu deploy trên Kubernetes.

Bài tập 21: Internationalization (i18n)
Mục tiêu: Hỗ trợ đa ngôn ngữ cho API messages và UI.
Các bước:
1. Tạo messages_{lang}.properties cho các ngôn ngữ.
2. Configure LocaleResolver và Interceptor.
3. Test bằng header Accept-Language.

Bài tập 22: File upload/download an toàn
Mục tiêu: Triển khai upload tập tin và lưu trữ an toàn (S3 hoặc local).
Các bước:
1. Xác thực người dùng trước khi upload.
2. Kiểm tra loại file, kích thước.
3. Lưu metadata vào DB, file vào storage.

Bài tập 23: Data migration với Flyway
Mục tiêu: Sử dụng Flyway cho migrate schema.
Các bước:
1. Thêm dependency flyway-core.
2. Viết migration scripts V1__init.sql, V2__add_table.sql.
3. Tích hợp trong pipeline để chạy migrate trước khi start app.

Bài tập 24: Feature toggles
Mục tiêu: Dùng feature flags để bật/tắt tính năng runtime.
Các bước:
1. Dùng Unleash/FF4J/LaunchDarkly hoặc Apollo config.
2. Tạo conditional logic trong code để check flag.

Bài tập 25: Security hardening
Mục tiêu: Áp các best practices bảo mật.
Các bước:
1. Sử dụng HTTPS, HSTS.
2. Cấu hình CSP, XSS protection headers.
3. Kiểm tra dependency vulnerabilities (Snyk/OWASP).

Bài tập 26: Blue/Green và Canary deployment
Mục tiêu: Triển khai không downtime và giảm rủi ro khi release.
Các bước:
1. Sử dụng LB/router để chuyển traffic.
2. Test canary bằng metrics và logs.

Bài tập 27: Observability nâng cao (logs, metrics, traces correlation)
Mục tiêu: Thiết lập correlation giữa logs và traces.
Các bước:
1. Gắn traceId trong logs.
2. Cấu hình dashboards liên quan.

Bài tập 28: Bulk import/ETL
Mục tiêu: Thiết kế pipeline nhập dữ liệu lớn vào hệ thống, xử lý bất đồng bộ.
Các bước:
1. Dùng batch hoặc stream (Kafka) cho ETL.
2. Giám sát throughput và retry logic.

Bài tập 29: Implementing websocket realtime
Mục tiêu: Thêm tính năng realtime (notifications) bằng WebSocket hoặc STOMP.
Các bước:
1. Thêm spring-boot-starter-websocket.
2. Thiết lập endpoint /ws và use SimpMessagingTemplate để push message.

Bài tập 30: Data archiving và housekeeping
Mục tiêu: Thiết kế cơ chế archive dữ liệu cũ để giữ hiệu năng DB.
Các bước:
1. Xác định retention policy.
2. Viết job di chuyển data sang cold storage.

Bài tập 31: Implement file scanning và virus check
Mục tiêu: Đảm bảo file upload an toàn.
Các bước:
1. Tích hợp clamAV hoặc dịch vụ quét.
2. Quarantine file suspect.

Bài tập 32: End-to-end CI/CD pipeline
Mục tiêu: Thiết lập pipeline build, test, containerize và deploy tự động.
Các bước:
1. Tạo workflow: checkout -> build -> test -> build image -> push -> deploy.
2. Thêm rung kiểm tra security & lint.

Bài tập 33: API documentation & contract (OpenAPI)
Mục tiêu: Document API với Swagger/OpenAPI.
Các bước:
1. Thêm springdoc-openapi.
2. Định nghĩa DTOs và annotates để tự động generate docs.

Bài tập 34: Pagination và sorting chuyên nghiệp
Mục tiêu: Implement cursor-based pagination cho large datasets.
Các bước:
1. Thiết kế API trả về cursor và hasNext flag.
2. Implement backend query efficient index usage.

Bài tập 35: CQRS pattern cơ bản
Mục tiêu: Tách read/write paths để tối ưu cho scale.
Các bước:
1. Thiết kế separate models cho read và write.
2. Sync data bằng event (event sourcing hoặc eventual consistency).

Bài tập 36: Secure secrets management
Mục tiêu: Quản lý secrets an toàn (DB passwords, API keys).
Các bước:
1. Dùng Vault/KMS để store secrets.
2. Không lưu secrets trong repo.

Bài tập 37: Implementing scheduler clustering
Mục tiêu: Đảm bảo scheduled task chỉ chạy một lần trong cluster.
Các bước:
1. Sử dụng ShedLock hoặc leader election.

Bài tập 38: GraphQL endpoint
Mục tiêu: Thêm GraphQL cho client cần query linh hoạt.
Các bước:
1. Thêm spring-boot-starter-graphql.
2. Define schema và resolvers.

Bài tập 39: Email service và retry
Mục tiêu: Gửi email asyn, retry khi thất bại.
Các bước:
1. Sử dụng Spring Mail + queue (RabbitMQ) để gửi asyn.
2. Cài retry policy và DLQ.

Bài tập 40: Implementing search suggestions & autocomplete
Mục tiêu: Tạo autocomplete cho tên product bằng ES.
Các bước:
1. Sử dụng completion suggesters của ES.
2. Tối ưu analyzers và mapping.

Bài tập 41: Implement file streaming and partial content
Mục tiêu: Hỗ trợ resume download và range requests.
Các bước:
1. Sử dụng HTTP range headers.
2. Kiểm tra large files và memory usage.

Bài tập 42: Kubernetes deployment basics
Mục tiêu: Deploy app lên k8s với manifests cơ bản.
Các bước:
1. Tạo Deployment, Service, ConfigMap, Secret.
2. Thiết lập readiness/liveness probes và resource limits.

Bài tập 43: Horizontal Pod Autoscaling and metrics
Mục tiêu: Autoscale dựa trên CPU hoặc custom metrics.
Các bước:
1. Cài HPA và Metrics Server.
2. Thử load test và observe scaling.

Bài tập 44: Canary release trên Kubernetes
Mục tiêu: Triển khai canary bằng label/weight.
Các bước:
1. Sử dụng Service mesh (Istio) hoặc ingress controller để route traffic.

Bài tập 45: Data encryption at rest và in transit
Mục tiêu: Bảo vệ dữ liệu lưu trữ và truyền tải.
Các bước:
1. Enable TLS cho DB và ES.
2. Sử dụng KMS cho encryption keys.

Bài tập 46: Implement backup và restore strategy
Mục tiêu: Đảm bảo recover dữ liệu khi mất.
Các bước:
1. Thiết lập backup schedule cho DB và ES.
2. Test restore procedure.

Bài tập 47: Performance tuning JVM
Mục tiêu: Tối ưu heap, GC và thread.
Các bước:
1. Giám sát bằng JMX, VisualVM hoặc Prometheus JMX exporter.
2. Điều chỉnh -Xmx, -Xms, chọn GC phù hợp (G1, ZGC...).

Bài tập 48: Dependency management and version pinning
Mục tiêu: Quản lý phiên bản dependency an toàn.
Các bước:
1. Sử dụng dependencyManagement/BOM.
2. Scan vulnerability và update định kỳ.

Bài tập 49: Design for backward compatibility of APIs
Mục tiêu: Cho phép evolve API mà không phá client cũ.
Các bước:
1. Versioning API (v1, v2) hoặc use accept headers.
2. Deprecate fields gracefully.

Bài tập 50: Cleanup và technical debt reduction
Mục tiêu: Tổ chức work để giảm technical debt.
Các bước:
1. Viết tasks để refactor, tidy up configs, remove unused dependencies.
2. Thực hiện code review checklist.

Kết luận phụ lục
Phần bài tập trên được thiết kế để bao phủ hầu hết các chủ đề đã trình bày trong chương. Mỗi bài tập có thể mở rộng thành project nhỏ. Khi hoàn thành, bạn sẽ có một hệ thống Spring Boot khá đầy đủ chức năng, sẵn sàng cho triển khai production.

---

Hướng tiếp theo
- Nếu bạn muốn, tôi có thể:
  - Tạo repository mẫu chứa skeleton cho một số bài tập (ví dụ: 1,2,3,4) và push lên một git remote.
  - Viết tập lệnh docker-compose.yml mẫu để chạy stack dev.
  - Tạo hướng dẫn CI/CD (GitHub Actions) mẫu để build/test/push image.

Chấm dứt phụ lục


---

Phần bổ sung: Bài tập 51-100 (mở rộng)

Bài tập 51: Implementing background jobs with Quartz
Mục tiêu: Thiết lập job phức tạp và hỗ trợ cron expression.
Các bước:
1. Thêm dependency quartz hoặc use spring-boot-starter-quartz.
2. Định nghĩa JobDetail và Trigger.
3. Cấu hình persistent job store (JDBC) nếu cần cluster.

Bài tập 52: Health check for downstream APIs
Mục tiêu: Tạo health indicator cho external API dependencies.
Các bước:
1. Implement HealthIndicator và gọi endpoint downstream nhẹ.
2. Tùy chỉnh status mapping và timeout.

Bài tập 53: Implement distributed locking with Redis
Mục tiêu: Dùng Redis để lock resource trong cluster.
Các bước:
1. Dùng Redisson hoặc setnx pattern.
2. Ensure lock release and handle deadlocks.

Bài tập 54: Implement feature auditing
Mục tiêu: Log các thay đổi cấu hình quan trọng và ai thay đổi.
Các bước:
1. Khi dùng Apollo hoặc config center, bật audit.
2. Ghi log chi tiết: user, timestamp, old/new value.

Bài tập 55: Implement soft delete và restore
Mục tiêu: Cho phép xóa mềm và phục hồi dữ liệu.
Các bước:
1. Thêm cột deleted_flag và filter in queries.
2. Tạo API restore và kiểm tra permissions.

Bài tập 56: Implement OAuth2 client login
Mục tiêu: Cho phép người dùng đăng nhập bằng Google/Facebook.
Các bước:
1. Thêm spring-boot-starter-oauth2-client.
2. Configure client registration và callback URI.

Bài tập 57: Data masking và PII handling
Mục tiêu: Che dấu thông tin nhạy cảm trong logs và responses.
Các bước:
1. Mask các trường PII trước khi log.
2. Áp encryption khi lưu trữ nhạy cảm.

Bài tập 58: Implementing content negotiation
Mục tiêu: Hỗ trợ trả XML/JSON theo Accept header.
Các bước:
1. Configure HttpMessageConverters.
2. Test endpoints trả content-type tương ứng.

Bài tập 59: Build a simple admin UI
Mục tiêu: Tạo UI (React/Vue) để quản trị products.
Các bước:
1. Scaffold frontend nhỏ (create-react-app).
2. Kết nối API, xử lý auth (JWT).

Bài tập 60: Implementing auditing trail with DB
Mục tiêu: Lưu lịch sử thay đổi bản ghi.
Các bước:
1. Tạo audit table và trigger hoặc ứng dụng ghi audit.
2. Cung cấp API xem lịch sử.

Bài tập 61: Implementing optimistic locking patterns
Mục tiêu: Tránh lost update trong concurrent updates.
Các bước:
1. Thêm version field và xử lý OptimisticLockException.
2. Test concurrency scenario.

Bài tập 62: Implementing bulk delete with safety
Mục tiêu: Xử lý xóa hàng loạt với confirmation và dry-run.
Các bước:
1. Thêm API dry-run để preview items affected.
2. Thực hiện job xóa theo batch và log.

Bài tập 63: Scheduled email digest
Mục tiêu: Gửi email tổng hợp hàng ngày cho users.
Các bước:
1. Sắp lịch job hàng ngày.
2. Biên dịch summary data và render template.

Bài tập 64: Implementing content caching with CDN
Mục tiêu: Sử dụng CDN cho static resources.
Các bước:
1. Host static content trên object storage.
2. Cấu hình CDN (CloudFront, Cloudflare) và cache headers.

Bài tập 65: Data validation pipeline and sanitization
Mục tiêu: Làm sạch input trước khi persist.
Các bước:
1. Xử lý trimming, normalizing input.
2. Áp whitelist cho các fields text.

Bài tập 66: Implementing SSE (Server-Sent Events)
Mục tiêu: Push realtime updates lên client bằng SSE.
Các bước:
1. Tạo endpoint produce SSE events.
2. Client subscribe và hiển thị events.

Bài tập 67: Implementing Graph database connector
Mục tiêu: Dùng Neo4j cho relational queries graph-like.
Các bước:
1. Thêm driver Neo4j và config.
2. Map domain và test traversal queries.

Bài tập 68: Implementing archiving to cold storage
Mục tiêu: Di chuyển dữ liệu cũ sang S3/Glacier.
Các bước:
1. Viết job select old data và upload archive.
2. Lưu metadata và link restore.

Bài tập 69: Implementing websocket authentication
Mục tiêu: Bảo vệ các kết nối realtime bằng token.
Các bước:
1. Thêm handshake interceptor check token.
2. Revocation và reconnect handling.

Bài tập 70: Implement domain events and eventual consistency
Mục tiêu: Thiết kế domain events để sync read models.
Các bước:
1. Define events và publish khi entity thay đổi.
2. Consumer cập nhật read-model hoặc ES index.

Bài tập 71: Implementing pagination cursors for GraphQL
Mục tiêu: Triển khai Relay-style cursors.
Các bước:
1. Thiết kế cursor format base64.
2. Implement pageInfo và edges structure.

Bài tập 72: Implementing multi-region deployment
Mục tiêu: Deploy ứng dụng ở nhiều region cho geo-redundancy.
Các bước:
1. Thiết kế data replication strategy.
2. Sử dụng load balancer geolocation routing.

Bài tập 73: Implementing event replay for debugging
Mục tiêu: Replay events để tái tạo bugs trên read-model.
Các bước:
1. Lưu event log có thể replay.
2. Tạo công cụ replay với optional filters.

Bài tập 74: Implementing database sharding basics
Mục tiêu: Phân shard theo tenant hoặc customer_id
Các bước:
1. Thiết kế sharding key và routing logic.
2. Tạo scripts để migrate data sang shards.

Bài tập 75: Implementing schema evolution for NoSQL
Mục tiêu: Quản lý schema changes cho NoSQL stores.
Các bước:
1. Sử dụng migration scripts cho documents.
2. Implement migration job with dry-run.

Bài tập 76: Implementing backpressure in stream processing
Mục tiêu: Kiểm soát throughput khi tiêu thụ streams.
Các bước:
1. Dùng reactive streams hoặc kafka consumer config.
2. Thiết kế retry/backoff policy.

Bài tập 77: Implementing secure file previews
Mục tiêu: Hiển thị preview file (image/pdf) an toàn.
Các bước:
1. Tạo service generate preview thumbnail.
2. Serve preview qua signed URL.

Bài tập 78: Implementing role-based access control (RBAC)
Mục tiêu: Thiết kế model RBAC cho ứng dụng.
Các bước:
1. Entities: Role, Permission, UserRole mapping.
2. Use @PreAuthorize với permission expressions.

Bài tập 79: Implementing transactional outbox pattern
Mục tiêu: Đảm bảo event publish reliable sau commit DB.
Các bước:
1. Thêm outbox table và insert trong cùng transaction.
2. Poller đọc outbox và publish messages.

Bài tập 80: Implementing optimistic read-retry patterns
Mục tiêu: Thực hiện optimistic reads và retry khi conflict.
Các bước:
1. Detect conflict bằng version hoặc hash.
2. Implement client-side retry with backoff.

Bài tập 81: Implementing background data reconciliation
Mục tiêu: So sánh và fix data drift giữa hệ thống.
Các bước:
1. Viết job compare và report differences.
2. Tạo fixer job với manual approve step.

Bài tập 82: Implementing access logging and analytics
Mục tiêu: Thu thập access logs để phân tích usage.
Các bước:
1. Ghi logs access thông qua filter/interceptor.
2. Ship logs vào analytics pipeline (ELK/Kafka).

Bài tập 83: Implementing blueprints for microservice modules
Mục tiêu: Tạo template module cho các loại service common.
Các bước:
1. Define archetype or template repo.
2. Include common libs và configs.

Bài tập 84: Implementing schema validation for messages
Mục tiêu: Validate message payloads using schema (JSON Schema/Avro).
Các bước:
1. Define schemas and registry.
2. Validate on producer and consumer sides.

Bài tập 85: Implementing search ranking experiments
Mục tiêu: Thử nghiệm tuning ranking trên ES.
Các bước:
1. Define relevance metrics and A/B test.
2. Collect analytics and iterate ranking.

Bài tập 86: Implementing user activity aggregation
Mục tiêu: Build aggregation pipeline for user metrics.
Các bước:
1. Stream events to kafka and process with stream job.
2. Store aggregates in time-series DB or analytics store.

Bài tập 87: Implementing data anonymization
Mục tiêu: Anonymize sensitive data for analytics.
Các bước:
1. Define transformation rules.
2. Apply during ETL step and store anonymized copies.

Bài tập 88: Implementing maintenance mode for app
Mục tiêu: Cho phép maintenance window và trả 503 cho users.
Các bước:
1. Toggle maintenance flag via admin endpoint.
2. Gateway trả 503 cho non-admin clients.

Bài tập 89: Implementing long-running job monitoring
Mục tiêu: Giám sát và thông báo khi job chạy lâu hoặc thất bại.
Các bước:
1. Emit metrics và alerts từ job.
2. Dashboard và notification channel (Slack/email).

Bài tập 90: Implementing data lineage tracking
Mục tiêu: Theo dõi nguồn gốc và transform của dữ liệu.
Các bước:
1. Log metadata transform stages.
2. Store lineage info and expose query API.

Bài tập 91: Implementing role-based UI features
Mục tiêu: Hide/show UI elements dựa trên role.
Các bước:
1. Backend trả roles trong token.
2. Frontend conditionally render components.

Bài tập 92: Implementing chaos engineering basics
Mục tiêu: Thử faults để cải thiện resilience.
Các bước:
1. Inject faults (latency, errors) trong staging.
2. Observe system behaviour and harden.

Bài tập 93: Implementing data sync between heterogeneous stores
Mục tiêu: Sync data giữa SQL và NoSQL stores.
Các bước:
1. Use change data capture or event-driven sync.
2. Ensure idempotency và ordering.

Bài tập 94: Implementing content moderation automation
Mục tiêu: Tự động kiểm duyệt nội dung (image/text).
Các bước:
1. Integrate ML service or third-party API.
2. Flag suspicious items and human-in-the-loop review.

Bài tập 95: Implementing payment gateway integration
Mục tiêu: Kết nối với service thanh toán (Stripe, PayPal).
Các bước:
1. Follow PCI compliance guidelines.
2. Test webhooks and retry logic.

Bài tập 96: Implementing multi-stage deployment pipelines
Mục tiêu: Dev -> Staging -> Production với promotion.
Các bước:
1. Configure pipeline stages và approvals.
2. Automate smoke tests on staging.

Bài tập 97: Implementing external API adapter layer
Mục tiêu: Tạo adapter để isolate external API changes.
Các bước:
1. Wrap external calls in adapter service.
2. Map external model to internal DTO.

Bài tập 98: Implementing usage-based billing metrics
Mục tiêu: Thu thập usage metrics để billing.
Các bước:
1. Define usage events và aggregate per customer.
2. Expose billing reports và invoices.

Bài tập 99: Implementing secure admin backdoor for debugging
Mục tiêu: Tạo safe backdoor (temporarily) để debug production.
Các bước:
1. Thêm admin-only endpoints protected mạnh.
2. Audit and time-limit such access.

Bài tập 100: Retrospective and documentation sprint
Mục tiêu: Hoàn thiện tài liệu, runbook, và retrospective.
Các bước:
1. Compile docs cho deploy, rollback, escalations.
2. Run retrospective và list action items.

Kết luận bổ sung
Danh sách 51-100 hoàn thiện giúp bạn có nguồn bài tập đa dạng cho từng chủ đề chuyên sâu. Thực hành từng bài tập sẽ trang bị kỹ năng thiết kế, triển khai và vận hành hệ thống Spring Boot quy mô.

---

Hết

