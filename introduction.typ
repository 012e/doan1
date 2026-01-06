= Tổng quan về Thiết kế Hệ thống

== Thiết kế trong các hệ thống nhỏ và trong các hệ thống lớn

=== Kiến trúc phần mềm quy mô nhỏ
<kiến-trúc-phần-mềm-quy-mô-nhỏ>

==== Đặc điểm chính
<đặc-điểm-chính>
Kiến trúc phần mềm quy mô nhỏ thường có cấu trúc đơn giản và trực tiếp.
Các hệ thống này thường được thiết kế cho một mục đích cụ thể với số
lượng người dùng và chức năng hạn chế. Phạm vi của các phần mềm này
thường được định nghĩa rõ ràng và ít có sự thay đổi.

==== Mô hình kiến trúc phổ biến
<mô-hình-kiến-trúc-phổ-biến>
Các ứng dụng nhỏ thường áp dụng các mô hình đơn giản như kiến trúc
monolithic, MVC (Model-View-Controller), hoặc kiến trúc hai tầng
(client-server). Các mô hình này dễ triển khai và quản lý với chi phí
thấp.

==== Quy trình phát triển
<quy-trình-phát-triển>
Phát triển phần mềm quy mô nhỏ thường linh hoạt hơn, cho phép thử nghiệm
và triển khai nhanh chóng. Một nhóm nhỏ các nhà phát triển có thể quản
lý toàn bộ codebase, và việc giao tiếp giữa các thành viên dễ dàng hơn.

==== Quản lý dữ liệu
<quản-lý-dữ-liệu>
Hệ thống dữ liệu thường đơn giản, sử dụng một cơ sở dữ liệu duy nhất
hoặc thậm chí lưu trữ dữ liệu cục bộ. Lưu lượng dữ liệu thường thấp và
có thể quản lý bằng các công cụ cơ bản.

=== Kiến trúc phần mềm quy mô lớn
<kiến-trúc-phần-mềm-quy-mô-lớn>
==== Đặc điểm chính
<đặc-điểm-chính-1>
Kiến trúc phần mềm quy mô lớn được thiết kế để xử lý khối lượng công
việc lớn, phục vụ số lượng người dùng đông đảo và cung cấp nhiều chức
năng phức tạp. Các hệ thống này cần phải có khả năng mở rộng, độ tin cậy
cao và khả năng phục hồi tốt.

#figure(image("images/2025-03-07-23-07-43.png"), caption: [Kiến trúc Microservices])

==== Mô hình kiến trúc phổ biến
<mô-hình-kiến-trúc-phổ-biến-1>
Hệ thống lớn thường áp dụng kiến trúc microservices, kiến trúc hướng sự
kiện (event-driven), kiến trúc dựa trên domain (DDD), hoặc kiến trúc
serverless. Các mô hình này cho phép mở rộng quy mô linh hoạt và phát
triển độc lập các thành phần.

==== Quy trình phát triển
<quy-trình-phát-triển-1>
Phát triển phần mềm quy mô lớn đòi hỏi quy trình chặt chẽ hơn, với các
phương pháp DevOps, CI/CD, và kiểm thử tự động. Nhiều nhóm phát triển
cùng làm việc trên các phần khác nhau của hệ thống, đòi hỏi sự phối hợp
và tích hợp liên tục.

==== Quản lý dữ liệu
<quản-lý-dữ-liệu-1>
Hệ thống dữ liệu phức tạp, thường sử dụng nhiều loại cơ sở dữ liệu (đa
dạng hóa dữ liệu), phân chia dữ liệu (sharding), và caching phân tán.
Các chiến lược sao lưu, phục hồi và bảo mật dữ liệu cần được thiết kế kỹ
lưỡng.

=== So sánh kiến trúc phần mềm quy mô nhỏ và lớn
<so-sánh-kiến-trúc-phần-mềm-quy-mô-nhỏ-và-lớn>
==== Độ phức tạp
<độ-phức-tạp>
- #strong[Hệ thống nhỏ];: Đơn giản, dễ hiểu và quản lý
- #strong[Hệ thống lớn];: Phức tạp, đòi hỏi nhiều lớp trừu tượng và tư
  duy hệ thống

==== Khả năng mở rộng
<khả-năng-mở-rộng>
- #strong[Hệ thống nhỏ];: Khả năng mở rộng hạn chế, thường được thiết kế
  cho một quy mô cụ thể
- #strong[Hệ thống lớn];: Được thiết kế với khả năng mở rộng từ đầu, cho
  phép tăng trưởng theo chiều ngang và chiều dọc

==== Chi phí và nguồn lực
<chi-phí-và-nguồn-lực>
- #strong[Hệ thống nhỏ];: Chi phí thấp, cần ít nguồn lực hơn
- #strong[Hệ thống lớn];: Chi phí cao hơn nhiều, đòi hỏi đầu tư lớn về
  nhân lực và cơ sở hạ tầng

==== Độ tin cậy và khả năng chịu lỗi
<độ-tin-cậy-và-khả-năng-chịu-lỗi>
- #strong[Hệ thống nhỏ];: Thường có ít cơ chế dự phòng, chịu lỗi đơn
  giản
- #strong[Hệ thống lớn];: Có nhiều cơ chế dự phòng, phân tán rủi ro, và
  chiến lược phục hồi sau sự cố

==== Thời gian phát triển
<thời-gian-phát-triển>
- #strong[Hệ thống nhỏ];: Chu kỳ phát triển ngắn, từ ý tưởng đến triển
  khai nhanh chóng
- #strong[Hệ thống lớn];: Chu kỳ phát triển dài hơn, đòi hỏi lập kế
  hoạch và thiết kế kỹ lưỡng

==== Bảo trì và cập nhật
<bảo-trì-và-cập-nhật>
- #strong[Hệ thống nhỏ];: Dễ dàng bảo trì và cập nhật
- #strong[Hệ thống lớn];: Bảo trì và cập nhật phức tạp, đòi hỏi chiến
  lược triển khai cẩn thận

== Các nguyên lý thiết kế hệ thống

=== Scalability

==== Giới thiệu 

Scalability (tính mở rộng)  là khả năng của một hệ thống, mạng, hoặc quy trình để xử lý khối lượng công việc ngày càng tăng hoặc có tiềm năng tăng trưởng. Trong lĩnh vực công nghệ thông tin, đặc biệt là đối với các ứng dụng và dịch vụ web, tính mở rộng là một yếu tố thiết kế quan trọng quyết định khả năng đáp ứng nhu cầu ngày càng tăng của người dùng.

==== Các loại scaling

===== Horizontal scaling 
Horizontal scaling (mở rộng theo chiều ngang) liên quan đến việc thêm nhiều máy chủ hoặc nút vào hệ thống hiện có. Đây là phương pháp phổ biến trong môi trường đám mây.
#figure(image("images/2025-03-07-00-25-03.png"), caption: [Minh họa horizontal scaling])
- Ưu điểm:
  - Có thể mở rộng gần như vô hạn bằng cách thêm nhiều máy chủ
  - Tăng cường khả năng chịu lỗi và tính sẵn sàng
  - Thường ít tốn kém hơn việc nâng cấp phần cứng mạnh mẽ

- Nhược điểm:
  - Yêu cầu thiết kế phần mềm phức tạp hơn để phối hợp giữa các nút
  - Có thể phát sinh vấn đề về đồng bộ hóa dữ liệu
  - Chi phí giấy phép phần mềm có thể tăng theo số lượng máy chủ

===== Vertical scaling 
Vertical scaling (mở rộng theo chiều dọc) liên quan đến việc nâng cấp phần cứng của máy chủ hiện có, như thêm CPU, RAM, hoặc ổ cứng.
#figure(image("images/2025-03-07-00-53-57.png"), caption: [Minh họa vertical scaling])

- Ưu điểm
  - Đơn giản về mặt triển khai, không cần thay đổi nhiều về kiến trúc phần mềm
  - Không phát sinh vấn đề về đồng bộ hóa giữa các nút
  - Hiệu quả đối với các ứng dụng không được thiết kế cho môi trường phân tán
 
- Nhược điểm:
  - Có giới hạn về khả năng mở rộng (hạn chế bởi phần cứng)
  - Chi phí có thể cao cho phần cứng hiệu năng cao
  - Điểm lỗi đơn lẻ nếu máy chủ gặp sự cố

==== Chiến Lược Mở Rộng

===== Mở rộng tự động (Auto-scaling)
Hệ thống tự động điều chỉnh tài nguyên dựa trên tải hiện tại, thường được áp dụng trong môi trường đám mây:

- Scale-out: Tự động thêm tài nguyên khi tải tăng
- Scale-in: Tự động giảm tài nguyên khi tải giảm
Dựa trên các ngưỡng như mức sử dụng CPU, bộ nhớ, số lượng yêu cầu, v.v.

===== Kiến trúc phân tán
Thiết kế hệ thống với nhiều thành phần có thể hoạt động độc lập:

- Microservices: Chia nhỏ ứng dụng thành các dịch vụ nhỏ, có thể mở rộng riêng biệt
- Sharding: Phân chia dữ liệu thành các phân đoạn nhỏ hơn trên nhiều máy chủ
- Caching: Sử dụng bộ nhớ đệm để giảm tải cho hệ thống cơ sở dữ liệu

===== Cân bằng tải (Load Balancing)
Phân phối lưu lượng truy cập đồng đều giữa các máy chủ:

- Cân bằng tải toàn cầu (Global load balancing): Phân phối lưu lượng giữa các trung tâm dữ liệu
- Cân bằng tải nội bộ (Local load balancing): Phân phối lưu lượng giữa các máy chủ trong cùng một trung tâm dữ liệu

==== Thách thức trong mở rộng
===== Mở rộng cơ sở dữ liệu
Cơ sở dữ liệu thường là điểm nghẽn khi mở rộng:

- Phân tách đọc/ghi (Read/write splitting): Sử dụng nút chính cho ghi và nhiều nút phụ cho đọc
- Phân vùng dữ liệu (Partitioning): Chia dữ liệu thành nhiều phân vùng dựa trên khóa hoặc phạm vi
- NoSQL và cơ sở dữ liệu phân tán: Thiết kế để mở rộng theo chiều ngang

===== Tính nhất quán dữ liệu
Trong hệ thống phân tán, việc duy trì tính nhất quán dữ liệu rất khó khăn:

- Nhất quán cuối cùng (Eventual consistency): Cho phép dữ liệu không đồng bộ tạm thời
- Thuật toán đồng thuận (Consensus algorithms): Đảm bảo tính nhất quán trong hệ thống phân tán
- CAP theorem: Sự đánh đổi giữa tính nhất quán, tính khả dụng và khả năng chịu phân vùng

===== Kỹ thuật phần mềm
Thiết kế phần mềm có khả năng mở rộng:

- Không trạng thái (Stateless design): Thiết kế ứng dụng không lưu trữ trạng thái trong bộ nhớ
- Mã không tắc nghẽn (Non-blocking code): Sử dụng lập trình bất đồng bộ để tối ưu hóa hiệu suất
- Phân chia mối quan tâm (Separation of concerns): Thiết kế mô-đun hóa để dễ dàng mở rộng

=== Availability
Availability là thước đo cho biết một hệ thống, dịch vụ hoặc ứng dụng hoạt động và sẵn sàng phục vụ khi cần trong một khoảng thời gian xác định. Đây là một trong những thuộc tính quan trọng nhất của hệ thống đáng tin cậy, đặc biệt đối với các dịch vụ kinh doanh quan trọng.

==== Đo lường tính sẵn sàng
Tính sẵn sàng thường được biểu thị bằng tỷ lệ phần trăm thời gian hệ thống hoạt động trong một năm. Cách tính phổ biến nhất là:

#align(center)[
  $"Availability" = ("Tổng thời gian" - "Thời gian ngừng hoạt động") / "Tổng thời gian" times  100%$
]

- *Các cấp độ sẵn sàng*
  - Hai số 9 (99%): Cho phép ngừng hoạt động 3,65 ngày/năm
  - Ba số 9 (99,9%): Cho phép ngừng hoạt động 8,76 giờ/năm
  - Bốn số 9 (99,99%): Cho phép ngừng hoạt động 52,56 phút/năm
  - Năm số 9 (99,999%): Cho phép ngừng hoạt động 5,26 phút/năm

Các hệ thống quan trọng như ngân hàng, y tế, hoặc viễn thông thường yêu cầu mức sẵn sàng từ bốn số 9 trở lên.
==== Các thách thức ảnh hưởng tính sẵn sàng
- *Nguyên nhân cứng* (Hard Failures)
  - Lỗi phần cứng: Hỏng máy chủ, thiết bị mạng, ổ đĩa
  - Sự cố nguồn điện: Mất điện, dao động điện áp
  - Sự cố trung tâm dữ liệu: Hỏa hoạn, lũ lụt, thiên tai
  - Lỗi kết nối mạng: Đứt cáp, nghẽn mạng, tấn công DDoS

- *Nguyên nhân mềm* (Soft Failures)
  - Lỗi phần mềm: Bugs, memory leaks, race conditions
  - Bảo trì hệ thống: Cập nhật, nâng cấp, sao lưu
  - Quá tải hệ thống: Đột biến lưu lượng, sự kiện đặc biệt
  - Lỗi cấu hình: Cấu hình sai, xung đột cài đặt

==== Chiến lược nâng cao tính sẵn sàng
===== Kiến trúc dự phòng
Loại bỏ điểm lỗi đơn lẻ (SPOF - Single Point of Failure):

- Dự phòng N+1: Cung cấp ít nhất một thành phần dự phòng cho mỗi thành phần chính
- Dự phòng N+M: Cung cấp nhiều thành phần dự phòng
- Kiến trúc Active-Passive: Hệ thống chính hoạt động với hệ thống dự phòng sẵn sàng tiếp quản
- Kiến trúc Active-Active: Nhiều hệ thống hoạt động đồng thời và chia sẻ tải

===== Phân phối địa lý

- Nhiều vùng (Multi-region): Triển khai trên nhiều vùng địa lý
- Nhiều trung tâm dữ liệu (Multi-datacenter): Sử dụng nhiều trung tâm dữ liệu
- Cân bằng tải toàn cầu (Global load balancing): Phân phối lưu lượng giữa các vùng
- Chuyển đổi dự phòng địa lý (Geo-failover): Khả năng chuyển hoạt động sang vùng khác

===== Cơ chế phát hiện và khôi phục lỗi

- Hệ thống giám sát (Monitoring): Theo dõi liên tục trạng thái hệ thống
- Kiểm tra tình trạng (Health checks): Kiểm tra định kỳ khả năng hoạt động
- Tự động chuyển đổi dự phòng (Automatic failover): Tự động chuyển sang hệ thống dự phòng
- Tự phục hồi (Self-healing): Hệ thống tự động phát hiện và sửa chữa vấn đề

===== Bảo Trì Không Gián Đoạn

- Triển khai luân phiên (Rolling deployments): Cập nhật từng phần hệ thống
- Cập nhật xanh-xanh dương (Blue-green deployments): Duy trì hai môi trường song song
- Kiến trúc không ngừng hoạt động (Zero-downtime architecture): Thiết kế cho phép bảo trì mà không ảnh hưởng dịch vụ
- Giai đoạn triển khai (Canary deployments): Triển khai dần dần để giảm thiểu rủi ro

=== Tính nhất quán (Consistency)

Tính nhất quán là thuộc tính của hệ thống đảm bảo rằng tất cả các nút hoặc thành phần trong hệ thống đều có cùng dữ liệu hoặc trạng thái tại một thời điểm cụ thể. Trong hệ thống phân tán, duy trì tính nhất quán là một thách thức lớn do dữ liệu được phân tán trên nhiều nút khác nhau.

==== Các mô hình tính nhất quán

+ *Tính nhất quán mạnh (Strong Consistency)*
  - Đảm bảo tất cả các nút đều thấy dữ liệu mới nhất sau khi cập nhật
  - Thường đạt được thông qua các giao thức đồng thuận hoặc cơ chế khóa
  - Ưu điểm: Đơn giản hóa lập trình, dữ liệu luôn nhất quán
  - Nhược điểm: Giảm tính khả dụng, tăng độ trễ giao dịch

+ *Tính nhất quán cuối cùng (Eventual Consistency)*
  - Đảm bảo rằng nếu không có cập nhật mới, cuối cùng tất cả các bản sao sẽ hội tụ về cùng một giá trị
  - Cho phép bất đồng bộ tạm thời giữa các bản sao
  - Ưu điểm: Độ trễ thấp, tính khả dụng cao
  - Nhược điểm: Phức tạp trong xử lý xung đột, có thể trả về dữ liệu cũ

+ *Tính nhất quán nhân quả (Causal Consistency)*
  - Đảm bảo các hoạt động có liên quan nhân quả được thấy theo đúng thứ tự
  - Các hoạt động không liên quan có thể được thấy theo thứ tự khác nhau
  - Cân bằng giữa tính nhất quán mạnh và tính nhất quán cuối cùng

+ *Tính nhất quán phiên (Session Consistency)*
  - Đảm bảo tính nhất quán trong phạm vi một phiên làm việc
  - Người dùng luôn thấy dữ liệu của riêng họ một cách nhất quán
  - Hữu ích cho ứng dụng tương tác người dùng

==== Định Lý CAP (CAP Theorem)

Định lý CAP (do Eric Brewer đề xuất) tuyên bố rằng trong một hệ thống phân tán, không thể đồng thời đảm bảo cả ba thuộc tính sau:

+ *Tính Nhất Quán (Consistency)*: Tất cả các nút thấy cùng dữ liệu tại cùng thời điểm
+ *Tính Khả Dụng (Availability)*: Mỗi yêu cầu đều nhận được phản hồi
+ *Khả Năng Chịu Phân Vùng (Partition Tolerance)*: Hệ thống tiếp tục hoạt động khi có phân vùng mạng

Trong thực tế, do không thể tránh khỏi phân vùng mạng trong hệ thống phân tán, hầu hết các hệ thống phải đánh đổi giữa tính nhất quán và tính khả dụng.

== Tính Chịu Lỗi (Fault Tolerance)
<tính-chịu-lỗi-fault-tolerance>
=== Các khái niệm về tính chịu lỗi
<các-khái-niệm-về-tính-chịu-lỗi>
==== Định nghĩa
<định-nghĩa>
Tính chịu lỗi là khả năng của hệ thống để duy trì hoạt động liên tục và
cung cấp dịch vụ một cách đáng tin cậy ngay cả khi một hoặc nhiều thành
phần của hệ thống gặp sự cố. Đây là một thuộc tính quan trọng trong
thiết kế hệ thống, đặc biệt là các hệ thống quan trọng mà thời gian
ngừng hoạt động có thể gây ra hậu quả nghiêm trọng.

==== Mục tiêu của tính chịu lỗi
<mục-tiêu-của-tính-chịu-lỗi>
- #strong[Tính khả dụng cao (High Availability)];: Đảm bảo hệ thống luôn
  sẵn sàng đáp ứng yêu cầu dịch vụ.
- #strong[Tính liên tục (Continuity)];: Duy trì hoạt động không gián
  đoạn khi có sự cố xảy ra.
- #strong[Độ tin cậy (Reliability)];: Đảm bảo hệ thống hoạt động đúng
  chức năng trong mọi điều kiện.
- #strong[Tính toàn vẹn dữ liệu (Data Integrity)];: Bảo vệ dữ liệu khỏi
  bị hỏng hoặc mất mát.

==== Các loại lỗi
<các-loại-lỗi>
+ #strong[Lỗi phần cứng (Hardware Faults)];:

  - Hỏng ổ cứng, RAM, CPU
  - Mất điện
  - Lỗi mạng và kết nối

+ #strong[Lỗi phần mềm (Software Faults)];:

  - Lỗi lập trình
  - Lỗi hệ điều hành
  - Xung đột tài nguyên
  - Rò rỉ bộ nhớ

+ #strong[Lỗi hoạt động (Operational Faults)];:

  - Lỗi cấu hình
  - Lỗi do con người
  - Quá tải hệ thống

+ #strong[Lỗi thiết kế (Design Faults)];:

  - Lỗi trong kiến trúc hệ thống
  - Thiếu tính năng đảm bảo an toàn
  - Thiết kế không tối ưu

=== Các kỹ thuật đảm bảo tính chịu lỗi
<các-kỹ-thuật-đảm-bảo-tính-chịu-lỗi>
==== Dự phòng (Redundancy)
<dự-phòng-redundancy>
Dự phòng là kỹ thuật cơ bản nhất để đạt được tính chịu lỗi. Nó bao gồm:

+ #strong[Dự phòng phần cứng (Hardware Redundancy)];:

  - #strong[Dự phòng thụ động (Passive Redundancy)];: Sử dụng nhiều
    thành phần dự phòng, trong đó một thành phần hoạt động chính và các
    thành phần khác ở chế độ chờ.
  - #strong[Dự phòng chủ động (Active Redundancy)];: Tất cả các thành
    phần đều hoạt động đồng thời và xử lý công việc.
  - #strong[Dự phòng N+1, N+2];: Có N thành phần cần thiết và thêm 1
    hoặc 2 thành phần dự phòng.
  - #strong[Dự phòng 2N];: Nhân đôi toàn bộ hệ thống.

+ #strong[Dự phòng thông tin (Information Redundancy)];:

  - #strong[Mã kiểm tra lỗi (Error Detection Codes)];: Sử dụng CRC,
    checksum
  - #strong[Mã sửa lỗi (Error Correction Codes)];: Sử dụng Reed-Solomon,
    Hamming
  - #strong[RAID (Redundant Array of Independent Disks)];: Các cấu hình
    RAID khác nhau cung cấp mức độ dự phòng dữ liệu khác nhau

+ #strong[Dự phòng thời gian (Time Redundancy)];:

  - Thực hiện lại các tác vụ bị lỗi
  - Kiểm tra lại kết quả để xác nhận

+ #strong[Dự phòng phần mềm (Software Redundancy)];:

  - #strong[N-version Programming];: Phát triển nhiều phiên bản độc lập
    của cùng một phần mềm
  - #strong[Recovery Blocks];: Sử dụng các phương pháp giải quyết vấn đề
    khác nhau
  - #strong[Design Diversity];: Thiết kế các giải pháp đa dạng

==== Phân vùng và cô lập lỗi (Fault Isolation)
<phân-vùng-và-cô-lập-lỗi-fault-isolation>
+ #strong[Módun hóa (Modularization)];:

  - Chia hệ thống thành các thành phần độc lập
  - Giới hạn ảnh hưởng của lỗi trong một phạm vi nhỏ

+ #strong[Sandboxing];:

  - Thực thi mã trong môi trường cô lập
  - Ngăn chặn lỗi lan truyền sang các phần khác của hệ thống

+ #strong[Microservices];:

  - Phân tách ứng dụng thành các dịch vụ nhỏ, độc lập
  - Mỗi dịch vụ có thể thất bại mà không ảnh hưởng đến toàn bộ hệ thống

==== Phát hiện và khôi phục lỗi (Fault Detection and Recovery)
<phát-hiện-và-khôi-phục-lỗi-fault-detection-and-recovery>
+ #strong[Kỹ thuật phát hiện lỗi];:

  - #strong[Heartbeat/Watchdog];: Giám sát hoạt động liên tục của hệ
    thống
  - #strong[Health checks];: Kiểm tra định kỳ trạng thái của các thành
    phần
  - #strong[Log monitoring];: Phân tích nhật ký để phát hiện dấu hiệu
    lỗi
  - #strong[Circuit breakers];: Phát hiện và ngăn chặn lỗi lan truyền

+ #strong[Kỹ thuật khôi phục lỗi];:

  - #strong[Restart/Reboot];: Khởi động lại thành phần bị lỗi
  - #strong[Rollback];: Quay trở lại trạng thái ổn định trước đó
  - #strong[Failover];: Chuyển đổi sang hệ thống dự phòng
  - #strong[Self-healing];: Hệ thống tự động phát hiện và sửa chữa lỗi

==== Quản lý trạng thái (State Management)
<quản-lý-trạng-thái-state-management>
+ #strong[Checkpointing];:

  - Lưu trữ trạng thái hệ thống tại các điểm cố định
  - Cho phép khôi phục từ điểm checkpoint gần nhất

+ #strong[Transaction Processing];:

  - Đảm bảo tính toàn vẹn của giao dịch (ACID)
  - Hỗ trợ rollback nếu có lỗi

+ #strong[Replication];:

  - Sao chép dữ liệu qua nhiều nút
  - Đồng bộ hóa trạng thái giữa các nút

=== Byzantine Fault Tolerance (BFT)
<byzantine-fault-tolerance-bft>
==== Định nghĩa và bối cảnh
<định-nghĩa-và-bối-cảnh>
Byzantine Fault Tolerance (BFT) là khả năng của hệ thống phân tán để đạt
được sự đồng thuận ngay cả khi một số nút trong hệ thống hoạt động sai
lệch hoặc có hành vi độc hại. Khái niệm này bắt nguồn từ \"Bài toán các
vị tướng Byzantine\" được mô tả bởi Leslie Lamport vào năm 1982.

==== Bài toán các vị tướng Byzantine
<bài-toán-các-vị-tướng-byzantine>
- Một nhóm các vị tướng Byzantine bao vây một thành phố và cần quyết
  định tấn công hay rút lui
- Một số vị tướng có thể là kẻ phản bội, gửi thông tin sai lệch
- Các vị tướng trung thành phải đạt được sự đồng thuận mặc dù có kẻ phản
  bội

==== Đặc điểm của Byzantine Fault
<đặc-điểm-của-byzantine-fault>
- #strong[Lỗi tùy ý (Arbitrary Failures)];: Các nút có thể hoạt động sai
  theo bất kỳ cách nào
- #strong[Hành vi độc hại (Malicious Behavior)];: Các nút có thể cố tình
  phá hoại hệ thống
- #strong[Phức tạp hơn các lỗi crash-stop];: Trong crash-stop, các nút
  chỉ đơn giản là dừng hoạt động

==== Các thuật toán BFT
<các-thuật-toán-bft>
+ #strong[Practical Byzantine Fault Tolerance (PBFT)];:

  - Được đề xuất bởi Castro và Liskov năm 1999
  - Hoạt động trong 3 giai đoạn: pre-prepare, prepare, và commit
  - Yêu cầu 3f+1 nút để chịu được f nút lỗi
  - Được sử dụng trong nhiều hệ thống thực tế

+ #strong[Tendermint];:

  - Thuật toán BFT dựa trên đồng thuận
  - Được sử dụng trong nhiều blockchain
  - Cung cấp cơ chế đồng thuận nhanh và an toàn

+ #strong[HoneyBadgerBFT];:

  - Thuật toán BFT bất đồng bộ
  - Hiệu quả trong môi trường mạng không ổn định
  - Tối ưu hóa cho hiệu suất trong mạng rộng

+ #strong[Federated Byzantine Agreement (FBA)];:

  - Sử dụng trong Stellar blockchain
  - Mỗi nút chọn một tập hợp các nút đáng tin cậy (quorum slices)
  - Cung cấp sự linh hoạt hơn so với các mô hình BFT truyền thống

==== Ứng dụng của BFT
<ứng-dụng-của-bft>
+ #strong[Blockchain và Cryptocurrency];:

  - Bitcoin sử dụng Proof of Work để đạt được đồng thuận
  - Ethereum 2.0 sử dụng thuật toán BFT Casper
  - Các blockchain như Tendermint, Algorand, và Stellar sử dụng các biến
    thể của BFT

+ #strong[Hệ thống phân tán quan trọng];:

  - Hệ thống tài chính
  - Hệ thống điều khiển hàng không
  - Hệ thống quân sự và an ninh quốc gia

+ #strong[Điện toán đám mây và microservices];:

  - Đảm bảo tính nhất quán trong các hệ thống phân tán
  - Bảo vệ chống lại các cuộc tấn công mạng

==== Hạn chế của BFT
<hạn-chế-của-bft>
- #strong[Hiệu suất];: Các thuật toán BFT thường yêu cầu nhiều vòng giao
  tiếp
- #strong[Khả năng mở rộng];: Khó khăn trong việc mở rộng đến hàng nghìn
  nút
- #strong[Phức tạp];: Khó triển khai và gỡ lỗi
- #strong[Chi phí tài nguyên];: Tiêu tốn nhiều tài nguyên tính toán và
  mạng
