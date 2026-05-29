#import "@preview/diatypst:0.8.0": *

#show: slides.with(
  title: "Interpreter - Phiên dịch",
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

- Tên gọi: Interpreter, phiên dịch
- Tên khác: Translater, Parser
- Phân loại: Behavioral Pattern (Mẫu ứng xử)

#box(stroke: 1pt + rgb("#2196F3"), radius: 5pt, inset: 12pt, [
  Xác định cấu trúc của một ngôn ngữ và cách giải thích các câu trong ngôn ngữ đó
])

= Mục đích & Ý định

#box(stroke: 2pt + rgb("#4CAF50"), radius: 5pt, inset: 12pt, [
  *Mục đích chính:* Định nghĩa một ngôn ngữ và cung cấp một phiên dịch viên để giải thích các câu trong ngôn ngữ đó.
])

*Ý định:*
- Tách biệt cấu trúc ngôn ngữ khỏi cách giải thích
- Dễ dàng thêm ngôn ngữ mới
- Giải quyết bài toán lặp lại

= Vấn đề

*Tình huống*: Cần phân tích và thực thi một ngôn ngữ đơn giản

*Vấn đề*: Nếu viết trực tiếp logic phân tích, sẽ khó mở rộng khi thêm quy tắc mới

#box(stroke: 1pt + rgb("#FF9800"), radius: 5pt, inset: 10pt, [
  Cần một cách để biểu diễn ngôn ngữ dưới dạng cấu trúc và dễ mở rộng
])

= Giải pháp

*Ý tưởng*: Định nghĩa các lớp cho từng phần tử ngôn ngữ

*Cách làm:*
- Tạo Abstract Expression cho các biểu thức
- Terminal Expression cho các phần tử cơ bản
- Non-Terminal Expression cho các quy tắc phức hợp

= Cấu trúc

*1. Abstract Expression:* Định nghĩa interface `interpret(context)`

*2. Terminal Expression:* Thực hiện phiên dịch cho ký tự/từ đơn giản

*3. Non-Terminal Expression:* Thực hiện phiên dịch cho quy tắc phức hợp (chứa các biểu thức khác)

*4. Context:* Chứa thông tin cần thiết cho phiên dịch

= Luồng hoạt động

#enum(
  [Phân tích chuỗi đầu vào thành cây biểu thức trừu tượng (AST)],
  [Gọi `interpret()` trên gốc cây AST],
  [Mỗi nút gọi `interpret()` trên nút con của nó],
  [Terminal Expression trả về kết quả cuối cùng],
  [Kết quả được truyền lên cây],
)

= Mã nguồn minh họa

```python
from abc import ABC, abstractmethod
from dataclasses import dataclass

class Expression(ABC):
    @abstractmethod
    def interpret(self, context: str) -> int: pass
```
```python
@dataclass
class Number(Expression):
    value: int

    def interpret(self, context: str) -> int:
        return self.value

```
```python
@dataclass
class Add(Expression):
    left: Expression
    right: Expression

    def interpret(self, context: str) -> int:
        return (self.left.interpret(context) +
                self.right.interpret(context))
```

#pagebreak()

```python
class Subtract(Expression):
    def __init__(self, left, right):
        self.left = left
        self.right = right

    def interpret(self, context: str) -> int:
        return (self.left.interpret(context) -
                self.right.interpret(context))

# Sử dụng: 5 + 3 - 2
expr = Subtract(
    Add(Number(5), Number(3)),
    Number(2)
)
result = expr.interpret("")  # = 6
```

= Ứng dụng thực tế

- *SQL Parser:* Phân tích câu lệnh SQL
- *Regular Expression:* Biểu thức chính quy
- *Compiler:* Biên dịch ngôn ngữ lập trình
- *Bộ lọc dữ liệu:* Phân tích điều kiện lọc
- *Công thức tính toán:* Excel, tính toán biểu thức

= Trường hợp áp dụng

Sử dụng Interpreter khi:
- Cần phân tích một ngôn ngữ đơn giản
- Ngôn ngữ có thể biểu diễn bằng cây đệ quy
- Số lượng quy tắc ngôn ngữ không quá lớn
- Hiệu suất không phải ưu tiên hàng đầu

= Ưu nhược điểm

#box(stroke: 2pt + rgb("#4CAF50"), radius: 5pt, inset: 10pt, [
  ✓ *Ưu Điểm*
  - Dễ thêm quy tắc mới
  - Tách biệt cấu trúc ngôn ngữ khỏi logic
  - Dễ hiểu và bảo trì
  - Tuân theo Single Responsibility
])

#box(stroke: 2pt + rgb("#F44336"), radius: 5pt, inset: 10pt, [
  ✗ *Nhược Điểm*
  - Hiệu suất thấp với ngôn ngữ phức tạp
  - Cây biểu thức quá lớn
  - Khó debug luồng phiên dịch
  - Không thích hợp cho ngôn ngữ lớn
])

= Cách áp dụng

+ Xác định ngôn ngữ cần phiên dịch
+ Tạo Abstract Expression interface
+ Tạo Terminal Expression cho ký tự/từ
+ Tạo Non-Terminal Expression cho quy tắc
+ Xây dựng parser để tạo cây biểu thức
+ Gọi interpret() trên gốc cây

= So sánh với các mẫu khác

*Interpreter:* Phân tích và thực thi ngôn ngữ

*Visitor:* Duyệt qua cây đối tượng, thực hiện hành động

*Strategy:* Chọn chiến lược thực thi tại runtime

*Composite:* Tạo cây các đối tượng phức hợp

= Các mẫu liên quan

*Composite:* Interpreter sử dụng cây Composite

*Visitor:* Có thể dùng Visitor để duyệt cây biểu thức

*Iterator:* Duyệt các phần tử trong cây

*Factory Method:* Tạo các Expression khác nhau

= Lỗi thường gặp

*Lỗi thường gặp:*
- ❌ Cây biểu thức quá sâu gây stack overflow
- ❌ Không xử lý lỗi phân tích
- ❌ Context quá phức tạp

*Cách khắc phục:*
- ✓ Giới hạn độ sâu cây
- ✓ Thêm xử lý ngoại lệ
- ✓ Đơn giản hóa Context
- ✓ Cache kết quả (Memoization)
- ✓ Dùng regex cho ngôn ngữ đơn giản

= Tóm tắt

#box(stroke: 2pt + rgb("#2196F3"), radius: 5pt, inset: 12pt, [
  *Mẫu Interpreter*

  Định nghĩa ngôn ngữ bằng cách tạo các lớp cho mỗi quy tắc và phiên dịch cây biểu thức.

  *Thích hợp cho:* Ngôn ngữ đơn giản, DSL, Parser

  *Cần cẩn thận:* Hiệu suất, độ phức tạp ngôn ngữ

  *Cải thiện:* Tính mở rộng, khả năng bảo trì, tách biệt logic
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
