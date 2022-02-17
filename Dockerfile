FROM node:14 as build-stage

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install

COPY . .

RUN npm run build

FROM nginx

COPY ./nginx/myconf.conf /etc/nginx/conf.d/default.conf

COPY --from=build-stage /usr/src/app/dist/TestProjectJenkins /usr/share/nginx/html

EXPOSE 80
