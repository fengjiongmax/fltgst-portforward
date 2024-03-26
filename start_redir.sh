#!/bin/sh

if [ -z $1 ]
then
	echo "sh start_redir.sh [port]"
	exit 1
fi

PORT=$1
echo "redirecting port: $PORT"

echo "Setting up emulator udp redirect..."
AUTH_TOKEN=$(cat $HOME/.emulator_console_auth_token)
echo "Auth token of android telnet: $AUTH_TOKEN"

{ echo "auth $AUTH_TOKEN"; sleep 1; echo "redir add udp:$PORT:$PORT"; sleep 1 ; echo "redir list"; sleep 1; } | telnet localhost 5554

FILE=udp_redir
if [ ! -f "$FILE" ]; then
	echo "Compiling..."
	gcc udp_redirect.c -o udp_redir
fi
echo "Start redirecting..."
ADDR=$(ip route get 1 | head -1 | cut -d ' ' -f7)
CMD="./udp_redir $ADDR $PORT 127.0.0.1 $PORT" 
echo "command: $CMD"
exec $CMD