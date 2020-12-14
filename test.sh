#!/bin/bash

set -o pipefail

echo "Running smoke test"
echo "___________________"
echo ">> Chec version <<"
docker run -t --rm a1zk/curl:0.1 --version
ec=$?
if [ $ec -ne 0 ]; then
  echo "Faild version valodation"
  exit $ec
else
  echo "Version test Passed"
fi
echo
echo
TEST_URLS=('blablacar.com' 'google.com' 'i.ua')
echo ">> Chec Urls <<"
for i in "${TEST_URLS[@]}";
do
  echo "$i"
  CODE=$(docker run -t --rm a1zk/curl:0.1 -I $i | awk '{print $2; exit}')
  echo "$CODE"
  if [ "$CODE" -ne 301 ]; then
    echo "Faild URL test"
    exit 1
  else
     echo "URL test is Passed"
  fi
done

echo "Done"