# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# The libfmt requirement is based on the CMakeLists.txt is different from the \
# INSTALL.md requiring 6.2.

# 4.x will be rust.  3.x is still c++.

MY_PN="${PN/b/B}"

declare -A GRPC_TO_PROTOBUF=(
	["1.49"]="3.21"
	["1.52"]="3.21"
	["1.53"]="3.21"
	["1.54"]="3.21"
	["1.55"]="4.23"
	["1.56"]="4.23"
	["1.57"]="4.23"
	["1.58"]="4.23"
	["1.59"]="4.24"
	["1.60"]="4.25"
	["1.61"]="4.25"
	["1.62"]="4.25"
	["1.63"]="5.26"
	["1.64"]="5.26"
	["1.65"]="5.26"
	["1.66"]="5.27"
	["1.67"]="5.27"
)
GRPC_SLOTS=(
	"1.49"
	"1.52"
	"1.53"
	"1.54"
	"1.55"
	"1.56"
	"1.57"
	"1.58"
	"1.59"
	"1.60"
	"1.61"
	"1.62"
	"1.63"
	"1.64"
	"1.65"
	"1.66"
	"1.67"
)
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
gen_grpcio_cdepend() {
	local s1
	local s2
	for s1 in ${GRPC_SLOTS[@]} ; do
		s2="${GRPC_TO_PROTOBUF[${s1}]}"
		echo "
			(
				dev-libs/protobuf:0/${s2}[${MULTILIB_USEDEP}]
				=net-libs/grpc-${s1}*[${MULTILIB_USEDEP}]
			)
		"
	done
}
CDEPEND="
	|| (
		$(gen_grpcio_cdepend)
	)
	dev-libs/protobuf:=
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
