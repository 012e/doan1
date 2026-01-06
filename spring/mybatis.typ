== Spring Boot MyBatis-Plus
<spring-boot-mybatis-plus>

=== Giới thiệu & So sánh
<giới-thiệu-mybatis-plus>
MyBatis-Plus (MBP) là một thư viện mở rộng mạnh mẽ cho MyBatis, giúp đơn giản hóa việc phát triển mà không làm mất đi tính linh hoạt của MyBatis gốc.

#strong[So sánh nhanh:]
- #strong[JPA/Hibernate]: Tốt cho các quan hệ object phức tạp, nhưng khó tối ưu SQL và có overhead performance.
- #strong[MyBatis]: Kiểm soát hoàn toàn SQL, performance tốt, nhưng phải viết XML/Annotation cho mọi câu CRUD cơ bản.
- #strong[MyBatis-Plus]: Kết hợp cả hai. Có sẵn CRUD (như JPA) nhưng vẫn cho phép viết SQL tay (như MyBatis) khi cần.

=== Cài đặt & Cấu hình Chi tiết
<cài-đặt-cấu-hình-mybatis>

#strong[1. Dependency]
```xml
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>mybatis-plus-boot-starter</artifactId>
    <version>3.5.3.1</version> <!-- Kiểm tra version mới nhất -->
</dependency>
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>
```

#strong[2. Cấu hình `application.yml`]
```yaml
mybatis-plus:
  # Vị trí file XML mapper (nếu dùng)
  mapper-locations: classpath*:/mapper/**/*.xml
  # Alias cho entity package để viết ngắn gọn trong XML
  type-aliases-package: com.example.demo.entity
  configuration:
    # Tự động map user_name (DB) -> userName (Java)
    map-underscore-to-camel-case: true
    # Log SQL ra console để debug
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
  global-config:
    db-config:
      # Chiến lược sinh ID: AUTO (DB tự tăng), ASSIGN_ID (Snowflake), ASSIGN_UUID...
      id-type: auto
      # Cấu hình Logic Delete (Xóa mềm)
      logic-delete-value: 1
      logic-not-delete-value: 0
```

=== Cơ chế CRUD Interface
<crud-interface>
Mô hình code tiêu chuẩn của MyBatis-Plus:

#strong[1. Entity]
```java
@Data
@TableName("sys_user")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String name;
    private Integer age;
    
    @TableField(fill = FieldFill.INSERT) // Tự động điền khi insert
    private LocalDateTime createTime;
    
    @TableLogic // Đánh dấu field xóa mềm
    private Integer deleted;
}
```

#strong[2. Mapper]
Chỉ cần kế thừa `BaseMapper<T>`, có ngay các hàm: `insert`, `deleteById`, `updateById`, `selectById`, `selectList`...
```java
@Mapper
public interface UserMapper extends BaseMapper<User> {
    // Có thể viết thêm hàm custom query tại đây
    @Select("SELECT * FROM sys_user WHERE age > #{age}")
    List<User> selectUsersOlderThan(int age);
}
```

#strong[3. Service]
Kế thừa `IService<T>` và `ServiceImpl` để có các hàm transaction như `saveBatch`, `saveOrUpdate`.
```java
public interface UserService extends IService<User> {}

@Service
public class UserServiceImpl extends ServiceImpl<UserMapper, User> implements UserService {}
```

=== Query Wrapper & Lambda Wrapper
<query-wrapper>
Đây là tính năng mạnh nhất giúp xây dựng câu `WHERE` động mà không cần nối chuỗi String.

```java
// Cách 1: QueryWrapper (Hard-code column name - dễ sai chính tả)
QueryWrapper<User> query = new QueryWrapper<>();
query.eq("name", "Huy")
     .gt("age", 18)
     .like("email", "@gmail.com");

// Cách 2: LambdaQueryWrapper (Type-safe - Khuyên dùng)
LambdaQueryWrapper<User> lambda = new LambdaQueryWrapper<>();
lambda.eq(User::getName, "Huy")
      .ge(User::getAge, 18)
      .orderByDesc(User::getCreateTime);

List<User> users = userMapper.selectList(lambda);
```

=== Pagination (Phân trang)
<pagination>
Để dùng phân trang, cần đăng ký Interceptor:

```java
@Configuration
public class MybatisConfig {
    @Bean
    public MybatisPlusInterceptor mybatisPlusInterceptor() {
        MybatisPlusInterceptor interceptor = new MybatisPlusInterceptor();
        // Thêm plugin phân trang cho MySQL
        interceptor.addInnerInterceptor(new PaginationInnerInterceptor(DbType.MYSQL));
        return interceptor;
    }
}
```

Sử dụng trong code:
```java
Page<User> page = new Page<>(1, 10); // Trang 1, 10 record/trang
userMapper.selectPage(page, new LambdaQueryWrapper<User>().gt(User::getAge, 20));

long total = page.getTotal();
List<User> records = page.getRecords();
```

=== Các tính năng nâng cao khác
<advanced-features>
- #strong[Auto-fill Handler]: Tự động điền `create_time`, `update_time` bằng cách implement `MetaObjectHandler`.
- #strong[Optimistic Locking]: Dùng plugin `OptimisticLockerInnerInterceptor` và annotation `@Version` để ngăn chặn race condition khi update.
- #strong[Performance Analysis]: Dùng plugin `BlockAttackInnerInterceptor` để chặn các câu lệnh DELETE/UPDATE toàn bộ bảng (quên WHERE).
- #strong[Code Generator]: Có công cụ sinh code tự động từ schema DB (Controller, Service, Mapper, XML, Entity).

=== Best Practices
<best-practices-mybatis>
- Luôn ưu tiên dùng #strong[`LambdaQueryWrapper`] để tận dụng compile-time check.
- Với các query phức tạp (JOIN nhiều bảng, sub-query), hãy viết #strong[XML Mapper] thuần túy để dễ tối ưu và maintain, đừng cố dùng Wrapper.
- Sử dụng #strong[`IService.saveBatch()`] cho các thao tác insert số lượng lớn (bulk insert) thay vì vòng lặp `save()`.