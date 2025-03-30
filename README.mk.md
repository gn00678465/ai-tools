# AI-Tools 模組化 Makefile 系統

這是一個模組化的 Makefile 系統，用於管理多個 AI 工具的環境設定與執行。

## 檔案結構

```
ai-tools/
├── Makefile      # 主入口檔，僅包含 include 指令
├── common.mk     # 通用目標與說明
├── litellm.mk    # LiteLLM 相關設定與命令
├── webui.mk      # Web-UI 相關設定與命令
├── langmanus.mk  # Langmanus 相關設定與命令
├── litellm/      # LiteLLM 應用目錄
├── web-ui/       # Web-UI 應用目錄
└── langmanus/    # Langmanus 應用目錄
```

## 優點

- **模組化設計**: 每個應用都有自己的 `.mk` 檔案，易於管理和維護
- **擴展性強**: 添加新應用只需創建新的 `.mk` 檔案並在主 Makefile 中引入
- **結構清晰**: 各模組功能分明，職責單一
- **相互獨立**: 各應用間配置互不干擾

## 使用方式

使用方式與之前完全相同，但代碼更加模組化和易於維護:

```bash
# 查看幫助
make help

# 設定所有環境
make setup-all

# 執行 LiteLLM
make litellm-run

# 執行 Web-UI
make webui-run

# 執行 Langmanus
make langmanus-run

# 清理暫存檔
make clean
```

## 如何添加新應用

1. 創建新的 `.mk` 檔案 (以 myapp.mk 為例):

```makefile
# myapp.mk
MYAPP_DIR = myapp
MYAPP_VENV = $(MYAPP_DIR)/.venv

.PHONY: myapp-run myapp-setup myapp-clean
myapp-run: myapp-setup
	@echo "執行 MyApp"
	@source $(MYAPP_VENV)/bin/activate && cd $(MYAPP_DIR) && python app.py

myapp-setup:
	@echo "設定 MyApp 環境"
	# 環境設定命令...

myapp-clean:
	@echo "清理 MyApp 暫存檔"
	@find $(MYAPP_DIR) -name "__pycache__" -exec rm -rf {} +
```

2. 在主 Makefile 中添加:

```makefile
include myapp.mk
```

3. 在 common.mk 中更新 help、setup-all 和 clean 目標
