#set heading(level: 3)


== Tên và phân loại

*Memento Pattern* có thể hiểu là *mẫu lưu dấu trạng thái* hoặc *mẫu ghi nhớ*. Tên gọi này nhấn mạnh mục tiêu chính của pattern: lưu lại một trạng thái tại một thời điểm cụ thể để sau này có thể khôi phục lại.

Memento thuộc nhóm *Behavioral Pattern* vì nó tập trung vào cách object quản lý hành vi liên quan đến việc lưu, phục hồi và quay lại trạng thái trước đó. Pattern này không chỉ nói về việc lưu dữ liệu, mà còn nói về cách lưu dữ liệu sao cho không phá vỡ tính đóng gói của object.

Nói ngắn gọn, Memento là pattern dùng để *lưu snapshot trạng thái của một object và khôi phục lại snapshot đó khi cần*, nhưng bên ngoài không được can thiệp trực tiếp vào cấu trúc nội bộ của object.

== Vấn đề cần giải quyết

Trong nhiều hệ thống, người dùng hoặc chương trình cần quay lại trạng thái trước đó sau khi đã thực hiện một số thay đổi. Đây là nhu cầu rất phổ biến.

Ví dụ:

- Trình soạn thảo văn bản cần hỗ trợ *Undo/Redo*.
- Game cần lưu *checkpoint* hoặc *save slot*.
- Hệ thống cấu hình cần lưu snapshot trước khi thay đổi setting.
- Database hoặc nghiệp vụ cần rollback khi một thao tác thất bại.
- Form nhập liệu cần lưu trạng thái ban đầu trước khi người dùng chỉnh sửa.
- Công cụ thiết kế cần quay lại trạng thái trước đó của canvas.

Giả sử ta có một `TextEditor` đang chứa nội dung văn bản, vị trí con trỏ, vùng đang chọn, font, màu chữ và nhiều thông tin khác. Khi người dùng bấm `Ctrl + Z`, hệ thống cần khôi phục lại trạng thái trước đó.

Một cách làm đơn giản là để bên ngoài đọc toàn bộ state của `TextEditor`, lưu lại, rồi khi cần thì gán ngược lại. Tuy nhiên cách này có vấn đề lớn:

- Client phải biết quá nhiều chi tiết nội bộ của `TextEditor`.
- Object bị lộ state, làm giảm tính đóng gói.
- Khi cấu trúc state thay đổi, nhiều đoạn code bên ngoài cũng phải thay đổi.
- Dễ xảy ra lỗi nếu client lưu thiếu hoặc khôi phục sai state.

Vấn đề cốt lõi là: *làm sao quay lại trạng thái trước đó của object mà không làm lộ toàn bộ dữ liệu nội bộ của object?*

== Định nghĩa

*Memento Pattern* là một design pattern cho phép lưu và khôi phục trạng thái trước đó của một object mà không phá vỡ tính đóng gói (*encapsulation*).

Pattern này tách trách nhiệm thành ba phần:

- Object chính tự biết cách tạo snapshot của chính nó.
- Snapshot được đóng gói trong một object riêng gọi là `Memento`.
- Một object quản lý lịch sử snapshot, nhưng không được phép sửa hoặc hiểu chi tiết bên trong snapshot.

Điểm quan trọng của Memento là: object bên ngoài có thể giữ snapshot, nhưng không nên truy cập trực tiếp vào dữ liệu nội bộ trong snapshot. Chỉ object tạo ra snapshot mới nên có quyền dùng snapshot đó để restore.

== Ý tưởng cốt lõi

Ý tưởng chính của Memento Pattern là:

*Trước khi thay đổi state quan trọng, object tạo ra một bản ghi nhớ trạng thái hiện tại. Khi cần undo hoặc rollback, object dùng bản ghi nhớ đó để tự khôi phục lại state cũ.*

Có thể hình dung qua ví dụ *save game*:

- Nhân vật game, level, máu, vị trí, inventory là trạng thái hiện tại.
- Save slot là `Memento`.
- Save manager là `Caretaker`, quản lý danh sách save slot.

Có thể hình dung qua ví dụ *Ctrl + Z trong text editor*:

- Văn bản hiện tại là state của `Editor`.
- Mỗi lần lưu lịch sử là một `Memento`.
- `History` hoặc `UndoManager` là `Caretaker`, quản lý stack các memento.

Điểm đặc biệt là `Caretaker` chỉ biết lưu và lấy memento. Nó không cần biết bên trong memento có text, cursor, selection hay format gì. Việc đóng gói này giúp bảo vệ object chính khỏi việc bị truy cập state tùy tiện từ bên ngoài.

== Thành phần chính

Các thành phần chính của Memento Pattern gồm:

#table(
  columns: (1.3fr, 3.8fr),
  inset: 8pt,
  align: left,
  [*Thành phần*], [*Vai trò*],
  [`Originator`],
  [Object chính có state cần được lưu và khôi phục. Originator tự tạo memento và tự restore từ memento.],

  [`Memento`],
  [Object chứa snapshot trạng thái của Originator tại một thời điểm. Memento nên che giấu dữ liệu nội bộ khỏi bên ngoài.],

  [`Caretaker`],
  [Object quản lý lịch sử snapshot, ví dụ stack undo/redo hoặc danh sách checkpoint. Caretaker không xử lý logic state bên trong.],

  [`Client`], [Đối tượng kích hoạt thao tác save, undo, redo hoặc rollback thông qua Originator và Caretaker.],
)

Vai trò cụ thể:

- `Originator`: biết rõ state nội bộ của mình, nên nó là nơi phù hợp nhất để tạo snapshot và khôi phục snapshot.
- `Memento`: đóng vai trò như một hộp lưu trạng thái. Bên ngoài chỉ nên xem nó như một bản ghi lịch sử, không nên sửa nội dung bên trong.
- `Caretaker`: lưu nhiều memento theo thứ tự thời gian. Với undo, thường dùng stack. Với save game, có thể dùng danh sách save slot hoặc file lưu trữ.

== UML tổng quát

Sơ đồ UML tổng quát của Memento Pattern:

#figure(
  image("diagrams/memento-structure.svg", width: 100%),
  caption: [Cấu trúc UML tổng quát của Memento Pattern],
)


Giải thích sơ đồ:

- `Originator` có state thật sự của object.
- Khi cần lưu, `Originator.Save()` tạo ra `Memento` chứa snapshot.
- `Caretaker.Backup()` gọi `Save()` và lưu memento vào `history`.
- Khi undo, `Caretaker.Undo()` lấy memento gần nhất và yêu cầu `Originator.Restore()`.

== UML minh họa với Text Editor

Ví dụ cụ thể với trình soạn thảo văn bản:

#figure(
  image("diagrams/memento-text-editor-example.svg", width: 100%),
  caption: [Class diagram của ví dụ Text Editor],
)


Trong ví dụ này:

- `TextEditor` là `Originator`.
- `EditorMemento` là snapshot của nội dung và vị trí con trỏ.
- `EditorHistory` là `Caretaker`, quản lý stack undo và redo.

== Luồng hoạt động

Luồng hoạt động khi lưu trạng thái:

1. User hoặc client chuẩn bị thực hiện một thao tác có thể cần undo.
2. Client yêu cầu `Caretaker` lưu trạng thái hiện tại.
3. `Caretaker` gọi `Originator.Save()` hoặc `CreateSnapshot()`.
4. `Originator` tạo `Memento` chứa state hiện tại.
5. `Caretaker` lưu `Memento` vào lịch sử.
6. User thực hiện thay đổi state.

Luồng hoạt động khi undo:

1. User bấm undo hoặc hệ thống cần rollback.
2. `Caretaker` lấy memento gần nhất từ lịch sử.
3. `Caretaker` truyền memento đó cho `Originator`.
4. `Originator` đọc state trong memento.
5. `Originator` khôi phục lại state cũ.
6. Client tiếp tục làm việc với object đã được restore.

Sequence diagram minh họa:

#figure(
  image("diagrams/memento-sequence.svg", width: 100%),
  caption: [Luồng backup và undo bằng Memento],
)


== Ví dụ code C\#

Ví dụ dưới đây mô phỏng một text editor đơn giản có chức năng undo.

```csharp
using System;
using System.Collections.Generic;

public class EditorMemento
{
    private readonly string _content;
    private readonly int _cursorPosition;
    private readonly DateTime _savedAt;

    public EditorMemento(string content, int cursorPosition)
    {
        _content = content;
        _cursorPosition = cursorPosition;
        _savedAt = DateTime.Now;
    }

    public string GetContent()
    {
        return _content;
    }

    public int GetCursorPosition()
    {
        return _cursorPosition;
    }

    public string GetLabel()
    {
        return $"Saved at {_savedAt:HH:mm:ss}, length = {_content.Length}";
    }
}

public class TextEditor
{
    private string _content = "";
    private int _cursorPosition = 0;

    public void Type(string text)
    {
        _content = _content.Insert(_cursorPosition, text);
        _cursorPosition += text.Length;
    }

    public void MoveCursor(int position)
    {
        if (position < 0 || position > _content.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(position));
        }

        _cursorPosition = position;
    }

    public EditorMemento CreateSnapshot()
    {
        return new EditorMemento(_content, _cursorPosition);
    }

    public void Restore(EditorMemento memento)
    {
        _content = memento.GetContent();
        _cursorPosition = memento.GetCursorPosition();
    }

    public void Show()
    {
        Console.WriteLine($"Content: '{_content}' | Cursor: {_cursorPosition}");
    }
}

public class EditorHistory
{
    private readonly Stack<EditorMemento> _undoStack = new();

    public void Save(TextEditor editor)
    {
        _undoStack.Push(editor.CreateSnapshot());
    }

    public void Undo(TextEditor editor)
    {
        if (_undoStack.Count == 0)
        {
            Console.WriteLine("Nothing to undo.");
            return;
        }

        EditorMemento snapshot = _undoStack.Pop();
        editor.Restore(snapshot);
        Console.WriteLine($"Restored: {snapshot.GetLabel()}");
    }
}

public class Program
{
    public static void Main()
    {
        TextEditor editor = new TextEditor();
        EditorHistory history = new EditorHistory();

        history.Save(editor);
        editor.Type("Hello");
        editor.Show();

        history.Save(editor);
        editor.Type(" World");
        editor.Show();

        history.Save(editor);
        editor.MoveCursor(5);
        editor.Type(", C#");
        editor.Show();

        history.Undo(editor);
        editor.Show();

        history.Undo(editor);
        editor.Show();
    }
}
```

Kết quả kỳ vọng:

```text
Content: 'Hello' | Cursor: 5
Content: 'Hello World' | Cursor: 11
Content: 'Hello, C# World' | Cursor: 9
Restored: Saved at ..., length = 11
Content: 'Hello World' | Cursor: 11
Restored: Saved at ..., length = 5
Content: 'Hello' | Cursor: 5
```

Trong ví dụ này:

- `TextEditor` không để lộ trực tiếp field `_content` và `_cursorPosition` cho client chỉnh sửa tùy tiện.
- `EditorMemento` lưu snapshot của editor.
- `EditorHistory` chỉ quản lý các snapshot trong stack, không xử lý logic nội bộ của editor.



#figure(
  image("diagrams/memento-code-flow.svg", width: 100%),
  caption: [Luồng chạy code ví dụ TextEditor undo],
)

== Biến thể Undo/Redo

Để hỗ trợ cả undo và redo, có thể dùng hai stack:

- `undoStack`: lưu các trạng thái trước đó.
- `redoStack`: lưu các trạng thái bị undo để có thể redo lại.

Ý tưởng:

- Trước khi thay đổi, lưu snapshot vào `undoStack`.
- Khi undo, trạng thái hiện tại được đưa vào `redoStack`, sau đó restore snapshot từ `undoStack`.
- Khi redo, trạng thái hiện tại được đưa lại vào `undoStack`, sau đó restore snapshot từ `redoStack`.
- Khi người dùng thực hiện thay đổi mới sau undo, `redoStack` thường bị xóa vì nhánh lịch sử cũ không còn phù hợp.

Memento giúp làm undo/redo đơn giản hơn khi trạng thái object tương đối nhỏ và có thể snapshot trực tiếp.

== Đánh giá

=== Ưu điểm

#table(
  columns: (1.4fr, 3.6fr),
  inset: 8pt,
  align: left,
  [*Ưu điểm*], [*Giải thích*],
  [Bảo vệ encapsulation],
  [Client không cần biết toàn bộ state nội bộ của Originator. Việc save/restore do Originator tự kiểm soát.],

  [Dễ xây dựng undo/redo],
  [Mỗi snapshot đại diện cho một trạng thái trước đó, rất phù hợp với undo trong editor, drawing tool hoặc form.],

  [Tách logic lưu state],
  [Caretaker quản lý lịch sử, Originator quản lý state thật. Mỗi thành phần có trách nhiệm rõ ràng.],

  [Dễ rollback], [Có thể lưu trạng thái trước thao tác rủi ro và khôi phục nếu thao tác thất bại.],
  [Không làm phức tạp client], [Client chỉ cần gọi save/undo, không phải tự copy từng field của object.],
)

=== Nhược điểm

#table(
  columns: (1.4fr, 3.6fr),
  inset: 8pt,
  align: left,
  [*Nhược điểm*], [*Giải thích*],
  [Tốn bộ nhớ],
  [Nếu object lớn hoặc lưu snapshot quá thường xuyên, lịch sử memento có thể tiêu tốn nhiều RAM hoặc storage.],

  [Deep copy phức tạp],
  [Nếu state chứa nhiều object lồng nhau, collection hoặc reference phức tạp, việc snapshot đúng có thể khó.],

  [Khó quản lý nhiều phiên bản], [Cần cơ chế giới hạn số lượng snapshot, đặt tên checkpoint hoặc xóa lịch sử cũ.],
  [Có thể che giấu chi phí],
  [Nhìn bên ngoài thao tác save rất đơn giản, nhưng bên trong có thể copy lượng dữ liệu lớn.],

  [Không phù hợp với state thay đổi liên tục],
  [Nếu state thay đổi từng mili-giây và mỗi lần đều snapshot, hệ thống dễ bị overhead lớn.],
)

== Khi nào nên dùng?

Nên dùng Memento khi:

- Cần chức năng undo/redo.
- Cần rollback khi thao tác thất bại.
- Cần lưu checkpoint hoặc save slot.
- Cần snapshot state ở một thời điểm cụ thể.
- Muốn lưu trạng thái mà vẫn giữ encapsulation.
- State của object đủ nhỏ hoặc có thể snapshot với chi phí chấp nhận được.

Ví dụ phù hợp:

- Text editor.
- Drawing application.
- Game save/checkpoint.
- Form wizard nhiều bước.
- Cấu hình hệ thống trước khi apply thay đổi.
- Transaction nghiệp vụ cần rollback ở mức object.

== Khi nào không nên dùng?

Không nên dùng Memento khi:

- State quá lớn và snapshot toàn bộ sẽ rất tốn bộ nhớ.
- State thay đổi liên tục với tần suất cao.
- Chi phí deep copy quá lớn.
- Chỉ cần lưu một vài field đơn giản, không cần pattern đầy đủ.
- Có thể rollback tốt hơn bằng log action hoặc event sourcing.
- Cần audit chi tiết từng thao tác hơn là chỉ lưu trạng thái cuối.

Trong các trường hợp state lớn, có thể cân nhắc:

- Lưu diff thay vì lưu full snapshot.
- Giới hạn số lượng snapshot.
- Nén snapshot.
- Lưu snapshot xuống disk/database.
- Kết hợp với Command Pattern để undo bằng hành động ngược.

== So sánh với Command Pattern

#table(
  columns: (1.3fr, 2.4fr, 2.4fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Memento*], [*Command*],
  [Mục đích chính], [Lưu trạng thái để khôi phục lại sau.], [Đóng gói hành động thành object.],
  [Undo bằng gì?], [Undo bằng snapshot state cũ.], [Undo bằng `Unexecute()` hoặc hành động ngược.],
  [Dữ liệu lưu], [State của object tại một thời điểm.], [Thông tin về thao tác đã thực hiện.],
  [Mức độ đơn giản], [Dễ hiểu nếu state nhỏ.], [Linh hoạt hơn nhưng cần thiết kế action rõ.],
  [Chi phí], [Tốn bộ nhớ nếu snapshot lớn.], [Tốn logic vì phải viết thao tác đảo ngược.],
  [Phù hợp khi], [Object state nhỏ, cần quay lại snapshot.], [Action phức tạp, cần queue/log/macro/redo.],
)

Ví dụ:

- Memento: lưu toàn bộ nội dung editor trước khi sửa.
- Command: lưu thao tác `InsertTextCommand`, khi undo thì xóa đoạn text vừa insert.

== So sánh với State Pattern

#table(
  columns: (1.3fr, 2.4fr, 2.4fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Memento*], [*State*],
  [Mục đích chính], [Lưu và khôi phục trạng thái quá khứ.], [Thay đổi hành vi của object theo trạng thái hiện tại.],
  [Trọng tâm], [Temporal history: lịch sử theo thời gian.], [Runtime behavior: hành vi tại thời điểm hiện tại.],
  [State được dùng để làm gì?], [Để restore lại object.], [Để quyết định object phản ứng như thế nào.],
  [Có lưu lịch sử không?], [Có, thường lưu nhiều snapshot.], [Không bắt buộc, thường chỉ giữ state hiện tại.],
  [Ví dụ], [Undo nội dung editor về bản trước.], [Order thay đổi behavior theo Pending/Paid/Shipped/Cancelled.],
)

Memento trả lời câu hỏi: *object trước đây như thế nào?*

State trả lời câu hỏi: *object hiện tại nên hành xử như thế nào theo trạng thái của nó?*

== So sánh với Prototype Pattern

#table(
  columns: (1.3fr, 2.4fr, 2.4fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Memento*], [*Prototype*],
  [Mục đích chính], [Lưu snapshot để restore state.], [Clone object để tạo object mới nhanh hơn.],
  [Kết quả tạo ra], [Memento đại diện cho trạng thái cũ.], [Object mới có cấu trúc giống object mẫu.],
  [Ai dùng object tạo ra?], [Originator dùng để restore.], [Client dùng object clone như một object bình thường.],
  [Có bảo vệ encapsulation không?], [Có, đây là mục tiêu quan trọng.], [Không phải trọng tâm chính.],
  [Ví dụ], [Lưu trạng thái editor trước khi sửa.], [Clone một enemy mẫu thành enemy mới trong game.],
)

Hai pattern đều có thể liên quan đến việc copy dữ liệu, nhưng mục đích khác nhau. Memento copy state để quay lại quá khứ; Prototype copy object để tạo instance mới.

== So sánh với Event Sourcing

#table(
  columns: (1.3fr, 2.4fr, 2.4fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Memento*], [*Event Sourcing*],
  [Cách lưu], [Lưu snapshot trạng thái tại một thời điểm.], [Lưu chuỗi event đã xảy ra.],
  [Khôi phục], [Restore trực tiếp từ snapshot.], [Replay event để dựng lại state.],
  [Audit trail], [Không thể hiện rõ từng hành động nếu chỉ lưu snapshot.], [Rất tốt vì lưu đầy đủ lịch sử event.],
  [Chi phí đọc], [Nhanh nếu snapshot đầy đủ.], [Có thể cần replay nhiều event, thường kết hợp snapshot.],
  [Phù hợp khi], [Cần undo/rollback đơn giản.], [Cần audit, trace nghiệp vụ và lịch sử thay đổi chi tiết.],
)

Trong thực tế, Event Sourcing đôi khi kết hợp với snapshot để tránh replay toàn bộ event từ đầu. Snapshot trong trường hợp đó có ý tưởng gần với Memento, nhưng Event Sourcing là một kiến trúc/lối lưu dữ liệu rộng hơn.

== Lưu ý thiết kế

Khi áp dụng Memento, cần chú ý:

- Không nên để `Caretaker` sửa nội dung bên trong `Memento`.
- Nên giới hạn số lượng snapshot để tránh tốn bộ nhớ.
- Với object lớn, cân nhắc lưu diff hoặc chỉ lưu phần thay đổi.
- Với object có reference phức tạp, cần phân biệt shallow copy và deep copy.
- Snapshot nên immutable để tránh bị thay đổi sau khi đã lưu.
- Nếu có nhiều loại state, nên đặt tên snapshot hoặc gắn timestamp để dễ quản lý.

== Kết luận

Memento Pattern là giải pháp phù hợp khi hệ thống cần lưu và khôi phục trạng thái object mà vẫn bảo vệ tính đóng gói. Pattern này đặc biệt hữu ích cho undo/redo, checkpoint, rollback và snapshot.

Điểm mạnh lớn nhất của Memento là giúp object tự kiểm soát việc lưu và restore state của chính nó, trong khi `Caretaker` chỉ quản lý lịch sử snapshot. Nhờ vậy, client không cần biết chi tiết nội bộ của object.

Tuy nhiên, Memento có thể gây tốn bộ nhớ nếu state lớn hoặc snapshot quá thường xuyên. Vì vậy, khi sử dụng pattern này cần cân nhắc kích thước state, tần suất lưu, cơ chế xóa snapshot cũ và khả năng dùng diff hoặc Command Pattern thay thế.
