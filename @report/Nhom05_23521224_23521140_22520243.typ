#set page(margin: (top: 3cm, bottom: 3.5cm, left: 2cm, right: 2cm))
// leading: giữa các dòng; spacing: giữa các đoạn văn
#set par(leading: 21pt, spacing: 1.5em, first-line-indent: 0pt, justify: true)
#set text(font: "Times New Roman", size: 13pt, lang: "vi")
#set list(marker: [-], indent: 1em)
#show heading: set block(above: 1.4em, below: 1em)

#show heading.where(level: 1): it => {
  pagebreak(weak: false) // Heading 1 nằm trên trang riêng
  let count = counter(heading).get().at(0)
  align(center, if count > 0 and count < 6 {
    // Thêm chữ Chương vào Heading 1 trên trang riêng
    ("Chương " + counter(heading).display("1. ") + it.body)
  } else { it.body })
}


// padding for table
#set table(inset: 10pt)
// table can be split into next page
#show figure: set block(breakable: true)
// figure numbering by chapter
#set figure(numbering: (..num) => numbering("1.1", counter(heading).get().first(), num.pos().first()))
// caption của bảng nằm trên, còn lại nằm dưới
#show figure.where(
  kind: table,
): set figure.caption(position: top)

// thêm chữ Chapter cho Heading 1
#show outline.entry.where(level: 1): it => {
  if it.element.func() == heading {
    text(
      weight: "bold",
      link(
        // in đậm heading 1 trong mục lục
        it.element.location(),
        it.indented(
          "Chương " + it.prefix(),
          it.inner(),
        ),
      ),
    )
  } else {
    it
  }
}

#show outline.entry.where(level: 3): it => {
  // Đừng hiện Heading 3 trong outline
}

#include "trang_bia.typ"

#align(center, outline(title: "MỤC LỤC", indent: 2em))
#align(center, outline(title: "DANH MỤC HÌNH", target: figure.where(kind: image)))
// #align(center, outline(title: "DANH MỤC BẢNG", target: figure.where(kind: table)))

#set page(numbering: "1")
#counter(page).update(1)
#set heading(numbering: "1.")


= Các mẫu tạo lập

== Abstract Factory (Phúc)
#include "../AbstractFactory/report.typ"

== Builder (Đạt)
#include "../Builder/report.typ"

== Factory Method (Đạt)
#include "../FactoryMethod/report.typ"

== Prototype (Phát)
#include "../Prototype/report.typ"

== Singleton (Phát)
#include "../Singleton/report.typ"

= Các mẫu cấu trúc

== Adapter (Phát)
#include "../Adapter/report.typ"

== Bridge (Đạt)
#include "../Bridge/report.typ"

== Composite (Phúc)
#include "../Composite/report.typ"

== Decorator (Phúc)
#include "../Decorator/report.typ"

== Facade (Phát)
#include "../Facade/report.typ"

== Flyweight (Phát)
#include "../Flyweight/report.typ"

== Interpreter (Phúc)
#include "../Interpreter/report.typ"

== Proxy (Đạt)
#include "../Proxy/report.typ"


= Các mẫu hành vi

== Chain of Responsibility (Phát)
#include "../ChainOfResponsibility/report.typ"

== Command (Đạt)
#include "../Command/report.typ"

== Iterator (Đạt)
#include "../Iterator/report.typ"

== Mediator (Phúc)
#include "../Mediator/report.typ"

== Memento (Phát)
#include "../Memento/report.typ"

== Observer (Đạt)
#include "../Observer/report.typ"

== State (Phúc)
#include "../State/report.typ"

== Strategy (Đạt)
#include "../Strategy/report.typ"

== Template Method (Phát)
#include "../TemplateMethod/report.typ"

== Visitor (Phúc)
#include "../Visitor/report.typ"
