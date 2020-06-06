FROM mhart/alpine-node:12 AS builder
WORKDIR /app
COPY Application/package.json Application/yarn.lock ./
RUN yarn
COPY Application/ ./
RUN yarn run build


# FROM mhart/alpine-node:12
# RUN yarn global add serve
# WORKDIR /app
# COPY --from=builder /app/build .
# CMD ["serve", "-p", "80", "-s", "."]

FROM nginx:alpine
LABEL author="Lars Maertins"
COPY --from=builder /app/build /var/www
COPY Deployment/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80
EXPOSE 443
ENTRYPOINT ["nginx","-g","daemon off;"]