#!/bin/sh

./stop_testing_server.sh

erl -noshell -sname forge -eval 'testing_server:start(".", "log.txt").' > /dev/null &
PID=$!
echo $PID > ERLANG_TESTING_SERVER
echo "Testing server started (PID: $PID)."

touch log.txt
tail -f log.txt
