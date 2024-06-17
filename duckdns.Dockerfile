FROM alpine:latest

# Install curl
RUN apk --no-cache add curl

# Create a directory for DuckDNS
RUN mkdir -p /opt/duckdns

# Create a shell script to run the DuckDNS update command
RUN echo 'echo url="https://www.duckdns.org/update?domains=exampledomain&token=a7c4d0ad-114e-40ef-ba1d-d217904a50f2&ip=" | curl -k -o /opt/duckdns/duck.log -K -' > /opt/duckdns/update.sh

# Make the script executable
RUN chmod +x /opt/duckdns/update.sh

# Set the script to run every 5 minutes using crontab
RUN echo "*/5 * * * * /opt/duckdns/update.sh" > /etc/crontabs/root

# Start cron daemon
CMD ["crond", "-f"]
