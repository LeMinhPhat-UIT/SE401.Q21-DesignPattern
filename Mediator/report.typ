#set heading(level: 2)

= Tên và Phân loại
Mediator - Mẫu hành vi (Behavioral Pattern)

= Mục đích, ý định
Xác định một đối tượng trung gian để đơn giản hóa giao tiếp giữa các đối tượng. Giảm sự phụ thuộc lẫn nhau bằng cách cho các đối tượng giao tiếp qua mediator thay vì trực tiếp.

= Motivation
Khi nhiều đối tượng cần giao tiếp phức tạp với nhau, chúng trở thành phụ thuộc chặt chẽ. Mediator tập trung logic giao tiếp.

= Khả năng ứng dụng
- Tập hợp các đối tượng giao tiếp theo cách không thể kiểm soát được
- Cần tái sử dụng đối tượng nhưng khó vì có nhiều tham chiếu tới các đối tượng khác
- Hành vi phân tán giữa các lớp cần tập trung

= Cấu trúc
Mediator định nghĩa giao diện để giao tiếp. ConcreteMediator triển khai và phối hợp các Colleague.

= Các thành viên
- Mediator: giao diện xác định phương thức giao tiếp
- ConcreteMediator: triển khai giao tiếp và phối hợp Colleague
- Colleague: giao diện các đối tượng tham gia
- ConcreteColleague: giao tiếp qua mediator

= Sự cộng tác
Colleague gửi yêu cầu tới Mediator. Mediator phối hợp phản hồi từ các Colleague khác.

= Các hệ quả mang lại, Ưu nhược điểm
*Ưu điểm:* Giảm sự phụ thuộc giữa các đối tượng; tập trung logic giao tiếp.
*Nhược điểm:* Mediator có thể trở thành "God Object"; khó bảo trì nếu logic phức tạp.

= Chú ý liên quan đến việc cài đặt
- Xác định tập hợp Colleague và cách giao tiếp
- Đảm bảo Mediator không vi phạm Single Responsibility

= Mã nguồn minh họa
Các đối tượng dialog, event handlers trong UI framework.

= Ví dụ về các hệ thống thực tế
- Dialog box: các control giao tiếp qua dialog
- Chat room: người dùng giao tiếp qua phòng
- Air traffic control: máy bay giao tiếp qua tower
- Event-driven systems

= Các mẫu liên quan
Liên quan đến Observer (thông báo), Facade (đơn giản giao diện).
