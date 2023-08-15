# Note: Platypus copies the binaries in .app/Contents/Resources,
# but there should be in .app/Contents/MacOS to avoid double-signing
# This is why they are manually copied.

# Common variables.
identifier := "net.cyann"
author := "Flavien Scheurer"
version := "1.3.1"
release_dir := "releases"

name := "not_set"
app_name := "not_set"

# App specific variables.
svg2icns := "svg2icns"
svg2icns_app_name := "SVG to ICNS"
svg2png := "svg2png"
svg2png_app_name := "SVG to PNG"
svg2folder := "svg2folder"
svg2folder_app_name := "SVG to folder icon"
svg2svg := "svg2svg"
svg2svg_app_name := "SVG to 1024 x 1024"


_build name app_name:
	/usr/local/bin/platypus \
	--optimize-nib --overwrite --droppable \
	--app-icon "{{ name }}.icns" \
	--name "{{ app_name }}" \
	--interface-type Droplet \
	--interpreter "/bin/zsh" \
	--bundle-identifier "{{ identifier }}.{{ name }}" \
	--uniform-type-identifiers public.svg-image \
	--bundled-file "Credits.html" \
	--author "{{ author }}" \
	--app-version {{ version }} \
	"{{ name }}.sh" \
	"{{ app_name }}"


# Copy the rsvg-convert in .app/Contents/MacOS.
_include_rsvg app_name:
	# cp "rsvg-convert" "{{ app_name }}.app/Contents/MacOS"


# Copy the oxipng in .app/Contents/MacOS.
_include_oxipng app_name:
	# cp "oxipng" "{{ app_name }}.app/Contents/MacOS"


# Build SVG to PNG
svg2png: (_build svg2png svg2png_app_name) && (_include_rsvg svg2png_app_name) (_include_oxipng svg2png_app_name)


# Build SVG to ICNS
svg2icns: (_build svg2icns svg2icns_app_name) && (_include_rsvg svg2icns_app_name)


# Build SVG to folder icon
svg2folder: (_build svg2folder svg2folder_app_name) && (_include_rsvg svg2folder_app_name)


# Build SVG to 1024 x 1024
svg2svg: (_build svg2svg svg2svg_app_name) && (_include_rsvg svg2svg_app_name)


# Build all
build: svg2png svg2icns svg2folder svg2svg zip_release


# Compress all apps and save a zip in /releases.
zip_release:
	-mkdir {{ release_dir }}
	zip -r -X "{{ release_dir }}/svg2any_{{ version }}.zip" *.app
