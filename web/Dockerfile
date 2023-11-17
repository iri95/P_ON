# 기본 이미지 설정
FROM node:18

# 작업 디렉토리 설정
WORKDIR /usr/src/app

# 의존성 파일 복사
COPY package.json package-lock.json ./

# 의존성 설치
RUN npm i

# 소스 코드 복사
COPY . .

# 빌드
RUN npm run build

# 포트 3000으로 노출
EXPOSE 3000

# 앱 실행
CMD ["npm", "run", "start"]