== Spring Boot RabbitMQ
<spring-boot-rabbitmq>

=== Tổng quan về Messaging
<tổng-quan-messaging>
RabbitMQ là một Message Broker mã nguồn mở, triển khai giao thức AMQP (Advanced Message Queuing Protocol). Nó đóng vai trò trung gian giúp các microservices giao tiếp bất đồng bộ (asynchronous), tách biệt (decoupling) và chịu tải (load leveling).

=== Cài đặt và Cấu hình
<cài-đặt-rabbitmq>

#strong[1. Dependency]
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-amqp</artifactId>
</dependency>
```

#strong[2. Cấu hình `application.yml`]
```yaml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
    # Cấu hình Publisher Confirms (đảm bảo message đã tới Broker)
    publisher-confirm-type: correlated
    publisher-returns: true
    listener:
      simple:
        # Chế độ Acknowledge: AUTO, MANUAL, NONE
        acknowledge-mode: manual
        # Số lượng consumer concurrent
        concurrency: 3
        max-concurrency: 10
```

=== Các mô hình Exchange cơ bản
<exchange-models>
- #strong[Direct Exchange]: Gửi message đến queue có `routingKey` khớp hoàn toàn. (1-1)
- #strong[Fanout Exchange]: Gửi message đến #strong[tất cả] queue đã bind vào nó, không quan tâm routingKey. (Broadcast)
- #strong[Topic Exchange]: Gửi message dựa trên pattern matching của routingKey (ví dụ: `order.*`, `#.log`). (Pub/Sub linh hoạt)
- #strong[Headers Exchange]: Dựa trên header của message thay vì routingKey (ít dùng).

=== Code Ví dụ: Producer & Consumer
<code-example-rabbitmq>

#strong[1. Cấu hình Queue & Exchange]
```java
@Configuration
public class RabbitConfig {
    public static final String QUEUE_NAME = "order.queue";
    public static final String EXCHANGE_NAME = "order.exchange";
    public static final String ROUTING_KEY = "order.created";

    @Bean
    public Queue queue() {
        return new Queue(QUEUE_NAME, true); // true = durable (bền vững khi restart)
    }

    @Bean
    public DirectExchange exchange() {
        return new DirectExchange(EXCHANGE_NAME);
    }

    @Bean
    public Binding binding(Queue queue, DirectExchange exchange) {
        return BindingBuilder.bind(queue).to(exchange).with(ROUTING_KEY);
    }
    
    // Converter để tự động chuyển Object <-> JSON
    @Bean
    public MessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }
}
```

#strong[2. Producer (Gửi tin)]
```java
@Service
public class RabbitProducer {
    @Autowired
    private RabbitTemplate rabbitTemplate;

    public void sendOrder(OrderDTO order) {
        // Gửi object, converter sẽ biến nó thành JSON
        rabbitTemplate.convertAndSend(
            RabbitConfig.EXCHANGE_NAME, 
            RabbitConfig.ROUTING_KEY, 
            order
        );
        System.out.println("Sent order: " + order.getId());
    }
}
```

#strong[3. Consumer (Nhận tin)]
```java
@Component
public class RabbitConsumer {

    @RabbitListener(queues = RabbitConfig.QUEUE_NAME)
    public void receiveOrder(OrderDTO order, Channel channel, @Header(AmqpHeaders.DELIVERY_TAG) long tag) {
        try {
            System.out.println("Processing order: " + order.getId());
            // Xử lý logic nghiệp vụ...
            
            // Xác nhận thành công (ACK) -> Xóa message khỏi queue
            channel.basicAck(tag, false);
        } catch (Exception e) {
            // Xử lý lỗi -> Reject và requeue (hoặc đẩy vào Dead Letter Queue)
            // channel.basicNack(tag, false, true); 
        }
    }
}
```

=== Xử lý Message tin cậy (Reliability)
<reliability-rabbitmq>
Để đảm bảo không mất message trong môi trường phân tán:

#strong[1. Phía Producer: Publisher Confirms]
Đảm bảo message đã đến được Exchange.
```java
rabbitTemplate.setConfirmCallback((correlationData, ack, cause) -> {
    if (ack) {
        log.info("Message sent successfully");
    } else {
        log.error("Message send failed: " + cause);
        // Logic retry hoặc lưu vào bảng log DB để gửi lại
    }
});
```

#strong[2. Phía Consumer: Manual Acknowledge]
Sử dụng `acknowledge-mode: manual` như ví dụ trên. Chỉ gửi ACK khi code chạy xong không lỗi. Nếu service crash giữa chừng, message sẽ ở lại queue và được gửi cho consumer khác.

#strong[3. Dead Letter Queue (DLQ)]
Xử lý các message bị lỗi nhiều lần hoặc hết hạn (TTL).
- Tạo một `dlx.exchange` và `dlx.queue`.
- Cấu hình queue chính để forward message sang DLX khi bị reject.

```java
@Bean
public Queue mainQueue() {
    Map<String, Object> args = new HashMap<>();
    args.put("x-dead-letter-exchange", "dlx.exchange");
    args.put("x-dead-letter-routing-key", "dlx.routing.key");
    return new Queue("main.queue", true, false, false, args);
}
```

=== Ứng dụng thực tế
<use-cases-rabbitmq>
- #strong[Xử lý bất đồng bộ]: Gửi email/SMS sau khi đăng ký tài khoản (User Service -> Notification Service).
- #strong[Giảm tải (Throttling)]: Hàng đợi đặt hàng trong giờ cao điểm (Flash Sales).
- #strong[Log Aggregation]: Thu thập log từ nhiều service về một nơi xử lý.