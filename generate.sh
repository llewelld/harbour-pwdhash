#!/bin/bash

# Generate graphics at different resolutions for different devices
# 1.0 (jolla phone), 1.25 (jolla c), 1.5 (tablet), 1.75 (xperia)
ratios="1.0 1.25 1.5 1.75 2.0"

# Generate app icons
sizes="86 108 128 172 256"
for size in ${sizes}; do
	mkdir -p "./icons/${size}x${size}"
	inkscape -z -e "./icons/${size}x${size}/harbour-pwdhash.png" -w $size -h $size "inputs/harbour-pwdhash.svg"
done

# Create the ratio directories
for ratio in ${ratios}; do
	mkdir -p "./qml/images/z${ratio}"
done

# Function for generating PNG images
function generate {
	basex=$1
	basey=$2
	names=$3
	for ratio in ${ratios}; do
		sizex=`echo "${ratio} * ${basex}" | bc`
		sizey=`echo "${ratio} * ${basey}" | bc`
		for name in ${names}; do
			inkscape -z -e "./qml/images/z${ratio}/${name}.png" -w ${sizex} -h ${sizey} "inputs/${name}.svg"
		done
	done
}

# Generate cover action icons
generate 32 32 "icon-cover-action-clipboard icon-cover-action-hash"

# Generate titles
generate 303 86 "pwdhash-title"

# Generate medium icons
#generate 64 64 "icon-m-first icon-m-second"

# Generate large icons
#generate 96 96 "icon-l-first icon-l-second"

# Generate cover
generate 117 133 "cover-background"

