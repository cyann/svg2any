# svg2any

Small macOS apps to help convert SVG files to PNG, ICNS, and macOS folder icons.

## Usage
Drop a square SVG file on the app.

Important: The resulting PNG file will be compressed using Zopfli, this takes 2-3 minutes on a recent MacBook Pro M1.

## Building
### Dependencies
svg2any depends on these binaries to build the apps:
- [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) 2.54.5 (LGPL)
- [oxipng](https://github.com/shssoichiro/oxipng) 6.0.1 (MIT)
- [Platypus](https://github.com/sveinbjornt/Platypus) 5.4 (BSD)

### Prerequisites
The required dependencies can be installed with [Homebrew](brew.sh):
```shell
brew install platypus librsvg oxipng
```
Note: librsvg and oxipng are present in this repository to help build universal apps.

### Build script
To build the apps with Platypus, run `./build.sh`.

### Notes
- There is a new version of rsvg-convert written in Rust, [console-rsvg-convert](https://github.com/miyako/console-rsvg-convert), however as of version 2.1.3 it does not support resizing.
- When a shell script is running from Platypus, these environment variables are used:
	- `__CFBundleIdentifier` _com.ystorian.svg2png_
	- `PWD` _/{app folder}/{Application name}.app/Contents/Resources_
- Binaries downloaded using brew are renamed based on the supported architecture, in order to create a universal app.
	- X86_64 (Intel) -> bin_x64
	- arm64 (Apple Silicon) -> bin_arm64
- Some SVG files work best when only the `viewBox` attribute is set. On macOS, the finder will show a better icon preview when the width and height attributes are not present.
	> Original SVG file:
	> ```xml
	> <svg width="1024" height="1024" [...]>
	> ```
	>
	>Better:
	> ```xml
	> <svg viewBox="0 0 1024 1024" [...]>
	> ```
- ICNS file are not compressed with oxipng since iconutil recompress them anyway. Compressing each PNG files before packing them with iconutil will result in larger ICNS files.


## Licenses
The binaries, included in the repository for convenience, are open source and are the property of their respective owners.
- [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) (LGPL)
- [oxipng](https://github.com/shssoichiro/oxipng) (MIT)
- [Platypus](https://github.com/sveinbjornt/Platypus) (BSD)

The rest is AGPL3, feel free to ask for another license if needed.
