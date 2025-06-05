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
