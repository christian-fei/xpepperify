#!/usr/bin/env bash

assertRequestContainsPng() {
    file=$1
    if [[ ${file: -4} == ".png" ]]  ; then
        echo "HTTP/1.0 500 Problem with format"
        echo "Problem with format"
        exit 1
    fi
}

response() {
    output=$1
    read -r CONTENT_TYPE   < <(file -b --mime-type "$output")
    read -r CONTENT_LENGTH < <(stat -c'%s' "$output")

    # Response
    echo "HTTP/1.0 200 OK"
    echo "Content-Type: $CONTENT_TYPE";
    echo "Content-Length: $CONTENT_LENGTH"
    echo
    cat $output
}

tmpFile=$(mktemp /tmp/file.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }
output="$tmpFile.png"

read -r line
line=${line%%$'\r'}
read -r REQUEST_METHOD REQUEST_URI REQUEST_HTTP_VERSION <<<"$line"

assertRequestContainsPng

profile=${REQUEST_URI:1}; overlay="red"
dev="white/";if [[ $profile == $dev* ]] ; then profile=${REQUEST_URI:2};overlay="white"; profile=${profile:${#overlay}};  fi;
dev="white-on-red/";if [[ $profile == $dev* ]] ; then profile=${REQUEST_URI:2};overlay="white-on-red";profile=${profile:${#overlay}}; fi;
overlay=$overlay.png

# Logging
echo "< $line" >&2;
echo "> $REQUEST_METHOD" >&2;
echo "> $REQUEST_URI" >&2;
echo "> $REQUEST_HTTP_VERSION" >&2;
echo "> profile $profile; $overlay" >&2;

wget -o /dev/null -a /dev/null $profile -O $tmpFile || { echo "Failed to get the file"; exit 1; }
convert $tmpFile -resize 500x500 miff:- | composite -gravity center overlay/$overlay - $output

response $output

#cleaning
rm $tmpFile
rm $output