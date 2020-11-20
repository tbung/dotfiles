#!/bin/sh

wid=$1
class=$2
title=$(xtitle $wid)
proc_name=$(ps -p "$(xdo pid "$wid")" -o comm= 2>/dev/null)
instance=$3

if [ "$proc_name" = "spotify" ] ; then
	echo desktop=X state=pseudo_tiled
fi
