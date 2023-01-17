#!/bin/bash
curl -s -D - -o /dev/null $1 | grep "HTTP/1.1"  | awk {'print $2'}
