#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

= Strategy Pattern

== Tên và Phân loại

*Strategy Pattern* là một mẫu thiết kế thuộc nhóm *Behavioral Pattern*.

Trong tiếng Việt, mẫu này thường được gọi là *mẫu chiến lược*. Ý tưởng cốt lõi là đóng gói một họ thuật toán dưới các class riêng biệt, có cùng interface, để có thể hoán đổi linh hoạt trong runtime.

== Mục đích, ý định

Mục đích chính của Strategy là tách phần "thuật toán có thể thay đổi" khỏi context sử dụng nó.

Ý định cụ thể:

- Đóng gói từng thuật toán thành strategy độc lập.
- Tránh chuỗi `if/else` hoặc `switch` lớn theo kiểu xử lý.
- Cho phép thay đổi hành vi lúc runtime mà không sửa context.
- Tăng khả năng mở rộng, kiểm thử và tái sử dụng thuật toán.

== Bí danh

Strategy Pattern còn được nhắc đến với các tên:

- *Policy Pattern*.
- *Algorithm Family Pattern*.

== Motivation

Xét hệ thống thương mại điện tử cần tính phí vận chuyển theo nhiều loại:

- Standard Shipping.
- Express Shipping.
- Same-Day Shipping.

Nếu đặt toàn bộ logic vào một lớp `ShippingService`, code dễ gặp vấn đề:

- Nhiều điều kiện rẽ nhánh khó bảo trì.
- Mỗi lần thêm phương thức vận chuyển phải sửa mã cũ.
- Khó unit test từng thuật toán độc lập.

Strategy giải quyết bằng cách:

- Định nghĩa interface `IShippingStrategy`.
- Mỗi thuật toán tính phí là một `ConcreteStrategy`.
- `CheckoutContext` chỉ giữ reference strategy và gọi thực thi.

== Khả năng ứng dụng

Strategy phù hợp khi:

- Có nhiều thuật toán cùng mục tiêu nhưng khác cách xử lý.
- Muốn chọn thuật toán theo cấu hình, user input, environment.
- Muốn tránh class lớn chứa quá nhiều nhánh điều kiện.
- Muốn benchmark hoặc A/B test nhiều thuật toán.

Ví dụ điển hình:

- Tính phí vận chuyển/thuế/chiết khấu.
- Thuật toán sắp xếp hoặc lọc dữ liệu.
- Chọn cơ chế nén (`zip`, `gzip`, `lz4`).
- Chọn cổng thanh toán (`VNPay`, `MoMo`, `Stripe`, `COD`).

== Cấu trúc

Các vai trò chính của Strategy Pattern:

- `Strategy`: interface chung cho các thuật toán.
- `ConcreteStrategy`: cài đặt thuật toán cụ thể.
- `Context`: giữ strategy hiện hành và dùng nó để xử lý.
- `Client`: chọn strategy phù hợp và inject vào context.

UML tổng quát:

```plantuml
@startuml
skinparam classAttributeIconSize 0

interface IStrategy {
  +Execute(data)
}

class ConcreteStrategyA {
  +Execute(data)
}

class ConcreteStrategyB {
  +Execute(data)
}

class Context {
  -strategy: IStrategy
  +SetStrategy(strategy: IStrategy)
  +Run(data)
}

class Client

IStrategy <|.. ConcreteStrategyA
IStrategy <|.. ConcreteStrategyB
Context --> IStrategy
Client --> Context
Client --> IStrategy
@enduml
```

Class diagram (Mermaid):

```mermaid
classDiagram
	class IShippingStrategy {
		<<interface>>
		+CalculateFee(orderTotal, weight, distance): decimal
	}

	class StandardShipping
	class ExpressShipping
	class SameDayShipping

	class CheckoutContext {
		-strategy: IShippingStrategy
		+SetStrategy(strategy)
		+CalculateShipping(orderTotal, weight, distance): decimal
	}

	IShippingStrategy <|.. StandardShipping
	IShippingStrategy <|.. ExpressShipping
	IShippingStrategy <|.. SameDayShipping
	CheckoutContext --> IShippingStrategy
```

== Các thành viên

`Strategy` (`IShippingStrategy`)

- Khai báo contract cho thuật toán.
- Giúp context làm việc qua abstraction.

`ConcreteStrategy`

- Cài đặt từng thuật toán cụ thể.
- Ví dụ:
  - `StandardShipping`: phí thấp, tốc độ thường.
  - `ExpressShipping`: phí cao hơn, giao nhanh.
  - `SameDayShipping`: phí cao nhất, có thêm điều kiện phạm vi.

`Context` (`CheckoutContext`)

- Nắm strategy hiện tại.
- Cung cấp API nghiệp vụ cho client.
- Ủy quyền xử lý thuật toán cho strategy thay vì tự làm.

`Client`

- Quyết định chọn strategy nào.
- Có thể thay strategy runtime theo điều kiện đơn hàng.

== Sự cộng tác

Luồng cộng tác chuẩn:

1. Client tạo context.
2. Client chọn strategy phù hợp.
3. Client set strategy vào context (`SetStrategy`).
4. Client gọi API trên context (`CalculateShipping`).
5. Context gọi strategy hiện tại để xử lý.
6. Client có thể thay strategy và chạy lại mà không sửa context.

Sequence diagram:

```plantuml
@startuml
actor User
participant Client
participant Context
participant Strategy

User -> Client : choose shipping type
Client -> Context : SetStrategy(ExpressShipping)
Client -> Context : CalculateShipping(...)
Context -> Strategy : CalculateFee(...)
Strategy --> Context : fee
Context --> Client : fee
@enduml
```

== Các hệ quả mang lại, Ưu nhược điểm

=== Ưu điểm

- *Open/Closed*: thêm strategy mới mà ít sửa mã cũ.
- *Single Responsibility*: mỗi thuật toán ở class riêng.
- Dễ unit test từng strategy độc lập.
- Dễ thay thế thuật toán theo runtime hoặc config.
- Giảm độ phức tạp ở context.

=== Nhược điểm

- Tăng số lượng class.
- Client cần hiểu để chọn strategy phù hợp.
- Nếu interface strategy quá chung chung, có thể phát sinh nhiều tham số không cần thiết.

== Chú ý liên quan đến việc cài đặt

- Giữ interface strategy đủ nhỏ và rõ nghĩa.
- Tránh để context biết chi tiết nội bộ của từng strategy.
- Nếu chọn strategy theo nhiều điều kiện, nên dùng factory/resolver để tránh `if/else` dồn về client.
- Với chiến lược có state nội bộ, cần chú ý thread safety.
- Có thể dùng DI để đăng ký danh sách strategy và resolve theo key.

== Một số so sánh nếu có

=== Strategy và State

- Strategy: client/chính sách bên ngoài chọn thuật toán.
- State: context tự chuyển đổi hành vi theo trạng thái nội bộ.

=== Strategy và Template Method

- Strategy dùng composition để thay đổi toàn bộ thuật toán.
- Template Method dùng kế thừa để thay đổi một số bước trong khung thuật toán cố định.

=== Strategy và Command

- Strategy đóng gói *cách làm* (thuật toán).
- Command đóng gói *việc cần làm* (request) để thực thi, queue, undo.

=== Strategy và Policy-based configuration

- Strategy thường là hiện thực OOP của policy.
- Policy config có thể map 1-1 sang concrete strategy.

== Mã nguồn minh họa

Ví dụ C# tính phí vận chuyển theo strategy:

```csharp
using System;

public interface IShippingStrategy
{
	decimal CalculateFee(decimal orderTotal, decimal weight, decimal distanceKm);
}

public class StandardShipping : IShippingStrategy
{
	public decimal CalculateFee(decimal orderTotal, decimal weight, decimal distanceKm)
		=> 15000m + weight * 2000m + distanceKm * 500m;
}

public class ExpressShipping : IShippingStrategy
{
	public decimal CalculateFee(decimal orderTotal, decimal weight, decimal distanceKm)
		=> 30000m + weight * 3000m + distanceKm * 900m;
}

public class SameDayShipping : IShippingStrategy
{
	public decimal CalculateFee(decimal orderTotal, decimal weight, decimal distanceKm)
	{
		if (distanceKm > 20) throw new InvalidOperationException("Same-day only supports <= 20km");
		return 50000m + weight * 3500m + distanceKm * 1200m;
	}
}

public class CheckoutContext
{
	private IShippingStrategy _strategy;

	public CheckoutContext(IShippingStrategy strategy)
	{
		_strategy = strategy;
	}

	public void SetStrategy(IShippingStrategy strategy) => _strategy = strategy;

	public decimal CalculateShipping(decimal orderTotal, decimal weight, decimal distanceKm)
		=> _strategy.CalculateFee(orderTotal, weight, distanceKm);
}

public class Program
{
	public static void Main()
	{
		var ctx = new CheckoutContext(new StandardShipping());
		Console.WriteLine($"Standard fee: {ctx.CalculateShipping(500000m, 2.5m, 8m)}");

		ctx.SetStrategy(new ExpressShipping());
		Console.WriteLine($"Express fee: {ctx.CalculateShipping(500000m, 2.5m, 8m)}");
	}
}
```

Ý nghĩa ví dụ:

- Context giữ contract `IShippingStrategy`, không phụ thuộc class cụ thể.
- Thuật toán đổi bằng `SetStrategy()`.
- Business flow không cần đổi khi thêm strategy mới.

== Ví dụ về các hệ thống thực tế

- Cổng thanh toán đa nhà cung cấp.
- Hệ thống đề xuất (recommendation) thay mô hình theo user segment.
- Engine định tuyến chọn thuật toán shortest path theo loại dữ liệu bản đồ.
- Công cụ nén/chuyển mã media theo quality profile.
- Rule pricing động trong ride-hailing theo khu vực/khung giờ.

== Các mẫu liên quan

- *State*: gần nhất về cấu trúc, khác mục tiêu chọn hành vi.
- *Template Method*: thay đổi theo kế thừa thay vì composition.
- *Factory Method/Abstract Factory*: thường dùng để tạo strategy phù hợp.
- *Command*: có thể dùng strategy bên trong command để đổi cách thực thi.

Tóm lại, Strategy Pattern đặc biệt hiệu quả khi hệ thống có nhiều thuật toán thay thế cho cùng một nghiệp vụ và cần thay đổi linh hoạt theo runtime. Khi kết hợp tốt với DI/factory, mẫu này giúp code sạch hơn, mở rộng dễ hơn và kiểm thử thuận tiện hơn.
