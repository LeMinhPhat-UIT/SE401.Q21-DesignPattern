#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)


== Tên và Phân loại

*Iterator Pattern* là một mẫu thiết kế thuộc nhóm *Behavioral Pattern* (nhóm hành vi).

Mẫu này cung cấp cách duyệt tuần tự các phần tử trong một tập hợp mà không cần để lộ cấu trúc bên trong của tập hợp đó.

== Mục đích, ý định

Mục đích chính của Iterator là tách logic duyệt dữ liệu ra khỏi đối tượng lưu trữ dữ liệu.

Ý định của pattern:

- Cho phép truy cập tuần tự các phần tử trong collection.
- Ẩn biểu diễn nội bộ của cấu trúc dữ liệu (array, list, tree, graph...).
- Cung cấp một giao diện duyệt thống nhất cho nhiều kiểu tập hợp khác nhau.
- Cho phép có nhiều cách duyệt trên cùng một collection (ví dụ: xuôi, ngược, lọc theo điều kiện).

== Bí danh

Iterator Pattern còn được gọi với các tên:

- *Cursor*.
- *Con trỏ duyệt*.
- Trong một số ngữ cảnh: *Enumerator* (đặc biệt trong .NET).

== Motivation

Giả sử ta có một lớp quản lý danh sách từ (`WordsCollection`) và cần duyệt dữ liệu theo nhiều cách:

- Duyệt từ đầu đến cuối.
- Duyệt từ cuối về đầu.

Nếu nhúng trực tiếp mọi vòng lặp vào `WordsCollection`, lớp này sẽ phải gánh quá nhiều trách nhiệm:

- Vừa quản lý dữ liệu, vừa quản lý chi tiết duyệt.
- Mỗi kiểu duyệt mới lại sửa class hiện có.
- Client phải biết nội bộ collection được lưu như thế nào.

Iterator giải quyết bằng cách tách phần duyệt thành các object riêng (`AlphabeticalOrderIterator`). Khi đó client chỉ làm việc với các hàm như `next()`, `valid()`, `current()`, không cần quan tâm collection lưu trữ dữ liệu ra sao.

== Khả năng ứng dụng

Nên dùng Iterator khi:

- Cần duyệt một collection phức tạp nhưng muốn ẩn cấu trúc dữ liệu bên trong.
- Muốn hỗ trợ nhiều cách duyệt cho cùng một dữ liệu.
- Muốn thống nhất API duyệt giữa nhiều collection khác nhau.
- Muốn giảm coupling giữa client và collection.

Ví dụ phù hợp:

- Duyệt danh sách bản ghi trong ứng dụng quản lý.
- Duyệt node trong cây giao diện.
- Duyệt kết quả truy vấn theo trang (paging).
- Duyệt dữ liệu stream hoặc pipeline theo từng bước.

== Cấu trúc

Iterator Pattern thường gồm các vai trò chính:

- `Iterator`: interface định nghĩa các thao tác duyệt (`current`, `next`, `valid`, `rewind`).
- `ConcreteIterator`: cài đặt cách duyệt cụ thể và giữ trạng thái vị trí hiện tại.
- `Aggregator` (hoặc `Iterable`): interface khai báo phương thức tạo iterator.
- `ConcreteAggregator`: collection cụ thể, cung cấp iterator tương ứng.
- `Client`: sử dụng iterator để duyệt dữ liệu.

Sơ đồ lớp tương ứng với demo trong project:

```mermaid
classDiagram
		class Iterator {
				<<interface>>
				+current() Object
				+next() Object
				+key() Number
				+valid() boolean
				+rewind() void
		}

		class AlphabeticalOrderIterator {
				-collection WordsCollection
				-position Number
				-reverse boolean
				+current() string
				+next() string
				+key() Number
				+valid() boolean
				+rewind() void
		}

		class Aggregator {
				<<interface>>
				+getIterator() Iterator
		}

		class WordsCollection {
				-items string[]
				+addItem(item)
				+getItems() string[]
				+getCount() Number
				+getIterator() Iterator
				+getReverseIterator() Iterator
		}

		Iterator <|.. AlphabeticalOrderIterator
		Aggregator <|.. WordsCollection
		WordsCollection --> AlphabeticalOrderIterator : creates
		AlphabeticalOrderIterator --> WordsCollection : traverses
```

== Các thành viên

`Iterator`

- Định nghĩa giao diện duyệt thống nhất.
- Tách client khỏi cài đặt duyệt cụ thể.

`AlphabeticalOrderIterator`

- Là concrete iterator trong ví dụ.
- Giữ tham chiếu đến `WordsCollection`.
- Quản lý vị trí hiện tại bằng `position`.
- Hỗ trợ duyệt xuôi hoặc ngược thông qua cờ `reverse`.

`Aggregator`

- Giao diện collection có thể tạo iterator.

`WordsCollection`

- Lưu dữ liệu gốc trong `items`.
- Cung cấp `getIterator()` để duyệt xuôi.
- Cung cấp `getReverseIterator()` để duyệt ngược.

`Client`

- Thêm dữ liệu vào collection.
- Lấy iterator phù hợp và duyệt bằng cùng một API.

== Sự cộng tác

Luồng cộng tác điển hình:

1. Client tạo `WordsCollection` và thêm các phần tử.
2. Client gọi `getIterator()` hoặc `getReverseIterator()`.
3. `WordsCollection` tạo `AlphabeticalOrderIterator` tương ứng.
4. Client lặp theo mẫu `while (iterator.valid()) { iterator.next(); }`.
5. Iterator truy cập dữ liệu từ collection và tự cập nhật trạng thái vị trí.

Điểm quan trọng là client không cần truy cập trực tiếp `items` hay biết collection được cài đặt bằng kiểu dữ liệu nào.

== Các hệ quả mang lại, Ưu nhược điểm

=== Ưu điểm

- Tuân thủ nguyên tắc trách nhiệm đơn (SRP): tách lưu trữ và duyệt.
- Tuân thủ nguyên tắc đóng/mở (OCP): thêm kiểu duyệt mới mà không phá code cũ.
- Giảm coupling giữa client và collection.
- Có thể tồn tại nhiều iterator đồng thời trên cùng một dữ liệu.
- Cải thiện khả năng kiểm thử phần duyệt độc lập.

=== Nhược điểm

- Tăng số lượng class/interface với hệ thống nhỏ.
- Có thêm overhead quản lý object iterator.
- Với collection đơn giản, dùng Iterator có thể bị xem là over-engineering.
- Cần lưu ý khi collection bị thay đổi trong lúc đang duyệt.

== Chú ý liên quan đến việc cài đặt

- Xác định rõ iterator làm việc theo snapshot hay theo dữ liệu "live".
- Quy ước rõ hành vi của `next()` khi hết phần tử.
- Tránh để client phụ thuộc vào index nội bộ của collection.
- Với dữ liệu lớn hoặc stream, cân nhắc lazy iteration để tiết kiệm bộ nhớ.
- Nếu có đa luồng, cần chính sách đồng bộ khi collection có thể bị sửa trong lúc duyệt.

== Một số so sánh nếu có

=== Iterator và Visitor

- Iterator tập trung vào *cách duyệt* cấu trúc dữ liệu.
- Visitor tập trung vào *thao tác áp dụng* lên từng phần tử của cấu trúc.

=== Iterator và Composite

- Composite tổ chức dữ liệu theo cây phần-whole.
- Iterator thường được dùng để duyệt các node trong Composite mà không để lộ cấu trúc nội bộ.

=== Iterator và for/foreach trực tiếp

- `for/foreach` tiện cho trường hợp đơn giản.
- Iterator hữu ích hơn khi cần nhiều chiến lược duyệt hoặc cần che giấu cấu trúc dữ liệu phức tạp.

== Mã nguồn minh họa

Đoạn mã sau sử dụng đúng ví dụ trong project:

```javascript
function print(str) { console.log(str) }

class AlphabeticalOrderIterator {
	constructor(collection, reverse = false) {
		this.collection = collection;
		this.reverse = reverse;
		this.position = reverse ? collection.getCount() - 1 : 0;
	}

	rewind() {
		this.position = this.reverse ? this.collection.getCount() - 1 : 0;
	}

	current() {
		return this.collection.getItems()[this.position];
	}

	key() {
		return this.position;
	}

	next() {
		const item = this.collection.getItems()[this.position];
		this.position += this.reverse ? -1 : 1;
		return item;
	}

	valid() {
		return this.reverse
			? this.position >= 0
			: this.position < this.collection.getCount();
	}
}

class WordsCollection {
	constructor() {
		this.items = [];
	}

	getItems() {
		return this.items;
	}

	getCount() {
		return this.items.length;
	}

	addItem(item) {
		this.items.push(item);
	}

	getIterator() {
		return new AlphabeticalOrderIterator(this);
	}

	getReverseIterator() {
		return new AlphabeticalOrderIterator(this, true);
	}
}

const collection = new WordsCollection();
collection.addItem('First');
collection.addItem('Second');
collection.addItem('Third');

const iterator = collection.getIterator();
print('Straight traversal:');
while (iterator.valid()) {
	print(iterator.next());
}

print('');
print('Reverse traversal:');
const reverseIterator = collection.getReverseIterator();
while (reverseIterator.valid()) {
	print(reverseIterator.next());
}
```

Kết quả mong đợi:

```text
Straight traversal:
First
Second
Third

Reverse traversal:
Third
Second
First
```

== Ví dụ về các hệ thống thực tế

- Java Collections Framework: `Iterator`, `ListIterator`.
- .NET Collections: `IEnumerable` và `IEnumerator`.
- Python: giao thức iterator (`__iter__`, `__next__`).
- C++ STL: input/forward/bidirectional/random-access iterator.
- ORM frameworks: duyệt tập kết quả truy vấn theo cursor/iterator.

== Các mẫu liên quan

- *Composite*: thường kết hợp với Iterator để duyệt cây đối tượng.
- *Factory Method*: có thể dùng để tạo iterator phù hợp cho từng loại collection.
- *Memento*: có thể kết hợp để lưu và phục hồi trạng thái vị trí duyệt.
- *Visitor*: Iterator cung cấp đường đi qua cấu trúc, Visitor định nghĩa thao tác trên từng phần tử.
