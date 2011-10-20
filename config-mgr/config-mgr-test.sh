#! /bin/bash
# Test for DbProfile.py

./config-mgr.py -p ./ -e dev -w
./config-mgr.py -p ./ -e dev
./config-mgr.py -p ./test.config -e dev
./config-mgr.py -p ./test.config -e dev -w


