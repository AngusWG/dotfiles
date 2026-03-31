# 完整的 Makefile 示例
.PHONY: install format update

# 一键安装：直接调用 dotbot
install:
	chmod +x ./install
	bash ./install

# 格式化：统一换行符
format:
	find . -type f -not -path '*/.*/*' -exec dos2unix {} +

# 更新：同步远程代码和子模块
update:
	git fetch --all
	git reset --hard origin/main
	bash ./install

u: update

i: install
