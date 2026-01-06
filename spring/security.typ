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
