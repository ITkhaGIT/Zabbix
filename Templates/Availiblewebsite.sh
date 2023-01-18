#!/bin/bash
HTTP_STATUS="$(curl -s -IL $1 | grep HTTP  | awk {'print $2'})"
count="$(echo $HTTP_STATUS |tr " " "\n" |wc -l)"
result="$(echo $HTTP_STATUS | awk '{print $'$count'}')"
echo "$result"
