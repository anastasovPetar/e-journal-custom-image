FROM alpine:latest

# Install curl
RUN apk --no-cache add curl

# Create a directory for DuckDNS
RUN mkdir -p /opt/duckdns

# Create a shell script to run the DuckDNS update command
RUN echo 'echo url="https://www.duckdns.org/update?domains=custom-ojs&token=6f3dd185-cfcd-4f88-a35b-b0ed7ab9f45e&ip=" | curl -k -o /opt/duckdns/duck.log -K -' > /opt/duckdns/update.sh
# Make the script executable
RUN chmod +x /opt/duckdns/update.sh

# Set the script to run every 5 minutes using crontab
RUN echo "*/5 * * * * /opt/duckdns/update.sh" > /etc/crontabs/root

# Start cron daemon
CMD ["crond", "-f"]
