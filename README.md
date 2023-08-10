# SVG to any

<img src="images/svg2any.svg" width="25%">

> **Small Mac apps to convert SVG files to PNG, ICNS, and macOS folder icons.**
>
> _Inutile, donc indispensable_

## Usage

### 1. As a droplet apps

<img src="images/svg2any-droplet_812x840.png" width="25%">

Launch the app and drag an SVG file on it to process it.

### 2. With the Finder `Open with ...`

Right-click on an SVG file, select **Open with**,
then choose one of the svg2any apps.

## Apps

| App | Description |
| --- | ----------- |
| <img src="images/svg2png.svg" width="10%" valign="bottom"> [svg2png](#svg-to-png) | Convert an SVG file to a PNG image with transparency |
| <img src="images/svg2icns.svg" width="10%" valign="bottom"> [svg2icns](#svg-to-icns) | Convert an SVG file to a macOS high-resolution icon |
| <img src="images/svg2folder.svg" width="10%" valign="bottom"> [svg2folder](#svg-to-folder) | Set the containing folder icon to the SVG image |
| <img src="images/svg2svg.svg" width="10%" valign="bottom"> [svg2svg](#svg-to-1024-x-1024) | Resize an SVG to 1024 x 1024 |

### SVG to PNG

<img src="images/svg2png.svg" width="10%">

Convert an SVG file to a PNG image with transparency,
perfect for social networks that don't support SVGs.
The resulting PNG file is compressed using the slow but efficient Zopfli algorithm
for images up to 1024 pixels, and the faster but less efficient zlib algorithm
for larger images.

> **Important**
> Images up to 1024 pixel are compressed using **Zopfli**, which is **very slow**.
> It takes **2~3 minutes** on a recent MacBook Pro M1 for a simple image.
> More complex images with lots of details, or less capable CPUs, will take way
> more time.

---

### SVG to ICNS

<img src="images/svg2icns.svg" width="10%">

Convert an SVG file to a macOS high-resolution icon.

---

### SVG to folder

<img src="images/svg2folder.svg" width="10%">

Set the containing folder icon to the SVG image.

---

### SVG to 1024 x 1024

<img src="images/svg2svg.svg" width="10%">

Resize an SVG to 1024 x 1024.

---

## SVG files

- Some SVGs work best when only the `viewBox` attribute is set.
- On macOS, the finder will show a better icon preview when the width and height
attributes are not present.

 > Original SVG file:
>
 > ```xml
 > <svg width="1024" height="1024" [...]>
 > ```
 >
 >Better:
>
 > ```xml
 > <svg viewBox="0 0 1024 1024" [...]>
 > ```
>
- ICNS file are not compressed with `oxipng` since `iconutil` recompress them anyway.
- Compressing each PNG files before packing them with `iconutil` will result in
larger ICNS files.

---

## Logs

Each app create a unique log file in `~/Library/Logs/cyann`.

---

## About

Why this?

### An itch to scratch

- I like SVG files: they are tiny, can be optimized a lot,
and look good at any resolution.
- I also like my folder icons to be more visually descriptive
as it makes me more productive.
- However macOS can't use SVGs for icons, it works only with ICNS.
- Switching to the console to run a script breaks my flow
when I'm managing files and folders with Finder.
- Compiling the binaries is a PITA when dealing with C code
on legacy hardware (try to `brew install librsvg`), Rust works better.

This little project should help me with Ally, [Ystorian](<https://ystorian.com]'s>
inventory command line tool written in Rust:

- Provide some kind of limited GUI.
- Bundled in macOS apps that are more user-friendly than command line tools.
- With universal binaries to support the modern arm64 architecture (Apple
- Silicon) as well as the legacy x64 (Intel).
- Signed and notarized.
- Available in the App Store for easier distribution.
- Experiment to find the best app sandboxing and hardening options.
- And understand which open source license works best with app distribution
in the App Store.

---

## Licenses

The binaries that used to be included were built from these repositories:

- [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg) (LGPL)
- [oxipng](https://github.com/shssoichiro/oxipng) (MIT)
- [Platypus](https://github.com/sveinbjornt/Platypus) (BSD)

The rest is AGPL3, feel free to ask for another license if needed.

---

## Building

### Dependencies

svg2any depends on these binaries to build the apps:

- Build the macOS .app: [Platypus](https://github.com/sveinbjornt/Platypus)
- Convert SVG to PNG files: [rsvg-convert](https://gitlab.gnome.org/GNOME/librsvg)
- Compress PNG files: [oxipng](https://github.com/shssoichiro/oxipng)

### How to build the macOS apps

### 1. Install platypus

The command line tool for [Platypus](https://sveinbjorn.org/platypus)
can be installed with [Homebrew](brew.sh):

```shell
brew install platypus
```

### 2. Build the apps

Notes:

- To help build universal apps, the `librsvg` and `oxipng` compiled binaries
for x86_64 (Intel) and arm64 (Apple Silicon since M1) used to present in this
repository.
- The build script optimizes the NIB in the bundles with the `optimize-nib`
parameter.
- This requires Xcode to be installed and configured.

Build the apps with Platypus:

```sh
./build.sh
```

### How to (re-)build the required universal binaries

#### 1. Install Rust

See [rustup.rs](https://rustup.rs/)

Add and update the 2 supported targets:

```sh
rustup target add aarch64-apple-darwin
rustup target add x86_64-apple-darwin
```

#### 2. Download and install the dependencies

```sh
brew install cairo pkg-config pango gdk-pixbuf
```

#### 3. Download the sources and compile

Use these commands to compile the binaries and combine them to get
the universal binaries.

### librsvg

```sh
mkdir vendor
mkdir bin

git -C "vendor" clone https://gitlab.gnome.org/GNOME/librsvg.git
git -C "vendor/librsvg" pull
export PKG_CONFIG_ALL_STATIC=1
export PKG_CONFIG_ALLOW_CROSS=1
cargo build --manifest-path=vendor/librsvg/Cargo.toml --release --target aarch64-apple-darwin --target x86_64-apple-darwin
lipo vendor/librsvg/target/aarch64-apple-darwin/release/rsvg-convert vendor/librsvg/target/x86_64-apple-darwin/release/rsvg-convert -create -output bin/rsvg-convert
```

The generated `rsvg-convert` universal binary can then be copied to `svg2any/`

### oxipng

```sh
git clone https://github.com/shssoichiro/oxipng.git
cd oxipng
cargo build --release --target aarch64-apple-darwin --target x86_64-apple-darwin
lipo target/aarch64-apple-darwin/release/oxipng target/x86_64-apple-darwin/release/oxipng -create -output oxipng
```

The generated `oxipng` universal binary can then be copied to `svg2any/`

### Build validation

The binaries must not have dependencies on locally installed libraries.
The **otool** command should only list path in `/usr/lib` and `/System/Library`.

```sh
otool -l rsvg-convert | grep "name /"
```

```sh
otool -l oxipng | grep "name /"

         name /usr/lib/dyld (offset 12)
         name /usr/lib/libiconv.2.dylib (offset 24)
         name /usr/lib/libSystem.B.dylib (offset 24)
         name /usr/lib/libresolv.9.dylib (offset 24)
         name /usr/lib/dyld (offset 12)
         name /usr/lib/libiconv.2.dylib (offset 24)
         name /usr/lib/libSystem.B.dylib (offset 24)
         name /usr/lib/libresolv.9.dylib (offset 24)
```

## Errors

### ibtool requires Xcode

When compiling a Platypus apps, this error message is shown at the
_Optimizing nib file_ step:

```text
xcode-select: error: tool 'ibtool' requires Xcode, but active developer
directory '/Library/Developer/CommandLineTools' is a command line tools instance
```

**Solution:**
Launch **Xcode**, open the **Settings** pane, select the **Locations** tab
and ensure **Command Line Tools** is not empty.
> Command Line Tools: Xcode 14.0.1 (14A400)

### pkg-config has not been configured to support cross-compilation

```shell
export PKG_CONFIG_ALL_STATIC=1
export PKG_CONFIG_ALLOW_CROSS=1
```
