function print(msg) {
    console.log(msg);
}

class Light {
    constructor(name) {
        this.name = name;
        this.isOn = false;
    }

    turnOn() {
        this.isOn = true;
        print(`[Receiver] ${this.name} is ON`);
    }

    turnOff() {
        this.isOn = false;
        print(`[Receiver] ${this.name} is OFF`);
    }

    status() {
        return this.isOn ? "ON" : "OFF";
    }
}

class TurnOnCommand {
    constructor(receiver) {
        this.receiver = receiver;
    }

    execute() {
        this.receiver.turnOn();
    }

    undo() {
        this.receiver.turnOff();
    }
}

class TurnOffCommand {
    constructor(receiver) {
        this.receiver = receiver;
    }

    execute() {
        this.receiver.turnOff();
    }

    undo() {
        this.receiver.turnOn();
    }
}

class RemoteControl {
    constructor() {
        this.undoStack = [];
        this.redoStack = [];
    }

    run(command) {
        command.execute();
        this.undoStack.push(command);
        this.redoStack = [];
        print(`[Invoker] undo=${this.undoStack.length}, redo=${this.redoStack.length}`);
    }

    undo() {
        if (this.undoStack.length === 0) {
            print("[Invoker] Nothing to undo");
            return;
        }
        const command = this.undoStack.pop();
        command.undo();
        this.redoStack.push(command);
        print(`[Invoker] undo=${this.undoStack.length}, redo=${this.redoStack.length}`);
    }

    redo() {
        if (this.redoStack.length === 0) {
            print("[Invoker] Nothing to redo");
            return;
        }
        const command = this.redoStack.pop();
        command.execute();
        this.undoStack.push(command);
        print(`[Invoker] undo=${this.undoStack.length}, redo=${this.redoStack.length}`);
    }
}

const light = new Light("Living Room Light");
const remote = new RemoteControl();

print("Standard execute (turn on):"); remote.run(new TurnOnCommand(light));
print("Standard execute (turn off):"); remote.run(new TurnOffCommand(light));
print("Undo:"); remote.undo();
print("Redo:"); remote.redo();

class Light {
    constructor(name) {
        this.name = name;
        this.isOn = false;
    }

    turnOn() {
        this.isOn = true;
        print(`[Receiver] ${this.name} is ON`);
    }

    turnOff() {
        this.isOn = false;
        print(`[Receiver] ${this.name} is OFF`);
    }

    status() {
        return this.isOn ? "ON" : "OFF";
    }
}

class TurnOnCommand {
    constructor(receiver) {
        this.receiver = receiver;
    }

    execute() {
        this.receiver.turnOn();
    }

    undo() {
        this.receiver.turnOff();
    }
}

class TurnOffCommand {
    constructor(receiver) {
        this.receiver = receiver;
    }

    execute() {
        this.receiver.turnOff();
    }

    undo() {
        this.receiver.turnOn();
    }
}

class RemoteControl {
    constructor() {
        this.undoStack = [];
        this.redoStack = [];
    }

    run(command) {
        command.execute();
        this.undoStack.push(command);
        this.redoStack = [];
        this.printHistory();
    }

    undo() {
        if (this.undoStack.length === 0) {
            print("[Invoker] Nothing to undo");
            return;
        }

        const command = this.undoStack.pop();
        command.undo();
        this.redoStack.push(command);
        this.printHistory();
    }

    redo() {
        if (this.redoStack.length === 0) {
            print("[Invoker] Nothing to redo");
            return;
        }

        const command = this.redoStack.pop();
        command.execute();
        this.undoStack.push(command);
        this.printHistory();
    }

    printHistory() {
        print(`[Invoker] undo=${this.undoStack.length}, redo=${this.redoStack.length}`);
    }
}

const light = new Light("Living Room Light");
const turnOn = new TurnOnCommand(light);
const turnOff = new TurnOffCommand(light);
const remote = new RemoteControl();

function bindEvents() {
    const onBtn = document.getElementById("btnOn");
    const offBtn = document.getElementById("btnOff");
    const undoBtn = document.getElementById("btnUndo");
    const redoBtn = document.getElementById("btnRedo");
    const clearBtn = document.getElementById("btnClear");

    onBtn.addEventListener("click", () => remote.run(turnOn));
    offBtn.addEventListener("click", () => remote.run(turnOff));
    undoBtn.addEventListener("click", () => remote.undo());
    redoBtn.addEventListener("click", () => remote.redo());
    clearBtn.addEventListener("click", () => {
        const output = document.getElementById("output");
        output.textContent = "";
        print(`[System] Current status: ${light.status()}`);
    });
}

document.addEventListener("DOMContentLoaded", () => {
    bindEvents();
    print("Command demo ready");
    print(`[System] Current status: ${light.status()}`);
});
