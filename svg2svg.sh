#!/bin/zsh

# svg2svg - Resize an SVG to 1024 x 1024.
# Flavien Scheurer 2022

# Declare variables.
# App name and copyright information.
app_name="svg2svg"
author="© 2022 Flavien Scheurer https://github.com/Ystorian/svg2any"

# App version, uses the script file date by default.
version="$(stat -f %Sm -t %Y-%m-%d "$0")"

# Log file.
log_file="$HOME/Library/Logs/$app_name.log"

# Image size in pixels.
size=1024

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
	echo "Resize an SVG to 1024 x 1024."
	echo "The converted file will be created in the same directory as the input file."
	echo "\n\tUsage: $app_name file"
	exit
fi

# Log the app name, version, and path.
echo "\n\n$(date +"%Y-%m-%d %H:%M:%S") $app_name version $version" >>"$log_file"
echo "Running script: $0" >>"$log_file"

# Define the file variables.

# Supported file extensions.
input_ext=svg
output_ext=svg

# Base directory path.
base_dir=$(dirname "$1")

# Input file name.
input_file_name=$(basename "$1")

# Base file name without any extension.
base_file=$(basename "$1" .$input_ext)
base_file=${base_file%.*}

# Output file name.
output_file_name="$base_file-$sizex$size.$output_ext"

# Path to the binaries, set to MacOS when running from an .app bundle.
bin_path="."
if [[ -d "../MacOS" ]]; then
	bin_path="../MacOS"
fi

# Test if the input file exists.
if [[ ! -f "$base_dir/$input_file_name" ]]; then
	echo "Error: File not found: $base_dir/$input_file_name" | tee -a "$log_file"
	exit
fi

echo "Base directory: $base_dir" >>"$log_file"
echo "Input file: $input_file_name" >>"$log_file"
echo "Output file: $output_file_name" >>"$log_file"

# Test if the output file already exists.
if [[ -f "$base_dir/$output_file_name" ]]; then
	echo "Overwriting existing output file." | tee -a "$log_file"
	rm "$base_dir/$output_file_name"
fi

# Resize the SVG.
echo "Executing $bin_path/$("$bin_path/rsvg-convert" -v)" >>"$log_file"
echo "Resizing $input_file_name..."
"$bin_path/rsvg-convert" --format svg --keep-aspect-ratio --width=$size --height=$size --output "$base_dir/$output_file_name" "$base_dir/$input_file_name" &>>"$log_file"

# Test if the output file was created.
if [[ ! -f "$base_dir/$output_file_name" ]]; then
	echo "Error: Output not found: $base_dir/$output_file_name" | tee -a "$log_file"
	exit
fi

# Display the path and size of the output file.
echo "Created $base_dir/$output_file_name ($(stat -f %z "$base_dir/$output_file_name") bytes)" | tee -a "$log_file"
echo "$(date +"%Y-%m-%d %H:%M:%S") Done." >>"$log_file"
