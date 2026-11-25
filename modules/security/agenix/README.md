# Agenix

该目录负责将 Agenix 与 agenix-rekey 集成到 Flake，并提供独立的密钥维护开发环境。

## 模块边界

- `config.nix`：导入 `agenix-rekey.flakeModule`，注册需要参与 rekey 的 NixOS、Darwin 和 Home Manager configurations，并导出 `packages.agenix`。
- `devshell.nix`：定义命名开发环境 `devShells.agenix`。该环境继承通用默认 devShell，并额外提供 `age`、`agenix-rekey` 和 `AGENIX_REKEY_ADD_TO_GIT`。
- 平台运行时配置仍由各自的 `nixos/`、`darwin/` 和 `home/` 模块负责；Host 通过导入对应模块启用 Secret。

Agenix 工具不再注入 `devShells.default`，普通开发环境不会因为启用仓库的默认 devShell 而自动携带密钥管理环境变量。

## Just 命令

在仓库根目录执行：

```bash
# 进入 Agenix 专用开发环境
just agenix

# 在专用环境中运行 agenix-rekey
just rekey

# 查看 rekey 后的工作区变化
just rekey-status
```

`just rekey` 会从 Flake 根目录执行 `agenix-rekey`，并使用专用 devShell 中的工具与环境变量。它负责重新加密配置的 Secret，不负责部署或激活 NixOS / Darwin 系统。

## 安全注意事项

- Master Identity 的明文内容不得进入 Git 或 Nix Store。
- rekey 产生的密文和配置变更应在提交前检查 `git status` 与 diff。
- `AGENIX_REKEY_ADD_TO_GIT` 允许工具将生成的文件加入 Git；这不替代人工检查，也不意味着应提交明文 Secret。
