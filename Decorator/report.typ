#set heading(level: 2)

= Tên và Phân loại
Decorator (Trang trí) — Structural

= Mục đích, ý định
Gắn thêm trách nhiệm (hành vi) cho đối tượng một cách linh hoạt trong lúc chạy, thay vì tạo nhiều lớp con cố định.

= Bí danh
Wrapper

= Motivation
Khi cần thêm nhiều biến thể tính năng (ví dụ: thông báo + log + mã hóa + nén) theo tổ hợp, kế thừa sẽ bùng nổ số lớp. Decorator cho phép “bọc” đối tượng bằng các lớp bổ sung để ghép tính năng linh hoạt.

= Khả năng ứng dụng
- Cần mở rộng hành vi cho đối tượng tại runtime.
- Tránh tạo nhiều lớp con chỉ để kết hợp tính năng.
- Muốn áp dụng/loại bỏ tính năng theo cấu hình.

= Cấu trúc
Component định nghĩa giao diện chung. ConcreteComponent là đối tượng gốc. Decorator giữ tham chiếu đến Component và chuyển tiếp lời gọi. ConcreteDecorator mở rộng bằng hành vi trước/sau khi ủy quyền.

= Các thành viên
- Component: giao diện chung cho đối tượng và lớp bọc.
- ConcreteComponent: triển khai hành vi cốt lõi.
- Decorator: lớp trừu tượng giữ tham chiếu Component, ủy quyền lời gọi.
- ConcreteDecorator: thêm hành vi cụ thể.

= Sự cộng tác
Client thao tác qua kiểu Component. Các Decorator có thể xếp chuỗi, mỗi lớp bọc thêm hành vi rồi chuyển tiếp đến đối tượng bên trong.

= Các hệ quả mang lại, Ưu nhược điểm
Ưu: linh hoạt, tuân thủ Open/Closed, tránh bùng nổ lớp con. Nhược: nhiều lớp nhỏ, khó debug chuỗi bọc, thứ tự bọc ảnh hưởng kết quả.

= Chú ý liên quan đến việc cài đặt
- Đảm bảo Decorator và Component cùng giao diện.
- Tránh lộ kiểu cụ thể để không phá vỡ khả năng thay thế.
- Quản lý thứ tự bọc nếu hành vi phụ thuộc nhau.

= Một số so sánh nếu có
So với kế thừa: Decorator linh hoạt hơn khi cần tổ hợp tính năng. So với Proxy: Proxy kiểm soát truy cập, Decorator tập trung mở rộng hành vi. So với Adapter: Adapter đổi giao diện, Decorator giữ nguyên giao diện.

= Mã nguồn minh họa
Ví dụ khái niệm: bọc `MessageSender` bằng `LoggingDecorator` rồi `EncryptDecorator` để thêm log và mã hóa mà không đổi đối tượng gốc.

= Ví dụ về các hệ thống thực tế
- Java I/O: `BufferedInputStream`, `DataInputStream` bọc `InputStream`.
- UI frameworks: thêm border, shadow, scroll bằng lớp bọc.
- Middleware pipeline: thêm kiểm tra, ghi log, nén.

= Các mẫu liên quan
Composite (cấu trúc cây), Proxy (kiểm soát truy cập), Adapter (đổi giao diện). Có thể phối hợp với Factory Method để tạo chuỗi bọc.
