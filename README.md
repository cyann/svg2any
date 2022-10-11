# svg2any

Small macOS apps to help convert SVG files to PNG, ICNS, and macOS folder icons.


### Dependencies
svg2any depends on:
- [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) 2.54.5 (LGPL)
- [oxipng](https://github.com/shssoichiro/oxipng) 6.0.1 (MIT)
- [Platypus](https://github.com/sveinbjornt/Platypus) 5.4 (BSD)

Install the dependencies with [Homebrew](brew.sh):
```shell
brew install platypus librsvg oxipng
```

### Notes
- There is a new version of rsvg-convert written in Rust, [console-rsvg-convert](https://github.com/miyako/console-rsvg-convert), however as of version 2.1.3 it does not support resizing.
- When a shell script is running from Platypus, these environment variables can be interesting:
  - `__CFBundleIdentifier` _com.ystorian.svg2png_
  - `PWD` _/{app folder}/{Application name}.app/Contents/Resources_
