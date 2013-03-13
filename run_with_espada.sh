#!/bin/sh

ESPADA_PATH=$(cd `dirname $0`; pwd)
RUBYLIB="$ESPADA_PATH/src":$RUBYLIB

alias espada_ruby="ruby -I '$RUBYLIB'"

echo ">> Path: $ESPADA_PATH\n"
echo ">> Ruby \$LOADPATH:"
espada_ruby -e "puts $:"
echo

espada_ruby $*
