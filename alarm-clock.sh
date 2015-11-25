#!/bin/bash

# alarm-clock.sh plays a sound either when a specific time is reached
# or after a period of time.
# HOW TO USE:
# $1 needs to be 'at' or 'in'.
# - 'at' defines a specific time hh:mm via at-command
# - 'in' defines a period of time via sleep-command

time=$2
sound=~/music/alarm-beep/loud.alarm.clock.buzzer.mp3

if [ -e $sound ]; then	
	command -v mplayer	>/dev/null 2>&1 || { echo >&2 "I require mplayer but it's not installed.  Aborting."; exit 1; }
	command -v at		>/dev/null 2>&1 || { echo >&2 "I require at	 but it's not installed.  Aborting."; exit 1; }
	if [ $1 = at ]; then
		echo "mplayer ${sound}" | at ${time}
	elif [ $1 = in ]; then
		sleep ${time}; mplayer ${sound}
	else
		echo "'$1' needs to be 'at' or 'in'."
	fi
else
	echo "alarm sound is not specified or specified file does not exist."
fi	
