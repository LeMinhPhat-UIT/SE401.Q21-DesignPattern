function print(str) { console.log(str) }

class Component {
  constructor() {
    this.parent = null;
  }

  setParent(parent) {
    this.parent = parent;
  }

  getParent() {
    return this.parent;
  }

  add(component) { }

  remove(component) { }

  isComposite() {
    return false;
  }

  operation() { }
}

class Leaf extends Component {
  constructor(name) {
    super();
    this.name = name;
  }

  operation() {
    return `Leaf(${this.name})`;
  }
}

class Composite extends Component {
  constructor(name) {
    super();
    this.name = name;
    this.children = [];
  }

  add(component) {
    this.children.push(component);
    component.setParent(this);
  }

  remove(component) {
    const index = this.children.indexOf(component);
    if (index !== -1) {
      this.children.splice(index, 1);
      component.setParent(null);
    }
  }

  isComposite() {
    return true;
  }

  operation() {
    const results = [];
    results.push(`Branch(${this.name})[`);
    
    for (const child of this.children) {
      results.push(child.operation());
    }
    
    results.push("]");
    return results.join(" ");
  }
}

function client(component) {
  print(`RESULT: ${component.operation()}`);
}

function client2(component1, component2) {
  if (component1.isComposite()) {
    component1.add(component2);
  }
  print(`RESULT: ${component1.operation()}`);
}

print("=== Composite Pattern Demo ===\n");

print("Client: Simple tree with leaves:");
const simple = new Leaf("Simple");
client(simple);

print("\nClient: Complex tree:");
const tree = new Composite("Root");
const branch1 = new Composite("Branch1");
branch1.add(new Leaf("Leaf1-1"));
branch1.add(new Leaf("Leaf1-2"));

const branch2 = new Composite("Branch2");
branch2.add(new Leaf("Leaf2-1"));

tree.add(branch1);
tree.add(branch2);
client(tree);

print("\nClient: Combining trees:");
const branch3 = new Composite("Branch3");
branch3.add(new Leaf("Leaf3-1"));
branch3.add(new Leaf("Leaf3-2"));

client2(tree, branch3);
