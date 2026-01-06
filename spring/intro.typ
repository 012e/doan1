== Giới thiệu chương
<giới-thiệu-chương>
Chương này trình bày hướng dẫn chi tiết để xây dựng hệ thống với Spring
Boot. Nội dung bao gồm khái niệm, các starter phổ biến, tích hợp với thư
viện (MyBatis-Plus), cache, message broker (RabbitMQ), tìm kiếm
(Elasticsearch), containerization (Docker), logging & observability
(ELK), quản trị ứng dụng (Spring Boot Admin), cấu hình phân tán
(Apollo), bảo mật (Spring Security, OAuth2, JWT), giám sát (Actuator +
Prometheus), giao dịch phân tán (Seata), validation (JSR-303), discovery
(Eureka), cũng như các mô-đun liên quan đến microservices: Ribbon,
Feign, Hystrix, Turbine, Dashboard.

Tài liệu được viết nhằm mục đích:

- Cung cấp hướng dẫn thực tế, có ví dụ cấu hình.
- Phù hợp cho người phát triển backend, kiến trúc sư hệ thống hoặc sinh
  viên nắm bắt mẫu thiết kế microservices với Spring Boot.
- Có thể dùng làm tài liệu nội bộ hoặc làm tài liệu học tập.

#strong[Phạm vi và giả định]

- Giả định người đọc đã có kiến thức cơ bản về Java và Maven/Gradle.
- Sử dụng Spring Boot 2.x hoặc 3.x (nếu có khác biệt, sẽ ghi chú rõ
  ràng).
- Các ví dụ tập trung vào tính thực tiễn: cấu hình `application.yml`,
  Dockerfile, và các đoạn code minh họa.
