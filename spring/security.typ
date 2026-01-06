== Spring Boot Security (OAuth2, JWT)
<spring-boot-security-oauth2-jwt>

=== Giới thiệu Spring Security
<giới-thiệu-spring-security>
Spring Security là framework mạnh mẽ và có tính tùy biến cao, là tiêu chuẩn thực tế (de-facto standard) để bảo mật các ứng dụng Spring.

#strong[Các tính năng cốt lõi:]
- #strong[Authentication (Xác thực)]: Xác minh danh tính người dùng (Bạn là ai?).
- #strong[Authorization (Phân quyền)]: Kiểm soát quyền truy cập (Bạn được làm gì?).
- #strong[Protection (Bảo vệ)]: Chống lại các tấn công phổ biến như CSRF, CORS, Session Fixation, XSS...

=== Kiến trúc bên trong (Under the hood)
<kiến-trúc-security>
Spring Security hoạt động dựa trên một chuỗi các Servlet Filter, gọi là #strong[`SecurityFilterChain`].

1. Request đi vào ứng dụng.
2. Đi qua chuỗi Filter:
   - `LogoutFilter`: Xử lý logout.
   - `UsernamePasswordAuthenticationFilter`: Xử lý login form.
   - `BearerTokenAuthenticationFilter`: Xử lý JWT Token (cho Resource Server).
   - `ExceptionTranslationFilter`: Bắt lỗi Security (401/403).
   - `FilterSecurityInterceptor`: Chốt chặn cuối cùng, kiểm tra quyền truy cập URL.
3. Nếu qua hết Filter -> Vào Controller.

Các thành phần quan trọng khác:
- #strong[`SecurityContextHolder`]: Nơi lưu trữ thông tin user (`Authentication`) cho thread hiện tại.
- #strong[`AuthenticationManager`]: Interface chính điều phối việc xác thực.
- #strong[`UserDetailsService`]: Interface tải thông tin user từ DB (thường dùng cho Form Login).

=== OAuth2 Resource Server & JWT
<oauth2-resource-server>
Trong kiến trúc Microservices hiện đại, chúng ta thường tách việc xác thực ra một server riêng (Identity Provider - IdP) như Keycloak, Auth0, hoặc Google. Service của chúng ta đóng vai trò là #strong[Resource Server] nhận Access Token (JWT) từ client để cấp quyền truy cập.

#strong[1. Cài đặt Dependency]
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-oauth2-resource-server</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-security</artifactId>
</dependency>
```

#strong[2. Cấu hình `application.yml`]
Kết nối tới IdP để lấy Public Key (dùng để verify chữ ký JWT).

```yaml
spring:
  security:
    oauth2:
      resourceserver:
        jwt:
          # URL trỏ tới file JWK Set (chứa public keys)
          # Ví dụ với Keycloak:
          jwk-set-uri: http://localhost:8080/realms/myrealm/protocol/openid-connect/certs
          # Hoặc dùng issuer-uri (Spring tự động tìm cấu hình)
          # issuer-uri: http://localhost:8080/realms/myrealm
```

=== Cấu hình Security Chi tiết
<security-config-detailed>
Tạo class cấu hình để tùy biến hành vi bảo mật.

```java
@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true) // Bật @PreAuthorize
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // 1. Tắt CSRF vì API Stateless không dùng Session/Cookie
            .csrf(csrf -> csrf.disable()) 
            
            // 2. Cấu hình CORS (nếu frontend khác domain)
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))
            
            // 3. Không lưu State (Session) -> Mỗi request phải có Token
            .sessionManagement(sess -> sess.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            
            // 4. Phân quyền URL
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/public/**", "/auth/login", "/docs/**").permitAll() // API công khai
                .requestMatchers("/admin/**").hasRole("ADMIN") // Chỉ role ADMIN
                .anyRequest().authenticated() // Các API khác cần login
            )
            
            // 5. Cấu hình Resource Server (JWT)
            .oauth2ResourceServer(oauth2 -> oauth2
                .jwt(jwt -> jwt.jwtAuthenticationConverter(jwtAuthenticationConverter()))
            )
            
            // 6. Xử lý lỗi 401/403 trả về JSON chuẩn
            .exceptionHandling(ex -> ex
                .authenticationEntryPoint(new CustomAuthenticationEntryPoint())
                .accessDeniedHandler(new CustomAccessDeniedHandler())
            );
        
        return http.build();
    }

    // Cấu hình CORS: Cho phép Frontend gọi API
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:3000", "https://myapp.com"));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type"));
        configuration.setAllowCredentials(true);
        
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
```

=== Xử lý Role từ JWT (Keycloak Example)
<jwt-role-converter>
Mặc định Spring Security tìm claim `scope` hoặc `scp`. Keycloak lại để roles trong `realm_access.roles` hoặc `resource_access`. Ta cần Converter để Spring hiểu.

```java
private JwtAuthenticationConverter jwtAuthenticationConverter() {
    JwtGrantedAuthoritiesConverter grantedAuthoritiesConverter = new JwtGrantedAuthoritiesConverter();
    grantedAuthoritiesConverter.setAuthoritiesClaimName("roles"); // Default
    grantedAuthoritiesConverter.setAuthorityPrefix("ROLE_");

    return new JwtAuthenticationConverter() {
        @Override
        protected Collection<GrantedAuthority> extractAuthorities(Jwt jwt) {
            // 1. Lấy scope mặc định
            Collection<GrantedAuthority> authorities = grantedAuthoritiesConverter.convert(jwt);
            
            // 2. Lấy role từ Keycloak (realm_access)
            Map<String, Object> realmAccess = jwt.getClaim("realm_access");
            if (realmAccess != null) {
                List<String> roles = (List<String>) realmAccess.get("roles");
                if (roles != null) {
                    roles.forEach(role -> 
                        authorities.add(new SimpleGrantedAuthority("ROLE_" + role.toUpperCase()))
                    );
                }
            }
            return authorities;
        }
    };
}
```

=== Lấy thông tin User (Principal)
<get-user-principal>

#strong[Cách 1: Inject `Jwt` object]
```java
@GetMapping("/me")
public ResponseEntity<?> getMe(@AuthenticationPrincipal Jwt jwt) {
    String userId = jwt.getSubject(); // Lấy 'sub' claim
    String email = jwt.getClaimAsString("email");
    return ResponseEntity.ok("User: " + userId + " - " + email);
}
```

#strong[Cách 2: Inject `SecurityContext` (Global)]
```java
public String getCurrentUsername() {
    Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
    if (authentication != null && authentication.getPrincipal() instanceof Jwt) {
        Jwt jwt = (Jwt) authentication.getPrincipal();
        return jwt.getClaimAsString("preferred_username");
    }
    return "anonymous";
}
```

=== Bảo mật mức Method (`@PreAuthorize`)
<method-security>
Cho phép kiểm soát quyền chi tiết trên từng hàm service.

```java
@Service
public class DocumentService {

    // Chỉ ADMIN hoặc MANAGER
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER')")
    public void approveDocument(Long id) { ... }

    // Chỉ chủ sở hữu document mới được xem
    // userId được lấy từ tham số hàm, authentication lấy từ SecurityContext
    @PreAuthorize("#userId == authentication.token.claims['sub']") 
    public List<Doc> getUserDocuments(String userId) { ... }
}
```

=== Testing với Security
<testing-security>
Sử dụng `spring-security-test` để mock user trong Unit/Integration Test.

```xml
<dependency>
    <groupId>org.springframework.security</groupId>
    <artifactId>spring-security-test</artifactId>
    <scope>test</scope>
</dependency>
```

```java
@SpringBootTest
@AutoConfigureMockMvc
class ApiTest {

    @Autowired MockMvc mockMvc;

    @Test
    @WithMockUser(username = "huy", roles = {"USER"}) // Giả lập user đã login
    void testGetProfile() throws Exception {
        mockMvc.perform(get("/api/me"))
               .andExpect(status().isOk());
    }

    @Test
    @WithMockUser(roles = {"USER"})
    void testAdminOnlyApi_ShouldFail() throws Exception {
        mockMvc.perform(get("/admin/settings"))
               .andExpect(status().isForbidden()); // 403
    }
    
    // Test với JWT cụ thể (mock claims)
    @Test
    @WithJwt(claims = @Claims(sub = "user-123", email = "test@example.com"))
    void testJwtApi() { ... }
}
```

=== Best Practices Checklist
<best-practices-security>
1. #strong[HTTPS Only]: Token (Bearer Token) gửi qua header, nếu không mã hóa HTTPS sẽ bị bắt gói tin và đánh cắp.
2. #strong[Short-lived Access Token]: Để token sống ngắn (5-15 phút). Dùng Refresh Token để lấy token mới.
3. #strong[Không lưu Secret trong Code]: Các thông tin nhạy cảm không được commit lên git.
4. #strong[Auditing]: Ghi log ai đã làm gì (Who did what?). Spring Security tích hợp tốt với Spring Data JPA Auditing (`@CreatedBy`, `@LastModifiedBy`).
5. #strong[Security Headers]: Luôn bật các header bảo mật mặc định (X-Content-Type-Options, X-Frame-Options, X-XSS-Protection) - Spring Security bật sẵn.
