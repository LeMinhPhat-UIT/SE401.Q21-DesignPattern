#set heading(level: 3)


== Tên và phân loại

*Singleton Pattern* là một mẫu thiết kế thuộc nhóm *Creational Pattern*. Nhóm Creational tập trung vào cách tạo object sao cho linh hoạt, kiểm soát được vòng đời object và giảm phụ thuộc trực tiếp giữa client với quá trình khởi tạo.

Singleton giải quyết một nhu cầu rất cụ thể: trong toàn bộ chương trình chỉ nên tồn tại *một instance duy nhất* của một class nào đó, đồng thời toàn hệ thống có thể truy cập đến instance này thông qua một điểm truy cập chung.

Nói ngắn gọn, Singleton là pattern dùng để quản lý một object duy nhất được chia sẻ trong phạm vi ứng dụng.

== Vấn đề cần giải quyết

Trong một số hệ thống, có những class không nên được tạo ra nhiều lần. Nếu mỗi nơi trong chương trình đều tự `new` một object mới, hệ thống có thể gặp các vấn đề như dữ liệu không nhất quán, lãng phí tài nguyên hoặc khó kiểm soát trạng thái toàn cục.

Ví dụ:

- `ConfigurationManager`: quản lý cấu hình ứng dụng.
- `Logger`: ghi log tập trung.
- `DatabaseConnectionManager`: quản lý kết nối hoặc connection pool.
- `CacheManager`: quản lý cache toàn cục.
- `AppSettings`: chứa setting dùng chung.
- `FileManager`: quản lý quyền truy cập đến một file dùng chung.

Giả sử nhiều service trong hệ thống tự tạo logger riêng:

```csharp
var logger1 = new Logger();
var logger2 = new Logger();
var logger3 = new Logger();
```

Nếu `Logger` có trạng thái như đường dẫn file log, cấp độ log hiện tại hoặc buffer ghi log, việc có nhiều instance có thể khiến log bị phân tán, cấu hình không đồng bộ hoặc cạnh tranh tài nguyên.

Vấn đề đặt ra là:

*Làm sao đảm bảo một class chỉ có một instance duy nhất, ngăn client tự tạo instance mới, nhưng vẫn cung cấp được một điểm truy cập chung cho toàn hệ thống?*

== Định nghĩa

*Singleton Pattern* đảm bảo rằng một class chỉ có một instance duy nhất trong toàn bộ chương trình, đồng thời cung cấp một cách truy cập toàn cục đến instance đó.

Singleton thường gồm ba ý chính:

- Constructor bị ẩn bằng `private` hoặc `protected` để client không thể tự `new`.
- Instance duy nhất được lưu trong chính class đó, thường là một field static.
- Client truy cập object thông qua một static property hoặc static method, ví dụ `Logger.Instance`.

Singleton không chỉ là “biến global”. Điểm quan trọng của Singleton là class tự kiểm soát việc tạo instance, đảm bảo chỉ có một object hợp lệ tồn tại theo thiết kế.

== Ý tưởng cốt lõi

Ý tưởng chính của Singleton là:

*Ngăn client tự tạo object mới, sau đó cung cấp một instance duy nhất được quản lý bên trong class.*

Thay vì để client gọi:

```csharp
var logger = new Logger();
```

Client sẽ gọi:

```csharp
var logger = Logger.Instance;
```

Lần đầu tiên truy cập, Singleton có thể tạo instance. Các lần sau, nó trả về lại cùng object đã được tạo trước đó.

Singleton có thể được cài đặt theo nhiều biến thể:

- *Eager initialization*: tạo instance ngay khi class được load.
- *Lazy initialization*: chỉ tạo instance khi có nhu cầu sử dụng lần đầu.
- *Thread-safe Singleton*: đảm bảo an toàn khi nhiều thread cùng truy cập.
- *Singleton qua DI container*: dùng vòng đời singleton trong dependency injection thay vì tự viết `ClassName.Instance`.

== Thành phần chính

#table(
  columns: (30%, 70%),
  inset: 8pt,
  align: (left, left),
  [*Thành phần*], [*Vai trò*],
  [*Singleton Class*], [Class tự quản lý instance duy nhất của chính nó.],
  [*Private Constructor*], [Ngăn client tạo object mới bằng toán tử `new`.],
  [*Static Instance*], [Field/property static lưu instance duy nhất.],
  [*Static Accessor*], [Cung cấp điểm truy cập toàn cục, ví dụ `Instance` hoặc `GetInstance()`.],
  [*Client*], [Sử dụng instance thông qua accessor thay vì trực tiếp khởi tạo.],
)

== UML bằng PlantUML

=== UML tổng quát

#figure(
  image("diagrams/singleton-structure.svg", width: 100%),
  caption: [Cấu trúc UML tổng quát của Singleton Pattern],
)


=== UML ví dụ Logger

#figure(
  image("diagrams/singleton-logger-example.svg", width: 100%),
  caption: [Class diagram của ví dụ Logger Singleton],
)


== Luồng hoạt động

Luồng hoạt động cơ bản của Singleton:

1. Client cần sử dụng object singleton.
2. Client gọi `Singleton.Instance` hoặc `Singleton.GetInstance()`.
3. Singleton kiểm tra instance đã được tạo hay chưa.
4. Nếu chưa có, Singleton tạo instance mới.
5. Nếu đã có, Singleton trả về instance cũ.
6. Client dùng instance đó để gọi method cần thiết.
7. Những lần gọi sau đều nhận lại cùng một instance.

Có thể biểu diễn bằng sequence diagram:

#figure(
  image("diagrams/singleton-sequence.svg", width: 100%),
  caption: [Luồng truy cập instance duy nhất],
)


== Code minh họa C\#

=== Cách cài đặt đơn giản

```csharp
public sealed class Logger
{
    private static Logger? _instance;

    private Logger()
    {
        Console.WriteLine("Logger created");
    }

    public static Logger Instance
    {
        get
        {
            if (_instance == null)
            {
                _instance = new Logger();
            }

            return _instance;
        }
    }

    public void Log(string message)
    {
        Console.WriteLine($"[LOG] {message}");
    }
}
```

Client sử dụng:

```csharp
public class OrderService
{
    public void CreateOrder()
    {
        Logger.Instance.Log("Creating order...");
        // Business logic
        Logger.Instance.Log("Order created successfully.");
    }
}

public class PaymentService
{
    public void Pay()
    {
        Logger.Instance.Log("Processing payment...");
        // Payment logic
        Logger.Instance.Log("Payment completed.");
    }
}
```

Cách này dễ hiểu nhưng chưa an toàn trong môi trường đa luồng. Nếu hai thread cùng truy cập lần đầu, cả hai có thể cùng thấy `_instance == null` và tạo ra hai object.

=== Thread-safe Singleton bằng Lazy<T>

Trong C\#, cách gọn và an toàn hơn là dùng `Lazy<T>`:

```csharp
public sealed class AppConfiguration
{
    private static readonly Lazy<AppConfiguration> _instance =
        new Lazy<AppConfiguration>(() => new AppConfiguration());

    private readonly Dictionary<string, string> _settings = new();

    private AppConfiguration()
    {
        _settings["AppName"] = "SE401 Demo";
        _settings["Environment"] = "Development";
    }

    public static AppConfiguration Instance => _instance.Value;

    public string Get(string key)
    {
        return _settings.TryGetValue(key, out var value)
            ? value
            : string.Empty;
    }
}
```

Client:

```csharp
string appName = AppConfiguration.Instance.Get("AppName");
Console.WriteLine(appName);
```

Ưu điểm của `Lazy<T>`:

- Chỉ tạo instance khi cần.
- Thread-safe theo mặc định.
- Code ngắn gọn hơn so với tự viết lock.

=== Singleton trong ASP.NET Core bằng DI

Trong các ứng dụng hiện đại, đặc biệt là ASP.NET Core, thường nên dùng DI container để quản lý singleton lifetime:

```csharp
public interface IAppLogger
{
    void Log(string message);
}

public class AppLogger : IAppLogger
{
    public void Log(string message)
    {
        Console.WriteLine($"[APP] {message}");
    }
}
```

Đăng ký trong `Program.cs`:

```csharp
builder.Services.AddSingleton<IAppLogger, AppLogger>();
```

Sử dụng qua constructor injection:

```csharp
public class OrderService
{
    private readonly IAppLogger _logger;

    public OrderService(IAppLogger logger)
    {
        _logger = logger;
    }

    public void CreateOrder()
    {
        _logger.Log("Create order");
    }
}
```

Về bản chất, DI container vẫn chỉ tạo một instance `AppLogger`, nhưng client không gọi `AppLogger.Instance`. Điều này giúp giảm coupling và dễ test hơn.



#figure(
  image("diagrams/singleton-code-flow.svg", width: 100%),
  caption: [Luồng chạy code ví dụ Logger Singleton],
)

== Đánh giá

=== Ưu điểm

#table(
  columns: (35%, 65%),
  inset: 8pt,
  align: (left, left),
  [*Ưu điểm*], [*Giải thích*],
  [Đảm bảo chỉ có một instance], [Hữu ích khi object đại diện cho tài nguyên hoặc trạng thái dùng chung.],
  [Cung cấp điểm truy cập chung], [Client có thể lấy instance từ một nơi thống nhất.],
  [Có thể lazy initialization], [Chỉ tạo object khi thật sự cần, tránh lãng phí tài nguyên.],
  [Kiểm soát vòng đời object], [Class hoặc DI container có thể quản lý thời điểm tạo và tái sử dụng object.],
  [Phù hợp cho một số tài nguyên toàn cục], [Ví dụ logger, configuration, cache manager hoặc application context.],
)

=== Nhược điểm

#table(
  columns: (35%, 65%),
  inset: 8pt,
  align: (left, left),
  [*Nhược điểm*], [*Giải thích*],
  [Dễ biến thành global state],
  [Nếu Singleton chứa nhiều state thay đổi, hệ thống có thể khó kiểm soát và khó dự đoán.],

  [Tăng coupling], [Client phụ thuộc trực tiếp vào `ClassName.Instance`, khó thay thế implementation.],
  [Khó test], [Unit test khó mock nếu code gọi trực tiếp Singleton thay vì abstraction.],
  [Cần cẩn thận với đa luồng], [Lazy initialization không thread-safe có thể tạo lỗi trong môi trường concurrent.],
  [Có thể vi phạm SRP], [Class vừa làm nghiệp vụ, vừa chịu trách nhiệm quản lý instance của chính nó.],
)

== Khi nào nên dùng và không nên dùng

=== Nên dùng khi

- Class thật sự chỉ nên có một instance trong toàn bộ ứng dụng.
- Object quản lý tài nguyên dùng chung như configuration, logger, cache.
- Cần kiểm soát chặt chẽ việc tạo object.
- Instance không chứa nhiều mutable state gây khó kiểm soát.
- Có thể triển khai thông qua DI container để giảm coupling.

=== Không nên dùng khi

- Chỉ muốn truy cập object ở nhiều nơi cho tiện.
- Object chứa trạng thái thay đổi theo từng request/user/session.
- Cần unit test nhiều và cần mock dễ dàng.
- Có thể truyền dependency qua constructor injection.
- Class chỉ chứa hàm tiện ích không state; khi đó static class có thể phù hợp hơn.

== So sánh với các pattern/khái niệm liên quan

=== Singleton vs Static Class

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Singleton*], [*Static Class*],
  [Bản chất], [Một object duy nhất.], [Tập hợp member static.],
  [Có instance không?], [Có instance thật sự.], [Không có object theo nghĩa thông thường.],
  [Implement interface], [Có thể implement interface.], [Không thể implement interface.],
  [Đa hình], [Có thể hỗ trợ ở mức nhất định.], [Không hỗ trợ đa hình.],
  [DI], [Có thể inject nếu đăng ký instance.], [Không phù hợp để inject.],
  [Phù hợp khi], [Cần object duy nhất có state/hành vi.], [Hàm tiện ích không cần state.],
)

=== Singleton truyền thống vs Singleton lifetime trong DI

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Singleton truyền thống*], [*Singleton trong DI*],
  [Ai quản lý instance?], [Chính class đó.], [DI container.],
  [Client truy cập], [`ClassName.Instance`.], [Constructor injection.],
  [Coupling], [Cao hơn.], [Thấp hơn vì phụ thuộc abstraction.],
  [Testability], [Khó mock hơn.], [Dễ mock hơn.],
  [Phù hợp hiện đại], [Ít được khuyến khích nếu lạm dụng.], [Thường được ưu tiên trong ứng dụng lớn.],
)

=== Singleton vs Prototype

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Singleton*], [*Prototype*],
  [Nhóm pattern], [Creational.], [Creational.],
  [Mục đích], [Đảm bảo chỉ có một instance.], [Tạo object mới bằng cách clone object mẫu.],
  [Số lượng object], [Một instance duy nhất.], [Nhiều object mới.],
  [Cách tạo], [Lấy instance có sẵn.], [Clone từ prototype.],
  [Ví dụ], [`ConfigurationManager.Instance`.], [Clone nhiều `Enemy` từ enemy mẫu.],
)

=== Singleton vs Flyweight

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Singleton*], [*Flyweight*],
  [Mục đích], [Chỉ có một instance của một class.], [Chia sẻ nhiều object/dữ liệu dùng chung theo trạng thái.],
  [Số lượng instance], [Một.], [Có thể nhiều, mỗi object ứng với một intrinsic state.],
  [Trọng tâm], [Kiểm soát instance.], [Tiết kiệm bộ nhớ.],
  [Ví dụ], [Một `Logger`.], [Nhiều `TreeType`: Oak, Pine, Cherry.],
)

=== Singleton vs Factory

#table(
  columns: (25%, 37%, 38%),
  inset: 7pt,
  align: (left, left, left),
  [*Tiêu chí*], [*Singleton*], [*Factory*],
  [Mục đích], [Đảm bảo một instance duy nhất.], [Tạo object mà không để client biết chi tiết khởi tạo.],
  [Số lượng object], [Một.], [Có thể nhiều.],
  [Client nhận object bằng], [`Instance`.], [`Create()`.],
  [Trọng tâm], [Quản lý vòng đời instance.], [Đóng gói logic tạo object.],
  [Ví dụ], [`Logger.Instance`.], [`PaymentFactory.Create("momo")`.],
)

== Kết luận

Singleton là pattern hữu ích khi hệ thống thật sự cần một object duy nhất được chia sẻ, chẳng hạn configuration, logger hoặc cache manager. Tuy nhiên, Singleton rất dễ bị lạm dụng và biến thành global state, làm tăng coupling và gây khó khăn cho unit test.

Trong các ứng dụng hiện đại, thay vì luôn viết Singleton truyền thống bằng `ClassName.Instance`, nên cân nhắc dùng dependency injection với singleton lifetime. Cách này vẫn đảm bảo chỉ có một instance, nhưng giữ code linh hoạt, dễ test và dễ thay thế implementation hơn.
