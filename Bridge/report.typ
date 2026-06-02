#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

== Tên và phân loại

*Bridge Pattern* trong tiếng Việt thường được gọi là *mẫu Cầu nối*.

Bridge thuộc nhóm *Structural Pattern* vì nó tập trung vào cách tổ chức cấu trúc lớp/đối tượng. Ý tưởng chính là tách phần trừu tượng (abstraction) khỏi phần triển khai chi tiết (implementation), sau đó nối hai phần bằng composition.

Tên gọi "Bridge" thể hiện đúng bản chất: tạo một chiếc cầu giữa hai hệ phân cấp độc lập để cả hai có thể phát triển riêng mà vẫn phối hợp được.

== Vấn đề cần giải quyết

Trong nhiều hệ thống, một tính năng có ít nhất hai chiều thay đổi độc lập.

Ví dụ với hệ thống thông báo:

- Chiều 1: loại thông báo (`BasicNotification`, `UrgentNotification`, `DigestNotification`, ...).
- Chiều 2: kênh gửi (`EmailSender`, `SmsSender`, `PushSender`, ...).

Nếu không dùng Bridge, ta thường tạo class cho mọi tổ hợp:

```text
BasicEmailNotification
BasicSmsNotification
UrgentEmailNotification
UrgentSmsNotification
...
```

Khi có $m$ loại thông báo và $n$ kênh gửi, số class có thể tăng gần $m * n$.

Cách làm này dẫn tới:

- Số lượng class bùng nổ khi mở rộng.
- Logic bị lặp lại ở nhiều class tổ hợp.
- Thêm biến thể mới ở một chiều phải sửa nhiều nơi.
- Coupling cao, bảo trì và test khó hơn.

Vấn đề cốt lõi là: *làm sao tách hai chiều thay đổi độc lập để mở rộng linh hoạt mà không nhân chéo số lượng class?*

== Mục đích và ý định

Mục đích chính của Bridge là *decouple abstraction khỏi implementation để chúng có thể thay đổi độc lập*.

Nói ngắn gọn:

- Abstraction mô tả "muốn làm gì".
- Implementor mô tả "làm bằng cách nào".
- Abstraction ủy quyền phần chi tiết cho implementor thông qua một interface chung.

== Định nghĩa

*Bridge Pattern* là một structural design pattern tách abstraction và implementation thành hai hệ phân cấp riêng biệt, cho phép cả hai biến thiên độc lập và kết hợp linh hoạt thông qua object composition.

Các thành phần ở mức định nghĩa:

- `Abstraction`: giao diện mức cao mà client sử dụng.
- `RefinedAbstraction`: các biến thể cụ thể của abstraction.
- `Implementor`: hợp đồng cho phần cài đặt chi tiết.
- `ConcreteImplementor`: các cài đặt cụ thể.

== Ý tưởng cốt lõi

Thay vì kế thừa chéo theo nhiều tổ hợp, Bridge tách thành hai cây class:

```text
Abstraction tree: Notification -> Basic/Urgent/...
Implementation tree: INotificationSender -> Email/SMS/...
```

Mỗi object ở phía abstraction giữ tham chiếu đến implementor, rồi gọi implementor khi cần thao tác chi tiết.

Có thể hình dung luồng dùng như sau:

```text
Client chọn loại Notification
+
Client chọn kênh Sender
-> Inject sender vào notification
-> Notification gọi sender để gửi
```

== Thành phần chính

=== Abstraction

`Abstraction` định nghĩa thao tác mức cao và giữ tham chiếu đến `Implementor`.

Trong demo Bridge hiện tại, lớp này là `Notification`.

=== RefinedAbstraction

`RefinedAbstraction` mở rộng hoặc tinh chỉnh hành vi của abstraction.

Ví dụ:

- `BasicNotification`: gửi nguyên văn nội dung.
- `UrgentNotification`: thêm tiền tố `[URGENT]` trước khi gửi.

=== Implementor

`Implementor` là interface định nghĩa các thao tác chi tiết.

Ví dụ: `INotificationSender` với phương thức `Send(string message)`.

=== ConcreteImplementor

Các cài đặt cụ thể của `Implementor`.

Ví dụ:

- `EmailSender`
- `SmsSender`

=== Client

Client kết hợp abstraction và implementor theo nhu cầu runtime.

```csharp
Notification notification = new UrgentNotification(new SmsSender());
notification.Send("Server is down!");
```

== Cấu trúc UML

Class diagram tổng quát bằng PlantUML:

```plantuml
@startuml
skinparam classAttributeIconSize 0

class Client

abstract class Abstraction {
  -implementor: Implementor
  +operation()
}

class RefinedAbstractionA {
  +operation()
}

class RefinedAbstractionB {
  +operation()
}

interface Implementor {
  +operationImpl()
}

class ConcreteImplementorA {
  +operationImpl()
}

class ConcreteImplementorB {
  +operationImpl()
}

Client --> Abstraction
Abstraction o--> Implementor
RefinedAbstractionA --|> Abstraction
RefinedAbstractionB --|> Abstraction
ConcreteImplementorA ..|> Implementor
ConcreteImplementorB ..|> Implementor
@enduml
```

== Luồng hoạt động

Luồng cơ bản của Bridge:

1. Client tạo một `ConcreteImplementor`.
2. Client inject implementor vào constructor của `RefinedAbstraction`.
3. Client gọi operation trên abstraction.
4. Abstraction xử lý logic mức cao.
5. Abstraction ủy quyền phần thực thi chi tiết cho implementor.
6. Implementor thực thi thao tác cụ thể.

Sequence diagram minh họa:

```plantuml
@startuml
actor Client
participant "UrgentNotification" as N
participant "SmsSender" as S

Client -> N : Send("Server is down!")
N -> N : prepend "[URGENT]"
N -> S : Send("[URGENT] Server is down!")
S -> S : output SMS
S --> Client : done
@enduml
```

== Các biến thể triển khai

=== Bridge cơ bản

Abstraction gọi implementor theo một chiều rõ ràng. Đây là dạng phổ biến nhất.

=== Bridge hai chiều mở rộng mạnh

Cả abstraction lẫn implementor đều có nhiều nhánh con và cùng phát triển độc lập.

Ví dụ:

- Abstraction: `Basic`, `Urgent`, `Scheduled`.
- Implementor: `Email`, `SMS`, `Push`.

=== Chọn implementor theo runtime

Implementor có thể được cấu hình theo môi trường hoặc theo cấu hình người dùng:

- Development: `ConsoleSender`.
- Production: `EmailSender`/`SmsSender`.

== Ví dụ minh họa bằng C\#

Ví dụ sau đồng bộ với code trong BridgeDemo của nhóm.

=== Implementor

```csharp
public interface INotificationSender
{
    void Send(string message);
}

public class EmailSender : INotificationSender
{
    public void Send(string message)
    {
        Console.WriteLine($"[Email] Sending: {message}");
    }
}

public class SmsSender : INotificationSender
{
    public void Send(string message)
    {
        Console.WriteLine($"[SMS] Sending: {message}");
    }
}
```

=== Abstraction và RefinedAbstraction

```csharp
public abstract class Notification
{
    protected INotificationSender sender;

    protected Notification(INotificationSender sender)
    {
        this.sender = sender;
    }

    public abstract void Send(string message);
}

public class BasicNotification : Notification
{
    public BasicNotification(INotificationSender sender)
        : base(sender) { }

    public override void Send(string message)
    {
        sender.Send(message);
    }
}

public class UrgentNotification : Notification
{
    public UrgentNotification(INotificationSender sender)
        : base(sender) { }

    public override void Send(string message)
    {
        sender.Send("[URGENT] " + message);
    }
}
```

=== Client sử dụng Bridge

```csharp
Notification notification1 = new BasicNotification(new EmailSender());
notification1.Send("Hello World");

Console.WriteLine();

Notification notification2 = new UrgentNotification(new SmsSender());
notification2.Send("Server is down!");

Console.WriteLine();

Notification notification3 = new UrgentNotification(new EmailSender());
notification3.Send("Database error!");
```

Ở ví dụ này:

- Loại notification và kênh gửi được chọn độc lập.
- Có thể mix linh hoạt các tổ hợp ngay tại runtime.
- Việc mở rộng hai phía không phụ thuộc chặt vào nhau.

== Class diagram cho ví dụ C\#

```plantuml
@startuml
skinparam classAttributeIconSize 0

abstract class Notification {
  #sender: INotificationSender
  +Send(message: string)
}

class BasicNotification {
  +Send(message: string)
}

class UrgentNotification {
  +Send(message: string)
}

interface INotificationSender {
  +Send(message: string)
}

class EmailSender {
  +Send(message: string)
}

class SmsSender {
  +Send(message: string)
}

Notification <|-- BasicNotification
Notification <|-- UrgentNotification
Notification o--> INotificationSender
INotificationSender <|.. EmailSender
INotificationSender <|.. SmsSender
@enduml
```

== Đánh giá

=== Ưu điểm

*Giảm class explosion.* Tránh tạo class cho mọi tổ hợp biến thể.

*Loose coupling.* Abstraction chỉ phụ thuộc vào interface implementor.

*Dễ mở rộng.* Thêm biến thể mới ở từng phía với ít tác động.

*Tuân thủ SRP/OCP tốt hơn.* Trách nhiệm tách rõ và dễ mở rộng không phá code cũ.

*Linh hoạt runtime.* Có thể thay implementor theo cấu hình hoặc ngữ cảnh.

=== Nhược điểm

*Tăng số lớp và mức trừu tượng.* Với bài toán nhỏ có thể gây over-engineering.

*Khó nắm bắt với người mới.* Cần hiểu rõ vai trò từng thành phần để tránh thiết kế sai.

*Thêm tầng gián tiếp.* Có thể làm trace luồng gọi phức tạp hơn.

== Khi nào nên dùng

Nên dùng Bridge khi:

- Có từ hai chiều thay đổi độc lập.
- Dự đoán còn mở rộng ở cả hai chiều trong tương lai.
- Muốn tránh inheritance tổ hợp gây bùng nổ class.
- Cần hoán đổi implementation ở runtime.

Ví dụ phù hợp:

- Notification type x Delivery channel.
- Shape x Render engine.
- RemoteControl x Device.
- Report x Export backend.

== Khi nào không nên dùng

Không nên dùng Bridge khi:

- Bài toán chỉ có một chiều thay đổi rõ ràng.
- Số biến thể ít và ổn định lâu dài.
- Yêu cầu ưu tiên tối đa sự đơn giản hơn tính mở rộng.

== Lưu ý khi cài đặt

- Xác định đúng hai chiều biến thiên trước khi tách Bridge.
- Ưu tiên composition thay vì kế thừa theo tổ hợp.
- Giữ interface implementor gọn, tập trung primitive operation.
- Không để abstraction phụ thuộc concrete implementor.
- Có thể kết hợp Dependency Injection để quản lý implementor.
- Nên có test riêng cho refined abstraction và từng concrete implementor.

== Ví dụ thực tế

=== UI toolkit đa nền tảng

Abstraction là widget (`Button`, `TextBox`), implementation là backend render theo nền tảng (`Win32`, `X11`, `Cocoa`).

=== Device driver

Abstraction là lệnh nghiệp vụ cấp cao, implementation là driver cụ thể của từng hãng.

=== Logging platform

Abstraction là logger mức cao, implementation là đích ghi (`Console`, `File`, `Elastic`, `Cloud`).

=== Notification platform

Abstraction là loại thông báo, implementation là provider gửi (`SMTP`, `SMS Gateway`, `Push Service`).

== So sánh với các pattern khác

=== Bridge và Adapter

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  align: left,
  [*Tiêu chí*], [*Bridge*], [*Adapter*],
  [Mục đích], [Tách abstraction và implementation], [Chuyển đổi interface không tương thích],
  [Thời điểm dùng], [Thiết kế từ đầu để mở rộng], [Tích hợp lớp/hệ thống có sẵn],
  [Trọng tâm], [Khả năng mở rộng cấu trúc], [Khả năng tương thích],
)

=== Bridge và Strategy

#table(
  columns: (1fr, 1fr, 1fr),
  inset: 6pt,
  align: left,
  [*Tiêu chí*], [*Bridge*], [*Strategy*],
  [Mục đích], [Tách hai hierarchy độc lập], [Thay đổi thuật toán],
  [Số chiều], [Thường 2 chiều], [Thường 1 chiều],
  [Vai trò], [Kiến trúc cấu trúc lớp], [Chiến lược hành vi],
)

=== Bridge và Abstract Factory

Abstract Factory có thể phối hợp với Bridge để tạo đúng cặp abstraction + implementor theo từng môi trường hoặc cấu hình.

== Quan hệ với nguyên lý thiết kế

Bridge hỗ trợ mạnh các nguyên lý:

*Single Responsibility Principle.* Mỗi hierarchy xử lý một chiều thay đổi.

*Open/Closed Principle.* Thêm abstraction/implementor mới mà không cần sửa sâu mã cũ.

*Dependency Inversion Principle.* Abstraction phụ thuộc vào interface implementor.

Ngoài ra, Bridge thể hiện rõ tư tưởng "favor composition over inheritance".

== Tóm tắt

Bridge Pattern là lựa chọn phù hợp khi hệ thống có hai chiều biến thiên độc lập và có nguy cơ bùng nổ class nếu kế thừa theo tổ hợp.

Bằng cách tách abstraction và implementation thành hai hệ phân cấp riêng, rồi nối chúng bằng composition, Bridge giúp hệ thống dễ mở rộng, dễ bảo trì và linh hoạt hơn khi thay đổi.

Có thể ghi nhớ ngắn gọn:

```text
Bridge = Tách phần "muốn làm gì" và "làm bằng cách nào"
để hai phía phát triển độc lập nhưng vẫn phối hợp được.
```