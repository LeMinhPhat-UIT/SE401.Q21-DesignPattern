#set heading(level: 3)

== Tên và phân loại

*Flyweight Pattern* có thể hiểu là *mẫu hạng ruồi* hoặc *mẫu đối tượng nhẹ*. Tên gọi này nhấn mạnh mục tiêu chính của pattern: làm cho hệ thống sử dụng các object nhẹ hơn bằng cách chia sẻ những dữ liệu giống nhau giữa nhiều object.

Flyweight thuộc nhóm *Structural Pattern* vì nó tập trung vào cách tổ chức cấu trúc object để giảm chi phí bộ nhớ. Pattern này không thay đổi trực tiếp thuật toán nghiệp vụ, mà thay đổi cách lưu trữ và chia sẻ trạng thái giữa các object.

Nói ngắn gọn, Flyweight là pattern dùng để *tái sử dụng các object chứa dữ liệu dùng chung* thay vì tạo ra nhiều object riêng biệt nhưng chứa dữ liệu lặp lại giống nhau.

== Vấn đề cần giải quyết

Trong một số hệ thống, ta cần tạo ra rất nhiều object giống nhau hoặc gần giống nhau. Nếu mỗi object đều lưu toàn bộ dữ liệu của riêng nó, kể cả những dữ liệu bị lặp lại, hệ thống sẽ tiêu tốn rất nhiều bộ nhớ.

Ví dụ:

- Game có hàng ngàn viên đạn, cây cối, quân lính hoặc particle effect.
- Trình soạn thảo văn bản có thể hiển thị hàng triệu ký tự.
- Bản đồ có rất nhiều icon như nhà hàng, cây xăng, khách sạn, trạm xe buýt.
- App giao hàng có thể hiển thị nhiều marker shipper, marker cửa hàng và marker đơn hàng trên bản đồ.
- Hệ thống vẽ đồ họa có rất nhiều hình tròn, hình vuông hoặc texture giống nhau.

Giả sử một game cần vẽ 100.000 cây trong rừng. Mỗi cây có các thông tin:

- Tọa độ `x`, `y`.
- Chiều cao hoặc kích thước.
- Loại cây: thông, sồi, anh đào.
- Màu sắc.
- Texture/hình ảnh.
- Dữ liệu mesh/model.

Trong đó, `x`, `y`, chiều cao có thể khác nhau theo từng cây. Nhưng `type`, `color`, `texture`, `mesh` của cùng một loại cây thường giống nhau. Nếu mỗi object `Tree` đều lưu lại toàn bộ texture/model, bộ nhớ sẽ bị lãng phí nghiêm trọng.

Vấn đề cốt lõi là: *làm sao biểu diễn số lượng lớn object mà không phải lưu lặp lại những phần dữ liệu giống nhau trong từng object?*

Flyweight Pattern giải quyết vấn đề này bằng cách tách dữ liệu thành hai phần:

- Dữ liệu dùng chung, được lưu trong object Flyweight.
- Dữ liệu riêng theo từng context, được lưu bên ngoài hoặc truyền vào khi xử lý.

== Mục đích và ý định

Mục đích chính của Flyweight là *giảm lượng bộ nhớ sử dụng khi hệ thống phải làm việc với số lượng lớn object có nhiều phần trạng thái giống nhau*.

Flyweight thường được dùng để:

- Giảm số lượng object nặng cần tạo ra.
- Chia sẻ dữ liệu giống nhau giữa nhiều context.
- Tăng hiệu quả khi xử lý số lượng lớn object.
- Tách rõ dữ liệu dùng chung và dữ liệu riêng.
- Tránh lưu lặp lại dữ liệu lớn như texture, font, icon, metadata, style hoặc configuration.

Flyweight không có nghĩa là toàn bộ object đều chỉ có một instance. Thay vào đó, hệ thống có thể có nhiều Flyweight, mỗi Flyweight đại diện cho một nhóm dữ liệu dùng chung.

Ví dụ trong bài toán rừng cây:

- `TreeType("Oak", "green", "oak.png")` là một Flyweight.
- 10.000 cây sồi khác nhau có thể cùng tham chiếu đến cùng một `TreeType`.
- Mỗi cây riêng chỉ cần lưu `x`, `y`, `height` và tham chiếu đến `TreeType`.

== Định nghĩa

*Flyweight Pattern* là một structural design pattern giúp giảm lượng bộ nhớ sử dụng bằng cách chia sẻ những phần trạng thái giống nhau giữa nhiều object, thay vì lưu trữ lặp lại trong từng object.

Định nghĩa ngắn gọn:

- `Flyweight` chứa phần dữ liệu có thể chia sẻ.
- `Context` chứa phần dữ liệu riêng của từng object.
- `FlyweightFactory` quản lý cache để tái sử dụng Flyweight đã tồn tại.
- `Client` yêu cầu Factory cung cấp Flyweight phù hợp và sử dụng nó trong từng context cụ thể.

Nói đơn giản, Flyweight biến câu hỏi:

```text
Mỗi object có cần giữ toàn bộ dữ liệu không?
```

thành:

```text
Phần nào giống nhau thì dùng chung, phần nào khác nhau thì lưu riêng.
```

== Ý tưởng cốt lõi

Ý tưởng chính của Flyweight Pattern là: *không lưu dữ liệu giống nhau trong từng object*. Thay vào đó, hãy lưu dữ liệu giống nhau vào một object dùng chung, còn dữ liệu riêng thì truyền từ bên ngoài hoặc lưu trong object context.

Pattern này dựa trên hai khái niệm quan trọng:

=== Intrinsic State

*Intrinsic state* là trạng thái bên trong, có thể dùng chung giữa nhiều object.

Đặc điểm:

- Không phụ thuộc vào từng context cụ thể.
- Thường không thay đổi hoặc ít thay đổi.
- Có thể được chia sẻ an toàn.
- Được lưu trong Flyweight.

Ví dụ với cây trong game:

- Tên loại cây.
- Màu lá mặc định.
- Texture.
- Sprite.
- Mesh/model 3D.

=== Extrinsic State

*Extrinsic state* là trạng thái bên ngoài, khác nhau theo từng context cụ thể.

Đặc điểm:

- Phụ thuộc vào từng object cụ thể.
- Không nên lưu trong Flyweight dùng chung.
- Thường được lưu trong Context hoặc truyền vào method khi xử lý.

Ví dụ với cây trong game:

- Vị trí `x`, `y`.
- Chiều cao riêng.
- Góc xoay.
- Trạng thái bị cháy, bị chặt, bị chọn.

Nếu lưu nhầm extrinsic state vào Flyweight, các object dùng chung Flyweight có thể ảnh hưởng lẫn nhau. Đây là lỗi thiết kế rất quan trọng cần tránh.

== Thành phần chính

Các thành phần chính trong Flyweight Pattern gồm:

#table(
  columns: (30%, 70%),
  inset: 8pt,
  align: horizon,
  [*Thành phần*], [*Vai trò*],
  [`Flyweight`],
  [Interface hoặc class khai báo các thao tác dùng chung. Nó thường nhận thêm extrinsic state từ bên ngoài khi thực thi.],

  [`ConcreteFlyweight`],
  [Object thật sự được chia sẻ. Nó lưu intrinsic state, ví dụ `TreeType`, `CharacterStyle`, `MapIconType`.],

  [`FlyweightFactory`],
  [Quản lý cache các Flyweight. Khi client yêu cầu một loại Flyweight, Factory trả về object đã tồn tại nếu có, hoặc tạo mới rồi lưu lại.],

  [`Context`],
  [Object chứa extrinsic state riêng và tham chiếu đến Flyweight. Ví dụ `Tree` chứa `x`, `y` và tham chiếu đến `TreeType`.],

  [`Client`],
  [Sử dụng Context hoặc yêu cầu Factory cung cấp Flyweight phù hợp. Client không nên tự tạo Flyweight một cách tùy tiện nếu muốn đảm bảo tái sử dụng.],
)

Trong triển khai thực tế, có thể không cần tách `Flyweight` interface nếu hệ thống đơn giản. Tuy nhiên, với hệ thống có nhiều loại Flyweight, interface giúp code dễ mở rộng và dễ thay thế hơn.

== UML tổng quát bằng PlantUML

Sơ đồ tổng quát:

#figure(
  image("diagrams/flyweight-structure.svg", width: 100%),
  caption: [Cấu trúc UML tổng quát của Flyweight Pattern],
)


Ý nghĩa sơ đồ:

- `Client` không cần tạo trực tiếp `ConcreteFlyweight`.
- `FlyweightFactory` giữ cache để tránh tạo trùng lặp.
- `Context` giữ dữ liệu riêng và tham chiếu đến Flyweight dùng chung.
- `Flyweight` xử lý logic dựa trên intrinsic state của nó và extrinsic state được truyền vào.

== UML ví dụ: rừng cây

Ví dụ phổ biến nhất của Flyweight là hệ thống vẽ rừng cây. Nhiều cây có vị trí khác nhau nhưng có thể dùng chung loại cây.

#figure(
  image("diagrams/flyweight-forest-example.svg", width: 100%),
  caption: [Class diagram của ví dụ rừng cây],
)


Trong ví dụ này:

- `TreeType` là Flyweight vì chứa dữ liệu dùng chung.
- `Tree` là Context vì chứa vị trí riêng.
- `TreeTypeFactory` tái sử dụng các `TreeType` đã tồn tại.
- `Forest` đóng vai trò client/use case quản lý nhiều cây.

== Luồng hoạt động

Luồng hoạt động cơ bản của Flyweight Pattern:

1. Client cần tạo hoặc sử dụng một object mới trong một context cụ thể.
2. Client xác định phần dữ liệu dùng chung, ví dụ loại cây, màu, texture.
3. Client gửi thông tin định danh phần dùng chung cho `FlyweightFactory`.
4. Factory kiểm tra cache xem Flyweight tương ứng đã tồn tại chưa.
5. Nếu đã tồn tại, Factory trả về object cũ.
6. Nếu chưa tồn tại, Factory tạo Flyweight mới, lưu vào cache rồi trả về.
7. Context lưu phần trạng thái riêng và tham chiếu đến Flyweight.
8. Khi cần xử lý, Context gọi Flyweight và truyền thêm trạng thái riêng nếu cần.

Sơ đồ tuần tự:

#figure(
  image("diagrams/flyweight-sequence.svg", width: 100%),
  caption: [Luồng tạo và tái sử dụng Flyweight qua Factory],
)


Điểm quan trọng là Factory không tạo mới Flyweight mỗi lần. Nó chỉ tạo mới khi chưa có object dùng chung tương ứng.

== Ví dụ minh họa bằng C\#

Bài toán: một hệ thống vẽ rừng cây. Mỗi cây có vị trí riêng, nhưng nhiều cây cùng loại có thể dùng chung thông tin tên, màu và texture.

```csharp
using System;
using System.Collections.Generic;

// Flyweight: chứa intrinsic state dùng chung
public class TreeType
{
    public string Name { get; }
    public string Color { get; }
    public string Texture { get; }

    public TreeType(string name, string color, string texture)
    {
        Name = name;
        Color = color;
        Texture = texture;
    }

    // x, y là extrinsic state được truyền từ bên ngoài
    public void Draw(int x, int y)
    {
        Console.WriteLine(
            $"Draw {Name} tree at ({x}, {y}) with color {Color} and texture {Texture}"
        );
    }
}

// FlyweightFactory: quản lý cache Flyweight
public class TreeTypeFactory
{
    private readonly Dictionary<string, TreeType> _treeTypes = new();

    public TreeType GetTreeType(string name, string color, string texture)
    {
        string key = $"{name}_{color}_{texture}";

        if (!_treeTypes.ContainsKey(key))
        {
            Console.WriteLine($"Create new TreeType: {key}");
            _treeTypes[key] = new TreeType(name, color, texture);
        }
        else
        {
            Console.WriteLine($"Reuse existing TreeType: {key}");
        }

        return _treeTypes[key];
    }

    public int Count => _treeTypes.Count;
}

// Context: chứa extrinsic state riêng của từng cây
public class Tree
{
    private readonly int _x;
    private readonly int _y;
    private readonly TreeType _type;

    public Tree(int x, int y, TreeType type)
    {
        _x = x;
        _y = y;
        _type = type;
    }

    public void Draw()
    {
        _type.Draw(_x, _y);
    }
}

// Client/use case
public class Forest
{
    private readonly List<Tree> _trees = new();
    private readonly TreeTypeFactory _factory = new();

    public void PlantTree(int x, int y, string name, string color, string texture)
    {
        TreeType type = _factory.GetTreeType(name, color, texture);
        Tree tree = new Tree(x, y, type);
        _trees.Add(tree);
    }

    public void Draw()
    {
        foreach (Tree tree in _trees)
        {
            tree.Draw();
        }
    }

    public int TreeCount => _trees.Count;
    public int TreeTypeCount => _factory.Count;
}

public class Program
{
    public static void Main()
    {
        Forest forest = new Forest();

        forest.PlantTree(10, 20, "Oak", "Green", "oak.png");
        forest.PlantTree(30, 40, "Oak", "Green", "oak.png");
        forest.PlantTree(50, 60, "Pine", "DarkGreen", "pine.png");
        forest.PlantTree(70, 80, "Oak", "Green", "oak.png");

        forest.Draw();

        Console.WriteLine($"Total trees: {forest.TreeCount}");
        Console.WriteLine($"Total tree types: {forest.TreeTypeCount}");
    }
}
```

Kết quả mong đợi:

```text
Create new TreeType: Oak_Green_oak.png
Reuse existing TreeType: Oak_Green_oak.png
Create new TreeType: Pine_DarkGreen_pine.png
Reuse existing TreeType: Oak_Green_oak.png
Draw Oak tree at (10, 20) with color Green and texture oak.png
Draw Oak tree at (30, 40) with color Green and texture oak.png
Draw Pine tree at (50, 60) with color DarkGreen and texture pine.png
Draw Oak tree at (70, 80) with color Green and texture oak.png
Total trees: 4
Total tree types: 2
```

Dù có 4 cây, hệ thống chỉ tạo 2 `TreeType`. Nếu số lượng cây tăng lên hàng chục nghìn, lợi ích tiết kiệm bộ nhớ sẽ rõ ràng hơn.



#figure(
  image("diagrams/flyweight-code-flow.svg", width: 100%),
  caption: [Luồng chạy code ví dụ Forest, Tree và TreeTypeFactory],
)

== Phân tích ví dụ

Trong đoạn code trên:

- `TreeType` là Flyweight, chứa intrinsic state: `Name`, `Color`, `Texture`.
- `Tree` là Context, chứa extrinsic state: `_x`, `_y`.
- `TreeTypeFactory` là Factory/cache, đảm bảo không tạo trùng `TreeType`.
- `Forest` là client/use case, quản lý danh sách cây và yêu cầu Factory cung cấp loại cây.

Điểm quan trọng nằm ở method:

```csharp
public TreeType GetTreeType(string name, string color, string texture)
```

Method này dùng key để xác định một Flyweight đã tồn tại hay chưa. Nếu đã tồn tại, nó trả lại object cũ. Nếu chưa tồn tại, nó tạo mới và lưu vào cache.

Nhờ đó, các object `Tree` không cần lưu texture riêng. Chúng chỉ cần giữ vị trí riêng và tham chiếu đến `TreeType` dùng chung.

== Khi nào nên dùng

Nên dùng Flyweight khi:

- Hệ thống cần tạo rất nhiều object.
- Nhiều object có phần dữ liệu giống nhau.
- Dữ liệu giống nhau chiếm nhiều bộ nhớ hoặc tốn chi phí khởi tạo.
- Phần dữ liệu dùng chung có thể tách khỏi dữ liệu riêng.
- Object dùng chung ít thay đổi hoặc có thể được xem là immutable.
- Chi phí lookup trong Factory nhỏ hơn lợi ích tiết kiệm bộ nhớ.

Một số tình huống phù hợp:

- Render ký tự trong trình soạn thảo văn bản.
- Icon/marker trên bản đồ.
- Texture, sprite, particle trong game.
- Các loại sản phẩm/category/tag dùng lặp lại trong nhiều bản ghi.
- Hệ thống vẽ đồ họa có nhiều shape cùng style.
- Cache metadata hoặc configuration nhỏ dùng chung cho nhiều entity.

== Khi nào không nên dùng

Không nên dùng Flyweight khi:

- Số lượng object ít, không tạo áp lực bộ nhớ.
- Các object hầu như không có dữ liệu lặp lại.
- Dữ liệu riêng và dữ liệu dùng chung khó tách rõ ràng.
- Object dùng chung thường xuyên thay đổi theo từng context.
- Việc dùng Factory/cache làm code phức tạp hơn lợi ích nhận được.
- Performance bottleneck không nằm ở bộ nhớ mà nằm ở I/O, database hoặc network.

Nếu hệ thống chỉ có vài chục object đơn giản, dùng Flyweight có thể là over-engineering. Pattern này chỉ thật sự có giá trị khi số lượng object lớn và dữ liệu trùng lặp đáng kể.

== Ưu điểm và nhược điểm

#table(
  columns: (50%, 50%),
  inset: 8pt,
  align: horizon,
  [*Ưu điểm*], [*Nhược điểm*],
  [Tiết kiệm bộ nhớ vì dữ liệu giống nhau được chia sẻ.],
  [Tăng độ phức tạp thiết kế do phải tách intrinsic/extrinsic state.],

  [Giảm số lượng object nặng cần tạo ra.], [Khó debug hơn vì dữ liệu của một object có thể nằm ở nhiều nơi.],
  [Tăng hiệu quả khi xử lý số lượng lớn object.], [Không hiệu quả nếu object không có nhiều dữ liệu lặp lại.],
  [Tách rõ dữ liệu dùng chung và dữ liệu riêng.], [Có thể tốn thêm chi phí lookup trong Factory/cache.],
  [Hỗ trợ cache và tái sử dụng object tốt hơn.],
  [Nếu Flyweight bị mutable, các context dùng chung có thể ảnh hưởng lẫn nhau.],
)

== Lưu ý thiết kế

Khi triển khai Flyweight, cần chú ý một số điểm:

=== Flyweight nên immutable

Flyweight chứa dữ liệu dùng chung, vì vậy nó nên được thiết kế bất biến hoặc hạn chế thay đổi. Nếu một context thay đổi Flyweight, tất cả context khác đang dùng chung Flyweight đó có thể bị ảnh hưởng.

Ví dụ, nếu `TreeType.Color` bị đổi từ `Green` sang `Red`, toàn bộ cây đang dùng `TreeType` đó sẽ bị đổi màu.

=== Key của Factory phải đủ chính xác

Factory thường dùng key để xác định Flyweight. Key phải bao gồm đầy đủ các thuộc tính tạo nên intrinsic state.

Ví dụ:

```csharp
string key = $"{name}_{color}_{texture}";
```

Nếu key thiếu `texture`, hai loại cây có cùng tên và màu nhưng khác texture có thể bị nhầm thành một Flyweight.

=== Không nhầm với cache thông thường

Flyweight có liên quan đến cache, nhưng không phải mọi cache đều là Flyweight. Flyweight tập trung vào việc chia sẻ intrinsic state giữa nhiều context. Cache thông thường có thể chỉ nhằm tăng tốc truy cập dữ liệu.

=== Không lưu extrinsic state trong Flyweight

Đây là lỗi phổ biến nhất. Nếu `TreeType` lưu `x`, `y`, nó không còn là dữ liệu dùng chung nữa. Khi đó các cây dùng chung `TreeType` sẽ ghi đè vị trí lẫn nhau.

== So sánh Flyweight và Singleton

#table(
  columns: (28%, 36%, 36%),
  inset: 7pt,
  align: horizon,
  [*Tiêu chí*], [*Flyweight*], [*Singleton*],
  [Mục đích chính],
  [Chia sẻ nhiều object nhỏ có trạng thái giống nhau để tiết kiệm bộ nhớ.],
  [Đảm bảo một class chỉ có một instance duy nhất.],

  [Số lượng instance],
  [Có thể có nhiều instance, mỗi instance đại diện một loại state dùng chung.],
  [Chỉ một instance duy nhất cho class đó.],

  [Trọng tâm],
  [Tiết kiệm bộ nhớ bằng cách chia sẻ intrinsic state.],
  [Kiểm soát số lượng instance và điểm truy cập toàn cục.],

  [Factory/cache], [Thường có Factory/cache để tái sử dụng Flyweight.], [Không bắt buộc có Factory/cache.],
  [Ví dụ], [`TreeType` cho Oak, Pine, Cherry.], [`ConfigurationManager`, `Logger`, `AppSettings`.],
)

Điểm dễ nhầm là cả hai đều có yếu tố dùng chung object. Tuy nhiên, Singleton chỉ nói về một instance duy nhất của một class, còn Flyweight có thể có nhiều instance dùng chung, mỗi instance đại diện cho một nhóm dữ liệu giống nhau.

== So sánh Flyweight và Prototype

#table(
  columns: (28%, 36%, 36%),
  inset: 7pt,
  align: horizon,
  [*Tiêu chí*], [*Flyweight*], [*Prototype*],
  [Mục đích chính], [Chia sẻ object để giảm bộ nhớ.], [Clone object để tạo object mới nhanh hơn hoặc linh hoạt hơn.],
  [Object được tạo ra], [Dùng lại object có sẵn.], [Tạo bản sao mới từ object mẫu.],
  [Trạng thái], [Tách intrinsic state và extrinsic state.], [Mỗi clone thường có state riêng.],
  [Có chia sẻ object không?], [Có, đây là trọng tâm chính.], [Không nhất thiết; clone thường là object độc lập.],
  [Ví dụ], [Dùng chung `TreeType` cho nhiều cây.], [Clone một `Enemy` mẫu thành nhiều enemy mới.],
)

Prototype hữu ích khi chi phí tạo object từ đầu cao và ta muốn clone từ mẫu. Flyweight hữu ích khi ta muốn nhiều context cùng dùng chung một phần dữ liệu.

== So sánh Flyweight và Object Pool

#table(
  columns: (28%, 36%, 36%),
  inset: 7pt,
  align: horizon,
  [*Tiêu chí*], [*Flyweight*], [*Object Pool*],
  [Mục đích chính],
  [Chia sẻ dữ liệu giống nhau để tiết kiệm bộ nhớ.],
  [Tái sử dụng object tạm thời để tránh tạo/hủy nhiều lần.],

  [Object dùng đồng thời],
  [Một Flyweight có thể được nhiều context dùng cùng lúc.],
  [Một object trong pool thường được một client mượn tại một thời điểm.],

  [State],
  [Flyweight thường chứa state dùng chung, ít thay đổi.],
  [Object trong pool thường có state thay đổi và cần reset trước khi trả lại pool.],

  [Vòng đời], [Flyweight thường tồn tại lâu trong cache.], [Object được mượn, dùng, reset, rồi trả lại pool.],
  [Ví dụ], [Dùng chung `TreeType` cho nhiều cây.], [Pool connection database, pool bullet object trong game.],
)

Object Pool giải quyết vấn đề chi phí tạo/hủy object. Flyweight giải quyết vấn đề lưu lặp lại dữ liệu giống nhau. Hai pattern có thể cùng xuất hiện trong game, nhưng mục tiêu của chúng khác nhau.

== So sánh Flyweight và Facade

#table(
  columns: (28%, 36%, 36%),
  inset: 7pt,
  align: horizon,
  [*Tiêu chí*], [*Flyweight*], [*Facade*],
  [Nhóm pattern], [Structural.], [Structural.],
  [Mục đích chính],
  [Giảm bộ nhớ bằng cách chia sẻ trạng thái dùng chung.],
  [Đơn giản hóa cách sử dụng subsystem phức tạp.],

  [Vấn đề giải quyết],
  [Có quá nhiều object chứa dữ liệu lặp lại.],
  [Client phải gọi quá nhiều class/service bên trong.],

  [Trọng tâm], [Tối ưu cấu trúc dữ liệu/object.], [Đơn giản hóa interface cho client.],
  [Ví dụ], [Nhiều marker bản đồ dùng chung một `MarkerIconType`.], [`CheckoutFacade` gọi Payment, Inventory, Shipping.],
)

Cả hai đều là Structural Pattern, nhưng Flyweight thiên về tối ưu bộ nhớ, còn Facade thiên về giảm độ phức tạp khi client sử dụng subsystem.

== Ví dụ áp dụng trong app giao hàng

Trong app giao hàng, bản đồ có thể hiển thị rất nhiều marker:

- Marker shipper.
- Marker nhà hàng.
- Marker khách hàng.
- Marker đơn hàng đang xử lý.

Nếu mỗi marker đều lưu riêng icon, màu, style, animation config, hệ thống có thể lãng phí bộ nhớ, đặc biệt khi bản đồ hiển thị nhiều đối tượng.

Có thể áp dụng Flyweight như sau:

- `MarkerStyle` là Flyweight: chứa icon, màu, kích thước, loại marker.
- `MapMarker` là Context: chứa vị trí latitude/longitude, id đối tượng, trạng thái realtime.
- `MarkerStyleFactory` quản lý các style dùng chung như `ShipperAvailable`, `ShipperBusy`, `Restaurant`, `Customer`, `Order`.

Khi cần hiển thị 500 shipper online, không cần tạo 500 icon/style riêng. Mỗi marker chỉ giữ vị trí và trạng thái riêng, còn style được dùng chung.

Sơ đồ ý tưởng:

#figure(
  image("diagrams/flyweight-map-marker-example.svg", width: 100%),
  caption: [Class diagram của ví dụ marker bản đồ],
)


Cách thiết kế này giúp bản đồ nhẹ hơn và tránh lặp lại style/icon cho từng marker.

== Tổng kết

Flyweight Pattern phù hợp khi hệ thống phải xử lý số lượng lớn object có nhiều dữ liệu giống nhau. Pattern này giúp giảm bộ nhớ bằng cách tách dữ liệu thành intrinsic state và extrinsic state.

Điểm mạnh nhất của Flyweight là khả năng chia sẻ object dùng chung thông qua Factory/cache. Tuy nhiên, pattern này cũng làm thiết kế phức tạp hơn và đòi hỏi phân tách trạng thái cẩn thận.

Có thể ghi nhớ Flyweight bằng câu sau:

```text
Nhiều object khác nhau không nhất thiết phải lưu toàn bộ dữ liệu khác nhau.
Phần nào giống nhau thì chia sẻ, phần nào riêng thì để bên ngoài.
```

