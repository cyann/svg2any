# svg2any

Small macOS apps to help convert SVG files to PNG, ICNS, and macOS folder icons.

## Usage
Drop a square SVG file on the app.

## Building
### Dependencies
svg2any depends on these binaries to build the apps:
- [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) 2.54.5 (LGPL)
- [oxipng](https://github.com/shssoichiro/oxipng) 6.0.1 (MIT)
- [Platypus](https://github.com/sveinbjornt/Platypus) 5.4 (BSD)

To build the apps, install the dependencies with [Homebrew](brew.sh):
```shell
brew install platypus librsvg oxipng
```

### Build script
To build the apps, run `./build.sh`.

### Notes
- There is a new version of rsvg-convert written in Rust, [console-rsvg-convert](https://github.com/miyako/console-rsvg-convert), however as of version 2.1.3 it does not support resizing.
- When a shell script is running from Platypus, these environment variables can be interesting:
	- `__CFBundleIdentifier` _com.ystorian.svg2png_
	- `PWD` _/{app folder}/{Application name}.app/Contents/Resources_
- Binaries downloaded using brew are renamed based on the supported architecture, in order to create a universal app.
	- X86_64 (Intel) -> bin_x64
	- arm64 (Apple Silicon) -> bin_arm64
