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
