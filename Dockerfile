FROM node:14-alpine as node
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
CMD ["node", "app.js", "0.0.0.0"]
EXPOSE 5000
