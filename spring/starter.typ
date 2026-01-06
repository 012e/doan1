== Spring Boot Starter
<spring-boot-starter>

=== Khái niệm "Starter"
<khái-niệm-starter>
Spring Boot Starters là các "dependency descriptors" - các gói thư viện được đóng gói sẵn. Thay vì phải copy-paste hàng chục dòng cấu hình dependency trong `pom.xml` (và lo lắng về xung đột version), bạn chỉ cần import một starter duy nhất.

#strong[Ví dụ:] Khi thêm `spring-boot-starter-web`, nó sẽ tự động kéo về:
- Spring MVC (Core framework)
- Tomcat (Embedded Web Server)
- Jackson (JSON processing)
- Hibernate Validator (Validation)
- Logging (Logback + SLF4J)

=== Danh sách Starter Phổ biến
<danh-sách-starter>
Hầu hết starter đều theo quy tắc đặt tên: `spring-boot-starter-*`.

1. #strong[Core & Web]
   - `spring-boot-starter-web`: Xây dựng RESTful API (dùng Tomcat mặc định).
   - `spring-boot-starter-webflux`: Xây dựng Reactive Web (dùng Netty).
   - `spring-boot-starter-aop`: Lập trình hướng khía cạnh (Aspect Oriented Programming).

2. #strong[Data & Database]
   - `spring-boot-starter-data-jpa`: Tương tác SQL qua Hibernate.
   - `spring-boot-starter-jdbc`: Dùng JDBC Template thuần.
   - `spring-boot-starter-data-redis`: Kết nối Redis (dùng Lettuce).
   - `spring-boot-starter-data-mongodb`: Kết nối MongoDB.

3. #strong[Ops & Monitoring]
   - `spring-boot-starter-actuator`: Giám sát sức khỏe ứng dụng.
   - `spring-boot-starter-security`: Bảo mật (Authentication/Authorization).

4. #strong[Test]
   - `spring-boot-starter-test`: Bao gồm JUnit 5, Mockito, AssertJ, Hamcrest, Spring Test.

=== Cơ chế Auto-Configuration
<auto-configuration-mechanism>
Sức mạnh của Starter đến từ Auto-Configuration. Khi Spring Boot thấy một class nào đó trong classpath (do starter kéo về), nó sẽ tự động cấu hình các Bean tương ứng.

#strong[Ví dụ:]
- Nếu có file `h2-1.4.jar` trong classpath -> Tự động cấu hình `DataSource` kết nối tới H2 in-memory.
- Nếu có `spring-kafka` -> Tự động cấu hình `KafkaTemplate`.

=== Tùy biến Starter (Exclude Dependency)
<exclude-dependency>
Đôi khi bạn không muốn dùng thành phần mặc định trong starter. Ví dụ: Dùng Jetty thay vì Tomcat.

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <exclusions>
        <!-- Loại bỏ Tomcat -->
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<!-- Thêm Jetty vào thay thế -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jetty</artifactId>
</dependency>
```

=== Tạo Custom Starter
<create-custom-starter>
Với các công ty lớn, việc tạo một starter riêng (Internal Library) giúp chuẩn hóa cấu hình cho tất cả microservices.

#strong[Cấu trúc Custom Starter:]
Gồm 2 module:
1. `my-library-autoconfigure`: Chứa code logic và file `META-INF/spring/org.springframework.boot.autoconfigure.AutoConfiguration.imports`.
2. `my-library-starter`: Module rỗng, chỉ chứa `pom.xml` import module trên.

Người dùng chỉ cần import `my-library-starter` là có đủ tính năng.

=== Version Management (Spring Boot BOM)
<version-management>
Spring Boot cung cấp `spring-boot-dependencies` (BOM - Bill Of Materials) để quản lý version. Trong `pom.xml`, bạn thường thấy thẻ `<parent>`:

```xml
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>3.1.2</version>
</parent>
```

Nhờ đó, khi khai báo dependency bên dưới, bạn #strong[không cần ghi version]:
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <!-- Không cần <version> ở đây -->
</dependency>
```
Điều này đảm bảo mọi thư viện đều tương thích với nhau.