#!/bin/bash
if [ "$1" = "" ]; then
    echo "Usage: $0 music.mp3"
    exit
fi

sha256=$(sha256sum "$1" | sed 's/\s.*//g')
cookies="/tmp/audiokeychain"$sha256".txt"

bucket=$(curl -q 'https://www.audiokeychain.com/bucket' -H 'Host: www.audiokeychain.com' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0' -H 'Accept: */*' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' -c $cookies)

if [ "$bucket" = "" ]; then
    echo "Couldn't obtain bucket code"
    exit 1
fi

uploadresult=$(curl -q 'https://www.audiokeychain.com/upload' -H 'Host: www.audiokeychain.com' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Content-Type: multipart/form-data;' -H 'Connection: keep-alive' -F "XUploadForm[file]=@$1" -F "zwa=$bucket" -b $cookies | ./JSON.sh -s)

if ! echo "$uploadresult" | grep -q 'name'; then
    echo "Couldn't upload file."
    exit 1
fi

result=$(curl -q "https://www.audiokeychain.com/queue/$bucket" -H 'Host: www.audiokeychain.com' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:47.0) Gecko/20100101 Firefox/47.0' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'X-Requested-With: XMLHttpRequest' -H 'Connection: keep-alive' --data 'errors=%5B%5D' -b $cookies | ./JSON.sh -s | sed '/^\["tracks",0\]\t/!d;s/^\["tracks",0\]\t//g;s/^"//g;s/"$//g;s/[<]\/tr[>].*/<\/tr>/g')

printf "$result"


rm $cookies
