#!/usr/bin/env bash
ARGS=$(lua tools/arggen.lua $@)
echo "loadfile('tools/$1.lua')($ARGS)"
lapis exec "loadfile('tools/$1.lua')($ARGS)" --trace
