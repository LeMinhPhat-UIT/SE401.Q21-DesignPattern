function print(str) { console.log(str) }

class Mediator {
  notify(sender, event) { }
}

class Colleague {
  mediator; constructor(mediator) { this.mediator = mediator }
  send(event) { this.mediator.notify(this, event) }
  receive(event) { }
}

class ConcreteMediator extends Mediator {
  component1; component2;

  setComponent1(c1) { this.component1 = c1 }
  setComponent2(c2) { this.component2 = c2 }

  notify(sender, event) {
    if (event === 'A') {
      print('Mediator reacts on A and triggers following operations:')
      this.component2.doC()
    }
    if (event === 'D') {
      print('Mediator reacts on D and triggers following operations:')
      this.component1.doB()
      this.component2.doC()
    }
  }
}

class ConcreteComponent1 extends Colleague {
  doA() { print('Component 1 does A.'); this.send('A') }
  doB() { print('Component 1 does B.') }
}

class ConcreteComponent2 extends Colleague {
  doC() { print('Component 2 does C.') }
  doD() { print('Component 2 does D.'); this.send('D') }
}

const mediator = new ConcreteMediator()
const c1 = new ConcreteComponent1(mediator)
const c2 = new ConcreteComponent2(mediator)

mediator.setComponent1(c1)
mediator.setComponent2(c2)

print('Client triggers operation A:'); c1.doA()
print('')
print('Client triggers operation D:'); c2.doD()
