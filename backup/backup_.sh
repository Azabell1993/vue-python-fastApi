#!/bin/bash
DATE=$(date +%Y%m%d%H%M%S)
DBNAME="hello_fastapi_dev"
HOST="localhost"
BACKUP_DIR="/home/jiwoo/Desktop/main-vue/backup/my_web_db_backup"
LOG_FILE="$BACKUP_DIR/backup_log.log"
SCHEMAS=("public")
export PGPASSWORD='hello_fastapi'

# 백업 디렉토리에서 오래된 파일 삭제
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;

# 백업 실행
for SCHEMA in "${SCHEMAS[@]}"; do
    BACKUP_PATH="$BACKUP_DIR/${SCHEMA}_backup_${DATE}.sql"
    # pg_dump를 사용하여 백업 실행
    pg_dump -U hello_fastapi -h $HOST -p 5433 -d $DBNAME -n $SCHEMA -f $BACKUP_PATH

    if [ $? -eq 0 ]; then
        echo "Backup successful for schema $SCHEMA on $DATE."
    else
        echo "Backup failed for schema $SCHEMA on $DATE."
    fi
done

# 백업 완료 로그
echo "Backup completed at $(date)" | tee -a "$LOG_FILE"

# 비밀번호 변수 제거
unset PGPASSWORD
