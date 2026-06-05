#set heading(level: 3)

= Tên và Phân loại
Visitor - Mẫu hành vi (Behavioral Pattern)

= Mục đích, ý định
Cho phép định nghĩa các thao tác mới trên các phần tử của một cấu trúc đối tượng mà không thay đổi các lớp của những phần tử đó. Tách logic xử lý khỏi cấu trúc dữ liệu.

= Motivation
Khi cần thực hiện nhiều thao tác khác nhau trên cùng một cấu trúc đối tượng phức tạp, thêm mỗi thao tác mới vào từng lớp sẽ làm cho code trở nên cồng kềnh. Visitor cho phép tách các thao tác ra khỏi cấu trúc.

= Khả năng ứng dụng
- Cấu trúc đối tượng ít thay đổi nhưng thao tác hay thay đổi
- Cần thực hiện các phép toán khác nhau trên các phần tử không liên quan
- Cần thực hiện phép tính lặp lại hoặc báo cáo trên cấu trúc phức tạp

= Cấu trúc
#figure(
  image("image.png", width: 80%),
  caption: "Cấu trúc của mẫu Visitor",
)
Visitor khai báo một giao diện visit() cho mỗi loại phần tử. Các phần tử chấp nhận visitor và gọi phương thức visit tương ứng. ConcreteVisitor triển khai logic cho từng loại phần tử.

= Các thành viên
- Visitor: giao diện định nghĩa phương thức visit cho mỗi loại phần tử
- ConcreteVisitor: triển khai các phương thức visit cụ thể
- Element: giao diện chấp nhận visitor
- ConcreteElement: phần tử cụ thể, triển khai accept()
- ObjectStructure: quản lý tập hợp các phần tử

= Sự cộng tác
Phần tử gọi accept(visitor), visitor gọi lại phương thức visit tương ứng của phần tử đó.

= Các hệ quả mang lại, Ưu nhược điểm
*Ưu điểm:* Dễ dàng thêm thao tác mới; nhóm logic thao tác tại một chỗ.
*Nhược điểm:* Khó thêm phần tử mới; vi phạm cấu trúc lớp.

= Chú ý liên quan đến việc cài đặt
- Hãy xác định rõ tập hợp các phần tử sẽ được visitor xử lý
- Visitor nên được thiết kế để có thể xử lý các phần tử tương ứng

= Mã nguồn minh họa
Visitor được sử dụng trong trình biên dịch, parser, hoặc khi cần in chi tiết cấu trúc dữ liệu phức tạp.

= Ví dụ về các hệ thống thực tế
- Trình biên dịch: AST visitor cho mỗi loại nút
- IDE: refactoring tool sử dụng visitor pattern
- Document processors: tính toán thống kê tài liệu

= Các mẫu liên quan
Khác với Composite (quản lý cấu trúc) về mục đích, nhưng thường dùng cùng nhau. Liên quan đến Strategy.
