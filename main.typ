#set text(font: "Times New Roman", size: 13pt)
#set heading(numbering: "1.")
#set page("a4")
#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages, zebra-fill: none, stroke: black + 1pt)
#show raw: set text(font: "JetBrains Mono") 

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
#set page(numbering: "1")
#outline(
  title: [
    #text([Mục lục], size: 30pt)
    #v(10pt)
  ],
  depth: 4
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

+ **Tính nhất quán mạnh (Strong Consistency)**
  - Đảm bảo tất cả các nút đều thấy dữ liệu mới nhất sau khi cập nhật
  - Thường đạt được thông qua các giao thức đồng thuận hoặc cơ chế khóa
  - Ưu điểm: Đơn giản hóa lập trình, dữ liệu luôn nhất quán
  - Nhược điểm: Giảm tính khả dụng, tăng độ trễ giao dịch

+ **Tính nhất quán cuối cùng (Eventual Consistency)**
  - Đảm bảo rằng nếu không có cập nhật mới, cuối cùng tất cả các bản sao sẽ hội tụ về cùng một giá trị
  - Cho phép bất đồng bộ tạm thời giữa các bản sao
  - Ưu điểm: Độ trễ thấp, tính khả dụng cao
  - Nhược điểm: Phức tạp trong xử lý xung đột, có thể trả về dữ liệu cũ

+ **Tính nhất quán nhân quả (Causal Consistency)**
  - Đảm bảo các hoạt động có liên quan nhân quả được thấy theo đúng thứ tự
  - Các hoạt động không liên quan có thể được thấy theo thứ tự khác nhau
  - Cân bằng giữa tính nhất quán mạnh và tính nhất quán cuối cùng

+ **Tính nhất quán phiên (Session Consistency)**
  - Đảm bảo tính nhất quán trong phạm vi một phiên làm việc
  - Người dùng luôn thấy dữ liệu của riêng họ một cách nhất quán
  - Hữu ích cho ứng dụng tương tác người dùng

==== Định Lý CAP (CAP Theorem)

Định lý CAP (do Eric Brewer đề xuất) tuyên bố rằng trong một hệ thống phân tán, không thể đồng thời đảm bảo cả ba thuộc tính sau:

+ **Tính Nhất Quán (Consistency)**: Tất cả các nút thấy cùng dữ liệu tại cùng thời điểm
+ **Tính Khả Dụng (Availability)**: Mỗi yêu cầu đều nhận được phản hồi
+ **Khả Năng Chịu Phân Vùng (Partition Tolerance)**: Hệ thống tiếp tục hoạt động khi có phân vùng mạng

Trong thực tế, do không thể tránh khỏi phân vùng mạng trong hệ thống phân tán, hầu hết các hệ thống phải đánh đổi giữa tính nhất quán và tính khả dụng.

=== Khả Năng Chống Chịu Lỗi (Fault Tolerance)

Khả năng chống chịu lỗi là khả năng hệ thống tiếp tục hoạt động đúng ngay cả khi một hoặc nhiều thành phần bị lỗi. Đây là thuộc tính quan trọng của hệ thống phân tán đáng tin cậy.

===== Các Loại Lỗi

+ **Lỗi Sự Cố (Crash Failures)**
  - Nút đột ngột ngừng hoạt động hoặc khởi động lại
  - Dễ phát hiện và xử lý nhất
  - Giải pháp: Dự phòng, tự động khởi động lại

+ **Lỗi Thời Gian (Timing Failures)**
  - Nút phản hồi quá chậm hoặc quá nhanh
  - Có thể do mạng không ổn định hoặc quá tải
  - Giải pháp: Cơ chế timeout, thử lại

+ **Lỗi Phản Hồi (Response Failures)**
  - Nút trả về giá trị không chính xác
  - Có thể do bug phần mềm hoặc dữ liệu hỏng
  - Giải pháp: Kiểm tra tính hợp lệ, mã hóa lỗi

+ **Lỗi Byzantine (Byzantine Failures)**
  - Nút hoạt động không thể dự đoán, có thể độc hại
  - Loại lỗi phức tạp nhất để xử lý
  - Được thảo luận chi tiết ở phần sau

===== Cơ Chế Chống Chịu Lỗi

+ **Dự Phòng (Redundancy)**
  - Dự phòng thông tin: Mã sửa lỗi, kiểm tra tổng
  - Dự phòng thời gian: Thử lại, thời gian chờ thích ứng
  - Dự phòng vật lý: Nhiều bản sao phần cứng

+ **Sao Chép (Replication)**
  - Duy trì nhiều bản sao dữ liệu trên các nút khác nhau
  - Có thể là sao chép đồng bộ hoặc bất đồng bộ
  - Phương pháp: Primary-Secondary, Multi-Primary, Quorum

+ **Phát Hiện Lỗi (Failure Detection)**
  - Cơ chế heartbeat: Kiểm tra định kỳ tình trạng nút
  - Hệ thống giám sát phân tán
  - Đánh giá tình trạng dựa trên nhiều nguồn

+ **Khôi Phục Lỗi (Failure Recovery)**
  - Khôi phục trạng thái từ snapshot hoặc log
  - Tự động khởi động lại dịch vụ
  - Failover tự động sang nút dự phòng

===== Kỹ Thuật Thiết Kế Chống Chịu Lỗi

+ **Phân Vùng Lỗi (Failure Domains)**
  - Cô lập các thành phần để lỗi không lan truyền
  - Sử dụng nhiều vùng hoặc khu vực

+ **Circuit Breaker Pattern**
  - Ngăn chặn gọi đến dịch vụ đã biết là bị lỗi
  - Cho phép hệ thống tự phục hồi
  - Ngăn chặn lỗi dây chuyền

+ **Bulkhead Pattern**
  - Cô lập tài nguyên cho các người dùng hoặc dịch vụ khác nhau
  - Đảm bảo lỗi không ảnh hưởng đến toàn bộ hệ thống

+ **Timeout và Retry Strategies**
  - Thiết lập thời gian chờ hợp lý
  - Chiến lược thử lại với backoff
  - Tránh thundering herd problem

==== Lỗi Byzantine (Byzantine Fault)

Lỗi Byzantine (Byzantine fault), hay còn gọi là Vấn đề các vị tướng Byzantine, là một tình trạng của một hệ thống, đặc biệt là hệ thống phân tán, trong đó các thành phần có thể bị lỗi và không có thông tin chính xác về việc liệu thành phần đó có bị lỗi hay không.  Thuật ngữ này lấy tên từ một câu chuyện ngụ ngôn, "Vấn đề các vị tướng Byzantine", được phát triển để mô tả một tình huống trong đó, để tránh sự sụp đổ của hệ thống, các tác nhân của hệ thống phải đồng ý về một chiến lược phối hợp, nhưng một số tác nhân này là không đáng tin cậy.

===== Bài Toán Các Tướng Byzantine

Bài toán mô tả tình huống:
- Một số tướng Byzantine bao vây một thành phố
- Tướng lĩnh cần đồng thuận về kế hoạch tấn công hoặc rút lui
- Liên lạc chỉ thông qua tin nhắn
- Một số tướng có thể là kẻ phản bội, gửi thông tin sai lệch

Thách thức là làm thế nào để các tướng trung thành đạt được đồng thuận ngay cả khi có sự hiện diện của kẻ phản bội.

===== Đặc Điểm của Lỗi Byzantine

+ **Không Giới Hạn Hành Vi**
  - Có thể gửi thông điệp mâu thuẫn đến các nút khác nhau
  - Có thể cố tình trì hoãn hoặc sửa đổi thông điệp
  - Có thể phối hợp với các nút độc hại khác

+ **Khó Phát Hiện**
  - Không thể dễ dàng phân biệt nút Byzantine với nút bình thường
  - Có thể hoạt động bình thường trong một thời gian trước khi gây ra lỗi
  - Có thể thay đổi hành vi để tránh phát hiện

+ **Tác Động Nghiêm Trọng**
  - Có thể phá vỡ tính nhất quán của toàn bộ hệ thống
  - Có thể dẫn đến hành vi không xác định
  - Đặc biệt nguy hiểm trong các hệ thống tài chính, quân sự, y tế

===== Giao Thức Đồng Thuận Byzantine

+ **PBFT (Practical Byzantine Fault Tolerance)**
  - Được phát triển bởi Miguel Castro và Barbara Liskov (1999)
  - Có thể chịu đựng đến f nút Byzantine trong hệ thống có 3f+1 nút
  - Sử dụng quy trình 3 giai đoạn: pre-prepare, prepare, commit
  - Hiệu quả hơn các giải pháp trước đó, nhưng vẫn có chi phí giao tiếp cao

+ **Tendermint**
  - Biến thể của PBFT được sử dụng trong blockchain
  - Sử dụng cơ chế đặt cược (staking) làm cơ chế khuyến khích
  - Cung cấp tính chất giao dịch chung cuộc (finality)

+ **HoneyBadgerBFT**
  - Giao thức đồng thuận không đồng bộ
  - Không phụ thuộc vào giả định thời gian
  - Phù hợp cho môi trường Internet với độ trễ không đoán trước

+ **Proof of Work (PoW)**
  - Sử dụng trong Bitcoin và nhiều blockchain khác
  - Dựa trên công việc tính toán thay vì giao tiếp
  - Cung cấp khả năng chống chịu Byzantine trong môi trường mở

===== Ứng Dụng của Khả Năng Chịu Lỗi Byzantine

+ **Blockchain và Cryptocurrency**
  - Bitcoin, Ethereum và các dự án blockchain khác
  - Môi trường phi tập trung với các tác nhân không đáng tin cậy
  - Kinh tế học token như cơ chế khuyến khích

+ **Hệ Thống Quan Trọng**
  - Hệ thống kiểm soát không lưu
  - Hệ thống tài chính phân tán
  - Hệ thống quân sự và an ninh quốc gia

+ **Điện Toán Đám Mây Đa Nhà Cung Cấp**
  - Đảm bảo dữ liệu nhất quán giữa các nhà cung cấp cloud
  - Bảo vệ chống lại các nhà cung cấp độc hại tiềm ẩn

+ **Internet of Things (IoT)**
  - Bảo vệ hệ thống IoT khỏi thiết bị bị xâm nhập
  - Đảm bảo tính toàn vẹn dữ liệu từ các cảm biến
  - Hỗ trợ hệ thống tự động phân tán

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

== Phân loại

=== Hardware & Software

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

#strong[Đặc điểm:]

- Phân phối gói tin dựa trên địa chỉ IP nguồn/đích và cổng
- Không xem xét nội dung gói tin
- Hiệu suất cao do xử lý đơn giản
- Không thể thực hiện các quyết định dựa trên nội dung HTTP

==== Layer 7 Load Balancer (Application Layer)

Load balancer tầng 7 hoạt động ở tầng ứng dụng, có khả năng phân tích và
ra quyết định dựa trên nội dung gói tin HTTP/HTTPS.

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
Write-through là một pattern caching trong đó dữ liệu được ghi vào cả
cache và nguồn dữ liệu chính (database) trong cùng một giao dịch.

#strong[Cách hoạt động:]

+ Ứng dụng ghi dữ liệu vào cache
+ Cache ngay lập tức ghi dữ liệu vào nguồn dữ

=== Write-back (Write-behind)

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
    align: (auto,auto,auto,),
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
<mô-hình-giao-tiếp-bất-đồng-bộ>
+ #strong[Message Queuing]

  - Sử dụng hàng đợi tin nhắn như RabbitMQ, ActiveMQ
  - Tin nhắn được lưu trữ tạm thời cho đến khi được xử lý
  - Mô hình giao tiếp point-to-point
  - Đảm bảo tin nhắn được xử lý chính xác một lần
  - Ví dụ thực tế: Nhiều hệ thống thanh toán và xử lý đơn hàng sử dụng
    RabbitMQ

+ #strong[Publish/Subscribe (Pub/Sub)]

  - Một nhà sản xuất gửi tin nhắn đến nhiều người tiêu dùng
  - Thường sử dụng các nền tảng như Kafka, Google Pub/Sub
  - Mô hình giao tiếp một-đến-nhiều
  - Phù hợp cho các sự kiện cần được xử lý bởi nhiều dịch vụ
  - Ví dụ thực tế: Netflix sử dụng Kafka để xử lý luồng dữ liệu thời
    gian thực

+ #strong[Event Streaming]

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

=== Định dạng dữ liệu
<định-dạng-dữ-liệu>
+ #strong[JSON (JavaScript Object Notation)]

  - Định dạng dữ liệu phổ biến nhất cho API web
  - Dễ đọc cho con người và dễ phân tích cho máy
  - Hỗ trợ rộng rãi trong hầu hết các ngôn ngữ lập trình
  - Nhẹ hơn XML nhưng ít cấu trúc hơn

+ #strong[XML (eXtensible Markup Language)]

  - Định dạng dữ liệu có cấu trúc cao, có thể mở rộng
  - Hỗ trợ không gian tên và lược đồ xác thực
  - Dài dòng hơn so với JSON
  - Vẫn được sử dụng trong nhiều ứng dụng doanh nghiệp

+ #strong[Protocol Buffers (Protobuf)]

  - Định dạng dữ liệu nhị phân nhỏ gọn do Google phát triển
  - Nhanh hơn và nhỏ hơn đáng kể so với JSON và XML
  - Yêu cầu định nghĩa lược đồ trước
  - Sử dụng chủ yếu với gRPC

+ #strong[Avro]

  - Định dạng dữ liệu nhị phân do Apache phát triển
  - Bao gồm lược đồ trong dữ liệu
  - Hỗ trợ tiến hóa lược đồ tốt hơn Protobuf
  - Phổ biến trong hệ sinh thái Hadoop và Kafka

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

=== Khám phá dịch vụ và đăng ký
<khám-phá-dịch-vụ-và-đăng-ký>
+ #strong[Client-side Discovery]

  - Client truy vấn đăng ký dịch vụ để tìm vị trí dịch vụ
  - Client thực hiện cân bằng tải và định tuyến
  - Ví dụ: Netflix Eureka với Ribbon

+ #strong[Server-side Discovery]

  - Client gửi yêu cầu thông qua bộ cân bằng tải
  - Bộ cân bằng tải tương tác với đăng ký dịch vụ
  - Ví dụ: AWS ELB với ECS

+ #strong[Service Registry Solutions]

  - Consul: Cung cấp khám phá dịch vụ, cấu hình và phân đoạn
  - etcd: Lưu trữ key-value phân tán được sử dụng bởi Kubernetes
  - ZooKeeper: Dịch vụ điều phối phân tán được sử dụng trong Hadoop
  - Eureka: Giải pháp khám phá dịch vụ của Netflix

=== Chiến lược xử lý lỗi
<chiến-lược-xử-lý-lỗi>
+ #strong[Circuit Breaker Pattern]

  - Ngăn chặn lỗi lan truyền khi dịch vụ xuống cấp
  - Trạng thái: Đóng (bình thường), Mở (lỗi), Nửa-mở (thử lại)
  - Thực hiện bởi các thư viện như Netflix Hystrix, Resilience4j
  - Giúp hệ thống phân tán chống chịu lỗi tốt hơn

+ #strong[Retry Pattern]

  - Tự động thử lại thao tác thất bại
  - Sử dụng giãn cách mũ (exponential backoff) để tránh quá tải
  - Kết hợp với timeout để ngăn chặn chờ đợi vô hạn
  - Hiệu quả cho lỗi tạm thời

+ #strong[Timeout Pattern]

  - Đặt giới hạn thời gian cho các cuộc gọi dịch vụ
  - Ngăn chặn tài nguyên bị chặn vô thời hạn
  - Cần thiết trong mọi giao tiếp dịch vụ từ xa
  - Nên được đặt ở nhiều cấp

+ #strong[Bulkhead Pattern]

  - Cô lập các thành phần để ngăn chặn lỗi lan truyền
  - Giống như các vách ngăn trên tàu để ngăn nước tràn vào
  - Thực hiện bằng cách phân tách thread pool hoặc giới hạn kết nối
  - Bảo vệ toàn bộ hệ thống khỏi lỗi của một thành phần

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
+ #strong[Thiếu kinh nghiệm đội ngũ]
  - Đội ngũ không quen với hệ thống phân tán
  - Thiếu kiến thức về DevOps và CI/CD
  - Không có kinh nghiệm với các mẫu thiết kế phân tán
  - Có thể dẫn đến triển khai sai và các vấn đề hiệu suất

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
