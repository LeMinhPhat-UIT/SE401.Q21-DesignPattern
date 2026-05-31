#import "@preview/diatypst:0.8.0": *

#show: slides.with(
  title: "Visitor - Lượt thăm",
  subtitle: "Mẫu thiết kế - SE401.Q21",
  authors: "23521224 Trương Hoàng Phúc\n23521140 Lê Minh Phát\n22520243 Ya Đạt",
  ratio: 4 / 3,
  layout: "small",
  title-color: blue,
  toc: true,
  theme: "full",
  count: "number",
)

= Tên & Phân loại

- Tên gọi: Visitor, lượt thăm
- Tên khác: Operation, Object Structure
- Phân loại: Behavioral Pattern (Mẫu ứng xử)

#box(stroke: 1pt + rgb("#2196F3"), radius: 5pt, inset: 12pt, [
  Các mẫu giải quyết vấn đề liên quan đến giao tiếp và trách nhiệm giữa các đối tượng
])

= Mục đích & Ý định

#box(stroke: 2pt + rgb("#4CAF50"), radius: 5pt, inset: 12pt, [
  *Mục đích chính:* Cho phép định nghĩa thao tác mới trên các đối tượng mà không thay đổi các lớp của chúng.
])

*Ý định:*
- Tách thuật toán khỏi cấu trúc đối tượng
- Dễ thêm thao tác mới mà khong sua lop
- Gom cac thao tac lien quan vao cung mot Visitor

= Vấn đề

*Tình huống*: Hệ thống tài liệu hỗ trợ nhiều thao tác (export, thống kê, in ấn)

#figure(
  image("images/problem1.png", width: 75%),
  caption: "Moi thao tac moi lai can sua tung lop tai lieu",
)

*Vấn đề*: Mỗi thao tác mới kéo theo sửa nhiều lớp, khó bảo trì

= Giải pháp

*Ý tưởng:* Đưa thao tác vào Visitor, các lớp chỉ cần hỗ trợ `accept`

#figure(
  image("images/solution.png", width: 75%),
  caption: "Dinh nghia thao tac trong Visitor",
)

*Lợi ích:*
- Dễ thêm thao tác mới
- Cấu trúc đối tượng ổn định
- Tách biệt rõ dữ liệu và thuật toán

= Cấu trúc

#figure(
  image("images/structure.png", width: 70%),
  caption: "Biểu đồ cấu trúc của mẫu thiết kế Visitor",
)

1. *Element trừu tượng:* Khai báo `accept(visitor)`.

2. *ConcreteElement:* Gọi `visitor.visitConcreteElementX(this)`.

3. *Visitor trừu tượng:* Khai báo các thao tác cho từng Element.

4. *ConcreteVisitor:* Cài đặt các thao tác cụ thể.

= Luồng hoạt động

#enum(
  [Client tạo Visitor],
  [Client duyệt Object Structure],
  [Mỗi Element gọi `accept(visitor)`],
  [Visitor thực hiện thao tác tương ứng],
)

= Ví dụ thực tế

#figure(
  image("images/example.png", width: 70%),
  caption: "Ap dung Visitor cho trinh bien dich (AST)",
)

= Mã nguồn minh họa

```python
class Visitor(ABC):
    @abstractmethod
    def visit(self, element): pass
```
