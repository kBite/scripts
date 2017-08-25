#!/bin/bash

# -----------------------------------------------------------------------------
# summary:      An alternative to ndu's 'dnstouch'
#
# description:  This script is inspired by tombart's answer on stackexchange.
#               It simply updates a zone file's serial number by adding +1.
#               Serial number is expected to be formatted as %Y%m%d[0-9]{2}.
#
#               'needle' has to match your serial numbers line comment!
#               (see 'examples')
#
# options:      dnstouch.sh [path/to/file.zone]
#
# examples:     # dnstouch.sh /etc/bind/zones/my.zone
#               file.zone:              2017082500; serial
#
# credit:       www.stackoverflow.com/users/34514/tombart
# source:       unix.stackexchange.com/q/197988
#
# author:       Kilian Engelhardt <kilian.engelhardt@gmail.com>
# version:      2017082500
#
# changelog:    20160918  removed fixed path and added parameter 'ZONE' instead
#               20170825  add header and apply shellcheck suggestions
# -----------------------------------------------------------------------------

zone="${1}"
date="$(date +%y%m%d)"
needle="serial" # we're looking for a line containing this comment

curr=$(grep -e "${needle}$" "${zone}" | sed -n "s/^\\s*\\([0-9]*\\)\\s*;\\s*${needle}\\s*/\\1/p")

# replace if current date is shorter (possibly using different format)
if [ "${#curr}" -lt "${#date}" ]; then
  serial="${date}00"
else
  prefix="${curr::8}"
  if [ "$date" -eq "$prefix" ]; then # same day
    num="${curr: -2}" # last two digits from serial number
    num=$((10#$num + 1)) # force decimal representation, increment
    serial="${date}$(printf '%02d' $num )" # format for 2 digits
  else
    serial="${date}00" # just update date
  fi
fi

sed -i -e "s/^\\(\\s*\\)[0-9]\\{0,\\}\\(\\s*;\\s*${needle}\\)$/\\1${serial}\\2/" "${zone}"
echo "${zone}: $(grep "; ${needle}$" "${zone}")"
