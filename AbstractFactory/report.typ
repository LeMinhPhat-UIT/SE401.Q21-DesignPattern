#set heading(level: 3)

= Tên và Phân loại
Abstract Factory - Mẫu tạo (Creational Pattern)

= Mục đích, ý định
Cung cấp giao diện để tạo các họ đối tượng liên quan mà không cần chỉ định rõ các lớp cụ thể của chúng.

= Motivation
Cần tạo các sản phẩm tương thích nhau từ các họ khác nhau. Thay vì khởi tạo trực tiếp từng lớp, sử dụng factory để quản lý việc tạo.

= Khả năng ứng dụng
- Hệ thống cần độc lập từ cách các sản phẩm được tạo
- Cần đảm bảo sử dụng các sản phẩm từ cùng một họ
- Cần linh hoạt chuyển đổi giữa các họ sản phẩm khác nhau

= Cấu trúc
AbstractFactory khai báo giao diện tạo sản phẩm. ConcreteFactory triển khai giao diện để tạo các sản phẩm cụ thể.

= Các thành viên
- AbstractFactory: giao diện khai báo phương thức tạo sản phẩm
- ConcreteFactory: triển khai tạo sản phẩm cụ thể
- AbstractProduct: giao diện sản phẩm
- ConcreteProduct: sản phẩm cụ thể
- Client: sử dụng factory để tạo sản phẩm

= Sự cộng tác
Client gọi phương thức của AbstractFactory. ConcreteFactory tạo ra ConcreteProduct tương ứng.

= Các hệ quả mang lại, Ưu nhược điểm
*Ưu điểm:* Tách logic tạo từ client; dễ chuyển đổi họ sản phẩm.
*Nhược điểm:* Khó thêm sản phẩm mới vào họ; code phức tạp hơn.

= Chú ý liên quan đến việc cài đặt
- Xác định rõ cách tạo từng sản phẩm
- Có thể dùng singleton cho factory

= Mã nguồn minh họa
Factory pattern thường dùng qua interface IFactory, các implement tạo đối tượng cụ thể.

= Ví dụ về các hệ thống thực tế
- UI framework (Swing, Qt) tạo các component khác nhau tùy platform
- Database connection factories cho SQL Server, MySQL, Oracle
- Trò chơi tạo các character từ những họ khác nhau

= Các mẫu liên quan
Khác Factory Method (tạo một sản phẩm). Có thể dùng với Prototype, Builder.
