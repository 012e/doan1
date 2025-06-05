= Microservices
<microservices>
== Tổng quan về microservices
<tổng-quan-về-microservices>
=== Định nghĩa và khái niệm cơ bản
<định-nghĩa-và-khái-niệm-cơ-bản>
Microservices là một phương pháp phát triển phần mềm và kiến trúc trong
đó ứng dụng được xây dựng dưới dạng một tập hợp các dịch vụ nhỏ, độc lập
và tập trung vào nghiệp vụ cụ thể. Mỗi dịch vụ hoạt động trong quá trình
riêng biệt và giao tiếp thông qua các cơ chế nhẹ, thường là API dựa trên
HTTP. Các dịch vụ này được xây dựng xung quanh các khả năng kinh doanh
và có thể được triển khai độc lập bởi các nhóm nhỏ, tự quản lý.

#image("images/2025-03-07-22-01-46.png")

=== Sự phát triển của microservices
<sự-phát-triển-của-microservices>
Microservices xuất hiện như một phản ứng đối với những hạn chế của kiến
trúc nguyên khối truyền thống. Khái niệm này bắt đầu phổ biến vào khoảng
năm 2010-2012, với những doanh nghiệp lớn như Netflix, Amazon và eBay
dẫn đầu trong việc áp dụng phương pháp này. Martin Fowler và James Lewis
đã chính thức hóa khái niệm này trong bài báo nổi tiếng của họ vào năm
2014, giúp phổ biến phương pháp này rộng rãi hơn trong cộng đồng phát
triển phần mềm.

=== Đặc điểm chính của microservices
<đặc-điểm-chính-của-microservices>
+ #strong[Tự chứa và độc lập];: Mỗi microservice có thể được phát triển,
  triển khai, vận hành và mở rộng mà không ảnh hưởng đến các dịch vụ
  khác.
+ #strong[Tổ chức xung quanh khả năng kinh doanh];: Các nhóm chịu trách
  nhiệm phát triển và duy trì các dịch vụ cụ thể từ đầu đến cuối.
+ #strong[Phân cấp và phi tập trung];: Kiến trúc microservices khuyến
  khích quản lý phi tập trung và phân cấp trong việc ra quyết định.
+ #strong[Đa dạng công nghệ];: Các nhóm có thể chọn công nghệ phù hợp
  nhất cho từng dịch vụ.
+ #strong[Tự động hóa cơ sở hạ tầng];: Microservices thường đòi hỏi
  triển khai tự động và CI/CD để quản lý hiệu quả nhiều dịch vụ.
+ #strong[Khả năng chịu lỗi];: Các dịch vụ được thiết kế để chịu đựng sự
  cố của các dịch vụ khác.
+ #strong[Quản lý dữ liệu phi tập trung];: Mỗi dịch vụ quản lý cơ sở dữ
  liệu riêng, có thể sử dụng các loại cơ sở dữ liệu khác nhau tùy thuộc
  vào nhu cầu.

=== So sánh với kiến trúc nguyên khối
<so-sánh-với-kiến-trúc-nguyên-khối>
#figure(
  align(center)[#table(
    columns: 3,
    table.header([Khía cạnh], [Kiến trúc nguyên khối], [Kiến trúc
      Microservices],),
    table.hline(),
    [Cấu trúc], [Một ứng dụng duy nhất, đơn vị], [Nhiều dịch vụ nhỏ,
    phân tán],
    [Phát triển], [Một codebase duy nhất], [Nhiều codebase riêng biệt],
    [Triển khai], [Triển khai toàn bộ ứng dụng], [Triển khai từng dịch
    vụ độc lập],
    [Quy mô], [Mở rộng toàn bộ ứng dụng], [Mở rộng từng dịch vụ theo nhu
    cầu],
    [Công nghệ], [Thường chỉ sử dụng một stack công nghệ], [Có thể sử
    dụng nhiều công nghệ khác nhau],
    [Khả năng chịu lỗi], [Một điểm lỗi có thể làm sập toàn bộ ứng
    dụng], [Các dịch vụ có thể gặp sự cố một cách độc lập],
    [Đội phát triển], [Thường là một đội lớn], [Nhiều đội nhỏ tập trung
    vào từng dịch vụ],
    [Dữ liệu], [Cơ sở dữ liệu tập trung], [Cơ sở dữ liệu phân tán theo
    dịch vụ],
  )]
  , kind: table
  )

=== Nguyên tắc thiết kế microservices
<nguyên-tắc-thiết-kế-microservices>
+ #strong[Nguyên tắc trách nhiệm đơn lẻ];: Mỗi dịch vụ chỉ nên tập trung
  vào một chức năng nghiệp vụ cụ thể.
+ #strong[Nguyên tắc ranh giới miền];: Dựa trên Domain-Driven Design
  (DDD) để xác định ranh giới của từng dịch vụ.
+ #strong[Thiết kế API đầu tiên];: Phát triển API trước khi triển khai
  dịch vụ.
+ #strong[Dữ liệu riêng tư];: Mỗi dịch vụ quản lý dữ liệu riêng và không
  được truy cập trực tiếp vào dữ liệu của dịch vụ khác.
+ #strong[Thiết kế hướng sự kiện];: Sử dụng các sự kiện để truyền thông
  tin giữa các dịch vụ.
+ #strong[Thiết kế hướng thất bại];: Dịch vụ phải được thiết kế để xử lý
  khi các dịch vụ khác không hoạt động.
+ #strong[Tự động hóa];: Tự động hóa triển khai, giám sát và kiểm tra.

=== Các mẫu thiết kế phổ biến trong microservices
<các-mẫu-thiết-kế-phổ-biến-trong-microservices>
+ #strong[API Gateway];: Cung cấp một điểm truy cập duy nhất cho các
  client.
+ #strong[Circuit Breaker];: Ngăn chặn lỗi lan truyền khi dịch vụ gặp sự
  cố.
+ #strong[CQRS (Command Query Responsibility Segregation)];: Tách biệt
  các thao tác đọc và ghi.
+ #strong[Saga];: Quản lý giao dịch phân tán giữa nhiều dịch vụ.
+ #strong[Event Sourcing];: Lưu trữ thay đổi trạng thái dưới dạng chuỗi
  các sự kiện.
+ #strong[Bulkhead];: Cô lập các thành phần để ngăn chặn lỗi lan truyền.
+ #strong[Sidecar];: Triển khai các chức năng phụ trợ bên cạnh dịch vụ
  chính.
+ #strong[Strangler Fig Pattern];: Chiến lược chuyển đổi dần dần từ hệ
  thống nguyên khối sang microservices.

== Phương thức giao tiếp giữa các microservices
<phương-thức-giao-tiếp-giữa-các-microservices>
=== Mô hình giao tiếp đồng bộ
<mô-hình-giao-tiếp-đồng-bộ>
+ #strong[REST (Representational State Transfer)]

  - Dựa trên HTTP và các nguyên tắc kiến trúc web
  - Dễ hiểu và triển khai, phổ biến rộng rãi
  - Sử dụng phương thức HTTP (GET, POST, PUT, DELETE) và mã trạng thái
  - Định dạng dữ liệu thường là JSON hoặc XML
  - Ví dụ thực tế: API RESTful được sử dụng bởi Twitter, Facebook và
    nhiều dịch vụ web khác

+ #strong[GraphQL]

  - Ngôn ngữ truy vấn cho API do Facebook phát triển
  - Cho phép client xác định chính xác dữ liệu cần thiết
  - Giảm thiểu vấn đề lấy dữ liệu quá mức hoặc thiếu dữ liệu
  - Một điểm cuối duy nhất xử lý tất cả các truy vấn
  - Ví dụ thực tế: GitHub, Shopify, và Pinterest sử dụng GraphQL cho API
    của họ

+ #strong[gRPC]

  - RPC (Remote Procedure Call) hiệu suất cao do Google phát triển
  - Sử dụng Protocol Buffers làm ngôn ngữ định nghĩa giao diện
  - Hỗ trợ giao tiếp song công toàn phần (full-duplex) qua HTTP/2
  - Hiệu quả cho giao tiếp giữa các dịch vụ nội bộ
  - Ví dụ thực tế: Google Cloud, Netflix, và Cisco sử dụng gRPC trong
    nội bộ

=== Mô hình giao tiếp bất đồng bộ

==== Message Queuing

#strong[Message Queuing] là một cơ chế giao tiếp #strong[không đồng bộ]
giữa các thành phần phần mềm, trong đó các #strong[thông điệp] được gửi
vào một #strong[hàng đợi trung gian] và được xử lý khi có tài nguyên sẵn
sàng. Nó giúp #strong[tách biệt] giữa #strong[producer] (bên gửi) và
#strong[consumer] (bên nhận), đảm bảo hệ thống hoạt động ổn định ngay cả
khi một số thành phần bị gián đoạn. #strong[Message Queuing] thường được
sử dụng để #strong[cải thiện hiệu suất, tăng khả năng mở rộng và đảm bảo
độ tin cậy] trong các hệ thống phân tán.


#image("images/2025-03-07-22-03-13.png")

- Sử dụng hàng đợi tin nhắn như RabbitMQ, ActiveMQ
- Tin nhắn được lưu trữ tạm thời cho đến khi được xử lý
- Mô hình giao tiếp point-to-point
- Đảm bảo tin nhắn được xử lý chính xác một lần
- Ví dụ thực tế: Nhiều hệ thống thanh toán và xử lý đơn hàng sử dụng
  RabbitMQ

==== Publish/Subscribe (Pub/Sub)
#strong[Publish/Subscribe (Pub/Sub)] là một mô hình giao tiếp
#strong[không đồng bộ] trong đó #strong[publisher] (bên phát) gửi thông
điệp đến một #strong[kênh chung] mà không cần biết ai sẽ nhận.
#strong[Subscriber] (bên nhận) đăng ký vào kênh để nhận thông điệp phù
hợp. Các thông điệp được gửi #strong[một lần] và có thể được nhận bởi
#strong[nhiều subscriber] cùng lúc. Mô hình này giúp hệ thống
#strong[tách biệt] giữa bên phát và bên nhận, #strong[tăng khả năng mở
rộng] và #strong[giảm phụ thuộc trực tiếp] giữa các thành phần.

#image("images/2025-03-07-22-04-19.png")

- Một nhà sản xuất gửi tin nhắn đến nhiều người tiêu dùng
- Thường sử dụng các nền tảng như Kafka, Google Pub/Sub
- Mô hình giao tiếp một-đến-nhiều
- Phù hợp cho các sự kiện cần được xử lý bởi nhiều dịch vụ
- Ví dụ thực tế: Netflix sử dụng Kafka để xử lý luồng dữ liệu thời
  gian thực

==== Event Streaming
#strong[Event Streaming] là một mô hình xử lý dữ liệu #strong[theo luồng
sự kiện];, trong đó các sự kiện được tạo ra, lưu trữ, xử lý và tiêu thụ
#strong[liên tục theo thời gian thực];. Dữ liệu được ghi vào một
#strong[log sự kiện] và có thể được nhiều hệ thống tiêu thụ theo nhu
cầu. Event Streaming giúp #strong[xử lý dữ liệu liên tục];, #strong[tăng
khả năng mở rộng];, #strong[cải thiện hiệu suất] và hỗ trợ #strong[kiến
trúc hướng sự kiện] trong các hệ thống phân tán.

  - Xử lý luồng liên tục các sự kiện
  - Thường triển khai bằng Apache Kafka hoặc AWS Kinesis
  - Lưu trữ sự kiện lâu dài và cho phép phát lại
  - Phù hợp cho phân tích dữ liệu thời gian thực và xử lý sự kiện
  - Ví dụ thực tế: LinkedIn sử dụng Kafka cho hệ thống xử lý dữ liệu
    thời gian thực

=== Các giao thức giao tiếp
<các-giao-thức-giao-tiếp>
+ #strong[HTTP/HTTPS]

  - Giao thức phổ biến nhất cho giao tiếp microservice
  - Đơn giản, được hiểu rộng rãi, và hỗ trợ tốt
  - Stateless và có thể cache
  - Phù hợp với REST và GraphQL

+ #strong[WebSocket]

  - Giao thức giao tiếp hai chiều full-duplex
  - Duy trì kết nối mở giữa client và server
  - Lý tưởng cho ứng dụng thời gian thực
  - Sử dụng trong các ứng dụng chat, trò chơi trực tuyến, và bảng điều
    khiển thời gian thực

+ #strong[AMQP (Advanced Message Queuing Protocol)]

  - Giao thức chuẩn cho nhắn tin doanh nghiệp
  - Hỗ trợ giao tiếp bất đồng bộ đáng tin cậy
  - Sử dụng bởi RabbitMQ và các hệ thống nhắn tin khác
  - Đảm bảo tin nhắn được gửi và nhận đúng cách

+ #strong[MQTT (Message Queuing Telemetry Transport)]

  - Giao thức nhẹ cho các thiết bị IoT và di động
  - Tối ưu hóa cho mạng không đáng tin cậy hoặc độ trễ cao
  - Mô hình pub/sub với mức QoS khác nhau
  - Phổ biến trong IoT và ứng dụng di động

=== Mẫu thiết kế giao tiếp trong microservices
<mẫu-thiết-kế-giao-tiếp-trong-microservices>
+ #strong[API Gateway/Backend for Frontend (BFF)]

  - Điểm vào duy nhất để giao tiếp với nhiều microservices
  - Xử lý định tuyến, tổng hợp phản hồi, và chuyển đổi giao thức
  - Có thể thực hiện chứng thực, ủy quyền, và giới hạn tốc độ
  - Ví dụ: Kong, AWS API Gateway, Netflix Zuul

+ #strong[Service Mesh]

  - Lớp cơ sở hạ tầng chuyên dụng cho giao tiếp dịch vụ-đến-dịch vụ
  - Xử lý khám phá dịch vụ, cân bằng tải, và theo dõi
  - Triển khai mẫu sidecar với proxy nhẹ bên cạnh mỗi dịch vụ
  - Ví dụ: Istio, Linkerd, Consul Connect

+ #strong[Saga Pattern]

  - Quản lý giao dịch phân tán giữa nhiều microservices
  - Duy trì tính nhất quán dữ liệu trong kiến trúc phân tán
  - Thực hiện thông qua điều phối hoặc điều khiển
  - Sử dụng bước bồi thường để xử lý lỗi

+ #strong[Event-Driven Architecture (EDA)]

  - Microservices giao tiếp thông qua sự kiện được phát
  - Giảm sự ghép nối giữa các dịch vụ
  - Sử dụng nhà môi giới sự kiện (event broker) để điều phối
  - Cho phép mở rộng dễ dàng với các người tiêu thụ sự kiện mới

== Khuyết điểm của microservices
<khuyết-điểm-của-microservices>

=== Thách thức về độ phức tạp
<thách-thức-về-độ-phức-tạp>
+ #strong[Độ phức tạp phân tán]

  - Hệ thống phân tán vốn phức tạp hơn hệ thống nguyên khối
  - Nhiều thành phần di chuyển và tương tác với nhau
  - Khó khăn trong việc hiểu toàn bộ hệ thống
  - Cần kiến thức chuyên sâu về thiết kế phân tán

+ #strong[Khó khăn trong debug và trace]

  - Một yêu cầu có thể đi qua nhiều dịch vụ
  - Khó khăn trong việc theo dõi và hiểu quy trình đầy đủ
  - Cần những công cụ truy tìm phân tán như Jaeger, Zipkin
  - Phân tích nguyên nhân gốc rễ có thể phức tạp

+ #strong[Phức tạp hóa triển khai]

  - Quản lý triển khai của hàng chục hoặc hàng trăm dịch vụ
  - Cần tự động hóa và quy trình CI/CD mạnh mẽ
  - Hỗ trợ cập nhật liên tục và phát hành từng phần
  - Cân nhắc khả năng tương thích ngược trong các bản cập nhật API

+ #strong[Tăng phức tạp cơ sở hạ tầng]

  - Quản lý nhiều cơ sở dữ liệu, hàng đợi, và dịch vụ
  - Nhu cầu về điều phối container (Kubernetes, Docker Swarm)
  - Giám sát và quản lý cơ sở hạ tầng phân tán
  - Tăng tiêu hao tài nguyên do nhiều dịch vụ độc lập

=== Vấn đề về hiệu suất
<vấn-đề-về-hiệu-suất>
+ #strong[Độ trễ mạng]

  - Giao tiếp giữa các dịch vụ phải đi qua mạng
  - Mỗi cuộc gọi API thêm độ trễ
  - Các chuỗi yêu cầu dài có thể dẫn đến hiệu suất kém
  - Các thao tác tổng hợp dữ liệu trở nên tốn kém hơn

+ #strong[Tải mạng]

  - Tăng lưu lượng mạng giữa các dịch vụ
  - Chuyển dữ liệu qua mạng tiêu tốn băng thông
  - Định dạng dữ liệu như JSON có thể không hiệu quả
  - Có thể cần cân nhắc giữa khả năng đọc và hiệu quả

+ #strong[Tài nguyên hệ thống bị trùng lặp]

  - Mỗi dịch vụ có container hoặc VM riêng
  - Mỗi dịch vụ yêu cầu bộ nhớ, CPU, và các tài nguyên hệ thống khác
  - Tiêu tốn nhiều tài nguyên hơn so với ứng dụng nguyên khối
  - Chi phí cơ sở hạ tầng cao hơn

+ #strong[Vấn đề về quy mô]

  - Khó khăn trong việc cân bằng tài nguyên giữa các dịch vụ
  - Hiệu suất không nhất quán giữa các thành phần
  - Tăng chi phí giám sát và quản lý
  - Có thể cần nhiều nỗ lực tối ưu hóa hơn so với ứng dụng nguyên khối

=== Thách thức về tính nhất quán dữ liệu
<thách-thức-về-tính-nhất-quán-dữ-liệu>
+ #strong[Dữ liệu phân tán]

  - Dữ liệu được phân phối giữa nhiều dịch vụ
  - Mỗi dịch vụ có cơ sở dữ liệu riêng (pattern database-per-service)
  - Khó duy trì tính nhất quán trong giao dịch trải rộng trên nhiều dịch
    vụ
  - Phải chấp nhận tính nhất quán cuối cùng (eventual consistency)

+ #strong[Thiếu giao dịch ACID]

  - Không thể sử dụng giao dịch ACID truyền thống giữa các dịch vụ
  - Phải sử dụng mẫu Saga hoặc các cơ chế bồi thường
  - Tăng độ phức tạp cho logic nghiệp vụ
  - Khó xử lý các trường hợp lỗi một phần

+ #strong[Thách thức trong truy vấn phân tán]

  - Dữ liệu liên quan có thể trải rộng trên nhiều dịch vụ
  - Các truy vấn tổng hợp trở nên phức tạp
  - Có thể cần API composition hoặc CQRS
  - Giảm hiệu suất cho các truy vấn phức tạp

+ #strong[Đồng bộ hóa dữ liệu]

  - Duy trì dữ liệu nhất quán giữa các dịch vụ
  - Xử lý sự cố không thành công trong quá trình đồng bộ
  - Xử lý xung đột và giải quyết xung đột
  - Thử thách trong việc duy trì tính toàn vẹn tham chiếu

=== Thách thức về tổ chức và quản lý
<thách-thức-về-tổ-chức-và-quản-lý>
+ #strong[Yêu cầu kỹ năng kỹ thuật cao]

  - Cần các kỹ sư có kinh nghiệm về hệ thống phân tán
  - Đòi hỏi hiểu biết sâu về DevOps và tự động hóa
  - Cần kỹ năng quản lý cơ sở dữ liệu phân tán
  - Thách thức trong việc tuyển dụng nhân tài phù hợp

+ #strong[Thách thức tổ chức và đội nhóm]

  - Yêu cầu tái cấu trúc đội ngũ phát triển
  - Phân chia trách nhiệm giữa các nhóm
  - Cần giao tiếp hiệu quả giữa các nhóm
  - Có thể dẫn đến sự chồng chéo hoặc xung đột

+ #strong[Chi phí vận hành cao hơn]

  - Tăng chi phí giám sát và quản lý
  - Cần nhiều công cụ và nền tảng hơn
  - Tăng chi phí cơ sở hạ tầng
  - Đòi hỏi đầu tư vào tự động hóa và công cụ

+ #strong[Phức tạp trong quản lý phiên bản và API]

  - Quản lý phiên bản và khả năng tương thích của nhiều API
  - Xử lý thay đổi API và tác động của chúng
  - Cân nhắc chiến lược phát triển và phiên bản
  - Cần quản lý contract giữa các dịch vụ

=== Thách thức về bảo mật
<thách-thức-về-bảo-mật>
+ #strong[Tăng bề mặt tấn công]

  - Nhiều điểm cuối dịch vụ đồng nghĩa với nhiều điểm tấn công tiềm năng
  - Nhiều kênh giao tiếp mạng cần được bảo mật
  - Nhiều dịch vụ để theo dõi các lỗ hổng
  - Cần chiến lược bảo mật toàn diện hơn

+ #strong[Phức tạp hóa xác thực và ủy quyền]

  - Quản lý danh tính giữa nhiều dịch vụ
  - Triển khai OAuth, JWT, hoặc các giải pháp SSO
  - Truyền thông tin xác thực an toàn giữa các dịch vụ
  - Duy trì mô hình bảo mật nhất quán

+ #strong[Bảo mật mạng phức tạp]

  - Quản lý mạng zero-trust giữa các dịch vụ
  - Thiết lập mã hóa TLS cho tất cả giao tiếp
  - Triển khai phân đoạn mạng và chính sách
  - Giám sát lưu lượng dịch vụ-đến-dịch vụ

+ #strong[Quản lý bí mật]

  - Xử lý bí mật (mã thông báo, mật khẩu, chứng chỉ) an toàn
  - Triển khai hệ thống quản lý bí mật (HashiCorp Vault, AWS Secrets
    Manager)
  - Luân chuyển bí mật một cách an toàn
  - Tránh rò rỉ bí mật trong cấu hình hoặc logs

=== Khi nào không nên sử dụng microservices
<khi-nào-không-nên-sử-dụng-microservices>
+ #strong[Ứng dụng nhỏ hoặc đơn giản]
  - Chi phí phức tạp của microservices vượt quá lợi ích
  - Thời gian phát triển ban đầu dài hơn
  - Khó chứng minh ROI cho các ứng dụng nhỏ
  - Monolith có thể là lựa chọn tốt hơn
+ #strong[Đội ngũ thiếu kinh nghiệm]
  - Đội ngũ không quen với hệ thống phân tán
  - Thiếu kiến thức về DevOps và CI/CD
  - Không có kinh nghiệm với các mẫu thiết kế phân tán
  - Có thể dẫn đến triển khai sai và các vấn đề hiệu suất

