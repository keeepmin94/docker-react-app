FROM node:alpine as builder 
#여기에 있는 FROM 부터다음 번 FROM 전까지는 모두 Builder Stage라는 것을 명시
WORKDIR /usr/src/app
COPY package.json ./
RUN npm install
COPY ./ ./
RUN npm run build

# nginx를 위한 베이스이미지
FROM nginx
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
# 다른 스테이지에 있는 파일을 복사할 때 다른 스테이지 이름을 명시
# Builder Stage에서 생성한 파일은 /usr/src/app/build 에 생성되며, 이 경로에 저장된 파일들을 /usr/share/nginx/html로 복사. 브라우저에서 HTTP 요청이 올 때마다 Nginx가 알맞은 파일을 전달할 수 있게 만듦.
# 클라이언트의 요청이 들어올 때마다 Nginx가 알맞은 정적 파일을 제공하기 위해 이 장소로 빌드된 파일을 복사. 이 장소는 설정을 통해 변경 가능.