FROM alpine:latest

# Install curl and other necessary tools
RUN apk --no-cache add curl bash

# Create a directory for DuckDNS
RUN mkdir -p /opt/duckdns

# Copy entrypoint script
COPY duckdns.entrypoint.sh /opt/duckdns/duckdns.entrypoint.sh

# Make the script executable
RUN chmod +x /opt/duckdns/duckdns.entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/opt/duckdns/duckdns.entrypoint.sh"]

