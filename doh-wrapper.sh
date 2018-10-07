#!/bin/bash

if [[ $DEBUG ]]; then
    set -x
fi

logger() {
    echo "[doh] :: $(date +%x-%X) :: $@" | tee -a /var/log/doh.log
}

main() {
    U=${UPSTREAM_DNS:-"8.8.8.8:53"}
    P=${DOH_PATH:-"/doh"}
    logger "Starting doh-proxy with upstream dns $U, dns path $P"
    /srv/doh-proxy -l 127.0.0.1:11443 -u $U -p $P
    logger "Stopping doh-proxy"
}

main
