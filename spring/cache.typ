== Spring Boot Cache & Redis
<spring-boot-cache-redis>

=== Giới thiệu Spring Cache Abstraction
<giới-thiệu-spring-cache>
Spring Framework cung cấp một lớp trừu tượng (abstraction) cho Caching, giúp lập trình viên sử dụng cache một cách nhất quán mà không phụ thuộc chặt chẽ vào thư viện bên dưới (Redis, EhCache, Caffeine, Hazelcast...).

#strong[Lợi ích:]
- Tăng tốc độ phản hồi API (Latency thấp).
- Giảm tải cho Database (Throughput cao).
- Tiết kiệm chi phí tính toán cho các tác vụ nặng.

=== Cài đặt Cache với Redis
<cài-đặt-cache-redis>
Redis là lựa chọn phổ biến nhất cho distributed cache.

#strong[1. Dependency]
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
```

#strong[2. Cấu hình Redis]
Trong `application.yml`:
```yaml
spring:
  data: # Spring Boot 3.x dùng spring.data.redis, 2.x dùng spring.redis
    redis:
      host: localhost
      port: 6379
      password: secret_password
      database: 0
      timeout: 2000ms
```

#strong[3. Cấu hình Cache Manager (Tùy chọn)]
Để tùy chỉnh TTL (Time-To-Live) cho từng loại cache:

```java
@Configuration
@EnableCaching
public class CacheConfig {
    @Bean
    public RedisCacheManagerBuilderCustomizer redisCacheManagerBuilderCustomizer() {
        return (builder) -> builder
            .withCacheConfiguration("userCache", 
                RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofMinutes(10)))
            .withCacheConfiguration("productCache", 
                RedisCacheConfiguration.defaultCacheConfig().entryTtl(Duration.ofHours(1)));
    }
}
```

=== Sử dụng Annotation
<sử-dụng-annotation>

#strong[1. `@EnableCaching`]
Đặt tại class main hoặc configuration để bật tính năng cache.

#strong[2. `@Cacheable`]
Dùng cho phương thức đọc (Read). Nếu cache có dữ liệu -> trả về ngay. Nếu chưa -> chạy hàm, lấy kết quả lưu vào cache.

```java
@Service
public class UserService {
    
    // Key sẽ là "userCache::123" (với id=123)
    // unless: Không cache nếu kết quả trả về là null
    @Cacheable(value = "userCache", key = "#id", unless = "#result == null")
    public User getUserById(Long id) {
        simulateSlowService();
        return userRepository.findById(id).orElse(null);
    }
}
```

#strong[3. `@CachePut`]
Dùng cho phương thức Thêm/Cập nhật (Write). Luôn chạy hàm và cập nhật kết quả mới vào cache.

```java
@CachePut(value = "userCache", key = "#user.id")
public User updateUser(User user) {
    return userRepository.save(user);
}
```

#strong[4. `@CacheEvict`]
Dùng cho phương thức Xóa. Xóa dữ liệu khỏi cache để tránh dữ liệu cũ (stale data).

```java
@CacheEvict(value = "userCache", key = "#id")
public void deleteUser(Long id) {
    userRepository.deleteById(id);
}

// Xóa toàn bộ cache (ví dụ khi master data thay đổi)
@CacheEvict(value = "userCache", allEntries = true)
public void clearAllCache() {}
```

#strong[5. `@Caching`]
Kết hợp nhiều annotation (ví dụ vừa update cache A, vừa xóa cache B).

=== Caching Pattern & Best Practices
<caching-pattern>
- #strong[Cache-Aside (Lazy Loading)]: Ứng dụng chịu trách nhiệm đọc/ghi cache. Đây là pattern mặc định của Spring Cache.
- #strong[Cache Key Design]: Nên kết hợp `prefix` + `entity_id` để dễ quản lý.
- #strong[TTL hợp lý]: Không bao giờ set TTL là vô hạn (trừ static data). Dữ liệu thay đổi nhanh -> TTL ngắn.
- #strong[Serialize]: Mặc định Spring dùng JDK Serialization (nhị phân, khó đọc). Nên cấu hình `GenericJackson2JsonRedisSerializer` để lưu dưới dạng JSON.

```java
@Bean
public RedisCacheConfiguration cacheConfiguration() {
    return RedisCacheConfiguration.defaultCacheConfig()
        .serializeValuesWith(SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer()));
}
```

=== Vấn đề thường gặp
<common-issues-cache>
- #strong[Cache Penetration]: Request liên tục query ID không tồn tại -> Cache miss -> Đánh sập DB. 
  *Giải pháp*: Cache cả giá trị null (với TTL ngắn) hoặc dùng Bloom Filter.
- #strong[Cache Avalanche]: Hàng loạt key hết hạn cùng lúc -> Request ùa vào DB.
  *Giải pháp*: Thêm `jitter` (random time) vào TTL của các key.
- #strong[Cache Breakdown]: Một key "hot" (được truy cập nhiều) hết hạn -> Nhiều thread cùng query DB để build lại cache.
  *Giải pháp*: Dùng Mutex Lock hoặc `@Cacheable(sync = true)`.