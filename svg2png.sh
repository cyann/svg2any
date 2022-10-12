#!/bin/zsh

# svg2png - Convert a square SVG file to PNG.
# Flavien Scheurer 2022

# Set the app name and version from the script itself.
app_name="$(basename "$0" .sh)"
version="$(stat -f %Sm -t %Y%m%d )"

# Reset the app name and version from the Platypus bundle if available.
if [[ -v $__CFBundleIdentifier ]]; then
	app_name="$__CFBundleIdentifier"
	version="${defaults read $PWD/../Info CFBundleShortVersionString}"
fi

# Other variables for this script.
size=1024
input_ext=svg
output_ext=png
help="Convert a square SVG file to a $size ⨉ $size PNG file."
repo=https://github.com/Ystorian/svg2any

# Log file.
log_file="$HOME/Library/Logs/$app_name.log"

# Prune the log file if larger than 1 MB.
if [[ -f "$log_file" ]] ; then
	find "$log_file" -size +1M -delete
fi

# Log the app name, version, and path.
echo "\n\n$(date +"%Y-%m-%d %H:%M:%S") $app_name $version" >> "$log_file"
echo "$PWD" >> "$log_file"

# Exit immediately if any command exits with a non-zero status.
# set -e

# Determine which CPU architecture we are running on.
arch="$(uname -m)"
if [ "$arch" = "arm64" ]; then
	arch="arm64"
elif [ "$arch" = "X86_64"]; then
	arch="x64"
else
	echo "Error: Unknown architecture $arch" | tee -a "$log_file"
	exit
fi
echo "Running on [$arch]" >> "$log_file"


# Test if a file was selected.
if [ "$1" = "" ] ; then
	# No file selected, assuming we are running as a standalone script, display the help text.
	echo "$app_name $version $repo"
	echo $help
	echo "The converted file will be {file}.$output_ext in the same directory."
	echo "\n\tUsage: $app_name /{dir}/{file}.$input_ext"
	echo "Error: File not specified" >> "$log_file"
	exit
fi


# Define the file variables.

# Base directory path.
base_dir=$(dirname "$1")

# Input file name.
input_file_name=$(basename "$1")

# Base file name without any extension.
base_file=$(basename "$1" .$input_ext)
base_file=${base_file%.*}

# Output file name.
output_file_name=$base_file.$output_ext


# Test if the input file exists.
if [[ ! -f "$base_dir/$input_file_name" ]] ; then
	echo "Error: File not found: $base_dir/$input_file_name" | tee -a "$log_file"
	exit
fi

echo "Base directory: $base_dir" >> "$log_file"
echo "Input file: $input_file_name" >> "$log_file"
echo "Output file: $output_file_name" >> "$log_file"


# Test if the output file already exists.
if [[ -f "$base_dir/$output_file_name" ]] ; then
	echo "Overwriting existing output file." | tee -a "$log_file"
	rm "$base_dir/$output_file_name"
fi

# Create a PNG file from the SVG.
echo "Executing rsvg-convert_$arch..." >> "$log_file"
echo "Converting $input_file_name..."
./rsvg-convert_$arch --keep-aspect-ratio --width=$size --height=$size --output "$base_dir/$output_file_name" "$base_dir/$input_file_name" # &>> "$log_file"

# Test if the output file was created.
if [[ ! -f "$base_dir/$output_file_name" ]] ; then
	echo "Error: Output not found: $base_dir/$output_file_name" | tee -a "$log_file"
	exit
fi

# Compress with oxipng.
echo "Executing oxipng_$arch..." >> "$log_file"
echo "Compressing $output_file_name (using Zopfli - this may 2-3 minutes)..."
./oxipng_$arch --opt max --interlace 0 --strip safe --alpha -Z "$base_dir/$output_file_name" &>> "$log_file"

# Display the path and size of the output file.
echo "Created $base_dir/$output_file_name ($(stat -f %z "$base_dir/$output_file_name") bytes)"
echo "$(date +"%Y-%m-%d %H:%M:%S") Done." >> "$log_file"
