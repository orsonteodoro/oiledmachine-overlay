# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

CFLAGS_HARDENED_CI_SANITIZERS="asan msan ubsan"
CFLAGS_HARDENED_USE_CASES="untrusted-data"

inherit cflags-hardened meson-multilib

if [[ "${PV}" == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dloebl/cgif"
else
	SRC_URI="
https://github.com/dloebl/cgif/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="A fast and lightweight GIF encoder"
HOMEPAGE="https://github.com/dloebl/cgif"
LICENSE="MIT"
SLOT="0"
IUSE="examples test"
RDEPEND="
	sys-libs/zlib
"
BDEPEND="
	>=dev-build/meson-0.56
"
DOCS=( "AUTHORS" "LICENSE" "README.md" )

multilib_src_configure() {
	cflags-hardened_append
	local emesonargs=(
		-Dfuzzer=false
		$(meson_use examples)
		$(meson_use examples install_examples)
		$(meson_use test tests)
	)
	meson_src_configure
}
