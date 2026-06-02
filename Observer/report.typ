

== Tên và Phân loại

*Observer Pattern* là một mẫu thiết kế thuộc nhóm *Behavioral Pattern* (nhóm hành vi).

Mẫu này định nghĩa mối quan hệ phụ thuộc một-nhiều giữa các đối tượng. Khi trạng thái của một đối tượng trung tâm thay đổi, mọi đối tượng phụ thuộc sẽ được thông báo và tự động cập nhật.

== Mục đích, ý định

Mục đích chính của Observer là xây dựng cơ chế publish-subscribe (phát-thông báo/đăng ký lắng nghe) để tách nơi phát sinh sự kiện khỏi nơi xử lý sự kiện.

Ý định của pattern:

- Cho phép nhiều đối tượng đăng ký nhận thay đổi từ một nguồn dữ liệu.
- Giảm coupling giữa đối tượng phát sự kiện (Subject) và các đối tượng phản ứng (Observer).
- Hỗ trợ cập nhật tự động khi trạng thái thay đổi.
- Dễ mở rộng thêm loại phản ứng mới mà không sửa mã Subject.

== Motivation

Giả sử ta có một đối tượng trung tâm `Subject` chứa trạng thái nghiệp vụ (ví dụ trạng thái cảm biến, trạng thái đơn hàng hoặc giá cổ phiếu).

Nhiều thành phần khác nhau cần phản ứng khi trạng thái này đổi:

- Thành phần A ghi log hoặc cảnh báo khi giá trị nhỏ hơn ngưỡng.
- Thành phần B cập nhật giao diện người dùng khi có thay đổi.

Nếu Subject gọi trực tiếp từng thành phần cụ thể, hệ thống nhanh chóng bị phụ thuộc chặt:

- Subject biết quá nhiều lớp xử lý cụ thể.
- Mỗi lần thêm kiểu phản ứng mới phải sửa Subject.
- Khó tái sử dụng Subject ở ngữ cảnh khác.

Observer giải quyết bằng cách để Subject chỉ quản lý danh sách observer thông qua interface và gọi `Notify()` khi trạng thái đổi. Observer nào quan tâm sẽ tự xử lý trong `Update()`.

== Khả năng ứng dụng

Nên dùng Observer khi:

- Một thay đổi dữ liệu cần lan truyền đến nhiều thành phần.
- Cần cơ chế event-driven để giảm phụ thuộc giữa module.
- Danh sách thành phần lắng nghe có thể thay đổi ở runtime (attach/detach).
- Muốn tách logic nghiệp vụ cốt lõi khỏi logic hiển thị, log, gửi thông báo.

Ví dụ điển hình:

- Hệ thống GUI (button click, state change, data binding).
- Hệ thống thông báo theo sự kiện trong microservice.
- Theo dõi trạng thái đơn hàng để gửi email/SMS/push notification.
- Giám sát cảm biến IoT và kích hoạt cảnh báo theo ngưỡng.

== Cấu trúc

Các vai trò chính của Observer Pattern:

- `ISubject`: khai báo `Attach`, `Detach`, `Notify`.
- `Subject`: lưu trạng thái và danh sách observer, phát thông báo khi đổi trạng thái.
- `IObserver`: khai báo `Update(ISubject subject)`.
- `ConcreteObserver`: cài đặt phản ứng cụ thể khi nhận thông báo.
- `Client`: tạo subject, observer và thiết lập đăng ký.

Sơ đồ lớp tổng quát:

```mermaid
classDiagram
	class ISubject {
		<<interface>>
		+Attach(observer)
		+Detach(observer)
		+Notify()
	}

	class Subject {
		-observers: List~IObserver~
		+State: int
		+Attach(observer)
		+Detach(observer)
		+Notify()
		+SomeBusinessLogic()
	}

	class IObserver {
		<<interface>>
		+Update(subject)
	}

	class ConcreteObserverA {
		+Update(subject)
	}

	class ConcreteObserverB {
		+Update(subject)
	}

	ISubject <|.. Subject
	IObserver <|.. ConcreteObserverA
	IObserver <|.. ConcreteObserverB
	Subject --> IObserver : notifies
```

== Các thành viên

`ISubject`

- Giao diện cho đối tượng phát sự kiện.
- Định nghĩa các thao tác quản lý vòng đời observer.

`Subject`

- Chứa trạng thái nghiệp vụ (`State`).
- Quản lý danh sách observer (`_observers`).
- Cung cấp `Attach`, `Detach`, `Notify`.
- Trong ví dụ, `SomeBusinessLogic()` thay đổi `State` ngẫu nhiên rồi phát thông báo.

`IObserver`

- Giao diện chuẩn cho mọi observer.
- Nhận callback `Update(ISubject subject)` khi Subject thay đổi.

`ConcreteObserverA`, `ConcreteObserverB`

- Cài đặt logic phản ứng riêng dựa trên `State` của Subject.
- `ConcreteObserverA` phản ứng khi `State < 3`.
- `ConcreteObserverB` phản ứng khi `State == 0` hoặc `State >= 2`.

`Client`

- Tạo Subject và các observer.
- Đăng ký/hủy đăng ký observer.
- Kích hoạt luồng nghiệp vụ để sinh sự kiện.

== Sự cộng tác

Luồng cộng tác tiêu biểu trong demo:

1. Client tạo `Subject`.
2. Client tạo `ConcreteObserverA` và `ConcreteObserverB`.
3. Client gọi `Attach()` để đăng ký lắng nghe.
4. Subject chạy `SomeBusinessLogic()`, cập nhật `State`.
5. Subject gọi `Notify()`.
6. Từng observer nhận `Update(subject)` và tự quyết định có phản ứng hay không.
7. Client có thể gọi `Detach()` để hủy đăng ký một observer bất kỳ.

== Các hệ quả mang lại, Ưu nhược điểm

=== Ưu điểm

- Giảm coupling giữa thành phần phát sự kiện và thành phần xử lý.
- Mở rộng tốt: thêm observer mới không cần sửa Subject.
- Hỗ trợ kiến trúc event-driven tự nhiên.
- Dễ tái sử dụng Subject trong nhiều ngữ cảnh khác nhau.
- Có thể đăng ký/hủy đăng ký linh hoạt trong runtime.

=== Nhược điểm

- Nếu số observer lớn, chi phí thông báo có thể tăng.
- Thứ tự gọi observer thường không đảm bảo nếu không quy định rõ.
- Dễ phát sinh vòng lặp sự kiện nếu observer tiếp tục kích hoạt thay đổi mới.
- Khó debug khi luồng sự kiện phức tạp và phân tán.

== Chú ý liên quan đến việc cài đặt

- Nên quy định rõ chính sách thứ tự notify nếu nghiệp vụ phụ thuộc thứ tự.
- Cần xử lý ngoại lệ trong từng observer để tránh một observer lỗi làm gãy toàn bộ chuỗi notify.
- Tránh memory leak bằng cách `Detach()` đúng lúc, đặc biệt với đối tượng sống lâu.
- Với hệ thống đa luồng, cần đồng bộ truy cập danh sách observer.
- Cân nhắc notify bất đồng bộ (queue/event bus) khi tải lớn.

== Một số so sánh nếu có

=== Observer và Mediator

- Observer tập trung vào phát-thông báo một-nhiều theo subscription.
- Mediator tập trung điều phối tương tác nhiều-nhiều qua một trung gian.

=== Observer và Pub/Sub qua message broker

- Observer thường in-process, trực tiếp trong cùng ứng dụng.
- Pub/Sub broker (RabbitMQ, Kafka...) thường dùng liên tiến trình/liên dịch vụ, bất đồng bộ mạnh hơn.

=== Observer và Callback trực tiếp

- Callback trực tiếp phù hợp tình huống đơn giản, ít bên nghe.
- Observer phù hợp khi số bên nghe thay đổi linh hoạt và cần quản lý vòng đời đăng ký.

== Mã nguồn minh họa

Đoạn mã dưới đây tóm lược theo đúng demo trong project:

```csharp
public interface IObserver
{
	void Update(ISubject subject);
}

public interface ISubject
{
	void Attach(IObserver observer);
	void Detach(IObserver observer);
	void Notify();
}

public class Subject : ISubject
{
	public int State { get; set; } = 0;
	private List<IObserver> _observers = new List<IObserver>();

	public void Attach(IObserver observer) => _observers.Add(observer);
	public void Detach(IObserver observer) => _observers.Remove(observer);

	public void Notify()
	{
		foreach (var observer in _observers)
		{
			observer.Update(this);
		}
	}

	public void SomeBusinessLogic()
	{
		State = new Random().Next(0, 10);
		Notify();
	}
}

class ConcreteObserverA : IObserver
{
	public void Update(ISubject subject)
	{
		if ((subject as Subject).State < 3)
			Console.WriteLine("ObserverA reacted.");
	}
}

class ConcreteObserverB : IObserver
{
	public void Update(ISubject subject)
	{
		if ((subject as Subject).State == 0 || (subject as Subject).State >= 2)
			Console.WriteLine("ObserverB reacted.");
	}
}
```

Kết quả chạy sẽ thay đổi theo giá trị ngẫu nhiên của `State`, nhưng luôn thể hiện:

- Subject cập nhật trạng thái.
- Subject thông báo toàn bộ observer đang đăng ký.
- Mỗi observer tự quyết định phản ứng theo điều kiện riêng.

== Ví dụ về các hệ thống thực tế

- Cơ chế event trong WinForms/WPF/JavaFX.
- Data binding trong MVVM (property change notification).
- Listener trong Android (`OnClickListener`, `TextWatcher`).
- Event emitter trong Node.js.
- Hệ thống domain events trong kiến trúc DDD.

== Các mẫu liên quan

- *Mediator*: dùng khi cần điều phối tương tác phức tạp giữa nhiều đối tượng.
- *Singleton*: Subject trung tâm đôi khi được triển khai dạng singleton trong ứng dụng nhỏ.
- *State*: khi state object thay đổi có thể phát sự kiện cho observer.
- *MVC/MVP/MVVM*: thường dùng Observer để đồng bộ Model và View.
