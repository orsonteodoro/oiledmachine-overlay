# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit cmake-multilib python-any-r1

DESCRIPTION="Abseil Common Libraries (C++), LTS Branch"
LICENSE="Apache-2.0"
HOMEPAGE="https://abseil.io"
KEYWORDS="~amd64 ~ppc64 ~x86"
SLOT="0/${PV}"
IUSE+=" "
BDEPEND+=" ${PYTHON_DEPS}"
SRC_URI="
https://github.com/abseil/abseil-cpp/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
RESTRICT="mirror"

src_prepare() {
	cmake-utils_src_prepare
	# un-hardcode abseil compiler flags
	sed -i \
		-e '/"-maes",/d' \
		-e '/"-msse4.1",/d' \
		-e '/"-mfpu=neon"/d' \
		-e '/"-march=armv8-a+crypto"/d' \
		absl/copts/copts.py || die
	# now generate cmake files
	absl/copts/generate_copts.py || die
	multilib_copy_sources
}

src_configure() {
	local mycmakeargs=(
		-DABSL_ENABLE_INSTALL=TRUE
	)
	cmake-multilib_src_configure
}
