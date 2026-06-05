#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

= Chain of Responsibility Pattern

== Tên và phân loại

*Chain of Responsibility Pattern* thường được viết tắt là *CoR*. Trong tiếng Việt, có thể hiểu là *mẫu chuỗi trách nhiệm*.

Chain of Responsibility thuộc nhóm *Behavioral Pattern* vì trọng tâm của nó nằm ở cách các object phối hợp để xử lý một request. Pattern này không tập trung vào việc tổ chức cấu trúc lớp như Adapter hay Facade, mà tập trung vào *luồng xử lý hành vi* giữa nhiều đối tượng.

Ý nghĩa của tên gọi “Chain of Responsibility” là: trách nhiệm xử lý request không bị gắn cứng vào một object duy nhất, mà được đặt vào một chuỗi các handler. Mỗi handler trong chuỗi có quyền xử lý request, từ chối request, hoặc chuyển tiếp request cho handler kế tiếp.

== Vấn đề cần giải quyết

Trong nhiều hệ thống thực tế, một request trước khi được xử lý chính thức thường phải đi qua nhiều bước khác nhau. Ví dụ trong một web API, một request có thể cần đi qua các bước:

- Ghi log request để phục vụ audit hoặc debug.
- Kiểm tra authentication để xác định người dùng đã đăng nhập hay chưa.
- Kiểm tra authorization để xác định người dùng có quyền thực hiện thao tác hay không.
- Validate dữ liệu đầu vào.
- Kiểm tra rate limit, cache, transaction hoặc các điều kiện nghiệp vụ phụ.
- Cuối cùng mới thực hiện business logic chính.

Nếu viết toàn bộ logic này trong một hàm duy nhất, code rất dễ biến thành một khối điều kiện lồng nhau:

```csharp
if (authenticated)
{
    if (authorized)
    {
        if (valid)
        {
            Process();
        }
    }
}
```

Cách viết này có một số vấn đề lớn:

- Hàm xử lý chính bị phình to vì chứa quá nhiều trách nhiệm.
- Mỗi lần thêm một bước xử lý mới, ta phải sửa code cũ.
- Thứ tự xử lý bị gắn cứng vào một nơi, khó thay đổi linh hoạt.
- Các bước như logging, authentication, validation khó tái sử dụng ở nhiều flow khác.
- Code khó test vì nhiều điều kiện bị lồng vào nhau.
- Debug phức tạp khi request có nhiều nhánh xử lý.

Vấn đề cốt lõi là: *làm sao để một request có thể đi qua nhiều bước xử lý khác nhau mà client không cần biết chính xác object nào sẽ xử lý, thứ tự xử lý có thể thay đổi, và mỗi bước vẫn giữ trách nhiệm riêng biệt?*

Chain of Responsibility giải quyết vấn đề này bằng cách tách từng bước xử lý thành một handler độc lập, sau đó nối các handler lại thành một chuỗi.

== Mục đích và ý định

Mục đích chính của Chain of Responsibility là *tránh việc sender phụ thuộc trực tiếp vào receiver cụ thể* bằng cách cho nhiều object trong một chuỗi có cơ hội xử lý request.

Client chỉ gửi request vào đầu chuỗi. Sau đó, request có thể:

- Được một handler xử lý rồi dừng lại.
- Được một handler xử lý một phần rồi chuyển tiếp.
- Đi qua nhiều handler cho đến handler cuối cùng.
- Bị chặn lại nếu một handler phát hiện request không hợp lệ.
- Không được handler nào xử lý nếu chain không có handler phù hợp.

Pattern này đặc biệt phù hợp với các pipeline xử lý như middleware, validation pipeline, approval workflow, logging pipeline, authentication flow và event processing.

== Định nghĩa

*Chain of Responsibility Pattern* là một behavioral design pattern cho phép truyền một request qua một chuỗi các handler. Mỗi handler quyết định sẽ xử lý request, chuyển tiếp request cho handler kế tiếp, hoặc dừng chuỗi xử lý.

Định nghĩa ngắn gọn:

- `Client` gửi request vào chain.
- `Handler` định nghĩa interface chung cho các object xử lý request.
- `ConcreteHandler` là các handler cụ thể, mỗi handler phụ trách một bước hoặc một điều kiện xử lý.
- Mỗi handler thường giữ tham chiếu đến handler kế tiếp.
- Sender không cần biết handler cụ thể nào sẽ xử lý request.

Điểm quan trọng của pattern này là *tách sender khỏi receiver*. Client không gọi trực tiếp `AuthenticationHandler`, `AuthorizationHandler`, `ValidationHandler` hay `BusinessHandler`. Client chỉ cần biết điểm đầu của chain.

== Ý tưởng cốt lõi

Ý tưởng chính của Chain of Responsibility là biến một quy trình xử lý nhiều bước thành một chuỗi các object độc lập.

Mỗi handler thường thực hiện ba việc:

1. Nhận request.
2. Xử lý phần trách nhiệm của nó.
3. Quyết định chuyển request cho handler kế tiếp hay dừng chain.

Có thể hình dung request đi qua chain như sau:

```text
Request -> Logging -> Authentication -> Authorization -> Validation -> Business Logic
```

Mỗi handler chỉ biết handler kế tiếp, không cần biết toàn bộ chain phía sau. Điều này giúp chain có thể được thay đổi linh hoạt: thêm handler mới, bỏ handler cũ, đổi thứ tự handler, hoặc dùng chain khác cho từng loại request.

Ví dụ:

- Với API public, chain có thể chỉ gồm `LoggingHandler -> RateLimitHandler -> BusinessHandler`.
- Với API cần đăng nhập, chain có thể là `LoggingHandler -> AuthenticationHandler -> AuthorizationHandler -> ValidationHandler -> BusinessHandler`.
- Với luồng phê duyệt đơn nghỉ phép, chain có thể là `TeamLeadApproval -> ManagerApproval -> DirectorApproval`.

== Thành phần chính

Một cấu trúc Chain of Responsibility điển hình gồm ba thành phần chính.

=== Handler

`Handler` là interface hoặc abstract class chung cho các handler trong chain. Nó thường định nghĩa:

- Phương thức để thiết lập handler kế tiếp, ví dụ `SetNext()`.
- Phương thức xử lý request, ví dụ `Handle()`.

Ví dụ:

```csharp
public interface IHandler
{
    IHandler SetNext(IHandler next);
    Task HandleAsync(RequestContext context);
}
```

`Handler` giúp client và các handler cụ thể làm việc thông qua một hợp đồng chung, không phụ thuộc vào class cụ thể.

=== BaseHandler

Trong nhiều implementation, ta thường tạo thêm một abstract class `BaseHandler` để chứa logic chuyển tiếp dùng chung. Thành phần này không bắt buộc, nhưng rất hữu ích vì tránh lặp code ở các handler cụ thể.

Ví dụ:

```csharp
public abstract class BaseHandler : IHandler
{
    private IHandler? _next;

    public IHandler SetNext(IHandler next)
    {
        _next = next;
        return next;
    }

    public virtual async Task HandleAsync(RequestContext context)
    {
        if (_next != null)
        {
            await _next.HandleAsync(context);
        }
    }
}
```

Với cách này, các concrete handler chỉ cần tập trung vào logic riêng, còn việc gọi handler kế tiếp có thể dùng lại từ `BaseHandler`.

=== Concrete Handler

`ConcreteHandler` là các handler cụ thể trong chain. Mỗi handler nên đảm nhận một trách nhiệm rõ ràng.

Ví dụ trong web API:

- `LoggingHandler`: ghi log request.
- `AuthenticationHandler`: kiểm tra người dùng đã đăng nhập chưa.
- `AuthorizationHandler`: kiểm tra quyền truy cập.
- `ValidationHandler`: kiểm tra dữ liệu đầu vào.
- `BusinessHandler`: thực hiện nghiệp vụ chính.

Một handler có thể xử lý theo hai kiểu:

- *Handle and forward*: xử lý phần của mình rồi chuyển tiếp.
- *Handle or stop*: nếu điều kiện không đạt thì dừng chain.

=== Client

`Client` là nơi tạo chain và gửi request vào chain. Client có thể cấu hình thứ tự các handler:

```csharp
logging
    .SetNext(authentication)
    .SetNext(authorization)
    .SetNext(validation)
    .SetNext(business);

await logging.HandleAsync(context);
```

Client không cần biết chi tiết bên trong từng handler. Nó chỉ cần biết handler đầu tiên của chain.

== Cấu trúc UML

Dưới đây là class diagram tổng quát bằng PlantUML:

```plantuml
@startuml
skinparam classAttributeIconSize 0

class Client

interface Handler {
  +setNext(next: Handler): Handler
  +handle(request: Request)
}

abstract class BaseHandler {
  -next: Handler
  +setNext(next: Handler): Handler
  +handle(request: Request)
}

class ConcreteHandlerA {
  +handle(request: Request)
}

class ConcreteHandlerB {
  +handle(request: Request)
}

class ConcreteHandlerC {
  +handle(request: Request)
}

Client --> Handler : sends request to first handler
BaseHandler ..|> Handler
BaseHandler o--> Handler : next
ConcreteHandlerA --|> BaseHandler
ConcreteHandlerB --|> BaseHandler
ConcreteHandlerC --|> BaseHandler

note right of BaseHandler
  Nếu handler hiện tại không dừng chain,
  request được chuyển cho next handler.
end note
@enduml
```

#figure(
  image("diagrams/cor-structure.svg", width: 100%),
  caption: [Cấu trúc UML tổng quát của Chain of Responsibility],
)


Trong sơ đồ này:

- `Handler` định nghĩa hợp đồng xử lý chung.
- `BaseHandler` giữ tham chiếu đến handler kế tiếp.
- `ConcreteHandlerA/B/C` kế thừa `BaseHandler` và override logic xử lý.
- `Client` chỉ gửi request vào handler đầu tiên.

== Luồng hoạt động

Luồng hoạt động cơ bản của Chain of Responsibility gồm các bước:

1. Client tạo request.
2. Client gửi request cho handler đầu tiên trong chain.
3. Handler đầu tiên xử lý phần trách nhiệm của nó.
4. Nếu request không hợp lệ hoặc đã được xử lý xong, handler có thể dừng chain.
5. Nếu request vẫn cần tiếp tục, handler chuyển request cho handler kế tiếp.
6. Các handler tiếp theo lặp lại quá trình tương tự.
7. Chain kết thúc khi request được xử lý xong, bị reject, hoặc không còn handler kế tiếp.

Sequence diagram minh họa:

```plantuml
@startuml
actor Client
participant LoggingHandler
participant AuthHandler
participant ValidationHandler
participant BusinessHandler

Client -> LoggingHandler : Handle(request)
LoggingHandler -> LoggingHandler : log request
LoggingHandler -> AuthHandler : forward request
AuthHandler -> AuthHandler : check authentication

alt authenticated
  AuthHandler -> ValidationHandler : forward request
  ValidationHandler -> ValidationHandler : validate data

  alt valid
    ValidationHandler -> BusinessHandler : forward request
    BusinessHandler -> BusinessHandler : execute business logic
    BusinessHandler --> Client : success response
  else invalid
    ValidationHandler --> Client : reject request
  end
else unauthenticated
  AuthHandler --> Client : reject request
end
@enduml
```

#figure(
  image("diagrams/cor-sequence.svg", width: 100%),
  caption: [Luồng request qua các handler trong chain],
)


Điểm quan trọng trong luồng này là mỗi handler có quyền quyết định chain có tiếp tục hay không.

== Các biến thể xử lý

Chain of Responsibility có thể được triển khai theo nhiều biến thể khác nhau.

=== Một handler xử lý rồi dừng

Trong biến thể này, request đi qua chain cho đến khi gặp handler phù hợp. Handler đó xử lý request và không chuyển tiếp nữa.

Ví dụ: hệ thống hỗ trợ khách hàng tự động:

```text
Request -> BasicSupport -> TechnicalSupport -> BillingSupport
```

Nếu `TechnicalSupport` xử lý được ticket, request dừng tại đó.

=== Nhiều handler cùng xử lý

Trong biến thể này, nhiều handler có thể cùng xử lý một request. Mỗi handler xử lý một phần rồi chuyển tiếp.

Ví dụ middleware trong web framework:

```text
Logging -> Authentication -> Authorization -> Validation -> Controller
```

Logging ghi log, Authentication xác thực, Authorization kiểm tra quyền, Validation kiểm tra dữ liệu, sau đó Controller xử lý nghiệp vụ.

=== Handler có thể chặn request

Một số handler đóng vai trò kiểm soát. Nếu request không đạt điều kiện, handler dừng chain và trả lỗi.

Ví dụ:

- `AuthenticationHandler` dừng chain nếu user chưa đăng nhập.
- `AuthorizationHandler` dừng chain nếu user không có quyền.
- `ValidationHandler` dừng chain nếu dữ liệu sai.
- `RateLimitHandler` dừng chain nếu request vượt giới hạn.

=== Dynamic Chain

Trong một số hệ thống, chain có thể được cấu hình runtime thay vì hard-code. Ví dụ:

- Admin bật/tắt một rule validation.
- Hệ thống chọn chain khác nhau theo loại request.
- Pipeline được cấu hình bằng dependency injection.
- Workflow phê duyệt thay đổi theo số tiền hoặc phòng ban.

Dynamic chain giúp hệ thống linh hoạt, nhưng cũng làm việc trace và debug khó hơn.

== Ví dụ minh họa bằng C\#

Ví dụ dưới đây mô phỏng pipeline xử lý request gồm logging, authentication, authorization, validation và business logic.

=== Request context

```csharp
public class RequestContext
{
    public string UserName { get; set; } = string.Empty;
    public bool IsAuthenticated { get; set; }
    public bool HasPermission { get; set; }
    public string Payload { get; set; } = string.Empty;
    public bool IsRejected { get; set; }
    public string? ErrorMessage { get; set; }
}
```

=== Handler interface và BaseHandler

```csharp
public interface IRequestHandler
{
    IRequestHandler SetNext(IRequestHandler next);
    Task HandleAsync(RequestContext context);
}

public abstract class BaseRequestHandler : IRequestHandler
{
    private IRequestHandler? _next;

    public IRequestHandler SetNext(IRequestHandler next)
    {
        _next = next;
        return next;
    }

    public virtual async Task HandleAsync(RequestContext context)
    {
        if (_next != null && !context.IsRejected)
        {
            await _next.HandleAsync(context);
        }
    }
}
```

=== Các concrete handler

```csharp
public class LoggingHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        Console.WriteLine($"[LOG] User: {context.UserName}, Payload: {context.Payload}");
        await base.HandleAsync(context);
    }
}

public class AuthenticationHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        if (!context.IsAuthenticated)
        {
            context.IsRejected = true;
            context.ErrorMessage = "User is not authenticated.";
            return;
        }

        await base.HandleAsync(context);
    }
}

public class AuthorizationHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        if (!context.HasPermission)
        {
            context.IsRejected = true;
            context.ErrorMessage = "User does not have permission.";
            return;
        }

        await base.HandleAsync(context);
    }
}

public class ValidationHandler : BaseRequestHandler
{
    public override async Task HandleAsync(RequestContext context)
    {
        if (string.IsNullOrWhiteSpace(context.Payload))
        {
            context.IsRejected = true;
            context.ErrorMessage = "Payload must not be empty.";
            return;
        }

        await base.HandleAsync(context);
    }
}

public class BusinessHandler : BaseRequestHandler
{
    public override Task HandleAsync(RequestContext context)
    {
        Console.WriteLine("Business logic executed successfully.");
        return Task.CompletedTask;
    }
}
```

=== Sử dụng chain

```csharp
var logging = new LoggingHandler();
var authentication = new AuthenticationHandler();
var authorization = new AuthorizationHandler();
var validation = new ValidationHandler();
var business = new BusinessHandler();

logging
    .SetNext(authentication)
    .SetNext(authorization)
    .SetNext(validation)
    .SetNext(business);

var context = new RequestContext
{
    UserName = "phat",
    IsAuthenticated = true,
    HasPermission = true,
    Payload = "Create order"
};

await logging.HandleAsync(context);

if (context.IsRejected)
{
    Console.WriteLine($"Request rejected: {context.ErrorMessage}");
}
```

Ở ví dụ này:

- Client chỉ gọi `logging.HandleAsync(context)`.
- `LoggingHandler` luôn ghi log rồi chuyển tiếp.
- `AuthenticationHandler`, `AuthorizationHandler`, `ValidationHandler` có thể dừng chain nếu request không hợp lệ.
- `BusinessHandler` chỉ chạy khi request đã vượt qua các bước trước đó.



#figure(
  image("diagrams/cor-code-flow.svg", width: 100%),
  caption: [Luồng chạy code ví dụ request pipeline],
)

== Class diagram cho ví dụ C\#

```plantuml
@startuml
skinparam classAttributeIconSize 0

class RequestContext {
  +UserName: string
  +IsAuthenticated: bool
  +HasPermission: bool
  +Payload: string
  +IsRejected: bool
  +ErrorMessage: string
}

interface IRequestHandler {
  +SetNext(next: IRequestHandler): IRequestHandler
  +HandleAsync(context: RequestContext): Task
}

abstract class BaseRequestHandler {
  -next: IRequestHandler
  +SetNext(next: IRequestHandler): IRequestHandler
  +HandleAsync(context: RequestContext): Task
}

class LoggingHandler
class AuthenticationHandler
class AuthorizationHandler
class ValidationHandler
class BusinessHandler

IRequestHandler <|.. BaseRequestHandler
BaseRequestHandler <|-- LoggingHandler
BaseRequestHandler <|-- AuthenticationHandler
BaseRequestHandler <|-- AuthorizationHandler
BaseRequestHandler <|-- ValidationHandler
BaseRequestHandler <|-- BusinessHandler
BaseRequestHandler o--> IRequestHandler : next
LoggingHandler --> RequestContext
AuthenticationHandler --> RequestContext
AuthorizationHandler --> RequestContext
ValidationHandler --> RequestContext
BusinessHandler --> RequestContext
@enduml
```

#figure(
  image("diagrams/cor-request-pipeline.svg", width: 100%),
  caption: [Class diagram của pipeline xử lý request],
)


== Đánh giá

=== Ưu điểm

*Loose Coupling.* Sender không cần biết object nào sẽ xử lý request. Client chỉ gửi request vào đầu chain, còn việc handler nào xử lý là chi tiết bên trong.

*Dễ mở rộng.* Khi cần thêm một bước xử lý mới, ta có thể tạo handler mới và gắn vào chain mà không cần sửa nhiều code cũ. Điều này phù hợp với Open/Closed Principle.

*Single Responsibility Principle.* Mỗi handler chỉ đảm nhận một nhiệm vụ rõ ràng, chẳng hạn logging, authentication, validation hoặc business logic.

*Reusable Handlers.* Handler có thể được tái sử dụng ở nhiều chain khác nhau. Ví dụ `LoggingHandler` hoặc `ValidationHandler` có thể dùng cho nhiều loại request.

*Dynamic Chain.* Thứ tự handler có thể thay đổi ở runtime hoặc thông qua cấu hình, giúp hệ thống linh hoạt hơn.

*Dễ test từng bước.* Vì mỗi handler độc lập, ta có thể unit test từng handler thay vì phải test một hàm lớn chứa nhiều điều kiện lồng nhau.

=== Nhược điểm

*Debug khó hơn.* Request đi qua nhiều object nên việc theo dõi flow có thể khó hơn so với một hàm xử lý trực tiếp.

*Khó trace request trong dynamic chain.* Nếu chain được cấu hình runtime, developer cần công cụ logging/tracing tốt để biết request đã đi qua những handler nào.

*Không đảm bảo request được xử lý.* Nếu chain không có handler phù hợp hoặc handler cuối không xử lý, request có thể kết thúc mà không có kết quả mong muốn.

*Performance overhead.* Nếu chain quá dài, request phải đi qua nhiều handler, gây thêm chi phí gọi hàm và xử lý trung gian.

*Có thể bị lạm dụng.* Với logic đơn giản, dùng Chain of Responsibility có thể làm hệ thống phức tạp không cần thiết.

== Khi nào nên dùng

Nên dùng Chain of Responsibility khi:

- Một request cần đi qua nhiều bước xử lý độc lập.
- Có nhiều object có thể xử lý request, nhưng sender không nên biết object cụ thể nào xử lý.
- Thứ tự xử lý có thể thay đổi hoặc cần cấu hình linh hoạt.
- Cần tách các bước như logging, authentication, authorization, validation, business logic.
- Cần xây dựng middleware pipeline.
- Cần xây dựng approval workflow theo cấp bậc.
- Cần xử lý event qua nhiều bộ lọc hoặc nhiều rule.
- Muốn tránh code nhiều `if/else` lồng nhau trong một hàm lớn.

Ví dụ phù hợp:

- Middleware trong ASP.NET Core, Express.js, Spring Security.
- Pipeline validate request trong backend service.
- Workflow phê duyệt đơn hàng, đơn nghỉ phép, khoản vay.
- Logging pipeline.
- Event processing pipeline.
- Rule engine đơn giản.

== Khi nào không nên dùng

Không nên dùng Chain of Responsibility khi:

- Logic xử lý rất đơn giản và chỉ có một hoặc hai bước cố định.
- Flow xử lý không có khả năng mở rộng trong tương lai.
- Cần biết chắc chắn một request luôn được xử lý bởi một object cụ thể.
- Việc trace/debug quan trọng hơn khả năng linh hoạt.
- Handler có phụ thuộc chặt vào nhau, khiến việc tách thành chain không tự nhiên.
- Thứ tự xử lý quá phức tạp và có nhiều nhánh rẽ, khi đó state machine hoặc workflow engine có thể phù hợp hơn.

== Lưu ý khi cài đặt

Một số lưu ý khi triển khai Chain of Responsibility:

- Mỗi handler nên có một trách nhiệm rõ ràng.
- Không nên để handler biết quá nhiều về toàn bộ chain.
- Nên có logging hoặc tracing để biết request đã đi qua handler nào.
- Cần quyết định rõ handler sẽ “xử lý rồi dừng” hay “xử lý rồi chuyển tiếp”.
- Nên có handler cuối cùng để xử lý trường hợp không có handler nào phù hợp.
- Tránh chain quá dài nếu không cần thiết.
- Với hệ thống lớn, có thể kết hợp Dependency Injection để đăng ký handler.
- Với request có kết quả trả về, cần thiết kế response model rõ ràng để tránh handler trả kết quả không nhất quán.

== Ví dụ thực tế

=== Middleware trong web framework

Đây là ví dụ rất phổ biến của Chain of Responsibility. Request đi qua nhiều middleware trước khi đến controller:

```text
HTTP Request
  -> Exception Handling Middleware
  -> Logging Middleware
  -> Authentication Middleware
  -> Authorization Middleware
  -> Validation Middleware
  -> Controller / Endpoint
```

Mỗi middleware có thể xử lý request, thêm thông tin vào context, hoặc dừng request và trả response.

=== Approval workflow

Trong hệ thống phê duyệt chi phí:

```text
Expense Request -> Team Lead -> Manager -> Director -> CFO
```

Nếu số tiền nhỏ, Team Lead có thể duyệt. Nếu số tiền lớn hơn, request được chuyển lên Manager hoặc Director. Sender không cần biết cấp nào sẽ duyệt cuối cùng.

=== Validation pipeline

Một request tạo đơn hàng có thể đi qua nhiều validator:

```text
CreateOrderRequest
  -> CustomerValidator
  -> AddressValidator
  -> PaymentValidator
  -> InventoryValidator
  -> ShippingValidator
```

Mỗi validator kiểm tra một phần riêng. Nếu có lỗi, chain dừng và trả lỗi cho client.

== So sánh với các pattern khác

=== Chain of Responsibility và Decorator

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  align: left,
  [*Tiêu chí*], [*Chain of Responsibility*], [*Decorator*],
  [Mục đích], [Xử lý request theo một chuỗi handler], [Bọc object để thêm hành vi mới],
  [Luồng xử lý], [Có thể dừng chain ở giữa], [Thường đi qua toàn bộ wrapper],
  [Trọng tâm], [Request flow], [Object enhancement],
  [Quan hệ], [Handler biết handler kế tiếp], [Decorator giữ object gốc hoặc decorator khác],
  [Ví dụ], [Authentication -> Authorization -> Validation], [LoggingPaymentGateway bọc PaymentGateway để thêm logging],
)

Điểm dễ nhầm là cả hai đều có thể tạo thành chuỗi object. Tuy nhiên, Decorator tập trung vào việc mở rộng hành vi của một object mà vẫn giữ interface giống object gốc, còn Chain of Responsibility tập trung vào việc truyền request qua nhiều handler và có thể dừng ở bất kỳ handler nào.

=== Chain of Responsibility và Observer

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  align: left,
  [*Tiêu chí*], [*Chain of Responsibility*], [*Observer*],
  [Mục đích], [Truyền request qua chuỗi xử lý], [Thông báo sự kiện đến nhiều observer],
  [Cách lan truyền], [Tuần tự, one-by-one], [Broadcast, one-to-many],
  [Có thể dừng không?], [Có, handler có thể stop chain], [Thường không, các observer độc lập nhận event],
  [Trọng tâm], [Request propagation], [Event notification],
  [Ví dụ], [Middleware pipeline], [UI event listener, domain event subscriber],
)

Observer phù hợp khi một event xảy ra và nhiều object cần được thông báo. Chain of Responsibility phù hợp khi một request cần đi qua các bước xử lý tuần tự.

=== Chain of Responsibility và Command

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  align: left,
  [*Tiêu chí*], [*Chain of Responsibility*], [*Command*],
  [Mục đích], [Route request qua nhiều handler], [Đóng gói một hành động thành object],
  [Số object xử lý], [Có thể nhiều handler], [Thường một command đại diện cho một thao tác],
  [Trọng tâm], [Flow xử lý], [Operation/action],
  [Kết quả], [Request có thể bị xử lý, chuyển tiếp hoặc dừng], [Command được execute, undo hoặc queue],
  [Ví dụ], [Validation chain], [CopyCommand, SaveOrderCommand],
)

Command biến một hành động thành object để có thể execute, undo, queue hoặc log. Chain of Responsibility không đóng gói một hành động duy nhất, mà tổ chức nhiều handler để xử lý một request.

=== Chain of Responsibility và Pipeline/Middleware

Pipeline hoặc middleware có thể xem là một ứng dụng thực tế rất phổ biến của Chain of Responsibility.

Điểm giống:

- Request đi qua nhiều bước xử lý.
- Mỗi bước có thể xử lý một phần request.
- Một bước có thể quyết định gọi bước tiếp theo hay dừng lại.

Điểm khác:

- Chain of Responsibility là pattern tổng quát.
- Middleware/Pipeline là cách triển khai cụ thể trong framework hoặc hệ thống backend.
- Middleware thường có context, response và cơ chế gọi `next()` rõ ràng hơn.

== Quan hệ với nguyên lý thiết kế

Chain of Responsibility hỗ trợ một số nguyên lý thiết kế quan trọng:

*Single Responsibility Principle.* Mỗi handler chỉ phụ trách một phần xử lý.

*Open/Closed Principle.* Có thể thêm handler mới mà không cần sửa logic của handler cũ.

*Dependency Inversion Principle.* Client có thể phụ thuộc vào interface `Handler` thay vì phụ thuộc vào các concrete handler.

Tuy nhiên, pattern này cũng cần được dùng cẩn thận. Nếu lạm dụng, hệ thống có thể có quá nhiều class nhỏ, flow khó theo dõi, và việc debug trở nên phức tạp.

== Tóm tắt

Chain of Responsibility là pattern phù hợp khi một request cần được xử lý qua nhiều bước, nhiều rule hoặc nhiều cấp trách nhiệm. Thay vì viết tất cả logic trong một hàm lớn với nhiều `if/else`, ta tách từng bước thành handler riêng và nối chúng lại thành chain.

Pattern này giúp giảm coupling giữa sender và receiver, tăng khả năng mở rộng, hỗ trợ tái sử dụng handler và làm code rõ trách nhiệm hơn. Đổi lại, nó có thể làm việc debug khó hơn, đặc biệt khi chain được cấu hình động hoặc có quá nhiều handler.

Có thể ghi nhớ ngắn gọn:

```text
Chain of Responsibility = Request đi qua chuỗi handler,
mỗi handler xử lý một phần hoặc quyết định có chuyển tiếp hay không.
```
