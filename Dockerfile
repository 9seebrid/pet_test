# 오피셜 노드 이미지
FROM node:lts-alpine as build

# 작업 디렉토리 설정
WORKDIR /app

# 패키지 파일 복사
COPY package.json package-lock.json* ./

# npm ci로 패키지 설치 (메모리 옵션 추가)
RUN NODE_OPTIONS="--max-old-space-size=8192" npm ci

# 나머지 소스코드 복사
COPY . .

# 빌드 (메모리 옵션 추가)
RUN NODE_OPTIONS="--max-old-space-size=8192" npm run build

# nginx 이미지
FROM nginx:1.23-alpine

# nginx 기본 접근 파일 설정
WORKDIR /usr/share/nginx/html

# 기존 파일 삭제
RUN rm -rf *

# 빌드된 리액트 파일 복사
COPY --from=build /app/build /usr/share/nginx/html

# nginx 포트 설정
EXPOSE 80

# nginx 실행 (데몬 모드 중지)
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
