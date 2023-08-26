# Development stage
FROM node:16-alpine as development

WORKDIR /backend
COPY backend/tsconfig.json backend/tsconfig.build.json ./
RUN yarn
COPY backend/ .
CMD [ "yarn", "start:dev" ]

# Builder stage
FROM development as builder
WORKDIR /backend
# Build the app with devDependencies still installed from "development" stage
RUN yarn run build
# Clear dependencies and reinstall for production (no devDependencies)
RUN rm -rf node_modules
RUN yarn install --frozen-lockfile

# Production stage
FROM alpine:latest as production
RUN apk --no-cache add nodejs ca-certificates
WORKDIR /root/
COPY --from=builder /backend ./
CMD [ "node", "./build/index.js" ]