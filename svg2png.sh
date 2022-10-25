#!/bin/zsh

# svg2png - Convert an SVG file to a PNG image with transparency,
# 	perfect for social networks that don't support SVGs.
# The resulting PNG file is compressed using the slow but efficient
# Zopfli algorithm for images up to 1024 pixels,
# and the faster but less efficient zlib algorithm for larger images.
# Flavien Scheurer 2022

# Declare variables.
# App name and copyright information.
app_name="svg2png"
author="© 2022 Flavien Scheurer https://github.com/Ystorian/svg2any"

# App version, uses the script file date by default.
version="$(stat -f %Sm -t %Y-%m-%d "$0")"

# Log file.
log_file="$HOME/Library/Logs/$app_name.log"

# Image size in pixels.
size=1024
# Maximum image size to accept.
#	The maximum image size for PNG is 32767,
#	but we set a reasonable limit to 8K.
max_size=8192
# Maximum image size to use Zopfli (use zlib instead to avoid wasting CPU).
zopfli_max_size=1024

# Use the version from the bundle if available.
if [[ -f "$PWD/../Info.plist" ]]; then
	version="$(plutil -extract CFBundleShortVersionString raw "$PWD/../Info.plist")"
fi

# Prune the log file if larger than 1 MB.
if [[ -f "$log_file" ]]; then
	find "$log_file" -size +1M -delete
fi

# Test if a file was selected.
if [[ "$1" = "" ]]; then
	# No file selected, assuming we are running as a standalone script, display the help text.
	echo "$app_name version $version"
	echo "Convert an SVG file a PNG file."
	echo "The converted file will be created in the same directory as the input file."
	echo "\n\tUsage: $app_name file [size]"
	exit
fi

# Log the app name, version, and path.
echo "\n\n$(date +"%Y-%m-%d %H:%M:%S") $app_name version $version" >>"$log_file"
echo "Running script: $0" >>"$log_file"

# Define the file variables.

# Supported file extensions.
input_ext=svg
output_ext=png

# Base directory path.
base_dir="$(dirname "$1")"

# Input file name.
input_file_name="$(basename "$1")"

# Base file name without any extension.
base_file="$(basename "$1" .$input_ext)"
base_file="${base_file%.*}"

# Output file name.
output_file_name="$base_file.$output_ext"

# Test if the input file exists.
if [[ ! -f "$base_dir/$input_file_name" ]]; then
	echo "Error: File not found: $base_dir/$input_file_name" | tee -a "$log_file"
	exit
fi

echo "Base directory: $base_dir" >>"$log_file"
echo "Input file: $input_file_name" >>"$log_file"
echo "Output file: $output_file_name" >>"$log_file"

# Set the size.
# Check if a size was given as parameter.
if [[ "$2x" != "x" ]]; then
	if (($2 > 0 && $2 <= max_size)); then
		# The second parameter is in range and is a base 10 integer, let's use it.
		size=$2
		echo "Size set with parameter to $size" | tee -a "$log_file"
	fi
fi

# Ask the user to specify a size.
user_size=$(osascript -e 'text returned of (display dialog "Enter the size in pixel for '$output_file_name' (max '$max_size'):" default answer "'$size'" with icon file (POSIX file "./AppIcon.icns") with title "SVG to PNG") as integer')

if [[ "$?" != 0 ]]; then
	echo "Exiting due to cancel by user" | tee -a "$log_file"
	exit
fi

# Test if the specified size is OK.
if (($user_size > 0 && $user_size <= max_size && $user_size != $size)); then
	size=$user_size
	echo "Size set with dialog to $size" | tee -a "$log_file"
fi

# Test if the output file already exists.
if [[ -f "$base_dir/$output_file_name" ]]; then
	echo "Overwriting existing output file." | tee -a "$log_file"
	rm "$base_dir/$output_file_name"
fi

# Create a PNG file from the SVG.
echo "Executing $(./rsvg-convert -v)" >>"$log_file"
echo "Converting $input_file_name..."
./rsvg-convert --keep-aspect-ratio --width=$size --height=$size \
	--output "$base_dir/$output_file_name" "$base_dir/$input_file_name" &>>"$log_file"

# Test if the output file was created.
if [[ ! -f "$base_dir/$output_file_name" ]]; then
	echo "Error: Output not found: $base_dir/$output_file_name" | tee -a "$log_file"
	exit
fi

# Compress with oxipng.
echo "Executing $(./oxipng -V)" >>"$log_file"
if (($size > $zopfli_max_size)); then
	echo "Image size is above $zopfli_max_size pixels, \
		compressing $output_file_name using zlib..." | tee -a "$log_file"
	./oxipng --opt max --interlace 0 --strip safe --alpha \
		"$base_dir/$output_file_name" &>>"$log_file"
else
	echo "Image size is below $zopfli_max_size pixels, compressing $output_file_name using Zopfli. \
		Have a break, this may take more than 5 minutes..." | tee -a "$log_file"
	./oxipng --opt max --interlace 0 --strip safe --alpha --zopfli \
		"$base_dir/$output_file_name" &>>"$log_file"
fi

# Display the path and size of the output file.
echo "Created $base_dir/$output_file_name ($(stat -f %z "$base_dir/$output_file_name") bytes)" | tee -a "$log_file"
echo "$(date +"%Y-%m-%d %H:%M:%S") Done." >>"$log_file"
