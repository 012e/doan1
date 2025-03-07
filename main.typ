#set text(font: "Times New Roman", size: 13pt)
#set heading(numbering: "1.")
#set page("a4")
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages, zebra-fill: none, stroke: black + 1pt)
#show raw: set text(font: "JetBrains Mono", size: 10pt) 

#set table(
  fill: (x, y) =>
    if y == 0 { luma(240) }
    else if x == 0{ luma(250) },
)

#show table.cell.where(y: 0): strong

#set table(align: left + horizon)

#let version = raw(read("version.txt"))
#let uit-color = rgb("#4a63b8")

#page(margin: 1cm)[
  #rect(width: 100%, height: 100%, stroke: 3pt + uit-color)[
    #pad(rest: 10pt)[
      #align(center)[
        #text(size: 17pt)[*ĐẠI HỌC QUỐC GIA THÀNH PHỐ HỒ CHÍ MINH*] \
        #text[*TRƯỜNG ĐẠI HỌC CÔNG NGHỆ THÔNG TIN*] \
        #text[*KHOA CÔNG NGHỆ PHẦN MỀM*] \ 
        #text(fill: white, size: 20pt)[SECRET: version #version]
        #v(50pt)
        #image("images/logo-uit.svg", width: 200pt)
      ]
      #align(horizon + center)[
        #text(size: 26pt)[*Đồ án 1*] \
        #v(3pt)
        #text(size: 30pt)[*Tìm hiểu về .NET Core 8*] \
        #v(20pt)

        #text[Giảng viên hướng dẫn] \
        #text[*Ths. Nguyễn Công Hoan*] \

        #v(10pt)

        #text[Sinh viên thực hiện] \
        #text[*Phạm Nhật Huy #sym.dash.en 23520643*] \
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
#show outline.entry.where(level: 1): it => {
  set text(size: 14pt, weight: "bold")
  set block(above: 1em)
  [#text(size: 14pt)[
    #link(it.element.location())[Chương #it.prefix() #it.inner()]]
  ]
}

#outline(
  title: [
    #text([Mục lục], size: 30pt)
    #v(10pt)
  ],
  depth: 4
)
#pagebreak()
#set page(numbering: "1")

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
#image("images/2025-03-07-00-25-03.png")
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
#image("images/2025-03-07-00-53-57.png")

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

#image("images/2025-03-07-21-50-59.png")


== Phân loại

=== Hardware & Software

#image("images/2025-03-07-21-49-37.png")

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

#image("images/2025-03-07-21-53-42.png")

#strong[Đặc điểm:]

- Phân phối gói tin dựa trên địa chỉ IP nguồn/đích và cổng
- Không xem xét nội dung gói tin
- Hiệu suất cao do xử lý đơn giản
- Không thể thực hiện các quyết định dựa trên nội dung HTTP

==== Layer 7 Load Balancer (Application Layer)

Load balancer tầng 7 hoạt động ở tầng ứng dụng, có khả năng phân tích và
ra quyết định dựa trên nội dung gói tin HTTP/HTTPS.

#image("images/2025-03-07-21-56-12.png")

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
#image("images/2025-03-07-21-56-52.png")

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

= Distributed transactions
<distributed-transactions>
== Tổng quan về transactions
<tổng-quan-về-transactions>
Một transaction (giao dịch) là một chuỗi các thao tác được xem như một
đơn vị công việc đơn lẻ. Transactions được thiết kế để duy trì tính toàn
vẹn dữ liệu bằng cách đảm bảo rằng các thao tác liên quan hoặc được thực
hiện đầy đủ, hoặc không có thao tác nào được thực hiện.

Các thuộc tính cơ bản của một transaction, thường được gọi là thuộc tính
ACID, bao gồm:

- #strong[Atomicity (Tính nguyên tử)];: Đảm bảo rằng tất cả các thao tác
  trong một transaction đều hoàn tất thành công, hoặc không có thao tác
  nào được thực hiện. Không có trạng thái \"một nửa hoàn thành\".
- #strong[Consistency (Tính nhất quán)];: Đảm bảo rằng cơ sở dữ liệu
  thay đổi từ một trạng thái hợp lệ sang một trạng thái hợp lệ khác sau
  khi transaction hoàn tất.
- #strong[Isolation (Tính độc lập)];: Đảm bảo rằng các transaction xảy
  ra đồng thời không ảnh hưởng lẫn nhau. Kết quả của một transaction
  không được hiển thị cho các transaction khác cho đến khi nó hoàn tất.
- #strong[Durability (Tính bền vững)];: Đảm bảo rằng sau khi một
  transaction hoàn tất, kết quả của nó sẽ được lưu trữ vĩnh viễn, ngay
  cả trong trường hợp hệ thống gặp sự cố.

Trong môi trường phân tán, các thao tác không chỉ diễn ra trên một cơ sở
dữ liệu mà còn trên nhiều cơ sở dữ liệu, dịch vụ hoặc hệ thống khác
nhau. Điều này làm phức tạp việc duy trì thuộc tính ACID và đòi hỏi các
giao thức đặc biệt để đảm bảo tính nhất quán.

Distributed transactions (giao dịch phân tán) có thêm một số thách thức:

+ #strong[Độ trễ mạng];: Việc truyền thông giữa các nút trong hệ thống
  phân tán gây ra độ trễ, làm giảm hiệu suất.
+ #strong[Lỗi mạng];: Các kết nối mạng có thể bị đứt, dẫn đến việc không
  thể truy cập các nút.
+ #strong[Lỗi nút];: Các nút riêng lẻ có thể gặp sự cố, làm gián đoạn
  luồng thực hiện transaction.
+ #strong[Đồng thuận];: Việc các nút đồng ý về trạng thái của
  transaction (commit hoặc abort) trở nên phức tạp hơn khi số lượng nút
  tăng lên.

Có nhiều giao thức được đề xuất để quản lý distributed transactions, bao
gồm Two-Phase Commit (2PC), Three-Phase Commit (3PC) và Saga, mỗi loại
có ưu và nhược điểm riêng.

== Two-phase commit (2PC)
<two-phase-commit-2pc>
Two-phase commit (2PC) là một giao thức phổ biến nhất để đảm bảo tính
toàn vẹn của distributed transactions. Như tên gọi, nó bao gồm hai giai
đoạn chính: giai đoạn chuẩn bị (prepare phase) và giai đoạn commit
(commit phase).

=== Các thành phần của 2PC
<các-thành-phần-của-2pc>
+ #strong[Coordinator (Điều phối viên)];: Một nút trung tâm chịu trách
  nhiệm điều phối quá trình transaction, quyết định commit hoặc abort,
  và lưu trữ kết quả cuối cùng.
+ #strong[Participants (Người tham gia)];: Các nút thực hiện các thao
  tác thực tế của transaction và báo cáo trạng thái cho coordinator.

=== Quy trình thực hiện 2PC
<quy-trình-thực-hiện-2pc>
==== Giai đoạn 1: Prepare Phase (Giai đoạn chuẩn bị)
<giai-đoạn-1-prepare-phase-giai-đoạn-chuẩn-bị>
+ Coordinator gửi thông điệp \"prepare\" tới tất cả các participants.
+ Mỗi participant:
  - Thực hiện các thao tác của transaction.
  - Lưu trữ trạng thái transaction vào bộ nhớ ổn định (stable storage)
    để có thể phục hồi nếu cần.
  - Trả lời coordinator với \"vote\_commit\" nếu sẵn sàng commit, hoặc
    \"vote\_abort\" nếu không thể commit vì bất kỳ lý do gì.

==== Giai đoạn 2: Commit Phase (Giai đoạn commit)
<giai-đoạn-2-commit-phase-giai-đoạn-commit>
+ Coordinator nhận phản hồi từ tất cả participants:
  - Nếu tất cả đều trả lời \"vote\_commit\", coordinator quyết định
    \"global\_commit\" và gửi thông điệp \"commit\" tới tất cả
    participants.
  - Nếu bất kỳ participant nào trả lời \"vote\_abort\", coordinator
    quyết định \"global\_abort\" và gửi thông điệp \"abort\" tới tất cả
    participants.
+ Mỗi participant:
  - Nếu nhận được \"commit\", hoàn tất transaction và giải phóng tài
    nguyên.
  - Nếu nhận được \"abort\", hoàn tác (rollback) transaction và giải
    phóng tài nguyên.
+ Participants gửi thông báo xác nhận (acknowledgment) về coordinator.

=== Ưu điểm của 2PC
<ưu-điểm-của-2pc>
+ #strong[Đảm bảo tính toàn vẹn];: 2PC đảm bảo rằng một transaction hoặc
  được thực hiện đầy đủ trên tất cả các nút, hoặc không được thực hiện
  trên bất kỳ nút nào.
+ #strong[Đơn giản];: Giao thức này tương đối đơn giản để hiểu và triển
  khai so với các giải pháp phức tạp hơn.
+ #strong[Được hỗ trợ rộng rãi];: Nhiều hệ thống cơ sở dữ liệu và
  middleware hỗ trợ 2PC.

=== Nhược điểm của 2PC
<nhược-điểm-của-2pc>
+ #strong[Blocking protocol];: Nếu coordinator gặp sự cố sau giai đoạn
  chuẩn bị, các participants sẽ bị chặn (blocked) cho đến khi
  coordinator phục hồi. Điều này có thể gây ra hiệu suất kém và thời
  gian chết (downtime).
+ #strong[Vấn đề hiệu suất];: Quá trình giao tiếp hai chiều nhiều lần
  làm tăng độ trễ và giảm hiệu suất, đặc biệt trong môi trường có độ trễ
  mạng cao.
+ #strong[Single point of failure];: Coordinator là điểm yếu của hệ
  thống, nếu nó gặp sự cố, toàn bộ hệ thống có thể bị ảnh hưởng.
+ #strong[Chi phí khóa tài nguyên];: Tài nguyên bị khóa trong suốt quá
  trình transaction, điều này có thể dẫn đến hiệu suất kém trong các hệ
  thống có tải cao.

=== Ví dụ thực tế về 2PC
<ví-dụ-thực-tế-về-2pc>
Giả sử một ngân hàng cần chuyển tiền từ tài khoản A sang tài khoản B,
hai tài khoản nằm trên hai cơ sở dữ liệu khác nhau:

+ #strong[Prepare Phase];:

  - Coordinator gửi thông điệp \"prepare\" đến cả hai cơ sở dữ liệu.
  - Cơ sở dữ liệu chứa tài khoản A kiểm tra số dư, trừ tiền, lưu trạng
    thái vào log, và gửi \"vote\_commit\".
  - Cơ sở dữ liệu chứa tài khoản B chuẩn bị thêm tiền, lưu trạng thái
    vào log, và gửi \"vote\_commit\".

+ #strong[Commit Phase];:

  - Coordinator nhận \"vote\_commit\" từ cả hai nút, gửi \"commit\" đến
    cả hai.
  - Cả hai cơ sở dữ liệu commit transaction, và xác nhận với
    coordinator.
  - Coordinator đánh dấu transaction là hoàn tất.

Nếu tài khoản A không đủ tiền hoặc có lỗi xảy ra, một trong các nút sẽ
gửi \"vote\_abort\", và coordinator sẽ gửi \"abort\" đến cả hai nút, yêu
cầu hoàn tác thay đổi.

== Three-phase commit (3PC)
<three-phase-commit-3pc>
Three-phase commit (3PC) là một cải tiến của giao thức Two-phase commit,
được thiết kế để giải quyết vấn đề blocking trong 2PC. 3PC thêm một giai
đoạn trung gian, chia quá trình thành ba giai đoạn chính: pre-commit,
prepare to commit, và commit.

=== Các thành phần của 3PC
<các-thành-phần-của-3pc>
Tương tự như 2PC, 3PC cũng có:

+ #strong[Coordinator];: Điều phối quá trình transaction.
+ #strong[Participants];: Các nút thực hiện thao tác và báo cáo trạng
  thái.

=== Quy trình thực hiện 3PC
<quy-trình-thực-hiện-3pc>
==== Giai đoạn 1: Canvassing Phase (Giai đoạn thăm dò)
<giai-đoạn-1-canvassing-phase-giai-đoạn-thăm-dò>
+ Coordinator gửi thông điệp \"can\_commit?\" đến tất cả participants.
+ Mỗi participant:
  - Kiểm tra xem có thể commit transaction không, nhưng chưa thực hiện
    bất kỳ thao tác nào.
  - Trả lời \"yes\" nếu có thể commit, hoặc \"no\" nếu không thể.

==== Giai đoạn 2: Prepare Phase (Giai đoạn chuẩn bị)
<giai-đoạn-2-prepare-phase-giai-đoạn-chuẩn-bị>
+ Nếu tất cả participants trả lời \"yes\" trong giai đoạn 1, coordinator
  gửi thông điệp \"prepare\_commit\" đến tất cả.
+ Mỗi participant:
  - Thực hiện các thao tác transaction và lưu trạng thái vào bộ nhớ ổn
    định.
  - Trả lời \"ACK\" (acknowledgment) để xác nhận đã nhận và xử lý thông
    điệp.
  - Chuyển sang trạng thái \"prepared\", sẵn sàng commit nhưng chưa
    commit.

==== Giai đoạn 3: Commit Phase (Giai đoạn commit)
<giai-đoạn-3-commit-phase-giai-đoạn-commit>
+ Sau khi nhận được \"ACK\" từ tất cả participants, coordinator gửi
  thông điệp \"do\_commit\" đến tất cả.
+ Mỗi participant:
  - Commit transaction và giải phóng tài nguyên.
  - Gửi xác nhận cuối cùng đến coordinator.

=== Xử lý lỗi trong 3PC
<xử-lý-lỗi-trong-3pc>
3PC có cơ chế xử lý lỗi phức tạp hơn 2PC:

+ #strong[Lỗi participant trong giai đoạn 1];: Tương tự như 2PC,
  coordinator sẽ abort transaction.
+ #strong[Lỗi participant trong giai đoạn 2 hoặc 3];: Các participants
  khác có thể tiếp tục và commit transaction, dựa trên timeout và thuật
  toán đồng thuận.
+ #strong[Lỗi coordinator];: Participants có thể chọn coordinator mới
  thông qua thuật toán bầu chọn và tiếp tục transaction.

=== Ưu điểm của 3PC
<ưu-điểm-của-3pc>
+ #strong[Non-blocking];: 3PC là giao thức non-blocking, giải quyết vấn
  đề chính của 2PC. Nếu coordinator gặp sự cố, participants vẫn có thể
  tiến hành và hoàn tất transaction.
+ #strong[Khả năng phục hồi tốt hơn];: 3PC cung cấp cơ chế phục hồi tốt
  hơn trong trường hợp lỗi, nhờ vào trạng thái trung gian
  \"prepare\_commit\".
+ #strong[Phát hiện lỗi hiệu quả];: Giai đoạn đầu tiên giúp phát hiện
  sớm các lỗi tiềm ẩn trước khi thực hiện bất kỳ thay đổi nào.

=== Nhược điểm của 3PC
<nhược-điểm-của-3pc>
+ #strong[Phức tạp hơn];: 3PC phức tạp hơn 2PC, đòi hỏi triển khai và
  quản lý phức tạp hơn.
+ #strong[Hiệu suất thấp hơn trong trường hợp bình thường];: Thêm một
  giai đoạn làm tăng số lượng thông điệp và độ trễ, dẫn đến hiệu suất
  kém hơn trong trường hợp không có lỗi.
+ #strong[Vấn đề phân mảng mạng];: 3PC không hoàn toàn giải quyết được
  vấn đề phân mảng mạng (network partitioning), có thể dẫn đến tình
  trạng không nhất quán trong một số tình huống.
+ #strong[Sử dụng tài nguyên nhiều hơn];: Do có thêm một giai đoạn và cơ
  chế phức tạp hơn, 3PC sử dụng nhiều tài nguyên hệ thống hơn.

=== Ví dụ thực tế về 3PC
<ví-dụ-thực-tế-về-3pc>
Lấy lại ví dụ chuyển tiền giữa hai tài khoản A và B trên hai cơ sở dữ
liệu khác nhau:

+ #strong[Canvassing Phase];:

  - Coordinator gửi \"can\_commit?\" đến cả hai cơ sở dữ liệu.
  - Cơ sở dữ liệu A kiểm tra số dư, xác nhận đủ tiền, gửi \"yes\".
  - Cơ sở dữ liệu B kiểm tra tài khoản tồn tại, gửi \"yes\".

+ #strong[Prepare Phase];:

  - Coordinator gửi \"prepare\_commit\" đến cả hai.
  - Cơ sở dữ liệu A trừ tiền, lưu trạng thái, gửi \"ACK\".
  - Cơ sở dữ liệu B chuẩn bị cộng tiền, lưu trạng thái, gửi \"ACK\".

+ #strong[Commit Phase];:

  - Coordinator gửi \"do\_commit\" đến cả hai.
  - Cả hai cơ sở dữ liệu commit transaction và xác nhận.

Trong trường hợp coordinator gặp sự cố sau giai đoạn prepare, các
participants có thể quyết định commit sau một khoảng thời gian timeout,
vì họ đã đi qua giai đoạn prepare và biết rằng tất cả các participants
khác cũng đã sẵn sàng commit.

== Saga
<saga>
Saga là một mô hình quản lý giao dịch phân tán được thiết kế để duy trì
tính nhất quán trong các ứng dụng có quy mô lớn, đặc biệt là trong kiến
trúc microservices. Khác với 2PC và 3PC, Saga không cố gắng đảm bảo tính
ACID nghiêm ngặt, mà tập trung vào tính nhất quán cuối cùng (eventual
consistency) thông qua chuỗi các giao dịch cục bộ và các cơ chế bù trừ.

=== Nguyên lý hoạt động của Saga
<nguyên-lý-hoạt-động-của-saga>
Saga chia một giao dịch phân tán lớn thành nhiều giao dịch cục bộ nhỏ
hơn. Mỗi giao dịch cục bộ cập nhật dữ liệu trong một dịch vụ, và sau đó
kích hoạt giao dịch tiếp theo trong chuỗi. Nếu một giao dịch thất bại,
Saga thực hiện các giao dịch bù trừ để hoàn tác những thay đổi đã được
thực hiện.

=== Các thành phần của Saga

+ #strong[Các giao dịch cục bộ (Local transactions)];: Mỗi bước trong
  Saga thực hiện một giao dịch riêng biệt, tự chứa trên một dịch vụ hoặc
  cơ sở dữ liệu.
+ #strong[Các hành động bù trừ (Compensating actions)];: Cho mỗi giao
  dịch cục bộ, Saga định nghĩa một hành động bù trừ tương ứng để hoàn
  tác thay đổi khi cần thiết.
+ #strong[Cơ chế điều phối (Coordination mechanism)];: Một cơ chế để
  điều phối luồng thực hiện các giao dịch cục bộ và hành động bù trừ.

=== Cách triển khai Saga

Có hai cách chính để triển khai Saga:

==== Choreography-based Saga (Saga dựa trên biên đạo)

- Các dịch vụ giao tiếp với nhau thông qua sự kiện, không có điều phối
  viên trung tâm.
- Mỗi dịch vụ thực hiện phần của mình trong giao dịch và phát sự kiện để
  thông báo cho dịch vụ tiếp theo.
- Nếu một dịch vụ gặp lỗi, nó phát sự kiện thất bại, kích hoạt các hành
  động bù trừ ở các dịch vụ trước đó.

#strong[Ưu điểm];:

- Phi tập trung, không có single point of failure.
- Ít phức tạp trong triển khai ban đầu.
- Tách biệt cao giữa các dịch vụ.

#strong[Nhược điểm];:

- Khó theo dõi và gỡ lỗi.
- Khó thực hiện các yêu cầu phức tạp hoặc chuỗi giao dịch dài.
- Khả năng mở rộng phức tạp khi số lượng dịch vụ tăng.

==== Orchestration-based Saga (Saga dựa trên điều phối)

- Có một dịch vụ trung tâm (orchestrator) điều phối toàn bộ quy trình.
- Orchestrator quyết định gọi dịch vụ nào tiếp theo và khi nào cần thực
  hiện bù trừ.
- Orchestrator duy trì trạng thái của toàn bộ quy trình.

#strong[Ưu điểm];:

- Dễ theo dõi và gỡ lỗi.
- Xử lý tốt các quy trình phức tạp.
- Tập trung hóa logic điều phối.

#strong[Nhược điểm];:

- Có nguy cơ trở thành single point of failure.
- Có thể tạo ra sự phụ thuộc giữa các dịch vụ và orchestrator.
- Phức tạp hơn trong việc triển khai ban đầu.

=== Quá trình xử lý lỗi trong Saga
<quá-trình-xử-lý-lỗi-trong-saga>
Khi một giao dịch cục bộ thất bại, Saga thực hiện các hành động bù trừ
cho tất cả các giao dịch đã hoàn thành theo thứ tự ngược lại:

+ Phát hiện lỗi trong một giao dịch cục bộ.
+ Dừng thực hiện các giao dịch còn lại.
+ Bắt đầu thực hiện các hành động bù trừ theo thứ tự ngược lại.
+ Đưa hệ thống về trạng thái nhất quán.

=== Ưu điểm của Saga
<ưu-điểm-của-saga>
+ #strong[Khả năng mở rộng];: Saga hoạt động tốt trong các hệ thống phân
  tán quy mô lớn và kiến trúc microservices.
+ #strong[Tính sẵn sàng cao];: Không bị chặn bởi các giao dịch dài, mỗi
  dịch vụ có thể tiếp tục hoạt động độc lập.
+ #strong[Phù hợp với microservices];: Mỗi dịch vụ quản lý dữ liệu riêng
  và chỉ thực hiện các giao dịch cục bộ.
+ #strong[Không khóa tài nguyên];: Giảm thiểu thời gian khóa tài nguyên,
  cải thiện đáng kể hiệu suất.
+ #strong[Tính linh hoạt];: Có thể triển khai theo nhiều cách khác nhau
  tùy thuộc vào yêu cầu hệ thống.

=== Nhược điểm của Saga
<nhược-điểm-của-saga>
+ #strong[Không đảm bảo tính isolation];: Saga không cung cấp isolation,
  có thể dẫn đến truy cập dữ liệu trung gian giữa các bước.
+ #strong[Phức tạp trong thiết kế hành động bù trừ];: Việc thiết kế các
  hành động bù trừ hiệu quả có thể rất phức tạp.
+ #strong[Xử lý lỗi phức tạp];: Cần xử lý nhiều tình huống lỗi khác
  nhau, bao gồm cả lỗi trong các hành động bù trừ.
+ #strong[Tính nhất quán cuối cùng];: Hệ thống có thể ở trạng thái không
  nhất quán tạm thời.
+ #strong[Khó gỡ lỗi];: Theo dõi và gỡ lỗi các giao dịch phân tán phức
  tạp phức tạp hơn so với các giao dịch đơn lẻ.

=== Ví dụ thực tế về Saga
<ví-dụ-thực-tế-về-saga>
Xét ví dụ về quy trình đặt hàng trong hệ thống thương mại điện tử
microservices:

#strong[Chuỗi giao dịch chính];:

+ Dịch vụ Order tạo đơn hàng mới trong trạng thái \"Pending\".
+ Dịch vụ Payment xử lý thanh toán.
+ Dịch vụ Inventory cập nhật số lượng hàng tồn kho.
+ Dịch vụ Shipping tạo đơn vận chuyển.
+ Dịch vụ Order cập nhật trạng thái đơn hàng thành \"Confirmed\".

#strong[Các hành động bù trừ];:

+ Dịch vụ Shipping: Hủy đơn vận chuyển.
+ Dịch vụ Inventory: Hoàn trả số lượng hàng.
+ Dịch vụ Payment: Hoàn tiền cho khách hàng.
+ Dịch vụ Order: Đánh dấu đơn hàng là \"Cancelled\".

#strong[Kịch bản lỗi];:

- Nếu dịch vụ Shipping không thể tạo đơn vận chuyển (ví dụ: không có
  phương tiện vận chuyển đến địa chỉ khách hàng), quy trình sẽ:
  + Dịch vụ Inventory hoàn trả số lượng hàng.
  + Dịch vụ Payment hoàn tiền cho khách hàng.
  + Dịch vụ Order đánh dấu đơn hàng là \"Cancelled\".

Trong kiến trúc choreography, mỗi dịch vụ sẽ phát sự kiện khi hoàn thành
hoặc thất bại, và dịch vụ tiếp theo sẽ phản ứng theo sự kiện đó. Trong
kiến trúc orchestration, một dịch vụ Saga Orchestrator sẽ quản lý toàn
bộ quy trình và gọi các dịch vụ theo thứ tự phù hợp.

== So sánh Two-phase commit/Three-phase commit và Saga
<so-sánh-two-phase-committhree-phase-commit-và-saga>
=== Bối cảnh sử dụng
<bối-cảnh-sử-dụng>
==== Two-phase commit (2PC) và Three-phase commit (3PC)
<two-phase-commit-2pc-và-three-phase-commit-3pc>
- Phù hợp cho các hệ thống yêu cầu tính ACID nghiêm ngặt.
- Thường được sử dụng trong các hệ thống cơ sở dữ liệu phân tán truyền
  thống.
- Tốt cho các giao dịch ngắn và ít phức tạp.
- Phù hợp khi các dịch vụ tham gia giao dịch có sẵn hầu hết thời gian.

==== Saga
<saga-1>
- Phù hợp cho kiến trúc microservices và hệ thống phân tán quy mô lớn.
- Lý tưởng cho các giao dịch kéo dài và phức tạp.
- Tốt cho hệ thống cần tính sẵn sàng cao và khả năng mở rộng.
- Phù hợp khi hệ thống có thể chấp nhận tính nhất quán cuối cùng.

=== So sánh chi tiết
<so-sánh-chi-tiết>
==== Mô hình giao dịch
<mô-hình-giao-dịch>
#figure(
  align(center)[#table(
    columns: 3,
    table.header([Giao thức], [Mô hình giao dịch], [Phạm vi áp dụng],),
    table.hline(),
    [2PC], [Giao dịch toàn cục với các thuộc tính ACID đầy đủ], [Phù hợp
    với các hệ thống cơ sở dữ liệu quan hệ phân tán],
    [3PC], [Giao dịch toàn cục với thuộc tính ACID và khả năng
    non-blocking], [Hệ thống cơ sở dữ liệu phân tán có yêu cầu cao về
    tính sẵn sàng],
    [Saga], [Chuỗi các giao dịch cục bộ với tính nhất quán cuối
    cùng], [Kiến trúc microservices và hệ thống phân tán quy mô lớn],
  )]
  , kind: table
  )

==== Xử lý lỗi và khả năng phục hồi
<xử-lý-lỗi-và-khả-năng-phục-hồi>
#figure(
  align(center)[#table(
    columns: 4,
    table.header([Giao thức], [Cơ chế xử lý lỗi], [Khả năng phục
      hồi], [Tính blocking],),
    table.hline(),
    [2PC], [Rollback toàn bộ nếu có lỗi], [Yếu trong trường hợp
    coordinator gặp sự cố], [Blocking],
    [3PC], [Rollback toàn bộ với cơ chế phục hồi tốt hơn], [Tốt hơn 2PC,
    có thể tiếp tục nếu coordinator gặp sự cố], [Non-blocking],
    [Saga], [Các hành động bù trừ (compensating transactions)], [Tốt,
    mỗi dịch vụ có thể xử lý lỗi độc lập], [Non-blocking],
  )]
  , kind: table
  )

==== Hiệu suất và khả năng mở rộng
<hiệu-suất-và-khả-năng-mở-rộng>
#figure(
  align(center)[#table(
    columns: 4,
    table.header([Giao thức], [Hiệu suất], [Khả năng mở rộng], [Tài
      nguyên cần thiết],),
    table.hline(),
    [2PC], [Thấp, do khóa tài nguyên và trao đổi thông điệp], [Hạn
    chế], [Cao, do khóa tài nguyên],
    [3PC], [Thấp hơn 2PC trong trường hợp bình thường], [Trung
    bình], [Rất cao, do thêm một giai đoạn],
    [Saga], [Cao, không khóa tài nguyên trong thời gian dài], [Rất
    tốt], [Thấp, do không khóa tài nguyên],
  )]
  , kind: table
  )

==== Tính nhất quán và độc lập
<tính-nhất-quán-và-độc-lập>
#figure(
  align(center)[#table(
    columns: 4,
    table.header([Giao thức], [Tính nhất quán], [Tính độc lập
      (Isolation)], [Độ phức tạp triển khai],),
    table.hline(),
    [2PC], [Đảm bảo tính nhất quán mạnh], [Đảm bảo tính độc lập], [Trung
    bình],
    [3PC], [Đảm bảo tính nhất quán mạnh], [Đảm bảo tính độc lập], [Cao],
    [Saga], [Tính nhất quán cuối cùng], [Không đảm bảo tính độc
    lập], [Trung bình đến cao, tùy vào cơ chế điều phối],
  )]
  , kind: table
  )

==== Khả năng đáp ứng trong môi trường phân tán
<khả-năng-đáp-ứng-trong-môi-trường-phân-tán>
#figure(
  align(center)[#table(
    columns: 4,
    table.header([Giao thức], [Đáp ứng lỗi mạng], [Đáp ứng phân mảng
      mạng], [Độ trễ],),
    table.hline(),
    [2PC], [Kém, dễ bị chặn], [Kém, có thể dẫn đến trạng thái không nhất
    quán], [Cao, do nhiều vòng trao đổi thông điệp],
    [3PC], [Trung bình], [Trung bình, giải quyết một số vấn đề nhưng vẫn
    tồn tại hạn chế], [Rất cao, do thêm một giai đoạn trao đổi],
    [Saga], [Tốt], [Tốt, mỗi dịch vụ có thể hoạt động độc lập], [Thấp,
    do trao đổi thông điệp tối thiểu],
  )]
  , kind: table
  )

=== Trường hợp sử dụng phù hợp
<trường-hợp-sử-dụng-phù-hợp>
==== Two-phase commit (2PC)
<two-phase-commit-2pc>
- #strong[Phù hợp khi];:

  - Hệ thống yêu cầu tính ACID đầy đủ.
  - Giao dịch ngắn và đơn giản.
  - Hệ thống mạng ổn định với độ trễ thấp.
  - Số lượng nút tham gia nhỏ.
  - Cần đảm bảo tính nhất quán mạnh.

- #strong[Ví dụ thực tế];:

  - Giao dịch ngân hàng yêu cầu tính nhất quán cao.
  - Hệ thống dự phòng thảm họa cần sao lưu dữ liệu đồng bộ.
  - Các hệ thống tài chính với yêu cầu tuân thủ nghiêm ngặt.

==== Three-phase commit (3PC)
<three-phase-commit-3pc>
- #strong[Phù hợp khi];:

  - Hệ thống yêu cầu tính ACID đầy đủ.
  - Tính sẵn sàng là ưu tiên cao.
  - Có thể chấp nhận hiệu suất thấp để đổi lấy độ tin cậy.
  - Cần giảm thiểu khả năng bị chặn.

- #strong[Ví dụ thực tế];:

  - Hệ thống điều khiển phân tán thời gian thực.
  - Hệ thống điện toán đám mây cần tính sẵn sàng cao.
  - Hệ thống tài chính yêu cầu cả tính nhất quán cao và tính sẵn sàng.

==== Saga
<saga>
- #strong[Phù hợp khi];:

  - Kiến trúc microservices.
  - Giao dịch phức tạp và kéo dài.
  - Có thể chấp nhận tính nhất quán cuối cùng.
  - Cần khả năng mở rộng cao.
  - Yêu cầu tính sẵn sàng cao.

- #strong[Ví dụ thực tế];:

  - Hệ thống thương mại điện tử.
  - Hệ thống đặt vé và lập lịch.
  - Ứng dụng xử lý đơn hàng phức tạp.
  - Ứng dụng di động với kết nối không ổn định.

= Consensus

Consensus là một khái niệm quan trọng trong hệ thống phân tán, đề cập
đến quá trình các nút trong hệ thống đạt được sự thống nhất về một giá
trị hoặc trạng thái. Bài viết này sẽ tìm hiểu về vấn đề consensus và đi
sâu vào thuật toán Raft - một trong những giải pháp phổ biến để giải
quyết vấn đề này.

== Vấn đề consensus
<vấn-đề-consensus>
Vấn đề đồng thuận (consensus) trong hệ thống phân tán là thách thức làm
thế nào để tất cả các nút trong hệ thống có thể đi đến sự thống nhất về
một giá trị hoặc trạng thái khi hệ thống có thể gặp phải nhiều sự cố
như:

- Sự chậm trễ trong truyền thông điệp giữa các nút
- Các nút có thể bị lỗi hoặc ngừng hoạt động (node failures)
- Hệ thống mạng không đáng tin cậy, có thể mất kết nối hoặc trễ cao
- Các nút có thể hoạt động với tốc độ khác nhau
- Tình huống phân mảng mạng (network partition)

Vấn đề consensus đặc biệt khó khăn trong môi trường bất đồng bộ
(asynchronous environment), nơi không có giới hạn về thời gian truyền
tin và các nút có thể bị trì hoãn vô hạn.

Một thuật toán consensus hiệu quả cần đảm bảo các tính chất sau:

+ #strong[Tính thống nhất (Agreement)];: Tất cả các nút không bị lỗi
  cuối cùng sẽ quyết định cùng một giá trị.
+ #strong[Tính chính xác (Validity)];: Giá trị được quyết định phải là
  giá trị được đề xuất bởi ít nhất một nút trong hệ thống.
+ #strong[Tính kết thúc (Termination)];: Tất cả các nút không bị lỗi
  cuối cùng sẽ đi đến quyết định.

Trong thực tế, nhiều thuật toán consensus đã được phát triển, bao gồm
Paxos, Raft, Zab, PBFT (Practical Byzantine Fault Tolerance), và
Tendermint. Mỗi thuật toán có những ưu điểm và nhược điểm riêng, phù hợp
với các trường hợp sử dụng khác nhau.

== Thuật toán Raft
<thuật-toán-raft>
=== Khái quát về Raft
<khái-quát-về-raft>
Raft là một thuật toán đồng thuận được đề xuất bởi Diego Ongaro và John
Ousterhout vào năm 2014 với mục tiêu tạo ra một giải pháp dễ hiểu hơn so
với Paxos. Tên \"Raft\" là từ viết tắt của \"Reliable, Replicated,
Redundant, And Fault-Tolerant\" (Đáng tin cậy, Nhân bản, Dự phòng và
Chịu lỗi).

Raft hoạt động dựa trên mô hình máy trạng thái sao chép (replicated
state machine), trong đó nhiều máy trạng thái đồng nhất được duy trì
trên nhiều nút khác nhau. Những máy trạng thái này được cập nhật thông
qua một log lệnh (command log) đồng nhất.

Nguyên tắc cốt lõi của Raft là:

+ #strong[Phân chia vấn đề];: Raft chia vấn đề consensus thành ba vấn đề
  con dễ hiểu hơn:

  - Bầu cử leader (Leader election)
  - Sao chép log (Log replication)
  - Đảm bảo an toàn (Safety)

+ #strong[Mô hình vai trò];: Trong Raft, mỗi nút có thể ở một trong ba
  vai trò:

  - #strong[Leader];: Xử lý tất cả các yêu cầu từ khách hàng và quản lý
    sao chép log đến các nút khác
  - #strong[Follower];: Thụ động, chỉ phản hồi các yêu cầu từ leader và
    ứng cử viên (candidate)
  - #strong[Candidate];: Vai trò trung gian khi một follower khởi động
    quá trình bầu cử để trở thành leader

+ #strong[Nhiệm kỳ (Term)];: Thời gian được chia thành các nhiệm kỳ
  (term) có số đánh liên tiếp. Mỗi nhiệm kỳ bắt đầu bằng một cuộc bầu cử
  để chọn ra một leader mới. Nếu không có leader nào được bầu, nhiệm kỳ
  kết thúc và một nhiệm kỳ mới bắt đầu.

=== Bầu cử leader
<bầu-cử-leader>
Quy trình bầu cử leader trong Raft diễn ra như sau:

+ #strong[Khởi đầu bầu cử];:

  - Mỗi nút khởi động với vai trò follower
  - Nếu một follower không nhận được thông điệp từ leader trong một
    khoảng thời gian ngẫu nhiên (election timeout), nó chuyển sang vai
    trò candidate và bắt đầu một cuộc bầu cử mới
  - Candidate tăng nhiệm kỳ hiện tại lên 1, bỏ phiếu cho chính mình và
    gửi yêu cầu bỏ phiếu (RequestVote RPC) đến tất cả các nút khác

+ #strong[Quá trình bỏ phiếu];:

  - Khi nhận được RequestVote RPC, follower sẽ bỏ phiếu cho candidate
    nếu:
    - Nhiệm kỳ của candidate lớn hơn hoặc bằng nhiệm kỳ hiện tại của
      follower
    - Follower chưa bỏ phiếu cho candidate khác trong nhiệm kỳ này
    - Log của candidate ít nhất phải cập nhật bằng log của follower (dựa
      trên index và term của mục log cuối cùng)
  - Mỗi nút chỉ được bỏ phiếu một lần trong mỗi nhiệm kỳ

+ #strong[Kết quả bầu cử];:

  - Candidate trở thành leader nếu nhận được đa số phiếu bầu (quá bán)
    từ tất cả các nút trong cụm
  - Nếu nhận được thông điệp từ một leader hợp lệ (có nhiệm kỳ lớn hơn
    hoặc bằng), candidate sẽ trở lại vai trò follower
  - Nếu không nhận được đủ phiếu bầu và không phát hiện leader, sau một
    thời gian chờ ngẫu nhiên, candidate sẽ bắt đầu một cuộc bầu cử mới

+ #strong[Xử lý chia phiếu (Split votes)];:

  - Nếu nhiều candidate bắt đầu bầu cử cùng lúc, có thể xảy ra tình
    huống chia phiếu, không candidate nào nhận được đủ phiếu
  - Để giải quyết vấn đề này, các timeout bầu cử được thiết lập ngẫu
    nhiên, giúp một candidate có cơ hội bắt đầu bầu cử trước những
    candidate khác

Đặc điểm quan trọng là thời gian timeout ngẫu nhiên giúp tránh tình
trạng bầu cử liên tục và đảm bảo hệ thống cuối cùng sẽ bầu được một
leader.

=== Hoạt động bình thường của thuật toán
<hoạt-động-bình-thường-của-thuật-toán>
Sau khi leader được bầu, hệ thống Raft hoạt động theo quy trình sau:

+ #strong[Xử lý yêu cầu từ khách hàng];:

  - Tất cả các yêu cầu từ khách hàng được chuyển đến leader
  - Nếu khách hàng gửi yêu cầu đến follower, follower sẽ chuyển tiếp yêu
    cầu đến leader

+ #strong[Sao chép log];:

  - Khi nhận được yêu cầu, leader tạo một mục log mới và thêm vào log
    của mình
  - Leader gửi mục log mới đến tất cả các follower thông qua
    AppendEntries RPC
  - Các follower kiểm tra tính nhất quán của log và thêm mục mới vào log
    của mình
  - Follower phản hồi cho leader sau khi đã lưu trữ mục log mới

+ #strong[Cam kết (Commit)];:

  - Khi leader xác nhận rằng mục log đã được sao chép thành công đến đa
    số các nút, nó cam kết mục log đó
  - Leader thông báo cho các follower về vị trí cam kết mới trong các
    thông điệp AppendEntries tiếp theo
  - Khi một mục log được cam kết, leader áp dụng nó vào máy trạng thái
    và trả về kết quả cho khách hàng
  - Các follower cũng áp dụng các mục log đã cam kết vào máy trạng thái
    của họ

+ #strong[Duy trì vai trò leader];:

  - Leader định kỳ gửi AppendEntries RPC (có thể không chứa mục log nào)
    đến tất cả các follower để duy trì vai trò leader
  - Các thông điệp này hoạt động như heartbeat, ngăn các follower bắt
    đầu cuộc bầu cử mới

+ #strong[Đồng bộ hóa log];:

  - Khi một mục log không nhất quán giữa leader và follower, leader sẽ
    gửi lại các mục log cũ cho follower
  - Leader duy trì nextIndex cho mỗi follower, chỉ ra mục log tiếp theo
    sẽ gửi đến follower đó
  - Nếu AppendEntries thất bại, leader giảm nextIndex và thử lại, cho
    đến khi tìm thấy điểm nhất quán

+ #strong[Xử lý thay đổi cụm (membership changes)];:

  - Thay đổi cấu hình cụm (thêm hoặc xóa nút) được thực hiện thông qua
    cơ chế bỏ phiếu hai giai đoạn
  - Đầu tiên, cụm chuyển sang cấu hình trung gian (joint consensus) bao
    gồm cả cấu hình cũ và mới
  - Sau khi joint consensus được cam kết, cụm chuyển sang cấu hình mới

+ #strong[Xử lý log compaction];:

  - Để ngăn log phát triển vô hạn, Raft sử dụng cơ chế snapshot
  - Mỗi nút định kỳ tạo snapshot của trạng thái hiện tại và loại bỏ các
    mục log đã được đưa vào snapshot

Trong toàn bộ quy trình, các thuộc tính an toàn của Raft được đảm bảo:

- Nếu một mục log được cam kết ở một nhiệm kỳ, nó sẽ xuất hiện trong log
  của tất cả các leader tương lai
- Leader không bao giờ ghi đè lên các mục log của nó
- Nếu hai log chứa một mục log có cùng index và term, thì tất cả các mục
  log trước đó đều giống nhau

=== Ưu điểm và nhược điểm của Raft
<ưu-điểm-và-nhược-điểm-của-raft>
==== Ưu điểm
<ưu-điểm>
+ #strong[Dễ hiểu và triển khai];:

  - Raft được thiết kế với mục tiêu dễ hiểu và dễ giải thích
  - Phân chia vấn đề thành các module riêng biệt giúp đơn giản hóa thuật
    toán
  - Có nhiều tài liệu và trực quan hóa hỗ trợ việc hiểu thuật toán

+ #strong[Mô hình vai trò rõ ràng];:

  - Việc phân chia vai trò thành leader, follower và candidate giúp đơn
    giản hóa luồng điều khiển
  - Tất cả các quyết định được tập trung ở leader, giảm độ phức tạp
    trong việc đồng bộ hóa

+ #strong[Tính chịu lỗi cao];:

  - Raft có thể chịu được lỗi của tối đa (N-1)/2 nút trong cụm N nút
  - Cơ chế bầu cử hiệu quả giúp nhanh chóng khôi phục khi leader gặp sự
    cố

+ #strong[Tính nhất quán mạnh (Strong consistency)];:

  - Raft đảm bảo tính nhất quán mạnh cho dữ liệu, phù hợp với các ứng
    dụng yêu cầu độ tin cậy cao
  - Mọi thay đổi được cam kết đều được đảm bảo không bị mất khi có sự cố

+ #strong[Cơ chế log và snapshot hiệu quả];:

  - Cơ chế log đơn giản và hiệu quả giúp dễ dàng triển khai và gỡ lỗi
  - Hỗ trợ snapshot giúp quản lý kích thước log và tối ưu hiệu suất

+ #strong[Hỗ trợ thay đổi cấu hình động];:

  - Raft cho phép thay đổi cấu hình cụm (thêm/xóa nút) trong khi hệ
    thống vẫn hoạt động
  - Cơ chế joint consensus đảm bảo an toàn khi thay đổi cấu hình

+ #strong[Triển khai rộng rãi];:

  - Raft đã được triển khai trong nhiều hệ thống phân tán thực tế như
    etcd, Consul, TiKV
  - Cộng đồng phát triển mạnh với nhiều thư viện và công cụ hỗ trợ

==== Nhược điểm
<nhược-điểm>
+ #strong[Hiệu suất bị ảnh hưởng bởi leader];:

  - Tất cả các yêu cầu ghi phải đi qua leader, có thể tạo thành điểm
    nghẽn
  - Nếu leader gặp sự cố, hệ thống phải chờ bầu cử leader mới trước khi
    xử lý các yêu cầu ghi

+ #strong[Độ trễ cao hơn trong một số trường hợp];:

  - Yêu cầu phần lớn nút phải xác nhận trước khi cam kết, gây độ trễ
    trong môi trường mạng chậm
  - Nếu leader và follower có độ trễ kết nối cao, hiệu suất của toàn bộ
    hệ thống sẽ bị ảnh hưởng

+ #strong[Không tối ưu cho mạng địa lý phân tán (geo-distributed
  networks)];:

  - Trong mạng phân tán địa lý với độ trễ cao giữa các vùng, Raft có thể
    không hiệu quả bằng các giải pháp khác
  - Cơ chế bầu cử và đồng bộ log có thể chậm trong môi trường độ trễ cao

+ #strong[Hạn chế khả năng mở rộng (scalability)];:

  - Khi số lượng nút tăng lên, lưu lượng mạng từ leader đến các follower
    tăng tuyến tính
  - Hiệu suất có thể giảm khi số lượng nút trong cụm quá lớn

+ #strong[Không chịu được lỗi Byzantine];:

  - Raft không được thiết kế để xử lý các lỗi Byzantine (nút có hành vi
    độc hại hoặc không nhất quán)
  - Nếu nút có hành vi độc hại, thuật toán có thể không đảm bảo tính
    đúng đắn

+ #strong[Chi phí bảo trì log và snapshot];:

  - Việc duy trì log và snapshot có thể tốn tài nguyên đáng kể, đặc biệt
    với khối lượng ghi lớn
  - Quá trình nén log (compaction) có thể ảnh hưởng đến hiệu suất hệ
    thống

+ #strong[Phức tạp khi triển khai đầy đủ];:

  - Mặc dù khái niệm cơ bản dễ hiểu, nhưng triển khai đầy đủ với tất cả
    các tối ưu hóa có thể khá phức tạp
  - Xử lý các trường hợp đặc biệt như phục hồi snapshot, thay đổi cấu
    hình đòi hỏi sự cẩn thận

== Các ứng dụng thực tế của Raft
<các-ứng-dụng-thực-tế-của-raft>
Thuật toán Raft đã được ứng dụng rộng rãi trong nhiều hệ thống phân tán
hiện đại:

+ #strong[etcd];: Hệ thống lưu trữ khóa-giá trị phân tán được sử dụng
  rộng rãi trong Kubernetes
+ #strong[Consul];: Hệ thống khám phá dịch vụ và cấu hình từ HashiCorp
+ #strong[TiKV];: Lớp lưu trữ khóa-giá trị phân tán của cơ sở dữ liệu
  TiDB
+ #strong[CockroachDB];: Cơ sở dữ liệu SQL phân tán, sử dụng biến thể
  của Raft
+ #strong[RethinkDB];: Cơ sở dữ liệu NoSQL với khả năng truy vấn thời
  gian thực
+ #strong[InfluxDB];: Cơ sở dữ liệu chuỗi thời gian (time series
  database)

= Deployment
<deployment>
== Deploy patterns
<deploy-patterns>
=== Multiple instances per host
<multiple-instances-per-host>
#strong[Multiple Instances per Host] là mô hình triển khai trong đó
#strong[nhiều phiên bản của một ứng dụng hoặc dịch vụ] chạy trên cùng
một máy chủ vật lý hoặc máy ảo. Điều này giúp #strong[tận dụng tối đa
tài nguyên];, #strong[giảm chi phí hạ tầng] và #strong[tăng hiệu quả sử
dụng máy chủ];. Tuy nhiên, nó cũng đòi hỏi #strong[quản lý tài nguyên
chặt chẽ] để tránh xung đột và quá tải hệ thống.

#image("images/2025-03-07-22-24-02.png")

- #strong[Ưu điểm];:
  - Tối ưu hóa việc sử dụng tài nguyên phần cứng
  - Giảm chi phí hạ tầng
  - Dễ dàng mở rộng theo chiều ngang với ít máy chủ hơn
- #strong[Nhược điểm];:
  - Khả năng cạnh tranh tài nguyên giữa các instance
  - Khó khăn trong việc cô lập lỗi và đảm bảo an toàn
  - Vấn đề về quản lý phụ thuộc nếu các ứng dụng yêu cầu các phiên bản
    thư viện khác nhau
- #strong[Trường hợp áp dụng];:
  - Các ứng dụng có mức tiêu thụ tài nguyên thấp
  - Môi trường phát triển và kiểm thử
  - Hệ thống có ngân sách hạn chế

=== Single instance per host
<single-instance-per-host>
#strong[Single Instance per Host] là mô hình triển khai trong đó
#strong[mỗi máy chủ chỉ chạy một phiên bản của ứng dụng hoặc dịch vụ];.
Điều này giúp #strong[cách ly tài nguyên];, #strong[cải thiện hiệu suất
và độ ổn định];, đồng thời #strong[giảm rủi ro xung đột] giữa các ứng
dụng. Tuy nhiên, mô hình này có thể #strong[tốn nhiều tài nguyên hơn] so
với chạy nhiều phiên bản trên cùng một máy chủ.

- #strong[Ưu điểm];:
  - Cô lập tài nguyên và quy trình xử lý
  - Tăng tính bảo mật và ổn định
  - Đơn giản hóa việc quản lý vòng đời ứng dụng
  - Dễ dàng mở rộng theo chiều dọc (vertical scaling)
- #strong[Nhược điểm];:
  - Chi phí hạ tầng cao hơn
  - Lãng phí tài nguyên nếu ứng dụng không sử dụng hết công suất máy chủ
- #strong[Trường hợp áp dụng];:
  - Các ứng dụng đòi hỏi hiệu suất cao
  - Dịch vụ cần độ tin cậy và khả năng dự đoán cao
  - Hệ thống sản xuất quan trọng

== Containerization
<containerization>
=== Docker
<docker>

#strong[Docker] là một nền tảng #strong[ảo hóa cấp độ hệ điều hành] giúp
đóng gói ứng dụng và các phụ thuộc của nó vào một #strong[container];.
Container này có thể chạy nhất quán trên nhiều môi trường khác nhau, từ
máy tính cá nhân đến máy chủ và đám mây. Docker giúp #strong[tối ưu hóa
việc triển khai, tăng tính di động, giảm xung đột môi trường và cải
thiện hiệu suất] trong việc phát triển và vận hành phần mềm.

#image("images/2025-03-07-22-22-49.png")

- #strong[Thành phần chính];:
  - #strong[Docker Engine];: Runtime để tạo và quản lý container
  - #strong[Docker Image];: Template chỉ đọc chứa mã nguồn, thư viện,
    phụ thuộc và các file cần thiết
  - #strong[Dockerfile];: File kịch bản định nghĩa cách tạo image
  - #strong[Docker Registry];: Kho lưu trữ và chia sẻ image (Docker Hub,
    Amazon ECR, Google Container Registry)
  - #strong[Docker Compose];: Công cụ định nghĩa và chạy ứng dụng Docker
    đa container
- #strong[Ưu điểm];:
  - Tính nhất quán giữa các môi trường
  - Khả năng di động cao
  - Hiệu quả về tài nguyên hơn so với máy ảo
  - Cô lập ứng dụng và phụ thuộc
- #strong[Nhược điểm];:
  - Vấn đề về bảo mật nếu không được cấu hình đúng
  - Độ phức tạp trong quản lý mạng và lưu trữ dữ liệu dài hạn
  - Chi phí hiệu suất nhỏ so với ứng dụng chạy trực tiếp trên host
- #strong[Các lệnh Docker cơ bản];:
  ```bash
  docker build -t myapp:1.0 .            # Tạo image từ Dockerfile
  docker run -d -p 8080:80 myapp:1.0     # Chạy container
  docker ps                              # Liệt kê container đang chạy
  docker logs container_id               # Xem logs
  docker exec -it container_id bash      # Truy cập vào container
  ```

=== Podman
<podman>
#strong[Podman] là một công cụ quản lý container mã nguồn mở, tương tự
như Docker, nhưng không yêu cầu #strong[daemon] chạy nền. Nó hỗ trợ
#strong[chạy, xây dựng và quản lý container] theo chuẩn OCI (Open
Container Initiative). Podman có thể chạy container #strong[không cần
quyền root];, giúp #strong[tăng cường bảo mật];. Ngoài ra, nó có thể
thay thế Docker trong nhiều trường hợp mà không cần thay đổi quá nhiều
về workflow.

- #strong[Đặc điểm nổi bật];:
  - Kiến trúc không daemon (daemonless)
  - Mô hình bảo mật tốt hơn với khả năng chạy dưới quyền người dùng
    thông thường
  - Hỗ trợ pod (nhóm container) giống Kubernetes
  - Tương thích với Docker, sử dụng cùng định dạng image
- #strong[Ưu điểm];:
  - Bảo mật tốt hơn do không cần quyền root
  - Sử dụng ít tài nguyên hơn khi không có daemon chạy liên tục
  - Tích hợp tốt với systemd
  - Tương thích API với Docker giúp chuyển đổi dễ dàng
- #strong[Nhược điểm];:
  - Một số tính năng Docker chưa được hỗ trợ đầy đủ
  - Cộng đồng nhỏ hơn so với Docker
- #strong[Các lệnh Podman cơ bản];:
  ```bash
  podman build -t myapp:1.0 .            # Tạo image
  podman run -d -p 8080:80 myapp:1.0     # Chạy container
  podman ps                              # Liệt kê container
  podman pod create --name mypod         # Tạo pod
  podman generate kube mypod > pod.yaml  # Tạo file cấu hình Kubernetes
  ```

=== Kubernetes & Helm
<kubernetes--helm>
==== Kubernetes
<kubernetes>
#strong[Kubernetes] là một nền tảng #strong[orchestration] mã nguồn mở
dùng để #strong[tự động triển khai, mở rộng và quản lý] các ứng dụng
container. Nó giúp quản lý #strong[các container] trên một cụm máy chủ,
cung cấp các tính năng như #strong[cân bằng tải, tự động phục hồi,
scaling linh hoạt] và #strong[quản lý cấu hình];. Kubernetes cho phép
ứng dụng chạy ổn định, dễ dàng mở rộng và tối ưu hóa tài nguyên trong
môi trường #strong[cloud-native];.

#align(center)[
  #image("images/2025-03-07-22-29-48.png", width: 5cm)
]

- #strong[Kiến trúc];:
  - #strong[Control Plane];:
    - #strong[API Server];: Giao diện để tương tác với cluster
    - #strong[etcd];: Cơ sở dữ liệu phân tán lưu trữ cấu hình cluster
    - #strong[Scheduler];: Phân phối pods đến các nodes
    - #strong[Controller Manager];: Quản lý các controller như node
      controller, replication controller
  - #strong[Worker Nodes];:
    - #strong[Kubelet];: Đảm bảo containers chạy trong pod
    - #strong[Kube-proxy];: Duy trì network rules trên nodes
    - #strong[Container Runtime];: Docker, containerd, CRI-O
- #strong[Các thành phần cơ bản];:
  - #strong[Pod];: Đơn vị nhỏ nhất, chứa một hoặc nhiều container
  - #strong[Service];: Cung cấp network endpoint ổn định cho pods
  - #strong[Deployment];: Quản lý việc tạo và cập nhật pods
  - #strong[StatefulSet];: Quản lý các ứng dụng stateful
  - #strong[ConfigMap & Secret];: Quản lý cấu hình và thông tin nhạy cảm
  - #strong[Ingress];: Quản lý truy cập HTTP từ bên ngoài cluster
  - #strong[Namespace];: Phân chia tài nguyên cluster theo logic
- #strong[Ưu điểm];:
  - Tự động hóa cao: tự phát hiện lỗi, tự phục hồi, tự mở rộng
  - Quản lý declarative thông qua YAML
  - Hỗ trợ triển khai nhiều môi trường (on-premises, cloud)
  - Cộng đồng lớn và hệ sinh thái phong phú
- #strong[Nhược điểm];:
  - Đường cong học tập dốc
  - Phức tạp trong việc cài đặt và bảo trì
  - Tốn nhiều tài nguyên cho các cluster nhỏ
- #strong[Các công cụ quản lý];:
  - #strong[kubectl];: CLI chính thức để tương tác với clusters
  - #strong[k9s];: Terminal UI cho Kubernetes
  - #strong[Lens];: GUI desktop cho quản lý Kubernetes
  - #strong[Managed K8s];: EKS (AWS), GKE (Google), AKS (Azure)

==== Helm
<helm>
#strong[Helm] là một trình quản lý package dành cho #strong[Kubernetes];,
giúp tự động hóa việc #strong[triển khai, quản lý và cập nhật] ứng dụng
dưới dạng #strong[biểu đồ (Helm Charts)];. Nó cho phép định nghĩa, cài
đặt và quản lý các ứng dụng Kubernetes một cách #strong[dễ dàng, có thể
tái sử dụng và có thể cấu hình linh hoạt];. Helm giúp đơn giản hóa quá
trình triển khai ứng dụng phức tạp, hỗ trợ #strong[rollbacks,
versioning] và quản lý #strong[dependencies] trong Kubernetes.

#align(center)[
  #image("images/2025-03-07-22-27-44.png", width: 5cm)
]

- #strong[Thành phần chính];:
  - #strong[Chart];: Gói các tài nguyên Kubernetes liên quan
  - #strong[Repository];: Nơi lưu trữ và chia sẻ charts
  - #strong[Release];: Instance của chart chạy trong cluster
- #strong[Cấu trúc Chart];:
  ```
  mychart/
  ├── Chart.yaml         # Thông tin về chart
  ├── values.yaml        # Giá trị mặc định
  ├── templates/         # Các template Kubernetes
  │   ├── deployment.yaml
  │   ├── service.yaml
  │   └── _helpers.tpl
  └── charts/            # Chart phụ thuộc (nếu có)
  ```
- #strong[Ưu điểm];:
  - Đơn giản hóa việc triển khai ứng dụng phức tạp
  - Quản lý phiên bản và rollback dễ dàng
  - Tái sử dụng cấu hình qua các môi trường
  - Chia sẻ ứng dụng trong cộng đồng qua Helm Hub
- #strong[Nhược điểm];:
  - Thêm lớp trừu tượng có thể gây khó khăn khi gỡ lỗi
  - Cách tiếp cận template có thể tạo ra các cấu hình phức tạp
- #strong[Các lệnh Helm cơ bản];:
  ```bash
  helm create mychart               # Tạo chart mới
  helm install myrelease mychart    # Cài đặt chart
  helm upgrade myrelease mychart    # Nâng cấp release
  helm rollback myrelease 1         # Rollback về phiên bản 1
  helm uninstall myrelease          # Gỡ bỏ release
  helm repo add bitnami https://charts.bitnami.com/bitnami  # Thêm repository
  ```

== Infrastructure & Configuration Management
<infrastructure--configuration-management>
=== Infrastructure as Code (IaC)
<infrastructure-as-code-iac>
#strong[Infrastructure as Code (IaC)] là phương pháp quản lý và cung cấp
#strong[hạ tầng IT] bằng cách sử dụng #strong[các tập tin cấu hình hoặc
mã nguồn];, thay vì cấu hình thủ công. IaC giúp #strong[tự động hóa,
tăng tính nhất quán, giảm lỗi con người và cải thiện khả năng mở rộng];.
Các công cụ phổ biến như #strong[Terraform, Ansible, CloudFormation] cho
phép định nghĩa hạ tầng dưới dạng #strong[code];, giúp dễ dàng kiểm soát
phiên bản, tái sử dụng và triển khai trên nhiều môi trường.
- #strong[Công cụ phổ biến];:
  - #strong[Terraform];:
    - Công cụ mã nguồn mở, ngôn ngữ HCL
    - Hỗ trợ nhiều cloud provider (AWS, Azure, GCP)
    - Sử dụng state file để theo dõi tài nguyên
    - Tính mô-đun cao với Terraform modules

    ```hcl
    provider "aws" {
      region = "us-west-2"
    }

    resource "aws_instance" "example" {
      ami           = "ami-0c55b159cbfafe1f0"
      instance_type = "t2.micro"
      tags = {
        Name = "example-instance"
      }
    }
    ```
  - #strong[AWS CloudFormation];:
    - Dịch vụ riêng của AWS
    - Sử dụng JSON hoặc YAML
    - Tích hợp sâu với các dịch vụ AWS
    - Hỗ trợ drift detection
  - #strong[Azure Resource Manager (ARM)];:
    - Dịch vụ quản lý tài nguyên của Azure
    - Sử dụng JSON templates
    - Hỗ trợ Role-Based Access Control
  - #strong[Pulumi];:
    - Sử dụng ngôn ngữ lập trình thực (Python, JavaScript, Go)
    - Hỗ trợ đa cloud
    - State management tương tự Terraform
- #strong[Nguyên tắc chính];:
  - #strong[Idempotence];: Có thể áp dụng cùng một cấu hình nhiều lần mà
    không gây ra thay đổi
  - #strong[Declarative];: Mô tả trạng thái mong muốn, không phải các
    bước để đạt được
  - #strong[Version Control];: Mã nguồn hạ tầng được quản lý trong hệ
    thống VCS
- #strong[Ưu điểm];:
  - Tính nhất quán và khả năng tái tạo
  - Tự động hóa cao, giảm lỗi do con người
  - Kiểm soát phiên bản và theo dõi thay đổi
  - Documentation as code
- #strong[Nhược điểm];:
  - Đường cong học tập dốc
  - Có thể phức tạp khi quản lý hệ thống lớn
  - Rủi ro nếu state management không đúng

=== Configuration management
<configuration-management>
- #strong[Định nghĩa];: Quản lý cấu hình hệ thống và phần mềm trên nhiều
  máy chủ một cách tự động và đồng nhất.
- #strong[Công cụ phổ biến];:
  - #strong[Ansible];:
    - Không cần agent, sử dụng SSH
    - YAML-based playbooks
    - Ít yêu cầu về hạ tầng
    - Mô hình push configuration

    ```yaml
    ---
    - hosts: webservers
      become: yes
      tasks:
        - name: Install nginx
          apt:
            name: nginx
            state: present
        - name: Start nginx
          service:
            name: nginx
            state: started
            enabled: yes
    ```
  - #strong[Puppet];:
    - Mô hình client-server
    - Ngôn ngữ DSL riêng
    - Hỗ trợ nhiều nền tảng
    - Mô hình pull configuration
  - #strong[Chef];:
    - Sử dụng Ruby DSL
    - Hỗ trợ đa nền tảng
    - \"Recipes\" và \"Cookbooks\"
    - Cộng đồng lớn và nhiều cookbook sẵn có
  - #strong[SaltStack];:
    - Tốc độ cao với ZeroMQ
    - Hỗ trợ cả push và pull
    - YAML based states
    - Remote execution engine
- #strong[Đặc tính chính];:
  - #strong[Idempotence];: Áp dụng cấu hình nhiều lần mà không gây ra
    thay đổi
  - #strong[Desired State Configuration];: Mô tả trạng thái đích, không
    phải các bước để đạt được
  - #strong[Templating];: Sử dụng templates để tạo cấu hình động
  - #strong[Facts/Variables];: Thu thập thông tin về hệ thống để quyết
    định cấu hình
- #strong[Ưu điểm];:
  - Quản lý hạ tầng quy mô lớn hiệu quả
  - Đảm bảo tính nhất quán giữa các môi trường
  - Giảm thiểu lỗi cấu hình thủ công
  - Tự động hóa việc cập nhật và bảo trì
- #strong[Nhược điểm];:
  - Phức tạp khi triển khai ban đầu
  - Yêu cầu kỹ năng chuyên môn
  - Có thể trở nên rắc rối với các hệ thống phức tạp

== Consul
<consul>
#strong[Consul] là một công cụ #strong[service mesh] và #strong[quản lý
dịch vụ phân tán];, giúp thực hiện #strong[service discovery, cấu hình,
quản lý key-value và bảo mật] trong hệ thống microservices. Nó hỗ trợ
#strong[quản lý trạng thái dịch vụ, cân bằng tải, giám sát sức khỏe
(health checks)] và cung cấp #strong[mạng zero-trust với service mesh];.
Consul có thể chạy trên nhiều môi trường, từ #strong[on-premises] đến
#strong[cloud];, giúp các dịch vụ giao tiếp an toàn và hiệu quả.

#align(center)[
  #image("images/2025-03-07-22-32-03.png", width: 5cm)
]

- #strong[Tính năng chính];:
  - #strong[Service Discovery];: Đăng ký và khám phá dịch vụ tự động
  - #strong[Health Checking];: Kiểm tra sức khỏe dịch vụ liên tục
  - #strong[Key-Value Store];: Lưu trữ cấu hình phân tán
  - #strong[Segmentation];: Bảo mật mạng zero-trust với Consul Connect
  - #strong[Multi-datacenter];: Hỗ trợ nhiều trung tâm dữ liệu và khu
    vực
- #strong[Kiến trúc];:
  - #strong[Consul Agent];: Chạy trên mỗi node, có thể ở chế độ client
    hoặc server
  - #strong[Consul Server];: Lưu trữ dữ liệu trong cluster, thực hiện
    consensus
  - #strong[Consensus Protocol];: Sử dụng Raft để đảm bảo tính nhất quán
  - #strong[Gossip Protocol];: Serf, sử dụng để phát hiện lỗi node,
    truyền thông báo
- #strong[Cách sử dụng];:
  - #strong[Đăng ký dịch vụ];:
    ```json
    {
      "service": {
        "name": "web",
        "tags": ["rails"],
        "port": 80,
        "check": {
          "http": "http://localhost:80/health",
          "interval": "10s"
        }
      }
    }
    ```
  - #strong[Truy vấn dịch vụ];:
    ```bash
    curl http://localhost:8500/v1/catalog/service/web
    # hoặc
    consul catalog services
    ```
  - #strong[Lưu trữ key-value];:
    ```bash
    consul kv put config/database/host db.example.com
    consul kv get config/database/host
    ```
- #strong[Tích hợp với các công cụ khác];:
  - Nomad: Orchestration
  - Vault: Bảo mật và quản lý bí mật
  - Terraform: Infrastructure provisioning
  - Kubernetes: Có thể sử dụng làm service catalog
- #strong[Ưu điểm];:
  - Nhẹ và dễ triển khai
  - Không phụ thuộc vào nền tảng cụ thể
  - Hỗ trợ nhiều kiểu kiểm tra sức khỏe
  - Tích hợp DNS cho service discovery
- #strong[Nhược điểm];:
  - Phức tạp khi cấu hình cho hệ thống lớn
  - Yêu cầu quản lý cẩn thận cluster Consul

== Monitoring & Logging
<monitoring--logging>
=== Grafana
<grafana>
- #strong[Tổng quan];: Nền tảng phân tích và trực quan hóa dữ liệu mã
  nguồn mở, đặc biệt mạnh mẽ với dữ liệu time-series.

#image("images/2025-03-07-22-37-24.png")

- #strong[Tính năng chính];:
  - #strong[Dashboards];: Giao diện trực quan với nhiều loại biểu đồ
  - #strong[Data sources];: Hỗ trợ nhiều nguồn dữ liệu (Prometheus,
    InfluxDB, Elasticsearch, MySQL, PostgreSQL...)
  - #strong[Alerting];: Hệ thống cảnh báo linh hoạt
  - #strong[Annotations];: Đánh dấu sự kiện trên biểu đồ
  - #strong[User management];: RBAC, LDAP/Active Directory, OAuth
  - #strong[Plugins];: Mở rộng tính năng qua plugins
- #strong[Use cases];:
  - Giám sát hạ tầng
  - Phân tích hiệu suất ứng dụng
  - Theo dõi business metrics
  - IoT analytics
  - Giám sát bảo mật
- #strong[Cấu hình và triển khai];:
  - #strong[Docker];:
    ```bash
    docker run -d -p 3000:3000 --name=grafana grafana/grafana
    ```
  - #strong[Kubernetes];:
    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: grafana
    spec:
      selector:
        matchLabels:
          app: grafana
      template:
        metadata:
          labels:
            app: grafana
        spec:
          containers:
          - name: grafana
            image: grafana/grafana:latest
            ports:
            - containerPort: 3000
    ```
- #strong[Ưu điểm];:
  - Giao diện trực quan mạnh mẽ và thân thiện
  - Hỗ trợ nhiều nguồn dữ liệu
  - Cộng đồng lớn với nhiều dashboard chia sẻ
  - Dễ dàng tùy chỉnh và mở rộng
- #strong[Nhược điểm];:
  - Đôi khi phức tạp khi cấu hình query nâng cao
  - Yêu cầu giải pháp lưu trữ dữ liệu riêng biệt
  - Một số tính năng nâng cao chỉ có trong phiên bản Enterprise

=== Prometheus
<prometheus>
- #strong[Tổng quan];: Hệ thống giám sát và cảnh báo mã nguồn mở, tập
  trung vào reliability và đơn giản.
- #strong[Kiến trúc];:
  - #strong[Prometheus Server];: Thu thập và lưu trữ time series data
  - #strong[Exporters];: Công cụ exposing metrics từ các hệ thống bên
    thứ ba
  - #strong[Alertmanager];: Xử lý cảnh báo
  - #strong[Push Gateway];: Hỗ trợ short-lived jobs
  - #strong[Client Libraries];: Tích hợp ứng dụng với Prometheus
- #strong[Mô hình dữ liệu];:
  - #strong[Metrics];: Đơn vị cơ bản, có tên và nhãn key-value
  - #strong[Types];: Counter, Gauge, Histogram, Summary
  - #strong[PromQL];: Ngôn ngữ truy vấn mạnh mẽ để tương tác với dữ liệu
- #strong[Các exporter phổ biến];:
  - Node Exporter: Metrics về hệ thống (CPU, memory, disk, network)
  - Blackbox Exporter: Giám sát endpoints qua HTTP, HTTPS, DNS, TCP,
    ICMP
  - MySQL Exporter: Metrics từ MySQL server
  - JMX Exporter: Metrics từ Java applications
- #strong[Cấu hình];:
  ```yaml
  global:
    scrape_interval: 15s

  scrape_configs:
    - job_name: 'prometheus'
      static_configs:
        - targets: ['localhost:9090']
    
    - job_name: 'node'
      static_configs:
        - targets: ['node-exporter:9100']

  alerting:
    alertmanagers:
      - static_configs:
        - targets: ['alertmanager:9093']
  ```
- #strong[Service Discovery];:
  - Kubernetes SD
  - Consul SD
  - File-based SD
  - AWS EC2 SD
  - Azure SD
- #strong[Ưu điểm];:
  - Mô hình pull-based đơn giản và đáng tin cậy
  - Lưu trữ dữ liệu hiệu quả
  - Khả năng tự giám sát
  - Tích hợp tốt với Kubernetes
- #strong[Nhược điểm];:
  - Không phù hợp với event logging
  - Retention dài hạn yêu cầu giải pháp lưu trữ bổ sung
  - Đường cong học tập với PromQL
  - Cấu hình phức tạp cho hệ thống lớn

=== Loki
<loki>
- #strong[Tổng quan];: Hệ thống tổng hợp log được thiết kế bởi Grafana
  Labs, lấy cảm hứng từ Prometheus.
- #strong[Đặc điểm chính];:
  - Thiết kế nhẹ và tiết kiệm chi phí
  - Không indexing toàn văn bản, chỉ index metadata
  - Lưu trữ logs theo dạng nén
  - Sử dụng cùng selector và labels như Prometheus
- #strong[Kiến trúc];:
  - #strong[Distributor];: Nhận logs và phân phối đến ingesters
  - #strong[Ingester];: Xử lý và lưu trữ log entries
  - #strong[Querier];: Xử lý các truy vấn từ client
  - #strong[Storage];: Object storage (S3, GCS) cho dữ liệu lâu dài
- #strong[Promtail];: Agent thu thập logs và gửi đến Loki
  ```yaml
  server:
    http_listen_port: 9080

  positions:
    filename: /tmp/positions.yaml

  clients:
    - url: http://loki:3100/loki/api/v1/push

  scrape_configs:
    - job_name: system
      static_configs:
        - targets:
            - localhost
          labels:
            job: varlogs
            __path__: /var/log/*log
  ```
- #strong[LogQL];: Ngôn ngữ truy vấn của Loki
  ```
  {job="varlogs"} |= "error" | json | line_format "{{.message}}"
  ```
- #strong[Triển khai với Helm];:
  ```bash
  helm repo add grafana https://grafana.github.io/helm-charts
  helm install loki grafana/loki-stack
  ```
- #strong[Ưu điểm];:
  - Chi phí lưu trữ thấp
  - Dễ dàng tích hợp với Grafana và hệ sinh thái Prometheus
  - Mở rộng tốt
  - Đơn giản hóa quy trình tìm kiếm log
- #strong[Nhược điểm];:
  - Khả năng tìm kiếm hạn chế hơn so với ELK
  - LogQL ít mạnh mẽ hơn so với Elasticsearch Query DSL
  - Không phù hợp với trường hợp cần phân tích nội dung log phức tạp

=== ELK stack
<elk-stack>
ELK Stack là một bộ công cụ mã nguồn mở gồm ba thành phần chính: Elasticsearch, Logstash và Kibana,
được sử dụng để thu thập, xử lý, lưu trữ và phân tích dữ liệu log theo thời gian thực. 

#image("images/2025-03-07-22-36-34.png")

- #strong[Thành phần];:
  - #strong[Elasticsearch];: Công cụ tìm kiếm và phân tích phân tán
  - #strong[Logstash];: Xử lý và chuyển đổi dữ liệu log
  - #strong[Kibana];: Nền tảng trực quan hóa dữ liệu
  - #strong[Beats];: Lightweight data shippers (Filebeat, Metricbeat,
    Packetbeat, Winlogbeat, ...)

==== Elasticsearch
Elasticsearch là động cơ tìm kiếm và phân tích phân tán, được xây dựng trên
Apache Lucene. Nó lưu trữ dữ liệu dưới dạng các tài liệu JSON và cho phép
tìm kiếm toàn văn bản với hiệu suất cao.
- Đặc điểm chính:
  - Database phân tán dựa trên Lucene
  - Full-text indexing
  - RESTful API
  - Khả năng mở rộng cao

- Cấu trúc:
  - Cluster: Nhóm các node Elasticsearch hoạt động cùng nhau
  - Node: Một máy chủ Elasticsearch đơn lẻ
  - Index: Tập hợp các tài liệu có đặc điểm tương tự
  - Shard: Phân đoạn của index, cho phép phân phối dữ liệu trên nhiều node

==== Logstash
Logstash là công cụ xử lý dữ liệu phía máy chủ để thu thập và chuyển đổi dữ liệu
từ nhiều nguồn khác nhau trước khi đẩy vào Elasticsearch.
  - Input \> Filter \> Output
  - Plugins phong phú
  - Cấu hình:
    ```
    input {
      beats {
        port => 5044
      }
    }

    filter {
      grok {
        match => { "message" => "%{COMBINEDAPACHELOG}" }
      }
      date {
        match => [ "timestamp", "dd/MMM/yyyy:HH:mm:ss Z" ]
      }
    }

    output {
      elasticsearch {
        hosts => ["http://elasticsearch:9200"]
        index => "web-%{+YYYY.MM.dd}"
      }
    }
    ```

==== Kibana
Kibana là nền tảng trực quan hóa và khám phá dữ liệu, giúp tạo dashboard và
biểu đồ từ dữ liệu trong Elasticsearch.
- Tính năng chính:
  - Giao diện web để tìm kiếm, phân tích và trực quan hóa
  - Dashboards
  - Canvas và Lens cho trực quan hóa
  - Management UI cho Elasticsearch
  - Kibana Query Language (KQL)

==== Beats
Beats là các agent nhẹ được cài đặt trên máy chủ để thu thập dữ liệu cụ
thể và gửi trực tiếp đến Elasticsearch hoặc thông qua Logstash.

- Các loại phổ biến:
  - Filebeat: Log files
  - Metricbeat: Metrics
  - Packetbeat: Network data
  - Auditbeat: Audit data
  - Heartbeat: Uptime monitoring

==== Triển khai
  - Docker Compose:
    ```yaml
    services:
      elasticsearch:
        image: docker.elastic.co/elasticsearch/elasticsearch:7.17.0
        environment:
          - discovery.type=single-node
        ports:
          - 9200:9200
      
      kibana:
        image: docker.elastic.co/kibana/kibana:7.17.0
        ports:
          - 5601:5601
        depends_on:
          - elasticsearch
      
      logstash:
        image: docker.elastic.co/logstash/logstash:7.17.0
        ports:
          - 5044:5044
        depends_on:
          - elasticsearch
    ```

=== OpenTelemetry & Jaeger
<opentelemetry--jaeger>
==== OpenTelemetry
<opentelemetry>
#strong[OpenTelemetry] là một bộ công cụ #strong[mã nguồn mở] dùng để
thu thập, xử lý và xuất dữ liệu #strong[quan sát (Observability)] từ các
ứng dụng, bao gồm #strong[logs, metrics và traces];. Nó giúp theo dõi
hiệu suất hệ thống, phát hiện lỗi và cải thiện khả năng quan sát trong
môi trường #strong[phân tán và microservices];. OpenTelemetry hỗ trợ
nhiều nền tảng, tích hợp với các hệ thống giám sát như
#strong[Prometheus, Jaeger, Grafana] và là tiêu chuẩn phổ biến trong
việc theo dõi ứng dụng hiện đại.


#image("images/2025-03-07-22-34-57.png")

#strong[Thành phần chính:]

- API & SDK: Các giao diện và thư viện để lập trình viên công cụ hóa mã
  nguồn
- Collector: Nhận, xử lý và xuất dữ liệu telemetry đến nhiều backend
  khác nhau
- Instrumentation: Thư viện tự động công cụ hóa cho các framework và thư
  viện phổ biến

#strong[Dữ liệu thu thập:]

- Traces: Thông tin về các yêu cầu khi chúng di chuyển qua dịch vụ và
  thành phần
- Metrics: Số liệu về hiệu suất và sức khỏe của hệ thống
- Logs: Bản ghi sự kiện và thông tin gỡ lỗi

#strong[Lợi ích:]

- Triển khai và thiết lập chuẩn hóa cho telemetry
- Tích hợp với nhiều backend giám sát và phân tích
- Giảm sự phụ thuộc vào nhà cung cấp với định dạng dữ liệu tiêu chuẩn
- Hỗ trợ nhiều ngôn ngữ lập trình và framework

#strong[Triển khai OpenTelemetry:]

+ Công cụ hóa ứng dụng với OpenTelemetry SDK
+ Cấu hình OpenTelemetry Collector
+ Định cấu hình xuất dữ liệu đến backend phân tích (Jaeger, Prometheus,
  v.v.)
+ Thiết lập sampling và lọc để quản lý khối lượng dữ liệu

==== Jaeger
<jaeger>
Jaeger là hệ thống tracing phân tán mã nguồn mở, được tạo ra bởi Uber và
hiện là dự án tốt nghiệp của Cloud Native Computing Foundation (CNCF).

#image("images/2025-03-07-22-35-28.png")

#strong[Kiến trúc:]

- Jaeger Client: Thư viện được tích hợp vào ứng dụng để tạo span
- Jaeger Agent: Dịch vụ mạng nhận span từ client và chuyển tiếp đến
  collector
- Jaeger Collector: Nhận trace từ agent và xử lý để lưu trữ
- Storage: Backend lưu trữ (Elasticsearch, Cassandra, hoặc Badger)
- Jaeger Query: Dịch vụ truy vấn từ storage và phục vụ UI
- Jaeger UI: Giao diện người dùng để tìm kiếm và phân tích trace

#strong[Tính năng chính:]

- Truy tìm gốc của yêu cầu trễ và lỗi
- Phân tích luồng dịch vụ và phát hiện điểm nghẽn
- Theo dõi mối quan hệ nhân quả giữa các sự kiện
- Tương thích với chuẩn OpenTracing và OpenTelemetry

#strong[Các trường hợp sử dụng:]

- Giám sát độ trễ giữa các dịch vụ trong kiến trúc microservice
- Phân tích gốc rễ nguyên nhân của lỗi hệ thống
- Tối ưu hóa hiệu suất dựa trên dữ liệu thực tế
- Hiểu được các phụ thuộc giữa các dịch vụ

#strong[Triển khai Jaeger với Kubernetes:]

+ Triển khai bằng Jaeger Operator
+ Cấu hình Jaeger Agent như sidecar trong pod
+ Tích hợp với OpenTelemetry Collector
+ Thiết lập kết nối với backend lưu trữ

= Xây dựng hệ thống với .NET Core
<xây-dựng-hệ-thống-với-net-core>
== ASP.NET Core
<aspnet-core>
ASP.NET Core là một framework mã nguồn mở, đa nền tảng để xây dựng các
ứng dụng web hiện đại kết nối Internet. ASP.NET Core là phiên bản thiết
kế lại của ASP.NET 4.x với những thay đổi kiến trúc mang lại framework
gọn nhẹ hơn và module hóa.

ASP.NET Core cung cấp các lợi ích sau:

- Hỗ trợ đa nền tảng: có thể chạy trên Windows, macOS và Linux
- Hiệu suất cao hơn so với ASP.NET 4.x
- Hỗ trợ phát triển và chạy đồng thời nhiều phiên bản
- Hệ thống cấu hình linh hoạt dựa trên môi trường
- Tích hợp với các hệ thống container hiện đại
- Hỗ trợ API RESTful, MVC, Razor Pages, Blazor và nhiều mô hình khác
- Tích hợp với các dịch vụ đám mây một cách liền mạch

=== Service & Dependency Injection
<service--dependency-injection>
Dependency Injection (DI) là một kỹ thuật thiết kế phần mềm quan trọng
và là một phần cốt lõi của ASP.NET Core. Framework này cung cấp
container DI tích hợp sẵn, giúp quản lý các dependency và vòng đời của
các service.

ASP.NET Core hỗ trợ ba kiểu đăng ký service:

+ #strong[Transient];: Dịch vụ được tạo mới mỗi khi được yêu cầu. Phù
  hợp với các dịch vụ nhẹ, không trạng thái.

```cs
services.AddTransient<ITransientService, TransientService>();
```

#block[
#set enum(numbering: "1.", start: 2)
+ #strong[Scoped];: Dịch vụ được tạo một lần cho mỗi request. Rất hữu
  ích cho các dịch vụ cần duy trì trạng thái trong suốt một request.
]

```cs
services.AddScoped<IScopedService, ScopedService>();
```

#block[
#set enum(numbering: "1.", start: 3)
+ #strong[Singleton];: Dịch vụ được tạo một lần duy nhất và được sử dụng
  xuyên suốt vòng đời của ứng dụng.
]

```cs
services.AddSingleton<ISingletonService, SingletonService>();
```

DI trong ASP.NET Core thúc đẩy nguyên tắc thiết kế hướng đến interface,
giúp tăng khả năng kiểm thử và bảo trì mã nguồn. Nó cũng hỗ trợ đăng ký
dịch vụ theo nhiều cách khác nhau, bao gồm đăng ký instance, factory
function, hoặc thông qua interface.

=== Middleware
<middleware>
Middleware là các thành phần phần mềm được kết nối với nhau trong
pipeline xử lý HTTP của ASP.NET Core. Mỗi thành phần middleware thực
hiện một chức năng cụ thể trong quá trình xử lý request và response.

Pipeline middleware hoạt động theo mô hình \"first in, first out\"
(FIFO), nơi mỗi middleware có thể:

- Xử lý request trước khi chuyển đến middleware tiếp theo
- Quyết định có chuyển request đến middleware tiếp theo hay không
- Thực hiện các tác vụ sau khi middleware tiếp theo đã xử lý xong

Một middleware điển hình có thể được triển khai như sau:

```cs
public class CustomMiddleware
{
    private readonly RequestDelegate _next;

    public CustomMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        // Logic xử lý trước khi chuyển đến middleware tiếp theo
        
        await _next(context); // Gọi middleware tiếp theo
        
        // Logic xử lý sau khi middleware tiếp theo đã xử lý xong
    }
}

// Mở rộng để đăng ký middleware
public static class CustomMiddlewareExtensions
{
    public static IApplicationBuilder UseCustomMiddleware(this IApplicationBuilder builder)
    {
        return builder.UseMiddleware<CustomMiddleware>();
    }
}
```

ASP.NET Core cung cấp nhiều middleware tích hợp sẵn cho các tác vụ phổ
biến như xác thực, phân quyền, định tuyến, xử lý ngoại lệ, nén dữ liệu,
phục vụ tệp tĩnh và CORS.

=== Caching
<caching>
Caching là kỹ thuật quan trọng để tối ưu hóa hiệu suất ứng dụng ASP.NET
Core. Framework này cung cấp nhiều lựa chọn caching khác nhau:

+ #strong[In-Memory Cache];: Lưu trữ dữ liệu trong bộ nhớ của máy chủ.
  Đơn giản nhưng chỉ phù hợp cho ứng dụng đơn server.

```cs
services.AddMemoryCache();
// Sử dụng
var cacheEntry = _cache.GetOrCreate(cacheKey, entry =>
{
    entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(10);
    return ComputeExpensiveValue();
});
```

#block[
#set enum(numbering: "1.", start: 2)
+ #strong[Distributed Cache];: Cho phép chia sẻ cache giữa nhiều
  instance của ứng dụng. ASP.NET Core hỗ trợ nhiều triển khai, bao gồm:
  - SQL Server
  - Redis
  - NCache
]

```cs
// Đăng ký Redis Cache
services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = "localhost:6379";
    options.InstanceName = "MyApplicationCache";
});

// Sử dụng
await _distributedCache.SetStringAsync(cacheKey, jsonData, options);
```

#block[
#set enum(numbering: "1.", start: 3)
+ #strong[Response Caching];: Cache các HTTP response để tránh phải xử
  lý lại các request giống nhau.
]

```cs
services.AddResponseCaching();
// Trong Controller
[ResponseCache(Duration = 60)]
public IActionResult Index()
{
    return View();
}
```

#block[
#set enum(numbering: "1.", start: 4)
+ #strong[Data Caching with Entity Framework];: Cache kết quả truy vấn
  để giảm tải database.
]

```cs
var blogs = await _context.Blogs
    .Where(b => b.Rating > 3)
    .TagWith("GetHighRatedBlogs")
    .ToListAsync();
```

ASP.NET Core cũng hỗ trợ caching phía client thông qua HTTP headers và
cơ chế caching tùy chỉnh.

=== SignalR
<signalr>
ASP.NET Core SignalR là một thư viện mạnh mẽ cho phép giao tiếp hai
chiều thời gian thực giữa server và client. SignalR đặc biệt hữu ích cho
các ứng dụng cần cập nhật dữ liệu tức thì như trò chuyện, bảng điều
khiển, trò chơi và thông báo.

SignalR tự động xử lý kết nối, quản lý và mở rộng. Nó cũng tự động chọn
phương thức truyền tải phù hợp nhất dựa trên khả năng của server và
client:

- WebSockets (ưu tiên khi được hỗ trợ)
- Server-Sent Events
- Long Polling

Cách thiết lập SignalR:

```cs
// Đăng ký dịch vụ
services.AddSignalR();

// Cấu hình endpoint
app.UseEndpoints(endpoints =>
{
    endpoints.MapHub<ChatHub>("/chatHub");
});
```

Triển khai Hub:

```cs
public class ChatHub : Hub
{
    public async Task SendMessage(string user, string message)
    {
        // Gửi tin nhắn đến tất cả client
        await Clients.All.SendAsync("ReceiveMessage", user, message);
        
        // Hoặc gửi đến một nhóm cụ thể
        // await Clients.Group("groupName").SendAsync("ReceiveMessage", user, message);
    }
    
    public async Task JoinGroup(string groupName)
    {
        await Groups.AddToGroupAsync(Context.ConnectionId, groupName);
    }
    
    public override async Task OnConnectedAsync()
    {
        // Xử lý khi client kết nối
        await base.OnConnectedAsync();
    }
}
```

SignalR trong ASP.NET Core còn cung cấp nhiều tính năng nâng cao như xác
thực, phân quyền, mã hóa, mở rộng quy mô với Redis backplane, và
streaming dữ liệu lớn.

== ORM
<orm>
ORM (Object-Relational Mapping) là kỹ thuật cho phép làm việc với cơ sở
dữ liệu quan hệ thông qua các đối tượng. .NET Core hỗ trợ nhiều
framework ORM, mỗi framework có điểm mạnh và phù hợp với các tình huống
khác nhau.

=== Entity Framework Core
<entity-framework-core>
Entity Framework Core (EF Core) là ORM hiện đại, nhẹ, mở rộng được và đa
nền tảng của Microsoft. Nó là phiên bản thiết kế lại hoàn toàn của
Entity Framework 6.x.

EF Core sử dụng mô hình làm việc thông qua DbContext và các entity được
định nghĩa dưới dạng class:

```cs
public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    { }
    
    public DbSet<Blog> Blogs { get; set; }
    public DbSet<Post> Posts { get; set; }
    
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Blog>()
            .HasMany(b => b.Posts)
            .WithOne(p => p.Blog)
            .HasForeignKey(p => p.BlogId);
            
        modelBuilder.Entity<Blog>()
            .HasIndex(b => b.Url)
            .IsUnique();
    }
}
```

EF Core hỗ trợ hai cách tiếp cận chính:

+ #strong[Code First];: Định nghĩa các entity bằng code và tạo/cập nhật
  database từ đó.
+ #strong[Database First];: Tạo các entity từ database hiện có.

EF Core hỗ trợ nhiều tính năng quan trọng:

- #strong[Migrations];: Quản lý phiên bản schema database
- #strong[Change Tracking];: Theo dõi thay đổi của entity
- #strong[Lazy Loading];: Tải dữ liệu liên quan theo yêu cầu
- #strong[Eager Loading];: Tải trước dữ liệu liên quan
- #strong[Query Translation];: Chuyển đổi LINQ thành SQL
- #strong[Concurrency Resolution];: Xử lý xung đột đồng thời

EF Core hỗ trợ nhiều database provider như SQL Server, SQLite,
PostgreSQL, MySQL, Oracle và nhiều provider khác từ cộng đồng.

=== Dapper
<dapper>
Dapper là một micro-ORM đơn giản, hiệu suất cao, tập trung vào tốc độ và
tinh gọn. Được phát triển bởi đội ngũ Stack Overflow, Dapper cung cấp
phương thức mở rộng cho IDbConnection giúp ánh xạ dữ liệu từ câu truy
vấn SQL vào các đối tượng.

Ưu điểm chính của Dapper:

- #strong[Hiệu suất cực kỳ cao];: Gần với ADO.NET thuần túy
- #strong[Đơn giản];: API nhỏ gọn, dễ học
- #strong[Kiểm soát SQL];: Viết câu truy vấn SQL trực tiếp
- #strong[Hỗ trợ thủ tục lưu trữ và các tính năng database nâng cao]

Ví dụ sử dụng Dapper:

```cs
public async Task<IEnumerable<Product>> GetProductsByCategoryAsync(int categoryId)
{
    using var connection = new SqlConnection(_connectionString);
    await connection.OpenAsync();
    
    return await connection.QueryAsync<Product>(
        "SELECT * FROM Products WHERE CategoryId = @CategoryId",
        new { CategoryId = categoryId }
    );
}

public async Task<int> CreateProductAsync(Product product)
{
    using var connection = new SqlConnection(_connectionString);
    await connection.OpenAsync();
    
    return await connection.ExecuteAsync(
        "INSERT INTO Products (Name, Price, CategoryId) VALUES (@Name, @Price, @CategoryId)",
        product
    );
}
```

Dapper còn hỗ trợ:

- #strong[Multi-mapping];: Ánh xạ một hàng vào nhiều đối tượng
- #strong[Multi-result];: Xử lý nhiều tập kết quả từ một câu truy vấn
- #strong[Transactions];: Quản lý giao dịch
- #strong[Async];: Hỗ trợ đầy đủ các phương thức bất đồng bộ

Dapper là lựa chọn tuyệt vời khi cần hiệu suất cao và kiểm soát SQL hoàn
toàn.

=== NHibernate
<nhibernate>
NHibernate là một ORM trưởng thành, đầy đủ tính năng cho .NET, là bản
chuyển đổi từ Hibernate trong Java. NHibernate cung cấp một giải pháp
toàn diện cho việc ánh xạ object-relational.

Cấu trúc của NHibernate bao gồm:

- #strong[SessionFactory];: Tạo và quản lý các Session
- #strong[Session];: Cung cấp các phương thức CRUD và truy vấn
- #strong[Mapping];: Định nghĩa cách ánh xạ đối tượng vào database

Ví dụ cấu hình và sử dụng NHibernate:

```cs
// Cấu hình
var configuration = new Configuration();
configuration.Configure("hibernate.cfg.xml");
configuration.AddAssembly(typeof(Product).Assembly);

// Tạo SessionFactory
var sessionFactory = configuration.BuildSessionFactory();

// Truy vấn dữ liệu
using (var session = sessionFactory.OpenSession())
using (var transaction = session.BeginTransaction())
{
    var products = session.Query<Product>()
        .Where(p => p.Category.Id == categoryId)
        .ToList();
        
    transaction.Commit();
    return products;
}
```

NHibernate có những ưu điểm:

- #strong[Mapping linh hoạt];: Hỗ trợ XML, Fluent API và Attributes
- #strong[Caching nhiều cấp độ];: Session cache và second-level cache
- #strong[HQL/LINQ];: Hỗ trợ nhiều cách truy vấn
- #strong[Lazy Loading];: Tải dữ liệu chỉ khi cần
- #strong[Interceptors];: Mở rộng hành vi mặc định

NHibernate phù hợp với các dự án lớn, phức tạp cần nhiều tính năng nâng
cao của ORM.

=== So sánh
<so-sánh>
Khi lựa chọn ORM cho dự án .NET Core, cần xem xét nhiều yếu tố. Dưới đây
là so sánh giữa Entity Framework Core, Dapper và NHibernate:

#strong[Hiệu suất];:

- Dapper nhanh nhất và gần với ADO.NET thuần túy
- EF Core hiệu suất tốt hơn nhiều so với EF6
- NHibernate có hiệu suất tốt nhưng thường chậm hơn Dapper

#strong[Đường cong học tập];:

- Dapper dễ học nhất với API đơn giản
- EF Core có độ phức tạp trung bình, được tài liệu hóa tốt
- NHibernate có đường cong học tập dốc nhất

#strong[Tính năng];:

- EF Core cung cấp cân bằng tốt giữa tính năng và đơn giản
- NHibernate có nhiều tính năng nâng cao nhất
- Dapper tối giản nhưng rất linh hoạt

#strong[Hỗ trợ database];:

- EF Core hỗ trợ nhiều loại database nhất qua providers
- Dapper hoạt động với bất kỳ database nào có ADO.NET provider
- NHibernate cũng hỗ trợ nhiều database

#strong[Kiểm soát SQL];:

- Dapper cung cấp kiểm soát SQL tuyệt đối
- NHibernate cho phép tinh chỉnh SQL khi cần
- EF Core cũng cho phép can thiệp SQL nhưng ít trực tiếp hơn

#strong[Khi nào sử dụng];:

- #strong[Entity Framework Core];: Phù hợp với hầu hết các dự án, đặc
  biệt khi cần cân bằng giữa năng suất và hiệu suất
- #strong[Dapper];: Lý tưởng cho các thành phần cần hiệu suất cực cao,
  API, microservices
- #strong[NHibernate];: Tốt cho các ứng dụng doanh nghiệp lớn với logic
  domain phức tạp

Trong thực tế, nhiều dự án kết hợp các ORM, sử dụng EF Core cho phần lớn
công việc và Dapper cho các truy vấn cần hiệu suất cao.

== Architecture
<architecture>
Kiến trúc phần mềm định nghĩa cấu trúc tổng thể của hệ thống, tổ chức
các thành phần và mối quan hệ giữa chúng. Trong hệ sinh thái .NET Core,
có nhiều mẫu kiến trúc phổ biến, mỗi mẫu có điểm mạnh và trường hợp sử
dụng riêng.

=== Clean Architecture
<clean-architecture>
Clean Architecture là một mẫu kiến trúc được đề xuất bởi Robert C.
Martin (Uncle Bob). Mục tiêu chính là tạo ra các hệ thống:

- #strong[Độc lập với framework];: Kiến trúc không phụ thuộc vào sự tồn
  tại của thư viện
- #strong[Có thể kiểm thử];: Logic nghiệp vụ có thể được kiểm thử mà
  không cần UI, database, web server
- #strong[Độc lập với UI];: UI có thể thay đổi mà không ảnh hưởng đến
  phần còn lại của hệ thống
- #strong[Độc lập với database];: Có thể thay đổi database mà không ảnh
  hưởng logic nghiệp vụ
- #strong[Độc lập với bất kỳ thành phần bên ngoài nào]

#image("images/2025-03-07-22-38-13.png")

Clean Architecture trong .NET Core thường được tổ chức thành các lớp
đồng tâm:

+ #strong[Domain Layer];: Ở trung tâm, chứa các entities, value objects,
  và domain events. Không phụ thuộc vào bất kỳ lớp nào khác.

```cs
public class Order
{
    public Guid Id { get; private set; }
    public Customer Customer { get; private set; }
    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();
    public OrderStatus Status { get; private set; }
    
    private readonly List<OrderItem> _items = new List<OrderItem>();
    
    public Order(Customer customer)
    {
        Id = Guid.NewGuid();
        Customer = customer;
        Status = OrderStatus.Draft;
    }
    
    public void AddItem(Product product, int quantity)
    {
        var existingItem = _items.FirstOrDefault(i => i.Product.Id == product.Id);
        if (existingItem != null)
        {
            existingItem.IncreaseQuantity(quantity);
        }
        else
        {
            _items.Add(new OrderItem(this, product, quantity));
        }
    }
    
    public void ConfirmOrder()
    {
        // Domain logic và validation
        if (!Items.Any())
            throw new OrderingDomainException("Order must have at least one item");
            
        Status = OrderStatus.Confirmed;
    }
}
```

#block[
#set enum(numbering: "1.", start: 2)
+ #strong[Application Layer];: Chứa use cases, interfaces repository và
  services. Điều phối luồng dữ liệu từ và đến domain entities.
]

```cs
public class CreateOrderCommand : IRequest<Guid>
{
    public string CustomerId { get; set; }
    public List<OrderItemDto> Items { get; set; }
}

public class CreateOrderCommandHandler : IRequestHandler<CreateOrderCommand, Guid>
{
    private readonly IOrderRepository _orderRepository;
    private readonly ICustomerRepository _customerRepository;
    private readonly IProductRepository _productRepository;
    
    public CreateOrderCommandHandler(
        IOrderRepository orderRepository,
        ICustomerRepository customerRepository,
        IProductRepository productRepository)
    {
        _orderRepository = orderRepository;
        _customerRepository = customerRepository;
        _productRepository = productRepository;
    }
    
    public async Task<Guid> Handle(CreateOrderCommand request, CancellationToken cancellationToken)
    {
        var customer = await _customerRepository.GetByIdAsync(request.CustomerId);
        if (customer == null)
            throw new NotFoundException(nameof(Customer), request.CustomerId);
            
        var order = new Order(customer);
        
        foreach (var item in request.Items)
        {
            var product = await _productRepository.GetByIdAsync(item.ProductId);
            if (product == null)
                throw new NotFoundException(nameof(Product), item.ProductId);
                
            order.AddItem(product, item.Quantity);
        }
        
        order.ConfirmOrder();
        
        _orderRepository.Add(order);
        await _orderRepository.UnitOfWork.SaveChangesAsync(cancellationToken);
        
        return order.Id;
    }
}
```

#block[
#set enum(numbering: "1.", start: 3)
+ #strong[Infrastructure Layer];: Triển khai các interfaces được định
  nghĩa trong application layer. Chứa database context, repositories,
  external services, logging, v.v.
]

```cs
public class OrderRepository : IOrderRepository
{
    private readonly ApplicationDbContext _context;
    
    public OrderRepository(ApplicationDbContext context)
    {
        _context = context;
        UnitOfWork = context;
    }
    
    public IUnitOfWork UnitOfWork => _context;
    
    public async Task<Order> GetByIdAsync(Guid id)
    {
        return await _context.Orders
            .Include(o => o.Customer)
            .Include(o => o.Items)
            .ThenInclude(i => i.Product)
            .FirstOrDefaultAsync(o => o.Id == id);
    }
    
    public Order Add(Order order)
    {
        return _context.Orders.Add(order).Entity;
    }
}
```

#block[
#set enum(numbering: "1.", start: 4)
+ #strong[Presentation Layer];: Web API, MVC UI, hoặc Blazor. Chuyển đổi
  dữ liệu từ application layer thành định dạng phù hợp với người dùng.
]

```cs
[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    private readonly IMediator _mediator;
    
    public OrdersController(IMediator mediator)
    {
        _mediator = mediator;
    }
    
    [HttpPost]
    public async Task<ActionResult<Guid>> Create(CreateOrderCommand command)
    {
        var orderId = await _mediator.Send(command);
        return Ok(orderId);
    }
}
```

Clean Architecture mang lại nhiều lợi ích:

- Dễ bảo trì và mở rộng
- Cô lập các thay đổi
- Kiểm thử dễ dàng
- Độc lập với các chi tiết triển khai
- Tập trung vào business logic

Tuy nhiên, nó cũng có thể dẫn đến quá nhiều abstraction và phức tạp cho
các ứng dụng nhỏ.

=== Vertical Slice Architecture
<vertical-slice-architecture>
Vertical Slice Architecture (VSA) là một cách tiếp cận khác biệt so với
kiến trúc phân lớp truyền thống. Thay vì tổ chức code theo các lớp kỹ
thuật (controllers, services, repositories), VSA tổ chức code theo tính
năng hoặc \"vertical slice\" của ứng dụng.

Nguyên tắc cơ bản:

- #strong[Tổ chức theo tính năng];: Mỗi vertical slice đại diện cho một
  tính năng hoàn chỉnh
- #strong[Giảm thiểu sự phụ thuộc giữa các slice];: Mỗi slice nên độc
  lập càng nhiều càng tốt
- #strong[Tách biệt mối quan tâm kỹ thuật trong phạm vi slice];: Mỗi
  slice chịu trách nhiệm về mọi khía cạnh của tính năng

#image("images/2025-03-07-22-38-38.png")

Trong .NET Core, VSA thường được triển khai bằng cách sử dụng thư viện
MediatR và CQRS (Command Query Responsibility Segregation):

```cs
// Features/Products/List/
public class ListProductsQuery : IRequest<List<ProductDto>> 
{
    public string SearchTerm { get; set; }
    public int? CategoryId { get; set; }
}

public class ListProductsQueryHandler : IRequestHandler<ListProductsQuery, List<ProductDto>>
{
    private readonly ApplicationDbContext _db;
    private readonly IMapper _mapper;
    
    public ListProductsQueryHandler(ApplicationDbContext db, IMapper mapper)
    {
        _db = db;
        _mapper = mapper;
    }
    
    public async Task<List<ProductDto>> Handle(ListProductsQuery request, CancellationToken cancellationToken)
    {
        var query = _db.Products.AsQueryable();
        
        if (!string.IsNullOrEmpty(request.SearchTerm))
        {
            query = query.Where(p => p.Name.Contains(request.SearchTerm));
        }
        
        if (request.CategoryId.HasValue)
        {
            query = query.Where(p => p.CategoryId == request.CategoryId.Value);
        }
        
        var products = await query
            .OrderBy(p => p.Name)
            .ToListAsync(cancellationToken);
            
        return _mapper.Map<List<ProductDto>>(products);
    }
}

// Features/Products/Create/
public class CreateProductCommand : IRequest<int>
{
    public string Name { get; set; }
    public decimal Price { get; set; }
    public int CategoryId { get; set; }
}

public class CreateProductCommandValidator : AbstractValidator<CreateProductCommand>
{
    public CreateProductCommandValidator()
    {
        RuleFor(p => p.Name).NotEmpty().MaximumLength(100);
        RuleFor(p => p.Price).GreaterThan(0);
        RuleFor(p => p.CategoryId).GreaterThan(0);
    }
}

public class CreateProductCommandHandler : IRequestHandler<CreateProductCommand, int>
{
    private readonly ApplicationDbContext _db;
    
    public CreateProductCommandHandler(ApplicationDbContext db)
    {
        _db = db;
    }
    
    public async Task<int> Handle(CreateProductCommand request, CancellationToken cancellationToken)
    {
        var product = new Product
        {
            Name = request.Name,
            Price = request.Price,
            CategoryId = request.CategoryId
        };
        
        _db.Products.Add(product);
        await _db.SaveChangesAsync(cancellationToken);
        
        return product.Id;
    }
}

// API Controller
[ApiController]
[Route("api/products")]
public class ProductsController : ControllerBase
{
    private readonly IMediator _mediator;
    
    public ProductsController(IMediator mediator)
    {
        _mediator = mediator;
    }
    
    [HttpGet]
    public async Task<ActionResult<List<ProductDto>>> List([FromQuery] ListProductsQuery query)
    {
        return await _mediator.Send(query);
    }
    
    [HttpPost]
    public async Task<ActionResult<int>> Create(CreateProductCommand command)
    {
        return await _mediator.Send(command);
    }
}
```

Ưu điểm của VSA:

- #strong[Tập trung vào tính năng];: Dễ dàng tìm và hiểu tất cả code
  liên quan đến một tính năng
- #strong[Giảm thiểu sự phụ thuộc vượt ranh giới];: Sửa đổi một tính
  năng ít ảnh hưởng đến tính năng khác
- #strong[Refactoring đơn giản];: Có thể refactor một tính năng mà không
  ảnh hưởng đến các tính năng khác
- #strong[Phát triển song song];: Các team có thể làm việc trên các tính
  năng khác nhau độc lập

Nhược điểm:

- Có thể dẫn đến trùng lặp code
- Khó duy trì tính nhất quán giữa các slice
- Tiềm ẩn tạo ra các \"island of functionality\" thiếu sự liên kết

VSA đặc biệt phù hợp với các ứng dụng lớn, có nhiều tính năng độc lập và
dự án có nhiều đội phát triển làm việc song song.

== Deployment
<deployment>
Triển khai ứng dụng .NET Core có nhiều lựa chọn khác nhau, từ các phương
pháp truyền thống đến các giải pháp container và cloud-native hiện đại.
Những giải pháp này cho phép tối ưu hóa việc triển khai, mở rộng quy mô
và quản lý ứng dụng trong môi trường sản xuất.

=== Docker/Kubernetes
<dockerkubernetes>
Docker và Kubernetes là hai công nghệ container quan trọng đã thay đổi
cách chúng ta triển khai ứng dụng .NET Core.

#strong[Docker] cho phép đóng gói ứng dụng và tất cả dependencies của nó
vào một container độc lập, đảm bảo ứng dụng chạy nhất quán trong bất kỳ
môi trường nào.

Một Dockerfile cơ bản cho ứng dụng ASP.NET Core:

```dockerfile
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["MyApp.csproj", "./"]
RUN dotnet restore "MyApp.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "MyApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "MyApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyApp.dll"]
```

Sử dụng Docker với .NET Core mang lại nhiều lợi ích:

- Môi trường đồng nhất từ phát triển đến sản xuất
- Cô lập ứng dụng và dependencies
- Triển khai nhanh và nhất quán
- Hiệu quả về tài nguyên
- Tích hợp tốt với CI/CD

#strong[Kubernetes] là nền tảng điều phối container mạnh mẽ, giúp quản
lý và mở rộng các ứng dụng container hóa.

Ví dụ về file YAML triển khai ứng dụng ASP.NET Core trên Kubernetes:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: myapp
        image: myregistry.azurecr.io/myapp:latest
        ports:
        - containerPort: 80
        resources:
          limits:
            cpu: "1"
            memory: "512Mi"
          requests:
            cpu: "0.5"
            memory: "256Mi"
        env:
        - name: ASPNETCORE_ENVIRONMENT
          value: "Production"
        livenessProbe:
          httpGet:
            path: /health/live
            port: 80
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health/ready
            port: 80
          initialDelaySeconds: 15
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
spec:
  selector:
    app: myapp
  ports:
  - port: 80
    targetPort: 80
  type: LoadBalancer
```

Kubernetes cung cấp nhiều tính năng cho ứng dụng .NET Core:

- #strong[Tự động mở rộng];: Tăng/giảm số lượng pods dựa trên tải
- #strong[Self-healing];: Tự động khởi động lại containers bị lỗi
- #strong[Rolling updates];: Cập nhật ứng dụng không gián đoạn
- #strong[Service discovery];: Định vị services một cách năng động
- #strong[Load balancing];: Phân phối tải giữa các instances
- #strong[Secrets management];: Quản lý thông tin nhạy cảm an toàn

.NET Core hỗ trợ tốt cho Docker và Kubernetes thông qua:

- Hình ảnh container chính thức tối ưu hóa
- Health checks tích hợp cho liveness và readiness probes
- Configuration providers cho Kubernetes ConfigMaps và Secrets
- Tích hợp logging với container logs

Kết hợp .NET Core, Docker và Kubernetes tạo nền tảng mạnh mẽ cho việc
xây dựng và triển khai các ứng dụng microservices có khả năng mở rộng
cao.

=== Aspire
<aspire>
.NET Aspire là một nền tảng mới từ Microsoft giới thiệu vào cuối năm
2023, được thiết kế để đơn giản hóa quá trình xây dựng, triển khai và
vận hành các ứng dụng phân tán, cloud-native .NET.

Aspire cung cấp một stack toàn diện cho phát triển cloud-native bao gồm:

- #strong[Orchestrator];: Quản lý và chạy các thành phần ứng dụng
- #strong[Dashboard];: Giao diện trực quan để giám sát và gỡ lỗi
- #strong[Components Library];: Các thành phần tái sử dụng cho dịch vụ
  phổ biến
- #strong[Mẫu ứng dụng];: Các blueprints để bắt đầu nhanh chóng

Ví dụ về cách thiết lập một dự án .NET Aspire:

```cs
// AppHost.cs
public class Program
{
    public static void Main(string[] args)
    {
        var builder = Host.CreateApplicationBuilder(args);
        builder.Environment.ContentRootPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

        var appHost = builder.Build();
        
        var catalogApi = appHost.CreateProject("catalogapi", "CatalogApi");
        var basketApi = appHost.CreateProject("basketapi", "BasketApi");
        var webApp = appHost.CreateProject("webapp", "WebApp");
        
        // Thêm Redis cho BasketApi
        var redis = appHost.AddRedis("redis");
        basketApi.WithReference(redis);
        
        // Thêm SQL Server cho CatalogApi
        var sqlServer = appHost.AddSqlServer("sql").AddDatabase("CatalogDb");
        catalogApi.WithReference(sqlServer);
        
        // Cấu hình dependency giữa các services
        webApp.WithReference(catalogApi);
        webApp.WithReference(basketApi);
        
        appHost.Run();
    }
}
```

Trong các dự án cụ thể, Aspire Components cung cấp extension methods để
cấu hình services:

```cs
// BasketApi/Program.cs
var builder = WebApplication.CreateBuilder(args);

// Thêm Redis cho caching
builder.AddRedisClient("redis");

// Đăng ký health checks
builder.Services.AddHealthChecks()
    .AddRedis(builder.Configuration.GetConnectionString("redis"));

// ...
```

.NET Aspire mang lại nhiều lợi ích:

- #strong[Phát triển đơn giản];: Xây dựng ứng dụng phân tán mà không cần
  cấu hình phức tạp
- #strong[Thiết kế cloud-native];: Hỗ trợ các mẫu thiết kế hiện đại như
  health checks, telemetry
- #strong[Developer experience nâng cao];: Dashboard trực quan để giám
  sát và gỡ lỗi
- #strong[Khả năng mở rộng];: Dễ dàng thêm services mới và tích hợp với
  hệ sinh thái .NET
- #strong[Đường dẫn rõ ràng đến Kubernetes];: Cung cấp các công cụ để
  tạo manifest Kubernetes

Aspire đặc biệt phù hợp với các trường hợp:

- Phát triển ứng dụng phân tán mới (microservices)
- Hiện đại hóa ứng dụng .NET hiện có
- Cung cấp môi trường phát triển local gần với production
- Tối ưu hóa quá trình từ phát triển đến sản xuất

.NET Aspire đang ngày càng phát triển và đã trở thành một phần quan
trọng trong chiến lược cloud-native của Microsoft cho .NET.

== Thiết kế hệ thống lớn
<thiết-kế-hệ-thống-lớn>
Thiết kế hệ thống lớn với .NET Core yêu cầu sự kết hợp của nhiều nguyên
tắc, mẫu và kỹ thuật để đảm bảo khả năng mở rộng, bảo trì và hiệu suất.
Dưới đây là các khía cạnh quan trọng cần xem xét:

=== Kiến trúc Microservices
<kiến-trúc-microservices>
Microservices là một phong cách kiến trúc phân tách ứng dụng thành các
dịch vụ nhỏ, có thể triển khai độc lập. .NET Core rất phù hợp cho kiến
trúc microservices với:

- #strong[Service Discovery];: Sử dụng Consul, Kubernetes hoặc Azure
  Service Fabric
- #strong[API Gateway];: Triển khai với YARP, Ocelot hoặc Azure API
  Management
- #strong[Communication];: gRPC cho RPC hiệu suất cao, REST API cho
  tương tác web
- #strong[Event Messaging];: RabbitMQ, Azure Service Bus, Kafka cho giao
  tiếp bất đồng bộ

Ví dụ về kiến trúc e-commerce với microservices:

- Product Catalog Service
- Inventory Service
- Order Service
- Payment Service
- User Service
- Notification Service

Mỗi service có database riêng, API riêng và có thể được phát triển,
triển khai và mở rộng độc lập.

=== Domain-Driven Design (DDD)
<domain-driven-design-ddd>
DDD là phương pháp thiết kế phần mềm tập trung vào mô hình hóa miền
nghiệp vụ phức tạp, rất phù hợp với hệ thống lớn:

- #strong[Bounded Contexts];: Ranh giới rõ ràng trong mô hình domain
- #strong[Ubiquitous Language];: Ngôn ngữ chung giữa các chuyên gia
  nghiệp vụ và nhà phát triển
- #strong[Aggregates];: Nhóm các entities và value objects liên quan
- #strong[Domain Events];: Truyền thông tin về các sự kiện quan trọng
  trong domain

Ví dụ về triển khai DDD trong .NET Core:

```cs
// Domain Event
public class OrderPlacedDomainEvent : IDomainEvent
{
    public Guid OrderId { get; }
    public DateTime PlacedDate { get; }
    
    public OrderPlacedDomainEvent(Guid orderId, DateTime placedDate)
    {
        OrderId = orderId;
        PlacedDate = placedDate;
    }
}

// Aggregate Root
public class Order : Entity, IAggregateRoot
{
    public Guid Id { get; private set; }
    public OrderStatus Status { get; private set; }
    public CustomerId CustomerId { get; private set; }
    public Money TotalAmount { get; private set; }
    public Address ShippingAddress { get; private set; }
    public IReadOnlyCollection<OrderItem> Items => _items.AsReadOnly();
    
    private readonly List<OrderItem> _items = new List<OrderItem>();
    
    public static Order Create(CustomerId customerId, Address shippingAddress)
    {
        var order = new Order
        {
            Id = Guid.NewGuid(),
            CustomerId = customerId,
            ShippingAddress = shippingAddress,
            Status = OrderStatus.Draft,
            TotalAmount = Money.Zero(Currency.USD)
        };
        
        return order;
    }
    
    public void AddItem(ProductId productId, string productName, Money unitPrice, int quantity)
    {
        var existingItem = _items.FirstOrDefault(i => i.ProductId == productId);
        if (existingItem != null)
        {
            existingItem.UpdateQuantity(existingItem.Quantity + quantity);
        }
        else
        {
            var orderItem = new OrderItem(this.Id, productId, productName, unitPrice, quantity);
            _items.Add(orderItem);
        }
        
        RecalculateTotalAmount();
    }
    
    public void ConfirmOrder()
    {
        if (Status != OrderStatus.Draft)
            throw new OrderingDomainException("Cannot confirm order that is not in Draft status");
            
        if (!Items.Any())
            throw new OrderingDomainException("Cannot confirm order without items");
            
        Status = OrderStatus.Confirmed;
        
        AddDomainEvent(new OrderPlacedDomainEvent(Id, DateTime.UtcNow));
    }
    
    private void RecalculateTotalAmount()
    {
        TotalAmount = Money.Zero(Currency.USD);
        foreach (var item in _items)
        {
            TotalAmount += item.TotalPrice;
        }
    }
}
```

=== Event-Driven Architecture
<event-driven-architecture>
Hệ thống lớn thường sử dụng mẫu Event-Driven Architecture để giảm sự phụ
thuộc và tăng tính mở rộng:

- #strong[Event Sourcing];: Lưu trữ các thay đổi trạng thái dưới dạng
  chuỗi events
- #strong[CQRS (Command Query Responsibility Segregation)];: Tách riêng
  operations đọc và ghi
- #strong[Message Brokers];: RabbitMQ, Azure Service Bus hoặc Kafka để
  truyền events

.NET Core có các công cụ để triển khai event-driven architecture:

- MassTransit hoặc NServiceBus cho message handling
- EventStore hoặc Marten cho event sourcing
- MediatR cho CQRS và in-process messaging

=== Khả năng mở rộng và Resilience
<khả-năng-mở-rộng-và-resilience>
Các hệ thống lớn cần được thiết kế để xử lý tải cao và phục hồi sau lỗi:

- #strong[Horizontal Scaling];: Thêm nhiều instance thông qua load
  balancing
- #strong[Sharding];: Phân chia database theo keys nhất định
- #strong[Caching Strategies];: Redis distributed cache, in-memory
  caching
- #strong[Circuit Breaker Pattern];: Sử dụng Polly để ngăn lỗi cascade

```cs
// Cấu hình Polly cho resilience
services.AddHttpClient<ICatalogService, CatalogService>()
    .AddTransientHttpErrorPolicy(policy => policy.RetryAsync(3))
    .AddTransientHttpErrorPolicy(policy => policy.CircuitBreakerAsync(
        handledEventsAllowedBeforeBreaking: 5,
        durationOfBreak: TimeSpan.FromSeconds(30)
    ));
```

=== Bảo mật và Xác thực
<bảo-mật-và-xác-thực>
Bảo mật là yếu tố quan trọng trong hệ thống lớn:

- #strong[Identity Server];: Cung cấp giải pháp SSO và OAuth/OpenID
  Connect
- #strong[Authentication];: JWT, cookie-based, và multi-factor
  authentication
- #strong[Authorization];: Policy-based authorization, role-based access
  control
- #strong[Data Protection];: Mã hóa dữ liệu nhạy cảm

```cs
// Cấu hình JWT authentication
services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = Configuration["Jwt:Issuer"],
            ValidAudience = Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(Configuration["Jwt:Key"]))
        };
    });

// Cấu hình authorization policies
services.AddAuthorization(options =>
{
    options.AddPolicy("AdminOnly", policy => 
        policy.RequireRole("Administrator"));
        
    options.AddPolicy("OrderManagement", policy =>
        policy.RequireClaim("Permission", "Orders.Read", "Orders.Write"));
});
```

=== Giám sát và Diagnostics
<giám-sát-và-diagnostics>
Hệ thống lớn yêu cầu giám sát và phân tích toàn diện:

- #strong[Distributed Tracing];: Với OpenTelemetry và Jaeger/Zipkin
- #strong[Logging];: Sử dụng Serilog, NLog gửi đến Elasticsearch hoặc
  Application Insights
- #strong[Metrics];: Prometheus, Grafana để theo dõi hiệu suất
- #strong[Health Checks];: Kiểm tra trạng thái của các thành phần và
  dependencies

```cs
// Cấu hình OpenTelemetry
services.AddOpenTelemetryTracing(builder =>
{
    builder
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddEntityFrameworkCoreInstrumentation()
        .AddSource("MyCompany.MyService")
        .SetResourceBuilder(ResourceBuilder.CreateDefault()
            .AddService("MyService", "MyCompany", "1.0.0"))
        .AddJaegerExporter(options =>
        {
            options.AgentHost = Configuration["Jaeger:AgentHost"];
            options.AgentPort = int.Parse(Configuration["Jaeger:AgentPort"]);
        });
});

// Cấu hình Health Checks
services.AddHealthChecks()
    .AddDbContextCheck<OrderContext>("order-db")
    .AddRedis(Configuration.GetConnectionString("Redis"), name: "redis-cache")
    .AddRabbitMQ(Configuration.GetConnectionString("RabbitMQ"), name: "rabbitmq")
    .AddCheck<ExternalApiHealthCheck>("external-api", tags: new[] { "api" });
```

=== Triển khai và DevOps
<triển-khai-và-devops>
Quy trình triển khai hiệu quả là yếu tố quan trọng cho hệ thống lớn:

- #strong[Infrastructure as Code];: Terraform, Azure Resource Manager,
  CloudFormation
- #strong[CI/CD Pipelines];: Azure DevOps, GitHub Actions, Jenkins
- #strong[Blue-Green Deployment];: Giảm thiểu thời gian ngừng hoạt động
- #strong[Canary Releases];: Triển khai dần dần để phát hiện sớm vấn đề

Với GitHub Actions:

```yaml
name: Build and Deploy

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: '8.0.x'
        
    - name: Restore dependencies
      run: dotnet restore
      
    - name: Build
      run: dotnet build --no-restore --configuration Release
      
    - name: Test
      run: dotnet test --no-build --configuration Release
      
    - name: Publish
      run: dotnet publish --no-build --configuration Release
      
    - name: Build and push Docker image
      uses: docker/build-push-action@v4
      with:
        context: .
        push: true
        tags: myregistry.azurecr.io/myapp:${{ github.sha }}
        
  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
    - name: Deploy to AKS
      uses: azure/k8s-deploy@v4
      with:
        namespace: production
        manifests: |
          kubernetes/deployment.yaml
          kubernetes/service.yaml
        images: myregistry.azurecr.io/myapp:${{ github.sha }}
```

=== Tổng kết
<tổng-kết>
Thiết kế hệ thống lớn với .NET Core yêu cầu kết hợp nhiều yếu tố:

- Kiến trúc phù hợp (microservices, layered, clean architecture)
- Phương pháp thiết kế domain-driven và event-driven
- Giải pháp mở rộng và resilience
- Bảo mật toàn diện
- Giám sát và diagnostics hiệu quả
- Quy trình triển khai tự động

.NET Core cung cấp một nền tảng mạnh mẽ và các công cụ phong phú để xây
dựng các hệ thống phức tạp, có khả năng mở rộng cao phục vụ hàng triệu
người dùng. Kết hợp với các thực hành phát triển và kiến trúc hiện đại,
nó cho phép xây dựng các hệ thống doanh nghiệp lớn, đáng tin cậy và có
khả năng phát triển.
