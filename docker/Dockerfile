FROM node:20-alpine

WORKDIR /app

COPY employee-app/package*.json ./
RUN npm install

COPY employee-app/*.js ./

EXPOSE 3000

CMD ["node", "index.js"]