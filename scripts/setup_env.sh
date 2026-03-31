#!/usr/bin/env bash
set -e # 遇到错误立刻停止

echo "🚀 开始环境初始化..."

# --- 1. 安装基础工具 ---
# 这里使用 apt，如果你用 mac 可以加一个判断
if command -v apt >/dev/null; then
    echo "正在安装系统依赖..."
    sudo apt update
    sudo apt install -y zsh tmux git curl fzf tree trash-cli
fi

# --- 2. 安装 Oh My Zsh ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "正在安装 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh 已经安装，跳过切换步骤。"
fi

# --- 3. 安装 Zsh 插件 ---
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
PLUGINS_DIR="$ZSH_CUSTOM/plugins"
mkdir -p "$PLUGINS_DIR"

install_zsh_plugin() {
    local repo=$1
    local name=$2
    local target_dir="$PLUGINS_DIR/$name"

    if [ ! -d "$target_dir" ]; then
        echo "Installing $name..."
        echo "Target directory: $target_dir"

        if git clone --depth=1 "$repo" "$target_dir"; then
            echo "$name installed successfully."
        else
            echo "Failed to install $name."
            return 1
        fi
    else
        echo "$name already exists at $target_dir"
    fi
}

install_zsh_plugin https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting
install_zsh_plugin https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions

# --- 4. 配置定时任务 (垃圾桶清理) ---
# 检查是否已存在清理任务，没有则添加
if ! crontab -l 2>/dev/null | grep -q "trash-empty"; then
    (crontab -l 2>/dev/null; echo "@daily $(which trash-empty) 7") | crontab -
    echo "✅ 定时任务已配置。"
fi

# 获取当前的 Shell 路径
CURRENT_SHELL=$(grep "^$USER:" /etc/passwd | cut -d: -f7)
TARGET_SHELL=$(which zsh)

# 检查当前 Shell 是否已经是 zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "检测到当前 Shell 不是 zsh，尝试切换..."
    sudo chsh -s "$(which zsh)" "$USER"
else
    echo "✅ Shell 已经是 zsh，跳过切换步骤。"
fi

echo "✨ 环境初始化完毕！"
echo "✨ 请重新连接终端或者 source ~/.zshrc"
