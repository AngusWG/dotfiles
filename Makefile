# 完整的 Makefile 示例
.PHONY: install format update

# 一键安装：直接调用 dotbot
install:
	chmod +x ./install
	bash ./install

# 格式化：统一换行符
format:
	find . -type f -not -path '*/.*/*' -exec dos2unix {} +

update:
	git fetch --all
	git reset --hard origin/main
	bash ./install

update-d:
	git fetch --all
	git reset --hard origin/develop
	bash ./install

ud: update-d

u: update

i: install
