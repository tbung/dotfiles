#!/usr/bin/bash

DISPLAY_CHAR=""
if [[ $(pgrep openconnect) ]]; then
    echo $DISPLAY_CHAR
else
    echo ""
fi
