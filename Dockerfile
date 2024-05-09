FROM oven/bun:alpine as build-env
WORKDIR /app
RUN apk add git
RUN git clone https://github.com/uptudev/welcome-to-docker.git .
RUN bun install
RUN mv ./patched_compress.js ./node_modules/@sveltejs/kit/src/core/adapt/builder.js
RUN bun run build \
    && rm -rf node_modules
FROM oven/bun:distroless
WORKDIR /app
COPY --from=build-env /app/build ./
COPY --from=build-env /app/serve.js ./
EXPOSE 3000/tcp
ENTRYPOINT ["bun", "./serve.js"]
