# gentoo-overlay

A small Gentoo overlay with two packages the main tree doesn't have: hacksaw, which selects a region of the screen, and shotgun, which takes the screenshot. Together they make a region screenshot to the clipboard in one key binding. Both are small Rust programs that need only libxcb or libX11 at runtime, where maim and slop bring libjpeg-turbo, libpng, libwebp and five more X libraries. The overlay is made for one laptop (Gentoo with dwm, as few packages as possible) and is in daily use there.

**Status:** in use on the target laptop: both packages build from these ebuilds (EAPI 8, cargo.eclass, crates fetched by Portage) and run there. amd64 only.

![Terminal output on a dark background: "emerge -pv --nodeps hacksaw shotgun" lists x11-misc/hacksaw-1.0.4 and media-gfx/shotgun-2.5.1 from the overlay; "ls -l" shows /usr/bin/hacksaw at 840520 bytes and /usr/bin/shotgun at 725752 bytes; then the dwm binding for Alt+Shift+S: g=$(hacksaw) && shotgun -g "$g" - | xclip -selection clipboard -t image/png](docs/images/emerge.png)

## Features

- **x11-misc/hacksaw 1.0.4:** draw a rectangle, or click a window, and it prints its geometry (`WxH+X+Y`). Esc cancels. MPL-2.0.
- **media-gfx/shotgun 2.5.1:** a screenshot of the screen, a window or a geometry, as PNG to a file or stdout. MPL-2.0.
- **Crates through Portage:** every Rust dependency is listed in `CRATES` and fetched and checked by Portage like any distfile, so building needs no network access and no `cargo vendor`.

## How to install

With `eselect repository` (app-eselect/eselect-repository):

```sh
doas eselect repository add r3clusionn git https://github.com/r3clusionn/gentoo-overlay.git
doas emaint sync -r r3clusionn
doas emerge x11-misc/hacksaw media-gfx/shotgun
```

Or by hand, in `/etc/portage/repos.conf/r3clusionn.conf`:

```ini
[r3clusionn]
location = /var/db/repos/r3clusionn
sync-type = git
sync-uri = https://github.com/r3clusionn/gentoo-overlay.git
```

Building needs Rust (dev-lang/rust or rust-bin) and, for hacksaw, Python (its xcb crate generates bindings at build time).

## How to use

```sh
shotgun shot.png                          # the whole screen
g=$(hacksaw) && shotgun -g "$g" shot.png  # a region you select
shotgun -i "$(xdotool getactivewindow)" w.png   # a window (needs xdotool)
```

In dwm, a region straight to the clipboard on Alt+Shift+S:

```c
{ MODKEY|ShiftMask, XK_s, spawn, SHCMD("g=$(hacksaw) && shotgun -g \"$g\" - | xclip -selection clipboard -t image/png") },
```

## How it works

- **The ebuilds use cargo.eclass:** the `CRATES` list pins each dependency and its version, `SRC_URI="${CARGO_CRATE_URIS}"` turns it into distfiles, and the Manifests (thin, with `DIST` lines only) carry their checksums. The packages themselves come from crates.io like their dependencies.
- **hacksaw** uses the old xcb 0.9 crate, which runs a bundled Python script to generate its X protocol bindings. The ebuild pulls in a build-time Python through python-any-r1 for that.
- **QA_FLAGS_IGNORED:** cargo builds with its own flags, so Portage's check that `CFLAGS`/`LDFLAGS` were honoured is skipped for the binaries.

## Measurements

| | hacksaw | shotgun |
|---|---|---|
| Installed binary | 840 kB | 726 kB |
| Runtime libraries (besides libc) | libxcb | libX11 (through x11rb) |

## Verification

- Both packages were emerged from these ebuilds on the target laptop and are installed there.
- The Alt+Shift+S binding above is used daily: hacksaw selects, and shotgun writes the PNG to the clipboard.

## Limits

- `KEYWORDS="amd64"` only, because that's the only architecture they were built on.
- hacksaw 1.0.4 is old upstream (2020) and its crates are old (xcb 0.9, structopt). It works but would need porting for newer Rust editions eventually.
- Not reviewed by Gentoo; for the main tree they would go through GURU or a proxy maintainer.

## License

The ebuilds are GPL-2.0, as Gentoo requires (see `LICENSE`). The programs are MPL-2.0 (their upstreams).
