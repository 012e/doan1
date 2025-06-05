= Caching
<caching>
== Tổng quan về caching
<tổng-quan-về-caching>
Caching là kỹ thuật lưu trữ tạm thời dữ liệu trong một không gian lưu
trữ nhanh hơn nhằm giảm thời gian truy cập và tăng hiệu suất hệ thống.
Khi thông tin được yêu cầu, hệ thống sẽ kiểm tra cache trước tiên - nếu
tìm thấy dữ liệu (cache hit), nó được trả về ngay lập tức; nếu không
(cache miss), hệ thống sẽ truy xuất dữ liệu từ nguồn chính, lưu vào
cache và trả về cho người dùng.

#image("images/2025-03-07-09-15-22.png")

Caching đóng vai trò then chốt trong việc cải thiện hiệu suất hệ thống
thông qua các cơ chế sau:

- #strong[Giảm độ trễ];: Truy cập dữ liệu từ cache nhanh hơn nhiều so
  với từ nguồn gốc (như cơ sở dữ liệu hoặc API từ xa).
- #strong[Giảm tải cho hệ thống];: Bằng cách lưu trữ dữ liệu tạm thời,
  cache giảm số lượng yêu cầu đến các hệ thống backend.
- #strong[Tăng khả năng mở rộng];: Cho phép hệ thống phục vụ nhiều người
  dùng hơn với cùng cơ sở hạ tầng.
- #strong[Tiết kiệm băng thông];: Giảm lượng dữ liệu cần truyền qua
  mạng.
- #strong[Tăng tính sẵn sàng];: Trong một số trường hợp, cache có thể
  cung cấp dữ liệu khi nguồn gốc không khả dụng.

Tuy nhiên, caching cũng mang đến những thách thức:

- #strong[Tính nhất quán dữ liệu];: Dữ liệu trong cache có thể trở nên
  lỗi thời so với nguồn chính.
- #strong[Phức tạp hóa kiến trúc];: Thêm một lớp cache làm tăng độ phức
  tạp của hệ thống.
- #strong[Chi phí bộ nhớ];: Cache sử dụng bộ nhớ quý giá, đòi hỏi phải
  cân nhắc giữa dung lượng cache và lợi ích mang lại.
- #strong[Làm trống cache];: Cần có chiến lược để loại bỏ dữ liệu khi
  cache đầy.
- #strong[Invalidation];: Cần có cơ chế để cập nhật hoặc vô hiệu hóa dữ
  liệu cache khi nguồn gốc thay đổi.

== Các pattern trong caching
<các-pattern-trong-caching>
=== Local cache
<local-cache>
Local cache lưu trữ dữ liệu trực tiếp trong bộ nhớ của ứng dụng, thường
trong cùng không gian địa chỉ với mã thực thi.

#image("images/2025-03-07-09-17-04.png")

#strong[Đặc điểm:]

- #strong[Truy cập cực nhanh];: Thời gian truy cập thấp do dữ liệu nằm
  trong bộ nhớ ứng dụng.
- #strong[Không có độ trễ mạng];: Truy cập không yêu cầu giao tiếp qua
  mạng.
- #strong[Đơn giản để triển khai];: Không cần cấu hình phức tạp hoặc
  dịch vụ bên ngoài.
- #strong[Giới hạn về quy mô];: Bị giới hạn bởi bộ nhớ của máy chủ đơn
  lẻ.
- #strong[Không chia sẻ giữa các instance];: Mỗi instance của ứng dụng
  duy trì cache riêng biệt.

#strong[Công nghệ phổ biến:]

- Guava Cache (Java)
- Caffeine (Java)
- LRUCache (nhiều ngôn ngữ)
- In-memory dictionaries/maps
- Ehcache (khi được cấu hình dưới dạng local cache)
- Spring Cache với `ConcurrentMapCacheManager`

#strong[Trường hợp sử dụng:]

- Dữ liệu tham chiếu ít thay đổi (như mã bưu điện, danh sách quốc gia)
- Kết quả tính toán tốn kém nhưng sử dụng thường xuyên
- Ứng dụng đơn lẻ không cần chia sẻ trạng thái với các instance khác
- Dữ liệu không nhạy cảm có thể được sao chép qua nhiều máy chủ

=== Distributed cache
<distributed-cache>
Distributed cache là một hệ thống cache được chia sẻ giữa nhiều máy chủ
hoặc instance ứng dụng, thường được triển khai dưới dạng dịch vụ riêng
biệt.

#image("images/2025-03-07-09-18-38.png")

#strong[Đặc điểm:]

- #strong[Chia sẻ dữ liệu];: Tất cả các instance ứng dụng truy cập cùng
  một cache.
- #strong[Khả năng mở rộng cao];: Có thể mở rộng độc lập với ứng dụng.
- #strong[Độ tin cậy cao];: Thường được triển khai với nhiều node để đảm
  bảo tính sẵn sàng cao.
- #strong[Độ trễ mạng];: Yêu cầu giao tiếp qua mạng để truy cập cache.
- #strong[Phân vùng và sao chép];: Hỗ trợ phân vùng dữ liệu và sao chép
  để cân bằng tải và khả năng chịu lỗi.
- #strong[Hỗ trợ nhiều ứng dụng];: Có thể phục vụ nhiều ứng dụng khác
  nhau đồng thời.

#strong[Công nghệ phổ biến:]

- Redis
- Memcached
- Hazelcast
- Apache Ignite
- Infinispan
- Ehcache (chế độ distributed)
- Amazon ElastiCache
- Azure Cache for Redis
- Google Cloud Memorystore

#strong[Trường hợp sử dụng:]

- Kiến trúc microservices cần chia sẻ dữ liệu
- Hệ thống có nhiều instance cần trạng thái nhất quán
- Quản lý phiên người dùng trong các ứng dụng web có nhiều máy chủ
- Kết quả truy vấn cơ sở dữ liệu được sử dụng trên nhiều dịch vụ
- Rate limiting và throttling trong kiến trúc phân tán
- Lưu trữ kết quả tính toán tốn kém có thể được sử dụng lại trên nhiều
  máy chủ

=== Reverse proxy cache
<reverse-proxy-cache>
Reverse proxy cache hoạt động như một trung gian giữa client và máy chủ
ứng dụng, lưu cache và phục vụ nội dung tĩnh hoặc động thay mặt cho máy
chủ nguồn.

#image("images/2025-03-07-09-21-38.png")

#strong[Đặc điểm:]

- #strong[Tách biệt];: Hoạt động như một lớp riêng biệt trước máy chủ
  ứng dụng.
- #strong[Trong suốt];: Client không biết họ đang giao tiếp với proxy
  thay vì máy chủ gốc.
- #strong[Tối ưu hóa HTTP];: Thường cung cấp các tính năng HTTP bổ sung
  như nén, SSL termination.
- #strong[Bộ nhớ đệm toàn bộ phản hồi];: Lưu trữ toàn bộ phản hồi HTTP,
  bao gồm header.
- #strong[Cache theo URL];: Thường sử dụng URL và HTTP header làm khóa
  cache.
- #strong[Kiểm soát tinh vi];: Hỗ trợ các chỉ thị cache-control HTTP
  tiêu chuẩn.

#strong[Công nghệ phổ biến:]

- Nginx
- Varnish
- Squid
- Apache Traffic Server
- HAProxy (có khả năng cache giới hạn)
- AWS CloudFront
- Cloudflare
- Akamai
- Fastly

#strong[Trường hợp sử dụng:]

- Phục vụ nội dung tĩnh (hình ảnh, CSS, JavaScript, tài liệu)
- Cache cho các trang web động ít thay đổi
- Giảm tải cho máy chủ ứng dụng trong các trang web có lưu lượng cao
- API Gateway với khả năng cache
- Mạng phân phối nội dung (CDN) tùy chỉnh
- Bảo vệ backend khỏi lưu lượng truy cập quá mức

=== Sidecar cache
<sidecar-cache>
Sidecar cache là một container hoặc process cache riêng biệt chạy cùng
với container/process ứng dụng chính trong kiến trúc microservices, tạo
thành một đơn vị triển khai duy nhất.

#image("images/2025-03-07-09-23-09.png")

#strong[Đặc điểm:]

- #strong[Colocation];: Chạy cùng với ứng dụng chính trên cùng một host.
- #strong[Kết nối cục bộ];: Giao tiếp với ứng dụng thông qua kết nối cục
  bộ tốc độ cao (localhost).
- #strong[Vòng đời chung];: Chia sẻ vòng đời với ứng dụng chính; được
  triển khai và dừng cùng nhau.
- #strong[Tách biệt về vùng nhớ và quá trình];: Chạy trong không gian xử
  lý riêng biệt.
- #strong[Per-instance];: Mỗi instance ứng dụng có sidecar cache riêng.
- #strong[Đóng gói công nghệ];: Cho phép ứng dụng và cache sử dụng công
  nghệ khác nhau.

#strong[Công nghệ phổ biến:]

- Redis container trong cùng một pod Kubernetes
- Memcached container cùng với container ứng dụng
- Envoy proxy với cấu hình cache
- NGINX sidecar với cấu hình cache
- Varnish sidecar
- Sidecar tùy chỉnh sử dụng nhớ đệm trong bộ nhớ

#strong[Trường hợp sử dụng:]

- Kiến trúc microservices với service mesh
- Caching layer cho API calls trong từng dịch vụ
- Tối ưu hóa truy cập cơ sở dữ liệu cho từng instance
- Giảm lưu lượng mạng trong môi trường Kubernetes
- Cải thiện tính cô lập và khả năng chịu lỗi của service
- Giảm độ trễ cho các yêu cầu thường xuyên mà không cần triển khai cache
  phân tán đầy đủ

=== Reverses proxy sidecar cache
<reverses-proxy-sidecar-cache>
Reverse proxy sidecar cache kết hợp các đặc điểm của reverse proxy cache
và sidecar cache, hoạt động như một proxy cache cục bộ chạy cùng với mỗi
instance ứng dụng.

#strong[Đặc điểm:]

- #strong[Instance cục bộ];: Mỗi instance ứng dụng có reverse proxy
  riêng.
- #strong[Định tuyến và cache];: Kết hợp định tuyến HTTP và khả năng
  cache.
- #strong[Phổ biến trong service mesh];: Thường thấy trong các triển
  khai service mesh.
- #strong[Nhiều tính năng proxy];: Cung cấp các tính năng proxy như SSL
  termination, compression, cân bằng tải.
- #strong[Lớp trừu tượng mạng];: Cung cấp lớp trừu tượng giữa ứng dụng
  và mạng bên ngoài.
- #strong[Khóa ứng dụng];: Có thể tùy chỉnh logic cache dựa trên ngữ
  cảnh ứng dụng.

#strong[Công nghệ phổ biến:]

- Envoy với cấu hình cache
- NGINX trong vai trò sidecar
- Varnish container cùng với container ứng dụng
- Traefik sidecar
- HAProxy sidecar
- Service mesh như Istio với cấu hình cache được kích hoạt

#strong[Trường hợp sử dụng:]

- Các triển khai service mesh phức tạp
- Microservices cần caching, circuit breaking, và các tính năng nâng cao
  khác
- Ứng dụng cần cache cục bộ nhưng vẫn muốn lợi ích của reverse proxy
- Khi việc cấu hình network policies phức tạp
- Caching giữa các dịch vụ trong cùng một cụm Kubernetes
- Các dịch vụ yêu cầu khả năng quan sát và điều khiển lưu lượng chi tiết

== Làm trống cache (Cache eviction)
<làm-trống-cache-cache-eviction>
Cache eviction là quá trình xóa dữ liệu khỏi cache để giải phóng không
gian cho dữ liệu mới. Đây là một khía cạnh quan trọng trong quản lý
cache hiệu quả.

=== Chiến lược Eviction
<chiến-lược-eviction>
+ #strong[Least Recently Used (LRU)]

  - Loại bỏ các mục được truy cập gần đây ít nhất
  - Duy trì thông tin về thời gian truy cập gần nhất cho mỗi mục
  - Hiệu quả khi dữ liệu có tính chất thời gian (temporal locality)
  - Được triển khai rộng rãi và dễ hiểu
  - Có thể không tối ưu cho các workload đặc biệt

+ #strong[Least Frequently Used (LFU)]

  - Loại bỏ các mục ít được truy cập nhất
  - Theo dõi số lần truy cập cho mỗi mục
  - Hiệu quả cho dữ liệu có biểu mẫu sử dụng ổn định
  - Có thể giữ các mục \"một lần nổi tiếng\" quá lâu
  - Thường kết hợp với yếu tố thời gian để tăng hiệu quả

+ #strong[First-In-First-Out (FIFO)]

  - Loại bỏ mục cũ nhất được thêm vào cache
  - Triển khai đơn giản (sử dụng queue)
  - Không xem xét mẫu truy cập
  - Có thể loại bỏ các mục được truy cập thường xuyên
  - Hữu ích cho các trường hợp đặc biệt với dữ liệu tạm thời

+ #strong[Time-To-Live (TTL)]

  - Loại bỏ các mục dựa trên thời gian tồn tại
  - Mỗi mục có \"hạn sử dụng\" xác định
  - Tốt cho dữ liệu có thể chấp nhận được độ mới nhất nhất định
  - Có thể tùy chỉnh TTL cho từng loại dữ liệu
  - Thường được kết hợp với các chiến lược khác

+ #strong[Random Replacement]

  - Loại bỏ ngẫu nhiên các mục khi cần không gian
  - Triển khai đơn giản nhất
  - Không cần theo dõi dữ liệu truy cập
  - Hiệu suất kém hơn so với các chiến lược có nhận thức
  - Có thể hữu ích khi chi phí tính toán của các thuật toán phức tạp hơn
    là quá cao

+ #strong[Size-Based]

  - Ưu tiên loại bỏ các mục lớn hơn
  - Tối đa hóa số lượng mục trong cache
  - Tốt cho cache với các mục có kích thước khác nhau đáng kể
  - Có thể loại bỏ các mục lớn nhưng được truy cập thường xuyên
  - Thường được kết hợp với các tiêu chí khác

+ #strong[Segmented LRU (SLRU)]

  - Chia cache thành phân đoạn \"protected\" và \"probationary\"
  - Các mục mới đi vào phân đoạn probationary
  - Các mục được truy cập lại được đưa vào phân đoạn protected
  - Cân bằng giữa các mục truy cập một lần và nhiều lần
  - Cải thiện hiệu suất LRU tiêu chuẩn cho nhiều workload

+ #strong[Adaptive Replacement Cache (ARC)]

  - Cân bằng động giữa recency (LRU) và frequency (LFU)
  - Duy trì hai danh sách LRU: cho các mục truy cập một lần và nhiều lần
  - Tự điều chỉnh dựa trên mẫu truy cập
  - Hiệu suất tốt trên nhiều loại workload
  - Phức tạp hơn để triển khai và duy trì

+ #strong[TinyLFU/Window-TinyLFU]

  - Sử dụng bộ lọc tần suất hiệu quả về bộ nhớ để theo dõi tần suất truy
    cập
  - Kết hợp window cache với main cache
  - Hiệu quả cho cả hit rate và hiệu suất bộ nhớ
  - Được sử dụng trong Caffeine cache (Java)
  - Cân bằng giữa hiệu suất và tiêu thụ bộ nhớ

+ #strong[CLOCK (Second-Chance)]

  - Xấp xỉ LRU với chi phí thấp hơn
  - Sử dụng bit tham chiếu và con trỏ \"đồng hồ\"
  - Không cần cấu trúc dữ liệu phức tạp
  - Được sử dụng trong nhiều hệ điều hành cho quản lý bộ nhớ ảo
  - Gần với LRU về hiệu suất với chi phí thấp hơn đáng kể

=== Các chiến lược đặc biệt và cân nhắc khi triển khai:
<các-chiến-lược-đặc-biệt-và-cân-nhắc-khi-triển-khai>
+ #strong[Proactive Eviction]

  - Xóa dữ liệu trước khi cache đầy
  - Có thể chạy như các tác vụ nền
  - Giảm độ trễ của các yêu cầu cache trong trường hợp xấu nhất
  - Phức tạp hơn về mặt triển khai

+ #strong[Background Refresh]

  - Cập nhật mục trong nền trước khi hết hạn
  - Giảm độ trễ đối với client
  - Thách thức với dữ liệu thay đổi thường xuyên
  - Yêu cầu tài nguyên hệ thống bổ sung

+ #strong[Pinned Entries]

  - Bảo vệ các mục quan trọng khỏi bị eviction
  - Đảm bảo dữ liệu quan trọng luôn có sẵn
  - Yêu cầu sự cân nhắc cẩn thận về những gì được ghim
  - Có thể giảm hiệu quả của cache nếu sử dụng quá mức

+ #strong[Group-Based Eviction]

  - Áp dụng các chính sách khác nhau cho các nhóm dữ liệu khác nhau
  - Cân bằng giữa các loại dữ liệu khác nhau
  - Có thể tối ưu hóa cho các mẫu sử dụng cụ thể
  - Cần phân loại dữ liệu hợp lý

+ #strong[Cost-Based Eviction]

  - Xem xét chi phí tính toán lại dữ liệu khi quyết định eviction
  - Giữ các mục tốn kém để tái tạo
  - Yêu cầu metadata bổ sung
  - Có thể tối đa hóa hiệu quả sử dụng cache

+ #strong[Machine Learning Based]

  - Sử dụng ML để dự đoán giá trị cache của các mục
  - Có thể thích ứng với các mẫu phức tạp
  - Đắt về mặt tính toán và phức tạp
  - Hiệu quả nhất cho các hệ thống quy mô lớn

== Các pattern truy cập trong caching
<các-pattern-truy-cập-trong-caching>
=== Cache-aside
<cache-aside>
Cache-aside (hay còn gọi là Lazy Loading) là một pattern trong đó ứng
dụng chịu trách nhiệm tương tác với cả cache và nguồn dữ liệu.

#image("images/2025-03-07-21-59-03.png")

#strong[Cách hoạt động:]

+ Ứng dụng tìm kiếm dữ liệu trong cache trước
+ Nếu dữ liệu được tìm thấy (cache hit), nó được trả về cho ứng dụng
+ Nếu dữ liệu không được tìm thấy (cache miss), ứng dụng:
  - Tải dữ liệu từ nguồn dữ liệu (database, API, v.v.)
  - Lưu dữ liệu vào cache
  - Trả về dữ liệu

#strong[Ưu điểm:]

- Chỉ cache dữ liệu thực sự được yêu cầu
- Cache không bị điền quá mức với dữ liệu không sử dụng
- Phù hợp với các ứng dụng có tỷ lệ đọc/ghi cao
- Đơn giản để triển khai và hiểu
- Phù hợp với các ứng dụng phía sau load balancer
- Kiểm soát dữ liệu cache ở cấp ứng dụng

#strong[Nhược điểm:]

- Cache miss dẫn đến hai chuyến đi riêng biệt (cache và nguồn dữ liệu)
- Có thể dẫn đến dữ liệu lỗi thời nếu không có chiến lược cập nhật cache
- Các truy vấn song song cho cùng dữ liệu có thể dẫn đến nhiều lần tải
  từ nguồn
- Cần logic triển khai trong mã ứng dụng
- Có nguy cơ Cache Stampede hoặc Thundering Herd khi nhiều yêu cầu đồng
  thời gặp cache miss

#strong[Trường hợp sử dụng:]

- Ứng dụng web có nhiều đọc hơn ghi
- Hệ thống với mẫu truy cập dữ liệu không đồng đều (một số dữ liệu được
  truy cập thường xuyên hơn nhiều)
- Khi toàn bộ bộ dữ liệu quá lớn để cache toàn bộ
- Các ứng dụng cần điều khiển trực tiếp về những gì được cache
- Khi dữ liệu có thể thay đổi từ nhiều nguồn khác nhau

#strong[Mã ví dụ (Python):]

```python
def get_user(user_id):
    # Tìm kiếm trong cache trước
    user = cache.get(f"user:{user_id}")
    if user is not None:
        return user
    
    # Cache miss - lấy từ database
    user = database.query(f"SELECT * FROM users WHERE id = {user_id}")
    
    # Lưu vào cache cho các yêu cầu trong tương lai
    cache.set(f"user:{user_id}", user, ttl=3600)  # TTL 1 giờ
    
    return user
```

#strong[Cải tiến phổ biến:]

- Sử dụng khóa phân tán để ngăn Thundering Herd
- Triển khai cơ chế invalidation cache khi dữ liệu thay đổi
- Sử dụng giá trị \"sentinel\" để xử lý cache miss thường xuyên
- Nén dữ liệu để giảm bộ nhớ cache sử dụng
- Thêm monitoring để theo dõi tỷ lệ cache hit/miss

=== Read-through
<read-through>
Read-through là một pattern caching trong đó thư viện hoặc dịch vụ cache
chịu trách nhiệm tải dữ liệu từ nguồn dữ liệu khi có cache miss.

#image("images/2025-03-07-21-59-38.png")

#strong[Cách hoạt động:]

+ Ứng dụng yêu cầu dữ liệu từ cache
+ Nếu dữ liệu có trong cache (cache hit), nó được trả về ngay lập tức
+ Nếu dữ liệu không có trong cache (cache miss):
  - Cache tự động gọi các hàm định trước để tải dữ liệu từ nguồn
  - Cache lưu trữ kết quả
  - Dữ liệu được trả về cho ứng dụng

#strong[Ưu điểm:]

- Trừu tượng hóa logic tải nguồn dữ liệu từ mã ứng dụng
- Đảm bảo mô hình tải nhất quán trên toàn ứng dụng
- Tránh Thundering Herd vì cache quản lý quá trình tải
- Cung cấp một quy trình đọc gọn gàng và đơn giản cho ứng dụng
- Dữ liệu được tải theo nhu cầu (lazy loading)
- Giảm mã trùng lặp trên nhiều dịch vụ

#strong[Nhược điểm:]

- Phức tạp hơn để triển khai so với Cache-aside
- Yêu cầu cấu hình cache với connectors/loaders
- Cache phải biết về nguồn dữ liệu
- Ít linh hoạt hơn cho các mẫu truy cập đặc biệt
- Không phải tất cả các giải pháp cache đều hỗ trợ Read-through

#strong[Trường hợp sử dụng:]

- Ứng dụng phân tán có nhất quán về truy cập dữ liệu
- Khi có nhu cầu trừu tượng hóa logic truy cập database từ mã
- Hệ thống với nhiều thành phần cần truy cập cùng một dữ liệu
- Khi bạn muốn tránh triển khai logic caching tùy chỉnh trong từng dịch
  vụ
- Khi tính nhất quán trong quản lý cache là ưu tiên hàng đầu

#strong[Công nghệ/Framework hỗ trợ:]

- Ehcache với CacheLoaders
- JCache (JSR-107) với CacheLoaders
- Redis với Redis Modules tùy chỉnh
- Coherence với CacheStore
- Hazelcast với MapLoader/MapStore
- Spring Cache với tích hợp CacheManager tùy chỉnh
- AWS DynamoDB Accelerator (DAX)

#strong[Mã ví dụ (Java với Spring):]

```java
@Component
public class UserCacheLoader implements CacheLoader<String, User> {
    @Autowired
    private UserRepository userRepository;
    
    @Override
    public User load(String userId) {
        // Cache tự động gọi phương thức này khi xảy ra cache miss
        return userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
    }
}

// Cấu hình cache
@Bean
public CacheManager cacheManager(UserCacheLoader userCacheLoader) {
    CaffeineCacheManager cacheManager = new CaffeineCacheManager("users");
    cacheManager.setCacheLoader(userCacheLoader);
    return cacheManager;
}

// Sử dụng trong dịch vụ
@Service
public class UserService {
    @Autowired
    private CacheManager cacheManager;
    
    public User getUser(String userId) {
        // Cache sẽ tự động tải từ database nếu cần
        return cacheManager.getCache("users").get(userId, User.class);
    }
}
```

=== Write-through
<write-through>
Write-through là một pattern caching trong đó mọi thao tác ghi dữ liệu
được thực hiện đồng thời vào cache và hệ thống lưu trữ chính.

#image("images/2025-03-07-21-59-53.png")

#strong[Cách hoạt động:]

+ Ứng dụng ghi dữ liệu vào cache
+ Cache ngay lập tức ghi dữ liệu này vào hệ thống lưu trữ chính
  (database)
+ Thao tác ghi chỉ được coi là hoàn tất khi cả hai quá trình ghi đều
  thành công
+ Cache và hệ thống lưu trữ chính luôn đồng bộ với nhau

#strong[Ưu điểm:]

- Đảm bảo tính nhất quán cao giữa cache và hệ thống lưu trữ chính
- Giảm thiểu nguy cơ mất dữ liệu khi cache gặp sự cố
- Đơn giản hóa quy trình khôi phục sau sự cố
- Phù hợp với các ứng dụng yêu cầu độ tin cậy cao về dữ liệu
- Không cần cơ chế xử lý dữ liệu bẩn (dirty data) phức tạp
- Hiệu quả trong hệ thống có tỷ lệ đọc cao hơn tỷ lệ ghi

#strong[Nhược điểm:]

- Hiệu suất ghi chậm hơn do phải chờ cả hai thao tác ghi hoàn tất
- Tăng độ trễ cho các thao tác ghi
- Phụ thuộc vào hiệu suất và độ tin cậy của hệ thống lưu trữ chính
- Tạo gánh nặng lớn cho database khi có nhiều thao tác ghi
- Không tối ưu cho các ứng dụng có tỷ lệ ghi cao

#strong[Trường hợp sử dụng:]

- Hệ thống tài chính hoặc ngân hàng yêu cầu độ tin cậy dữ liệu cao
- Ứng dụng không thể chấp nhận sự không nhất quán dữ liệu tạm thời
- Môi trường có khả năng khôi phục sau sự cố cao
- Hệ thống có tỷ lệ ghi thấp nhưng tỷ lệ đọc cao
- Khi việc mất dữ liệu được coi là không thể chấp nhận

#strong[Công nghệ/Framework hỗ trợ:]

- Ehcache với CacheWriters
- JCache (JSR-107) với CacheWriters
- Redis với cơ chế AOF (Append-Only File)
- Oracle Coherence với CacheStore
- Hazelcast với MapStore
- Spring Cache với hỗ trợ CacheWriter
- AWS ElastiCache với cấu hình đồng bộ hóa

#strong[Mã ví dụ (Java với Spring):]

```java
@Component
public class UserCacheWriter implements CacheWriter<String, User> {
    @Autowired
    private UserRepository userRepository;
    
    @Override
    public void write(String key, User value) {
        // Lưu dữ liệu vào database
        userRepository.save(value);
    }
    
    @Override
    public void delete(String key) {
        userRepository.deleteById(key);
    }
}

// Cấu hình cache
@Bean
public CacheManager cacheManager(UserCacheWriter userCacheWriter) {
    CaffeineCacheManager cacheManager = new CaffeineCacheManager("users");
    cacheManager.setCacheWriter(userCacheWriter);
    cacheManager.setWriteThrough(true);
    return cacheManager;
}

// Sử dụng trong dịch vụ
@Service
public class UserService {
    @Autowired
    private CacheManager cacheManager;
    
    public void updateUser(User user) {
        // Dữ liệu sẽ được ghi đồng thời vào cache và database
        Cache cache = cacheManager.getCache("users");
        cache.put(user.getId(), user);
    }
}
```

=== Write-back
<write-back>
Write-back là một pattern caching trong đó thao tác ghi chỉ được thực
hiện vào cache trước, sau đó mới được ghi vào hệ thống lưu trữ chính
theo lịch trình hoặc điều kiện nhất định.

#image("images/2025-03-07-22-00-39.png")

#strong[Cách hoạt động:]

+ Ứng dụng ghi dữ liệu vào cache
+ Cache đánh dấu dữ liệu là \"bẩn\" (dirty)
+ Thao tác ghi vào hệ thống lưu trữ chính được hoãn lại
+ Dữ liệu được ghi vào hệ thống lưu trữ chính theo:
  - Khoảng thời gian định kỳ
  - Số lượng mục bẩn vượt ngưỡng
  - Khi cache đầy và cần giải phóng
  - Khi cache shutdown hoặc theo yêu cầu đặc biệt

#strong[Ưu điểm:]

- Hiệu suất ghi nhanh hơn vì không phải chờ ghi vào hệ thống lưu trữ
  chính
- Giảm đáng kể tải cho database với mô hình ghi bùng nổ
- Tối ưu băng thông mạng và tài nguyên database
- Gom nhóm nhiều thao tác ghi thành các batch hiệu quả
- Hoạt động tốt trong môi trường có tỷ lệ ghi cao
- Tăng thông lượng ghi tổng thể của hệ thống

#strong[Nhược điểm:]

- Rủi ro mất dữ liệu nếu cache gặp sự cố trước khi ghi vào database
- Phức tạp hơn trong triển khai và quản lý
- Có thể gây ra dữ liệu không nhất quán tạm thời
- Cần cơ chế quản lý dữ liệu \"bẩn\" (dirty data)
- Phức tạp hơn khi khôi phục sau sự cố
- Khó khăn trong đảm bảo tính nhất quán dữ liệu trong hệ thống phân tán

#strong[Trường hợp sử dụng:]

- Ứng dụng có tỷ lệ ghi cao
- Hệ thống phân tích dữ liệu thời gian thực
- Các ứng dụng IoT với dữ liệu sensor tần suất cao
- Hệ thống xử lý log và metrics
- Khi hiệu suất ghi quan trọng hơn tính nhất quán tức thời
- Môi trường có thể chấp nhận mất dữ liệu ở mức độ nhất định

#strong[Công nghệ/Framework hỗ trợ:]

- Ehcache với write-behind configuration
- Hazelcast với MapStore và write-delay
- Oracle Coherence với write-behind CacheStore
- Redis với Lua scripts hoặc modules tùy chỉnh
- Apache Ignite với CacheWriteBehindStore
- Spring Cache với triển khai tùy chỉnh
- Microsoft AppFabric Caching với write-behind strategy

#strong[Mã ví dụ (Java với Hazelcast):]

```java
@Configuration
public class CacheConfig {
    @Bean
    public Config hazelcastConfig() {
        Config config = new Config();
        MapConfig mapConfig = new MapConfig("users");
        
        // Cấu hình write-behind
        MapStoreConfig mapStoreConfig = new MapStoreConfig();
        mapStoreConfig.setImplementation(new UserMapStore());
        mapStoreConfig.setWriteDelaySeconds(5); // Hoãn ghi 5 giây
        mapStoreConfig.setWriteBatchSize(100);  // Gom 100 thao tác ghi
        mapStoreConfig.setWriteCoalescing(true); // Gộp các thao tác ghi trên cùng khóa
        mapStoreConfig.setEnabled(true);
        mapStoreConfig.setWriteBehindEnabled(true);
        
        mapConfig.setMapStoreConfig(mapStoreConfig);
        config.addMapConfig(mapConfig);
        
        return config;
    }
}

// MapStore implementation
public class UserMapStore implements MapStore<String, User> {
    private UserRepository userRepository;
    
    public UserMapStore() {
        // Khởi tạo repository
        this.userRepository = SpringContextHolder.getBean(UserRepository.class);
    }
    
    @Override
    public void store(String key, User value) {
        // Được gọi khi write-behind được kích hoạt
        userRepository.save(value);
    }
    
    @Override
    public void storeAll(Map<String, User> map) {
        // Xử lý ghi batch
        userRepository.saveAll(map.values());
    }
    
    // Các phương thức khác của MapStore...
}

// Sử dụng trong dịch vụ
@Service
public class UserService {
    @Autowired
    private HazelcastInstance hazelcastInstance;
    
    public void updateUser(User user) {
        // Dữ liệu chỉ được ghi vào cache trước
        IMap<String, User> userMap = hazelcastInstance.getMap("users");
        userMap.put(user.getId(), user);
        // Write-behind sẽ tự động ghi vào database sau
    }
}
```
