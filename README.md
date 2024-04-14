# Gateway

A macOS app for launching [mpv][mpv] via system dialogs.

## Rationale

mpv is a media player capable of playing a number of formats not supported by macOS's [AVFoundation][avfoundation]
framework—a notable one being the [Matroska media container][mkv] (`.mkv`).

While mpv is available to install, [most links lead to 3rd-party methods][mpv-install]. In particular, [Homebrew's
cask][mpv-homebrew-cask] leads to stolendata's public builds that don't support current features like JPEG XL for
screenshots. While the public builds are nice, building the [Homebrew formula][mpv-homebrew-formula] from source will
yield a better experience more often than not.

The formula links an executable to `/usr/local/bin/mpv` which can be called from the command line as `mpv`. This allows
users to invoke the player with `mpv <path-to-file>`, but does not make the player available in Finder. Consequently,
invoking mpv can be cumbersome or lead people to use [IINA][iina] instead—a video player built on mpv.

This is the problem Gateway addresses. It accepts any file as input and invokes mpv for you.

In the future, this application may be expanded to support any file for any application. For now, it primarily targets
mpv.

## Install

See [Releases][releases]. macOS Ventura (v13) or later is required.

Note that Ventura has a limitation where aliases to the mpv executable are always resolved. This may require you to set
the path when the location changes (e.g. when building mpv from source with Homebrew).

[mpv]: https://mpv.io/
[mpv-install]: https://mpv.io/installation/
[mpv-homebrew-formula]: https://formulae.brew.sh/formula/mpv
[mpv-homebrew-cask]: https://formulae.brew.sh/cask/stolendata-mpv
[avfoundation]: https://developer.apple.com/av-foundation
[mkv]: https://www.matroska.org/
[iina]: https://github.com/iina/iina
[releases]: https://github.com/kyleerhabor/gateway/releases
