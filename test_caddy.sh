#!/bin/bash

set -e
set +x

URL=http://127.0.0.1:666
CADDY_CT=caddyserver

echo "1/3 visit $URL should works..."
HTTP_CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL)
if [[ $HTTP_CODE == 200 ]]; then
  echo " --> OK: http code == 200"
else
  echo " *** Error Expect HTTP CODE 200 got $HTTP_CODE"
  exit 1;
fi

echo "Change config file to test reload"
sed -i 's/index.html/index2.html/g' Caddyfile

echo "2/3 visit $URL should still return 200..."
HTTP_CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL)
if [[ $HTTP_CODE == 200 ]]; then
  echo " --> OK: http code == 200"
else
  echo " *** Error Expect HTTP CODE 200 got $HTTP_CODE"
  exit 1;
fi

echo "Reload caddy..."
docker kill -s USR1 $CADDY_CT

echo "3/3 visit $URL exepct 404 file not found..."
HTTP_CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL)
if [[ $HTTP_CODE == 404 ]]; then
  echo " --> OK: http code == 404"
else
  echo " *** Error Expect HTTP CODE 404 got $HTTP_CODE"
  exit 1;
fi


echo "Get config back"
sed -i 's/index2.html/index.html/g' Caddyfile
echo "Reload caddy..."
docker kill -s USR1 $CADDY_CT

echo "4/6 visit $URL should still return 200..."
HTTP_CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL)
if [[ $HTTP_CODE == 200 ]]; then
  echo " --> OK: http code == 200"
else
  echo " *** Error Expect HTTP CODE 200 got $HTTP_CODE"
  exit 1;
fi


echo "Generate config error"
sed -i 's/127.0.0.1 /127.0.0.1/g' Caddyfile
echo "Reload caddy..."
docker kill -s USR1 $CADDY_CT

echo "5/6 visit $URL should still return 200 and ignore new config..."
HTTP_CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL)
if [[ $HTTP_CODE == 200 ]]; then
  echo " --> OK: http code == 200"
else
  echo " *** Error Expect HTTP CODE 200 got $HTTP_CODE"
  exit 1;
fi


echo "Get config back"
sed -i 's/127.0.0.1/127.0.0.1 /g' Caddyfile
echo "Reload caddy..."
docker kill -s USR1 $CADDY_CT

echo "6/6 visit $URL should still return 200..."
HTTP_CODE=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' $URL)
if [[ $HTTP_CODE == 200 ]]; then
  echo " --> OK: http code == 200"
else
  echo " *** Error Expect HTTP CODE 200 got $HTTP_CODE"
  exit 1;
fi

