== Spring Boot Elasticsearch
<spring-boot-elasticsearch>

=== Tổng quan
<tổng-quan-elasticsearch>
Elasticsearch (ES) là một công cụ tìm kiếm và phân tích phân tán (distributed search & analytics engine) dựa trên Apache Lucene. Trong hệ sinh thái Spring, nó được sử dụng để:
- Tìm kiếm văn bản (Full-text search) nhanh chóng.
- Gợi ý từ khóa (Autocomplete).
- Phân tích log (Log analysis) và dashboard (kết hợp Kibana).
- Lọc dữ liệu phức tạp (Geo-location, faceted search).

=== Cài đặt và Kết nối
<cài-đặt-elasticsearch>

#strong[1. Dependency]
```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-elasticsearch</artifactId>
</dependency>
```

#strong[2. Cấu hình `application.yml`]
```yaml
spring:
  elasticsearch:
    uris: http://localhost:9200
    username: elastic # Nếu có security
    password: changeme
    socket-timeout: 10s
```

=== Định nghĩa Document
<định-nghĩa-document>
Thay vì `@Entity` của JPA, ta dùng `@Document`.

```java
@Document(indexName = "products")
@Data
public class Product {
    @Id
    private String id;

    @Field(type = FieldType.Text, analyzer = "standard")
    private String name;

    @Field(type = FieldType.Keyword) // Keyword dùng để filter chính xác, không tách từ
    private String category;

    @Field(type = FieldType.Double)
    private Double price;
    
    @Field(type = FieldType.Date, format = DateFormat.date_optional_time)
    private LocalDateTime createdDate;
}
```

=== Sử dụng Repository (Spring Data)
<elasticsearch-repository>
Cách đơn giản nhất, tương tự JPA Repository.

```java
public interface ProductRepository extends ElasticsearchRepository<Product, String> {
    
    // Tìm chính xác theo category
    List<Product> findByCategory(String category);
    
    // Tìm tương đối theo tên (Match Query)
    List<Product> findByNameContaining(String name);
    
    // Tìm trong khoảng giá
    List<Product> findByPriceBetween(Double min, Double max);
}
```

=== Sử dụng ElasticsearchOperations (Advanced)
<elasticsearch-operations>
Khi cần query phức tạp, custom aggregation, highlight kết quả...

```java
@Service
public class ProductSearchService {
    @Autowired
    private ElasticsearchOperations elasticsearchOperations;

    public SearchHits<Product> searchProducts(String keyword, Double minPrice) {
        // Xây dựng query
        Criteria criteria = new Criteria("name").contains(keyword)
                            .and("price").greaterThanEqual(minPrice);
        
        Query query = new CriteriaQuery(criteria);
        
        // Thực thi search
        return elasticsearchOperations.search(query, Product.class);
    }
    
    // Native Query (Viết JSON Query trực tiếp)
    public void nativeQueryExample() {
        NativeQuery query = NativeQuery.builder()
            .withQuery(q -> q.match(m -> m.field("name").query("laptop")))
            .withAggregation("avg_price", Aggregation.of(a -> a.avg(avg -> avg.field("price"))))
            .build();
            
        SearchHits<Product> hits = elasticsearchOperations.search(query, Product.class);
    }
}
```

=== Đồng bộ dữ liệu (Sync Data)
<sync-data-elasticsearch>
Dữ liệu thường nằm chính ở DB (MySQL/PostgreSQL) và được sync sang ES để tìm kiếm.
- #strong[Sync đồng bộ]: Khi save vào DB -> gọi luôn hàm save vào ES. (Dễ nhất nhưng tăng latency, không đảm bảo consistency nếu lỗi).
- #strong[Sync bất đồng bộ (Async)]: Dùng `@Async` hoặc Message Queue (RabbitMQ/Kafka).
- #strong[CDC (Change Data Capture)]: Dùng Debezium hoặc Logstash để đọc binlog của DB và đẩy sang ES (Chuyên nghiệp nhất).

=== Best Practices
<best-practices-elasticsearch>
- #strong[Index Lifecycle Management (ILM)]: Cấu hình xoá index cũ (ví dụ log 30 ngày) để tiết kiệm disk.
- #strong[Mapping cẩn thận]: Đừng để ES tự đoán kiểu dữ liệu (dynamic mapping) trong production. Hãy định nghĩa rõ `Text` vs `Keyword`.
- #strong[Bulk Insert]: Luôn dùng `saveAll()` hoặc Bulk Request khi import dữ liệu lớn để tăng tốc độ gấp 10-100 lần.
