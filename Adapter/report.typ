#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

= Adapter (Phát)

== Tên và phân loại

*Adapter Pattern* còn được gọi là *Wrapper* hoặc *Translator*. Trong tiếng Việt, có thể hiểu đây là *mẫu chuyển đổi giao diện*.

Adapter thuộc nhóm *Structural Pattern* vì trọng tâm của nó không nằm ở thuật toán xử lý nghiệp vụ, mà nằm ở cách tổ chức, ghép nối và làm cho các lớp hoặc object có interface khác nhau có thể làm việc cùng nhau. Nói cách khác, Adapter giải quyết vấn đề tương thích ở tầng cấu trúc giữa các thành phần phần mềm.

== Vấn đề cần giải quyết

Trong thực tế, hệ thống phần mềm hiếm khi được xây dựng hoàn toàn từ đầu và hiếm khi mọi thành phần đều có interface khớp với nhau. Khi phát triển hoặc bảo trì hệ thống, ta thường gặp các tình huống như:

- Ứng dụng đang làm việc thông qua một interface chuẩn, ví dụ `IPaymentGateway`, `INotificationSender`, `IJsonParser`, nhưng thư viện bên thứ ba lại cung cấp class với tên hàm, kiểu dữ liệu hoặc quy ước gọi hàm khác.
- Hệ thống cũ trả dữ liệu ở dạng XML, trong khi module mới chỉ nhận và xử lý JSON.
- Client code đã ổn định, đã được kiểm thử, nhưng cần tích hợp thêm một service mới không tuân theo interface hiện tại.
- Một ứng dụng cần kết nối nhiều nhà cung cấp khác nhau, chẳng hạn nhiều cổng thanh toán, nhiều dịch vụ gửi email/SMS, nhiều API vận chuyển; mỗi bên lại đặt tên hàm và định dạng dữ liệu khác nhau.
- Một class cũ vẫn còn giá trị sử dụng, nhưng không thể sửa trực tiếp vì nó thuộc thư viện bên ngoài, hệ thống legacy, hoặc việc sửa có thể gây ảnh hưởng dây chuyền.

Vấn đề cốt lõi là: *làm sao sử dụng được một object có interface không khớp với interface mà client đang mong đợi, nhưng không phải sửa client code và cũng không phải sửa class cũ?*

Nếu giải quyết bằng cách sửa trực tiếp client để gọi class mới, client sẽ phụ thuộc vào chi tiết cụ thể của class đó. Khi có thêm một thư viện khác, client lại phải sửa tiếp. Cách làm này làm tăng coupling, làm giảm khả năng mở rộng và khiến code khó bảo trì.

Adapter Pattern đưa ra một hướng tiếp cận an toàn hơn: giữ nguyên client, giữ nguyên class có sẵn, và đặt một lớp trung gian ở giữa để chuyển đổi lời gọi.

== Định nghĩa

*Adapter Pattern* là một design pattern cho phép các object có interface không tương thích có thể làm việc với nhau bằng cách đặt một lớp trung gian gọi là `Adapter`. Lớp này cung cấp interface mà client mong muốn, đồng thời bên trong nó chuyển đổi lời gọi sang interface thật sự của object được tái sử dụng, gọi là `Adaptee`.

Có thể mô tả ngắn gọn như sau:

- Client chỉ biết và chỉ phụ thuộc vào `Target` interface.
- `Adaptee` là class có sẵn, có chức năng cần dùng nhưng interface không phù hợp.
- `Adapter` implement `Target`, bên trong giữ hoặc kế thừa `Adaptee`, sau đó chuyển lời gọi từ `Target` sang lời gọi phù hợp với `Adaptee`.

Nhờ vậy, client có thể làm việc với `Adaptee` một cách gián tiếp mà không cần biết `Adaptee` thật sự hoạt động ra sao.

== Ý tưởng cốt lõi

Ý tưởng chính của Adapter là *bọc một object có interface không tương thích bên trong một object mới*, rồi object mới đó cung cấp interface mà client mong muốn.

Adapter thường thực hiện ba việc quan trọng:

1. Nhận request từ client theo interface chuẩn (`Target`).
2. Chuyển đổi request đó sang dạng mà object cũ hoặc service bên ngoài hiểu được.
3. Gọi phương thức thật sự của `Adaptee`, sau đó chuyển đổi kết quả trả về nếu cần.

Có thể hình dung Adapter giống như một bộ chuyển đổi ổ cắm điện. Thiết bị điện không cần thay đổi chân cắm, ổ điện trên tường cũng không cần thay đổi cấu trúc. Bộ chuyển đổi đứng ở giữa, nhận một chuẩn đầu vào và biến nó thành chuẩn đầu ra phù hợp.

Trong phần mềm, Adapter cũng đóng vai trò tương tự: nó không làm thay đổi bản chất nghiệp vụ của `Adaptee`, mà chỉ giúp `Adaptee` trở nên tương thích với phần còn lại của hệ thống.

== Thành phần chính

Một cấu trúc Adapter Pattern điển hình gồm bốn thành phần:

=== Client

`Client` là phần code sử dụng chức năng thông qua interface chuẩn. Client không nên biết class cụ thể nào đang xử lý phía sau. Nó chỉ gọi phương thức được định nghĩa trong `Target`.

Ví dụ, trong một hệ thống thanh toán, client chỉ gọi:

```csharp
paymentGateway.Pay(amount);
```

Client không cần biết phía sau là Stripe, PayPal, MoMo hay một cổng thanh toán nội bộ.

=== Target

`Target` là interface mà client mong muốn sử dụng. Đây là hợp đồng chung giữa client và các implementation.

Ví dụ:

```csharp
public interface IPaymentGateway
{
    PaymentResult Pay(decimal amount, string currency);
}
```

Mọi class muốn được client sử dụng như một cổng thanh toán đều cần tuân theo interface này.

=== Adaptee

`Adaptee` là class có sẵn, có chức năng thật sự cần dùng, nhưng interface của nó không tương thích với `Target`.

Ví dụ, một thư viện thanh toán bên thứ ba có thể cung cấp class như sau:

```csharp
public class StripeService
{
    public StripeResponse Charge(long amountInCents, string currencyCode)
    {
        // Gọi API thật sự của Stripe
    }
}
```

Ở đây, `StripeService` có thể thanh toán được, nhưng nó không có hàm `Pay(decimal amount, string currency)`. Nó dùng `Charge(long amountInCents, string currencyCode)`, nên client không thể dùng trực tiếp theo interface `IPaymentGateway`.

=== Adapter

`Adapter` là class trung gian. Nó implement `Target`, giữ tham chiếu đến `Adaptee`, và chuyển lời gọi từ client sang lời gọi mà `Adaptee` hiểu được.

Ví dụ:

```csharp
public class StripePaymentAdapter : IPaymentGateway
{
    private readonly StripeService _stripeService;

    public StripePaymentAdapter(StripeService stripeService)
    {
        _stripeService = stripeService;
    }

    public PaymentResult Pay(decimal amount, string currency)
    {
        long amountInCents = (long)(amount * 100);
        StripeResponse response = _stripeService.Charge(amountInCents, currency);

        return new PaymentResult(
            success: response.IsSuccess,
            transactionId: response.TransactionId,
            message: response.Message
        );
    }
}
```

Client vẫn chỉ thấy `IPaymentGateway`, còn chi tiết chuyển đổi sang `StripeService` được giấu bên trong adapter.

== Cấu trúc UML

Dưới đây là class diagram tổng quát bằng PlantUML:

```plantuml
@startuml
skinparam classAttributeIconSize 0

class Client

interface Target {
  +request(data)
}

class Adapter {
  -adaptee: Adaptee
  +request(data)
}

class Adaptee {
  +specificRequest(specificData)
}

Client --> Target : uses
Adapter ..|> Target
Adapter --> Adaptee : delegates / translates

note bottom of Adapter
  specificData = convert(data)
  return adaptee.specificRequest(specificData)
end note
@enduml
```

Trong sơ đồ này:

- `Client` chỉ phụ thuộc vào `Target`.
- `Adapter` hiện thực `Target`, nên có thể được truyền vào client như một implementation bình thường.
- `Adapter` giữ tham chiếu đến `Adaptee` và gọi phương thức thật của `Adaptee`.
- Phần chuyển đổi dữ liệu, đổi tên hàm, đổi kiểu trả về hoặc xử lý mapping nằm trong `Adapter`.

== Luồng hoạt động

Luồng hoạt động của Adapter Pattern có thể mô tả theo các bước sau:

1. Client gọi một phương thức thông qua interface `Target`.
2. Vì object thật được truyền vào client là `Adapter`, lời gọi đi vào `Adapter`.
3. `Adapter` kiểm tra, chuyển đổi hoặc mapping dữ liệu đầu vào sang định dạng mà `Adaptee` hiểu được.
4. `Adapter` gọi phương thức thật sự của `Adaptee`.
5. `Adaptee` xử lý logic hoặc gọi service bên ngoài.
6. Nếu `Adaptee` trả về kết quả theo định dạng riêng, `Adapter` tiếp tục chuyển đổi kết quả đó về định dạng mà `Target` quy định.
7. Client nhận kết quả theo đúng interface quen thuộc, không cần biết có sự tồn tại của `Adaptee` phía sau.

Sequence diagram minh họa:

```plantuml
@startuml
actor Client
participant "Target Interface" as Target
participant Adapter
participant Adaptee

Client -> Target : request(data)
Target -> Adapter : request(data)
Adapter -> Adapter : convert(data)
Adapter -> Adaptee : specificRequest(specificData)
Adaptee --> Adapter : specificResult
Adapter -> Adapter : convertResult(specificResult)
Adapter --> Client : result
@enduml
```

== Phân loại Adapter

Adapter thường có hai biến thể chính: *object adapter* và *class adapter*.

=== Object Adapter

Object Adapter dùng composition hoặc delegation. Adapter giữ một instance của `Adaptee` ở bên trong, sau đó ủy quyền lời gọi cho instance đó.

Đây là cách phổ biến trong C\#, Java và nhiều ngôn ngữ hướng đối tượng hiện đại vì nó linh hoạt và không phụ thuộc vào đa kế thừa class.

Ưu điểm:

- Linh hoạt vì có thể thay đổi `Adaptee` lúc runtime.
- Có thể adapter cho nhiều subclass của `Adaptee`.
- Phù hợp với nguyên tắc ưu tiên composition hơn inheritance.

Nhược điểm:

- Cần viết thêm code chuyển tiếp lời gọi.
- Nếu có nhiều phương thức cần chuyển đổi, adapter có thể dài.

=== Class Adapter

Class Adapter dùng inheritance. Adapter kế thừa từ `Adaptee` và đồng thời implement `Target`.

Cách này chỉ phù hợp với ngôn ngữ hỗ trợ đa kế thừa class hoặc trong trường hợp cấu trúc kế thừa cho phép. Trong C\#, class adapter bị hạn chế vì C\# không hỗ trợ đa kế thừa class.

Ưu điểm:

- Có thể override hành vi của `Adaptee` nếu cần.
- Không cần giữ tham chiếu riêng đến `Adaptee`.

Nhược điểm:

- Kém linh hoạt hơn object adapter.
- Phụ thuộc chặt vào class cụ thể.
- Không phù hợp nếu cần adapter nhiều subclass khác nhau.

== Ví dụ minh họa bằng C\#

Giả sử hệ thống hiện tại chỉ làm việc với interface `IPaymentGateway`. Sau này hệ thống cần tích hợp Stripe, nhưng thư viện Stripe lại có interface khác.

=== Target

```csharp
public interface IPaymentGateway
{
    PaymentResult Pay(decimal amount, string currency);
}

public class PaymentResult
{
    public bool Success { get; }
    public string TransactionId { get; }
    public string Message { get; }

    public PaymentResult(bool success, string transactionId, string message)
    {
        Success = success;
        TransactionId = transactionId;
        Message = message;
    }
}
```

=== Adaptee

```csharp
public class StripeService
{
    public StripeResponse Charge(long amountInCents, string currencyCode)
    {
        Console.WriteLine($"Charging {amountInCents} cents via Stripe...");

        return new StripeResponse(
            isSuccess: true,
            transactionId: Guid.NewGuid().ToString(),
            message: "Stripe payment completed"
        );
    }
}

public class StripeResponse
{
    public bool IsSuccess { get; }
    public string TransactionId { get; }
    public string Message { get; }

    public StripeResponse(bool isSuccess, string transactionId, string message)
    {
        IsSuccess = isSuccess;
        TransactionId = transactionId;
        Message = message;
    }
}
```

=== Adapter

```csharp
public class StripePaymentAdapter : IPaymentGateway
{
    private readonly StripeService _stripeService;

    public StripePaymentAdapter(StripeService stripeService)
    {
        _stripeService = stripeService;
    }

    public PaymentResult Pay(decimal amount, string currency)
    {
        long amountInCents = ConvertToCents(amount);
        StripeResponse stripeResponse = _stripeService.Charge(amountInCents, currency);

        return new PaymentResult(
            success: stripeResponse.IsSuccess,
            transactionId: stripeResponse.TransactionId,
            message: stripeResponse.Message
        );
    }

    private static long ConvertToCents(decimal amount)
    {
        return (long)(amount * 100);
    }
}
```

=== Client

```csharp
public class CheckoutService
{
    private readonly IPaymentGateway _paymentGateway;

    public CheckoutService(IPaymentGateway paymentGateway)
    {
        _paymentGateway = paymentGateway;
    }

    public void Checkout(decimal totalAmount)
    {
        PaymentResult result = _paymentGateway.Pay(totalAmount, "USD");

        if (result.Success)
        {
            Console.WriteLine($"Payment success: {result.TransactionId}");
        }
        else
        {
            Console.WriteLine($"Payment failed: {result.Message}");
        }
    }
}
```

=== Chạy thử

```csharp
var stripeService = new StripeService();
IPaymentGateway gateway = new StripePaymentAdapter(stripeService);

var checkoutService = new CheckoutService(gateway);
checkoutService.Checkout(19.99m);
```

Điểm quan trọng là `CheckoutService` không phụ thuộc vào `StripeService`. Nếu sau này thay Stripe bằng PayPal hoặc MoMo, ta chỉ cần tạo adapter mới implement `IPaymentGateway`, client không cần sửa.

== UML cho ví dụ thanh toán

```plantuml
@startuml
skinparam classAttributeIconSize 0

class CheckoutService {
  -paymentGateway: IPaymentGateway
  +Checkout(totalAmount: decimal): void
}

interface IPaymentGateway {
  +Pay(amount: decimal, currency: string): PaymentResult
}

class StripePaymentAdapter {
  -stripeService: StripeService
  +Pay(amount: decimal, currency: string): PaymentResult
  -ConvertToCents(amount: decimal): long
}

class StripeService {
  +Charge(amountInCents: long, currencyCode: string): StripeResponse
}

class PaymentResult {
  +Success: bool
  +TransactionId: string
  +Message: string
}

class StripeResponse {
  +IsSuccess: bool
  +TransactionId: string
  +Message: string
}

CheckoutService --> IPaymentGateway
StripePaymentAdapter ..|> IPaymentGateway
StripePaymentAdapter --> StripeService
IPaymentGateway ..> PaymentResult
StripeService ..> StripeResponse
StripePaymentAdapter ..> PaymentResult
StripePaymentAdapter ..> StripeResponse
@enduml
```

== Khả năng ứng dụng

Nên cân nhắc dùng Adapter Pattern khi:

- Muốn tái sử dụng một class có sẵn nhưng interface của class đó không khớp với interface hệ thống đang dùng.
- Muốn tích hợp thư viện bên thứ ba mà không làm client code phụ thuộc trực tiếp vào thư viện đó.
- Muốn che giấu sự khác biệt giữa nhiều vendor/service khác nhau bằng một interface thống nhất.
- Muốn giữ nguyên code cũ đã ổn định và chỉ thêm lớp chuyển đổi ở bên ngoài.
- Muốn áp dụng Open/Closed Principle: thêm adapter mới thay vì sửa client cũ.
- Cần chuyển đổi định dạng dữ liệu giữa các module, ví dụ XML sang JSON, DTO bên ngoài sang domain model nội bộ, hoặc response của API bên thứ ba sang response chuẩn của hệ thống.

Không nên lạm dụng Adapter nếu:

- Hai interface đã tương thích hoặc chỉ khác rất nhỏ và có thể thống nhất ngay từ thiết kế ban đầu.
- Adapter phải chứa quá nhiều logic nghiệp vụ, khiến nó không còn là lớp chuyển đổi mà trở thành một service phức tạp.
- Sự khác biệt giữa hai hệ thống không chỉ là interface mà còn là mô hình nghiệp vụ hoàn toàn khác nhau. Khi đó cần thiết kế lại boundary rõ hơn, có thể dùng Anti-Corruption Layer thay vì một adapter đơn giản.

== Đánh giá

=== Ưu điểm

- *Giảm phụ thuộc giữa client và class bên ngoài*: client chỉ phụ thuộc vào `Target`, không phụ thuộc trực tiếp vào `Adaptee`.
- *Tái sử dụng được class cũ*: có thể dùng lại thư viện hoặc module legacy mà không cần sửa code gốc.
- *Tuân thủ Open/Closed Principle*: muốn hỗ trợ thêm service mới thì thêm adapter mới, hạn chế sửa code client.
- *Tách biệt logic chuyển đổi*: mọi mapping về tên hàm, kiểu dữ liệu, định dạng request/response được gom vào adapter.
- *Hỗ trợ kiểm thử tốt hơn*: client có thể được test bằng mock của `Target`, không cần khởi tạo service thật bên ngoài.
- *Giảm rủi ro khi tích hợp*: thay vì rải logic gọi API bên thứ ba khắp hệ thống, ta cô lập nó trong adapter.

=== Nhược điểm

- *Tăng số lượng class*: mỗi interface hoặc service không tương thích thường cần thêm một adapter riêng.
- *Có thể làm kiến trúc rườm rà*: nếu dùng adapter cho những khác biệt quá nhỏ, code có thể bị over-engineering.
- *Adapter có thể phình to*: nếu `Adaptee` quá khác biệt, adapter phải xử lý nhiều mapping phức tạp.
- *Không giải quyết khác biệt nghiệp vụ sâu*: Adapter chủ yếu xử lý khác biệt interface. Nếu hai hệ thống có quy tắc nghiệp vụ mâu thuẫn, cần giải pháp thiết kế rộng hơn.
- *Có thể che giấu lỗi thiết kế*: nếu trong cùng một hệ thống nội bộ mà phải tạo quá nhiều adapter, đó có thể là dấu hiệu các module đang thiếu chuẩn interface chung.

== Lưu ý khi cài đặt

Khi triển khai Adapter Pattern, cần lưu ý một số điểm sau:

- Nên để client phụ thuộc vào interface `Target`, không phụ thuộc trực tiếp vào adapter cụ thể.
- Adapter chỉ nên chịu trách nhiệm chuyển đổi interface và dữ liệu, không nên chứa nhiều business rule.
- Nếu tích hợp API bên thứ ba, nên gom toàn bộ logic chuyển đổi request/response, exception, mã lỗi vào adapter để tránh rò rỉ chi tiết bên ngoài vào domain nội bộ.
- Với C\#, Java, TypeScript, object adapter thường linh hoạt hơn class adapter.
- Nên đặt tên adapter theo ý nghĩa chuyển đổi, ví dụ `StripePaymentAdapter`, `LegacyUserAdapter`, `XmlOrderAdapter`.
- Nếu có nhiều adapter cho cùng một interface, có thể kết hợp với Dependency Injection để chọn implementation phù hợp.
- Nếu cần bọc cả một subsystem phức tạp, cần cân nhắc Facade thay vì Adapter.

== So sánh với các pattern liên quan

=== Adapter và Facade

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Adapter*], [*Facade*],
  [Mục đích chính], [Chuyển đổi interface không tương thích thành interface client mong muốn.], [Đơn giản hóa cách sử dụng một hệ thống con phức tạp.],
  [Vấn đề giải quyết], [Client không dùng được class có sẵn vì khác interface.], [Client không muốn làm việc trực tiếp với nhiều class hoặc nhiều bước phức tạp.],
  [Có thay đổi interface không?], [Có. Adapter biến interface của `Adaptee` thành `Target`.], [Có thể có, nhưng mục tiêu chính là gom và đơn giản hóa thao tác.],
  [Thường bọc], [Một class hoặc một service không tương thích.], [Nhiều class hoặc cả một subsystem.],
  [Ví dụ], [`StripePaymentAdapter` biến `StripeService` thành `IPaymentGateway`.], [`OrderFacade` gọi Inventory, Payment, Shipping để hoàn tất đơn hàng.],
)

Tóm lại, Adapter tập trung vào *tương thích interface*, còn Facade tập trung vào *đơn giản hóa cách sử dụng hệ thống phức tạp*.

=== Adapter và Decorator

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Adapter*], [*Decorator*],
  [Mục đích chính], [Làm interface không tương thích trở nên tương thích.], [Thêm chức năng mới cho object mà không sửa object gốc.],
  [Interface sau khi bọc], [Thường khác với interface của `Adaptee`.], [Thường giống interface của object gốc.],
  [Có thay đổi hành vi không?], [Có thể có chuyển đổi lời gọi và dữ liệu.], [Có, bằng cách bổ sung hành vi trước/sau khi gọi object gốc.],
  [Tập trung vào], [Tương thích interface.], [Mở rộng chức năng.],
  [Ví dụ], [`StripePaymentAdapter` biến `StripeService` thành `IPaymentGateway`.], [`LoggingPaymentGateway` thêm logging trước/sau khi thanh toán.],
)

Decorator thường giữ nguyên interface để client vẫn dùng object như cũ nhưng có thêm chức năng. Adapter thường đổi interface để client có thể dùng được object vốn không tương thích.

=== Adapter và Bridge

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Adapter*], [*Bridge*],
  [Nhóm pattern], [Structural.], [Structural.],
  [Mục đích], [Kết nối các interface không tương thích.], [Tách abstraction khỏi implementation để cả hai phát triển độc lập.],
  [Thời điểm dùng], [Thường dùng sau khi đã có class hoặc service không tương thích.], [Thường được thiết kế từ đầu để hệ thống dễ mở rộng.],
  [Quan hệ chính], [`Adapter` bọc hoặc giữ tham chiếu đến `Adaptee`.], [`Abstraction` giữ tham chiếu đến `Implementor`.],
  [Vấn đề chính], [“Tôi có class này nhưng interface không khớp.”], [“Tôi muốn abstraction và implementation thay đổi độc lập.”],
)

Adapter thường mang tính chữa cháy hoặc tích hợp, còn Bridge thường là một quyết định thiết kế có chủ đích từ sớm.

=== Adapter và Proxy

#table(
  columns: (1.4fr, 2fr, 2fr),
  inset: 6pt,
  align: horizon,
  [*Tiêu chí*], [*Adapter*], [*Proxy*],
  [Mục đích chính], [Chuyển đổi interface.], [Kiểm soát truy cập đến object thật.],
  [Interface], [Thường khác interface của object được bọc.], [Thường giống interface của object thật.],
  [Vai trò], [Làm cho object không tương thích dùng được.], [Thêm lớp đại diện để lazy loading, caching, authorization, remote access.],
  [Ví dụ], [Bọc API thanh toán bên ngoài thành `IPaymentGateway`.], [Bọc service thật để kiểm tra quyền trước khi gọi.],
)

Proxy không nhằm mục tiêu đổi interface. Nó thường giữ nguyên interface và kiểm soát việc truy cập đến object thật.

== Ví dụ trong hệ thống thực tế

Adapter Pattern xuất hiện rất nhiều trong các hệ thống thực tế:

- *Database driver*: ứng dụng làm việc thông qua interface chung, còn driver cụ thể chuyển lời gọi sang MySQL, PostgreSQL, SQL Server hoặc Oracle.
- *Cổng thanh toán*: hệ thống định nghĩa `IPaymentGateway`, sau đó tạo adapter cho Stripe, PayPal, MoMo, VNPay hoặc ZaloPay.
- *Dịch vụ gửi thông báo*: client gọi `INotificationSender.Send()`, adapter chuyển sang API riêng của email provider, SMS provider hoặc push notification provider.
- *Chuyển đổi dữ liệu*: adapter chuyển XML từ hệ thống cũ thành DTO hoặc JSON cho module mới.
- *Tích hợp legacy system*: một hệ thống mới có thể gọi chức năng cũ thông qua adapter thay vì sửa toàn bộ legacy code.
- *Phần cứng và thiết bị*: driver hoặc lớp giao tiếp thiết bị cũng có thể đóng vai trò adapter giữa hệ điều hành và phần cứng.

== Kết luận

Adapter Pattern là một mẫu thiết kế quan trọng khi hệ thống cần tích hợp các thành phần không tương thích nhưng vẫn muốn giữ client code ổn định. Thay vì sửa client hoặc sửa class cũ, ta tạo một lớp adapter để chuyển đổi interface, dữ liệu và kết quả trả về.

Pattern này đặc biệt hữu ích trong các tình huống tích hợp thư viện bên thứ ba, hệ thống legacy, nhiều vendor hoặc nhiều API bên ngoài. Tuy nhiên, cần dùng đúng mục đích: Adapter nên là lớp chuyển đổi mỏng, tập trung vào tương thích interface, không nên trở thành nơi chứa quá nhiều business logic.

Có thể ghi nhớ Adapter bằng câu ngắn gọn:

*Adapter giúp một class có interface không phù hợp trở nên dùng được trong hệ thống hiện tại mà không cần sửa client và không cần sửa class gốc.*
