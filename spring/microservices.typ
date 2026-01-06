== Microservices Modules
<microservices-modules>
=== Eureka
<eureka>
Service discovery giúp các instance tự đăng ký và tìm thấy nhau.

- #strong[Server]: `@EnableEurekaServer`.
- #strong[Client]: `@EnableEurekaClient`.

=== Ribbon / Spring Cloud LoadBalancer
<ribbon-spring-cloud-loadbalancer>
Client-side load balancer để phân phối request giữa các instance.

=== Feign
<feign>
Declarative REST client. Định nghĩa interface với `@FeignClient` để gọi
service khác một cách dễ dàng.

=== Hystrix / Resilience4j
<hystrix-resilience4j>
Cung cấp Circuit Breaker để ngăn chặn lỗi dây chuyền (cascading
failures).
