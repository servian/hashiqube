# syntax=docker/dockerfile:1

FROM node:14.20.0

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN echo "nameserver 10.9.99.10" > /etc/resolv.conf

EXPOSE 6001

CMD [ "node", "index.js" ]
