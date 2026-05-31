function print(str) { console.log(str) }

class State {
  onEnter(context) { }
  onExit(context) { }
  handle(context) { }
}

class ConcreteStateA extends State {
  onEnter(context) { print('StateA: onEnter') }
  onExit(context) { print('StateA: onExit') }
  handle(context) {
    print('StateA: handle (transitioning to StateB)')
    context.transitionTo(new ConcreteStateB())
  }
}

class ConcreteStateB extends State {
  onEnter(context) { print('StateB: onEnter') }
  onExit(context) { print('StateB: onExit') }
  handle(context) {
    print('StateB: handle (transitioning to StateC)')
    context.transitionTo(new ConcreteStateC())
  }
}

class ConcreteStateC extends State {
  onEnter(context) { print('StateC: onEnter') }
  onExit(context) { print('StateC: onExit') }
  handle(context) {
    print('StateC: handle (transitioning to StateA)')
    context.transitionTo(new ConcreteStateA())
  }
}

class Context {
  state; constructor(state) { this.transitionTo(state) }

  transitionTo(state) {
    print(`Context: transition to ${state.constructor.name}`)
    if (this.state) this.state.onExit(this)
    this.state = state
    this.state.onEnter(this)
  }

  request() { this.state.handle(this) }
}

const context = new Context(new ConcreteStateA())
context.request()
print('')
context.request()
print('')
context.request()
