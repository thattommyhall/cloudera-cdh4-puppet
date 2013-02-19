#!/bin/sh -eu


echo " * manifest syntax... \c"
find . -name \*.pp | xargs -n100 puppet parser validate --color=false 
echo "[ OK ]"

if test ! -x /usr/bin/erb; then
  echo "Err unable to find erb"
  exit 1
fi

# This is likely to be problematic as the number of templates increases
for TEMPLATE in `find . -name \*.erb`; do
  echo " * erb syntax ${TEMPLATE}... \c"
  /usr/bin/erb -P -x -T '-' $TEMPLATE | ruby -c > /dev/null
  echo "[ OK ]"
done

for YAML in `find . -name \*.yaml`; do
  echo " * yaml syntax ${YAML}... \c"
  ruby -e "require 'yaml'; YAML.load_file('${YAML}')"
  echo "[ OK ]"
done
