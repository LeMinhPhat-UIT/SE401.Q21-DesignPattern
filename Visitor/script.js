function print(str) { console.log(str) }

class Element {
  accept(visitor) { }
}

class ConcreteElementA extends Element {
  accept(visitor) { return visitor.visitConcreteElementA(this) }
  exclusiveMethodOfConcreteElementA() { return 'A' }
}

class ConcreteElementB extends Element {
  accept(visitor) { return visitor.visitConcreteElementB(this) }
  specialMethodOfConcreteElementB() { return 'B' }
}

class Visitor {
  visitConcreteElementA(element) { }
  visitConcreteElementB(element) { }
}

class ConcreteVisitor1 extends Visitor {
  visitConcreteElementA(element) {
    print(`ConcreteVisitor1: visiting ${element.constructor.name} (${element.exclusiveMethodOfConcreteElementA()})`)
  }
  visitConcreteElementB(element) {
    print(`ConcreteVisitor1: visiting ${element.constructor.name} (${element.specialMethodOfConcreteElementB()})`)
  }
}

class ConcreteVisitor2 extends Visitor {
  visitConcreteElementA(element) {
    print(`ConcreteVisitor2: visiting ${element.constructor.name} (${element.exclusiveMethodOfConcreteElementA()})`)
  }
  visitConcreteElementB(element) {
    print(`ConcreteVisitor2: visiting ${element.constructor.name} (${element.specialMethodOfConcreteElementB()})`)
  }
}

const elements = [new ConcreteElementA(), new ConcreteElementB()]
const visitor1 = new ConcreteVisitor1()

print('Elements interacting with visitor1:')
elements.forEach(e => e.accept(visitor1))

print('')
const visitor2 = new ConcreteVisitor2()
print('Elements interacting with visitor2:')
elements.forEach(e => e.accept(visitor2))
