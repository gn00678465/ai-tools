# 主 Makefile - AI Tools 管理工具
# 按照模組化設計拆分，每個應用都有獨立的 .mk 檔案

# 引入所有模組
include common.mk
include litellm.mk
include webui.mk
include langmanus.mk

# 此檔案作為整合入口點，只需引用各個獨立模組
# 所有具體的命令定義均放在各自的 .mk 檔案中

# 如何擴展:
# 1. 建立新的 your-app.mk 文件
# 2. 在此處添加 include your-app.mk
# 3. 在 common.mk 中更新 help 和 setup-all 目標
