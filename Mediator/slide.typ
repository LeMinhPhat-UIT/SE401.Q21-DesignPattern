#import "@preview/diatypst:0.8.0": *

#show: slides.with(
  title: "Mediator - Lớp trung gian",
  subtitle: "Mẫu thiết kế - SE401.Q21",
  authors: "23521224 Trương Hoàng Phúc\n23521140 Lê Minh Phát\n22520243 Ya Đạt",
  ratio: 4 / 3,
  layout: "small",
  title-color: blue,
  toc: true,
  theme: "full",
  count: "number",
)

= Tên, Bí danh & Phân loại

- Tên gọi: Mediator, lớp trung gian
- Tên khác: Intermediary, Controller
- Phân loại: Behavioral Pattern (Mẫu ứng xử)

#box(stroke: 1pt + rgb("#2196F3"), radius: 5pt, inset: 12pt, [
  Các mẫu giải quyết vấn đề liên quan đến giao tiếp và trách nhiệm giữa các đối tượng
])

= Mục đích & Ý định

#box(stroke: 2pt + rgb("#4CAF50"), radius: 5pt, inset: 12pt, [
  *Mục đích chính:* Giảm sự phụ thuộc lẫn nhau giữa các lớp, đảm nhiệm việc làm lớp trung gian thực hiện việc giao tiếp gián tiếp giữa các lớp.
])

*Ý định:*
- Giải phóng các đối tượng khỏi sự phụ thuộc chặt chẽ
- Tạo điểm tập trung duy nhất cho logic giao tiếp
- Tăng khả năng tái sử dụng của các đối tượng

= Vấn đề

*Tình huống*: Dialog chỉnh sửa hồ sơ khách hàng

#figure(
  image("images/problem1.png", width: 75%),
  caption: "Các phần tử UI có quan hệ phức tạp với nhau",
)

*Vấn đề*: Mỗi phần tử phải liên lạc trực tiếp với nhiều phần tử khác

= Giải pháp

*Ý tưởng*: Dừng giao tiếp trực tiếp, sử dụng Mediator

#figure(
  image("images/solution.png", width: 75%),
  caption: "Giao tiếp gián tiếp qua Mediator",
)

*Lợi ích:*
- Các thành phần chỉ phụ thuộc vào 1 Mediator
- Giảm phụ thuộc lẫn nhau, tập trung logic giao tiếp

= Cấu trúc

#figure(
  image("images/structure.png", width: 70%),
  caption: "Biểu đồ cấu trúc của mẫu thiết kế Mediator",
)

1. *Các lớp Component:* chứa business logic, sử dụng Mediator qua interface. Không biết lớp Mediator cụ thể, dễ tái sử dụng.

2. *Mediator trừu tượng:* Khai báo phương thức giao tiếp, thường chỉ có `notify(sender)`.

3. *Mediator kế thừa:* quản lý quan hệ giữa các Component, tham chiếu đến các lớp Component, thực hiện logic giao tiếp phức tạp.

4. Component không biết nhau, chỉ thông báo đến Mediator khi có sự kiện. Mediator xử lý và gọi Component khác.

= Luồng hoạt động

#enum(
  [Component gọi `Mediator.notify(this)`],
  [Mediator nhận thông báo từ Component],
  [Mediator xác định Component cần nhận thông báo],
  [Mediator gọi phương thức thích hợp trên Component khác],
  [Các Component không biết nhau, chỉ biết Mediator],
)

= Ví dụ thực tế

#figure(
  image("images/example.png", width: 70%),
  caption: "Áp dụng mẫu Mediator
  vào hộp thoại đăng nhập/đăng xuất",
)


= Mã nguồn minh họa

```python
class Mediator(ABC):
    @abstractmethod
    def notify(self, sender, event): pass
```
```python
@dataclass
class Button:
    mediator: Mediator

    def click(self):
        self.mediator.notify(self, "click")

```
```python
@dataclass
class TextBox:
    mediator: Mediator

    text: str = ""
    def get_text(self): return self.text
    def set_text(self, text): self.text = text

```
#pagebreak()
```python
class ConcreteMediator(Mediator):
    def __init__(self, btn: Button, txtbox: TextBox):
        self.button = btn
        self.textbox = txtbox

    def notify(self, sender, event):
        if (sender == self.button)
        and (event == "click"):
            if self.validate_data(
              self.textbox.get_text()
            ): self.save_data()

    def validate_data(self, data): return bool(data)
    def save_data(self): print("Data saved!")
```

= Ứng dụng thực tế

- *Thư viện giao diện:* WinForms, Qt
- *Hệ thống nhắn tin: *Nhóm chat tập trung
- *Kiến trúc MVC:* Controller là Mediator
- *Lập trình game:* lớp Manager
- *Hệ thống phân tán:* Message broker

= Trường hợp áp dụng

Sử dụng Mediator khi:
- Khó sửa các lớp vì phụ thuộc chặt chẽ
- Không thể tái sử dụng Component vì phụ thuộc các lớp khác
- Phải tạo quá nhiều lớp kế thừa
- Logic giao tiếp giữa các đối tượng phức tạp

= Ưu nhược điểm

#box(stroke: 2pt + rgb("#4CAF50"), radius: 5pt, inset: 10pt, [
  ✓ *Ưu Điểm*
  - Đơn nghĩa vụ
  - Thêm được sửa không
  - Giảm phụ thuộc chặt chẽ
  - Dễ tái sử dụng
])

#box(stroke: 2pt + rgb("#F44336"), radius: 5pt, inset: 10pt, [
  ✗ *Nhược Điểm*
  - Mediator phải quản lí quá nhiều thứ
  - Khó debug, tăng độ phức tạp
])

= Cách áp dụng

+ Xác định các lớp liên quan chặt chẽ
+ Khai báo Mediator trừu tượng
+ Định nghĩa Mediator kế thừa
+ Sửa Component để sử dụng Mediator
+ Components gọi Mediator thay vì gọi nhau trực tiếp

= So sánh với các mẫu khác

*Mediator:* Giao tiếp hai chiều, giảm phụ thuộc, tập trung logic

*Facade:* Giao tiếp một chiều, cung cấp interface đơn, subsystem không biết

*Observer:* Phân tán giao tiếp, dynamic subscriptions, thông báo sự kiện

= Các mẫu liên quan

*Observer:* Mediator dùng Observer để giao tiếp

*Command:* Gói gọi thành command mà Mediator xử lý

*State:* Mediator chuyển trạng thái của Component

*Strategy:* Các chiến lược giao tiếp khác nhau

*Facade:* Mediator như Facade cho các lớp Component

= Lỗi thường gặp

*Lỗi thường gặp:*
- ❌ Mediator quá lớn (God Object)
- ❌ Các Component vẫn gọi nhau trực tiếp
- ❌ Mediator quản lí quá nhiều chi tiết

*Cách khắc phục:*
- ✓ Giữ interface đơn giản
- ✓ Sử dụng enum cho các loại event
- ✓ Chia nhỏ Mediator
- ✓ Hiểu rõ luồng giao tiếp
- ✓ Test các Component độc lập

= Tóm tắt

#box(stroke: 2pt + rgb("#2196F3"), radius: 5pt, inset: 12pt, [
  *Mẫu Mediator*

  Giảm phụ thuộc bằng cách tập trung giao tiếp giữa các lớp thông qua đối tượng trung gian.

  *Thích hợp cho:* UI phức tạp, logic trong game, hệ thống phân tán

  *Cần cẩn thận:* Mediator không được quá lớn

  *Cải thiện:* Tính bảo trì, tính tái sử dụng, tính dễ kiểm thử
])

#pagebreak()

#align(center + horizon)[
  #text(size: 28pt, weight: "bold")[
    Cảm ơn\
    vì đã mua sự chú ý!
  ]
]

#align(center + horizon)[
  #text(size: 15pt)[
    Nhóm 5
  ]

]
