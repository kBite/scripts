#!/bin/bash

# kBite: generate_ssh-config.sh			early alpha, production ready
#
# OpenSSH 7.3 will have an include feature, but every version below does not.
# Reference: https://bugzilla.mindrot.org/show_bug.cgi?id=1585
#
# This is my workaround.

if [[ ! -d ${HOME}/.ssh/config.d ]]; then
	mkdir ${HOME}/.ssh/config.d
	echo "Your first run?"
	exit 123
fi

cat ${HOME}/.ssh/config.d/*.cfg > ${HOME}/.ssh/config
exit 0
