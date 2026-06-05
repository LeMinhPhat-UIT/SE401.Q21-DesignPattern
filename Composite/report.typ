#set heading(level: 3)

= Tên và Phân loại
Composite - Mẫu cấu trúc (Structural Pattern)

= Mục đích, ý định
Soạn các đối tượng thành cấu trúc cây để biểu diễn các phần-toàn thể. Cho phép client xử lý các đối tượng riêng lẻ và tổ hợp của chúng một cách thống nhất.

= Motivation
Trong các ứng dụng có cấu trúc cây (file system, UI components), cần xử lý cả phần tử đơn lẻ và tập hợp phần tử. Composite cho phép cách tiếp cận thống nhất.

= Khả năng ứng dụng
- Biểu diễn các cấu trúc part-whole dưới dạng cây
- Muốn client không cần phân biệt đối tượng riêng lẻ hay tổ hợp
- Cần hỗ trợ các phép toán trên cây đối tượng

= Cấu trúc
#figure(
  image("image.png", width: 50%),
  caption: "Cấu trúc của mẫu Composite",
)

Component là giao diện chung. Leaf là phần tử lá (không có con). Composite là phần tử chứa các component khác.

= Các thành viên
- Component: giao diện chung cho phần tử và tổ hợp
- Leaf: phần tử lá, không có con
- Composite: chứa danh sách component và cho phép thêm/xóa
- Client: làm việc qua giao diện Component

= Sự cộng tác
Client làm việc qua giao diện Component. Composite ủy nhiệm các thao tác cho các component con.

= Các hệ quả mang lại, Ưu nhược điểm
*Ưu điểm:* Tạo cấu trúc phân cấp sạch; dễ thêm thành phần mới.
*Nhược điểm:* Khó hạn chế các loại component; có thể quá tổng quát.

= Chú ý liên quan đến việc cài đặt
- Thiết kế giao diện Component cẩn thận
- Quản lý danh sách con trong Composite

= Mã nguồn minh họa
File system là ví dụ: Directory chứa File và Directory con.

= Ví dụ về các hệ thống thực tế
- File system (folder, file)
- UI framework (panel, button, textbox)
- Document structure (chapters, sections, paragraphs)
- Biểu diễn cây tổ chức công ty

= Các mẫu liên quan
Thường dùng với Iterator, Visitor. Tương tự Iterator nhưng cho cấu trúc.
