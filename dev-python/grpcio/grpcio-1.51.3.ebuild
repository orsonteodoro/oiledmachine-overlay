# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=$(ver_cut "1-3" "${PV}")

ABSEIL_CPP_SLOT="20220623"
CXX_STANDARD=17 # Originally 14
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
GRPC_SLOT="3"
PROTOBUF_CPP_SLOT="3"
PROTOBUF_PYTHON_SLOT="4"
PYTHON_COMPAT=( "python3_"{10..11} )
RE2_SLOT="20220623"

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

inherit cython distutils-r1 flag-o-matic libcxx-slot libstdcxx-slot multiprocessing prefix

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
S="${WORKDIR}/${GRPC_P}"
SRC_URI+="
https://github.com/${GRPC_PN}/${GRPC_PN}/archive/v${MY_PV}.tar.gz
	-> ${GRPC_P}.tar.gz
"

DESCRIPTION="Python libraries for the high performance gRPC framework"
HOMEPAGE="
	https://grpc.io
	https://github.com/grpc/grpc/tree/master/src/python/grpcio
"
LICENSE="Apache-2.0"
SLOT="${GRPC_SLOT}/"$(ver_cut "1-2" "${PV}") # Use wrapper for PYTHONPATH
IUSE+="
${_CXX_STANDARD[@]}
doc protobuf
ebuild_revision_9
"
REQUIRED_USE="
	^^ (
		${_CXX_STANDARD[@]/+}
	)
"
# See src/include/openssl/crypto.h#L99 for versioning
# See src/include/openssl/base.h#L187 for versioning
# See https://github.com/grpc/grpc/blob/v1.51.3/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.51.3/third_party
RDEPEND+="
	>=dev-cpp/abseil-cpp-20220623.0:${ABSEIL_CPP_SLOT}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-cpp/abseil-cpp:=
	>=dev-libs/openssl-1.1.1g:0[-bindist(-)]
	dev-libs/openssl:=
	>=dev-libs/re2-0.2022.04.01:${RE2_SLOT}
	dev-libs/re2:=
	>=net-dns/c-ares-1.17.2
	net-dns/c-ares:=
	>=sys-libs/zlib-1.2.13
	sys-libs/zlib:=
"
DEPEND+="
	${RDEPEND}
"
# TODO: doc: requirements.bazel.txt
BDEPEND+="
	>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.26:0.29[${PYTHON_USEDEP}]
	dev-python/cython:=
	>=dev-python/wheel-0.29[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/sphinx-1.8.1[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
"
PDEPEND+="
	protobuf? (
		~dev-python/grpcio-tools-${PV}[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/grpcio-1.51.3-multislot-paths.patch"
)

distutils_enable_sphinx "doc/python/sphinx"

pkg_setup() {
	python_setup
	libcxx-slot_verify
	libstdcxx-slot_verify
}

python_prepare_all() {
	distutils-r1_python_prepare_all
	hprefixify setup.py
}

python_configure() {
	cython_set_cython_slot "0.29"
	cython_python_configure
	append-cppflags -I"${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/include"
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${GRPC_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	# os.environ.get('GRPC_BUILD_WITH_BORING_SSL_ASM', True)
	export GRPC_BUILD_WITH_BORING_SSL_ASM=
	export GRPC_PYTHON_DISABLE_LIBC_COMPATIBILITY=1
	export GRPC_PYTHON_BUILD_EXT_COMPILER_JOBS="$(makeopts_jobs)"
	export GRPC_PYTHON_BUILD_SYSTEM_ABSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_WITH_SYSTEM_RE2=1
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_ENABLE_DOCUMENTATION_BUILD=$(usex doc "1" "0")
	local L=(
		"${S}/tools/distrib/python/grpcio_tools/setup.py"
		"${S}/setup.py"
		$(grep -r -l -e "-std=c++14" "${S}/src/python/grpcio")
	)
	if use cxx_standard_cxx17 ; then
		append-cxxflags "-std=c++17"
		sed -i "s|-std=c++14|-std=c++17|g" "${L[@]}" || die
	fi
	local libdir=$(get_libdir)
	append-ldflags \
		"-Wl,-L/usr/lib/re2/${RE2_SLOT}/${libdir}" \
		"-Wl,-L/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/${libdir}" \
		"-Wl,--rpath=/usr/lib/re2/${RE2_SLOT}/${libdir}" \
		"-Wl,--rpath=/usr/lib/abseil-cpp/${ABSEIL_CPP_SLOT}/${libdir}"
	sed -i \
		-e "s|@RE2_SLOT@|${RE2_SLOT}|g" \
		-e "s|@ABSEIL_CPP_SLOT@|${ABSEIL_CPP_SLOT}|g" \
		"${S}/setup.py" \
		|| die
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
	# Change of base /usr -> /usr/lib/grpc/${GRPC_SLOT}
		local old_prefix="/usr/lib/${EPYTHON}"
		local new_prefix="/usr/lib/grpc/${GRPC_SLOT}/lib/${EPYTHON}"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
	}

	python_foreach_impl change_prefix
}
