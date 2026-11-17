# NixOS 安装指南

本文记录使用仓库内的 `install-vm` App，通过 SSH 将现有 Ubuntu/Linux 主机安装为 `mochou@vm` NixOS Host 的流程，并重点说明目标机器无法访问 GitHub 时如何提供本地 kexec 安装包。

> [!CAUTION]
> 安装会运行 Host 对应的 Disko 配置，重新分区并格式化目标磁盘。目标磁盘上的 Ubuntu、EFI、/boot、LVM、文件和其他数据都会被销毁。执行前必须核对 SSH 地址和磁盘设备，确认目标机没有需要保留的数据。

## 1. 安装目标与磁盘布局

当前安装入口：

- Flake Host：`mochou@vm`
- 系统架构：`x86_64-linux`
- 安装 App：`nix run .#install-vm`
- 默认 SSH 目标：`root@192.168.122.246`
- 磁盘设备：`/dev/vda`（由 `hosts/mochou@vm/disk-config.nix` 声明）

当前 Disko 配置在目标磁盘上创建 GPT 分区：

| 分区 | 大小 | 用途 |
| --- | ---: | --- |
| EFI System Partition | 约 1 GiB | FAT32，挂载到 `/boot` |
| swap | 10 GiB | Linux swap |
| root | 剩余空间 | Btrfs |

Btrfs 中创建以下子卷：

- `/nix`：Nix store 和相关数据所在文件系统。
- `/@rootfs`：挂载到 `/nix/persistence`。
- `/@home`：挂载到 `/nix/persistence/home`。
- `/@var`：挂载到 `/nix/persistence/var`。
- 顶层子卷挂载到 `/btr_pool`，供管理使用。

**不要把这份 Host 配置直接用于磁盘布局不同、设备名不是 `/dev/vda` 或需要保留数据的机器。** 修改目标设备时，应先审查并修改对应 Host 的 Disko 配置。

## 2. 前置条件

### 部署机

- 已安装 Nix，并启用 Flakes。
- 仓库已检出，Flake inputs 可用。
- 能构建目标 `x86_64-linux` 的 NixOS 系统和 Disko 配置。若使用 `--build-on local`，部署机必须具备相应构建能力；macOS 等非 Linux 部署机需要配置可用的 Linux builder，或改用能够构建该目标的 Linux 部署机。
- 能通过 SSH 访问目标机。

### 目标机

- 正在运行 x86-64 Linux（例如 Ubuntu），并支持 kexec。
- 至少有 1.5 GiB 可用物理内存（swap 不计入）。
- root SSH 公钥认证可用，且 root 可以执行远程命令。
- 目标机和部署机之间的 SSH 网络连接在 kexec 重启到安装环境后仍然可达。
- 使用 kexec 时，固件 Secure Boot 应关闭。
- 目标机不需要访问 GitHub 或 Nix binary cache；安装闭包由部署机经 SSH 传输。目标机仍需要与部署机保持网络连通。

nixos-anywhere 不支持通过 Wi-Fi 完成此类安装。网络、路由和 SSH 端口必须在临时安装环境启动后仍可用。

## 3. 配置 root SSH 公钥

在目标 Ubuntu 上准备 root 的 authorized_keys。将部署机的**公钥**追加到文件，不要复制私钥：

```bash
sudo install -d -m 700 -o root -g root /root/.ssh
echo '<DEPLOYMENT_PUBLIC_KEY>' | sudo tee -a /root/.ssh/authorized_keys
sudo chmod 600 /root/.ssh/authorized_keys
sudo chown root:root /root/.ssh/authorized_keys
```

从部署机测试非交互 root SSH。若使用 Kitty，交互式 `ssh` 可能是 `kitty +kitten ssh` 的 alias；测试时应调用实际 OpenSSH 可执行文件，绕过 Kitty 集成：

```bash
SSH_BIN="$(whence -p ssh)"
"$SSH_BIN" -T root@<TARGET_IP> 'id'
```

预期输出包含：

```text
uid=0(root) gid=0(root) groups=0(root)
```

如果这里失败，先修复 SSH 公钥认证、root 登录权限或 SSH 启动脚本，不要继续安装。

## 4. 目标机无法访问 GitHub：使用本地 kexec 包

nixos-anywhere 默认会从 nix-community/nixos-images 的 GitHub Release 下载 kexec 安装包。如果目标机无法访问 GitHub，可以在部署机上通过可用的网络、代理或可信镜像下载同一个安装包，再通过 `--kexec` 指定本地文件。nixos-anywhere 会先将该文件上传到目标机，然后使用它启动临时 NixOS 安装环境。

### 4.1 下载到部署机

本次安装日志中默认请求的文件是：

`nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz`

对应 Release 路径为 `nixos-25.11`。下载时应保持文件名、架构和 Release 版本与本次 nixos-anywhere 请求一致。

```bash
mkdir -p .cache/nixos-anywhere

KEXEC_URL='https://<可访问的镜像域名>/nix-community/nixos-images/releases/download/nixos-25.11/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz'

curl -fL --retry 3 "$KEXEC_URL" \
  -o .cache/nixos-anywhere/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz
```

将 `<可访问的镜像域名>` 替换为自己实际可用、可信的 GitHub Release 镜像地址。镜像服务的 URL 路径规则可能不同，应以镜像服务说明为准。也可以通过浏览器或 HTTP 代理下载，再把文件放到上述本地路径。

下载后检查文件：

```bash
file .cache/nixos-anywhere/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz
ls -lh .cache/nixos-anywhere/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz
sha256sum .cache/nixos-anywhere/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz
```

应从对应的官方 [nixos-images Release](https://github.com/nix-community/nixos-images/releases) 获取该资产的校验值，并与本地 `sha256sum` 输出比对。不要仅凭文件名或下载成功就信任镜像文件。

### 4.2 使用本地文件启动安装

在仓库根目录执行：

```bash
INSTALL_HOST=root@<TARGET_IP> \
  nix run .#install-vm -- \
  --kexec "$PWD/.cache/nixos-anywhere/nixos-kexec-installer-noninteractive-x86_64-linux.tar.gz" \
  --build-on local \
  --no-substitute-on-destination
```

参数说明：

- `INSTALL_HOST`：覆盖 App 默认的 SSH 目标地址。
- `--kexec <path>`：使用部署机上的本地 kexec tarball；nixos-anywhere 会通过 SSH 上传，不再让目标机从 GitHub 下载。
- `--build-on local`：要求在部署机侧构建安装所需的系统闭包。部署机必须能构建 `x86_64-linux`；如果不能，应先配置 Linux builder 或换用 Linux 部署机。
- `--no-substitute-on-destination`：不要求目标机从其 substituters 获取缺失的闭包。

仓库的 `install-vm` App 会打印目标地址，并要求输入完整 SSH 目标进行二次确认。核对无误后，输入提示中的完整目标地址继续。

> [!IMPORTANT]
> 本地 kexec 文件只解决“目标机下载 GitHub 引导镜像”这一环节。它不代表整个安装过程完全离线：部署机仍需具备 Flake inputs、所需源代码和构建依赖（可通过网络或本地缓存取得），并完成目标系统构建；随后通过 SSH 将所需闭包传给目标机。目标机不需要访问公共互联网，但必须能与部署机通信。

## 5. 安装过程与验证

nixos-anywhere 默认依次执行以下阶段：

1. `kexec`：通过 SSH 上传并启动临时 NixOS 安装环境。
2. `disko`：按 Host 的 Disko 配置销毁旧分区并创建新文件系统。
3. `install`：安装 Flake 中的 `mochou@vm` 系统配置。
4. `reboot`：卸载安装文件系统并重启目标机。

安装期间不要关闭部署机或目标 VM。kexec 后 SSH 连接可能中断，工具会等待临时安装环境启动后重新连接。

首次启动后，从部署机验证：

```bash
ssh root@<TARGET_IP> 'nixos-version; lsblk -f; findmnt / /boot /nix'
```

再检查 systemd 服务：

```bash
ssh root@<TARGET_IP> 'systemctl --failed'
```

如果系统服务启动失败，先查看对应服务日志：

```bash
ssh root@<TARGET_IP> 'journalctl -b -u <UNIT_NAME> --no-pager -n 100'
```

安装完成后，日常系统更新应使用仓库配置的 deploy-rs 流程，不要再次运行 `install-vm`。重新运行安装 App 会再次执行 Disko 并清空目标磁盘。

## 6. 相关文件与上游文档

仓库内相关文件：

- `modules/flake/apps.nix)：`install-vm` App、目标地址覆盖和破坏性确认。
- `hosts/mochou@vm/default.nix`：NixOS Host 组合与 SSH 配置。
- `hosts/mochou@vm/disk-config.nix`：目标磁盘分区、文件系统和 Btrfs 子卷。
- `modules/flake/deploy.nix`：安装完成后的 deploy-rs 日常部署配置。

上游文档：

- [nixos-anywhere Quickstart](https://nix-community.github.io/nixos-anywhere/quickstart.html)
- [nixos-anywhere: Using your own kexec image](https://nix-community.github.io/nixos-anywhere/howtos/custom-kexec.html)
- [nixos-anywhere CLI Reference](https://nix-community.github.io/nixos-anywhere/reference.html)
- [nixos-images Releases](https://github.com/nix-community/nixos-images/releases)
