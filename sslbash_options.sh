#!/bin/bash
#option to do quick search on single domain or collection of domains in textfile#
echo "For quick ssl check on single domain enter 1"
echo "For ssl check on multiple domains enter 2"
read OPTION
if [[ $OPTION -eq 1 ]]
then 

echo "Enter a valid domain name to check SSL Expiry"
read DOM
PORT="443"
echo | openssl s_client -servername $DOM -connect $DOM:$PORT \
	| openssl x509 -noout -dates | grep notAfter
else echo "all our code for check on text file goes under else"
fi 

