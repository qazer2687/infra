#!/usr/bin/env bash

SERVER="alpha"

if ping -c 1 -W 1 "$SERVER" &> /dev/null; then
    echo '{"text":"ALPHA: ONLINE","class":"up"}'
else
    echo '{"text":"ALPHA: OFFLINE","class":"down"}'
fi
