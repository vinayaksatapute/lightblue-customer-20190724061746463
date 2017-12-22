#!/bin/bash

if [ -z "$suffix" ]
then
  if [ -z "$1" ]
  then 
    exit 99
  else
    suffix=$1
  fi
fi

bx service create CloudantNoSQLDB Lite lightblue-cloudant 
bx service key-create lightblue-cloudant cred
cred=`bx service key-show lightblue-cloudant cred`
cldUrl=`echo -e $cred | grep url |  grep -Po '(?<=\"url\": \")[^"]*'`

curl -k -X PUT $cldUrl/customers

curl -k -X POST -H "Content-Type: application/json" -d '{"username":"foo","password":"bar","firstName":"foo","lastName":"bar","email":"foo@bar.com"}' $cldUrl/customers

curl -k -X POST -H "Content-Type: application/json" -d '{"index":{"fields":["username"]},"name":"username","type":"json"}' $cldUrl/customers/_index

bx app push lightblue-customer-$suffix -n lightblue-customer-$suffix

exit
