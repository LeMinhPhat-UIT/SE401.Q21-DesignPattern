function print(str) { console.log(str) }

class Product1 { parts = []; list() { print(this.parts) } }

class Builder { addA() { }; addB() { }; addC() { } }

class ConcreteBuilder1 extends Builder {
    product; constructor() { super(); this.reset() }; reset() { this.product = new Product1() }

    build() { const result = this.product; this.reset(); return result }

    addA() { this.product.parts.push('PartA1') }
    addB() { this.product.parts.push('PartB1') }
    addC() { this.product.parts.push('PartC1') }
}

class Director {
    builder; set(builder) { this.builder = builder }

    build_min() { this.builder.addA() }
    build_max() { this.builder.addA(); this.builder.addB(); this.builder.addC() }
}

const drc = new Director(); const bld = new ConcreteBuilder1(); drc.set(bld)

print('Standard basic product:')
drc.build_min()
bld.build().list()

print('Standard full featured product:')
drc.build_max()
bld.build().list()

print('Custom product:')
bld.addA()
bld.addB()
bld.build().list()
