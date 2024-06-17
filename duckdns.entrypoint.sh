#!/bin/bash

# Load environment variables from .env file if it exists
if [ -f /opt/duckdns/.env ]; then
  export $(cat /opt/duckdns/.env | xargs)
fi

# Create a shell script to run the DuckDNS update command
echo "echo url=\"https://www.duckdns.org/update?domains=$DUCKDNS_DOMAIN&token=$DUCKDNS_TOKEN&ip=\" | curl -k -o /opt/duckdns/duck.log -K -" > /opt/duckdns/update.sh

# Make the script executable
chmod +x /opt/duckdns/update.sh

# Set the script to run every 5 minutes using crontab
echo "*/5 * * * * /opt/duckdns/update.sh" > /etc/crontabs/root

# Start cron daemon
crond -f
