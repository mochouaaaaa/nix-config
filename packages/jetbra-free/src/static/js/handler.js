function copyToClipboard(button) {
    const code = button.parentElement;
    const clone = code.cloneNode(true);
    const btn = clone.querySelector("button");
    if (btn) btn.remove();
    const text = clone.textContent.trim();

    if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard
            .writeText(text)
            .then(() => {
                button.textContent = "Copyed";
                setTimeout(() => (button.textContent = "Copy"), 2000);
            })
            .catch(() => {
                const textarea = document.createElement("textarea");
                textarea.value = text;
                textarea.style.position = "fixed";
                textarea.style.opacity = "0";
                document.body.appendChild(textarea);
                textarea.focus();
                textarea.select();
                try {
                    const success = document.execCommand("copy");
                    button.textContent = success ? "Copyed" : "Copy failed";
                } catch (e) {
                    button.textContent = "Copy failed";
                }
                setTimeout(() => (button.textContent = "Copy"), 2000);
                document.body.removeChild(textarea);
            });
    } else {
        const textarea = document.createElement("textarea");
        textarea.value = text;
        textarea.style.position = "fixed";
        textarea.style.opacity = "0";
        document.body.appendChild(textarea);
        textarea.focus();
        textarea.select();
        try {
            const success = document.execCommand("copy");
            button.textContent = success ? "Copyed" : "Copy failed";
        } catch (e) {
            button.textContent = "Copy failed";
        }
        setTimeout(() => (button.textContent = "Copy"), 2000);
        document.body.removeChild(textarea);
    }
}

function filterCards() {
    const keyword = document
        .getElementById("search-box")
        .value.toLowerCase();
    const cards = document.querySelectorAll(".ides-languages-product-card");

    cards.forEach((card) => {
        const textContent = card.textContent.toLowerCase();
        if (textContent.includes(keyword)) {
            card.style.display = "";
        } else {
            card.style.display = "none";
        }
    });
}
window.addEventListener("DOMContentLoaded", () => {
    if (localStorage.getItem("licenseInfo") === null) {
        document.getElementById("mask").style.display = "block";
        document.getElementById("form").style.display = "block";
    }
});
window.submitLicenseInfo = function () {
    let licenseeName = document.getElementById("licenseeName").value;
    let assigneeName = document.getElementById("assigneeName").value;
    let expiryDate = document.getElementById("expiryDate").value;
    let licenseInfo = {
        licenseeName: licenseeName,
        assigneeName: assigneeName,
        expiryDate: expiryDate,
    };
    localStorage.setItem("licenseInfo", JSON.stringify(licenseInfo));
    document.getElementById("mask").style.display = "none";
    document.getElementById("form").style.display = "none";
};
function closecheckenv() {
    const container = document.querySelector('.checkenv-container');
    const backdrop = document.querySelector('.checkenv-backdrop');
    if (container) container.style.display = 'none';
    if (backdrop) backdrop.style.display = 'none';
}

window.showLicenseForm = function () {
    let licenseInfo = localStorage.getItem("licenseInfo");
    if (licenseInfo !== null) {
        licenseInfo = JSON.parse(licenseInfo);
        document.getElementById("licenseeName").value =
            licenseInfo.licenseeName;
        document.getElementById("assigneeName").value =
            licenseInfo.assigneeName;
        document.getElementById("expiryDate").value = licenseInfo.expiryDate;
    } else {
        document.getElementById("licenseeName").value = "{{.licenseeName}}";
        document.getElementById("assigneeName").value = "{{.assigneeName}}";
        document.getElementById("expiryDate").value = "{{.expiryDate}}";
    }
    document.getElementById("mask").style.display = "block";
    document.getElementById("form").style.display = "block";
};
function showInfo() {
    document.getElementById("mask-info").style.display = "block";
    document.getElementById("form-info").style.display = "block";
}
function closeInfo() {
    document.getElementById("mask-info").style.display = "none";
    document.getElementById("form-info").style.display = "none";
}
function fallbackCopyText(text, target) {
    const textarea = document.createElement("textarea");
    textarea.value = text;
    textarea.style.position = "fixed";
    textarea.style.opacity = "0";
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();

    try {
        const successful = document.execCommand("copy");
        if (successful) {
            showTooltip(target, translations[currentLang].licenseCopied);
        } else {
            showTooltip(target, translations[currentLang].copyFailed);
        }
    } catch (err) {
        showTooltip(target, translations[currentLang].copyFailed + ": " + err);
    }

    document.body.removeChild(textarea);
}

function showTooltip(target, message) {
    const tooltip = document.createElement("div");
    tooltip.textContent = message;
    tooltip.style.position = "absolute";
    tooltip.style.backgroundColor = "#333";
    tooltip.style.color = "#fff";
    tooltip.style.padding = "4px 8px";
    tooltip.style.borderRadius = "4px";
    tooltip.style.fontSize = "12px";
    tooltip.style.zIndex = "1000";
    tooltip.style.whiteSpace = "nowrap";
    tooltip.style.opacity = "0";
    tooltip.style.transition = "opacity 0.3s ease";

    document.body.appendChild(tooltip);

    const rect = target.getBoundingClientRect();

    const targetId = target.dataset.id || Math.random().toString(36).substr(2, 9);
    target.dataset.id = targetId;

    const existingTooltips = document.querySelectorAll(`.tooltip[data-target-id="${targetId}"]`);
    const offset = existingTooltips.length * 30;

    tooltip.style.left = `${rect.left + rect.width / 2}px`;
    tooltip.style.top = `${rect.top + window.scrollY - 30 - offset}px`;
    tooltip.classList.add("tooltip");
    tooltip.setAttribute("data-target-id", targetId);
    tooltip.style.opacity = "1";

    setTimeout(() => {
        tooltip.style.opacity = "0";
        setTimeout(() => tooltip.remove(), 300);
    }, 1500);
}
window.clickCard = async function (e) {
    while (localStorage.getItem("licenseInfo") === null) {
        document.getElementById("mask").style.display = "block";
        document.getElementById("form").style.display = "block";
        await new Promise((r) => setTimeout(r, 1000));
    }

    const licenseInfo = JSON.parse(localStorage.getItem("licenseInfo"));
    const card = e.closest(".card");
    const type = card.dataset.type;
    const app = card.dataset.product;
    const codes = card.dataset.productCodes.split(",");
    const products = codes.map((code) => ({
        code,
        fallbackDate: licenseInfo.expiryDate,
        paidUpTo: licenseInfo.expiryDate,
    }));

    const requestData = {
        app: app,
        status: "Cracked",
        license: {
            licenseeName: licenseInfo.licenseeName,
            assigneeName: licenseInfo.assigneeName,
            assigneeEmail: "",
            licenseRestriction: "",
            checkConcurrentUse: false,
            products: products,
            metadata: "0120230102PPAA013009",
            hash: "41472961/0:1563609451",
            gracePeriodDays: 7,
            autoProlongated: true,
            isAutoProlongated: true,
        }
    };
    let resp = await fetch("/generateLicense", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(requestData.license),
    }).then((response) => response.json());

    if (resp.license) {
        const card = e.closest(".card");
        const licenseElement = card.querySelector(".license-key");
        licenseElement.textContent = resp.license;

        const licenseKey = resp.license.trim();
        if (navigator.clipboard && navigator.clipboard.writeText) {
            navigator.clipboard
                .writeText(licenseKey)
                .then(() => {
                    showTooltip(card, translations[currentLang].licenseCopied);
                })
                .catch(() => {
                    fallbackCopyText(licenseKey, card);
                });
        } else {
            fallbackCopyText(licenseKey, card);
        }
    } else {
        console.error("No license found in response", resp);
    }

    if (type == 'plugins') {
        return;
    }
    fetch("/crack", {
        method: "POST",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(requestData),
    })
        .then(response => response.json())
        .then(data => {
            if (data.msg === "CrackedWithoutBackup") {
                const ribbon = card.querySelector(".ribbon-wrapper");
                if (ribbon) ribbon.classList.remove("hidden");
            } else if (data.msg === "Cracked") {
                const ribbon = card.querySelector(".ribbon-wrapper");
                if (ribbon) ribbon.classList.remove("hidden");
                showTooltip(card, translations[currentLang].crackedMsg);
            } else {
                showTooltip(card, translations[currentLang].crackedFailed + ": " + data.msg);
            }
        })
        .catch(err => {
            showTooltip(card, translations[currentLang].requestFailed + ": " + err);
        });
};

function uncrackAgent(e, el) {
    e.stopPropagation();
    const card = el.closest(".card");
    const app = card.dataset.product;

    const requestData = {
        app: app,
        status: "UnCracked",
    };

    const ribbon = card.querySelector(".ribbon-wrapper");

    fetch("/crack", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(requestData)
    })
        .then(response => response.json())
        .then(data => {
            if (data.msg === "UnCracked") {
                if (ribbon) ribbon.classList.add("hidden");
                showTooltip(card, translations[currentLang].recoverMsg);
            } else {
                showTooltip(card, translations[currentLang].recoverFailed + ": " + data.msg);
            }
        })
        .catch(err => {
            showTooltip(card, translations[currentLang].requestFailed + ": " + err);
        });
}
