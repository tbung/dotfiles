#!/usr/bin/bash

DISPLAY_CHAR=""
if [[ $(ip addr) == *mullvad* ]]; then
    echo $DISPLAY_CHAR
else
    echo ""
fi
