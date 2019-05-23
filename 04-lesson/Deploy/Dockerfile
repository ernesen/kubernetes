FROM node:8.16.0-alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY app.js ./
# COPY package.json ./
RUN chmod +x .
RUN npm install express@4.17.0
EXPOSE 8080
CMD ["node", "app.js"]