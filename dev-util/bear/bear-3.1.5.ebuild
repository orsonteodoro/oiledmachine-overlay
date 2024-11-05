# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# The libfmt requirement is based on the CMakeLists.txt is different from the \
# INSTALL.md requiring 6.2.

# 4.x will be rust.  3.x is still c++.

MY_PN="${PN/b/B}"

PYTHON_COMPAT=( "python3_"{8..11} )

inherit cmake-multilib python-any-r1

KEYWORDS="~amd64 ~arm64 ~arm64-macos ~ppc64 ~s390"
S="${WORKDIR}/${MY_PN}-${PV}"
SRC_URI="
https://github.com/rizsotto/Bear/archive/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bear is a tool that generates a compilation database for clang \
tooling."
HOMEPAGE="https://github.com/rizsotto/Bear"
LICENSE="GPL-3+"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
CDEPEND="
	>=dev-libs/protobuf-3.11:0/3.21[${MULTILIB_USEDEP}]
	|| (
		=net-libs/grpc-1.49*[${MULTILIB_USEDEP}]
		=net-libs/grpc-1.52*[${MULTILIB_USEDEP}]
		=net-libs/grpc-1.53*[${MULTILIB_USEDEP}]
		=net-libs/grpc-1.54*[${MULTILIB_USEDEP}]
	)
	net-libs/grpc:=
"
RDEPEND+="
	${CDEPEND}
	>=dev-cpp/nlohmann_json-3.11.3[${MULTILIB_USEDEP}]
	>=dev-libs/libfmt-11.0.2[${MULTILIB_USEDEP}]
	>=dev-libs/spdlog-1.14.1[${MULTILIB_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${CDEPEND}
	>=dev-build/cmake-3.12
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	test? (
		$(python_gen_any_dep '
			>=dev-python/lit-0.7[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
		>=dev-cpp/gtest-1.12.1[${MULTILIB_USEDEP}]
		dev-debug/valgrind
	)
"

pkg_setup()
{
	python-any-r1_pkg_setup
	if pkg-config --libs grpc | grep -q -e "absl_dynamic_annotations" ; then
		if [[ ! -f "${ESYSROOT}"/usr/$(get_libdir)/libabsl_dynamic_annotations.so ]] ; then
			# grpc requirement
			die "Missing libabsl_dynamic_annotations.so"
		fi
	fi
}

src_configure() {
	local nabis=0
	local a
	for a in $(multilib_get_enabled_abis) ; do
		nabis=$((${nabis} + 1))
	done
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS=$(usex test)
		-DENABLE_FUNC_TESTS=$(usex test)
	)
	if (( ${nabis} > 1 )) ; then
		mycmakeargs+=(
			-DENABLE_MULTILIB=ON
		)
	else
		mycmakeargs+=(
			-DENABLE_MULTILIB=OFF
		)
	fi
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	# Removed staged folder.  It contains the same contents.
	rm -rf "${ED}/var" || die
}
