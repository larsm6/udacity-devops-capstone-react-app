FROM mhart/alpine-node:12 AS builder
WORKDIR /app
COPY Application/package.json Application/yarn.lock ./
RUN yarn
COPY Application/ ./
RUN yarn run build


FROM mhart/alpine-node:12
RUN yarn global add serve
WORKDIR /app
COPY --from=builder /app/build .
CMD ["serve", "-p", "443", "-s", "."]