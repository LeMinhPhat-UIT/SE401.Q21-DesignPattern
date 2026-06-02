function print(message) {
    console.log(message);

    const output = document.getElementById("output");
    if (output) {
        output.textContent += `${message}\n`;
    }
}

class StandardShipping {
    calculateFee(orderTotal, weightKg, distanceKm) {
        return 15000 + weightKg * 2000 + distanceKm * 500;
    }

    getName() {
        return "StandardShipping";
    }
}

class ExpressShipping {
    calculateFee(orderTotal, weightKg, distanceKm) {
        return 30000 + weightKg * 3000 + distanceKm * 900;
    }

    getName() {
        return "ExpressShipping";
    }
}

class SameDayShipping {
    calculateFee(orderTotal, weightKg, distanceKm) {
        if (distanceKm > 20) {
            throw new Error("Same-day only supports distance <= 20km");
        }
        return 50000 + weightKg * 3500 + distanceKm * 1200;
    }

    getName() {
        return "SameDayShipping";
    }
}

class CheckoutContext {
    constructor(strategy) {
        this.strategy = strategy;
    }

    setStrategy(strategy) {
        this.strategy = strategy;
        print(`[Context] Switched strategy to ${strategy.getName()}`);
    }

    calculateShipping(orderTotal, weightKg, distanceKm) {
        print(`[Context] Calculating shipping with ${this.strategy.getName()}...`);
        return this.strategy.calculateFee(orderTotal, weightKg, distanceKm);
    }
}

const SAMPLE_ORDER = {
    orderTotal: 500000,
    weightKg: 2.5,
    distanceKm: 8,
};

const context = new CheckoutContext(new StandardShipping());

function runWith(strategy) {
    context.setStrategy(strategy);

    try {
        const fee = context.calculateShipping(
            SAMPLE_ORDER.orderTotal,
            SAMPLE_ORDER.weightKg,
            SAMPLE_ORDER.distanceKm
        );
        print(`[Result] Fee = ${fee.toLocaleString("vi-VN")} VND\n`);
    } catch (error) {
        print(`[Error] ${error.message}\n`);
    }
}

function compareAll() {
    print("[Compare] Running all strategies...");
    runWith(new StandardShipping());
    runWith(new ExpressShipping());
    runWith(new SameDayShipping());
}

function bindEvents() {
    const btnStandard = document.getElementById("btnStandard");
    const btnExpress = document.getElementById("btnExpress");
    const btnSameDay = document.getElementById("btnSameDay");
    const btnCompare = document.getElementById("btnCompare");
    const btnClear = document.getElementById("btnClear");

    if (btnStandard) btnStandard.addEventListener("click", () => runWith(new StandardShipping()));
    if (btnExpress) btnExpress.addEventListener("click", () => runWith(new ExpressShipping()));
    if (btnSameDay) btnSameDay.addEventListener("click", () => runWith(new SameDayShipping()));
    if (btnCompare) btnCompare.addEventListener("click", compareAll);
    if (btnClear) {
        btnClear.addEventListener("click", () => {
            const output = document.getElementById("output");
            if (output) output.textContent = "";
            print("[System] Log cleared.");
        });
    }
}

document.addEventListener("DOMContentLoaded", () => {
    bindEvents();

    print("Strategy demo ready.");
    print(`[System] Sample order: total=${SAMPLE_ORDER.orderTotal}, weight=${SAMPLE_ORDER.weightKg}kg, distance=${SAMPLE_ORDER.distanceKm}km`);
    compareAll();
});
