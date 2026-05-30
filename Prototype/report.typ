#set text(font: "New Computer Modern", size: 11pt)
#set page(margin: (x: 2.2cm, y: 2cm))
#set heading(numbering: "1.")
#set par(justify: true, leading: 0.65em)

= Prototype Pattern

== Tên và phân loại

*Prototype Pattern* có thể hiểu là *mẫu nguyên mẫu* hoặc *mẫu đối tượng mẫu*. Tên gọi này nhấn mạnh ý tưởng chính của pattern: thay vì tạo object mới từ đầu bằng constructor, ta tạo object mới bằng cách sao chép một object mẫu đã tồn tại.

Prototype thuộc nhóm *Creational Pattern* vì nó tập trung vào cách tạo object. Tuy nhiên, khác với Factory Method hoặc Abstract Factory, Prototype không đặt trọng tâm vào việc chọn constructor hoặc subclass phù hợp, mà đặt trọng tâm vào việc *clone trạng thái của một object mẫu*.

Nói ngắn gọn, Prototype là pattern dùng để tạo object mới bằng cách sao chép object có sẵn, đặc biệt hữu ích khi object cần tạo có cấu hình phức tạp hoặc chi phí khởi tạo cao.

== Vấn đề cần giải quyết

Trong nhiều hệ thống, việc tạo object mới không phải lúc nào cũng đơn giản. Có những object cần rất nhiều bước khởi tạo, phải đọc dữ liệu từ database/file/API, phải validate nhiều thông tin, hoặc phải thiết lập một cấu trúc object con phức tạp.

Ví dụ:

- Một `ReportTemplate` có sẵn header, footer, style, danh sách section, biểu đồ và rule định dạng.
- Một enemy trong game có nhiều thông số như máu, sát thương, tốc độ, AI behavior, sprite, animation.
- Một form đăng ký có nhiều field, rule validation và giá trị mặc định.
- Một cấu hình hệ thống cần đọc từ file hoặc database trước khi sử dụng.
- Một object gần giống object cũ, chỉ khác một vài thuộc tính nhỏ.

Nếu client luôn phải gọi constructor và truyền đầy đủ thông tin, code tạo object sẽ dài, lặp lại và dễ sai. Ngoài ra, client có thể bị phụ thuộc quá mạnh vào class cụ thể, constructor cụ thể và chi tiết khởi tạo bên trong.

Ví dụ không dùng Prototype:

```csharp
var goblin = new Enemy(
    name: "Goblin",
    health: 100,
    damage: 15,
    speed: 3,
    sprite: LoadSprite("goblin.png"),
    aiProfile: LoadAI("aggressive"),
    skills: new List<string> { "Slash", "Dodge" }
);

var strongGoblin = new Enemy(
    name: "Strong Goblin",
    health: 150,
    damage: 20,
    speed: 3,
    sprite: LoadSprite("goblin.png"),
    aiProfile: LoadAI("aggressive"),
    skills: new List<string> { "Slash", "Dodge" }
);
```

Hai object gần như giống nhau nhưng code khởi tạo bị lặp lại. Khi logic khởi tạo thay đổi, nhiều nơi trong code cũng phải sửa theo.

Vấn đề cốt lõi là: *làm sao tạo nhanh object mới dựa trên một object đã được cấu hình sẵn mà không cần lặp lại toàn bộ logic khởi tạo?*

Prototype Pattern giải quyết vấn đề này bằng cách cho chính object biết cách sao chép nó. Client chỉ cần chọn object mẫu và gọi `Clone()`.

== Mục đích và ý định

Mục đích chính của Prototype là *tạo object mới bằng cách clone từ object mẫu đã có sẵn*.

Prototype thường được dùng để:

- Giảm chi phí khởi tạo object phức tạp.
- Tránh lặp lại code tạo object gần giống nhau.
- Tạo nhiều biến thể object từ một object mẫu.
- Giảm phụ thuộc của client vào constructor cụ thể.
- Cho phép thêm loại object mới bằng cách đăng ký prototype mới thay vì sửa nhiều logic tạo object.
- Hỗ trợ cơ chế template, preset, copy object, duplicate item hoặc clone configuration.

Prototype đặc biệt phù hợp khi object mẫu đã có trạng thái gần đúng với object cần tạo. Sau khi clone, client chỉ cần chỉnh sửa một vài thuộc tính khác biệt.

== Định nghĩa

*Prototype Pattern* là một creational design pattern cho phép tạo object mới bằng cách sao chép một object hiện có, gọi là prototype, thay vì khởi tạo object từ đầu.

Định nghĩa ngắn gọn:

- `Prototype` khai báo phương thức `Clone()`.
- `ConcretePrototype` tự cài đặt cách sao chép chính nó.
- `Client` gọi `Clone()` trên object mẫu để tạo object mới.
- `Prototype Registry` có thể được dùng để lưu và tra cứu nhiều prototype theo key.

Nói đơn giản:

```text
Thay vì hỏi: "Làm sao tạo object này từ đầu?"
Prototype hỏi: "Đã có object mẫu chưa? Nếu có, clone nó rồi chỉnh lại phần cần khác."
```

== Ý tưởng cốt lõi

Ý tưởng chính của Prototype Pattern là: *nếu việc tạo object mới phức tạp hoặc tốn kém, hãy tạo sẵn một object mẫu, sau đó sao chép nó khi cần*.

Quy trình tư duy thường là:

1. Tạo một object mẫu với cấu hình đầy đủ.
2. Lưu object mẫu đó ở nơi phù hợp, ví dụ registry hoặc service.
3. Khi cần object mới, clone object mẫu thay vì dựng lại từ đầu.
4. Chỉnh sửa các thuộc tính khác biệt trên object vừa clone.

Ví dụ trong game:

- `goblinPrototype` chứa cấu hình chuẩn của Goblin.
- Khi sinh Goblin mới, game gọi `goblinPrototype.Clone()`.
- Sau đó game chỉ cần chỉnh vị trí, level hoặc vài chỉ số riêng.

Ví dụ trong hệ thống báo cáo:

- `monthlyReportTemplate` chứa layout, style, sections, charts.
- Khi tạo báo cáo tháng 5, hệ thống clone template rồi thay data tháng 5.
- Khi tạo báo cáo tháng 6, hệ thống clone template rồi thay data tháng 6.

Điểm quan trọng là object clone phải đủ độc lập để việc chỉnh sửa object mới không làm hỏng prototype gốc.

== Shallow copy và Deep copy

Khi nói đến Prototype, vấn đề quan trọng nhất là phân biệt *shallow copy* và *deep copy*.

=== Shallow copy

Shallow copy chỉ sao chép các field cấp đầu tiên. Với field kiểu primitive hoặc value type, giá trị được copy trực tiếp. Nhưng với field là object tham chiếu như list, dictionary, object con, bản clone và bản gốc có thể cùng trỏ đến một object con.

Ví dụ:

```text
report1.Sections ----> List A
report2.Sections ----> List A
```

Nếu `report2` thêm section mới, `report1` cũng bị ảnh hưởng vì cả hai dùng chung danh sách.

Shallow copy có ưu điểm là nhanh và đơn giản, nhưng dễ gây bug nếu object có nhiều dữ liệu tham chiếu có thể thay đổi.

=== Deep copy

Deep copy sao chép cả object chính và các object con bên trong. Sau khi clone, bản gốc và bản sao độc lập hơn.

Ví dụ:

```text
report1.Sections ----> List A
report2.Sections ----> List B
```

Nếu `report2` thêm section mới, `report1` không bị ảnh hưởng.

Deep copy an toàn hơn trong nhiều trường hợp, nhưng phức tạp hơn vì phải quyết định object con nào cần clone, object nào có thể dùng chung, object nào là immutable.

=== Khi nào dùng loại nào?

- Dùng shallow copy khi object đơn giản, không có object con mutable, hoặc dữ liệu dùng chung là an toàn.
- Dùng deep copy khi object có cấu trúc lồng nhau và bản clone cần độc lập với bản gốc.
- Có thể dùng copy có chọn lọc: clone phần dễ thay đổi, chia sẻ phần immutable hoặc tài nguyên nặng.

== Thành phần chính

Các thành phần chính của Prototype Pattern gồm:

#table(
  columns: (1.4fr, 3fr),
  inset: 8pt,
  align: left,
  [*Thành phần*], [*Vai trò*],
  [`Prototype`], [Interface hoặc abstract class khai báo phương thức `Clone()`. Nó định nghĩa contract chung cho các object có khả năng tự sao chép.],
  [`ConcretePrototype`], [Class cụ thể có state và cài đặt logic clone. Mỗi class tự quyết định clone shallow, deep hay clone có chọn lọc.],
  [`Client`], [Đối tượng sử dụng prototype để tạo object mới. Client không cần biết chi tiết constructor phức tạp.],
  [`Prototype Registry`], [Kho lưu các prototype theo key. Thành phần này không bắt buộc, nhưng rất hữu ích khi hệ thống có nhiều object mẫu cần quản lý.]
)

== UML tổng quát bằng PlantUML

Sơ đồ tổng quát:

```plantuml
@startuml
skinparam classAttributeIconSize 0

interface Prototype {
  +Clone(): Prototype
}

class ConcretePrototype {
  -state: string
  -items: List<string>
  +Clone(): Prototype
}

class Client {
  +Operation(): void
}

Prototype <|.. ConcretePrototype
Client --> Prototype : uses

note right of ConcretePrototype
Clone() có thể là shallow copy,
deep copy hoặc copy có chọn lọc.
end note
@enduml
```

Sơ đồ có Prototype Registry:

```plantuml
@startuml
skinparam classAttributeIconSize 0

interface Prototype {
  +Clone(): Prototype
}

class ConcretePrototype {
  -state: string
  +Clone(): Prototype
}

class PrototypeRegistry {
  -prototypes: Dictionary<string, Prototype>
  +Register(key: string, prototype: Prototype): void
  +Create(key: string): Prototype
}

class Client {
  -registry: PrototypeRegistry
  +Operation(): void
}

Prototype <|.. ConcretePrototype
PrototypeRegistry o--> Prototype : stores
Client --> PrototypeRegistry : requests clone
@enduml
```

== Luồng hoạt động

Luồng hoạt động cơ bản của Prototype Pattern:

1. Client cần tạo một object mới.
2. Client chọn một prototype phù hợp.
3. Client gọi `Clone()` trên prototype.
4. Prototype tự sao chép dữ liệu của nó sang object mới.
5. Client nhận object mới.
6. Client có thể tùy chỉnh thêm một vài thuộc tính nếu cần.

Biểu diễn dạng sequence:

```plantuml
@startuml
actor Client
participant "PrototypeRegistry" as Registry
participant "Prototype" as Prototype
participant "Cloned Object" as Clone

Client -> Registry: Create("goblin")
Registry -> Prototype: Clone()
Prototype -> Clone: create copy
Clone --> Prototype: copied object
Prototype --> Registry: cloned object
Registry --> Client: cloned object
Client -> Clone: customize position/level
@enduml
```

Nếu không dùng registry, client có thể giữ trực tiếp prototype và gọi `Clone()` trên prototype đó.

== Ví dụ minh họa: Enemy trong game

Giả sử game cần tạo nhiều loại enemy. Mỗi enemy có nhiều thuộc tính như tên, máu, sát thương, danh sách kỹ năng. Một số enemy gần giống nhau, chỉ khác level hoặc vị trí.

Nếu dùng constructor ở mọi nơi, code sẽ lặp lại nhiều. Ta có thể tạo prototype cho từng loại enemy, sau đó clone khi cần sinh enemy mới.

=== Code C\# minh họa

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

public interface IEnemyPrototype
{
    IEnemyPrototype Clone();
}

public class Enemy : IEnemyPrototype
{
    public string Name { get; set; }
    public int Health { get; set; }
    public int Damage { get; set; }
    public int Level { get; set; }
    public Position Position { get; set; }
    public List<string> Skills { get; set; }

    public Enemy(
        string name,
        int health,
        int damage,
        int level,
        Position position,
        List<string> skills)
    {
        Name = name;
        Health = health;
        Damage = damage;
        Level = level;
        Position = position;
        Skills = skills;
    }

    public IEnemyPrototype Clone()
    {
        // Deep copy cho các object mutable như Position và List<string>.
        return new Enemy(
            Name,
            Health,
            Damage,
            Level,
            new Position(Position.X, Position.Y),
            Skills.ToList()
        );
    }

    public override string ToString()
    {
        return $"{Name} | HP: {Health} | Damage: {Damage} | Level: {Level} | Position: ({Position.X}, {Position.Y}) | Skills: {string.Join(", ", Skills)}";
    }
}

public class Position
{
    public int X { get; set; }
    public int Y { get; set; }

    public Position(int x, int y)
    {
        X = x;
        Y = y;
    }
}

public class EnemyRegistry
{
    private readonly Dictionary<string, IEnemyPrototype> _prototypes = new();

    public void Register(string key, IEnemyPrototype prototype)
    {
        _prototypes[key] = prototype;
    }

    public Enemy Create(string key)
    {
        if (!_prototypes.ContainsKey(key))
        {
            throw new ArgumentException($"Prototype '{key}' does not exist.");
        }

        return (Enemy)_prototypes[key].Clone();
    }
}

public class Program
{
    public static void Main()
    {
        var registry = new EnemyRegistry();

        var goblinPrototype = new Enemy(
            name: "Goblin",
            health: 100,
            damage: 15,
            level: 1,
            position: new Position(0, 0),
            skills: new List<string> { "Slash", "Dodge" }
        );

        registry.Register("goblin", goblinPrototype);

        var goblinA = registry.Create("goblin");
        goblinA.Position.X = 10;
        goblinA.Position.Y = 5;

        var goblinB = registry.Create("goblin");
        goblinB.Level = 3;
        goblinB.Health = 150;
        goblinB.Position.X = 30;
        goblinB.Skills.Add("Poison Attack");

        Console.WriteLine(goblinPrototype);
        Console.WriteLine(goblinA);
        Console.WriteLine(goblinB);
    }
}
```

Trong ví dụ trên:

- `IEnemyPrototype` là Prototype.
- `Enemy` là ConcretePrototype.
- `EnemyRegistry` là Prototype Registry.
- `Program` đóng vai trò Client.
- `Clone()` tạo bản sao độc lập cho `Position` và `Skills` để tránh bug do dùng chung reference.

=== Class diagram cho ví dụ

```plantuml
@startuml
skinparam classAttributeIconSize 0

interface IEnemyPrototype {
  +Clone(): IEnemyPrototype
}

class Enemy {
  +Name: string
  +Health: int
  +Damage: int
  +Level: int
  +Position: Position
  +Skills: List<string>
  +Clone(): IEnemyPrototype
}

class Position {
  +X: int
  +Y: int
}

class EnemyRegistry {
  -prototypes: Dictionary<string, IEnemyPrototype>
  +Register(key: string, prototype: IEnemyPrototype): void
  +Create(key: string): Enemy
}

class Program {
  +Main(): void
}

IEnemyPrototype <|.. Enemy
Enemy *-- Position
EnemyRegistry o--> IEnemyPrototype
Program --> EnemyRegistry
@enduml
```

== Ví dụ minh họa: Report Template

Một ví dụ gần với hệ thống quản lý là tạo báo cáo. Báo cáo tháng, báo cáo quý, báo cáo doanh thu có thể dùng chung cấu trúc: tiêu đề, danh sách section, biểu đồ, footer. Mỗi lần tạo báo cáo mới, ta chỉ cần clone template rồi thay dữ liệu.

```csharp
using System;
using System.Collections.Generic;
using System.Linq;

public interface IReportPrototype
{
    IReportPrototype Clone();
}

public class Report : IReportPrototype
{
    public string Title { get; set; }
    public string Theme { get; set; }
    public List<string> Sections { get; set; } = new();

    public IReportPrototype Clone()
    {
        return new Report
        {
            Title = Title,
            Theme = Theme,
            Sections = Sections.ToList()
        };
    }

    public void Print()
    {
        Console.WriteLine($"Report: {Title} | Theme: {Theme}");
        Console.WriteLine("Sections: " + string.Join(", ", Sections));
    }
}

public class Demo
{
    public static void Main()
    {
        var monthlyTemplate = new Report
        {
            Title = "Monthly Revenue Report",
            Theme = "Corporate",
            Sections = new List<string> { "Summary", "Revenue Chart", "Top Products" }
        };

        var mayReport = (Report)monthlyTemplate.Clone();
        mayReport.Title = "Revenue Report - May 2026";
        mayReport.Sections.Add("May Analysis");

        var juneReport = (Report)monthlyTemplate.Clone();
        juneReport.Title = "Revenue Report - June 2026";
        juneReport.Sections.Add("June Analysis");

        monthlyTemplate.Print();
        mayReport.Print();
        juneReport.Print();
    }
}
```

Nếu `Sections` không được copy bằng `ToList()`, template gốc có thể bị thay đổi khi report clone thêm section mới.

== Đánh giá

=== Ưu điểm

#table(
  columns: (1.6fr, 3fr),
  inset: 8pt,
  align: left,
  [*Ưu điểm*], [*Giải thích*],
  [Giảm chi phí khởi tạo object phức tạp], [Object mẫu đã được cấu hình sẵn, client chỉ cần clone thay vì dựng lại từ đầu.],
  [Giảm code lặp], [Khi cần nhiều object gần giống nhau, ta không phải lặp lại toàn bộ constructor hoặc logic setup.],
  [Không phụ thuộc trực tiếp vào constructor cụ thể], [Client chỉ biết interface `Clone()`, không cần biết class có bao nhiêu constructor hoặc cần tham số gì.],
  [Dễ tạo biến thể object], [Clone object mẫu rồi chỉnh sửa một vài thuộc tính riêng như level, position, title hoặc theme.],
  [Kết hợp tốt với Registry], [Có thể lưu nhiều prototype theo key và tạo object mới linh hoạt theo cấu hình.]
)

=== Nhược điểm

#table(
  columns: (1.6fr, 3fr),
  inset: 8pt,
  align: left,
  [*Nhược điểm*], [*Giải thích*],
  [Clone object phức tạp không phải lúc nào cũng dễ], [Nếu object có nhiều quan hệ, object con, tài nguyên ngoài hoặc vòng tham chiếu, clone sẽ khó cài đặt đúng.],
  [Dễ nhầm giữa shallow copy và deep copy], [Nếu copy reference sai cách, object clone và object gốc có thể ảnh hưởng lẫn nhau.],
  [Có thể che giấu logic tạo object], [Client chỉ thấy clone, nên đôi khi khó biết object mới thật sự được tạo như thế nào.],
  [Không phù hợp nếu object đơn giản], [Nếu object chỉ có vài field và constructor đơn giản, Prototype có thể làm thiết kế rườm rà hơn.],
  [Cần chú ý identity và resource], [Các field như ID, connection, file handle, event subscription không nên bị clone máy móc.]
)

== Khi nào nên dùng Prototype?

Nên dùng Prototype khi:

- Object cần tạo có chi phí khởi tạo cao.
- Object có nhiều thuộc tính hoặc cấu trúc phức tạp.
- Có nhiều object gần giống nhau, chỉ khác vài thuộc tính nhỏ.
- Muốn tạo object mới dựa trên trạng thái runtime của object hiện có.
- Muốn tránh phụ thuộc trực tiếp vào constructor cụ thể.
- Cần cơ chế duplicate/copy trong ứng dụng, ví dụ copy shape trong editor, clone enemy trong game, clone template báo cáo.
- Muốn quản lý nhiều object mẫu thông qua registry.

Ví dụ thực tế:

- Game clone enemy, item, projectile, NPC template.
- Graphic editor clone shape, layer, component.
- Document editor clone template, paragraph style, slide layout.
- Business app clone report template, form template, workflow template.
- Testing clone object fixture đã setup sẵn.

== Khi nào không nên dùng Prototype?

Không nên dùng Prototype khi:

- Object rất đơn giản và constructor rõ ràng.
- Clone object phức tạp hơn tạo mới.
- Object chứa nhiều resource không thể clone an toàn như socket, database connection, stream, lock, thread.
- Object có identity quan trọng và việc clone có thể tạo bug, ví dụ clone cả `Id` của entity database.
- Hệ thống không có nhu cầu tạo nhiều object tương tự nhau.
- Team dễ nhầm giữa shallow copy và deep copy mà không có convention rõ ràng.

== Lưu ý khi triển khai

Khi triển khai Prototype trong dự án thực tế, cần chú ý:

- Xác định rõ clone là shallow copy hay deep copy.
- Không clone máy móc các field định danh như `Id`, `CreatedAt`, `Version` nếu chúng phải unique.
- Với collection mutable, thường nên tạo collection mới.
- Với object con immutable, có thể chia sẻ để tiết kiệm chi phí.
- Với resource bên ngoài như file, socket, database connection, nên tạo lại hoặc bỏ qua.
- Có thể dùng copy constructor, method `Clone()`, serialization, mapping library hoặc manual copy tùy ngôn ngữ và yêu cầu.
- Nên viết test để đảm bảo thay đổi object clone không ảnh hưởng prototype gốc.

Ví dụ test tư duy:

```text
Clone report template -> thêm section vào report clone
Kỳ vọng: template gốc không có section mới
```

== So sánh Prototype với Factory Method

#table(
  columns: (1.3fr, 2fr, 2fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Prototype*], [*Factory Method*],
  [Cách tạo object], [Clone từ object mẫu.], [Gọi factory method để tạo object.],
  [Trọng tâm], [Sao chép trạng thái có sẵn.], [Ẩn logic khởi tạo object.],
  [Phù hợp khi], [Object mẫu đã có cấu hình phức tạp.], [Muốn subclass quyết định object nào được tạo.],
  [Có cần prototype object không?], [Có.], [Không.],
  [Ví dụ], [`goblinPrototype.Clone()`], [`EnemyFactory.CreateEnemy("goblin")`]
)

Điểm khác biệt quan trọng: Factory Method tạo object mới dựa trên logic tạo object, còn Prototype tạo object mới dựa trên một object mẫu đã tồn tại.

== So sánh Prototype với Abstract Factory

#table(
  columns: (1.3fr, 2fr, 2fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Prototype*], [*Abstract Factory*],
  [Mục đích chính], [Tạo object mới từ object mẫu.], [Tạo họ object liên quan với nhau.],
  [Cách tạo], [Clone.], [Factory tạo object mới.],
  [Phù hợp khi], [Có nhiều object gần giống nhau.], [Cần tạo nhiều object cùng một family.],
  [Mức độ tổ chức], [Tập trung vào từng object mẫu.], [Tập trung vào nhóm sản phẩm liên quan.],
  [Ví dụ], [Clone enemy mẫu.], [Tạo bộ UI Windows/Mac: Button, Checkbox, Dialog.]
)

Abstract Factory phù hợp khi cần đảm bảo nhiều object được tạo ra thuộc cùng một family. Prototype phù hợp khi mỗi object cụ thể có thể được sao chép từ mẫu.

== So sánh Prototype với Builder

#table(
  columns: (1.3fr, 2fr, 2fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Prototype*], [*Builder*],
  [Mục đích chính], [Clone object có sẵn.], [Tạo object phức tạp từng bước.],
  [Cách tạo object], [Sao chép từ mẫu.], [Gọi chuỗi bước cấu hình.],
  [Phù hợp khi], [Có object mẫu gần đúng.], [Cần kiểm soát quá trình build chi tiết.],
  [Khả năng tùy biến], [Tùy biến sau khi clone.], [Tùy biến trong lúc build.],
  [Ví dụ], [Clone một `ReportTemplate`.], [Build `Report` với title, sections, charts.]
)

Builder tốt khi quá trình tạo object cần nhiều bước rõ ràng. Prototype tốt khi đã có object mẫu hoàn chỉnh và muốn tạo bản sao nhanh.

== So sánh Prototype với Flyweight

#table(
  columns: (1.3fr, 2fr, 2fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Prototype*], [*Flyweight*],
  [Nhóm pattern], [Creational.], [Structural.],
  [Mục đích chính], [Tạo object mới bằng clone.], [Chia sẻ object/dữ liệu dùng chung để tiết kiệm bộ nhớ.],
  [Object tạo ra], [Object mới, thường độc lập.], [Object dùng chung, không nhất thiết tạo mới.],
  [Trạng thái], [Clone state cần thiết.], [Tách intrinsic và extrinsic state.],
  [Ví dụ], [Clone Enemy mẫu thành enemy mới.], [Nhiều Tree dùng chung một TreeType.]
)

Prototype tạo thêm object mới. Flyweight cố gắng giảm số object/dữ liệu bị lặp bằng cách dùng chung phần trạng thái giống nhau.

== So sánh Prototype với Memento

#table(
  columns: (1.3fr, 2fr, 2fr),
  inset: 7pt,
  align: left,
  [*Tiêu chí*], [*Prototype*], [*Memento*],
  [Mục đích chính], [Tạo object mới từ object mẫu.], [Lưu và khôi phục trạng thái trước đó.],
  [Kết quả], [Có một object mới để sử dụng.], [Có snapshot để restore state.],
  [Trọng tâm], [Object creation.], [State history/undo/rollback.],
  [Client dùng khi], [Muốn copy/duplicate object.], [Muốn quay lại trạng thái cũ.],
  [Ví dụ], [Duplicate một shape trong editor.], [Undo thao tác chỉnh sửa shape.]
)

Prototype và Memento đều có thể liên quan đến việc sao chép trạng thái, nhưng mục đích khác nhau. Prototype dùng để tạo object mới; Memento dùng để lưu lịch sử trạng thái phục vụ restore.

== Kết luận

Prototype Pattern là một mẫu thiết kế hữu ích khi hệ thống cần tạo nhiều object phức tạp hoặc nhiều object gần giống nhau. Thay vì khởi tạo lại từ đầu, ta tạo object mẫu và clone nó khi cần.

Pattern này giúp giảm lặp code, giảm chi phí khởi tạo và giúp client ít phụ thuộc hơn vào constructor cụ thể. Tuy nhiên, Prototype cũng yêu cầu lập trình viên hiểu rõ shallow copy, deep copy và các vấn đề liên quan đến object identity, resource, collection mutable.

Có thể ghi nhớ Prototype bằng một câu ngắn:

```text
Prototype = tạo object mới bằng cách sao chép object mẫu đã có.
```

Khi object đơn giản, constructor rõ ràng thì không cần dùng Prototype. Nhưng khi object phức tạp, khởi tạo tốn kém, hoặc cần tạo nhiều biến thể gần giống nhau, Prototype là một lựa chọn rất đáng cân nhắc.
