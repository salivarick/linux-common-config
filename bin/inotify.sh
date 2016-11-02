#!/usr/bin/env sh
# exit while press Control-C on OSX
trap "exit" INT

dir=$1
shift 1
cmd=$*
exclude="\/\..+"

if [[ "Darwin" == `uname`  ]]; then
  watcher="fswatch -1 $dir -l 0.1 --exclude $exclude -E"
else
  watcher="inotifywait $dir -r -q -e close_write --exclude $exclude"
fi

until false; do
  clear
  $cmd &
  $watcher
  job_pid=$!
  pkill -P $job_pid >/dev/null
  kill $job_pid >/dev/null
done
