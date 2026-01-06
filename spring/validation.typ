== Spring Boot JSR-303
<spring-boot-jsr-303>
Sử dụng `spring-boot-starter-validation` để validate dữ liệu input:

```java
public ResponseEntity create(@Valid @RequestBody DTO dto, BindingResult result) { ... }
```
