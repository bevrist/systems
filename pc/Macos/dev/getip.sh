#!/bin/bash
curl -s https://icanhazip.com
dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com
dig -6 TXT +short o-o.myaddr.l.google.com @ns1.google.com
