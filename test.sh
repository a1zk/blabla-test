#!/bin/bash

echo "Running smoke test"
echo "___________________"
echo ">> Chec version <<"
docker run -t --rm a1zk/blabla-test:test --version
ec=$?
if [ $ec -ne 0 ]; then
  echo "Faild version valodation"
  exit $ec
else
  echo "Version test Passed"
fi
echo
echo
TEST_URLS=('blablacar.com', 'google.com', 'i.ua')
echo ">> Chec Urls <<"
for i in "${TEST_URLS[@]}"
do
  CODE=$(docker run -t --rm a1zk/blabla-test:test -I $i | awk '{print $2; exit}')
  if [ $CODE -ne 301 ] || [ $CODE -ne 200 ]; then
    echo "Faild URL test"
  else
     echo "URL test is Passed"
  fi
done

echo "Done"