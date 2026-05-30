#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

= Facade Pattern

== Tên và phân loại

*Facade Pattern* có thể hiểu là *mẫu mặt tiền*. Từ "facade" mang nghĩa là mặt ngoài hoặc lớp giao diện phía trước của một công trình. Trong thiết kế phần mềm, Facade đóng vai trò tương tự: nó đứng phía trước một hệ thống con phức tạp và cung cấp cho client một cách sử dụng đơn giản hơn.

Facade thuộc nhóm *Structural Pattern* vì nó tập trung vào cách tổ chức và ghép nối các lớp/object trong hệ thống. Pattern này không thay đổi nghiệp vụ chính của các subsystem, mà tạo thêm một lớp trung gian để client không phải tương tác trực tiếp với quá nhiều class bên trong.

Nói ngắn gọn, Facade là một lớp "cửa vào" cấp cao cho một nhóm class/service phức tạp.

== Vấn đề cần giải quyết

Trong nhiều hệ thống, một chức năng nhìn từ bên ngoài có vẻ đơn giản nhưng bên trong lại cần phối hợp nhiều class, service hoặc subsystem khác nhau.

Ví dụ trong chức năng đặt hàng của một hệ thống thương mại điện tử, client có thể phải gọi nhiều thành phần:

- `InventoryService` để kiểm tra và trừ tồn kho.
- `PaymentService` để xử lý thanh toán.
- `OrderService` để tạo đơn hàng.
- `ShippingService` để tạo yêu cầu giao hàng.
- `EmailService` để gửi email xác nhận.
- `NotificationService` để gửi thông báo cho người dùng.

Nếu client phải tự gọi trực tiếp từng service, code client sẽ trở nên phức tạp:

```csharp
inventory.CheckStock(productId, quantity);
payment.Pay(userId, amount);
order.CreateOrder(userId, items);
shipping.CreateShipment(orderId);
email.SendConfirmation(userEmail, orderId);
```

Cách thiết kế này tạo ra nhiều vấn đề:

- Client biết quá nhiều chi tiết nội bộ của subsystem.
- Client phải biết gọi service nào trước, service nào sau.
- Khi subsystem thay đổi, nhiều nơi trong client có thể phải sửa theo.
- Logic điều phối bị lặp lại ở nhiều màn hình, controller hoặc service khác nhau.
- Code client khó đọc vì bị trộn giữa mục tiêu nghiệp vụ cấp cao và các thao tác kỹ thuật cấp thấp.
- Hệ thống dễ bị coupling chặt giữa tầng bên ngoài và các class bên trong.

Vấn đề cốt lõi là: *làm sao cung cấp một interface đơn giản, thống nhất để client sử dụng một hệ thống phức tạp bên trong mà không cần biết toàn bộ chi tiết triển khai?*

Facade Pattern giải quyết vấn đề này bằng cách đặt một lớp trung gian ở phía trước subsystem. Client chỉ gọi Facade, còn Facade chịu trách nhiệm điều phối các subsystem cần thiết.

== Mục đích và ý định

Mục đích chính của Facade là *đơn giản hóa cách sử dụng một subsystem phức tạp*.

Facade không nhất thiết phải thay thế toàn bộ subsystem. Các class bên trong vẫn tồn tại và vẫn có thể được dùng trực tiếp nếu cần. Tuy nhiên, với các use case phổ biến, Facade cung cấp một API cấp cao giúp client làm việc dễ hơn.

Facade thường được dùng để:

- Cung cấp một điểm truy cập đơn giản cho một nhóm class phức tạp.
- Che giấu thứ tự gọi nhiều subsystem.
- Giảm phụ thuộc giữa client và subsystem.
- Gom logic điều phối nhiều service vào một nơi rõ ràng.
- Làm cho code client ngắn gọn và dễ đọc hơn.
- Tạo ranh giới giữa các layer trong kiến trúc nhiều tầng.

Ví dụ, thay vì controller phải gọi `InventoryService`, `PaymentService`, `OrderService`, `ShippingService` và `EmailService`, controller chỉ cần gọi:

```csharp
checkoutFacade.Checkout(request);
```

== Định nghĩa

*Facade Pattern* là một structural design pattern cung cấp một interface đơn giản, thống nhất cho một tập hợp interface phức tạp trong một subsystem.

Định nghĩa ngắn gọn:

- `Client` cần thực hiện một chức năng cấp cao.
- `Subsystem Classes` là các class/service thực hiện logic thật sự.
- `Facade` đứng trước subsystem và cung cấp các phương thức đơn giản cho client.
- Client gọi Facade thay vì gọi trực tiếp nhiều subsystem.
- Facade điều phối thứ tự gọi các subsystem và có thể tổng hợp kết quả trả về.

Nói đơn giản, Facade là "mặt tiền" của một hệ thống phức tạp. Client không cần biết bên trong có bao nhiêu class, các class đó liên hệ thế nào, hoặc phải gọi theo thứ tự nào. Client chỉ cần gọi một phương thức cấp cao từ Facade.

== Ý tưởng cốt lõi

Ý tưởng chính của Facade Pattern là *gom nhiều thao tác phức tạp của nhiều class con vào một class cấp cao*, để client chỉ cần làm việc với một điểm truy cập đơn giản.

Facade thường thực hiện các việc sau:

1. Nhận request từ client.
2. Kiểm tra hoặc chuẩn hóa dữ liệu đầu vào nếu cần.
3. Gọi các subsystem cần thiết.
4. Điều phối thứ tự xử lý giữa các subsystem.
5. Ẩn chi tiết phức tạp bên trong.
6. Tổng hợp hoặc chuyển đổi kết quả nếu cần.
7. Trả kết quả đơn giản cho client.

Có thể hình dung luồng xử lý như sau:

```text
Client -> Facade -> Subsystem A
                 -> Subsystem B
                 -> Subsystem C
                 -> Subsystem D
```

Client chỉ nhìn thấy Facade. Các subsystem phía sau có thể phức tạp, có nhiều dependency hoặc nhiều bước xử lý, nhưng những chi tiết đó được đóng gói bên trong Facade.

== Thành phần chính

Một cấu trúc Facade Pattern điển hình gồm ba nhóm thành phần chính.

=== Client

`Client` là đối tượng sử dụng chức năng cấp cao. Client có thể là controller, UI, API endpoint, service khác hoặc một module bên ngoài.

Client không nên phải biết quá nhiều chi tiết nội bộ của subsystem. Thay vào đó, client chỉ cần gọi các phương thức rõ nghĩa trên Facade.

Ví dụ:

```csharp
await checkoutFacade.CheckoutAsync(request);
```

Ở đây client không cần biết bên trong checkout gồm những bước nào.

=== Facade

`Facade` là lớp trung gian cung cấp interface đơn giản cho client.

Nhiệm vụ của Facade là:

- Giữ tham chiếu đến các subsystem cần thiết.
- Cung cấp các method cấp cao như `Checkout()`, `PlaceOrder()`, `GenerateReport()`.
- Gọi các subsystem theo đúng thứ tự.
- Ẩn chi tiết xử lý phức tạp.
- Có thể chuyển đổi dữ liệu đầu vào/đầu ra để client dễ dùng hơn.

Facade không nên chứa toàn bộ business logic chi tiết. Nó chủ yếu là nơi *orchestrate* hoặc *coordinate* các subsystem.

=== Subsystem Classes

`Subsystem Classes` là các class/service thật sự xử lý logic bên trong.

Ví dụ trong hệ thống đặt hàng:

- `InventoryService` xử lý tồn kho.
- `PaymentService` xử lý thanh toán.
- `OrderService` xử lý đơn hàng.
- `EmailService` xử lý gửi email.

Các subsystem không nhất thiết phải biết Facade tồn tại. Chúng chỉ tập trung vào trách nhiệm riêng của mình.

=== Additional Facade

Trong hệ thống lớn, có thể có nhiều Facade khác nhau cho nhiều nhóm use case khác nhau.

Ví dụ:

- `CheckoutFacade` cho luồng thanh toán.
- `ReportFacade` cho luồng xuất báo cáo.
- `UserManagementFacade` cho luồng quản lý người dùng.

Việc chia nhỏ Facade giúp tránh tình trạng một Facade quá lớn và trở thành God Class.

== Cấu trúc UML tổng quát

Dưới đây là class diagram tổng quát bằng PlantUML:

```plantuml
@startuml
skinparam classAttributeIconSize 0

class Client {
  +DoWork()
}

class Facade {
  -subsystemA: SubsystemA
  -subsystemB: SubsystemB
  -subsystemC: SubsystemC
  +Operation()
}

class SubsystemA {
  +OperationA()
}

class SubsystemB {
  +OperationB()
}

class SubsystemC {
  +OperationC()
}

Client --> Facade : uses
Facade --> SubsystemA
Facade --> SubsystemB
Facade --> SubsystemC

note right of Facade
Facade cung cấp API cấp cao
và điều phối các subsystem.
end note

note bottom of Client
Client không cần biết
chi tiết subsystem.
end note
@enduml
```

== UML minh họa: Checkout Facade

Ví dụ dưới đây mô phỏng chức năng checkout trong hệ thống bán hàng. `OrderController` chỉ gọi `CheckoutFacade`, còn Facade điều phối nhiều service bên trong.

```plantuml
@startuml
skinparam classAttributeIconSize 0

class OrderController {
  -checkoutFacade: CheckoutFacade
  +PlaceOrder(request: CheckoutRequest): CheckoutResult
}

class CheckoutFacade {
  -inventoryService: InventoryService
  -paymentService: PaymentService
  -orderService: OrderService
  -emailService: EmailService
  +Checkout(request: CheckoutRequest): CheckoutResult
}

class InventoryService {
  +CheckStock(items: List<OrderItem>): bool
  +ReserveStock(items: List<OrderItem>)
}

class PaymentService {
  +Pay(userId: Guid, amount: decimal): PaymentResult
}

class OrderService {
  +CreateOrder(request: CheckoutRequest): Order
}

class EmailService {
  +SendConfirmation(email: string, orderId: Guid)
}

class CheckoutRequest {
  +UserId: Guid
  +Email: string
  +Items: List<OrderItem>
}

class CheckoutResult {
  +Success: bool
  +Message: string
  +OrderId: Guid
}

OrderController --> CheckoutFacade
CheckoutFacade --> InventoryService
CheckoutFacade --> PaymentService
CheckoutFacade --> OrderService
CheckoutFacade --> EmailService
CheckoutFacade ..> CheckoutRequest
CheckoutFacade ..> CheckoutResult
@enduml
```

== Luồng hoạt động

Luồng hoạt động cơ bản của Facade Pattern gồm các bước:

1. Client cần thực hiện một chức năng cấp cao.
2. Client gọi một phương thức đơn giản trên Facade.
3. Facade nhận request và xác định các subsystem cần dùng.
4. Facade gọi các subsystem theo đúng thứ tự.
5. Các subsystem xử lý công việc chuyên biệt của chúng.
6. Facade có thể tổng hợp kết quả hoặc xử lý lỗi.
7. Client nhận kết quả mà không cần biết chi tiết bên trong.

Với ví dụ checkout:

```text
OrderController
    -> CheckoutFacade.Checkout()
        -> InventoryService.CheckStock()
        -> InventoryService.ReserveStock()
        -> PaymentService.Pay()
        -> OrderService.CreateOrder()
        -> EmailService.SendConfirmation()
    <- CheckoutResult
```

Điểm quan trọng là controller không cần chứa logic điều phối các service. Nếu sau này cần thêm `CouponService`, `ShippingService` hoặc `NotificationService`, ta có thể sửa trong Facade thay vì sửa nhiều controller khác nhau.

== Ví dụ code C\#

=== Subsystem classes

```csharp
public sealed class InventoryService
{
    public bool CheckStock(IEnumerable<OrderItem> items)
    {
        Console.WriteLine("Checking inventory...");
        return items.All(item => item.Quantity > 0);
    }

    public void ReserveStock(IEnumerable<OrderItem> items)
    {
        Console.WriteLine("Reserving stock...");
    }
}

public sealed class PaymentService
{
    public PaymentResult Pay(Guid userId, decimal amount)
    {
        Console.WriteLine($"Processing payment: {amount:N0} VND");
        return new PaymentResult(true, "Payment successful");
    }
}

public sealed class OrderService
{
    public Order CreateOrder(CheckoutRequest request)
    {
        Console.WriteLine("Creating order...");
        return new Order(Guid.NewGuid(), request.UserId, request.TotalAmount);
    }
}

public sealed class EmailService
{
    public void SendConfirmation(string email, Guid orderId)
    {
        Console.WriteLine($"Sending confirmation email to {email} for order {orderId}");
    }
}
```

=== Model đơn giản

```csharp
public sealed record OrderItem(Guid ProductId, int Quantity, decimal UnitPrice);

public sealed record CheckoutRequest(
    Guid UserId,
    string Email,
    IReadOnlyList<OrderItem> Items)
{
    public decimal TotalAmount => Items.Sum(item => item.Quantity * item.UnitPrice);
}

public sealed record PaymentResult(bool Success, string Message);

public sealed record Order(Guid Id, Guid UserId, decimal TotalAmount);

public sealed record CheckoutResult(bool Success, string Message, Guid? OrderId = null);
```

=== Facade

```csharp
public sealed class CheckoutFacade
{
    private readonly InventoryService _inventoryService;
    private readonly PaymentService _paymentService;
    private readonly OrderService _orderService;
    private readonly EmailService _emailService;

    public CheckoutFacade(
        InventoryService inventoryService,
        PaymentService paymentService,
        OrderService orderService,
        EmailService emailService)
    {
        _inventoryService = inventoryService;
        _paymentService = paymentService;
        _orderService = orderService;
        _emailService = emailService;
    }

    public CheckoutResult Checkout(CheckoutRequest request)
    {
        if (!_inventoryService.CheckStock(request.Items))
        {
            return new CheckoutResult(false, "Not enough stock");
        }

        _inventoryService.ReserveStock(request.Items);

        PaymentResult paymentResult = _paymentService.Pay(
            request.UserId,
            request.TotalAmount);

        if (!paymentResult.Success)
        {
            return new CheckoutResult(false, paymentResult.Message);
        }

        Order order = _orderService.CreateOrder(request);
        _emailService.SendConfirmation(request.Email, order.Id);

        return new CheckoutResult(true, "Checkout successful", order.Id);
    }
}
```

=== Client

```csharp
public sealed class OrderController
{
    private readonly CheckoutFacade _checkoutFacade;

    public OrderController(CheckoutFacade checkoutFacade)
    {
        _checkoutFacade = checkoutFacade;
    }

    public CheckoutResult PlaceOrder(CheckoutRequest request)
    {
        return _checkoutFacade.Checkout(request);
    }
}
```

=== Chạy thử

```csharp
var facade = new CheckoutFacade(
    new InventoryService(),
    new PaymentService(),
    new OrderService(),
    new EmailService());

var controller = new OrderController(facade);

var request = new CheckoutRequest(
    Guid.NewGuid(),
    "customer@example.com",
    new List<OrderItem>
    {
        new(Guid.NewGuid(), 2, 50000),
        new(Guid.NewGuid(), 1, 120000)
    });

CheckoutResult result = controller.PlaceOrder(request);
Console.WriteLine(result.Message);
```

Client chỉ gọi `PlaceOrder()` hoặc `Checkout()`, không cần tự điều phối tồn kho, thanh toán, tạo đơn và gửi email.

== Đánh giá

=== Ưu điểm

*Giảm độ phức tạp cho client.* Client không cần biết nhiều class/service bên trong. Nó chỉ cần gọi một API cấp cao.

*Che giấu chi tiết xử lý nội bộ.* Thứ tự gọi subsystem, cách xử lý lỗi, cách tổng hợp kết quả được đặt bên trong Facade.

*Giảm coupling giữa client và subsystem.* Khi subsystem thay đổi, nếu interface của Facade vẫn giữ nguyên thì client ít bị ảnh hưởng.

*Phù hợp với kiến trúc nhiều layer.* Facade có thể đóng vai trò service cấp cao ở tầng application, giúp controller hoặc UI không chứa quá nhiều logic điều phối.

*Dễ bảo trì hơn khi subsystem thay đổi.* Ví dụ thêm `CouponService` hoặc đổi `EmailService` thành `NotificationService`, ta có thể cập nhật trong Facade.

*Code client dễ đọc hơn.* Thay vì đọc nhiều lời gọi rời rạc, client thể hiện rõ ý định nghiệp vụ: `Checkout()`, `GenerateReport()`, `RegisterUser()`.

=== Nhược điểm

*Facade có thể trở thành God Class.* Nếu gom quá nhiều chức năng không liên quan vào một Facade, class này sẽ phình to và khó bảo trì.

*Có thể che giấu quá nhiều chi tiết quan trọng.* Một số client cần kiểm soát chi tiết hơn, nhưng Facade lại chỉ cung cấp API cấp cao.

*Không thay thế được thiết kế subsystem tốt.* Nếu subsystem bên trong được thiết kế kém, Facade chỉ che bớt sự phức tạp ở bên ngoài chứ không làm hệ thống thật sự tốt hơn.

*Có thể làm giảm tính linh hoạt.* Client muốn gọi subsystem theo cách đặc biệt có thể bị giới hạn bởi API của Facade.

*Dễ bị lạm dụng.* Không phải mọi nhóm class đều cần Facade. Nếu subsystem đơn giản, thêm Facade có thể chỉ làm tăng số lượng class không cần thiết.

== Khi nào nên dùng

Nên dùng Facade Pattern khi:

- Client phải gọi quá nhiều class/service để thực hiện một use case.
- Có một subsystem phức tạp cần được ẩn sau một API đơn giản.
- Muốn giảm phụ thuộc giữa tầng bên ngoài và các class bên trong.
- Muốn gom logic điều phối nhiều service vào một nơi rõ ràng.
- Muốn tạo một boundary giữa các layer hoặc module.
- Có nhiều client cùng lặp lại một chuỗi thao tác giống nhau.
- Muốn cung cấp API đơn giản cho thư viện hoặc framework nội bộ.

Ví dụ phù hợp:

- `CheckoutFacade` trong hệ thống bán hàng.
- `ReportFacade` để gom nhiều bước truy vấn, tính toán và xuất file.
- `AuthenticationFacade` để gom login, token, refresh token và audit log.
- `FileProcessingFacade` để gom đọc file, parse, validate và import dữ liệu.

== Khi nào không nên dùng

Không nên dùng Facade Pattern khi:

- Subsystem rất đơn giản, client chỉ cần gọi một hoặc hai method.
- Client thật sự cần kiểm soát chi tiết từng subsystem.
- Facade chỉ chuyển tiếp method một cách máy móc mà không đơn giản hóa gì.
- Facade gom quá nhiều chức năng không liên quan.
- Vấn đề chính là interface không tương thích; trường hợp đó nên cân nhắc Adapter.
- Vấn đề chính là thêm hành vi mới cho object; trường hợp đó nên cân nhắc Decorator.

Một dấu hiệu lạm dụng Facade là class có tên rất chung như `SystemFacade`, `AppFacade`, `ManagerFacade` nhưng chứa hàng chục method không liên quan.

== So sánh Facade và Adapter

Cả Facade và Adapter đều thuộc nhóm Structural Pattern, đều có thể bọc một hoặc nhiều object bên trong. Tuy nhiên mục đích của chúng khác nhau.

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Facade*], [*Adapter*],
  [Mục đích chính], [Đơn giản hóa cách sử dụng một subsystem phức tạp.], [Làm hai interface không tương thích có thể làm việc với nhau.],
  [Vấn đề giải quyết], [Client phải gọi quá nhiều class hoặc quá nhiều bước.], [Client không dùng được class có sẵn vì interface không khớp.],
  [Số lượng class thường bọc], [Thường bọc nhiều class/subsystem.], [Thường bọc một class hoặc một service không tương thích.],
  [Có tập trung vào tương thích interface không?], [Không phải trọng tâm chính.], [Có, đây là trọng tâm chính.],
  [Client dùng vì], [Muốn API đơn giản hơn.], [Muốn dùng lại class không tương thích.],
  [Ví dụ], [`CheckoutFacade.Checkout()` gọi nhiều service.], [`StripeAdapter.Pay()` gọi `StripeService.MakePayment()`.]
)

Tóm lại: Facade giải quyết vấn đề *phức tạp khi sử dụng subsystem*, còn Adapter giải quyết vấn đề *không tương thích interface*.

== So sánh Facade và Decorator

Facade và Decorator đều có thể được xem là một lớp bọc bên ngoài object khác. Tuy nhiên ý định thiết kế khác nhau.

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Facade*], [*Decorator*],
  [Mục đích chính], [Đơn giản hóa cách dùng subsystem.], [Thêm chức năng mới cho object mà không sửa class gốc.],
  [Interface sau khi bọc], [Thường là interface cấp cao và đơn giản hơn.], [Thường giữ cùng interface với object gốc.],
  [Đối tượng được bọc], [Nhiều class/service bên trong.], [Một object cụ thể hoặc nhiều wrapper lồng nhau.],
  [Tập trung vào], [Đơn giản hóa và che giấu phức tạp.], [Mở rộng hành vi.],
  [Ví dụ], [`CheckoutFacade` gọi Payment, Inventory, Email.], [`LoggingPaymentGateway` thêm logging trước/sau khi thanh toán.]
)

Tóm lại: Facade làm hệ thống dễ dùng hơn, còn Decorator làm object có thêm hành vi mới.

== So sánh Facade và Mediator

Facade và Mediator đôi khi dễ bị nhầm vì cả hai đều đứng giữa nhiều object. Khác biệt nằm ở quan hệ và mục tiêu.

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Facade*], [*Mediator*],
  [Mục đích chính], [Cung cấp interface đơn giản cho subsystem.], [Điều phối giao tiếp giữa nhiều object.],
  [Quan hệ với các object], [Facade đứng trước subsystem.], [Mediator đứng giữa các object ngang hàng.],
  [Client có biết subsystem không?], [Thường không cần biết.], [Các object thường biết mediator.],
  [Trọng tâm], [Đơn giản hóa cách sử dụng.], [Giảm phụ thuộc nhiều-nhiều giữa các object.],
  [Ví dụ], [`CheckoutFacade` gọi Payment, Inventory, Email.], [`ChatRoomMediator` điều phối các user gửi tin nhắn.]
)

Tóm lại: Facade là cửa vào đơn giản cho một subsystem, còn Mediator là trung tâm điều phối tương tác giữa nhiều object ngang hàng.

== So sánh Facade và Proxy

Facade và Proxy đều có thể đứng trước object khác, nhưng mục tiêu không giống nhau.

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Facade*], [*Proxy*],
  [Mục đích chính], [Đơn giản hóa một hệ thống phức tạp.], [Kiểm soát quyền truy cập đến object thật.],
  [Interface], [Có thể cung cấp interface mới, cấp cao hơn.], [Thường giữ cùng interface với real subject.],
  [Đối tượng phía sau], [Nhiều subsystem.], [Một object thật hoặc tài nguyên từ xa.],
  [Tập trung vào], [Đơn giản hóa sử dụng.], [Lazy loading, access control, caching, remote access.],
  [Ví dụ], [`ReportFacade.GenerateMonthlyReport()`], [`ImageProxy.Display()` tải ảnh khi cần.]
)

== Liên hệ với kiến trúc phần mềm

Trong các dự án thực tế, Facade thường xuất hiện dưới các tên như:

- `ApplicationService`
- `UseCaseService`
- `Orchestrator`
- `Coordinator`
- `Gateway`
- `Manager`, nếu dùng đúng phạm vi

Ví dụ trong Clean Architecture hoặc DDD, tầng Application thường chứa các service điều phối use case. Những service này có thể mang tinh thần của Facade vì chúng cung cấp API cấp cao cho controller và điều phối domain service, repository, external service.

Tuy nhiên, không nên đánh đồng mọi service với Facade. Một class chỉ nên được xem là Facade khi nó thật sự đơn giản hóa việc sử dụng một nhóm subsystem phức tạp.

== Lưu ý khi triển khai

Để dùng Facade hiệu quả, cần chú ý một số điểm:

- Đặt tên method theo use case cấp cao, ví dụ `Checkout()`, `RegisterUser()`, `GenerateReport()`.
- Không để Facade chứa quá nhiều logic chi tiết. Logic chuyên biệt nên nằm trong subsystem.
- Không gom nhiều use case không liên quan vào một Facade.
- Có thể chia Facade theo module hoặc bounded context.
- Không bắt buộc client chỉ được dùng Facade. Với nhu cầu đặc biệt, client nội bộ vẫn có thể dùng subsystem trực tiếp.
- Kiểm soát kích thước Facade để tránh God Class.
- Dùng dependency injection để truyền subsystem vào Facade thay vì tự khởi tạo cứng bên trong.

== Kết luận

Facade Pattern là một mẫu thiết kế hữu ích khi hệ thống có nhiều class/service bên trong và client cần một cách sử dụng đơn giản hơn. Pattern này giúp giảm độ phức tạp cho client, che giấu chi tiết xử lý nội bộ, giảm coupling và làm code cấp cao dễ đọc hơn.

Điểm mạnh nhất của Facade là biến một quy trình phức tạp thành một lời gọi đơn giản. Tuy nhiên, Facade không sửa được thiết kế kém của subsystem và cũng không nên bị lạm dụng thành một God Class chứa mọi thứ.

Có thể ghi nhớ Facade bằng câu sau:

*Facade không làm subsystem biến mất; nó chỉ tạo một cửa vào đơn giản để client không phải đi qua quá nhiều cánh cửa nhỏ bên trong.*
