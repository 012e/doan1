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
