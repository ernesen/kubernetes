FROM node
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
#COPY ./app/ ./
#COPY ./ ./
COPY app.js ./
COPY package.json ./
CMD chmod +x .
RUN npm install
CMD ["node", "app.js"]