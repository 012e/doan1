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
