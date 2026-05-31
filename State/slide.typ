#import "@preview/diatypst:0.8.0": *

#show: slides.with(
  title: "State - Trạng thái",
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

- Tên gọi: State, trạng thái
- Tên khác: Objects for States
- Phân loại: Behavioral Pattern (Mẫu ứng xử)

#box(stroke: 1pt + rgb("#2196F3"), radius: 5pt, inset: 12pt, [
  Các mẫu giải quyết vấn đề liên quan đến giao tiếp và trách nhiệm giữa các đối tượng
])

= Mục đích & Ý định

#box(stroke: 2pt + rgb("#4CAF50"), radius: 5pt, inset: 12pt, [
  *Mục đích chính:* Cho phép đối tượng thay đổi hành vi của nó khi trạng thái nội bộ thay đổi. Đối tượng có vẻ như đã thay đổi lớp của nó.
])

*Ý định:*
- Đóng gói các trạng thái khác nhau thành các lớp riêng biệt
- Cho phép đối tượng chuyển đổi trạng thái động
- Tránh nhiều điều kiện if-else phức tạp

= Vấn đề

*Tình huống*: Máy bán hàng tự động

#figure(
  image("images/problem1.png", width: 75%),
  caption: "Máy bán hàng có nhiều trạng thái khác nhau",
)

*Vấn đề*: Hành vi phụ thuộc vào trạng thái, quản lý trạng thái phức tạp

= Giải pháp

*Ý tưởng:* Sử dụng các lớp State để đóng gói logic của mỗi trạng thái

#figure(
  image("images/solution.png", width: 75%),
  caption: "Chuyển logic trạng thái vào các lớp riêng",
)

*Lợi ích:*
- Mã sạch, dễ bảo trì
- Dễ thêm trạng thái mới
- Giảm complexity của Context

= Cấu trúc

#figure(
  image("images/structure.png", width: 70%),
  caption: "Biểu đồ cấu trúc của mẫu thiết kế State",
)

1. *State trừu tượng:* Khai báo phương thức cho các trạng thái cụ thể.

2. *State kế thừa:* Thực hiện hành vi theo trạng thái cụ thể, có thể chuyển đổi Context sang trạng thái khác.

3. *Context:* Chứa tham chiếu đến State hiện tại, ủy quyền công việc cho State object.

= Luồng hoạt động

#enum(
  [Context nhận request từ client],
  [Context ủy quyền request cho State object hiện tại],
  [State xử lý request và có thể chuyển Context sang State khác],
  [Context được cập nhật State mới],
)

= Ví dụ thực tế

#figure(
  image("images/example.png", width: 70%),
  caption: "Áp dụng mẫu State vào hệ thống đơn hàng",
)

= Mã nguồn minh họa

```python
class State(ABC):
    @abstractmethod
    def handle(self, context): pass
```
