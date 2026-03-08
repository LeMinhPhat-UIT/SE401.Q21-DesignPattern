function print(str) { console.log(str) }

class Target { req() { return "Target: The default target's behavior."; } }
class Service { wtf() { return '.eetpadA eht fo roivaheb laicepS'; } }

class Adapter extends Target {
  adaptee; constructor(adaptee) { super(); this.adaptee = adaptee; }
  req() { return "Adapter: " + this.adaptee.wtf().split('').reverse().join(''); }
}

function client(fun) { print(fun.req()) }

const tgt = new Target()
const svc = new Service()
const adp = new Adapter(svc)

client(tgt)
print("Service: " + svc.wtf())
client(adp);