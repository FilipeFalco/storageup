# Development stage
FROM node:20-alpine as development
# Define working directory
WORKDIR /usr/src/app
# Copy source code
COPY ./backend/package*.json ./
RUN set -eux \
    & apk add \
        --no-cache \
        nodejs \
        yarn
RUN yarn
COPY ./backend/.env ./backend/tsconfig.json ./backend/tsconfig.build.json  ./
COPY ./backend/src ./src
# Install dependencies
CMD [ "yarn", "run", "start:dev" ]

# Builder stage
FROM development as builder
WORKDIR /usr/src/app
# Build the app with devDependencies still installed from "development" stage
RUN yarn run build
# Clear dependencies and reinstall for production (no devDependencies)
RUN rm -rf node_modules
RUN yarn install --frozen-lockfile

# Production stage
FROM alpine:latest as production
RUN set -eux \
    & apk add \
        --no-cache \
        nodejs \
        yarn
RUN apk --no-cache add nodejs ca-certificates
WORKDIR /root/
COPY --from=builder /usr/src/app ./
CMD [ "yarn", "run", "start:prod" ]
EXPOSE 8080