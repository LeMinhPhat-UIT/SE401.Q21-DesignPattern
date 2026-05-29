
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

= Abstract Factory
#include "../AbstractFactory/report.typ"

= Adapter
#include "../Adapter/report.typ"

= Bridge
#include "../Bridge/report.typ"

= Builder
#include "../Builder/report.typ"

= Chain of Responsibility
#include "../ChainOfResponsibility/report.typ"

= Command
#include "../Command/report.typ"

= Composite
#include "../Composite/report.typ"

= Decorator
#include "../Decorator/report.typ"

= Facade
#include "../Facade/report.typ"

= Factory Method
#include "../FactoryMethod/report.typ"

= Flyweight
#include "../Flyweight/report.typ"

= Interpreter
#include "../Interpreter/report.typ"

= Iterator
#include "../Iterator/report.typ"

= Mediator
#include "../Mediator/report.typ"

= Memento
#include "../Memento/report.typ"

= Observer
#include "../Observer/report.typ"

= Prototype
#include "../Prototype/report.typ"

= Proxy
#include "../Proxy/report.typ"

= Singleton
#include "../Singleton/report.typ"

= State
#include "../State/report.typ"

= Strategy
#include "../Strategy/report.typ"

= Template Method
#include "../TemplateMethod/report.typ"

= Visitor
#include "../Visitor/report.typ"

