== Spring Boot Logging & ELK Stack
<spring-boot-elk>

=== Tổng quan Logging
<logging-overview>
Spring Boot dùng Commons Logging cho internal logging, nhưng cấu hình mặc định là #strong[Logback].
Trong môi trường production và microservices, việc xem log qua file text là bất khả thi. Ta cần giải pháp #strong[Centralized Logging] (Nhật ký tập trung).

ELK Stack bao gồm:
- #strong[Elasticsearch]: Kho chứa và tìm kiếm log.
- #strong[Logstash]: Pipeline xử lý log (Filter, Parse, Enrich).
- #strong[Kibana]: Giao diện xem log.
- #strong[Filebeat/Fluentd]: Agent gửi log từ app server về Logstash/ES.

=== Cấu hình Logback xuất JSON
<logback-json>
Để máy dễ đọc, ta nên format log thành JSON thay vì text thuần.

#strong[1. Dependency]
```xml
<dependency>
    <groupId>net.logstash.logback</groupId>
    <artifactId>logstash-logback-encoder</artifactId>
    <version>7.3</version>
</dependency>
```

#strong[2. Cấu hình `logback-spring.xml`]
Tạo file này trong `src/main/resources`.

```xml
<configuration>
    <appender name="JSON_CONSOLE" class="ch.qos.logback.core.ConsoleAppender">
        <encoder class="net.logstash.logback.encoder.LogstashEncoder">
            <!-- Thêm field custom -->
            <customFields>{"app_name":"my-service"}</customFields>
        </encoder>
    </appender>
    
    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <file>logs/app.log</file>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>logs/app.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>7</maxHistory>
        </rollingPolicy>
        <encoder class="net.logstash.logback.encoder.LogstashEncoder"/>
    </appender>

    <root level="INFO">
        <appender-ref ref="JSON_CONSOLE" />
        <appender-ref ref="FILE" />
    </root>
</configuration>
```

=== Mô hình triển khai
<deployment-model>

#strong[Cách 1: App -> Logstash -> ES (Direct TCP)]
App gửi log trực tiếp qua TCP/UDP tới Logstash.
- Ưu điểm: Đơn giản.
- Nhược điểm: Nếu Logstash chết, App có thể bị block hoặc mất log.

#strong[Cách 2: App -> File -> Filebeat -> Logstash -> ES (Khuyên dùng)]
App chỉ việc ghi log ra file (như truyền thống). Filebeat (nhẹ) chạy background đọc file đó và đẩy đi.
- Ưu điểm: Tách biệt, App không phụ thuộc hệ thống log, đảm bảo performance.

=== Cấu hình Pipeline (Filebeat + Logstash)
<pipeline-config>

#strong[1. Filebeat (`filebeat.yml`)]
```yaml
filebeat.inputs:
- type: log
  enabled: true
  paths:
    - /path/to/app/logs/*.log
  json.keys_under_root: true # Parse JSON log từ app

output.logstash:
  hosts: ["logstash:5044"]
```

#strong[2. Logstash (`logstash.conf`)]
```conf
input {
  beats {
    port => 5044
  }
}

filter {
  # Có thể filter bớt log debug hoặc mask thông tin nhạy cảm
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
    index => "microservice-logs-%{+YYYY.MM.dd}"
  }
}
```

=== Trace ID (Sleuth / Micrometer Tracing)
<trace-id>
Trong microservices, request đi qua nhiều service. Cần một ID duy nhất để gom log lại.
Spring Boot 3 dùng Micrometer Tracing (trước đây là Spring Cloud Sleuth).

Khi tích hợp, log sẽ tự động có thêm:
`[OrderService, traceId=64a1b2c3, spanId=8e9d0a]`

Copy `traceId` này paste vào Kibana, bạn sẽ thấy toàn bộ hành trình của request đó.