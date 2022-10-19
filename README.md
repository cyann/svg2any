# svg2any
<img src="images/svg2any.svg" width="25%">

> **Small macOS apps to help convert SVG files to PNG, ICNS, and macOS folder icons.**

## Usage
### 1. Droplet
<img src="images/svg2any-droplet_812x840.png" width="25%">

Launch the app and drag an SVG file on it to process it.

### 2. Open with
Right-click on an SVG file and select **Open with**, then choose one of the svg2any apps.

## Apps
# SVG to PNG
<img src="images/svg2png.svg" width="10%">

Convert a square SVG file to a highly compressed 1024 x 1024 PNG file.

> **Important ⏳**
> --
> The resulting PNG file will be compressed using **Zopfli**, this takes 2~3 minutes on a recent MacBook Pro M1.

---

# SVG to ICNS
<img src="images/svg2icns.svg" width="10%">

Convert a square SVG file to a universal macOS icon (ICNS).

---

# SVG to folder
<img src="images/svg2folder.svg" width="10%">

Set a macOS folder icon to the specified square SVG file.

---

## SVG files
- Some SVGs work best when only the `viewBox` attribute is set.
- On macOS, the finder will show a better icon preview when the width and height attributes are not present.
	> Original SVG file:
	> ```xml
	> <svg width="1024" height="1024" [...]>
	> ```
	>
	>Better:
	> ```xml
	> <svg viewBox="0 0 1024 1024" [...]>
	> ```
- ICNS file are not compressed with `oxipng` since `iconutil` recompress them anyway.
- Compressing each PNG files before packing them with `iconutil` will result in larger ICNS files.

---

## Building
### Dependencies
svg2any depends on these binaries to build the apps:
- Build the macOS .app: [Platypus](https://github.com/sveinbjornt/Platypus) 5.4 (BSD)
- Convert SVG to PNG files: [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) 2.55 (LGPL)
- Compress PNG files: [oxipng](https://github.com/shssoichiro/oxipng) 6.0.1 (MIT)

### How to build the macOS Apps
### 1. Install platypus
The command line tool for [Platypus](https://sveinbjorn.org/platypus) can be installed with [Homebrew](brew.sh):
```shell
brew install platypus
```

### 2. Build the apps
> Note: to help build universal apps, the `librsvg` and `oxipng` compiled binaries for x86_64 (Intel) and arm64 (Apple Silicon since M1) are present in this repository. To build these on your own, see below.

To build the apps with Platypus:
```sh
./build.sh
```


### How to (re-)build the universal binaries
#### 1. Install Rust
See [rustup.rs](https://rustup.rs/)

#### 2. Download the sources and compile

Use these examples to compile the binaries and combine them to get universal binaries.

### librsvg
```sh
git clone https://gitlab.gnome.org/GNOME/librsvg.git
cd librsvg
cargo build --release --target aarch64-apple-darwin
cargo build --release --target x86_64-apple-darwin
lipo target/aarch64-apple-darwin/release/rsvg-convert target/x86_64-apple-darwin/release/rsvg-convert -create -output rsvg-convert
```
Copy `rsvg-convert` to `svg2any/`

### oxipng
```sh
git clone https://github.com/shssoichiro/oxipng.git
cd oxipng
cargo build --release --target aarch64-apple-darwin
cargo build --release --target x86_64-apple-darwin
lipo target/aarch64-apple-darwin/release/oxipng target/x86_64-apple-darwin/release/oxipng -create -output oxipng
```
Copy `oxipng` to `svg2any/`

## Scripting
Some notes on the shell scripts:

- When a shell script is running from Platypus, this environment variables is set:
	- `__CFBundleIdentifier` _com.ystorian.svg2png_

- Other environment variables:
	- `PWD` _/{app folder}/{Application name}.app/Contents/Resources_

# About
Why this?
1. I had an itch to scratch:
	- I like SVG files: they are tiny, can be optimized a lot, and look good at any resolution.
	- I also like my folder icons to be more visually descriptive as it makes me more productive.
	- However macOS can't use SVGs for icons, it works only with ICNS.
	- Switching to the console to run a script breaks my flow when I'm in the Finder.
	- Compiling the binaries is a PITA when dealing with C, Rust just works.
2. This should help me with ysto-agent, our Rust command line tool for Ystorian MVP:
	- Provide some kind of limited GUI.
	- In a nice bundled macOS app.
	- Signed and notarized.
	- Available in the App Store for easier distribution.

## Licenses
The binaries, included in the repository for convenience, are open source and are the property of their respective owners.
- [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) (LGPL)
- [oxipng](https://github.com/shssoichiro/oxipng) (MIT)
- [Platypus](https://github.com/sveinbjornt/Platypus) (BSD)

The rest is AGPL3, feel free to ask for another license if needed.
