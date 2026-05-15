function print(str) { console.log(str) }

class Handler {
  setNext(handler) { this.nextHandler = handler; return handler; }
  handle(req) { if (this.nextHandler) return this.nextHandler.handle(req); return null; }
}

class MonkeyHandler extends Handler {
  handle(req) {
    if (req === 'Banana') return `Monkey: I'll eat the ${req}.`;
    return super.handle(req);
  }
}

class SquirrelHandler extends Handler {
  handle(req) {
    if (req === 'Nut') return `Squirrel: I'll eat the ${req}.`;
    return super.handle(req);
  }
}

class DogHandler extends Handler {
  handle(req) {
    if (req === 'MeatBall') return `Dog: I'll eat the ${req}.`;
    return super.handle(req);
  }
}

function clientCode(handler) {
  const foods = ['Nut', 'Banana', 'Cup of coffee'];
  for (const food of foods) {
    print(`Client: Who wants a ${food}?`);
    const result = handler.handle(food);
    result ? print(`  ${result}`) : print(`  ${food} was left untouched.`);
  }
}

const monkey = new MonkeyHandler();
const squirrel = new SquirrelHandler();
const dog = new DogHandler();

monkey.setNext(squirrel).setNext(dog);

print('Chain: Monkey > Squirrel > Dog\n');
clientCode(monkey);
print('');

print('Subchain: Squirrel > Dog\n');
clientCode(squirrel);
