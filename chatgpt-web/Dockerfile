FROM node:lts-alpine AS builder

RUN apk update && apk add git
RUN git clone --depth 1 https://github.com/Chanzhaoyu/chatgpt-web.git /app
WORKDIR /app

COPY run-script.sh .
RUN chmod +x run-script.sh && ./run-script.sh
RUN npm install pnpm -g && pnpm install && pnpm run build

FROM node:lts-alpine

COPY --from=builder /app/service /app
COPY --from=builder /app/dist /app/public

WORKDIR /app
RUN npm install pnpm -g && pnpm install

EXPOSE 3002

CMD ["pnpm", "run", "start"]
