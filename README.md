# Shell-
https://drive.google.com/file/d/1AjByKQ5WrjjYgDgrOl-ShsahfFWRdNWM/view?usp=drive_link  
![image](https://github.com/WANG-YI-CHEN-411034018/Shell/blob/main/IMG/1712146398768.jpg)  
* 這個 Bash 腳本主要功能是將指定的來源資料夾的內容備份到目的地資料夾，並且會自動刪除超過7天的備份檔案和備份紀錄。  
![image](https://github.com/WANG-YI-CHEN-411034018/Shell/blob/main/IMG/1712146387448.jpg)  
* 以下是該腳本的主要結構：  
變數設定：設定來源資料夾、目的地資料夾、備份時間和備份紀錄檔案的路徑。  
函式定義：定義了三個函式，分別用於刪除超過7天的備份檔案(delete_old_backups)、刪除超過7天的備份紀錄(delete_old_logs)和執行備份(perform_backup)。  
主程式：提供一個選單讓使用者選擇要執行的操作，包括執行備份、設定備份時間和查閱備份紀錄  
系統操作流程說明  
使用者選擇要執行的操作。  
如果選擇執行備份，則會調用 perform_backup 函式。該函式會生成一個時間戳記，並使用 tar 命令將來源資料夾的內容壓縮成一個 .tar.gz 檔案，然後將該檔案儲存到目的地資料夾。完成備份後，會將備份完成的訊息和時間寫入備份紀錄檔案，並調用 delete_old_logs 和 delete_old_backups 函式刪除超過7天的備份紀錄和備份檔案。  
如果選擇設定備份時間，則會提示使用者輸入新的備份時間，並將該時間設定為新的備份時間。  
如果選擇查閱備份紀錄，則會顯示備份紀錄檔案的內容。  
* 系統程式截圖說明  
![image](https://github.com/WANG-YI-CHEN-411034018/Shell/blob/main/IMG/1712146416261.jpg)  
![image](https://github.com/WANG-YI-CHEN-411034018/Shell/blob/main/IMG/1712146424810.jpg)  
