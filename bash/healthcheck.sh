#!/bin/bash

status_code=`curl -s -o /dev/null -w "%{http_code}" "http://localhost/"`

if [ "$status_code" == "200" ]
then
	exit 0
else
	exit 1
fi
