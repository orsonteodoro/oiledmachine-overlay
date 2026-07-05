# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_PIE=1
CFLAGS_HARDENED_USE_CASES="security-critical untrusted-data"

CHKL_TIMESTAMPS=(
	"sys-libs/libcap-9999"
	"sys-libs/libselinux-9999"
)

inherit bash-completion-r1 cflags-hardened chkl linux-info meson secure-version

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="2f55bae38468d0c50cf5df87b1e481e882b63acb"
	EGIT_BRANCH="main"
	EGIT_REPO_URI="https://github.com/containers/bubblewrap.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="amd64 arm arm64 ~loong ppc ppc64 ~riscv x86"
	SRC_URI="https://github.com/containers/${PN}/releases/download/v${PV}/${P}.tar.xz"
fi


DESCRIPTION="Unprivileged sandboxing tool, namespaces-powered chroot-like solution"
HOMEPAGE="https://github.com/containers/bubblewrap/"
LICENSE="LGPL-2+"
# tests require root privileges
RESTRICT="test"
SLOT="0"
IUSE+="
selinux suid
ebuild_revision_35
"
RDEPEND="
	>=sys-libs/libseccomp-${LIBSECCOMP_PV}:=
	>=sys-libs/libcap-${LIBCAP_PV}:=
	elibc_glibc? (
		>=sys-libs/glibc-${GLIBC_PV}:=
	)
	elibc_musl? (
		>=sys-libs/musl-${MUSL_PV}:=
	)
	selinux? (
		>=sys-libs/libselinux-${LIBSELINUX_PV}:=
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

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		# TODO:  add verify-sig
		unpack ${A}
	fi
}

src_configure() {
	chkl_check_many_timestamps
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
