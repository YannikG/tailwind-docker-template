FROM --platform=amd64 node:latest AS build

WORKDIR /app

# Install dependencies
COPY package.json /app/package.json
RUN npm install

# Copy source files
COPY tailwind.config.js /app/tailwind.config.js
COPY src /app/src

# Publish
RUN npn run publish

FROM --platform=amd64 nginx:latest

COPY --from=build /app/src /usr/share/nginx/html

COPY --from=build /app/dist /usr/share/nginx/html/dist

# Add NGINX config
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
RUN chown -R nginx /etc/nginx /var/run /run
RUN chmod -R a+w /var/run /run /var/cache /var/cache/nginx

EXPOSE 80

# run nginx
CMD ["nginx", "-g", "daemon off;"]