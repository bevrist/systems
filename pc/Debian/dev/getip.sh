#!/bin/bash
case "$1" in
	"-4")
		API="http://v4.ipv6-test.com/api/myip.php"
		;;
	"-6")
		API="http://v6.ipv6-test.com/api/myip.php"
		;;
	*)
		API="http://ipv6-test.com/api/myip.php"
		;;
esac
curl -s "$API"
echo
