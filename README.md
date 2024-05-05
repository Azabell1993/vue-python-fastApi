# Developing a Single Page App with FastAPI and Vue.js

기본 예제 :  [post](https://testdriven.io/blog/developing-a-single-page-app-with-fastapi-and-vuejs).
예제 참조 : [post](https://github.com/testdrivenio/fastapi-vue)

--------------------------------------------------------------
# Vue.js + Python FastAPI + WASM + Docker

1. docker-compose 버전 수정 및 Dockerfile과 호환을 위한 포트번호 추가
2. 회원가입, 로그인에서 상당 부분을 수정함
    추가한 코드 : 
    /home/jiwoo/Desktop/main-vue/services/frontend/src/views/CustomAlert.vue    -- Alert창을 Custom한 Vue 코드
    /home/jiwoo/Desktop/main-vue/services/frontend/src/views/WasmView.vue       -- WASM을 테스트하기 위한 WasmView Vue 코드
    /home/jiwoo/Desktop/main-vue/services/frontend/src/assets/css/main.css      -- main.css

3. docker-compose 에서 command: ./create_secret_key.sh 부분을 참조하면
```
#!/bin/bash
export SECRET_KEY=$(openssl rand -hex 32)
exec uvicorn src.main:app --reload --host 0.0.0.0 --port 5000
```  
예제에는 하드코딩으로 되어있어 docker를 새로 돌릴때마다 발급이 가능한 SECRET_KEY를 만드는 스크립트를 작성함.

3. DB backup 스크립트 작성함. 지 스크립트를 실행하기 전의 전제 조건
    1) 콘솔 내 한국시간으로 변경 (운영체제마다 다르지만 우분투 기준으로 설명)
    ```
    sudo timedatectl set-timezone Asia/Seoul
    ```  

    2) docker ps 로 확인을 하고나서 psql에 대항하는 컨테이너 안에 들어가서 vim 편집기를 설치 후

    ```
    hello_fastapi_dev=# SHOW config_file;
                  config_file                
    ------------------------------------------
    /var/lib/postgresql/data/postgresql.conf
    (1 row)
    ```  
    vim /var/lib/postgresql/data/postgresql.conf 코드 내에서 time_zone을 'Asia/Seoul'로 수정 후 sudo docker restart 

    3) 저장소 추가 및 키 가져오기
    ```
        # 저장소 추가
        sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

        # 저장소 키 가져오기
        wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

        # 패키지 목록 업데이트
        sudo apt-get update
    ```  
    4) 설치
    ```
        # 설치
        sudo apt-get install postgresql-client-15
    ```  
    5) postgres 조회
    ```
    $ sudo cat /etc/passwd | grep 'postgres'
    postgres:x:116:124:PostgreSQL administrator,,,:/var/lib/postgresql:/bin/bash
    ```  
    6) postgres 패스워드 지정
    ```
    $ sudo passwd postgres
    New password:
    Retype new password:
    passwd: password updated successfully
    ```   
    7) postgres로 콘솔 로그인
    ```
    $ su postgres
    Password:
    postgres $ crontab -e
    ```  
    8) 목록에서 1번 선택
    ```
    postgres $ crontab -e
    no crontab for postgres - using an empty one

    Select an editor.  To change later, run 'select-editor'.
      1. /bin/nano        <---- easiest
      2. /usr/bin/vim.basic
      3. /usr/bin/vim.tiny
      4. /bin/ed

    Choose 1-4 [1]: 1
    ```  

    9) crontab에 1분단위 테스트 진행
    - 1분단위 테스트(test 용)
    * * * * * /백업스크립트경로/backup_.sh >> /log 모니터링 할 경로/crontab_.log 2>&1

    $ sudo tail -f crontab_.log
    Backup successful for schema public on 20240505170501.
    Backup completed at Sun May  5 17:05:02 KST 2024
    Backup successful for schema public on 20240505170601.
    Backup completed at Sun May  5 17:06:01 KST 2024
    Backup successful for schema public on 20240505170701.
    Backup completed at Sun May  5 17:07:01 KST 2024
    Backup successful for schema public on 20240505170801.
    Backup completed at Sun May  5 17:08:01 KST 2024
    Backup successful for schema public on 20240505170901.
    Backup completed at Sun May  5 17:09:01 KST 2024
    Backup successful for schema public on 20240505171001.
    Backup completed at Sun May  5 17:10:01 KST 2024
    Backup successful for schema public on 20240505171101.
    Backup completed at Sun May  5 17:11:02 KST 2024
    Backup successful for schema public on 20240505171201.
    Backup completed at Sun May  5 17:12:01 KST 2024


    10) 자동화 작성
    - 매일 오후 4시에 백업이 진행되는 코드
    #0 16 * * * /data/sstd_backup/sstd_backup.sh >> /data/sstd_backup/sstd_crontab_cron.log 2>&1

    - 매일 새벽 12시에 백업이 진행되는 코드
    0 0 * * * /data/sstd_backup/sstd_backup.sh >> /data/sstd_backup/sstd_crontab_cron.log 2>&1

    - 1분단위 테스트(test 용)
    #* * * * * /data/sstd_backup/sstd_backup.sh >> /data/sstd_backup/sstd_crontab_cron.log 2>&1

    11) 복원시
    $ psql -U postgres 먼저 계정 생성
    CREATE DATABASE hello_fastapi_dev;
    CREATE USER hello_fastapi WITH ENCRYPTED PASSWORD 'your_password';
    GRANT ALL PRIVILEGES ON DATABASE hello_fastapi_dev TO hello_fastapi;

    - 복원하기
    psql -U hello_fastapi -h localhost -p 5433 -d hello_fastapi_dev -f /path/to/your/backup/public_backup_20240505103010.sql


4. python으로 작성한 회원가입 API 로직이 작동하는지 확인해보려면  
    ```
    curl -X POST http://localhost:5000/login -H "Content-Type: application/json" -d '{"username":"test", "password":"1234", "full_name":"test"}'```
    ```  

    ```
    curl -X POST http://localhost:5000/register -H "Content-Type: application/json" -d '{"username":"testuser", "password":"password123", "full_name":"Test User"}'
    ```  

- 터미널 결과 값 : 
    ``` {"id":100,"username":"testuser","full_name":"Test User","note":[]} ```  
- 실제 DB조회 시 : 
    ```
    hello_fastapi_dev=# select * from users;
    id  | username | full_name |                           password                           |          created_at           |          modified_at          
    -----+----------+-----------+--------------------------------------------------------------+-------------------------------+-------------------------------
      2 | test     | test      | $2b$12$vyn5IReAYuMTbjeD5Mj7A.VtVGzAiKBUiQJqVUQp82zpAPcLO14iq | 2024-05-04 12:07:44.112106+00 | 2024-05-04 12:07:44.112131+00
    100 | testuser | Test User | $2b$12$v8L2rpFaQvhQNgyVUiVLsucjvCIp39DdDwOdNh3RBUIe/E67s4SwC | 2024-05-05 07:26:15.690754+00 | 2024-05-05 07:26:15.690776+00
    ```  

5. docker-compose 를 편하게 돌리려면 docker_start.sh를 사용하세요.  
    ```
    sudo docker-compose down
    sudo docker system prune -a
    sudo systemctl restart docker
    sudo docker-compose down
    sudo docker-compose up -d
    ```  

만약, front-app(Vue.js)만 재시작하고 싶다면.  
    ```
    /Desktop/main-vue/backup$ sudo docker ps
    CONTAINER ID   IMAGE               COMMAND                  CREATED       STATUS       PORTS                                       NAMES
    5f691a1ee93a   main-vue_backend    "./create_secret_key…"   2 hours ago   Up 2 hours   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   main-vue_backend_1
    8addfea4c981   main-vue_frontend   "docker-entrypoint.s…"   2 hours ago   Up 2 hours   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp   main-vue_frontend_1
    b856fa6d9580   postgres:15.1       "docker-entrypoint.s…"   2 hours ago   Up 2 hours   0.0.0.0:5433->5432/tcp, :::5433->5432/tcp   main-vue_db_1

    # Container ID를 확인한 후
    sudo docker restart 8addfea4c981
    ```  
를 수행하세요.

