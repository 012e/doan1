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
