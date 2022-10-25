#!/bin/zsh

# Note: Platypus copies the binaries in .app/Contents/Resources,
# but there should be in .app/Contents/MacOS to avoid double-signing
# This is why they are manually copied.

# Common variables.
identifier=com.ystorian
author="Flavien Scheurer"
version=1.0.2

app_name="SVG to PNG"
name="svg2png"

/usr/local/bin/platypus --optimize-nib --overwrite --droppable --app-icon "$name.icns" --name "$app_name" --interface-type Droplet --interpreter "/bin/zsh" --bundle-identifier "$identifier"."$name" --uniform-type-identifiers public.svg-image --bundled-file "Credits.html" --author "$author" --app-version $version "$name.sh" "$app_name"

# Copy the required binaries in .app/Contents/MacOS.
cp "rsvg-convert" "$app_name.app/Contents/MacOS"
cp "oxipng" "$app_name.app/Contents/MacOS"
app_name="SVG to ICNS"
name="svg2icns"

/usr/local/bin/platypus --optimize-nib --overwrite --droppable --app-icon "$name.icns" --name "$app_name" --interface-type Droplet --interpreter "/bin/zsh" --bundle-identifier "$identifier"."$name" --uniform-type-identifiers public.svg-image --bundled-file "Credits.html" --author "$author" --app-version $version "$name.sh" "$app_name"

# Copy the required binaries in .app/Contents/MacOS.
cp "rsvg-convert" "$app_name.app/Contents/MacOS"
app_name="SVG to folder icon"
name="svg2folder"

/usr/local/bin/platypus --optimize-nib --overwrite --droppable --app-icon "$name.icns" --name "$app_name" --interface-type Droplet --interpreter "/bin/zsh" --bundle-identifier "$identifier"."$name" --uniform-type-identifiers public.svg-image --bundled-file "Credits.html" --author "$author" --app-version $version "$name.sh" "$app_name"

# Copy the required binaries in .app/Contents/MacOS.
cp "rsvg-convert" "$app_name.app/Contents/MacOS"
