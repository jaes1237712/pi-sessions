# Pi sessions：跨裝置同步

這個 private Git repository 同時是：

1. Pi 的正式 session 儲存位置
2. 跨裝置同步這些 session 的 Git repository

它不是另外一份需要 import 的備份。所有裝置共用同一個平面目錄：

```text
sessions/*.jsonl
```

Pi 會讀取每個 JSONL header 的 `cwd`，因此在某個 workspace 執行 `/resume` 時，只顯示該 workspace 的 session。不要再依裝置或 workspace 建立子目錄。

## 每台裝置設定一次

Clone repository 後執行：

```bash
./install.sh
source ~/.bashrc
```

安裝程式會：

- 將 `PI_CODING_AGENT_SESSION_DIR` 設為此 repository 的 `sessions/`
- 將 `sync-sessions` 連結到 `~/.local/bin/`

確認設定：

```bash
echo "$PI_CODING_AGENT_SESSION_DIR"
```

## 日常使用

開始在另一台裝置工作前，以及結束工作後，都執行：

```bash
sync-sessions
```

同步完成後，在相同路徑的 workspace 啟動 Pi：

```bash
cd ~/Projects/DevFightingGame-workspace
pi -r
```

另一台裝置建立的 session 會直接出現在 `/resume`，不需要 `import-project-sessions` 或 `/import`。

## 同步規則

- 不要同時在兩台裝置續寫同一個 session。
- 執行 `sync-sessions` 前先離開正在寫入 session 的 Pi process。
- 不同 session 的檔名包含 UUID，正常情況不會互相衝突。
- Session 可能包含程式碼、terminal output 或 secrets；repository 必須保持 private。

## 舊目錄遷移

第一次執行新版 `sync-sessions` 時，會自動將舊的 `sessions/desktop/...`、`sessions/laptop/...` 平面化到 `sessions/`，並移除完全相同的副本。如果同一個 session 在兩台裝置產生無法安全合併的分支，腳本會停止，不會任意覆蓋。
