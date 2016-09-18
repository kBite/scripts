#!/bin/bash

#####
#
# description: an alternative to ndu's 'dnstouch'
# 
#####
#
# credit: www.stackoverflow.com/users/34514/tombart
#
#####
#
# changelog:
# - 20160918 kbite: removed fixed path and added parameter 'ZONE' instead
#
#####

ZONE=${1}
DATE=$(date +%Y%m%d)
# we're looking line containing this comment
NEEDLE="Serial"

curr=$(grep -e "${NEEDLE}$" ${ZONE} | sed -n "s/^\s*\([0-9]*\)\s*;\s*${NEEDLE}\s*/\1/p")

# replace if current date is shorter (possibly using different format)
if [ ${#curr} -lt ${#DATE} ]; then
        serial="${DATE}00"
else
        prefix=${curr::-2}
        if [ "$DATE" -eq "$prefix" ]; then # same day
                num=${curr: -2} # last two digits from serial number
                num=$((10#$num + 1)) # force decimal representation, increment
                serial="${DATE}$(printf '%02d' $num )" # format for 2 digits
        else    
                serial="${DATE}00" # just update date
        fi
fi

sed -i -e "s/^\(\s*\)[0-9]\{0,\}\(\s*;\s*${NEEDLE}\)$/\1${serial}\2/" ${ZONE}
echo "${ZONE}: $(grep "; ${NEEDLE}$" ${ZONE})"
