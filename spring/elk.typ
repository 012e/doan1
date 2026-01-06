== Spring Boot ELK (Elasticsearch, Logstash, Kibana)
<spring-boot-elk-elasticsearch-logstash-kibana>
- #strong[Logging]: Mặc định dùng Logback. Sử dụng
  `logstash-logback-encoder` để format JSON.
- #strong[Logstash]: Nhận logs từ Filebeat hoặc trực tiếp từ app để ship
  vào Elasticsearch.
- #strong[Kibana]: Visualize và tạo dashboard.
