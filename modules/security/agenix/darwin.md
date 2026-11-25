# Darwin 上的 agenix

Darwin Host 通过 Home Manager 的 `activate-agenix` LaunchAgent 挂载用户 Secret。正常情况下，Home Manager activation 会安装并加载对应的 LaunchAgent plist；无需每次切换系统后手动执行以下操作。

## 修复未更新的 activate-agenix

### 现象

修改 Home Manager 的 agenix Secret 配置并切换 Darwin 后，当前 generation 已包含新的 Secret，生成的 `agenix-home-manager-mount-secrets` 脚本也包含这些 Secret，但运行目录中仍缺少对应文件。

检查时可能发现：

- Home Manager 当前 generation 中的 LaunchAgent plist 指向新生成的挂载脚本；
- `~/Library/LaunchAgents/org.nix-community.home.activate-agenix.plist` 已经是新 plist；
- launchd 中已加载的 `org.nix-community.home.activate-agenix` 仍引用旧 Store 路径下的脚本。

### 原因

LaunchAgent 的 plist 文件和 launchd 当前进程管理器中加载的 Job Definition 是两份状态。更新磁盘上的 plist，并不等于 launchd 已经重新加载它。

Home Manager activation 会比较新 generation 的 plist 与用户目录中的 plist，并在文件变化时尝试执行 `bootout`、安装 plist 和 `bootstrap`。如果磁盘文件已经更新、但 launchd 仍保留旧 Job Definition，单纯再次比较 plist 可能无法修复这种状态不一致。

本次故障中，手动卸载并重新加载 LaunchAgent 后，`launchctl print` 显示的脚本路径更新为当前 generation 的脚本，缺失的 Secret 随后成功生成。这里记录的是已验证的恢复方式；尚不能据此断定最初的自动 reload 失败由 Home Manager 的哪一步导致。

### 手动恢复

在 Darwin 用户会话中执行：

```bash
uid=$(id -u)
label="gui/$uid/org.nix-community.home.activate-agenix"

launchctl bootout "$label"

launchctl bootstrap "gui/$uid" \
  "$HOME/Library/LaunchAgents/org.nix-community.home.activate-agenix.plist"

launchctl kickstart -k "$label"
```

这三个步骤分别用于：

1. 从当前 GUI 用户的 launchd domain 卸载旧 Job；
2. 从磁盘上的 plist 重新注册 LaunchAgent；
3. 强制启动 Agent，立即执行 agenix Secret 挂载脚本。

### 验证

确认 launchd 已加载当前 generation 对应的脚本：

```bash
launchctl print "gui/$(id -u)/org.nix-community.home.activate-agenix"
```

检查输出中的 `arguments`，确认 `agenix-home-manager-mount-secrets` 指向预期的新 Store 路径。然后检查 Secret 目录：

```bash
ls -la "$(getconf DARWIN_USER_TEMP_DIR)/agenix/"
```

确认需要的 Secret 文件存在，并具有预期权限。

> 这是发生 LaunchAgent 状态不一致时的手动恢复步骤，不应无条件加入每次 Darwin activation。正常情况下仍由 Home Manager 管理 LaunchAgent 的安装与加载。
