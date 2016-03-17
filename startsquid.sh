#!/bin/sh

case $SQUID in
	aci|deb|rpm)
	chown squid /cache/
	/usr/sbin/squid -z
	/usr/sbin/squid -f /configs/squid-${SQUID}.conf -N -d 1
	;;

	custom)
	curl -k $CONF -o /conf/squid-custom.conf 
        chown squid /cache/
        /usr/sbin/squid -z
        /usr/sbin/squid -f /conf/squid-custom.conf -N -d 1
	;;

	*)
	chown squid /cache/ 
	/usr/sbin/squid -z
	/usr/sbin/squid -N -d 1
	;;  
esac 
