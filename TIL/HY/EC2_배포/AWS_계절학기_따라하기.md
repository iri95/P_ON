# 계절학기 클라우드 트랙 서버관리 - AWS

### PUTTY 설치

![Untitled](./AWS_계절학기_따라하기/Untitled%201.png)

![Untitled](./AWS_계절학기_따라하기/Untitled%202.png)

![Untitled](./AWS_계절학기_따라하기/Untitled%203.png)

- 맥, 리눅스: pem / 푸티: ppk
- puttyget: pem → ppk

### Windows Choco

- 윈도우에서도 open SSH를 쓸 수 있다

![Untitled](./AWS_계절학기_따라하기/Untitled%204.png)

- Try It Now → 설치 명령어 복사

![Untitled](./AWS_계절학기_따라하기/Untitled%205.png)

- PowerShell 관리자 실행 → 붙여넣기 → 설치
  
  - 설치 확인
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%206.png)

## 1. 프리티어 사용 가능한 아이디 로그인

## 2. EC2 인스턴스 시작

- EC2 검색 → EC2 시작하기
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%207.png)

- 리전 확인 (서울)
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%208.png)
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%209.png)

- 인스턴스 시작
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2010.png)

- 서버 이름 작성
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2011.png)

- 우분투서버, 아키텍처 64비트(x86)
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2012.png)

- 인스턴스 유형: t2 micro, 프리티어 사용가능 확인

![Untitled] ![Untitled](./AWS_계절학기_따라하기/Untitled%2013.png)

- 키 페어
  
  - 새 키 페어 생성
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2014.png)
  
  - 키페어 이름은 서버명과 동일 (기억하려고)
    RSA / .pem 선택
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2015.png)
  
  - 키페어 생성 클릭 시 키페어 파일 다운로드 됨

- 네트워크설정: HTTPS, HTTP 트래픽 허용 체크
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2016.png)

- 스토리지 구성 (용량) → 프리티어는 최대 30GB이므로 그대로 유지
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2017.png)

- 인스턴스 시작
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2018.png)

> 이슈| VPC가 없어서 생성 후 시작함

- 서버 생성 확인
  
  - 인스턴스 상태: 실행중
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2019.png)

## 3. 인스턴스

- 인스턴스 ID 클릭
  
  - 퍼블릭 IP 주소, 프라이빗 IP 주소 확인 → 퍼블릭 IP로 배포
  
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2020.png)

- puttygen 실행
  
  - Load → pem key 열기 → Save private key → 바탕화면 저장
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2021.png)

- putty 실행
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2022.png)
  
  - Category: Connection → SSH → Auth → Credentials
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2023.png)
    
    puttygen에서 저장한 바탕화면 키
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2024.png)
  
  - Category: Session
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2025.png)
    
    인스턴스 퍼블릭 IPv4 주소
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2026.png)

- open → Accept
  ![Untitled](./AWS_계절학기_따라하기/Untitled%2027.png)
  
  - ubuntu 입력
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2028.png)

## 4. Putty 실습

- `vim test.txt` test.txt 파일 접근
  `i` → INSERT
  `esc` → `:w` 저장 → `:q` 나가기 ⇒ `:wq` 저장 후 나가기
  `cat [파일명]` 파일 내용 확인
  `ls` 리스트 확인
  - `ls -a` 숨김 파일까지 보기
  - `ls -al` 파일 자세히 보기??
- `man [명령어]` 명령어 설명 → `q` 나가기

## 5. 배포

https://url.kr/kubrjs

- `sudo apt-get update`
  다운받을 수 있는 패키지 목록 업데이트

- java → Zulu8 [https://docs.azul.com/core/zulu-openjdk/install/debian](https://docs.azul.com/core/zulu-openjdk/install/debian)
  
  ```bash
  $ **sudo** apt **install** gnupg ca-certificates curl
  $ curl **-s** https://repos.azul.com/azul-repo.key | **sudo** gpg **--dearmor** **-o** /usr/share/keyrings/azul.gpg
  $ echo "deb [signed-by=/usr/share/keyrings/azul.gpg] https://repos.azul.com/zulu/deb stable main" | sudo tee /etc/apt/sources.list.d/zulu.list
  ```
  
  - 패키지 추가 후 업데이트
    
    ```bash
    $ sudo apt update
    ```
  
  - 버전 입력
    
    ```bash
    $ sudo apt install zulu<jdk-version>-jdk
    
    # For example
    $ sudo apt install zulu17-jdk
    $ sudo apt install zulu8-jdk
    ```
  
  - 설치 확인
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2029.png)

- MariaDB
  
  - 설치
    
    ```bash
    sudo apt-get install mariadb-client mariadb-server -y
    sudo mysql_secure_installation
    ```
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2030.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2031.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2032.png)
    
    비밀번호 입력: ssafy
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2033.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2034.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2035.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2036.png)
  
  - 실습
    `mysql -u root -p` → 패스워드 입력
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2037.png)
    
    `exit` → 나가기
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2038.png)

- 파일질라
  
  - 설치
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2039.png)
  
  - 사이트 관리자
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2040.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2041.png)
    
    → 새 사이트 → 이름설정 [SSAFY] → SFTP, 호스트: 인스턴스 IP 주소, 키파일, 사용자: ubuntu, 키파일 업로드(pem, ppk 무관)
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2042.png)
    
    → 연결 : 우측에 우분투가 보임
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2043.png)
    
    → 배포파일 `springboot/` 파일 2개(sql, jar) 끌어넣기
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2044.png)
    
    → ubuntu에 파일 들어왔는 지 확인
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2045.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2046.png)
    
    - 자동으로 넣기
      ![Untitled](./AWS_계절학기_따라하기/Untitled%2047.png)
    
    - 확인: `ssafy_db`
      ![Untitled](./AWS_계절학기_따라하기/Untitled%2048.png)

- NginX
  
  - 설치
    
    ```bash
    sudo apt-get install nginx-core -y
    ```
  
  - 상태 확인
    
    ```bash
    sudo systemctl status nginx
    ```
    
    active 확인 → `q` 나가기
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2049.png)
  
  - 배포 폴더 → Vue / articles → 폴더 주소에 `cmd`
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2050.png)
    
    ```bash
    npm install
    # static 파일로 변환
    npm run build
    ```
    
    `dist` 폴더에 빌드된 파일 저장됨 → dist.zip 압축
    → 파일 질라 우분투 서버로 복사
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2051.png)
  
  - 알집 해제
    
    ```bash
    sudo apt-get install unzip
    unzip dist.zip
    ```
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2052.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2053.png)
  
  - dist 폴더 안의 파일 복사
    
    ```bash
    cd dist
    sudo cp -r * /var/www/html/.
    ```
    
    → 복사 확인
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2054.png)
    
    → 서버 확인 (인스턴스 IP 주소)
    → `F12` 개발자 도구
    연동 안되어있음
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2055.png)

- spring 연결
  
  - 배포 디렉터리 수정
    
    ```bash
    cd /etc/nginx/sites-available/
    sudo vim default
    ```
    
    → default 파일의 location 수정
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2056.png)
    
    → `i` → `location /api` 추가 → `esc` → `:wq`
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2057.png)
    
    → 시스템 재부팅
    
    ```bash
    sudo systemctl stop nginx
    sudo systemctl start nginx
    sudo systemctl status nginx
    ```
  
  - 홈 디렉터리로 이동
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2058.png)
  
  - jar 파일 실행
    `java -jar [파일명]`
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2059.png)
  
  - 서버 확인
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2060.png)
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2061.png)

- 백그라운드로 서버를 계속 돌려주는 방법
  
  ```bash
  nohup java -jar [파일명] &
  ```
  
  - 서버 종료 방법
    
    ```bash
    ps -ux | grep "java"
    kill -9 [번호]
    ```
    
    ![Untitled](./AWS_계절학기_따라하기/Untitled%2062.png)
