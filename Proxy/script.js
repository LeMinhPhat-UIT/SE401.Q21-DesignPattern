function print(message) {
    console.log(message);

    const output = document.getElementById("output");
    if (output) {
        output.textContent += `${message}\n`;
    }
}

class HighResolutionImage {
    constructor(fileName) {
        this.fileName = fileName;
        this.loadFromDisk();
    }

    loadFromDisk() {
        print(`[RealSubject] Loading image '${this.fileName}' from disk...`);
    }

    display() {
        print(`[RealSubject] Displaying '${this.fileName}'.`);
    }
}

class ImageProxy {
    constructor(fileName, role) {
        this.fileName = fileName;
        this.role = role;
        this.realImage = null;
    }

    hasAccess() {
        return this.role === "Admin" || this.role === "Editor";
    }

    display() {
        print(`[Proxy] Incoming request from role='${this.role}'.`);

        if (!this.hasAccess()) {
            print("[Proxy] Access denied.");
            return;
        }

        if (this.realImage === null) {
            print("[Proxy] Real image not initialized yet. Creating now...");
            this.realImage = new HighResolutionImage(this.fileName);
        } else {
            print("[Proxy] Reusing cached RealSubject instance.");
        }

        this.realImage.display();
        print("[Proxy] Request completed.\n");
    }
}

function runGuestDemo() {
    const guestImage = new ImageProxy("architecture.png", "Guest");
    guestImage.display();
}

function runAdminDemo() {
    const adminImage = new ImageProxy("architecture.png", "Admin");
    adminImage.display();
}

function runAdminTwiceDemo() {
    const adminImage = new ImageProxy("architecture.png", "Admin");
    adminImage.display();
    adminImage.display();
}

function bindEvents() {
    const btnGuest = document.getElementById("btnGuest");
    const btnAdmin = document.getElementById("btnAdmin");
    const btnAdminTwice = document.getElementById("btnAdminTwice");
    const btnClear = document.getElementById("btnClear");

    if (btnGuest) btnGuest.addEventListener("click", runGuestDemo);
    if (btnAdmin) btnAdmin.addEventListener("click", runAdminDemo);
    if (btnAdminTwice) btnAdminTwice.addEventListener("click", runAdminTwiceDemo);
    if (btnClear) {
        btnClear.addEventListener("click", () => {
            const output = document.getElementById("output");
            if (output) {
                output.textContent = "";
            }
            print("[System] Log cleared.");
        });
    }
}

document.addEventListener("DOMContentLoaded", () => {
    bindEvents();

    print("Proxy demo ready.");
    print("Auto run quick scenario:");

    runGuestDemo();
    runAdminTwiceDemo();
});
