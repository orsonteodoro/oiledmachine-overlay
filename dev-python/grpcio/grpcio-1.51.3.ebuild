# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

ABSEIL_CPP_PV="20220623.0"
CXX_STANDARD=17 # Originally 14
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
GRPC_PN="grpc"
GRPC_P="${GRPC_PN}-${PV}"
MY_PV=$(ver_cut 1-3 ${PV})
PROTOBUF_CPP_SLOT="3"
PROTOBUF_PYTHON_SLOT="4"
PYTHON_COMPAT=( "python3_"{10..11} )

_CXX_STANDARD=(
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
SLOT="${PROTOBUF_CPP_SLOT}" # Use wrapper for PYTHONPATH
IUSE+="
${_CXX_STANDARD[@]}
doc
ebuild_revision_5
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
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-cpp/abseil-cpp:=
	>=dev-libs/openssl-1.1.1g:0[-bindist(-)]
	dev-libs/openssl:=
	>=net-dns/c-ares-1.17.2
	net-dns/c-ares:=
	>=sys-libs/zlib-1.2.13
	sys-libs/zlib:=
	dev-python/protobuf:${PROTOBUF_PYTHON_SLOT}/4.21[${PYTHON_USEDEP}]
	dev-python/protobuf:=
	cxx_standard_cxx14? (
		>=dev-libs/re2-0.2022.04.01:0/10
		dev-libs/re2:=
	)
	cxx_standard_cxx17? (
		>=dev-libs/re2-0.2022.04.01:0/11
		dev-libs/re2:=
	)
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
PATCHES=(
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
	append-cppflags -I"${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/include"
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
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
		append-flags "-std=c++17"
		sed -i "s|-std=c++14|-std=c++17|g" "${L[@]}" || die
	fi
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
	# Change of base /usr -> /usr/lib/grpc/${PROTOBUF_CPP_SLOT}
		local old_prefix="/usr/lib/${EPYTHON}"
		local new_prefix="/usr/lib/grpc/${PROTOBUF_CPP_SLOT}/lib/${EPYTHON}"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
	}

	python_foreach_impl change_prefix
}
