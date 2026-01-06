== Spring Boot & Seata (Distributed Transaction)
<spring-boot-seata>

=== Vấn đề của Giao dịch Phân tán
<distributed-transaction-problem>
Trong Monolithic, `@Transactional` của Spring đảm bảo tính toàn vẹn dữ liệu (ACID) trên một Database duy nhất.
Trong Microservices, một nghiệp vụ "Đặt hàng" có thể gọi 3 service:
1. `Order Service`: Tạo đơn hàng (DB 1).
2. `Inventory Service`: Trừ kho (DB 2).
3. `Account Service`: Trừ tiền (DB 3).

Nếu bước 3 lỗi (hết tiền), DB 1 và DB 2 đã commit rồi -> #strong[Sai lệch dữ liệu]. Đây là bài toán Distributed Transaction.

=== Giới thiệu Seata
<intro-seata>
Seata (Simple Extensible Autonomous Transaction Architecture) là giải pháp mã nguồn mở của Alibaba để xử lý giao dịch phân tán với hiệu năng cao.

#strong[Các chế độ hoạt động (Modes):]
1. #strong[AT Mode] (Mặc định, phổ biến nhất): Tự động hóa việc commit/rollback dựa trên SQL parsing. Non-intrusive (không sửa code nhiều).
2. #strong[TCC Mode] (Try-Confirm-Cancel): Hiệu năng cao nhất nhưng phải code tay 3 hàm cho mỗi hành động.
3. #strong[Saga Mode]: Dùng cho transaction kéo dài (Long running).
4. #strong[XA Mode]: Chuẩn 2PC cũ, an toàn nhưng chậm.

=== Kiến trúc Seata (AT Mode)
<seata-architecture>
- #strong[TC (Transaction Coordinator)]: Server Seata đứng giữa điều phối.
- #strong[TM (Transaction Manager)]: Service bắt đầu giao dịch (VD: Order Service).
- #strong[RM (Resource Manager)]: Các service tham gia (VD: Inventory, Account).

#strong[Quy trình:]
1. TM hỏi TC xin mở một Global Transaction (có XID).
2. RM thực hiện SQL, #strong[commit luôn] vào DB local, nhưng lưu lại "Undo Log" (ảnh trước/sau khi update).
3. Nếu tất cả RM thành công -> TM bảo TC "Global Commit" -> RM xóa Undo Log.
4. Nếu có một RM lỗi -> TM bảo TC "Global Rollback" -> RM dùng Undo Log để khôi phục dữ liệu cũ.

=== Cài đặt Seata với Spring Boot
<setup-seata>

#strong[1. Cài đặt Seata Server (TC)]
Tải bản build hoặc chạy Docker:
```bash
docker run -d -p 8091:8091 seataio/seata-server
```

#strong[2. Dependency]
```xml
<dependency>
    <groupId>io.seata</groupId>
    <artifactId>seata-spring-boot-starter</artifactId>
    <version>1.7.0</version>
</dependency>
```

#strong[3. Cấu hình `application.yml`]
Tất cả service tham gia đều phải trỏ về Seata Server (TC).

```yaml
seata:
  enabled: true
  application-id: ${spring.application.name}
  tx-service-group: my_test_tx_group # Group name mapping với cấu hình trên server
  service:
    vgroup-mapping:
      my_test_tx_group: default
    grouplist:
      default: 127.0.0.1:8091
```

#strong[4. Tạo bảng `undo_log`]
Mỗi Database tham gia giao dịch (OrderDB, InventoryDB...) bắt buộc phải có bảng `undo_log` để Seata lưu trạng thái phục hồi.
```sql
CREATE TABLE `undo_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `branch_id` bigint(20) NOT NULL,
  `xid` varchar(100) NOT NULL,
  `context` varchar(128) NOT NULL,
  `rollback_info` longblob NOT NULL,
  `log_status` int(11) NOT NULL,
  `log_created` datetime NOT NULL,
  `log_modified` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ux_undo_log` (`xid`,`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```

=== Sử dụng Global Transaction
<usage-global-transaction>
Tại điểm bắt đầu nghiệp vụ (ví dụ hàm `createOrder` ở OrderService), chỉ cần thêm 1 annotation:

```java
@Service
public class OrderService {

    @Autowired private InventoryClient inventoryClient;
    @Autowired private AccountClient accountClient;

    // @GlobalTransactional: Đánh dấu đây là giao dịch phân tán
    // name: Tên gợi nhớ
    // rollbackFor: Rollback khi gặp Exception nào
    @GlobalTransactional(name = "create-order-tx", rollbackFor = Exception.class)
    public void create(Order order) {
        // 1. Lưu Order (Local DB)
        orderRepository.save(order);
        
        // 2. Trừ kho (Remote Service - Feign)
        inventoryClient.decrease(order.getProductId(), order.getCount());
        
        // 3. Trừ tiền (Remote Service - Feign)
        accountClient.decrease(order.getUserId(), order.getMoney());
        
        // Nếu bước 3 lỗi -> Seata sẽ tự động rollback bước 1 và 2
    }
}
```

=== Lưu ý quan trọng
<seata-notes>
- Các bảng tham gia transaction phải có #strong[Primary Key].
- Seata AT Mode dựa trên việc parse SQL, nên một số câu SQL phức tạp (stored procedure, trigger) có thể không được hỗ trợ.
- Hiệu năng sẽ thấp hơn transaction nội bộ do phải giao tiếp qua mạng với TC và ghi Undo Log. Cần cân nhắc kỹ khi dùng.