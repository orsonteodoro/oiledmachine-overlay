# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ABSEIL_CPP_PV="20240116.0"
CYTHON_SLOT="0.29"
CXX_STANDARD=17 # Originally 14
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut "1-3" "${PV}")
PROTOBUF_PV="25.1"
PROTOBUF_CPP_SLOT="4"
PROTOBUF_PYTHON_SLOT="4"
PYTHON_COMPAT=( "python3_"{10..11} )

_CXX_STANDARD=(
	"cxx_standard_cxx14"
	"+cxx_standard_cxx17"
)

inherit libstdcxx-compat
GCC_COMPAT=(
	"${LIBSTDCXX_COMPAT_STDCXX17[@]}"
)

inherit libcxx-compat
LLVM_COMPAT=(
	"${LIBCXX_COMPAT_STDCXX17[@]/llvm_slot_}"
)

inherit cython flag-o-matic libcxx-slot libstdcxx-slot distutils-r1 multiprocessing prefix

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
ebuild_revision_9
"
# See https://github.com/grpc/grpc/blob/v1.62.3/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.62.3/third_party
RDEPEND="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-cpp/abseil-cpp:=
	dev-libs/protobuf:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP}]
	dev-libs/protobuf:=
	>=dev-python/cython-0.29.8:${CYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/cython:=
	dev-python/protobuf:${PROTOBUF_PYTHON_SLOT}[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	~dev-python/grpcio-${PV}:${PROTOBUF_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},${PYTHON_USEDEP}]
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
	sed -i -r \
		-e "\|third_party/abseil-cpp/.*[.]cc|d" "protoc_lib_deps.py" \
		-e "\|third_party/protobuf/.*[.]c|d" "protoc_lib_deps.py" \
		-e "\|third_party/protobuf/.*[.]cc|d" "protoc_lib_deps.py" \
		|| die
}

python_configure() {
	cython_python_configure
	append-cppflags -I"${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/include"
	local L1=(
		"${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)/libprotobuf.a"
		"${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)/libprotoc.a"
	)
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
	append-ldflags -Wl,--whole-archive "${L1[@]}" -Wl,--no-whole-archive "${L2[@]}"
	filter-flags "-Wl,--as-needed"
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
	local L=(
		"${WORKDIR}/${GRPC_P}/setup.py"
		"${WORKDIR}/${GRPC_P}/tools/distrib/python/grpcio_tools/setup.py"
		$(grep -r -l -e "-std=c++14" "${S}")
	)
	if use cxx_standard_cxx17 ; then
		append-flags "-std=c++17"
		sed -e "s|-std=c++14|-std=c++17|g" "${L[@]}" || die
	fi
einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
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
			$(realpath "${ED}/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}/site-packages/grpc_tools/_protoc_compiler.cpython-${pv}-"*"-linux-gnu.so") \
			|| die
	}

	python_foreach_impl change_prefix

	rm -rf "${ED}/lib" || true

	local old_prefix="/usr/share"
	local new_prefix="/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/share"
	mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
}
