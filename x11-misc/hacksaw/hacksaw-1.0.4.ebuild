# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	ansi_term@0.11.0
	atty@0.2.14
	bitflags@1.2.1
	cfg-if@0.1.10
	clap@2.33.0
	hacksaw@1.0.4
	heck@0.3.1
	hermit-abi@0.1.10
	lazy_static@1.4.0
	libc@0.2.68
	log@0.4.8
	proc-macro-error@0.4.12
	proc-macro-error-attr@0.4.12
	proc-macro2@1.0.10
	quote@1.0.3
	strsim@0.8.0
	structopt@0.3.12
	structopt-derive@0.4.5
	syn@1.0.17
	syn-mid@0.5.0
	textwrap@0.11.0
	unicode-segmentation@1.6.0
	unicode-width@0.1.7
	unicode-xid@0.2.0
	vec_map@0.8.1
	version_check@0.9.1
	winapi@0.3.8
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	xcb@0.9.0
"

PYTHON_COMPAT=( python3_{12..14} )

inherit cargo python-any-r1

DESCRIPTION="Lightweight selection tool for usage in screenshot scripts etc."
HOMEPAGE="https://github.com/neXromancers/hacksaw"
SRC_URI="${CARGO_CRATE_URIS}"

LICENSE="MPL-2.0"
# Dependent crate licenses
LICENSE+=" MIT"
SLOT="0"
KEYWORDS="amd64"

DEPEND="x11-libs/libxcb:="
RDEPEND="${DEPEND}"
# xcb-0.9 generates its bindings with a bundled python script at build time
BDEPEND="${PYTHON_DEPS}"

QA_FLAGS_IGNORED="usr/bin/${PN}"

pkg_setup() {
	python-any-r1_pkg_setup
	rust_pkg_setup
}
