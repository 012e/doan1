#set text(font: "Times New Roman", size: 13pt)
#set heading(numbering: "1.")
#set page("a4")
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

#let uit-color = rgb("#4a63b8")

#page(margin: 1cm)[
  #rect(width: 100%, height: 100%, stroke: 3pt + uit-color)[
    #pad(rest: 10pt)[
      #align(center)[
        #text(size: 17pt)[*ĐẠI HỌC QUỐC GIA THÀNH PHỐ HỒ CHÍ MINH*] \
        #text[*TRƯỜNG ĐẠI HỌC CÔNG NGHỆ THÔNG TIN*] \
        #text[*KHOA CÔNG NGHỆ PHẦN MỀM*]
        #v(90pt)
        #image("images/logo-uit.svg", width: 200pt)
      ]
      #align(horizon + center)[
        #text(size: 30pt)[*Tìm hiểu về .Net Core 8*] \
        #v(20pt)

        #text[Giảng viên hướng dẫn] \
        #text[*Ths. Nguyễn Công Hoan*] \

        #v(10pt)

        #text[Sinh viên thực hiện] \
        #text[*Phạm Nhật Huy - 23520643*] \
      ]
      #align(bottom + center)[
        #text(size: 13pt)[
          #text[Thành phố Hồ Chí Minh], ngày
          #datetime.today().display("[day]/[month]/[year]")
        ]
      ]
    ]
  ]

]



#pagebreak()
#set page(numbering: "1")
#outline(
  title: [
    #text([Mục lục], size: 30pt)
    #v(10pt)
  ],
  // depth: 4
)
#pagebreak()

#show heading.where(level: 1): it => {
  [Chương #counter(heading).at(here()).at(0). ] + it.body
}



= Tổng quan về thiết kế hệ thống

== Thiết kế các hệ thống nhỏ và trong các hệ thống lớn

== Các nguyên lý thiết kế hệ thống

=== Scalability

==== Giới thiệu 

Scalability (tính mở rộng)  là khả năng của một hệ thống, mạng, hoặc quy trình để xử lý khối lượng công việc ngày càng tăng hoặc có tiềm năng tăng trưởng. Trong lĩnh vực công nghệ thông tin, đặc biệt là đối với các ứng dụng và dịch vụ web, tính mở rộng là một yếu tố thiết kế quan trọng quyết định khả năng đáp ứng nhu cầu ngày càng tăng của người dùng.

==== Các loại scaling

===== Horizontal scaling 
Horizontal scaling (mở rộng theo chiều ngang) liên quan đến việc thêm nhiều máy chủ hoặc nút vào hệ thống hiện có. Đây là phương pháp phổ biến trong môi trường đám mây.

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

- Ưu điểm
  - Đơn giản về mặt triển khai, không cần thay đổi nhiều về kiến trúc phần mềm
  - Không phát sinh vấn đề về đồng bộ hóa giữa các nút
  - Hiệu quả đối với các ứng dụng không được thiết kế cho môi trường phân tán
 
- Nhược điểm:
  - Có giới hạn về khả năng mở rộng (hạn chế bởi phần cứng)
  - Chi phí có thể cao cho phần cứng hiệu năng cao
  - Điểm lỗi đơn lẻ nếu máy chủ gặp sự cố

==== Chiến Lược Mở Rộng

===== Mở Rộng Tự Động (Auto-scaling)
Hệ thống tự động điều chỉnh tài nguyên dựa trên tải hiện tại, thường được áp dụng trong môi trường đám mây:

- Scale-out: Tự động thêm tài nguyên khi tải tăng
- Scale-in: Tự động giảm tài nguyên khi tải giảm
Dựa trên các ngưỡng như mức sử dụng CPU, bộ nhớ, số lượng yêu cầu, v.v.

===== Kiến Trúc Phân Tán
Thiết kế hệ thống với nhiều thành phần có thể hoạt động độc lập:

- Microservices: Chia nhỏ ứng dụng thành các dịch vụ nhỏ, có thể mở rộng riêng biệt
- Sharding: Phân chia dữ liệu thành các phân đoạn nhỏ hơn trên nhiều máy chủ
- Caching: Sử dụng bộ nhớ đệm để giảm tải cho hệ thống cơ sở dữ liệu

===== Cân Bằng Tải (Load Balancing)
Phân phối lưu lượng truy cập đồng đều giữa các máy chủ:

- Cân bằng tải toàn cầu (Global load balancing): Phân phối lưu lượng giữa các trung tâm dữ liệu
- Cân bằng tải nội bộ (Local load balancing): Phân phối lưu lượng giữa các máy chủ trong cùng một trung tâm dữ liệu

==== Thách Thức trong Mở Rộng
===== Mở Rộng Cơ Sở Dữ Liệu
Cơ sở dữ liệu thường là điểm nghẽn khi mở rộng:

- Phân tách đọc/ghi (Read/write splitting): Sử dụng nút chính cho ghi và nhiều nút phụ cho đọc
- Phân vùng dữ liệu (Partitioning): Chia dữ liệu thành nhiều phân vùng dựa trên khóa hoặc phạm vi
- NoSQL và cơ sở dữ liệu phân tán: Thiết kế để mở rộng theo chiều ngang

===== Tính Nhất Quán Dữ Liệu
Trong hệ thống phân tán, việc duy trì tính nhất quán dữ liệu rất khó khăn:

- Nhất quán cuối cùng (Eventual consistency): Cho phép dữ liệu không đồng bộ tạm thời
- Thuật toán đồng thuận (Consensus algorithms): Đảm bảo tính nhất quán trong hệ thống phân tán
- CAP theorem: Sự đánh đổi giữa tính nhất quán, tính khả dụng và khả năng chịu phân vùng

===== Kỹ Thuật Phần Mềm
Thiết kế phần mềm có khả năng mở rộng:

- Không trạng thái (Stateless design): Thiết kế ứng dụng không lưu trữ trạng thái trong bộ nhớ
- Mã không tắc nghẽn (Non-blocking code): Sử dụng lập trình bất đồng bộ để tối ưu hóa hiệu suất
- Phân chia mối quan tâm (Separation of concerns): Thiết kế mô-đun hóa để dễ dàng mở rộng

=== Availability
Availability là thước đo cho biết một hệ thống, dịch vụ hoặc ứng dụng hoạt động và sẵn sàng phục vụ khi cần trong một khoảng thời gian xác định. Đây là một trong những thuộc tính quan trọng nhất của hệ thống đáng tin cậy, đặc biệt đối với các dịch vụ kinh doanh quan trọng.

==== Đo Lường Tính Sẵn Sàng
Tính sẵn sàng thường được biểu thị bằng tỷ lệ phần trăm thời gian hệ thống hoạt động trong một năm. Cách tính phổ biến nhất là:

$"Availability" = ("Tổng thời gian" - "Thời gian ngừng hoạt động") / "Tổng thời gian" times  100%$

- *Các Cấp Độ Sẵn Sàng*
  - Hai số 9 (99%): Cho phép ngừng hoạt động 3,65 ngày/năm
  - Ba số 9 (99,9%): Cho phép ngừng hoạt động 8,76 giờ/năm
  - Bốn số 9 (99,99%): Cho phép ngừng hoạt động 52,56 phút/năm
  - Năm số 9 (99,999%): Cho phép ngừng hoạt động 5,26 phút/năm

Các hệ thống quan trọng như ngân hàng, y tế, hoặc viễn thông thường yêu cầu mức sẵn sàng từ bốn số 9 trở lên.
==== Các Thách Thức Ảnh Hưởng Tính Sẵn Sàng
- *Nguyên Nhân Cứng* (Hard Failures)
  - Lỗi phần cứng: Hỏng máy chủ, thiết bị mạng, ổ đĩa
  - Sự cố nguồn điện: Mất điện, dao động điện áp
  - Sự cố trung tâm dữ liệu: Hỏa hoạn, lũ lụt, thiên tai
  - Lỗi kết nối mạng: Đứt cáp, nghẽn mạng, tấn công DDoS

- *Nguyên Nhân Mềm* (Soft Failures)
  - Lỗi phần mềm: Bugs, memory leaks, race conditions
  - Bảo trì hệ thống: Cập nhật, nâng cấp, sao lưu
  - Quá tải hệ thống: Đột biến lưu lượng, sự kiện đặc biệt
  - Lỗi cấu hình: Cấu hình sai, xung đột cài đặt

==== Chiến Lược Nâng Cao Tính Sẵn Sàng
===== Kiến Trúc Dự Phòng
Loại bỏ điểm lỗi đơn lẻ (SPOF - Single Point of Failure):

- Dự phòng N+1: Cung cấp ít nhất một thành phần dự phòng cho mỗi thành phần chính
- Dự phòng N+M: Cung cấp nhiều thành phần dự phòng
- Kiến trúc Active-Passive: Hệ thống chính hoạt động với hệ thống dự phòng sẵn sàng tiếp quản
- Kiến trúc Active-Active: Nhiều hệ thống hoạt động đồng thời và chia sẻ tải

===== Phân Phối Địa Lý

- Nhiều vùng (Multi-region): Triển khai trên nhiều vùng địa lý
- Nhiều trung tâm dữ liệu (Multi-datacenter): Sử dụng nhiều trung tâm dữ liệu
- Cân bằng tải toàn cầu (Global load balancing): Phân phối lưu lượng giữa các vùng
- Chuyển đổi dự phòng địa lý (Geo-failover): Khả năng chuyển hoạt động sang vùng khác

===== Cơ Chế Phát Hiện và Khôi Phục Lỗi

- Hệ thống giám sát (Monitoring): Theo dõi liên tục trạng thái hệ thống
- Kiểm tra tình trạng (Health checks): Kiểm tra định kỳ khả năng hoạt động
- Tự động chuyển đổi dự phòng (Automatic failover): Tự động chuyển sang hệ thống dự phòng
- Tự phục hồi (Self-healing): Hệ thống tự động phát hiện và sửa chữa vấn đề

===== Bảo Trì Không Gián Đoạn

- Triển khai luân phiên (Rolling deployments): Cập nhật từng phần hệ thống
- Cập nhật xanh-xanh dương (Blue-green deployments): Duy trì hai môi trường song song
- Kiến trúc không ngừng hoạt động (Zero-downtime architecture): Thiết kế cho phép bảo trì mà không ảnh hưởng dịch vụ
- Giai đoạn triển khai (Canary deployments): Triển khai dần dần để giảm thiểu rủi ro

=== Consistency

==== Fault tolerance

==== Byzantine fault

= Load balancer

== Giới thiệu

Load balancer (bộ cân bằng tải) là một thiết bị hoặc phần mềm phân phối lưu lượng mạng hoặc yêu cầu đến nhiều máy chủ. Đây là một thành phần quan trọng trong kiến trúc hệ thống để đảm bảo hiệu suất, độ tin cậy và tính khả dụng của ứng dụng.

== Phân loại

=== Hardware & Software

=== Tầng xử lý

== Thuật toán

== Pattern

== Tăng availability của hệ thống

= Caching

== Tổng quan về caching

== Các pattern trong caching

=== Local cache

=== Distributed cache

=== Reverse proxy cache

=== Sidecar cache

=== Reverses proxy sidecar cache

== Làm trống cache (Cache eviction)

== Các pattern truy cập trong caching

=== Cache-aside

=== Read-through

=== Write-through

=== Write-back (Write-behind)

= Microservices

== Tổng quan về microservices

== Phương thức giao tiếp giữa các microservices

== Khuyết điểm của microservices

= Service discovery & API gateway

== Phân loại service discovery

== Phân loại hình thức register

== Sử dụng service

=== Direct

=== Composite UI

=== API gateway

== Envoy

=== Giới thiệu

=== Kiến trúc

= Distributed transactions

== Tổng quan về transactions

== Two-phase commit (2PC)

== Three-phase commit (3PC)

== Saga

== So sánh Two-phase commit/Three-phase commit và Saga

= Consensus

== Vấn đề consensus

== Thuật toán Raft

=== Khái quát về Raft

=== Bầu cử leader

=== Hoạt động bình thường của thuật toán

=== Ưu điểm và nhược điểm của Raft

==== Ưu điểm

==== Nhược điểm

= Deployment

== Deploy patterns

=== Multiple instances per host

=== Single instance per host

== Docker

=== Kubernetes và Helm

=== Kubernetes

=== Helm

== Consul

== Grafana + Prometheus

=== Grafana

=== Prometheus

= Xây dựng hệ thống với .NET Core

== ASP.NET Core

=== Service & Dependency Injection

=== Middleware

== ORM

== Architecture

=== Clean architecture

=== CQRS

== Thiết kế hệ thống lớn
