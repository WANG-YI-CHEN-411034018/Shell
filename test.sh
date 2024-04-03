#!/bin/bash

# 設定備份的來源和目的地資料夾
# source_folder 變數儲存要備份的資料夾路徑
# destination_folder 變數儲存備份檔案將要被儲存的目的地資料夾路徑
# Windows 的檔案系統被映射到 WSL 中的 /mnt 目錄下
source_folder="/mnt/c/Users/user/Desktop/作業/新增資料夾1"
destination_folder="/mnt/c/Users/user/Desktop/作業/新增資料夾2"

# 設定備份的時間，預設為每天凌晨2點
# backup_time 變數以 crontab 格式儲存自動執行備份的時間
# 0 2 * * * 的意思是：分: 0（整點）、小時: 2、日: *（每天）、月: *（每個月）、星期: *（每個星期）
backup_time="0 2 * * *"

# 設定備份紀錄檔案
# log_file 變數儲存備份過程中產生的紀錄檔案路徑
log_file="/mnt/c/Users/user/Desktop/作業/備份/backup_log.txt"

# 函式：刪除超過7天的備份檔案
delete_old_backups() {
    # 使用 find 命令找出備份檔案，並刪除超過7天的檔案
    # -type f 表示尋找檔案類型為普通檔案
    # -name 'backup_*.tar.gz' 表示尋找名稱符合模式的檔案
    # -mtime +7 表示尋找修改時間超過7天的檔案
    # -exec rm {} \; 表示對找到的每個檔案執行 rm 命令進行刪除
    find "$destination_folder" -type f -name 'backup_*.tar.gz' -mtime +7 -exec rm {} \;
    echo "刪除超過7天的備份檔案完成。"
}

# 函式：刪除超過7天的備份紀錄
delete_old_logs() {
    # 使用 find 命令找出備份紀錄檔案，並刪除超過7天的檔案
    # 這裡的 -type f 和 -mtime +7 與上面的 delete_old_backups 函式相同
    # 但是這裡是針對備份紀錄檔案進行操作
    find "$log_file" -type f -mtime +7 -exec rm {} \;
    echo "刪除超過7天的備份紀錄完成。"
}

# 函式：執行備份
perform_backup() {
    # 產生時間戳記，用於標識備份檔案
    # timestamp 變數儲存當前日期和時間的字串，格式為 YYYYMMDD_HHMMSS
    timestamp=$(date +"%Y%m%d_%H%M%S")
    # 指定備份檔案的名稱和路徑
    # backup_file 變數儲存備份檔案的完整路徑和檔名
    backup_file="$destination_folder/backup_$timestamp.tar.gz"
    
    # 使用 tar 命令進行資料夾的壓縮備份，並保留絕對路徑
    # -c 表示建立新的壓縮檔案
    # -z 表示使用 gzip 進行壓縮
    # -P 表示保留檔案的絕對路徑
    # -f 指定壓縮檔案的名稱和路徑
    tar -czPf "$backup_file" "$source_folder"
    
    # 將備份完成的訊息和時間寫入備份紀錄檔案
    # 使用 >> 進行檔案寫入操作，這會將訊息附加到檔案的末尾
    echo "Backup completed at $(date +"%Y-%m-%d %H:%M:%S")" >> "$log_file"
    
    # 執行刪除超過7天的備份紀錄
    delete_old_logs

    # 執行刪除超過7天的備份檔案
    delete_old_backups
}

# 主程式
# 提供使用者一個選單來選擇執行的操作
while true; do
    echo "1. 執行備份"
    echo "2. 設定備份時間"
    echo "3. 查閱備份紀錄"
    echo "4. 退出程式"
    echo "請輸入選項（1-4）："
    read option

    # 使用 case 語句根據使用者的輸入執行相對應的函式
    case $option in
        1)
            # 執行備份操作
            perform_backup
            ;;
        2)
            # 提示使用者輸入新的備份時間
            echo "請輸入新的備份時間（crontab 格式，例如 0 2 * * *），0 2 * * * 的意思是：分: 0（整點）、小時: 2、日: *（每天）、月: *（每個月）、星期: *（每個星期）："
            read new_backup_time

            # 設定新的備份時間
            # 使用 crontab -l 列出目前的 cron 工作
            # 使用 echo 將新的備份時間和腳本路徑加入 cron 工作
            # 使用 crontab - 將新的 cron 工作列表寫入 cron
            (crontab -l ; echo "$new_backup_time /mnt/c/Users/user/Desktop/作業/backup_script.sh") | crontab -
            
            # 顯示新設定的備份時間
            echo "新的備份時間已設定為：$new_backup_time"
            ;;
        3)
            # 顯示備份紀錄檔案的內容
            cat "$log_file"
            ;;
        4)
            # 退出程式
            echo "程式已退出。"
            exit 0
            ;;
        *)
            # 如果輸入的選項無效，顯示錯誤訊息
            echo "無效的選項"
            ;;
    esac
done