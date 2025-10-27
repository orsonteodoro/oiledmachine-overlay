# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Fix C++ configure time selection

_CXX_STANDARD=(
	"cxx_standard_cxx11"
	"cxx_standard_cxx14"
	"+cxx_standard_cxx17"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX17[@]}
)

inherit libcxx-compat
LLVM_COMPAT=(
	${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}
)

ABSEIL_CPP_PV="20200225.0"
CXX_STANDARD=17 # Originally 11
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut 1-3 "${PV}")
PROTOBUF_PV="3.12.2"
PROTOBUF_CPP_SLOT="3"
PROTOBUF_PYTHON_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit flag-o-matic libcxx-slot libstdcxx-slot distutils-r1 multiprocessing prefix

KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
S="${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
https://github.com/protocolbuffers/protobuf/archive/refs/tags/v${PROTOBUF_PV}.tar.gz
	-> protobuf-${PROTOBUF_PV}.tar.gz
"

DESCRIPTION="Protobuf code generator for gRPC"
HOMEPAGE="
	https://grpc.io
	https://github.com/grpc/grpc/tree/master/tools/distrib/python/grpcio_tools
"
LICENSE="Apache-2.0"
SLOT="${PROTOBUF_CPP_SLOT}"
IUSE+="
${_CXX_STANDARD[@]}
ebuild_revision_5
"
REQUIRED_USE="
	^^ (
		${_CXX_STANDARD[@]/+}
	)
"
# See https://github.com/grpc/grpc/blob/v1.30.2/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.30.2/third_party
RDEPEND="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx11?,cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-cpp/abseil-cpp:=
	dev-libs/protobuf:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx11?,cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-libs/protobuf:=
	>=dev-python/cython-0.29.8:0.29[${PYTHON_USEDEP}]
	dev-python/cython:=
	dev-python/protobuf:${PROTOBUF_PYTHON_SLOT}/3.12[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	~dev-python/grpcio-${PV}:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_USEDEP},cxx_standard_cxx11?,cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-python/grpcio:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	dev-util/patchelf
"

pkg_setup() {
	python_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

src_unpack() {
	unpack ${A}
	rm -rf "${WORKDIR}/${GRPC_P}/third_party/protobuf" || die
	mv "${WORKDIR}/protobuf-${PROTOBUF_PV}" \
		"${WORKDIR}/${GRPC_P}/third_party/protobuf" || die
	mkdir -p "${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/third_party" || die
	ln -s "${WORKDIR}/${GRPC_P}/third_party/protobuf" \
		"${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/third_party/protobuf" || die
	ln -s "${WORKDIR}/${GRPC_P}" \
		"${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/grpc_root" || die
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

check_cython() {
	local actual_cython_pv=$(cython --version 2>&1 \
		| cut -f 3 -d " " \
		| sed -e "s|a|_alpha|g" \
		| sed -e "s|b|_beta|g" \
		| sed -e "s|rc|_rc|g")
	local actual_cython_slot=$(ver_cut 1-2 "${actual_cython_pv}")
	local expected_cython_slot="0.29"
	if ver_test "${actual_cython_slot}" -ne "${expected_cython_slot}" ; then
eerror
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue."
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
}

python_configure() {
	append-cppflags -I"${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/include"
	local libdir=$(get_libdir)
	local L2=(
		$(PKG_CONFIG_PATH="\
${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/${libdir}/pkgconfig:\
${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/${libdir}/pkgconfig:\
${ESYSROOT}/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/${libdir}/pkgconfig:\
${ESYSROOT}/usr/${libdir}/pkgconfig:\
${PKG_CONFIG_PATH}" \
		pkg-config --libs protobuf)
	)
	append-ldflags "${L2[@]}"
	filter-flags "-Wl,--as-needed"
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	check_cython
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
	# Change of base /usr -> /usr/lib/grpc/${PROTOBUF_CPP_SLOT}
		local old_prefix="/usr/lib/${EPYTHON}"
		local new_prefix="/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die

		local pv
		pv="${EPYTHON/python}"
		pv="${pv/.}"
		patchelf \
			--add-rpath "${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/$(get_libdir)" \
			--add-rpath "${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)" \
			$(realpath "${ED}/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}/site-packages/grpc_tools/_protoc_compiler.cpython-${pv}-"*"-linux-gnu.so") \
			|| die
	}

	python_foreach_impl change_prefix

	rm -rf "${ED}/lib" || true

	local old_prefix="/usr/share"
	local new_prefix="/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/share"
	mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
}
