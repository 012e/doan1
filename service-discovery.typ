= Service Discovery & API Gateway
<service-discovery--api-gateway>
== Phân loại Service Discovery
<phân-loại-service-discovery>
Service Discovery là quá trình xác định và định vị các dịch vụ
(services) trong một môi trường phân tán. Có hai phương pháp tiếp cận
chính:

=== 1. Client-side Discovery
<1-client-side-discovery>
Trong mô hình này, client chịu trách nhiệm xác định vị trí của service.
Client truy vấn một service registry, nhận thông tin về các instance
đang chạy, sau đó sử dụng thuật toán cân bằng tải để chọn ra instance
phù hợp.

#image("images/2025-03-07-22-07-26.png")

#strong[Ưu điểm:]

- Client có kiểm soát tốt hơn về thuật toán cân bằng tải
- Giảm lớp trung gian giúp giảm độ trễ
- Client có thể thực hiện các quyết định thông minh dựa trên trạng thái
  cục bộ

#strong[Nhược điểm:]

- Tăng độ phức tạp cho client
- Client phải triển khai logic service discovery cho mỗi ngôn
  ngữ/framework
- Client phải xử lý các trường hợp khi service không khả dụng

=== 2. Server-side Discovery
<2-server-side-discovery>
Trong mô hình này, client gửi yêu cầu đến một thành phần trung gian
(load balancer hoặc router), thành phần này sẽ tìm kiếm service registry
và chuyển tiếp yêu cầu đến instance thích hợp.

#image("images/2025-03-07-22-08-02.png")

#strong[Ưu điểm:]

- Tách biệt logic discovery khỏi client
- Client đơn giản hơn, không cần biết về cơ chế discovery
- Dễ triển khai đồng nhất trong nhiều nền tảng

#strong[Nhược điểm:]

- Thêm thành phần có thể trở thành điểm lỗi
- Có thể tăng độ trễ do thêm một lớp trung gian
- Cần thiết lập và quản lý thêm thành phần

== Phân loại hình thức register
<phân-loại-hình-thức-register>
Để các dịch vụ có thể được khám phá, chúng cần được đăng ký (register)
vào một service registry. Có các hình thức đăng ký như sau:

=== Self-registration
<1-self-registration>
Trong mô hình này, mỗi service instance tự chịu trách nhiệm đăng ký
thông tin của mình vào service registry khi khởi động và hủy đăng ký khi
tắt.

#image("images/2025-03-07-22-08-19.png")

- #strong[Ưu điểm:]
  - Kiến trúc phi tập trung
  - Service chủ động quản lý vòng đời của mình
  - Không cần thành phần quản lý bên ngoài

- #strong[Nhược điểm:]
  - Tăng độ phức tạp của service
  - Yêu cầu logic đăng ký phải được triển khai trong mỗi service
  - Có thể gặp vấn đề khi service bị crash mà không thực hiện được việc
    hủy đăng ký

=== Third-party Registration
<2-third-party-registration>
Trong mô hình này, một thành phần riêng biệt gọi là service registrar
theo dõi các service instance và cập nhật thông tin vào service
registry.

#image("images/2025-03-07-22-08-27.png")

#strong[Ưu điểm:]

- Đơn giản hóa các service, giúp chúng tập trung vào nhiệm vụ chính
- Xử lý tốt các trường hợp service crash
- Cung cấp cơ chế đăng ký nhất quán

#strong[Nhược điểm:]

- Thêm thành phần cần được triển khai và duy trì
- Có thể trở thành điểm lỗi duy nhất
- Có thể có độ trễ trong việc phát hiện thay đổi trạng thái của service

=== Infrastructure-based Registration
<3-infrastructure-based-registration>
Nhiều nền tảng cloud và container orchestration (như Kubernetes) cung
cấp cơ chế đăng ký tích hợp.

#strong[Ưu điểm:]

- Tích hợp sẵn với hạ tầng
- Không cần code đặc biệt trong service
- Kết hợp chặt chẽ với các cơ chế quản lý vòng đời

#strong[Nhược điểm:]

- Phụ thuộc vào nền tảng cụ thể
- Có thể khó khăn khi chuyển đổi giữa các nền tảng
- Khả năng tùy biến có thể bị hạn chế

== Sử dụng Service
<sử-dụng-service>
Sau khi đã thiết lập Service Discovery, có nhiều cách để client sử dụng
các service. Ba phương pháp chính là:

=== Direct
<direct>
Trong mô hình Direct, client giao tiếp trực tiếp với các service sau khi
đã xác định vị trí của chúng thông qua Service Discovery.

#strong[Quy trình:]

+ Client truy vấn service registry để tìm vị trí của service
+ Client kết nối trực tiếp đến service instance
+ Client xử lý các vấn đề về tính khả dụng, retry logic, và cân bằng tải

#strong[Ưu điểm:]

- Đơn giản về mặt kiến trúc
- Giảm độ trễ do không có thành phần trung gian
- Phù hợp cho các ứng dụng có yêu cầu hiệu suất cao

#strong[Nhược điểm:]

- Client phải xử lý nhiều chi tiết phức tạp
- Khó đảm bảo tính nhất quán giữa các client khác nhau
- Khó áp dụng các chính sách chung như bảo mật, giám sát

=== Composite UI
<composite-ui>
Mô hình Composite UI (hay còn gọi là API Composition) tập trung vào việc
tổng hợp dữ liệu từ nhiều service để hiển thị trong giao diện người
dùng.

#strong[Quy trình:]

+ UI layer gọi đến nhiều service khác nhau
+ Tổng hợp kết quả từ các service
+ Chuyển đổi và hiển thị dữ liệu cho người dùng

#strong[Ưu điểm:]

- Giao diện người dùng thống nhất mặc dù dữ liệu từ nhiều service
- Giảm số lượng yêu cầu từ client đến server
- Có thể tối ưu hóa dữ liệu cho từng trường hợp sử dụng cụ thể

#strong[Nhược điểm:]

- Tăng độ phức tạp trong UI layer
- Có thể gây ra vấn đề hiệu suất khi phải gọi nhiều service
- Phức tạp trong việc xử lý lỗi khi một số service không khả dụng

=== API Gateway
<api-gateway>
API Gateway đóng vai trò cổng vào duy nhất cho tất cả các yêu cầu từ
client và sau đó chuyển tiếp đến các service thích hợp.

#strong[Chức năng chính:]

- Định tuyến yêu cầu đến service phù hợp
- Tổng hợp dữ liệu từ nhiều service
- Xử lý các vấn đề chéo như xác thực, cân bằng tải, giám sát

#strong[Ưu điểm:]

- Ẩn đi sự phức tạp của hệ thống microservices
- Cung cấp API được tối ưu hóa cho các client khác nhau
- Tập trung xử lý các vấn đề chéo, giúp service tập trung vào business
  logic

#strong[Nhược điểm:]

- Có thể trở thành điểm nghẽn và điểm lỗi duy nhất
- Thêm độ trễ do thêm một lớp trung gian
- Cần được thiết kế cẩn thận để đảm bảo hiệu suất và khả năng mở rộng

== Envoy
<envoy>
=== Giới thiệu
<giới-thiệu>
Envoy là một proxy mã nguồn mở, được thiết kế đặc biệt cho các ứng dụng
dạng cloud-native và microservices. Được phát triển ban đầu bởi Lyft và
hiện là một dự án tốt nghiệp của Cloud Native Computing Foundation
(CNCF).

#strong[Đặc điểm nổi bật:]

- Proxy Layer 7 (HTTP, gRPC, MongoDB, Redis...)
- Tích hợp trực tiếp với Service Discovery
- Cân bằng tải thông minh
- Hỗ trợ các tính năng như circuit breaking, rate limiting, tracing
- Cấu hình động thông qua API
- Xây dựng trên C++ với hiệu suất cao

Envoy thường được triển khai theo mô hình sidecar trong Service Mesh,
hoặc như một Edge Proxy/API Gateway.

=== Kiến trúc
<kiến-trúc>
Kiến trúc của Envoy bao gồm các thành phần chính sau:

==== Listeners
<1-listeners>
Listeners là các điểm đầu vào mạng (network sockets) mà Envoy lắng nghe.
Mỗi listener có thể được cấu hình với các bộ lọc (filters) để xử lý
traffic.

#strong[Loại Listeners:]

- #strong[TCP Listeners];: Xử lý kết nối TCP thuần túy
- #strong[HTTP Listeners];: Xử lý traffic HTTP/1.x, HTTP/2, gRPC

==== Filters
<2-filters>
Filters tạo nên pipeline xử lý yêu cầu trong Envoy. Có hai loại filters
chính:

- #strong[Network Filters];: Hoạt động ở lớp L3/L4 (TCP), xử lý raw
  bytes và kết nối
- #strong[HTTP Filters];: Hoạt động ở lớp L7, xử lý HTTP
  request/response

Các filters phổ biến bao gồm:

- Router filter: Chuyển tiếp yêu cầu HTTP đến upstream cluster
- Rate limit filter: Giới hạn số lượng request
- JWT authentication filter: Xác thực JWT token
- CORS filter: Xử lý Cross-Origin Resource Sharing

==== Clusters
<3-clusters>
Clusters là nhóm các endpoints cung cấp cùng một service. Envoy sử dụng
các thông tin về cluster để quyết định nơi định tuyến yêu cầu.

#strong[Cấu hình Cluster bao gồm:]

- Phương thức khám phá service (static, DNS, EDS)
- Thuật toán cân bằng tải (round robin, least request, ring hash...)
- Cấu hình health checking
- Circuit breaking thresholds
- Timeout và retry policies

==== Endpoints
<4-endpoints>
Endpoints là các instance cụ thể trong một cluster. Một endpoint thường
là một địa chỉ IP và port.

==== Routes
<5-routes>
Routes định nghĩa cách Envoy khớp yêu cầu HTTP với cluster phù hợp.
Routes có thể được cấu hình dựa trên:

- Path prefix hoặc exact match
- HTTP headers
- Query parameters
- HTTP method

==== Dynamic Configuration
<6-dynamic-configuration>
Envoy hỗ trợ xAPI (xDS) - một tập các APIs để cấu hình động:

- LDS (Listener Discovery Service)
- RDS (Route Discovery Service)
- CDS (Cluster Discovery Service)
- EDS (Endpoint Discovery Service)
- SDS (Secret Discovery Service)

Điều này cho phép Envoy cập nhật cấu hình mà không cần khởi động lại.

==== Observability
<7-observability>
Envoy cung cấp khả năng quan sát mạnh mẽ:

- Thống kê chi tiết về traffic
- Distributed tracing (OpenTracing, Zipkin, Jaeger)
- Access logging
- Admin interface cho giám sát và debug
