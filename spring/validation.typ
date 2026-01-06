== Spring Boot Validation (JSR-303/JSR-380)
<spring-boot-validation>

=== Giới thiệu Bean Validation
<validation-intro>
Trong phát triển API, việc kiểm tra dữ liệu đầu vào (Validation) là lá chắn đầu tiên để bảo vệ hệ thống khỏi dữ liệu rác, tấn công injection và lỗi logic.
Spring Boot hỗ trợ chuẩn #strong[Jakarta Bean Validation (JSR-380)] (trước đây là JSR-303). Implementation mặc định là thư viện #strong[Hibernate Validator].

=== Cài đặt
<validation-install>
Từ Spring Boot 2.3 trở đi, `spring-boot-starter-validation` không còn nằm mặc định trong `spring-boot-starter-web` (để giảm kích thước nếu không dùng). Bạn cần thêm thủ công:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-validation</artifactId>
</dependency>
```

=== Các Annotation Cơ bản thường dùng
<validation-annotations>
| Annotation | Mô tả | Loại dữ liệu |
| :--- | :--- | :--- |
| `@NotNull` | Không được null, nhưng có thể rỗng (""). | Mọi loại |
| `@NotEmpty` | Không null, độ dài > 0 (cho Collection/Map/Array/String). | String, Collection... |
| `@NotBlank` | Không null, và phải có ít nhất 1 ký tự không phải khoảng trắng (trim().length > 0). | String |
| `@Min` / `@Max` | Giá trị số phải nằm trong khoảng. | Number |
| `@Size` | Độ dài phải nằm trong khoảng (min, max). | String, Collection, Array |
| `@Email` | Phải đúng định dạng email. | String |
| `@Pattern` | Kiểm tra theo Regex (Biểu thức chính quy). | String |
| `@Past` / `@Future` | Ngày tháng phải trong quá khứ/tương lai. | Date, LocalDate... |
| `@AssertTrue`/`False`| Field phải là true/false. | Boolean |

=== Sử dụng trong Controller
<validation-controller>

#strong[1. Validate Request Body (JSON)]
Dùng `@Valid` (chuẩn Java) hoặc `@Validated` (Spring extension) trước tham số `@RequestBody`.

```java
@PostMapping("/users")
public ResponseEntity<String> register(@Valid @RequestBody UserDTO userDTO) {
    // Nếu dữ liệu sai, Spring sẽ ném MethodArgumentNotValidException
    // và code trong hàm này sẽ KHÔNG được chạy.
    return ResponseEntity.ok("User registered");
}
```

#strong[2. Validate Path Variable / Request Param]
Để validate các tham số đơn lẻ (không phải object), cần thêm `@Validated` ở mức Class (Controller).

```java
@RestController
@Validated // Bắt buộc
public class UserController {

    @GetMapping("/users/{id}")
    public User getUser(@PathVariable @Min(1) Long id) { ... }
    
    @GetMapping("/search")
    public List<User> search(@RequestParam @Size(min=3) String keyword) { ... }
}
```
*Lưu ý: Trường hợp này sẽ ném `ConstraintViolationException` thay vì `MethodArgumentNotValidException`.*

=== Nested Validation (Validate lồng nhau)
<nested-validation>
Nếu DTO chứa một object khác bên trong, `@Valid` ở ngoài sẽ không tự động kiểm tra object con. Cần thêm `@Valid` vào field object con đó.

```java
public class OrderDTO {
    @NotNull
    private String orderId;

    @Valid // Quan trọng! Nếu thiếu, danh sách items sẽ KHÔNG được kiểm tra
    @NotEmpty
    private List<OrderItemDTO> items;
}

public class OrderItemDTO {
    @NotBlank
    private String productName;
    @Min(1)
    private int quantity;
}
```

=== Xử lý lỗi (Exception Handling)
<validation-exception>
Để trả về JSON lỗi thân thiện thay vì stack trace dài ngoằng, ta dùng `@RestControllerAdvice`.

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    // Xử lý lỗi validate cho @RequestBody
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, String> handleJsonValidation(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getAllErrors().forEach((error) -> {
            String fieldName = ((FieldError) error).getField();
            String errorMessage = error.getDefaultMessage();
            errors.put(fieldName, errorMessage);
        });
        return errors;
    }

    // Xử lý lỗi validate cho @RequestParam / @PathVariable
    @ExceptionHandler(ConstraintViolationException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public Map<String, String> handleParamValidation(ConstraintViolationException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getConstraintViolations().forEach(violation -> {
            String propertyPath = violation.getPropertyPath().toString();
            errors.put(propertyPath, violation.getMessage());
        });
        return errors;
    }
}
```

=== Validation Group (Phân nhóm kiểm tra)
<validation-group>
Cùng một DTO nhưng logic validate khác nhau cho từng API (VD: `Insert` không cần ID, `Update` bắt buộc có ID).

1. Tạo interface đánh dấu (Marker Interface):
```java
public interface CreateGroup {}
public interface UpdateGroup {}
```

2. Gắn vào field DTO:
```java
public class ProductDTO {
    // Chỉ check khi dùng UpdateGroup
    @NotNull(groups = UpdateGroup.class) 
    private Long id;

    // Check cho cả 2 trường hợp
    @NotBlank(groups = {CreateGroup.class, UpdateGroup.class})
    private String name;
}
```

3. Chỉ định Group trong Controller bằng `@Validated` (không dùng `@Valid` được vì `@Valid` không hỗ trợ group):
```java
@PostMapping
public void create(@Validated(CreateGroup.class) @RequestBody ProductDTO dto) { ... }

@PutMapping
public void update(@Validated(UpdateGroup.class) @RequestBody ProductDTO dto) { ... }
```

=== Custom Validator (Tự viết logic kiểm tra)
<custom-validator>
Khi các annotation có sẵn không đủ (VD: Kiểm tra số điện thoại theo nhà mạng, kiểm tra trùng lặp trong DB...).

#strong[Ví dụ: `@UniqueEmail` kiểm tra email đã tồn tại chưa.]

1. Tạo Annotation:
```java
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = UniqueEmailValidator.class) // Link tới class xử lý
public @interface UniqueEmail {
    String message() default "Email đã tồn tại";
    Class<?>[] groups() default {};
    Class<? extends Payload>[] payload() default {};
}
```

2. Viết class xử lý (Implement `ConstraintValidator`):
```java
@Component // Để có thể @Autowired Repository
public class UniqueEmailValidator implements ConstraintValidator<UniqueEmail, String> {

    @Autowired
    private UserRepository userRepository;

    @Override
    public boolean isValid(String email, ConstraintValidatorContext context) {
        if (email == null || email.isBlank()) return true; // Để @NotBlank lo
        return !userRepository.existsByEmail(email);
    }
}
```

3. Sử dụng:
```java
public class UserRegisterDTO {
    @UniqueEmail
    private String email;
}
```

=== Fail Fast (Dừng ngay khi gặp lỗi đầu tiên)
<fail-fast>
Mặc định Hibernate Validator sẽ kiểm tra toàn bộ các field và trả về tất cả lỗi. Nếu muốn tối ưu performance (gặp lỗi dừng ngay), cấu hình như sau:

```java
@Bean
public Validator validator() {
    ValidatorFactory factory = Validation.byProvider(HibernateValidator.class)
        .configure()
        .failFast(true) // Bật chế độ Fail Fast
        .buildValidatorFactory();
    return factory.getValidator();
}
```
