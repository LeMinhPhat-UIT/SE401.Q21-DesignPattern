#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

= Command Pattern

== Tên và Phân loại

*Command Pattern* là một mẫu thiết kế thuộc nhóm *Behavioral Pattern*.

Trong tiếng Việt, pattern này thường được gọi là *mẫu lệnh*. Ý tưởng trọng tâm là đóng gói một yêu cầu (request) thành một object độc lập, gọi là command. Khi đó, thao tác thực thi có thể được truyền đi, lưu lại, xếp hàng, hoàn tác hoặc thực hiện trễ (deferred execution).

== Mục đích, ý định

Mục đích chính của Command là *biến một hành động thành object* để tách nơi phát sinh yêu cầu khỏi nơi xử lý yêu cầu.

Ý định cụ thể:

- Tách `Invoker` (nơi gọi lệnh) khỏi `Receiver` (nơi thực thi nghiệp vụ).
- Cho phép tham số hóa object bằng thao tác.
- Dễ hỗ trợ undo/redo.
- Dễ log, queue, replay thao tác.
- Dễ ghép macro command (một lệnh gồm nhiều lệnh con).

== Bí danh

Command Pattern thường được nhắc bằng các tên:

- *Action* (trong nhiều GUI framework).
- *Transaction object* (khi command mang tính giao dịch và có undo).
- *Request object pattern*.

== Motivation

Xét một ứng dụng editor có toolbar và shortcut bàn phím:

- Nút Save.
- Nút Copy/Paste.
- Nút Undo/Redo.
- Menu macro "Format + Save + Export".

Nếu gắn trực tiếp xử lý nghiệp vụ vào từng nút, hệ thống nhanh chóng rối:

- UI phụ thuộc chặt vào class nghiệp vụ.
- Khó tái sử dụng hành động cho nhiều trigger khác nhau (button, hotkey, context menu).
- Khó thêm undo/redo vì không có đơn vị thao tác độc lập.
- Khó queue/retry thao tác trong môi trường bất đồng bộ.

Command giải quyết bằng cách gom mỗi thao tác thành một object có giao diện chung như `Execute()` (và có thể thêm `Undo()`). UI chỉ gọi command, còn logic thực thi nằm ở receiver.

== Khả năng ứng dụng

Command phù hợp khi:

- Cần tách UI layer khỏi business logic.
- Cần hỗ trợ undo/redo.
- Cần queue command để xử lý async/background.
- Cần log và replay thao tác.
- Cần tạo macro từ nhiều thao tác nhỏ.
- Cần truyền thao tác qua network hoặc message bus.

Ví dụ điển hình:

- Text editor (Copy/Cut/Paste/Undo).
- CAD/design tools (move/rotate/resize with undo).
- Job scheduler (enqueue command chạy theo lịch).
- CQRS write model (command object đại diện ý định thay đổi trạng thái).

== Cấu trúc

Command Pattern thường có cấu trúc sau:

- `Command` interface: định nghĩa `Execute()` (và có thể `Undo()`).
- `ConcreteCommand`: cài đặt lệnh cụ thể, giữ tham chiếu receiver và dữ liệu cần thiết.
- `Receiver`: chứa logic nghiệp vụ thật.
- `Invoker`: gọi command, có thể lưu history.
- `Client`: tạo command, gán receiver, cấu hình invoker.

UML tổng quát:

```plantuml
@startuml
skinparam classAttributeIconSize 0

interface Command {
  +Execute()
  +Undo()
}

class ConcreteCommandA {
  -receiver: Receiver
  +Execute()
  +Undo()
}

class ConcreteCommandB {
  -receiver: Receiver
  +Execute()
  +Undo()
}

class Receiver {
  +ActionA()
  +ActionB()
}

class Invoker {
  -history: List<Command>
  +SetCommand(command: Command)
  +Run()
}

class Client

ConcreteCommandA ..|> Command
ConcreteCommandB ..|> Command
ConcreteCommandA --> Receiver
ConcreteCommandB --> Receiver
Invoker --> Command
Client --> Invoker
Client --> Receiver
Client --> ConcreteCommandA
Client --> ConcreteCommandB
@enduml
```

== Các thành viên

`Command`

- Interface chung cho mọi lệnh.
- Tối thiểu có `Execute()`.
- Nếu cần undo/redo, thêm `Undo()`.

`ConcreteCommand`

- Đóng gói yêu cầu cụ thể.
- Chứa dữ liệu đầu vào cho thao tác.
- Gọi receiver để thực thi logic.

`Receiver`

- Nơi chứa nghiệp vụ thật.
- Không biết invoker hay UI cụ thể.
- Có thể được dùng bởi nhiều command.

`Invoker`

- Kích hoạt command.
- Có thể quản lý queue/history.
- Không cần biết chi tiết nghiệp vụ bên dưới.

`Client`

- Wiring toàn hệ thống.
- Khởi tạo receiver, command, invoker.
- Gắn command vào nút bấm/hotkey/scheduler.

== Sự cộng tác

Luồng cộng tác chuẩn:

1. Client tạo receiver.
2. Client tạo concrete command và inject receiver.
3. Client gán command vào invoker.
4. Invoker gọi `Execute()` khi có trigger.
5. Command gọi receiver để xử lý nghiệp vụ.
6. Nếu có undo, invoker lưu history và gọi `Undo()` khi cần.

Sequence diagram:

```plantuml
@startuml
actor User
participant Invoker
participant ConcreteCommand
participant Receiver

User -> Invoker : click button / press shortcut
Invoker -> ConcreteCommand : Execute()
ConcreteCommand -> Receiver : Action(...)
Receiver --> ConcreteCommand : done
ConcreteCommand --> Invoker : done
@enduml
```

== Các hệ quả mang lại, Ưu nhược điểm

=== Ưu điểm

- *Loose Coupling*: invoker không phụ thuộc receiver cụ thể.
- *Open/Closed*: thêm command mới mà ít sửa code cũ.
- *Undo/Redo friendly*: command là đơn vị thao tác độc lập.
- *Queue/Retry/Logging dễ dàng*: command object có thể lưu, serialize, replay.
- *Macro support*: gom nhiều command thành command lớn.

=== Nhược điểm

- Tăng số lượng class với mỗi thao tác mới.
- Có thể over-engineering cho bài toán nhỏ.
- Undo phức tạp khi thao tác có side-effect ngoài hệ thống (gửi mail, gọi API ngoài).
- Cần quản lý history và transaction boundary cẩn thận.

== Chú ý liên quan đến việc cài đặt

- Mỗi command nên làm một việc rõ ràng (SRP).
- Quy định rõ idempotency nếu command có thể retry.
- Với undo, cần lưu đủ state trước khi execute.
- Tránh để command chứa logic nghiệp vụ quá lớn, nghiệp vụ nên ở receiver/domain service.
- Nếu cần chạy async, interface có thể là `Task ExecuteAsync()`.
- Với distributed system, nên có `CommandId`, timestamp, correlation id để trace.

== Một số so sánh nếu có

=== Command và Strategy

- Command đóng gói *yêu cầu thực thi* thành object.
- Strategy đóng gói *thuật toán thay thế* cho một context.

Command thường gắn với trigger, queue, undo/redo; Strategy thường gắn với chọn cách xử lý tại runtime.

=== Command và Chain of Responsibility

- Command: một thao tác cụ thể được execute.
- Chain of Responsibility: request đi qua chuỗi handler có thể chặn hoặc chuyển tiếp.

Có thể kết hợp: mỗi handler trong chain thực thi một command.

=== Command và Mediator

- Command tập trung vào thao tác.
- Mediator tập trung điều phối giao tiếp giữa nhiều colleague object.

=== Command và Event

- Command diễn tả *ý định* (hãy làm gì đó), thường one handler chính.
- Event diễn tả *điều đã xảy ra*, có thể nhiều subscriber.

== Mã nguồn minh họa

Ví dụ C# đơn giản có undo/redo cho tài khoản ngân hàng.

```csharp
using System;
using System.Collections.Generic;

public interface ICommand
{
	void Execute();
	void Undo();
}

public class BankAccount
{
	public string Owner { get; }
	public decimal Balance { get; private set; }

	public BankAccount(string owner, decimal initialBalance)
	{
		Owner = owner;
		Balance = initialBalance;
	}

	public void Deposit(decimal amount)
	{
		Balance += amount;
		Console.WriteLine($"Deposit {amount}. Balance = {Balance}");
	}

	public void Withdraw(decimal amount)
	{
		Balance -= amount;
		Console.WriteLine($"Withdraw {amount}. Balance = {Balance}");
	}
}

public class DepositCommand : ICommand
{
	private readonly BankAccount _account;
	private readonly decimal _amount;

	public DepositCommand(BankAccount account, decimal amount)
	{
		_account = account;
		_amount = amount;
	}

	public void Execute() => _account.Deposit(_amount);
	public void Undo() => _account.Withdraw(_amount);
}

public class WithdrawCommand : ICommand
{
	private readonly BankAccount _account;
	private readonly decimal _amount;

	public WithdrawCommand(BankAccount account, decimal amount)
	{
		_account = account;
		_amount = amount;
	}

	public void Execute() => _account.Withdraw(_amount);
	public void Undo() => _account.Deposit(_amount);
}

public class CommandInvoker
{
	private readonly Stack<ICommand> _undoStack = new();
	private readonly Stack<ICommand> _redoStack = new();

	public void Run(ICommand command)
	{
		command.Execute();
		_undoStack.Push(command);
		_redoStack.Clear();
	}

	public void Undo()
	{
		if (_undoStack.Count == 0) return;

		var cmd = _undoStack.Pop();
		cmd.Undo();
		_redoStack.Push(cmd);
	}

	public void Redo()
	{
		if (_redoStack.Count == 0) return;

		var cmd = _redoStack.Pop();
		cmd.Execute();
		_undoStack.Push(cmd);
	}
}

public class Program
{
	public static void Main()
	{
		var account = new BankAccount("Phat", 1000m);
		var invoker = new CommandInvoker();

		invoker.Run(new DepositCommand(account, 200m));
		invoker.Run(new WithdrawCommand(account, 150m));

		Console.WriteLine("Undo:");
		invoker.Undo();

		Console.WriteLine("Redo:");
		invoker.Redo();
	}
}
```

Ví dụ trên minh họa:

- Mỗi thao tác gửi/rút tiền là một command object.
- Invoker quản lý lịch sử để undo/redo.
- UI hoặc API endpoint chỉ cần gọi invoker, không cần biết chi tiết tài khoản xử lý ra sao.

== Ví dụ về các hệ thống thực tế

- *Text editors*: mỗi thao tác nhập/xóa/định dạng là command có undo.
- *IDE*: refactor action thường triển khai theo command + history.
- *Game engines*: input mapping (jump, shoot, interact) qua command.
- *Job queue systems*: mỗi job có thể xem như một command delayed execution.
- *CQRS architectures*: `CreateOrderCommand`, `ApprovePaymentCommand`, ...
- *Remote control IoT*: nút bấm ánh xạ tới command gửi tới thiết bị tương ứng.

== Các mẫu liên quan

- *Memento*: thường đi cùng Command để lưu trạng thái undo phức tạp.
- *Composite*: dùng cho macro command (một command chứa danh sách command con).
- *Prototype*: clone command mẫu rồi chỉnh dữ liệu đầu vào.
- *Mediator*: invoker/command có thể gửi kết quả qua mediator để điều phối module khác.
- *Chain of Responsibility*: command sau khi tạo có thể đi qua chain kiểm tra/authorize trước khi execute.

Tóm lại, Command Pattern đặc biệt mạnh khi hệ thống cần tách trigger và xử lý, đồng thời hỗ trợ lịch sử thao tác, queue, retry và mở rộng hành vi theo hướng data-driven.
