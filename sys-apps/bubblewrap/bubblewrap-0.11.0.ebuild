# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_PIE=1
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"

inherit bash-completion-r1 cflags-hardened linux-info meson

KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
SRC_URI="https://github.com/containers/${PN}/releases/download/v${PV}/${P}.tar.xz"

DESCRIPTION="Unprivileged sandboxing tool, namespaces-powered chroot-like solution"
HOMEPAGE="https://github.com/containers/bubblewrap/"
LICENSE="LGPL-2+"
# tests require root privileges
RESTRICT="test"
SLOT="0"
IUSE="
selinux suid
ebuild_revision_25
"
RDEPEND="
	sys-libs/libseccomp
	sys-libs/libcap
	selinux? (
		>=sys-libs/libselinux-2.1.9
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-text/docbook-xml-dtd:4.3
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"

pkg_setup() {
	if [[ "${MERGE_TYPE}" != "buildonly" ]] ; then
		CONFIG_CHECK="~UTS_NS ~IPC_NS ~USER_NS ~PID_NS ~NET_NS"
		linux-info_pkg_setup
	fi
}

src_configure() {
	cflags-hardened_append
	local emesonargs=(
		$(meson_feature selinux)
		-Dbash_completion=enabled
		-Dbash_completion_dir="$(get_bashcompdir)"
		-Dman=enabled
		-Dtests=false
		-Dzsh_completion=enabled
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	if use suid; then
		chmod u+s "${ED}/usr/bin/bwrap"
	fi
}
