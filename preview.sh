#!/bin/bash

# Preview Plymouth Splash
# by _khAttAm_
# www.khattam.info
# License: GPL v3
# source: https://gist.github.com/nextgenthemes/5396198
# modified by Sébastien Bouchard <sebastjava@hotmail.ca>

# if [ $# -eq 0 ]
#   then
#     echo "Argument must be one of: lordnikon, acirdburn, crashoverride"
#     exit -1
# fi

# cd $1


chk_root () {
  if [ ! $( id -u ) -eq 0 ]; then
    echo; echo; echo; echo; echo "Must be run as root!"
    exit
  fi
}
chk_root

DURATION=$1
if [ $# -ne 1 ]; then
  DURATION=10
fi

plymouthd --debug
plymouth --show-splash
for ((I=0; I<$DURATION; I++)); do
  plymouth --update=test$I;
  sleep 1;
  done;
plymouth quit
