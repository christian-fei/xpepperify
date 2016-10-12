#!/usr/bin/env bash

printHelp() {
echo "HTTP/1.0 500 Problem with format

<html>
<body>
<h1>Xpepperify your avatar</h1>
<p>
Usage for the <br>
<ul><li><strong>red overlay</strong><img width=\"30\" src=\"/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg\"><a href="/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg">http://this-website-address.com/http://url-of-the-avatar.png</a>
</li><li><strong>white overlay</strong><img width=\"30\" src=\"/white/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg\"><a href="/white/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg">http://this-website-address.com/white/http://url-of-the-avatar.png</a>
</li><li><strong>white over red overlay</strong><img width=\"30\" src=\"/white-on-red/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg\"><a href="/white-on-red/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg">http://this-website-address.com/white-on-red/http://url-of-the-avatar.png</a>
</li></ul>
</p>
<img  width=\"200\"  src=\"/https://static.artfire.com/uploads/product/7/367/82367/6082367/6082367/large/troll_face_-_6_x_5_25_decal_18d24f31.jpg\">
</body>
</html>
";
}


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

tmpFile=$(mktemp /tmp/file.XXXXXXXXXX) || { echo "HTTP/1.0 500 Problem with format";echo "Failed to create temp file"; exit 1; }
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

wget -o /dev/null -a /dev/null $profile -O $tmpFile

if [[ "$?" == "1" ]]; then
    printHelp ; exit 1;
fi
convert $tmpFile -resize 500x500 miff:- | composite -gravity center overlay/$overlay - $output

response $output

#cleaning
rm $tmpFile
rm $output