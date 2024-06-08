# Use the official NGINX image as a base image
FROM nginx:latest

RUN apt-get update && apt-get install -y nano

# Copy custom NGINX configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy site configuration file
COPY ojs.conf /etc/nginx/conf.d/default.conf

# Copy the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/

# Set permissions and make the entrypoint script executable
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose the port NGINX will run on
EXPOSE 80

# Run entrypoint script
ENTRYPOINT ["docker-entrypoint.sh"]
