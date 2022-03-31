# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit cmake-multilib python-any-r1

DESCRIPTION="Bear is a tool that generates a compilation database for clang \
tooling."
HOMEPAGE="https://github.com/rizsotto/Bear"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86"
MY_PN="${PN/b/B}"
SLOT="0"
IUSE+=" test"
CDEPEND=" >=net-libs/grpc-1.26[${MULTILIB_USEDEP}]
	   >=dev-libs/protobuf-3.11[${MULTILIB_USEDEP}]"
DEPEND+=" ${CDEPEND}
	  >=dev-cpp/nlohmann_json-3.7.3[${MULTILIB_USEDEP}]
	  >=dev-libs/libfmt-6.1[${MULTILIB_USEDEP}]
	  >=dev-libs/spdlog-1.5[${MULTILIB_USEDEP}]" # The libfmt requirement is based on the CMakeLists.txt differing from the INSTALL.md requiring 6.2.
RDEPEND+=" ${DEPEND}"
BDEPEND+=" ${CDEPEND}
	>=dev-util/cmake-3.12
	test? (
		${PYTHON_DEPS}
		>=dev-cpp/gtest-1.10[${MULTILIB_USEDEP}]
		$(python_gen_any_dep '>=dev-python/lit-0.7[${PYTHON_USEDEP}]')
		dev-util/valgrind
	)
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]"
SRC_URI="
https://github.com/rizsotto/Bear/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="mirror"

pkg_setup()
{
	python-any-r1_pkg_setup
	if pkg-config --libs grpc | grep -q -e "absl_dynamic_annotations" ; then
		if [[ ! -f /usr/$(get_libdir)/libabsl_dynamic_annotations.so ]] ; then
			# grpc requirement
			die "Missing libabsl_dynamic_annotations.so"
		fi
	fi
}

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local nabis=0
	for a in $(multilib_get_enabled_abis) ; do
		nabis=$((${nabis} + 1))
	done
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS=$(usex test)
		-DENABLE_FUNC_TESTS=$(usex test)
	)
	if (( ${nabis} > 1 )) ; then
		mycmakeargs+=( -DENABLE_MULTILIB=ON  )
	else
		mycmakeargs+=( -DENABLE_MULTILIB=OFF  )
	fi
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	# Removed staged folder.  It contains the same contents.
	rm -rf "${ED}/var" || die
}
