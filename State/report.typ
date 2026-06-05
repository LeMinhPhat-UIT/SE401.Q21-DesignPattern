#set heading(level: 3)

= Tên và Phân loại
State - Mẫu hành vi (Behavioral Pattern)

= Mục đích, ý định
Cho phép một đối tượng thay đổi hành vi của nó khi trạng thái nội bộ của nó thay đổi. Tách logic trạng thái khỏi lớp chính.

= Motivation
Khi một đối tượng có hành vi phụ thuộc vào trạng thái và cần thay đổi hành vi khi trạng thái thay đổi, code sẽ chứa nhiều if-else. State pattern giải quyết bằng cách tạo các lớp trạng thái.

= Khả năng ứng dụng
- Hành vi của đối tượng phụ thuộc vào trạng thái và thay đổi tại runtime
- Có các nhánh lớn phụ thuộc vào trạng thái hiện tại
- Mã có nhiều if-else hoặc switch-case kiểm tra trạng thái

= Cấu trúc
#figure(
  image("image.png", width: 80%),
  caption: "Cấu trúc của mẫu State",
)

State định nghĩa giao diện cho các hành vi trạng thái. ConcreteState triển khai hành vi cụ thể cho từng trạng thái. Context chứa một State hiện tại.

= Các thành viên
- State: giao diện định nghĩa các phương thức cho mỗi trạng thái
- ConcreteState: triển khai hành vi cho một trạng thái cụ thể
- Context: định nghĩa giao diện cho client, giữ tham chiếu ConcreteState

= Sự cộng tác
Context ủy nhiệm yêu cầu cho ConcreteState hiện tại. State có thể chuyển Context sang state khác.

= Các hệ quả mang lại, Ưu nhược điểm
*Ưu điểm:* Loại bỏ if-else; dễ thêm trạng thái mới; tách logic trạng thái.
*Nhược điểm:* Tăng số lớp; có thể phức tạp hóa code nếu trạng thái ít.

= Chú ý liên quan đến việc cài đặt
- Xác định rõ tất cả trạng thái có thể
- Xem xét ai chuyển trạng thái: Context hay State

= Mã nguồn minh họa
Máy trạng thái: Connection (Connected, Disconnected, Connecting).

= Ví dụ về các hệ thống thực tế
- TCP Connection: Established, Listen, Closed
- Order: Pending, Processing, Shipped, Delivered
- Traffic light: Red, Yellow, Green
- Media player: Playing, Paused, Stopped

= Các mẫu liên quan
Liên quan đến Strategy (chọn thuật toán). Khác ở chỗ State tự chuyển đổi.
