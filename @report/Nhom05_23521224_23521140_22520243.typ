
#import "@preview/basic-report:0.3.1": *

#show: it => basic-report(
  doc-category: "Mẫu thiết kế - SE401.Q21",
  doc-title: "Báo cáo cuối kỳ",
  author: "
Nhóm 05
23521224 Trương Hoàng Phúc
23521140 Lê Minh Phát
22520243 Ya Đạt",
  language: "vi",
  compact-mode: false,
  it,
)

#set page(margin: 1.75in)
#set par(leading: 0.55em, spacing: 0.55em, first-line-indent: 1.8em, justify: true)
#show heading: set block(above: 1.4em, below: 1em)

= Abstract Factory (Phúc)
#include "../AbstractFactory/report.typ"

= Adapter (Phát)
#include "../Adapter/report.typ"

= Bridge (Đạt)
#include "../Bridge/report.typ"

= Builder (Đạt)
#include "../Builder/report.typ"

= Chain of Responsibility (Phát)
#include "../ChainOfResponsibility/report.typ"

= Command (Đạt)
#include "../Command/report.typ"

= Composite (Phúc)
#include "../Composite/report.typ"

= Decorator (Phúc)
#include "../Decorator/report.typ"

= Facade (Phát)
#include "../Facade/report.typ"

= Factory Method (Đạt)
#include "../FactoryMethod/report.typ"

= Flyweight (Phát)
#include "../Flyweight/report.typ"

= Interpreter (Phúc)
#include "../Interpreter/report.typ"

= Iterator (Đạt)
#include "../Iterator/report.typ"

= Mediator (Phúc)
#include "../Mediator/report.typ"

= Memento (Phát)
#include "../Memento/report.typ"

= Observer (Đạt)
#include "../Observer/report.typ"

= Prototype (Phát)
#include "../Prototype/report.typ"

= Proxy (Đạt)
#include "../Proxy/report.typ"

= Singleton (Phát)
#include "../Singleton/report.typ"

= State (Phúc)
#include "../State/report.typ"

= Strategy (Đạt)
#include "../Strategy/report.typ"

= Template Method (Phát)
#include "../TemplateMethod/report.typ"

= Visitor (Phúc)
#include "../Visitor/report.typ"
