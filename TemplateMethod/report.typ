

== Tên và phân loại

*Template Method Pattern* là một mẫu thiết kế thuộc nhóm *Behavioral Pattern*. Nhóm Behavioral tập trung vào cách các object hoặc class phối hợp hành vi với nhau.

Template Method giải quyết bài toán khi nhiều class có chung một quy trình tổng quát, nhưng một số bước trong quy trình đó lại khác nhau tùy từng class con.

Nói ngắn gọn, Template Method giúp cố định “khung thuật toán” ở class cha, còn các bước chi tiết có thể được class con tùy biến.

== Vấn đề cần giải quyết

Trong nhiều hệ thống, ta thường gặp nhiều class thực hiện cùng một workflow tổng quát. Nếu mỗi class tự viết lại toàn bộ workflow, code sẽ bị trùng lặp và dễ sai lệch thứ tự xử lý.

Ví dụ hệ thống xử lý thanh toán. Dù thanh toán bằng thẻ, ví điện tử hay tiền mặt, quy trình tổng quát có thể giống nhau:

1. Validate đơn hàng.
2. Tính tổng tiền.
3. Xử lý thanh toán.
4. Cập nhật trạng thái đơn hàng.
5. Gửi thông báo.

Điểm khác nhau thường chỉ nằm ở bước xử lý thanh toán:

- Thẻ tín dụng cần gọi cổng thanh toán ngân hàng.
- Ví điện tử cần gọi API của ví.
- Tiền mặt có thể không gọi API thanh toán mà chỉ ghi nhận trạng thái chờ thu tiền.

Nếu không dùng Template Method, ta có thể viết lặp như sau:

```csharp
public class CreditCardPayment
{
    public void Pay(Order order)
    {
        ValidateOrder(order);
        var amount = CalculateAmount(order);
        ProcessCreditCard(amount);
        UpdateOrderStatus(order);
        SendNotification(order);
    }
}

public class MomoPayment
{
    public void Pay(Order order)
    {
        ValidateOrder(order);
        var amount = CalculateAmount(order);
        ProcessMomo(amount);
        UpdateOrderStatus(order);
        SendNotification(order);
    }
}
```

Các bước `ValidateOrder`, `CalculateAmount`, `UpdateOrderStatus`, `SendNotification` bị lặp lại. Nếu sau này muốn thêm một bước mới như ghi audit log, ta phải sửa nhiều class.

Vấn đề đặt ra là:

*Làm sao tái sử dụng được phần quy trình chung, đảm bảo thứ tự thuật toán không bị thay đổi lung tung, nhưng vẫn cho phép class con tùy biến một số bước cụ thể?*

== Định nghĩa

*Template Method Pattern* định nghĩa bộ khung của một thuật toán trong class cha, nhưng cho phép class con override một số bước cụ thể mà không làm thay đổi cấu trúc tổng thể của thuật toán.

Trong pattern này:

- Class cha chứa một method chính gọi là *template method*.
- Template method định nghĩa thứ tự các bước của thuật toán.
- Một số bước được cài sẵn trong class cha.
- Một số bước là abstract/virtual để class con triển khai hoặc tùy biến.
- Client thường gọi template method mà không cần biết chi tiết từng bước bên trong.

Nói đơn giản:

*Template Method cố định quy trình chung, nhưng mở ra các điểm tùy biến bên trong quy trình đó.*

== Ý tưởng cốt lõi

Ý tưởng chính của Template Method là:

*Đưa những phần giống nhau lên class cha, còn những phần thay đổi thì để class con override.*

Class cha đóng vai trò người “điều phối quy trình”. Nó biết bước nào chạy trước, bước nào chạy sau. Class con chỉ chịu trách nhiệm cài đặt các phần khác nhau.

Ví dụ:

```csharp
public abstract class PaymentProcessor
{
    public void Pay(Order order)
    {
        ValidateOrder(order);
        var amount = CalculateAmount(order);
        ProcessPayment(amount);
        UpdateOrderStatus(order);
        SendNotification(order);
    }

    protected abstract void ProcessPayment(decimal amount);
}
```

Ở đây, `Pay()` là template method. Nó cố định workflow thanh toán. Các class con chỉ cần override `ProcessPayment()`.

== Thành phần chính

#table(
  columns: (32%, 68%),
  inset: 8pt,
  align: (left, left),
  [*Thành phần*], [*Vai trò*],
  [*AbstractClass*], [Class cha định nghĩa template method và các bước của thuật toán.],
  [*Template Method*], [Method cố định thứ tự thực hiện các bước. Thường không nên override.],
  [*Primitive Operations*], [Các bước cụ thể mà class con bắt buộc phải triển khai.],
  [*ConcreteClass*], [Class con triển khai các bước còn thiếu hoặc tùy biến bước đã có.],
  [*Hook Methods*], [Các điểm mở rộng tùy chọn; class con có thể override hoặc bỏ qua.],
)

== UML bằng PlantUML

=== UML tổng quát

```plantuml
@startuml
skinparam classAttributeIconSize 0

abstract class AbstractClass {
  +TemplateMethod()
  #StepOne()
  #StepTwo()
  #StepThree()
  #Hook()
}

class ConcreteClassA {
  #StepTwo()
  #StepThree()
}

class ConcreteClassB {
  #StepTwo()
  #StepThree()
  #Hook()
}

AbstractClass <|-- ConcreteClassA
AbstractClass <|-- ConcreteClassB

note right of AbstractClass
  TemplateMethod() cố định workflow.
  Các Step/Hook là điểm tùy biến.
end note
@enduml
```

=== UML ví dụ PaymentProcessor

```plantuml
@startuml
skinparam classAttributeIconSize 0

class Order {
  +Id: Guid
  +Total: decimal
  +Status: string
}

abstract class PaymentProcessor {
  +Pay(order: Order)
  #ValidateOrder(order: Order)
  #CalculateAmount(order: Order): decimal
  #BeforePayment(order: Order)
  #ProcessPayment(amount: decimal)
  #UpdateOrderStatus(order: Order)
  #ShouldSendNotification(): bool
  #SendNotification(order: Order)
}

class CreditCardPaymentProcessor {
  #BeforePayment(order: Order)
  #ProcessPayment(amount: decimal)
}

class MomoPaymentProcessor {
  #ProcessPayment(amount: decimal)
}

class CashPaymentProcessor {
  #ProcessPayment(amount: decimal)
  #ShouldSendNotification(): bool
}

PaymentProcessor <|-- CreditCardPaymentProcessor
PaymentProcessor <|-- MomoPaymentProcessor
PaymentProcessor <|-- CashPaymentProcessor
PaymentProcessor --> Order
@enduml
```

== Luồng hoạt động

Luồng hoạt động của Template Method:

1. Client tạo object của class con.
2. Client gọi template method trên object đó.
3. Template method ở class cha bắt đầu chạy.
4. Class cha thực hiện các bước chung.
5. Khi đến bước cần tùy biến, class cha gọi method đã được override ở class con.
6. Sau đó template method tiếp tục chạy các bước còn lại.
7. Client nhận kết quả mà không cần biết chi tiết từng bước.

Sequence diagram:

```plantuml
@startuml
actor Client
participant "ConcretePaymentProcessor" as Concrete
participant "PaymentProcessor" as Base

Client -> Concrete: Pay(order)
activate Concrete
Concrete -> Base: ValidateOrder(order)
Concrete -> Base: CalculateAmount(order)
Concrete -> Concrete: ProcessPayment(amount)
Concrete -> Base: UpdateOrderStatus(order)
Concrete -> Base: SendNotification(order)
Concrete --> Client: done
deactivate Concrete
@enduml
```

== Code minh họa C\#

=== Domain đơn giản

```csharp
public class Order
{
    public Guid Id { get; set; } = Guid.NewGuid();
    public decimal Total { get; set; }
    public string Status { get; set; } = "Pending";
    public string CustomerEmail { get; set; } = string.Empty;
}
```

=== Abstract class chứa template method

```csharp
public abstract class PaymentProcessor
{
    // Template Method: cố định workflow thanh toán.
    public void Pay(Order order)
    {
        ValidateOrder(order);
        decimal amount = CalculateAmount(order);

        BeforePayment(order);          // Hook method
        ProcessPayment(amount);        // Primitive operation

        UpdateOrderStatus(order);

        if (ShouldSendNotification())  // Hook method
        {
            SendNotification(order);
        }
    }

    protected virtual void ValidateOrder(Order order)
    {
        if (order == null)
            throw new ArgumentNullException(nameof(order));

        if (order.Total <= 0)
            throw new InvalidOperationException("Order total must be greater than zero.");
    }

    protected virtual decimal CalculateAmount(Order order)
    {
        return order.Total;
    }

    protected virtual void BeforePayment(Order order)
    {
        // Hook method: mặc định không làm gì.
        // Class con có thể override nếu cần.
    }

    protected abstract void ProcessPayment(decimal amount);

    protected virtual void UpdateOrderStatus(Order order)
    {
        order.Status = "Paid";
        Console.WriteLine($"Order {order.Id} status updated to Paid.");
    }

    protected virtual bool ShouldSendNotification()
    {
        return true;
    }

    protected virtual void SendNotification(Order order)
    {
        Console.WriteLine($"Send payment confirmation to {order.CustomerEmail}.");
    }
}
```

=== Concrete class cho từng loại thanh toán

```csharp
public class CreditCardPaymentProcessor : PaymentProcessor
{
    protected override void BeforePayment(Order order)
    {
        Console.WriteLine("Checking credit card fraud risk...");
    }

    protected override void ProcessPayment(decimal amount)
    {
        Console.WriteLine($"Charging credit card: {amount:N0} VND");
    }
}

public class MomoPaymentProcessor : PaymentProcessor
{
    protected override void ProcessPayment(decimal amount)
    {
        Console.WriteLine($"Calling MoMo API: {amount:N0} VND");
    }
}

public class CashPaymentProcessor : PaymentProcessor
{
    protected override void ProcessPayment(decimal amount)
    {
        Console.WriteLine($"Mark as cash on delivery: {amount:N0} VND");
    }

    protected override bool ShouldSendNotification()
    {
        return false;
    }
}
```

=== Client sử dụng

```csharp
var order = new Order
{
    Total = 150_000,
    CustomerEmail = "customer@example.com"
};

PaymentProcessor processor = new MomoPaymentProcessor();
processor.Pay(order);
```

Client chỉ gọi `Pay(order)`. Nó không cần quan tâm bên trong có những bước nào và thứ tự ra sao. Class cha đảm bảo workflow chung, class con chỉ thay đổi phần thanh toán cụ thể.

== Đánh giá

=== Ưu điểm

#table(
  columns: (35%, 65%),
  inset: 8pt,
  align: (left, left),
  [*Ưu điểm*], [*Giải thích*],
  [Tái sử dụng code chung], [Các bước giống nhau được đưa lên class cha, tránh lặp code ở nhiều class con.],
  [Đảm bảo thứ tự thuật toán], [Template method cố định workflow, class con khó làm sai thứ tự xử lý.],
  [Cho phép tùy biến một phần thuật toán], [Class con chỉ override các bước cần thay đổi.],
  [Tuân thủ Open/Closed ở mức nhất định], [Có thể thêm class con mới mà ít phải sửa workflow chung.],
  [Tách phần ổn định và phần thay đổi], [Phần ổn định nằm ở class cha, phần biến đổi nằm ở primitive operation/hook.],
)

=== Nhược điểm

#table(
  columns: (35%, 65%),
  inset: 8pt,
  align: (left, left),
  [*Nhược điểm*], [*Giải thích*],
  [Phụ thuộc vào kế thừa], [Class con bị ràng buộc vào class cha, kém linh hoạt hơn composition.],
  [Class cha có thể khó hiểu], [Nếu workflow lớn và có nhiều hook, abstract class dễ trở nên phức tạp.],
  [Class con bị giới hạn bởi khung thuật toán],
  [Nếu class con cần workflow rất khác, Template Method không còn phù hợp.],

  [Có thể vi phạm LSP], [Nếu class con override sai ý đồ, behavior có thể không còn đúng với kỳ vọng của class cha.],
  [Khó đổi thuật toán lúc runtime], [Vì variation nằm trong class con, không linh hoạt bằng Strategy.],
)

== Khi nào nên dùng và không nên dùng

=== Nên dùng khi

- Nhiều class có chung một quy trình tổng quát.
- Một số bước trong quy trình thay đổi tùy class con.
- Muốn tránh lặp code ở nhiều class.
- Muốn đảm bảo thứ tự xử lý luôn nhất quán.
- Workflow tương đối ổn định, chỉ có một vài điểm mở rộng.

Ví dụ phù hợp:

- Import file: open file → parse → validate → save → close.
- Xử lý thanh toán: validate → calculate → pay → update → notify.
- Data mining: load data → clean → transform → analyze → export.
- Report generation: fetch data → format → render → export.
- Game AI turn: select target → move → attack → end turn.

=== Không nên dùng khi

- Các thuật toán thay đổi nhiều và cần đổi lúc runtime.
- Không muốn phụ thuộc vào kế thừa.
- Mỗi class có workflow rất khác nhau.
- Class cha phải chứa quá nhiều hook để đáp ứng mọi trường hợp.
- Có thể dùng composition linh hoạt hơn, ví dụ Strategy hoặc pipeline.

== So sánh với các pattern liên quan

=== Template Method vs Strategy

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Template Method*], [*Strategy*],
  [Nhóm pattern], [Behavioral.], [Behavioral.],
  [Cơ chế chính], [Kế thừa.], [Composition.],
  [Phần thay đổi nằm ở], [Class con override method.], [Object strategy được truyền vào.],
  [Workflow tổng thể], [Thường cố định trong class cha.], [Context có thể thay đổi strategy linh hoạt.],
  [Đổi thuật toán runtime], [Khó hơn.], [Dễ hơn.],
  [Coupling], [Class con phụ thuộc class cha.], [Context phụ thuộc abstraction strategy.],
  [Ví dụ], [`PaymentProcessor.Pay()` cố định quy trình.], [`IPaymentStrategy.Pay()` thay đổi cách thanh toán.],
)

=== Template Method vs Factory Method

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Template Method*], [*Factory Method*],
  [Nhóm pattern], [Behavioral.], [Creational.],
  [Mục đích], [Định nghĩa khung thuật toán.], [Tạo object thông qua method cho class con quyết định.],
  [Class con override để], [Tùy biến một bước xử lý.], [Quyết định object nào được tạo.],
  [Trọng tâm], [Luồng xử lý.], [Khởi tạo object.],
  [Ví dụ], [`Import()` gồm open, parse, save, close.], [`CreateButton()` trả về WindowsButton/MacButton.],
)

=== Template Method vs Hook Method

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Template Method*], [*Hook Method*],
  [Vai trò], [Method chính định nghĩa workflow.], [Điểm mở rộng tùy chọn trong workflow.],
  [Có bắt buộc override không?],
  [Không nên override template method nếu muốn giữ workflow.],
  [Không bắt buộc override.],

  [Thường nằm ở đâu?], [Class cha.], [Class cha.],
  [Ví dụ], [`Pay()`], [`BeforePayment()`, `ShouldSendNotification()`],
)

=== Template Method vs Chain of Responsibility

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Template Method*], [*Chain of Responsibility*],
  [Mục đích], [Cố định các bước của một thuật toán.], [Truyền request qua chuỗi handler.],
  [Thứ tự xử lý], [Được class cha định nghĩa cố định.], [Do cách nối chain quyết định.],
  [Ai xử lý?], [Nhiều method trong cùng object/class hierarchy.], [Nhiều object handler khác nhau.],
  [Có thể dừng giữa chừng không?], [Có thể, nhưng không phải trọng tâm.], [Có, đây là đặc điểm phổ biến.],
  [Ví dụ], [Quy trình import file.], [Middleware xử lý request.],
)

=== Template Method vs Decorator

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Template Method*], [*Decorator*],
  [Nhóm pattern], [Behavioral.], [Structural.],
  [Mục đích], [Cố định workflow và cho class con tùy biến bước.], [Bọc object để thêm hành vi mới.],
  [Cơ chế], [Kế thừa.], [Composition/wrapping.],
  [Thời điểm mở rộng], [Thông qua subclass.], [Thông qua wrapper object.],
  [Ví dụ],
  [Các class thanh toán override `ProcessPayment()`.],
  [`LoggingPaymentGateway` bọc payment gateway để thêm logging.],
)

== Kết luận

Template Method là pattern phù hợp khi nhiều class có cùng một quy trình xử lý tổng quát nhưng khác nhau ở một vài bước. Nó giúp tái sử dụng code chung, tránh lặp workflow và đảm bảo thứ tự thuật toán nhất quán.

Tuy nhiên, pattern này dựa nhiều vào kế thừa. Nếu hệ thống cần thay đổi thuật toán linh hoạt lúc runtime hoặc muốn giảm phụ thuộc vào class cha, Strategy hoặc các thiết kế dùng composition có thể phù hợp hơn.
