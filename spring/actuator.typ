== Spring Boot Actuator Prometheus
<spring-boot-actuator-prometheus>
Thêm dependency `micrometer-registry-prometheus` và bật endpoint:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
```
