#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

== Tên và Phân loại

*Builder Pattern* là một mẫu thiết kế thuộc nhóm *Creational Pattern* (nhóm khởi tạo).

Mẫu này tập trung vào việc tách quá trình xây dựng đối tượng phức tạp ra khỏi biểu diễn cuối cùng của đối tượng đó. Thay vì gọi một constructor dài với nhiều tham số hoặc viết logic khởi tạo rải rác, Builder gom quy trình tạo object thành các bước rõ ràng, có thứ tự.

== Mục đích, ý định

Mục đích chính của Builder là xây dựng một đối tượng phức tạp từng bước một và cho phép tạo ra nhiều biến thể của đối tượng bằng cùng một quy trình.

Ý định của pattern:

- Tách phần "cách xây" khỏi "sản phẩm được tạo".
- Dễ kiểm soát thứ tự tạo các phần của object.
- Tránh constructor quá dài hoặc telescoping constructor.
- Tạo nhiều cấu hình sản phẩm khác nhau từ cùng một builder.

== Bí danh

Builder Pattern còn có thể được gọi là:

- *Mẫu xây dựng*.
- *Step-by-step object construction pattern*.

Trong một số framework, ý tưởng tương tự còn xuất hiện dưới tên *Fluent Builder* khi các bước build trả về chính builder để chain method.

== Motivation

Giả sử ta có một sản phẩm gồm nhiều thành phần tùy chọn: A, B, C.

Trong nhiều tình huống thực tế, ta cần:

- Bản tối thiểu chỉ có A.
- Bản đầy đủ có A + B + C.
- Bản tùy chỉnh có A + B.

Nếu không dùng Builder, logic tạo object dễ bị phân tán và lặp lại:

- Mỗi nơi tự quyết định add phần nào.
- Dễ quên thứ tự hoặc thiếu bước reset giữa hai lần tạo.
- Khó tái sử dụng quy trình tạo "chuẩn" cho nhiều sản phẩm.

Builder giải quyết bằng cách đóng gói quy trình tạo thành các bước (`addA`, `addB`, `addC`) và dùng `Director` để định nghĩa recipe (kịch bản build) cố định.

== Khả năng ứng dụng

Nên dùng Builder khi:

- Đối tượng có nhiều thuộc tính tùy chọn.
- Cần tạo nhiều biến thể từ cùng một họ sản phẩm.
- Quy trình tạo object gồm nhiều bước và cần kiểm soát thứ tự.
- Muốn tách code khởi tạo phức tạp khỏi business logic.
- Muốn tái sử dụng quy trình build "min", "max", "custom".

Ví dụ phù hợp:

- Tạo cấu hình request/response phức tạp.
- Tạo đối tượng UI (dialog, form, dashboard) theo nhiều preset.
- Tạo document/report có nhiều phần tùy chọn.
- Tạo object domain lớn (Order, Invoice, Profile) với nhiều dữ liệu tùy chọn.

== Cấu trúc

Builder Pattern thường gồm các vai trò:

- `Product`: đối tượng kết quả cần tạo.
- `Builder`: interface định nghĩa các bước tạo.
- `ConcreteBuilder`: cài đặt các bước cụ thể và giữ trạng thái sản phẩm đang tạo.
- `Director`: định nghĩa thứ tự các bước build cho từng biến thể.
- `Client`: chọn builder, gọi director hoặc tự build tay.

Sơ đồ lớp trong project có thể mô tả như sau:

```mermaid
classDiagram
		class Product1{
			+parts[] : String
			+report()
		}

		class Builder{
			<<interface>>
			+reset()
			+addA()
			+addB()
			+addC()
		}

		Builder <|-- ConcreteBuilder1
		Product1 <-- ConcreteBuilder1
		class ConcreteBuilder1{
			-product : Product1
			+ConcreteBuilder1()
			+reset()
			+addA()
			+addB()
			+addC()
			+getProd()
		}

		Builder <-- Director
		class Director {
			-builder : Builder
			+Director(builder)
			+build_min()
			+build_max()
		}
```

== Các thành viên

`Product1`

- Đại diện sản phẩm cuối cùng.
- Chứa `parts` để lưu các thành phần đã được lắp.
- Hàm `report()` dùng để hiển thị cấu trúc sản phẩm.

`Builder`

- Interface mô tả bộ bước tạo sản phẩm: `reset()`, `addA()`, `addB()`, `addC()`.
- Giúp `Director` làm việc qua abstraction thay vì phụ thuộc class cụ thể.

`ConcreteBuilder1`

- Cài đặt chi tiết các bước xây dựng.
- Nắm giữ sản phẩm hiện tại qua biến `product`.
- `getProd()` trả sản phẩm hiện tại và reset để sẵn sàng build sản phẩm mới.

`Director`

- Định nghĩa các kịch bản build tiêu chuẩn.
- `build_min()` tạo bản tối thiểu.
- `build_max()` tạo bản đầy đủ.

`Client`

- Tạo builder/director.
- Chọn kịch bản build hoặc tự gọi từng bước để build custom.

== Sự cộng tác

Luồng cộng tác tiêu biểu:

1. Client tạo `ConcreteBuilder1`.
2. Client truyền builder vào `Director`.
3. Client gọi một recipe như `build_min()` hoặc `build_max()`.
4. `Director` gọi tuần tự các bước trên builder.
5. Client gọi `getProd()` để nhận sản phẩm hoàn chỉnh.
6. Builder tự `reset()` để có thể build vòng tiếp theo.

Với nhu cầu đặc biệt, client có thể bỏ qua director và gọi trực tiếp:

```text
addA -> addB -> getProd
```

== Các hệ quả mang lại, Ưu nhược điểm

=== Ưu điểm

- Tách rõ quy trình tạo và biểu diễn sản phẩm.
- Giảm constructor quá dài và khó đọc.
- Dễ tạo nhiều cấu hình sản phẩm từ cùng mã build.
- Dễ mở rộng thêm builder mới cho loại sản phẩm mới.
- Dễ test từng bước build hoặc từng recipe.

=== Nhược điểm

- Tăng số lượng class (Builder, ConcreteBuilder, Director).
- Có thể hơi "nặng" với bài toán rất đơn giản.
- Cần quản lý trạng thái builder cẩn thận (đặc biệt chuyện reset).

== Chú ý liên quan đến việc cài đặt

- Nên quy định rõ khi nào builder reset (tại `getProd()` hay do client gọi).
- Tránh để client đọc trạng thái trung gian không hợp lệ.
- Nếu sản phẩm immutable, có thể tạo object mới ở cuối quá trình build.
- Có thể kết hợp fluent API để code ngắn gọn hơn:

```text
builder.addA().addB().addC().build()
```

- Với môi trường multi-thread, không nên dùng chung một builder mutable cho nhiều luồng.

== Một số so sánh nếu có

=== Builder và Abstract Factory

- Builder: tập trung *quy trình từng bước* để tạo một object phức tạp.
- Abstract Factory: tập trung *họ object liên quan* (family) và tạo chúng nhanh qua factory method.

=== Builder và Factory Method

- Factory Method trả về object thường trong một bước.
- Builder phù hợp khi object cần nhiều bước cấu hình trước khi hoàn chỉnh.

=== Builder và Prototype

- Prototype tạo object mới bằng cách clone object mẫu.
- Builder tạo object mới bằng quy trình lắp ghép từng phần.

== Mã nguồn minh họa

Đoạn code sau bám theo demo trong project Builder:

```javascript
function print(str) { console.log(str) }

class Product1 { parts = []; report() { print(this.parts) } }

class Builder { reset() { }; addA() { }; addB() { }; addC() { } }

class ConcreteBuilder1 extends Builder {
		product; constructor() { super(); this.reset() };

		reset() { this.product = new Product1() }
		addA() { this.product.parts.push('PartA1') }
		addB() { this.product.parts.push('PartB1') }
		addC() { this.product.parts.push('PartC1') }

		getProd() { const result = this.product; this.reset(); return result }
}

class Director {
		builder; constructor(builder) { this.builder = builder }

		build_min() { this.builder.addA() }
		build_max() { this.builder.addA(); this.builder.addB(); this.builder.addC() }
}

const bld = new ConcreteBuilder1();
const drc = new Director(bld);

print('Standard basic product:'); drc.build_min()
bld.getProd().report()

print('Standard full featured product:'); drc.build_max()
bld.getProd().report()

print('Custom product:'); bld.addA(); bld.addB()
bld.getProd().report()
```

Kết quả thể hiện rõ ba kiểu tạo:

- Basic product.
- Full featured product.
- Custom product.

== Ví dụ về các hệ thống thực tế

- SQL/HTTP query builder trong backend framework.
- UI builder (tạo cây component theo cấu hình).
- Document/report builder (PDF, HTML, DOCX).
- Test data builder (tạo object mẫu cho unit test).
- Cloud infrastructure builder (tạo cấu hình tài nguyên theo từng bước).

== Các mẫu liên quan

- *Abstract Factory*: có thể phối hợp để tạo builder tương ứng từng họ sản phẩm.
- *Factory Method*: thường dùng bên trong Builder để tạo từng thành phần con.
- *Prototype*: có thể clone sản phẩm nền rồi tiếp tục build thêm bước mới.
- *Composite*: sản phẩm do Builder tạo ra thường có cấu trúc cây (tree object).

Tóm lại, Builder là lựa chọn tốt khi đối tượng có nhiều bước tạo và nhiều biến thể cấu hình, giúp code rõ ràng, mở rộng tốt và giảm lỗi khi khởi tạo đối tượng phức tạp.

== Phân tích sâu quy trình xây dựng

Trong Builder Pattern, điểm quan trọng không chỉ là có các hàm `addA`, `addB`, `addC`, mà còn là quản lý *vòng đời của builder*.

Một vòng đời chuẩn thường gồm ba pha:

1. *Khởi tạo trạng thái build* (`reset`).
2. *Lắp ráp từng phần* (`addX`).
3. *Hoàn tất và trả sản phẩm* (`getProd`/`build`).

Nếu bỏ qua pha reset hoặc không định nghĩa rõ thời điểm reset, sản phẩm sau có thể bị "dính" dữ liệu từ sản phẩm trước.

=== Trạng thái nội bộ của Builder

Builder thường chứa state mutable, ví dụ:

- Danh sách parts đã thêm.
- Các flag kiểm soát bước bắt buộc/không bắt buộc.
- Bộ validate tạm thời trước khi xuất sản phẩm.

Trong ví dụ hiện tại, `ConcreteBuilder1` lưu state qua biến `product`. Cách này đơn giản, dễ hiểu, nhưng cần chú ý:

- Không tái sử dụng cùng builder trong nhiều luồng cùng lúc.
- Không để client giữ reference vào `product` trung gian.
- Nên có quy ước reset nhất quán sau khi trả sản phẩm.

=== Vai trò của Director trong hệ thống lớn

Ở ví dụ nhỏ, Director có vẻ dư thừa vì client tự gọi builder được. Tuy nhiên trong hệ thống lớn, Director giúp:

- Đóng gói recipe chuẩn của domain.
- Giảm duplicated code trong nhiều service.
- Đảm bảo mọi sản phẩm "chuẩn" luôn qua cùng quy trình.

Ví dụ domain e-commerce:

- `build_default_checkout()`
- `build_guest_checkout()`
- `build_express_checkout()`

Mỗi recipe tương ứng một quy tắc nghiệp vụ rõ ràng.

== Biến thể triển khai nâng cao

Builder không chỉ có một kiểu cổ điển. Có nhiều biến thể phù hợp từng loại bài toán.

=== Fluent Builder

Đặc trưng:

- Mỗi bước trả về `this`.
- Dễ đọc khi chain method.

Ví dụ:

```javascript
const product = builder
	.addA()
	.addB()
	.addC()
	.build();
```

Ưu điểm: code ngắn, trực quan.

Lưu ý: vẫn phải xử lý validate và reset rõ ràng trong `build()`.

=== Immutable Builder

Đặc trưng:

- Mỗi lần gọi `addX()` trả về builder mới thay vì sửa builder cũ.
- Tránh side-effect.

Phù hợp với môi trường cần an toàn cao hoặc code theo phong cách functional.

Đánh đổi: tốn thêm bộ nhớ do tạo nhiều object trung gian.

=== Step Builder

Đặc trưng:

- Ép thứ tự build ở mức type/interface.
- Không cho phép gọi `build()` nếu thiếu bước bắt buộc.

Ví dụ ý tưởng:

```text
StartStep -> RequiredStepA -> RequiredStepB -> OptionalStep -> BuildStep
```

Phù hợp khi domain có nhiều ràng buộc cứng, ví dụ hồ sơ pháp lý, giao dịch tài chính.

=== Builder không có Director

Trong nhiều codebase hiện đại, Director bị lược bỏ để giảm lớp trung gian.

Client hoặc service layer sẽ đóng vai trò điều phối recipe. Cách này ổn khi:

- Số recipe ít.
- Quy trình tạo đơn giản.
- Team ưu tiên ít abstraction.

Ngược lại, nếu recipe tăng mạnh, Director hoặc orchestration class sẽ hữu ích hơn.

== Pseudocode tổng quát

```text
interface Builder {
	reset()
	buildPartA()
	buildPartB()
	buildPartC()
	getResult()
}

class ConcreteBuilder implements Builder {
	product

	reset()        -> create new Product
	buildPartA()   -> add A
	buildPartB()   -> add B
	buildPartC()   -> add C
	getResult()    -> return product and reset
}

class Director {
	builder

	makeMinimal()  -> A
	makeFull()     -> A, B, C
}

client:
	b = ConcreteBuilder()
	d = Director(b)
	d.makeFull()
	p = b.getResult()
```

== Sequence minh họa chi tiết

```mermaid
sequenceDiagram
	actor Client
	participant Director
	participant ConcreteBuilder
	participant Product

	Client->>Director: build_max()
	Director->>ConcreteBuilder: addA()
	Director->>ConcreteBuilder: addB()
	Director->>ConcreteBuilder: addC()

	Client->>ConcreteBuilder: getProd()
	ConcreteBuilder-->>Client: Product
	ConcreteBuilder->>ConcreteBuilder: reset()
```

Điểm mấu chốt trong sequence trên là builder tự reset sau khi trả product, đảm bảo build tiếp theo không lẫn state cũ.

== Chiến lược kiểm thử cho Builder

Với Builder, testing nên chia theo ba lớp:

=== Unit test cho ConcreteBuilder

Mục tiêu:

- Mỗi hàm `addX()` thêm đúng part.
- `getProd()` trả đúng kết quả.
- `reset()` thực sự tạo trạng thái mới.

Ví dụ kịch bản:

- `addA()` rồi `getProd()` -> chỉ có `PartA1`.
- `addA()`, `addB()`, `addC()` -> đúng thứ tự parts.
- `getProd()` hai lần liên tiếp -> lần hai là sản phẩm rỗng (nếu chưa add gì).

=== Unit test cho Director

Có thể dùng mock builder để kiểm tra thứ tự gọi hàm:

- `build_min()` chỉ gọi `addA()`.
- `build_max()` gọi `addA()`, `addB()`, `addC()` đúng thứ tự.

=== Integration test

Kết hợp `Director + ConcreteBuilder + Product` để đảm bảo recipe cho ra output đúng nghiệp vụ.

== Lỗi thường gặp và cách tránh

=== Quên reset builder

Triệu chứng:

- Sản phẩm mới chứa dữ liệu của sản phẩm trước.

Cách tránh:

- Reset ngay trong `getProd()` hoặc bắt buộc client gọi `reset()` theo contract rõ ràng.

=== Builder bị lộ trạng thái nội bộ

Triệu chứng:

- Client chỉnh sửa trực tiếp `product.parts` trong lúc builder đang build.

Cách tránh:

- Giữ encapsulation, không expose state mutable giữa quá trình build.

=== Dùng chung builder cho nhiều thread

Triệu chứng:

- Kết quả ngẫu nhiên, part thiếu/thừa do race condition.

Cách tránh:

- Mỗi request một builder instance.
- Hoặc dùng immutable builder nếu cần share logic.

=== Lạm dụng Builder cho object quá đơn giản

Triệu chứng:

- Tăng số lớp không cần thiết.

Cách tránh:

- Nếu object có 2-3 field đơn giản, constructor/factory có thể đủ tốt.

== Hiệu năng và đánh đổi thiết kế

Builder thêm một số overhead:

- Thêm call method cho từng bước.
- Thêm object trung gian (builder/director).

Tuy nhiên trong đa số ứng dụng business, overhead này rất nhỏ so với lợi ích về:

- Khả năng bảo trì.
- Tính rõ ràng.
- Giảm lỗi khởi tạo.

Nếu bài toán nhạy hiệu năng, có thể benchmark giữa:

- Constructor/factory trực tiếp.
- Builder cổ điển.
- Fluent/immutable builder.

== Ví dụ mở rộng: HTTP Request Builder

Builder rất phù hợp cho request có nhiều phần tùy chọn như method, headers, query, body, timeout.

```javascript
class HttpRequest {
	constructor({ method, url, headers, query, body, timeout }) {
		this.method = method;
		this.url = url;
		this.headers = headers;
		this.query = query;
		this.body = body;
		this.timeout = timeout;
	}
}

class HttpRequestBuilder {
	constructor() { this.reset(); }

	reset() {
		this.method = "GET";
		this.url = "";
		this.headers = {};
		this.query = {};
		this.body = null;
		this.timeout = 5000;
		return this;
	}

	setMethod(m) { this.method = m; return this; }
	setUrl(u) { this.url = u; return this; }
	addHeader(k, v) { this.headers[k] = v; return this; }
	addQuery(k, v) { this.query[k] = v; return this; }
	setBody(b) { this.body = b; return this; }
	setTimeout(ms) { this.timeout = ms; return this; }

	build() {
		if (!this.url) throw new Error("URL is required");
		const req = new HttpRequest({
			method: this.method,
			url: this.url,
			headers: this.headers,
			query: this.query,
			body: this.body,
			timeout: this.timeout,
		});
		this.reset();
		return req;
	}
}
```

Ưu điểm của ví dụ trên là có thể thêm option mới mà không phá vỡ client code cũ.

== Checklist áp dụng nhanh

Trước khi chọn Builder, có thể tự hỏi:

- Object có nhiều thuộc tính tùy chọn không?
- Có nhiều biến thể sản phẩm từ cùng quy trình không?
- Constructor hiện tại có khó đọc hoặc dễ nhầm thứ tự tham số không?
- Có cần đóng gói recipe chuẩn cho nhiều use case không?
- Team có chấp nhận thêm abstraction để đổi lấy maintainability không?

Nếu phần lớn câu trả lời là "có", Builder thường là lựa chọn hợp lý.

== Câu hỏi thường gặp

=== Builder có bắt buộc phải có Director không?

Không bắt buộc. Director hữu ích khi có nhiều recipe chuẩn hoặc muốn tách hẳn orchestration khỏi client.

=== Khi nào nên reset trong `build()`/`getProd()`?

Nên reset ngay sau khi trả kết quả nếu builder được tái sử dụng nhiều lần trong cùng vòng đời object.

=== Có thể dùng Builder với object immutable không?

Có. Đây là trường hợp phổ biến. Builder giữ state mutable tạm thời, sau đó tạo ra immutable product tại `build()`.

=== Builder có thay thế hoàn toàn Factory Method không?

Không. Hai pattern phục vụ nhu cầu khác nhau. Builder mạnh ở khởi tạo nhiều bước; Factory Method mạnh ở việc chọn loại object để tạo.

== Kết luận mở rộng

Builder không chỉ là "một cách viết constructor đẹp hơn". Điểm giá trị thực sự nằm ở kiến trúc:

- Chuẩn hóa quy trình khởi tạo phức tạp.
- Giảm coupling giữa quá trình build và logic sử dụng.
- Tăng khả năng mở rộng khi domain phát triển.

Trong project hiện tại, demo `Product1 + ConcreteBuilder1 + Director` đã thể hiện đúng tinh thần cốt lõi của Builder. Khi mở rộng hệ thống, bạn có thể thêm:

- Nhiều ConcreteBuilder cho nhiều loại sản phẩm.
- Director recipes theo từng ngữ cảnh nghiệp vụ.
- Fluent API và validate rule để tăng an toàn khi build.

Nhờ vậy, code khởi tạo sẽ rõ ràng, nhất quán và bền vững hơn theo thời gian.
