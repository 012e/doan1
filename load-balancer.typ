= Load Balancer

== Giới thiệu

Load balancer là một thành phần quan trọng trong kiến trúc hệ thống,
hoạt động như một trung gian phân phối lưu lượng mạng đến nhiều máy chủ
khác nhau. Mục đích chính của load balancer là tối ưu hóa việc sử dụng
tài nguyên, tăng cường thông lượng, giảm độ trễ và đảm bảo tính sẵn sàng
cao của các ứng dụng và dịch vụ.

Load balancer nhận các yêu cầu từ client và chuyển tiếp chúng đến các
máy chủ phía sau dựa trên các thuật toán phân phối tải nhất định. Khi
một máy chủ gặp sự cố hoặc quá tải, load balancer sẽ tự động chuyển
hướng lưu lượng đến các máy chủ khác đang hoạt động bình thường, đảm bảo
dịch vụ luôn sẵn sàng và người dùng không gặp gián đoạn.

#figure(image("images/2025-03-07-21-50-59.png"), caption: [Hello captions])


== Phân loại

=== Hardware & Software

#figure(image("images/2025-03-07-21-49-37.png"), caption: [Hello captions])

==== Hardware Load Balancer

Hardware load balancer là các thiết bị chuyên dụng được thiết kế đặc
biệt cho việc cân bằng tải. Các thiết bị này thường bao gồm phần cứng
tối ưu và hệ điều hành đặc biệt để xử lý lưu lượng mạng một cách hiệu
quả.

#strong[Ưu điểm:]

- Hiệu suất cao và độ trễ thấp
- Khả năng xử lý lưu lượng lớn
- Độ tin cậy cao
- Thường có các tính năng bảo mật tích hợp

#strong[Nhược điểm:]

- Chi phí đầu tư và bảo trì cao
- Khó mở rộng khi nhu cầu tăng
- Hạn chế về tính linh hoạt và tùy biến

Các nhà cung cấp phổ biến: F5 Networks, Citrix, A10 Networks.

==== Software Load Balancer

Software load balancer là giải pháp cân bằng tải được triển khai dưới
dạng phần mềm, có thể chạy trên các máy chủ thông thường hoặc môi trường
ảo hóa.

#strong[Ưu điểm:]

- Chi phí thấp hơn so với giải pháp phần cứng
- Dễ dàng mở rộng và tùy biến
- Tích hợp tốt với các hệ thống đám mây và môi trường ảo hóa
- Cập nhật và nâng cấp dễ dàng

#strong[Nhược điểm:]

- Hiệu suất có thể không bằng giải pháp phần cứng
- Cần tài nguyên hệ thống để vận hành
- Có thể yêu cầu nhiều cấu hình hơn

Các giải pháp phổ biến: NGINX, HAProxy, AWS ELB, Traefik, Envoy.

=== Tầng xử lý

==== Layer 4 Load Balancer (Transport Layer)

Load balancer tầng 4 hoạt động ở tầng vận chuyển của mô hình OSI, phân
phối lưu lượng dựa trên thông tin IP và cổng TCP/UDP.

#figure(image("images/2025-03-07-21-53-42.png"), caption: [Hello captions])

#strong[Đặc điểm:]

- Phân phối gói tin dựa trên địa chỉ IP nguồn/đích và cổng
- Không xem xét nội dung gói tin
- Hiệu suất cao do xử lý đơn giản
- Không thể thực hiện các quyết định dựa trên nội dung HTTP

==== Layer 7 Load Balancer (Application Layer)

Load balancer tầng 7 hoạt động ở tầng ứng dụng, có khả năng phân tích và
ra quyết định dựa trên nội dung gói tin HTTP/HTTPS.

#figure(image("images/2025-03-07-21-56-12.png"), caption: [Hello captions])

#strong[Đặc điểm:]

- Phân phối yêu cầu dựa trên URL, header HTTP, cookie, dữ liệu phiên
- Có thể thực hiện lọc nội dung, nén, mã hóa SSL
- Hỗ trợ định tuyến thông minh dựa trên nội dung ứng dụng
- Hiệu suất thấp hơn do phải xử lý và phân tích sâu hơn
- Hỗ trợ tốt các ứng dụng phức tạp, microservices

== Thuật toán

Các thuật toán cân bằng tải quyết định cách phân phối lưu lượng đến các
máy chủ backend:

+ #strong[Round Robin:] Phân phối yêu cầu tuần tự qua các máy chủ. Đơn
  giản nhưng không tính đến tải hiện tại của máy chủ.

+ #strong[Weighted Round Robin:] Cải tiến của Round Robin, cho phép gán
  trọng số cho từng máy chủ dựa trên năng lực xử lý.

+ #strong[Least Connections:] Chuyển yêu cầu mới đến máy chủ có ít kết
  nối đang hoạt động nhất.

+ #strong[Weighted Least Connections:] Kết hợp trọng số máy chủ với
  thuật toán Least Connections.

+ #strong[IP Hash:] Sử dụng hàm băm trên địa chỉ IP của client để xác
  định máy chủ đích. Đảm bảo các yêu cầu từ cùng client luôn được chuyển
  đến cùng một máy chủ.

+ #strong[URL Hash:] Tương tự IP Hash nhưng sử dụng URL để xác định máy
  chủ đích.

+ #strong[Least Response Time:] Chuyển yêu cầu đến máy chủ có thời gian
  phản hồi thấp nhất và ít kết nối.

+ #strong[Random with Two Choices:] Chọn ngẫu nhiên hai máy chủ, sau đó
  chọn máy chủ có ít kết nối hơn.

== Pattern

Server-side load balancing và client-side load balancing đều là các phương pháp
phân phối lưu lượng truy cập trên nhiều máy chủ, nhưng chúng khác nhau về cách thức
hoạt động:

+ *Server-side load balancing*: Server-side load balancing được thực hiện bởi một thiết bị hoặc ứng dụng được đặt trước các máy chủ backend. Load balancer sẽ nhận các yêu cầu từ client và sử dụng một thuật toán để chọn một máy chủ backend để xử lý yêu cầu. Sau đó, load balancer sẽ chuyển tiếp yêu cầu đến máy chủ backend được chọn và trả về kết quả cho client.
+ *Client-side load balancing*: Client-side load balancing được thực hiện bởi client. Client sẽ nhận thông tin về các máy chủ backend từ một dịch vụ danh mục (registry service) và sử dụng một thuật toán để chọn một máy chủ backend để gửi yêu cầu. Sau đó, client sẽ gửi yêu cầu trực tiếp đến máy chủ backend được chọn và nhận kết quả trả về.
#figure(image("images/2025-03-07-21-56-52.png"), caption: [Hello captions])

== Tăng availability của hệ thống

Để tăng tính sẵn sàng của hệ thống sử dụng load balancer:

+ #strong[Triển khai nhiều load balancer:] Sử dụng mô hình Active-Active
  hoặc Active-Passive để đảm bảo load balancer không trở thành điểm lỗi
  đơn.

+ #strong[Health checking:] Thiết lập kiểm tra sức khỏe thường xuyên cho
  cả load balancer và máy chủ backend để phát hiện và xử lý sự cố kịp
  thời.

+ #strong[Session persistence (khi cần thiết):] Đảm bảo các yêu cầu từ
  cùng một phiên được chuyển đến cùng một máy chủ để duy trì trạng thái
  phiên.

+ #strong[Giám sát và cảnh báo:] Thiết lập hệ thống giám sát và cảnh báo
  toàn diện để phát hiện sớm các vấn đề tiềm ẩn.

+ #strong[Auto-scaling:] Tích hợp với các nền tảng điện toán đám mây để
  tự động mở rộng số lượng máy chủ backend khi tải tăng cao.

+ #strong[Phân bố địa lý:] Triển khai hệ thống trên nhiều vùng địa lý
  khác nhau để chống lại sự cố khu vực.

+ #strong[Rate limiting và DDoS protection:] Bảo vệ hệ thống khỏi các
  cuộc tấn công từ chối dịch vụ và quá tải.

+ #strong[Rollback plan:] Xây dựng và kiểm tra kế hoạch khôi phục để đảm
  bảo khả năng phục hồi nhanh chóng khi gặp sự cố.

+ #strong[Kiểm tra đầy đủ:] Thực hiện kiểm tra thường xuyên, bao gồm các
  kịch bản thảm họa và khôi phục sau thảm họa.

Việc triển khai load balancer hiệu quả không chỉ giúp phân phối tải một
cách tối ưu mà còn đóng vai trò quan trọng trong việc đảm bảo hệ thống
luôn sẵn sàng và đáng tin cậy, đặc biệt trong các ứng dụng quan trọng
cần thời gian hoạt động cao.

