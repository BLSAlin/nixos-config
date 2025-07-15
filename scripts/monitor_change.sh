#!/usr/bin/env bash

set -o nounset
set -o errexit

case $1 in
	"--sn")
		selector="--sn"
		;;
	"--model")
		selector="--model"
		;;
	*)
		selector="--sn"
		;;
esac

current=$(ddcutil getvcp 60 $selector $2 | sed -n "s/.*(sl=\(.*\))/\1/p")

case $current in
    0x0f)
        output=0x11
        ;;

    0x11)
        output=0x0f
        ;;

    *)
        output=0x0f
        ;;
esac

ddcutil setvcp 60 $output $selector $2
