function print(str) { console.log(str) }

class Product1 { parts = []; report() { print(this.parts) } }

class Builder { reset() { }; addA() { }; addB() { }; addC() { } }

class ConcreteBuilder1 extends Builder {
    product; constructor() { super(); this.reset() };

    reset() { this.product = new Product1() }
    addA() { this.product.parts.push('PartA1') }
    addB() { this.product.parts.push('PartB1') }
    addC() { this.product.parts.push('PartC1') }

    getProd() { const result = this.product; this.reset(); return result }
}

class Director {
    builder; constructor(builder) { this.builder = builder }

    build_min() { this.builder.addA() }
    build_max() { this.builder.addA(); this.builder.addB(); this.builder.addC() }
}

const bld = new ConcreteBuilder1();
const drc = new Director(bld);

print('Standard basic product:'); drc.build_min()
bld.getProd().report()

print('Standard full featured product:'); drc.build_max()
bld.getProd().report()

print('Custom product:'); bld.addA(); bld.addB()
bld.getProd().report()
