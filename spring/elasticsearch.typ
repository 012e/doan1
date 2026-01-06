== Spring Boot Elasticsearch
<spring-boot-elasticsearch>
=== Mục tiêu
<mục-tiêu-1>
Kết hợp ElasticSearch để cung cấp khả năng tìm kiếm full-text,
aggregation, và analytics.

=== Cấu hình
<cấu-hình>
#strong[application.yml:]

```yaml
spring:
  elasticsearch:
    rest:
      uris: http://localhost:9200
```

=== CRUD và Search
<crud-và-search>
- Spring Data Elasticsearch cung cấp repository và native query.
- Dùng `BulkRequest` để nhập dữ liệu lớn, xử lý batch size hợp lý.
