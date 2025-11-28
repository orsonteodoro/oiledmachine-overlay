# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# The libfmt requirement is based on the CMakeLists.txt is different from the \
# INSTALL.md requiring 6.2.

# 4.x will be rust.  3.x is still c++.

MY_PN="${PN/b/B}"

ABSEIL_CPP_PV="20220623.0"
CMAKE_MAKEFILE_GENERATOR="emake"
CXX_STANDARD=17
GRPC_SLOT="3"
PROTOBUF_SLOT="3"
RE2_SLOT="20220623"

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

PYTHON_COMPAT=( "python3_"{8..11} )

inherit abseil-cpp cmake-multilib flag-o-matic grpc libcxx-slot libstdcxx-slot protobuf python-any-r1

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
IUSE+="
test
ebuild_revision_7
"
RDEPEND+="
	${CDEPEND}
	>=dev-libs/libfmt-8.1.1[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	>=dev-libs/spdlog-1.9.2[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${MULTILIB_USEDEP}]
	dev-libs/protobuf:${PROTOBUF_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx17]
	dev-libs/protobuf:=
	net-libs/grpc:${GRPC_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx17]
	net-libs/grpc:=
"
DEPEND+="
	${RDEPEND}
	>=dev-cpp/nlohmann_json-3.7.3[${MULTILIB_USEDEP}]
"
BDEPEND+="
	>=dev-build/cmake-3.22.1
	>=dev-util/pkgconf-1.3.7[${MULTILIB_USEDEP},pkg-config(+)]
	dev-libs/protobuf:${PROTOBUF_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/protobuf:=
	test? (
		$(python_gen_any_dep '
			>=dev-python/lit-0.7[${PYTHON_USEDEP}]
		')
		${PYTHON_DEPS}
		>=dev-cpp/gtest-1.11.0[${LIBCXX_USEDEP},${MULTILIB_USEDEP}]
		dev-debug/valgrind
	)
"
PATCHES=(
	"${FILESDIR}/${PN}-3.1.6-fix-grpc-link.patch"
)

pkg_setup()
{
	python-any-r1_pkg_setup
	local libdir=$(get_libdir)
	if pkg-config --libs grpc | grep -q -e "absl_dynamic_annotations" ; then
		if [[ ! -f "${ESYSROOT}/usr/lib/grpc/${GRPC_SLOT}/${libdir}/libabsl_dynamic_annotations.so" ]] ; then
			# grpc requirement
eerror "Missing libabsl_dynamic_annotations.so"
			die
		fi
	fi
	libcxx-slot_verify
	libstdcxx-slot_verify
}

multilib_src_configure() {
einfo "libdir:  $(get_libdir)"
	pushd "${WORKDIR}/${MY_P}" >/dev/null 2>&1 || die
	PKG_CONFIG_PATH=$(echo "${PKG_CONFIG_PATH}" | tr ":" $"\n" | sed -e "/pkgconfig/d" | tr $"\n" ":")
	PKG_CONFIG_PATH="${ESYSROOT}/usr/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%%.*}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	PKG_CONFIG_PATH="${ESYSROOT}/usr/lib/grpc/${GRPC_SLOT}/$(get_libdir)/pkgconfig:${PKG_CONFIG_PATH}"
	export PKG_CONFIG_PATH
	PATH=$(echo "${PATH}" | tr ":" $"\n" | sed -e "/grpc/d" -e "/protobuf/d" | tr $"\n" ":")
	PATH="${ESYSROOT}/usr/lib/grpc/${GRPC_SLOT}/bin:${PATH}" # For grpc_cpp_plugin
	PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_SLOT}/bin:${PATH}" # For protoc
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
einfo "PATH:  ${PATH}"

	filter-flags -Wl,--as-needed

einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"

	export PATH
	local nabis=0
	local a
	for a in $(multilib_get_enabled_abis) ; do
		nabis=$((${nabis} + 1))
	done
	local mycmakeargs=(
		-DENABLE_FUNC_TESTS=$(usex test)
		-DENABLE_UNIT_TESTS=$(usex test)
		-DCMAKE_VERBOSE_MAKEFILE=ON
		-DABSEIL_CPP_SLOT="${ABSEIL_CPP_PV%%.*}"
		-DABSEIL_CPP_SO_SUFFIX="2206.0.0"
		-DLIBDIR="$(get_libdir)"
		-DGRPC_SLOT="${GRPC_SLOT}"
		-DPROTOBUF_SLOT="${PROTOBUF_CPP_SLOT}"
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
	cmake_src_configure
	popd >/dev/null 2>&1 || die
}

src_configure() {
	cmake-multilib_src_configure
}

multilib_src_compile() {
einfo "libdir: $(get_libdir)"
	abseil-cpp_src_configure
	protobuf_src_configure
	re2_src_configure
	grpc_src_configure
	export PKG_CONFIG_PATH
einfo "PKG_CONFIG_PATH:  ${PKG_CONFIG_PATH}"
einfo "PATH:  ${PATH}"

einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "CPPFLAGS:  ${CPPFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"

	cmake_src_compile
}

src_compile() {
	cmake-multilib_src_compile
}

src_install() {
	cmake-multilib_src_install
	# Removed staged folder.  It contains the same contents.
	rm -rf "${ED}/var" || die
}
