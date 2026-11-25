# Agenix

该目录负责将 Agenix 与 agenix-rekey 集成到 Flake，并提供独立的密钥维护开发环境。

## 模块边界

- `config.nix`：导入 `agenix-rekey.flakeModule`，筛选并注册包含 `age.rekey` 配置的 NixOS、Darwin 和 Home Manager configurations，并导出 `packages.agenix`。
- `devshell.nix`：定义命名开发环境 `devShells.agenix`，额外提供 `age` 和 agenix-rekey 工具，并设置 `AGENIX_REKEY_ADD_TO_GIT`。
- 平台运行时配置仍由各自的 `nixos.nix`、`darwin.nix` 和 `home.nix` 模块负责；Host 通过导入对应模块启用 Secret。

Agenix 工具不会注入 `devShells.default`。普通开发环境不会因为启用仓库默认 devShell 而自动携带密钥管理工具或相关环境变量。Agenix 专用环境独立定义，不继承默认开发环境。

## 密钥重新加密

在仓库根目录进入专用开发环境：

```bash
just agenix
```

进入环境后执行：

```bash
agenix rekey -a
```

也可以不进入交互式环境，直接执行完整命令：

```bash
nix develop .#agenix --command agenix rekey -a
```

当前 `justfile` 只提供 `just agenix` 用于进入专用环境，没有 `just rekey` 或 `just rekey-status` 配方。不要使用不存在的 Just 命令。

重新加密完成后，检查工作区变化：

```bash
git status --short
git diff
```

重新加密只负责更新配置的 Secret 密文，不负责部署或激活 NixOS / Darwin 系统。

## 安全注意事项

- Master Identity 的明文内容不得进入 Git 或 Nix Store。
- rekey 产生的密文和配置变更应在提交前检查 `git status` 与 diff。
- `AGENIX_REKEY_ADD_TO_GIT` 允许工具将生成的文件加入 Git；这不替代人工检查，也不意味着应提交明文 Secret。
