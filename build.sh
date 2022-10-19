#!/bin/zsh

# Common variables.
identifier=com.ystorian
author="Flavien Scheurer"
version=1.0.2

app_name="SVG to PNG"
name=svg2png
bundled_file="rsvg-convert|oxipng"

/usr/local/bin/platypus --optimize-nib --overwrite --droppable --app-icon "$name.icns" --name "$app_name" --interface-type Droplet --interpreter "/bin/zsh" --bundle-identifier "$identifier"."$name" --uniform-type-identifiers public.svg-image --bundled-file "$bundled_file" --author "$author" --app-version $version "$name.sh" "$app_name"

app_name="SVG to ICNS"
name=svg2icns
bundled_file="rsvg-convert"

/usr/local/bin/platypus --optimize-nib --overwrite --droppable --app-icon "$name.icns" --name "$app_name" --interface-type Droplet --interpreter "/bin/zsh" --bundle-identifier "$identifier"."$name" --uniform-type-identifiers public.svg-image --bundled-file "$bundled_file" --author "$author" --app-version $version "$name.sh" "$app_name"

app_name="SVG to folder icon"
name=svg2folder
bundled_file="rsvg-convert"

/usr/local/bin/platypus --optimize-nib --overwrite --droppable --app-icon "$name.icns" --name "$app_name" --interface-type Droplet --interpreter "/bin/zsh" --bundle-identifier "$identifier"."$name" --uniform-type-identifiers public.svg-image --bundled-file "$bundled_file" --author "$author" --app-version $version "$name.sh" "$app_name"
