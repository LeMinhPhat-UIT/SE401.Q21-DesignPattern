

== Tên và Phân loại

*Proxy Pattern* là một mẫu thiết kế thuộc nhóm *Structural Pattern* (nhóm cấu trúc).

Mẫu này tạo ra một đối tượng đại diện (proxy) có cùng giao diện với đối tượng thật (real subject), từ đó kiểm soát cách truy cập đến đối tượng thật.

== Mục đích, ý định

Mục đích chính của Proxy là cung cấp một lớp trung gian để thêm kiểm soát trước/sau khi chuyển tiếp lời gọi tới đối tượng thật.

Ý định của pattern:

- Kiểm soát quyền truy cập vào đối tượng thật.
- Trì hoãn khởi tạo đối tượng nặng tài nguyên (lazy initialization).
- Tối ưu hiệu năng thông qua cache.
- Ghi log, đo thời gian, audit mà không sửa logic lõi.
- Ẩn truy cập từ xa (remote object) như truy cập cục bộ.

== Motivation

Giả sử hệ thống có dịch vụ đọc ảnh độ phân giải cao từ kho lưu trữ từ xa. Việc tải ảnh tốn thời gian và băng thông, nhưng không phải lúc nào client cũng thật sự cần dữ liệu ảnh đầy đủ.

Nếu client gọi trực tiếp đối tượng thật:

- Mỗi lần truy cập đều tải dữ liệu nặng.
- Khó kiểm soát quyền truy cập theo vai trò người dùng.
- Logic log và cache bị lặp lại ở nhiều nơi.

Proxy giải quyết bằng cách đặt một lớp đại diện:

- Kiểm tra quyền trước khi truy cập ảnh thật.
- Cache kết quả sau lần tải đầu.
- Chỉ khởi tạo đối tượng thật khi thật sự cần.

Client vẫn dùng cùng một interface, nên có thể thay real subject bằng proxy mà không đổi mã gọi.

== Khả năng ứng dụng

Nên dùng Proxy khi:

- Đối tượng thật nặng, khởi tạo tốn tài nguyên.
- Cần kiểm soát truy cập theo quyền.
- Cần thêm cache hoặc giới hạn tần suất gọi.
- Cần theo dõi/audit lời gọi mà không sửa đối tượng thật.
- Cần truy cập đối tượng ở máy khác nhưng muốn API cục bộ.

Tình huống thực tế:

- Ảnh/video lớn chỉ tải khi người dùng mở chi tiết.
- API client có lớp proxy để retry/throttle.
- ORM dùng proxy để lazy load quan hệ.
- Reverse proxy (Nginx) kiểm soát request trước backend.

== Cấu trúc

Thành phần chính của Proxy Pattern:

- `Subject`: interface chung cho `RealSubject` và `Proxy`.
- `RealSubject`: đối tượng thực hiện nghiệp vụ thật.
- `Proxy`: giữ tham chiếu đến `RealSubject`, thêm logic kiểm soát.
- `Client`: làm việc thông qua `Subject`.

Sơ đồ lớp tổng quát:

```mermaid
classDiagram
	class Subject {
		<<interface>>
		+Request()
	}

	class RealSubject {
		+Request()
	}

	class Proxy {
		-realSubject: RealSubject
		+Request()
		-CheckAccess() bool
		-LogAccess()
	}

	Subject <|.. RealSubject
	Subject <|.. Proxy
	Proxy --> RealSubject : controls access
	Client --> Subject
```

UML tổng quát (PlantUML):

```plantuml
@startuml
skinparam classAttributeIconSize 0

interface Subject {
	+Request()
}

class RealSubject {
	+Request()
}

class Proxy {
	-realSubject: RealSubject
	+Request()
	-CheckAccess(): bool
	-LogAccess(): void
}

class Client

Subject <|.. RealSubject
Subject <|.. Proxy
Proxy --> RealSubject
Client --> Subject
@enduml
```

Sequence cộng tác cơ bản:

```mermaid
sequenceDiagram
	participant C as Client
	participant P as Proxy
	participant R as RealSubject

	C->>P: Request()
	P->>P: CheckAccess()
	alt Access Granted
		P->>R: Request()
		R-->>P: result
		P->>P: LogAccess()
		P-->>C: result
	else Access Denied
		P-->>C: throw/deny
	end
```

== Các thành viên

`Subject`

- Định nghĩa giao diện mà cả proxy và real subject cùng tuân theo.
- Giúp client không phụ thuộc vào cài đặt cụ thể.

`RealSubject`

- Chứa nghiệp vụ cốt lõi.
- Thực thi xử lý chính khi có request hợp lệ.

`Proxy`

- Giữ tham chiếu tới `RealSubject`.
- Có thể trì hoãn khởi tạo real subject.
- Chặn/lọc request trước khi chuyển tiếp.
- Bổ sung cross-cutting concerns: logging, caching, auth, metrics.

`Client`

- Chỉ làm việc qua `Subject`.
- Không cần biết phía sau là proxy hay real subject.

== Sự cộng tác

Luồng hoạt động điển hình:

1. Client gọi `Request()` thông qua interface `Subject`.
2. Proxy nhận request và thực hiện bước tiền xử lý (check quyền, check cache, validate input).
3. Nếu chưa có `RealSubject`, proxy có thể tạo mới (lazy load).
4. Proxy chuyển tiếp request sang `RealSubject`.
5. `RealSubject` xử lý nghiệp vụ và trả kết quả.
6. Proxy hậu xử lý (log, metrics, cache) rồi trả về cho client.

== Các hệ quả mang lại, Ưu nhược điểm

=== Ưu điểm

- Kiểm soát truy cập tốt mà không chạm vào logic lõi.
- Tối ưu hiệu năng với lazy load và cache.
- Tăng khả năng mở rộng cho các concern phụ trợ (audit, tracing).
- Tuân thủ OCP: thêm proxy mới không sửa subject cũ.
- Client ít bị ảnh hưởng khi thay đổi cơ chế truy cập.

=== Nhược điểm

- Tăng số lớp và độ phức tạp cấu trúc.
- Có thêm một mức gián tiếp, có thể gây overhead nhỏ.
- Dễ tạo chuỗi proxy quá dài nếu lạm dụng.
- Khó debug hơn nếu nhiều logic ẩn trong proxy.

== Chú ý liên quan đến việc cài đặt

- Interface của proxy phải giống real subject để thay thế minh bạch.
- Nếu proxy giữ trạng thái (cache/session), cần chú ý thread safety.
- Tránh để proxy chứa quá nhiều nghiệp vụ chính.
- Với remote proxy, cần xử lý timeout, retry, circuit breaker.
- Cần chính sách invalidate cache rõ ràng.
- Quy định rõ lỗi phát sinh ở proxy hay real subject để logging nhất quán.

== Một số so sánh nếu có

=== Proxy và Decorator

- Cùng bọc object và cùng interface.
- Proxy tập trung *kiểm soát truy cập* hoặc *tối ưu truy cập*.
- Decorator tập trung *mở rộng hành vi* theo kiểu lắp ghép linh hoạt.

=== Proxy và Adapter

- Proxy giữ nguyên giao diện đối tượng thật.
- Adapter chuyển đổi từ giao diện này sang giao diện khác.

=== Proxy và Facade

- Facade cung cấp giao diện đơn giản cho cả subsystem.
- Proxy đại diện cho *một đối tượng cụ thể* để kiểm soát truy cập.

=== Proxy và Mediator

- Proxy điều tiết truy cập tới một đối tượng.
- Mediator điều phối tương tác giữa nhiều đối tượng đồng cấp.

=== Proxy và Flyweight

- Flyweight tối ưu bộ nhớ bằng chia sẻ trạng thái dùng chung cho nhiều object nhỏ.
- Proxy tối ưu hoặc kiểm soát *đường truy cập* đến object.

=== Proxy và Observer

- Observer lan truyền sự kiện một-nhiều qua cơ chế subscribe.
- Proxy không phát sự kiện; proxy chặn/chuyển tiếp lời gọi một cách minh bạch.

== Các biến thể Proxy thường dùng

=== Virtual Proxy

- Mục tiêu: trì hoãn tạo object nặng.
- Dùng khi chi phí khởi tạo cao nhưng tần suất sử dụng thấp.
- Rủi ro: độ trễ cao ở lần truy cập đầu tiên (cold start).

=== Protection Proxy

- Mục tiêu: kiểm soát quyền truy cập.
- Dùng khi cần RBAC/ABAC cho từng thao tác.
- Rủi ro: logic phân quyền đặt sai chỗ có thể gây lộ quyền.

=== Remote Proxy

- Mục tiêu: đại diện đối tượng từ xa như local object.
- Dùng với RPC/gRPC/REST client wrapper.
- Rủi ro: timeout, mạng lỗi, serialization mismatch.

=== Caching (Smart) Proxy

- Mục tiêu: giảm độ trễ và giảm số lần gọi đến real subject.
- Dùng cho dữ liệu đọc nhiều, ít thay đổi.
- Rủi ro: cache stale nếu không có chiến lược invalidation rõ ràng.

== Checklist triển khai thực tế

- Xác định rõ loại proxy cần dùng: virtual, protection, remote hay caching.
- Thiết kế `Subject` ổn định để client không phụ thuộc vào triển khai.
- Đảm bảo proxy và real subject tuân thủ cùng hợp đồng đầu vào/đầu ra.
- Nếu có cache: định nghĩa key, TTL, và điều kiện xóa cache.
- Nếu remote: chuẩn hóa timeout, retry, backoff và circuit breaker.
- Bổ sung observability: log tương quan, metrics latency, error rate.
- Viết test cho cả trường hợp pass-through lẫn trường hợp bị chặn tại proxy.
- Đánh giá overhead do proxy để tránh chain proxy quá sâu.

== Lỗi thường gặp và cách tránh

- Đưa nghiệp vụ lõi vào proxy:
  Proxy chỉ nên xử lý control concerns; nghiệp vụ chính để ở real subject.
- Quên đồng bộ khi proxy có trạng thái dùng chung:
  Dùng lock/thread-safe collection hoặc thiết kế stateless.
- Cache không invalidation:
  Định nghĩa chiến lược invalidation ngay từ đầu thay vì xử lý vá lỗi.
- Bắt mọi exception rồi nuốt lỗi:
  Cần phân biệt lỗi business và lỗi kỹ thuật, log có cấu trúc.
- Lộ khác biệt hành vi giữa proxy và real subject:
  Đảm bảo tính thay thế (LSP), cùng semantics cho cùng request.

== Mã nguồn minh họa

Ví dụ C\# dưới đây minh họa *Protection + Virtual Proxy*:

```csharp
using System;

namespace ProxyDemo
{
	public interface IImage
	{
		void Display();
	}

	// RealSubject: tải ảnh nặng và hiển thị.
	public class HighResolutionImage : IImage
	{
		private readonly string _fileName;

		public HighResolutionImage(string fileName)
		{
			_fileName = fileName;
			LoadFromDisk();
		}

		private void LoadFromDisk()
		{
			Console.WriteLine($"Loading image '{_fileName}' from disk...");
		}

		public void Display()
		{
			Console.WriteLine($"Displaying '{_fileName}'.");
		}
	}

	// Proxy: kiểm tra quyền và trì hoãn tạo real object.
	public class ImageProxy : IImage
	{
		private readonly string _fileName;
		private readonly string _role;
		private HighResolutionImage _realImage;

		public ImageProxy(string fileName, string role)
		{
			_fileName = fileName;
			_role = role;
		}

		public void Display()
		{
			if (!HasAccess())
			{
				Console.WriteLine("Access denied: user is not allowed to view this image.");
				return;
			}

			if (_realImage == null)
			{
				_realImage = new HighResolutionImage(_fileName);
			}

			Console.WriteLine("Proxy: access granted, forwarding request.");
			_realImage.Display();
		}

		private bool HasAccess()
		{
			return _role == "Admin" || _role == "Editor";
		}
	}

	public class Program
	{
		public static void Main()
		{
			IImage guestImage = new ImageProxy("architecture.png", "Guest");
			guestImage.Display();

			Console.WriteLine();

			IImage adminImage = new ImageProxy("architecture.png", "Admin");
			adminImage.Display();
			adminImage.Display(); // Lần 2 không cần load lại từ disk.
		}
	}
}
```

Kết quả dự kiến:

```text
Access denied: user is not allowed to view this image.

Loading image 'architecture.png' from disk...
Proxy: access granted, forwarding request.
Displaying 'architecture.png'.
Proxy: access granted, forwarding request.
Displaying 'architecture.png'.
```

Nhận xét:

- Người dùng `Guest` bị chặn tại proxy.
- Đối tượng ảnh thật chỉ tạo khi lần đầu truy cập hợp lệ.
- Lần gọi thứ hai không tải lại ảnh, thể hiện lợi ích lazy initialization.

== Ví dụ về các hệ thống thực tế

- ORM như Hibernate/Entity Framework dùng proxy để lazy loading entity liên quan.
- AOP proxy trong Spring/.NET để chèn transaction, logging, security.
- Reverse proxy (Nginx, HAProxy) đứng trước service để route, auth, cache.
- HTTP client wrapper thêm retry/circuit breaker cho gọi API.
- CDN edge proxy cache nội dung tĩnh trước khi truy cập origin.

== Các mẫu liên quan

- *Decorator*: cùng dạng wrapper, khác mục tiêu thiết kế.
- *Adapter*: chuyển giao diện, thường xuất hiện trước/sau proxy trong integration layer.
- *Facade*: có thể dùng cùng proxy để vừa đơn giản hóa vừa kiểm soát truy cập.
- *Bridge*: tách abstraction-implementation; proxy có thể bọc phía implementation.
- *Chain of Responsibility*: có thể kết hợp nhiều proxy/filter dạng pipeline xử lý request.

Tóm lại, Proxy Pattern đặc biệt hữu ích khi hệ thống cần kiểm soát truy cập, tối ưu hiệu năng hoặc ẩn độ phức tạp giao tiếp từ xa mà vẫn giữ API ổn định cho client. Nếu dùng đúng ranh giới trách nhiệm, Proxy giúp mở rộng hệ thống sạch và an toàn hơn mà không làm rối nghiệp vụ cốt lõi.
