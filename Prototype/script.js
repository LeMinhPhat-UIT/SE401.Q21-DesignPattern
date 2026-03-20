function print(str) { console.log(str) }

class Prototype {
  constructor() {
    this.primitive = null;
    this.component = null;
    this.circularReference = null;
  }

  clone() {
    const clone = Object.create(Object.getPrototypeOf(this));
    clone.primitive = this.primitive;
    clone.component = Object.assign({}, this.component);
    clone.circularReference = {
      ...this.circularReference,
      prototype: { ...this }
    };
    return clone;
  }
}

class ComponentWithBackReference {
  constructor(prototype) {
    this.prototype = prototype;
  }
}

function client() {
  print(" Prototype Pattern Demo \n");

  const p1 = new Prototype();
  p1.primitive = 245;
  p1.component = { date: new Date() };
  p1.circularReference = new ComponentWithBackReference(p1);

  const p2 = p1.clone();

  print("Primitive field values:");
  print(`p1 primitive: ${p1.primitive}`);
  print(`p2 primitive: ${p2.primitive}`);
  
  if (p1.primitive === p2.primitive) {
    print("✓ Primitive values are the same\n");
  } else {
    print("✗ Primitive values are different\n");
  }

  print("Component field values:");
  print(`p1 component: ${p1.component.date}`);
  print(`p2 component: ${p2.component.date}`);
  
  if (p1.component === p2.component) {
    print("✗ Component objects are the same (shallow copy)");
  } else {
    print("✓ Component objects are different (deep copy)\n");
  }

  print("Circular reference:");
  if (p1.circularReference === p2.circularReference) {
    print("✗ Circular references are the same");
  } else {
    print("✓ Circular references are different");
  }
  
  if (p1.circularReference.prototype === p2.circularReference.prototype) {
    print("✗ Circular reference prototypes are the same");
  } else {
    print("✓ Circular reference prototypes are different\n");
  }

  print("Changing p2 primitive value...");
  p2.primitive = 999;
  print(`p1 primitive: ${p1.primitive}`);
  print(`p2 primitive: ${p2.primitive}`);
  print("✓ Changes to p2 don't affect p1");
}

client();
