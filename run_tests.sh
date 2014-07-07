#!/bin/bash

function kill_mrt {
  # Kills mrt and all the child processes
  # From http://stackoverflow.com/a/15139734/2624068
  kill -- -$(ps -o pgid= $! | grep -o [0-9]*) 2> /dev/null > /dev/null 3> /dev/null
}

function run_test {
  TEST_FILE=$1
  CUSTOM_TEST_ARGS="$2"
  cd test/app
  mrt $CUSTOM_TEST_ARGS > /dev/null &
  cd ../..
  casperjs test test/$TEST_FILE
  kill_mrt
}

if [! hash python >/dev/null 2>&1 ]
then
  echo "Tests require casper.js to run. Install casper.js with either"
  echo "'brew update && brew install casperjs'       (homebrew)"
  echo "or '[sudo] npm install -g casperjs'          (npm)"
fi

run_test test_base.coffee ""
run_test test_custom_root_route.coffee "--settings settings.json"