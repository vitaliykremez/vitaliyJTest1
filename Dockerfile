FROM 216920179355.dkr.ecr.eu-central-1.amazonaws.com/vk-testangular:node14-alpine as build-stage

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

FROM nginx

COPY ./nginx/myconf.conf /etc/nginx/conf.d/default.conf

COPY --from=build-stage /usr/src/app/dist/TestProjectJenkins /usr/share/nginx/html

EXPOSE 80
