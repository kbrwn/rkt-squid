#!/usr/bin/env bash

set -e

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges and a fedora rootfs directory"
    exit 1
fi


# Start the build with an empty ACI
acbuild --debug begin

# In the event of the script exiting, end the build
trap "{ export EXT=$?; acbuild --debug end && exit $EXT; }" EXIT

#Set name
acbuild set-name kbrwn/alpine-squid
#add port 5000
acbuild port add www tcp 3128
#copy configuration file from local machine
acbuild copy squid.conf /etc/squid/squid.conf

#add cert for ssl
acbuild copy squid.pem /etc/squid/squid.pem

#add alpine base 
acbuild --debug dep add quay.io/coreos/alpine-sh

#update base
acbuild --debug run -- apk update

#install squid
acbuild --debug run -- apk add squid

#mount cache
acbuild --debug mount add cache /cache

#keep running
#acbuild set-exec -- /usr/sbin/squid -z && /usr/sbin/squid -N -d 1 -D
acbuild set-exec -- /bin/sh -c 'chown squid /cache/ && /usr/sbin/squid -z && /usr/sbin/squid -N -d 1'

acbuild --debug write --overwrite alpine-squid.aci
