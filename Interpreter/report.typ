#set heading(level: 3)

= Tên và Phân loại
Interpreter - Mẫu hành vi (Behavioral Pattern)

= Mục đích, ý định
Xác định cách biểu diễn một ngôn ngữ cụ thể và xây dựng trình thông dịch để xử lý các câu trong ngôn ngữ đó.

= Motivation
Cần xử lý một ngôn ngữ hay ký pháp đặc biệt. Interpreter cho phép xây dựng một cấu trúc biểu diễn văn pháp và thực hiện các phép tính.

= Khả năng ứng dụng
- Ngôn ngữ cần được định nghĩa có thể được biểu diễn dưới dạng cây cú pháp
- Hiệu suất không phải vấn đề chính
- Độ phức tạp của ngôn ngữ vừa phải
- Cần linh hoạt thêm câu lệnh mới

= Cấu trúc
#figure(
  image("image.png", width: 80%),
  caption: "Cấu trúc của mẫu Interpreter",
)

AbstractExpression khai báo phương thức interpret(). ConcreteExpression triển khai phương thức này. Các expression tổ hợp thành cây cú pháp.

= Các thành viên
- AbstractExpression: giao diện cơ sở cho các biểu thức
- ConcreteExpression: triển khai interpret() cho terminal/nonterminal
- Context: lưu trữ thông tin toàn cục
- Client: xây dựng cây cú pháp và gọi interpret

= Sự cộng tác
Client xây dựng cây biểu thức. Mỗi nút gọi interpret() đệ quy trên các nút con.

= Các hệ quả mang lại, Ưu nhược điểm
*Ưu điểm:* Dễ thêm phép tính mới; biểu diễn ngôn ngữ linh hoạt.
*Nhược điểm:* Khó thêm quy tắc ngữ pháp; hiệu suất thấp với ngôn ngữ phức tạp.

= Chú ý liên quan đến việc cài đặt
- Xác định rõ ngữ pháp của ngôn ngữ
- Triển khai parser để xây dựng cây
- Quản lý Context cẩn thận

= Mã nguồn minh họa
Biểu thức số học, ký pháp logic, hay các mini-language.

= Ví dụ về các hệ thống thực tế
- Biểu thức số học trong máy tính
- SQL query interpreter
- Expression evaluator
- Regular expression engine

= Các mẫu liên quan
Liên quan đến Composite (cây cú pháp), Visitor (xử lý cây).
