FROM node:alpine as build-phase

WORKDIR '/app'
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

FROM nginx
COPY --from=build-phase /app/build /usr/share/nginx/html
