#!/bin/bash


start_xrdp_services() {
    # Preventing xrdp startup failure
    rm -rf /var/run/xrdp-sesman.pid
    rm -rf /var/run/xrdp.pid
    rm -rf /var/run/xrdp/xrdp-sesman.pid
    rm -rf /var/run/xrdp/xrdp.pid

    useradd -ms /bin/bash a
    echo "a:a"|chpasswd
    # Use exec ... to forward SIGNAL to child processes
    xrdp-sesman && exec xrdp -n
}

stop_xrdp_services() {
    xrdp --kill
    xrdp-sesman --kill
    exit 0
}

# trap "stop_xrdp_services" SIGKILL SIGTERM SIGHUP SIGINT EXIT
exec "$@"
if [ -z "$1" ]; then
    start_xrdp_services
else
    exec "$@"
fi
