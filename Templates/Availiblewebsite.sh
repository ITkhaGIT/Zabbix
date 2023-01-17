#!/bin/bash
curl -s -D - -o /dev/null $1 | grep HTTP  | awk {'print $2'}
