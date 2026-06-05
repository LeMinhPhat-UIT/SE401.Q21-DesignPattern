#set heading(level: 3)

== Tên và phân loại

*Factory Method Pattern* trong tiếng Việt thường được gọi là *mẫu Phương thức Factory*.

Factory Method thuộc nhóm *Creational Pattern* vì nó tập trung vào cơ chế khởi tạo đối tượng. Thay vì client gọi trực tiếp `new ConcreteProduct()`, toàn bộ logic tạo đối tượng được đẩy vào một phương thức ảo (`factory method`) để các lớp con quyết định kiểu cụ thể nào sẽ được tạo ra.

Tên gọi "Factory Method" thể hiện đúng bản chất: *một phương thức đóng vai trò nhà máy sản xuất đối tượng*, và nhà máy cụ thể là do lớp con định nghĩa.

== Mục đích và ý định

Mục đích của Factory Method là *định nghĩa một interface để tạo đối tượng, nhưng để lại cho lớp con quyết định lớp nào sẽ được khởi tạo*.

Factory Method cho phép một lớp trì hoãn việc khởi tạo sang lớp con (defer instantiation to subclasses). Điều này có nghĩa:

- Lớp cha xác định *khi nào* và *cách sử dụng* sản phẩm thông qua interface chung.
- Lớp con xác định *sản phẩm cụ thể* nào được tạo ra bằng cách override factory method.
- Client làm việc hoàn toàn qua abstraction, không phụ thuộc vào class cụ thể.

== Vấn đề cần giải quyết (Motivation)

Xét một ứng dụng quản lý phương tiện giao thông (`Vehicle`). Ban đầu hệ thống chỉ hỗ trợ tàu thuyền (`Boat`). Theo thời gian cần bổ sung xe đạp (`Bicycle`), sau đó xe máy, ô tô, v.v.

Nếu client tạo đối tượng trực tiếp:

```csharp
IVehicle vehicle = new Boat();
vehicle.StartEngine();
```

Mỗi lần thêm phương tiện mới, client phải sửa code — vi phạm nguyên lý *Open/Closed Principle*. Đồng thời client bị coupling chặt vào class cụ thể `Boat`, gây khó khăn khi test và mở rộng.

*Giải pháp*: giới thiệu lớp `VehicleCreator` trừu tượng với factory method `CreateVehicle()`. Mỗi loại creator (`BoatCreator`, `BicycleCreator`) tự quyết định sản phẩm nào được tạo. Client chỉ làm việc với `VehicleCreator` và `IVehicle` — không biết class cụ thể nào đứng sau.

== Khả năng ứng dụng

Factory Method phù hợp trong các trường hợp:

- *Không biết trước loại đối tượng cần tạo*: khi code không thể xác định tại compile-time sẽ dùng class cụ thể nào, mà chỉ biết ở runtime.
- *Muốn lớp con kiểm soát việc tạo đối tượng*: framework/thư viện định nghĩa cấu trúc chung, ứng dụng cụ thể quyết định class nào được dùng.
- *Tái sử dụng object hiện có thay vì tạo mới*: factory method có thể trả về object từ cache/pool thay vì `new`, mà client không cần biết.
- *Cần tách biệt logic khởi tạo khỏi logic sử dụng*: giúp code dễ test (mock creator), dễ mở rộng (thêm creator mới không sửa code cũ).

== Cấu trúc

Cấu trúc tổng quát của Factory Method:

```plantuml
@startuml
abstract class Creator {
  +{abstract} FactoryMethod() : Product
  +SomeOperation()
}

interface Product {
  +DoSomething()
}

class ConcreteCreatorA {
  +FactoryMethod() : Product
}

class ConcreteCreatorB {
  +FactoryMethod() : Product
}

class ConcreteProductA {
  +DoSomething()
}

class ConcreteProductB {
  +DoSomething()
}

Creator <|-- ConcreteCreatorA
Creator <|-- ConcreteCreatorB
Product <|.. ConcreteProductA
Product <|.. ConcreteProductB
ConcreteCreatorA ..> ConcreteProductA : <<creates>>
ConcreteCreatorB ..> ConcreteProductB : <<creates>>
Creator --> Product
@enduml
```

Cấu trúc cụ thể trong project này:

```plantuml
@startuml
abstract class VehicleCreator {
  +{abstract} CreateVehicle() : IVehicle
}

interface IVehicle {
  +StartEngine() : string
}

class BoatCreator {
  +CreateVehicle() : IVehicle
}

class BicycleCreator {
  +CreateVehicle() : IVehicle
}

class Boat {
  +StartEngine() : string
}

class Bicycle {
  +StartEngine() : string
}

VehicleCreator <|-- BoatCreator
VehicleCreator <|-- BicycleCreator
IVehicle <|.. Boat
IVehicle <|.. Bicycle
BoatCreator ..> Boat : <<creates>>
BicycleCreator ..> Bicycle : <<creates>>
VehicleCreator --> IVehicle
@enduml
```

== Các thành viên

Factory Method bao gồm bốn thành phần chính:

*Product (IVehicle)*

- Interface hoặc lớp trừu tượng định nghĩa hành vi chung cho tất cả sản phẩm.
- Creator làm việc với sản phẩm qua interface này, không biết class cụ thể.
- Trong project: `IVehicle` với phương thức `StartEngine()`.

*ConcreteProduct (Boat, Bicycle)*

- Các lớp cụ thể triển khai interface `Product`.
- Mỗi `ConcreteProduct` định nghĩa hành vi đặc thù của mình.
- Trong project: `Boat.StartEngine()` trả về `"Boat has been started"`, `Bicycle.StartEngine()` trả về `"Your bicycle has engine? That's cool"`.

*Creator (VehicleCreator)*

- Lớp trừu tượng (hoặc interface) khai báo factory method.
- Thường chứa các phương thức nghiệp vụ sử dụng sản phẩm được tạo ra bởi factory method.
- Creator *không* bắt buộc phải trừu tượng — có thể cung cấp một sản phẩm mặc định.
- Trong project: `VehicleCreator` với `abstract IVehicle CreateVehicle()`.

*ConcreteCreator (BoatCreator, BicycleCreator)*

- Các lớp con override factory method để trả về instance cụ thể.
- Mỗi `ConcreteCreator` chịu trách nhiệm cho một loại sản phẩm.
- Trong project: `BoatCreator` trả về `new Boat()`, `BicycleCreator` trả về `new Bicycle()`.

== Sự cộng tác

Luồng hoạt động của Factory Method diễn ra như sau:

```plantuml
@startuml
participant Client
participant VehicleCreator as Creator <<abstract>>
participant BoatCreator as Concrete
participant Boat as Product

Client -> Concrete : new BoatCreator()
Client -> Concrete : CreateVehicle()
Concrete -> Product : new Boat()
Product --> Concrete : boat : IVehicle
Concrete --> Client : boat : IVehicle
Client -> Product : StartEngine()
Product --> Client : "Boat has been started"
@enduml
```

Quá trình cộng tác:

1. Client chọn một `ConcreteCreator` phù hợp (thông qua config, switch expression, DI container, ...).
2. Client gọi `CreateVehicle()` trên creator. Creator thực chất là `VehicleCreator`, nhưng phương thức ảo được dispatch tới `BoatCreator`.
3. `BoatCreator.CreateVehicle()` khởi tạo `new Boat()` và trả về dưới dạng `IVehicle`.
4. Client sử dụng sản phẩm qua interface `IVehicle.StartEngine()` — hoàn toàn không biết đó là `Boat` hay `Bicycle`.

== Hệ quả, ưu và nhược điểm

*Ưu điểm*

- *Loại bỏ coupling với ConcreteProduct*: client làm việc qua interface `IVehicle`, không import/tham chiếu trực tiếp `Boat` hay `Bicycle`.
- *Tuân theo Open/Closed Principle*: thêm phương tiện mới (`Car`, `Motorcycle`) chỉ cần thêm class mới — không sửa code cũ.
- *Single Responsibility Principle*: logic tạo sản phẩm tập trung tại creator, tách biệt khỏi logic sử dụng.
- *Dễ test và mock*: trong unit test, có thể tạo `FakeCreator` trả về `MockVehicle` mà không ảnh hưởng code thật.
- *Tái sử dụng logic khởi tạo*: nếu tạo object cần nhiều bước (config, validate, ...), logic đó nằm gọn trong creator.

*Nhược điểm*

- *Tăng số lượng class*: mỗi loại sản phẩm mới cần thêm cả class Product lẫn class Creator — trong dự án nhỏ có thể là over-engineering.
- *Phân cấp class sâu hơn*: khó theo dõi luồng tạo đối tượng khi có nhiều lớp con creator.
- *Client vẫn phải biết Creator*: client cần biết dùng `BoatCreator` hay `BicycleCreator`, chỉ không cần biết `Boat`/`Bicycle` cụ thể.

== Chú ý khi cài đặt

*Cách khai báo Creator*

- Creator có thể là `abstract class` (buộc subclass phải implement factory method) hoặc `class` thường với một implementation mặc định.
- Nếu dùng `abstract`, đảm bảo mọi subclass đều override factory method — không để sót.

*Không nhất thiết phải có Creator tách biệt*

- Đôi khi factory method được đặt ngay trong lớp sử dụng sản phẩm, không cần class Creator riêng. Điều này chấp nhận được khi hệ thống nhỏ.

*Trả về interface, không trả về class cụ thể*

- Factory method nên khai báo kiểu trả về là `IVehicle`, không phải `Boat`. Điều này bảo đảm client không thể vô tình coupling vào class cụ thể.

*Đặt tên nhất quán*

- Convention phổ biến: `Create<ProductName>()`, `Make<ProductName>()`, `Build<ProductName>()`. Trong project này dùng `CreateVehicle()`.

*Kết hợp với Dependency Injection*

- Trong ứng dụng thực tế, `ConcreteCreator` thường được inject qua DI container thay vì khởi tạo thủ công bằng `switch`/`if`.

```csharp
// Thay vì:
vehicleCreator = creator switch {
    nameof(BoatCreator) => new BoatCreator(),
    ...
};

// Nên dùng:
services.AddScoped<VehicleCreator, BoatCreator>();
var vehicleCreator = serviceProvider.GetRequiredService<VehicleCreator>();
```

*Phân biệt Factory Method với static factory*

- Static factory (`Vehicle.Create(type)`) không có tính đa hình — không thể override ở subclass. Factory Method yêu cầu instance của creator và khai thác virtual dispatch.

== So sánh với các mẫu liên quan

*Factory Method vs Abstract Factory*

#table(
  columns: (1fr, 1fr, 1fr),
  [*Tiêu chí*], [*Factory Method*], [*Abstract Factory*],
  [Phạm vi], [Tạo một loại sản phẩm], [Tạo một họ sản phẩm liên quan],
  [Cơ chế], [Kế thừa (subclass override)], [Composition (factory object)],
  [Mở rộng], [Thêm subclass creator], [Thêm concrete factory],
  [Ví dụ], [`BoatCreator.CreateVehicle()`], [`VietjetFactory.CreateTicket()` + `CreateBaggagePolicy()`],
)

*Factory Method vs Builder*

- Builder tập trung vào *từng bước* xây dựng object phức tạp; Factory Method tập trung vào *loại* object được tạo.
- Một `ConcreteCreator` trong Factory Method có thể sử dụng Builder bên trong để xây dựng sản phẩm phức tạp.

*Factory Method vs Prototype*

- Prototype tạo object bằng cách *clone* một đối tượng mẫu có sẵn.
- Factory Method tạo object từ đầu bằng constructor.
- Prototype linh hoạt hơn khi cần nhiều biến thể nhỏ; Factory Method rõ ràng hơn về kiểu tạo ra.

*Factory Method vs Template Method*

- Cả hai đều dựa vào kế thừa và virtual method.
- Template Method xác định *bộ khung thuật toán* và để subclass override các bước; Factory Method xác định *điểm tạo đối tượng* và để subclass chọn loại.
- Factory Method thực chất là một trường hợp đặc biệt của Template Method áp dụng cho việc khởi tạo đối tượng.

== Mã nguồn minh họa

Dưới đây là toàn bộ mã nguồn của project `FactoryMethodDemo`:

*Interface IVehicle*

```csharp
namespace FactoryMethodDemo.Interfaces
{
    internal interface IVehicle
    {
        string StartEngine();
    }
}
```

*Abstract class VehicleCreator*

```csharp
namespace FactoryMethodDemo.Interfaces
{
    abstract class VehicleCreator
    {
        // Factory Method — lớp con quyết định trả về loại IVehicle nào
        public abstract IVehicle CreateVehicle();
    }
}
```

*Concrete products: Boat và Bicycle*

```csharp
namespace FactoryMethodDemo.Models
{
    internal class Boat : IVehicle
    {
        public string StartEngine() => "Boat has been started";
    }

    internal class Bicycle : IVehicle
    {
        public string StartEngine() => "Your bicycle has engine? That's cool";
    }
}
```

*Concrete creators: BoatCreator và BicycleCreator*

```csharp
namespace FactoryMethodDemo.Implements
{
    internal class BoatCreator : VehicleCreator
    {
        public override IVehicle CreateVehicle() => new Boat();
    }

    internal class BicycleCreator : VehicleCreator
    {
        public override IVehicle CreateVehicle() => new Bicycle();
    }
}
```

*Client (Program.cs)*

```csharp
using FactoryMethodDemo.Implements;
using FactoryMethodDemo.Interfaces;

string creator = nameof(BoatCreator);
VehicleCreator vehicleCreator;

vehicleCreator = creator switch
{
    nameof(BoatCreator)    => new BoatCreator(),
    nameof(BicycleCreator) => new BicycleCreator(),
    _                      => throw new Exception()
};

if (vehicleCreator is not null)
{
    var vehicle = vehicleCreator.CreateVehicle();
    Console.WriteLine(vehicle.StartEngine());
}
```

*Kết quả chạy* (khi `creator = nameof(BoatCreator)`):

```
Boat has been started
```

Để chuyển sang dùng `BicycleCreator`, chỉ cần đổi giá trị của biến `creator` — không cần sửa bất kỳ dòng code nào khác.

Ví dụ mở rộng: thêm phương tiện mới `Car` chỉ cần:

```csharp
// Models/Car.cs
internal class Car : IVehicle
{
    public string StartEngine() => "Car engine roaring!";
}

// Implements/CarCreator.cs
internal class CarCreator : VehicleCreator
{
    public override IVehicle CreateVehicle() => new Car();
}

// Program.cs — thêm một case trong switch, không sửa gì khác
nameof(CarCreator) => new CarCreator(),
```

== Ví dụ trong các hệ thống thực tế

*ASP.NET Core — ControllerFactory*

ASP.NET Core dùng `IControllerFactory` để tạo controller instance cho mỗi request. Framework định nghĩa interface, ứng dụng (hoặc DI container) cung cấp concrete factory. Điều này cho phép thay thế toàn bộ cơ chế khởi tạo controller mà không sửa framework.

*Entity Framework Core — DbContext Pooling*

`IDbContextFactory<TContext>` là một factory method interface. Khi dùng `AddDbContextFactory`, EF Core tạo context thông qua factory — cho phép pooling, scoped lifetime, v.v. thay vì `new AppDbContext()`.

*Logging — ILoggerFactory*

`ILoggerFactory.CreateLogger(categoryName)` là một factory method: factory quyết định trả về `ConsoleLogger`, `FileLogger`, hay `NullLogger` tùy theo cấu hình, mà caller không cần biết.

*Java — java.util.Calendar.getInstance()*

`Calendar.getInstance()` là một static factory trả về `GregorianCalendar`, `BuddhistCalendar`, hay `JapaneseImperialCalendar` tùy `Locale` của hệ thống — người gọi chỉ biết đang nhận `Calendar`.

*Game Engine (Unity) — ObjectPool / Instantiate*

`Object.Instantiate(prefab)` trong Unity là một dạng factory: engine quyết định tạo object trong scene từ prefab, trả về instance. AddressableAssets nâng cấp thêm thành async factory.

== Các mẫu liên quan

- *Abstract Factory*: thường được cài đặt bằng nhiều Factory Method. Khi một factory method phát triển lên và cần tạo nhiều sản phẩm liên quan, nó trở thành Abstract Factory.

- *Template Method*: Factory Method là một đặc trường hợp của Template Method — cả hai dùng kế thừa và virtual dispatch để tùy chỉnh hành vi ở subclass.

- *Prototype*: có thể thay thế Factory Method khi sản phẩm cần clone từ prototype thay vì khởi tạo mới. Đặc biệt hữu ích khi số lượng biến thể lớn.

- *Builder*: Factory Method chỉ cần một bước tạo sản phẩm (`CreateVehicle()`). Khi sản phẩm phức tạp hơn và cần nhiều bước, dùng Builder bên trong factory method.

- *Dependency Injection*: DI container là một Factory Method tổng quát — nó map interface sang concrete class và khởi tạo khi cần. Trong .NET, `IServiceProvider.GetService<T>()` về bản chất là factory method.

== Nguyên lý thiết kế được áp dụng

Factory Method là minh họa điển hình cho nhiều nguyên lý trong SOLID và OOP:

- *Open/Closed Principle*: thêm loại phương tiện mới không cần sửa code hiện có, chỉ thêm class mới.
- *Dependency Inversion Principle*: module cấp cao (`Program.cs`) phụ thuộc vào abstraction (`IVehicle`, `VehicleCreator`), không phụ thuộc vào `Boat` hay `Bicycle` cụ thể.
- *Single Responsibility Principle*: `BoatCreator` chỉ chịu trách nhiệm tạo `Boat`; `Bicycle` chỉ chứa logic của xe đạp.
- *Program to interfaces, not implementations*: client nhận `IVehicle`, không nhận `Boat`.

== Tóm tắt

Factory Method giải quyết vấn đề *coupling giữa client và class cụ thể* bằng cách giới thiệu một phương thức ảo để tạo đối tượng. Lớp cha định nghĩa *khi nào dùng sản phẩm*; lớp con định nghĩa *sản phẩm nào được tạo*.

Trong project `FactoryMethodDemo`, pattern được thể hiện rõ ràng qua:

- `VehicleCreator` — creator trừu tượng với `CreateVehicle()`.
- `BoatCreator`, `BicycleCreator` — concrete creator, mỗi cái tạo một loại phương tiện.
- `IVehicle` — product interface.
- `Boat`, `Bicycle` — concrete product với logic riêng.
- `Program.cs` — client chọn creator lúc runtime, dùng sản phẩm qua interface.

Factory Method phù hợp nhất khi hệ thống cần mở rộng linh hoạt về loại đối tượng tạo ra, muốn tách biệt logic tạo khỏi logic sử dụng, và cần đảm bảo client không coupling với class cụ thể.
