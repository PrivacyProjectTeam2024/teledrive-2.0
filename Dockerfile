FROM node:18.16.0 as build

# Define build arguments
ARG REACT_APP_TG_API_ID
ARG REACT_APP_TG_API_HASH
ARG ENV
ARG TG_API_ID
ARG TG_API_HASH
ARG ADMIN_USERNAME
ARG DB_PASSWORD
ARG API_JWT_SECRET
ARG FILES_JWT_SECRET
ARG DATABASE_URL

# Copy package files
COPY yarn.lock .
COPY package.json .
COPY api/package.json api/package.json
COPY web/package.json web/package.json

# Clean yarn cache and install dependencies
RUN yarn cache clean
RUN yarn install --network-timeout 1000000

RUN yarn upgrade --lastest

# Copy the rest of the application code
COPY . .

# Build the application
RUN yarn workspaces run build

# Run Prisma migrations
RUN yarn server prisma migrate deploy

# Start the application
CMD ["yarn", "start"]
