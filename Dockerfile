FROM node:14 as build-stage

# создание директории приложения
WORKDIR /usr/src/app

# установка зависимостей
# символ астериск ("*") используется для того чтобы по возможности
# скопировать оба файла: package.json и package-lock.json
COPY package.json ./

RUN npm install
# Если вы создаете сборку для продакшн
# RUN npm ci --only=production

# копируем исходный код
COPY . .

#EXPOSE 8080
RUN npm run build

FROM nginx
COPY ./nginx/myconf.conf /etc/nginx/conf.d/default.conf
COPY --from=build-stage /usr/src/app/dist/TestProjectJenkins /usr/share/nginx/html
