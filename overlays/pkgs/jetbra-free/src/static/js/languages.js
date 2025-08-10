
const translations = {
    en: {
        searchPlaceholder: "Search for IDE or plugin...",
        instructions: "Instructions for use",
        chooseIde: "Choose the IDE",
        choosePlugins: "Choose the Plugins",
        licenseeInfo: "Licensee Information",
        enterLicenseeInfo: "Please enter licensee information",
        submit: "Submit",
        close: "Close",
        clickToGenerate: "Click to crack and generate a license",
        freeTag: "Free for non-commercial use",
        clickCard: "Click to generate a license",
        cracked: "Cracked",
        recover: "Recover",
        licenseCopied: "License copied! ✅",
        crackedMsg: "Cracked successfully, ja-netfilter injected ✅",
        crackedFailed: "Crack failed",
        recoverMsg: "Recovered successfully, crack removed",
        recoverFailed: "Recovery failed",
        requestFailed: "Request failed",
    },
    zh: {
        searchPlaceholder: "搜索 IDE 或插件...",
        instructions: "使用说明",
        chooseIde: "选择 IDE",
        choosePlugins: "选择插件",
        licenseeInfo: "授权信息",
        enterLicenseeInfo: "请输入授权信息",
        submit: "提交",
        close: "关闭",
        clickToGenerate: "点击生成授权码",
        freeTag: "免费用于非商业用途",
        clickCard: "点击生成授权码",
        cracked: "已破解",
        recover: "还原",
        licenseCopied: "授权码已复制！✅",
        crackedMsg: "破解成功，已注入 ja-netfilter ✅",
        crackedFailed: "破解失败",
        recoverMsg: "已还原，破解内容已移除",
        recoverFailed: "还原失败",
        requestFailed: "请求出错",
    }
};

let currentLang = 'en';

function toggleLanguage() {
    currentLang = currentLang === 'zh' ? 'en' : 'zh';
    updatePageLanguage();
}

function updatePageLanguage() {
    const t = translations[currentLang];

    document.getElementById('search-box').placeholder = t.searchPlaceholder;

    document.querySelector('h2').textContent = t.chooseIde;
    document.querySelectorAll('h2')[1].textContent = t.choosePlugins;

    document.querySelector('#form .title').textContent = t.licenseeInfo;
    document.querySelector('#form .subtitle').textContent = t.enterLicenseeInfo;
    document.querySelector('#form .submit').textContent = t.submit;

    document.querySelector('#form-info .title').textContent = t.instructions;
    document.querySelector('#form-info .submit').textContent = t.close;

    document.querySelectorAll('.license-key').forEach(el => {
        el.textContent = t.clickToGenerate;
    });

    document.querySelectorAll('[data-test="tag"]').forEach(el => {
        el.textContent = t.freeTag;
    });

    document.querySelectorAll('.license-key').forEach(el => {
        el.textContent = t.clickCard;
    });
    document.querySelectorAll('.ribbon').forEach(el => {
        if (el.classList.contains('recover')) {
            el.textContent = t.recover;
            el.setAttribute('data-hover-text', t.cracked);
        } else {
            el.textContent = t.cracked;
            el.setAttribute('data-hover-text', t.recover);
        }
    });
}
document.addEventListener('DOMContentLoaded', () => {
    updatePageLanguage();
});