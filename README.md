# Dendritic Nix Configuration

个人 Nix 配置仓库，基于 **Nix Flakes、flake-parts 与 import-tree** 构建，采用模块化（Dendritic）组织方式，集中管理 NixOS、nix-darwin 与 Home Manager 配置。

## 设计目标

- **模块化组织**：按功能拆分配置，避免把所有系统设置堆在单一 Host 文件中。
- **Host 组合**：通过 `hosts/<username>@<hostname>/` 描述主机，并由 Flake 自动发现。
- **跨平台复用**：共享通用配置，同时保留 NixOS、Darwin 和 Home Manager 的平台边界。
- **声明式管理**：使用 Nix Flakes 固定依赖，通过模块组合描述系统状态。
- **可维护性**：提供统一的格式化、静态检查、Flake 检查和系统切换命令。

## 技术栈

| 组件 | 用途 |
| --- | --- |
| [Nix Flakes](https://nix.dev/concepts/flakes.html) | 依赖锁定与配置入口 |
| [flake-parts](https://github.com/hercules-ci/flake-parts) | 组织 Flake outputs |
| [import-tree](https://github.com/vic/import-tree) | 自动导入模块树 |
| [NixOS](https://nixos.org/) | Linux 系统配置 |
| [nix-darwin](https://github.com/nix-darwin/nix-darwin) | macOS 系统配置 |
| [Home Manager](https://github.com/nix-community/home-manager) | 用户环境与应用配置 |
| [agenix](https://github.com/ryantm/agenix) / [agenix-rekey](https://github.com/oddlama/agenix-rekey) | 加密秘密管理 |
| [preservation](https://github.com/nix-community/preservation) | 持久化目录与文件管理 |
| [just](https://github.com/casey/just) | 常用任务入口 |
| [nh](https://github.com/nix-community/nh) | NixOS / Darwin 构建与切换 |

## 仓库结构

~~~text
.
├── flake.nix               # Flake 入口、inputs 与模块导入
├── flake.lock              # 锁定的 Flake inputs
├── justfile                # 常用开发、检查和部署命令
├── hosts/
│   └── <username>@<hostname>/
│       ├── host.json       # class 与目标 system
│       └── default.nix     # 单台主机的模块组合与主机级设置
├── lib/                    # 自定义 Nix helper
├── modules/
│   ├── appearance/         # 外观、主题与字体
│   ├── core/               # 基础系统与通用配置
│   ├── darwin/             # macOS 平台模块
│   ├── desktop/            # 桌面环境与窗口管理器
│   ├── development/        # 开发工具与开发环境
│   ├── flake/              # Flake 层模块与配置
│   ├── hardware/           # 硬件相关配置
│   ├── programs/           # 应用程序配置
│   ├── security/           # 安全相关配置
│   └── services/           # 系统服务
├── pkgs/                   # 自定义包与包相关定义
└── secrets/                # 加密秘密文件及 rekey 相关数据
~~~

目录会随着模块演进而调整；以上结构描述的是当前仓库的主要职责划分。

## 架构说明

### Flake 入口

**flake.nix** 使用 **flake-parts.lib.mkFlake** 构建 Flake，并导入：

- flake-parts 的模块支持；
- Home Manager 的 flake-parts 集成；
- 通过 **import-tree ./modules** 自动导入的项目模块。

Flake inputs 中分别维护 Linux、稳定版 nixpkgs、Intel/macOS 对应的 nixpkgs、nix-darwin、Home Manager，以及桌面、存储和秘密管理相关依赖。具体版本以 **flake.lock** 为准。

### Host 自动发现与组合

**modules/hosts.nix** 扫描 **hosts/** 下的主机目录。目录名采用 **username@hostname**，其中后缀只是主机名（如 **nixos**、**work**、**home**），不代表操作系统类型。每个主机通过 **host.json** 声明 **class**（**nixos**、**darwin** 或 **home**）和目标 **system**。

Flake 根据 **class** 生成 **nixosConfigurations**、**darwinConfigurations** 或独立的 **homeConfigurations**。系统 nixpkgs 源根据目标架构自动选择：Intel Darwin 使用 **nixpkgs-darwin**，其他系统默认使用 **nixpkgs**。每个 Host 的 **default.nix** 负责选择功能模块并设置主机级差异。

### 功能模块

**modules/** 以功能领域组织配置，而不是把所有配置按 Host 重复存放。一个功能模块可以包含选项定义、具体配置以及必要的平台适配；Host 只需导入需要的模块。

例如，桌面环境和系统服务可以分别组合，使服务配置不必依赖某个特定桌面环境。需要跨模块共享的配置选项，应确保其声明模块被导入到同一个最终模块组合中。

### 秘密与持久化

- 敏感配置使用 agenix / agenix-rekey 管理。请勿将明文密钥、密码、令牌或解密后的秘密提交到仓库。
- 系统持久化通过 preservation 模块管理。Host 可选择启用持久化配置，功能模块也可以按需声明自身需要保留的数据。
- **modules/core/var.nix** 可能包含本机相关变量；新增文档或示例时不要复制其中的个人凭据或密码哈希。

## 环境准备

需要安装：

- Nix，并启用 Flakes 与 **nix-command**；
- **just**；
- **nh**（执行系统构建与切换时使用）；
- 检查任务所需工具：**nixfmt**、**statix**、**deadnix**。

进入仓库后，可以使用：

~~~bash
# 查看可用任务
just

# 进入项目开发环境
just dev

# 查看 Flake outputs
just show
~~~

## 常用命令

默认 Host 为 **mochou@nixos**。可以通过 **NH_HOST** 指定其他 Host，通过 **NH_FLAKE** 指定仓库路径。

### 代码质量与 Flake 检查

~~~bash
just fmt          # 格式化 Flake
just fmt-check    # 检查 Nix 格式
just lint         # 运行 statix 与 deadnix
just check        # 执行 nix flake check（不构建 derivations）
just validate     # fmt-check + lint + check
just check-build  # 执行包含构建检查的 flake check
~~~

### NixOS

~~~bash
just nixos-eval     # 求值系统 toplevel
just nixos-build    # 构建系统
just nixos-boot     # 构建并设置下次启动使用的系统
just nixos-switch   # 构建并切换到新系统
just nixos-test     # 测试切换
just nixos-repl     # 打开 Nix REPL
~~~

### nix-darwin

~~~bash
just darwin-eval
just darwin-build
just darwin-switch
just darwin-repl
~~~

### Flake inputs 更新

~~~bash
just update          # 更新所有 inputs
just update-linux    # 更新 Linux 相关 inputs
just update-darwin   # 更新 Darwin 相关 inputs
just update-desktop  # 更新桌面环境相关 inputs
just lock            # 更新 flake.lock
~~~

### 指定 Host 或仓库路径

~~~bash
NH_HOST=<username>@<hostname> just nixos-switch
NH_FLAKE=/path/to/nix-config just check
~~~

### 秘密管理

~~~bash
just rekey
just rekey-status
~~~

执行 rekey 前，请确认本机已配置所需的身份密钥和访问权限。不要在终端日志、Issue 或提交记录中暴露秘密内容。

## 添加一台主机

1. 在 **hosts/** 下创建符合 **<username>@<hostname>** 格式的目录。
2. 添加 **host.json**，声明该主机的 **class** 和 **system**。
3. 添加该 Host 的 **default.nix**，导入所需的基础模块、功能模块和用户级模块。
4. 如果是 NixOS WSL 主机，可在 **host.json** 中设置 **nixosWsl: true**。
5. 使用 **just show** 查看输出，并执行对应的 eval / check 命令验证。

示例目录：

~~~text
hosts/
└── alice@work/
    ├── host.json
    └── default.nix
~~~

## 注意事项

- 修改 Flake 输入后，检查并提交更新后的 **flake.lock**。
- 新增模块文件后，确保它已被 Git 跟踪，再运行基于 **import-tree** 的 Flake 求值。
- 不要假设定义在某个 Flake 模块命名空间中的模块会自动导入到每个 Host；模块之间需要通过明确的 **imports** 建立组合关系。
- 对于会影响系统状态的变更，先运行格式化、静态检查和 Flake 求值，再执行 switch。
- 不同平台的模块应明确平台边界，避免在不支持的平台上引用系统专属选项。

## License

本仓库主要用于个人设备的系统配置与学习参考。若计划公开复用其中的模块，请先检查各文件的许可证、第三方资源和个人化配置。
