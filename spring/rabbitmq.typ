== Spring Boot RabbitMQ
<spring-boot-rabbitmq>
=== Tổng quan
<tổng-quan-1>
RabbitMQ là message broker phổ biến sử dụng AMQP. Spring Boot hỗ trợ
RabbitMQ thông qua `spring-boot-starter-amqp`.

=== Cài đặt
<cài-đặt>
#strong[application.yml:]

```yaml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
```

=== Cấu hình cơ bản
<cấu-hình-cơ-bản>
- `RabbitTemplate` để publish message.
- `@RabbitListener` để tiêu thụ message.
- Tạo queue, exchange, binding bằng `@Bean` trong cấu hình.

=== Reliable messaging
<reliable-messaging>
- #strong[Acknowledgement modes]: auto, manual.
- #strong[Retry, DLX (dead-letter exchange)] cho message xử lý thất bại.
- #strong[Message converter]: `Jackson2JsonMessageConverter` để gửi
  JSON.
