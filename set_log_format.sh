#!/bin/sh

LOG_FORMAT="\'[NGINX] \$remote_addr - \$remote_user [\$time_local] \
\"\$request\" \$status \$bytes_sent \"\$http_referer\" \
\"\$http_user_agent\" \"\$gzip_ratio\";\'"


if grep --quiet log_format $@
then
    sed -i "s|\(.*\)log_format.*$|\1log_format $LOG_FORMAT|" $@
else
    sed -i "s|^\(.*\)\(access_log.*$\)|\1\2\n\1log_format $LOG_FORMAT|" $@
fi
