#/bin/bash

function progress {
	column_count=$(tput cols)
	
  for i in $(seq 1 $column_count);
	do
		printf "="
		sleep .001
	done
	echo 
}

if [ ! -f ./profile.png ]; then
	echo "required files are missing\n"
	echo "less README.md for more info\n"
	exit 1
fi

echo "processing images."

progress

# http://www.imagemagick.org/discourse-server/viewtopic.php?f=1&t=16335&start=0
convert profile.png -resize 500x500 miff:- | composite -gravity center xpeppers-overlay.png - xpepperified.png

echo "xpepperified.png has been created."

open xpepperified.png
