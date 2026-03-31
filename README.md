# DOTFILES

---

以下是 Dotbot 的**三大核心用法**，按从易到难排序：

---

### 1. 基础用法：软链接 (Link)

这是最常用的功能。把仓库里的文件“映射”到家目录下。

**在 `install.conf.yaml` 中写入：**

```yaml
- link:
    ~/.zshrc: zshrc             # 仓库里的 zshrc -> 映射到 ~/.zshrc
    ~/.tmux.conf: tmux.conf     # 仓库里的 tmux.conf -> 映射到 ~/.tmux.conf
    ~/.config/nvim: nvim        # 甚至可以映射整个文件夹
```

* **原理**：它相当于自动执行了 `ln -s ~/dotfiles/zshrc ~/.zshrc`。
* **优势**：你在仓库里改了文件，系统配置**实时生效**，不需要重新运行脚本。

---

### 2. 自动化脚本 (Shell)

用来处理那些“链接”搞不定的事情，比如**安装软件**或**创建目录**。

**在 `install.conf.yaml` 中写入：**

```yaml
- shell:
  - [git submodule update --init --recursive, 正在同步插件子模块]
  - command: bash scripts/setup_env.sh
    description: "执行你之前那个安装 zsh 和 tmux 的大脚本"
    stdout: true
    stderr: true
```

* **注意**：`shell` 模块非常适合运行你之前写好的那个包含 `apt install` 和 `crontab` 的脚本。

---

### 3. 目录清理 (Clean)

如果你删除了仓库里的某个配置，但家目录下的软链接还在（变成了死链接），这个功能可以帮你删掉它们。

```yaml
- clean:
    ~/:
      recursive: false  # 检查家目录下的死链接并清理
```

---

### 🚀 你的“实战一键部署”流程

当你以后去了一台**新电脑**，或者重装了系统，你只需要：


```bash
git clone --recursive https://github.com/你的用户名/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash ./install 
```

---

### 💡 给你的进阶小贴士

* **路径问题**：在 YAML 里，左边是**目的地**（通常带 `~/`），右边是**源文件**（相对于 `install.conf.yaml` 的路径）。
* **参数配置**：建议在 `defaults` 里开启 `relink: true`。这样如果你手动改了软链接，Dotbot 每次运行都会把它纠正回来。
* **权限设定**：如果你的脚本需要执行权限，可以在 YAML 里加一个 `chmod` 的 `shell` 命令，或者直接在 git 仓库里 `chmod +x`。

---

### 接下来建议你做的事

1. 把你那段 **“身份校验 + 安装软件 + Crontab”** 的逻辑存入 `scripts/setup_env.sh`。
2. 把你理想中的 **`.zshrc`**（包含那个 Tmux 自动启动块）直接存为仓库根目录下的 `zshrc` 文件。
3. 运行一次 `./install`，看看你的 `~/.zshrc` 是不是已经变成了一个指向仓库的箭头？

**需要我帮你把那个“带 Tmux 自动启动逻辑”的完整 `zshrc` 内容写出来供你直接复制吗？**

---

## 验证 

- 查看当前 shell `echo $SHELL`
- 查看别名 `alias rm`