#!/bin/bash

# -----------------------------------------------------------------------------
# summary:      An alternative to ndu's 'dnstouch'
#
# description:  This script is inspired by tombart's answer on stackexchange.
#               It simply updates a zone file's serial number by adding +1.
#               New serial number will be formatted as %Y%m%d[0-9]{2};
#                 e.g. 2017090308
#
#               'needle' has to match your serial number's line comment!
#               (see 'examples')
#
# options:      dnstouch.sh [path/to/my.zone]
#
# examples:     # dnstouch.sh /etc/bind/zones/my.zone
#               my.zone:              2017082500; serial
#
# credit:       www.stackoverflow.com/users/34514/tombart
# source:       unix.stackexchange.com/q/197988
#
# author:       Kilian Engelhardt <kilian.engelhardt@gmail.com>
# version:      2017082500
#
# changelog:    20160918  removed fixed path and added parameter 'ZONE' instead
#               20170825  add header and apply shellcheck suggestions
#               20170903  add functions, usage message, and needleSet
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# ---[ global variables ]------------------------------------------------------
# -----------------------------------------------------------------------------

program="${0##*/}"
date="$(date +%Y%m%d)"
needle="serial"              # we're looking for a line containing this comment
needleSet="false"

# -----------------------------------------------------------------------------
# ---[ functions ]-------------------------------------------------------------
# -----------------------------------------------------------------------------

usage () {
  echo "Description:"
  echo "  This script simply updates a zone file's serial number by adding +1."
  echo "  Serial number is identified by comment containing \$needle."
  echo "  New serial number will be formatted as %Y%m%d[0-9]{2}"
  echo ""
  echo "  First time usage: configure \$needle and \$needleSet inline."
  echo ""
  echo "Example:"
  echo "  # dnstouch.sh /etc/bind/zones/my.zone"
  echo "  my.zone:              2017082500; serial"
  echo ""
  echo "Usage: ${program} [zone file]"
  echo ""
  echo " options:"
  echo ""
  echo " -h | --help | help          display this message"
  echo ""
}

needleSet () {
  if [[ "${needleSet}" == "false" ]]; then
    echo "Please configure \$needle and set \$needleSet to anything but 'false'."
    echo "Current settings: \$needle=${needle} and \$needleSet=${needleSet}"
    exit -1
  fi
}

dnstouch () {
  declare -a parameters
  parameters=( "${@}" )
  zone="${parameters[0]}"

  currentSerial=$(grep -e "${needle}$" "${zone}" | awk '{print $1}')

  # replace if current date is shorter (possibly using different format)
  if [ "${#currentSerial}" -lt "${#date}" ]; then
    newSerial="${date}00"
  else
    prefix="${currentSerial::-2}"
    if [ "${date}" -eq "${prefix}" ]; then        # if same day:
      num="${currentSerial: -2}"                  #   last two digits
      num=$((10#${num} + 1))                      #   force decimal repr.
      newSerial="${date}$(printf '%02d' ${num} )" #   incr format for 2 digits
    else
      newSerial="${date}00"                       # if not: just update date
    fi
  fi

  sed -i -e "s/^\\(\\s*\\)[0-9]\\{0,\\}\\(\\s*;\\s*${needle}\\)$/\\1${newSerial}\\2/" "${zone}"
  echo "${zone}: $(grep "; ${needle}$" "${zone}")"
}

# -----------------------------------------------------------------------------
# ---[ main ]------------------------------------------------------------------
# -----------------------------------------------------------------------------

main () {
  declare -a parameters
  parameters=( "${@}" )

  if [[ "${#parameters}" == "0" ]]; then
    usage
    exit -1
  fi

  case "${parameters[0]}" in
    "-h"|"--help"|"help")
      usage
      ;;
    *)
      needleSet
      dnstouch "${@}"
      ;;
  esac
}

main "${@}"

# -----------------------------------------------------------------------------
# vim: tabstop=2 shiftwidth=2 softtabstop=2 expandtab autoindent
