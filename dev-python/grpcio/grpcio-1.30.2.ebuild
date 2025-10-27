# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

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
MY_PV=$(ver_cut 1-3 ${PV})
PROTOBUF_CPP_SLOT="3"
PROTOBUF_PYTHON_SLOT="3"
PYTHON_COMPAT=( "python3_"{10..11} )

inherit distutils-r1 flag-o-matic libcxx-slot libstdcxx-slot multiprocessing prefix

KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86"
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
cxx_standard_cxx11 cxx_standard_cxx14 +cxx_standard_cxx17 doc
ebuild_revision_2
"
REQUIRED_USE="
	^^ (
		cxx_standard_cxx11
		cxx_standard_cxx14
		cxx_standard_cxx17
	)
"
# See src/include/openssl/crypto.h#L99 for versioning
# See src/include/openssl/base.h#L187 for versioning
# See https://github.com/grpc/grpc/blob/v1.30.2/bazel/grpc_python_deps.bzl#L45
# See https://github.com/grpc/grpc/tree/v1.30.2/third_party
RDEPEND+="
	>=dev-cpp/abseil-cpp-${ABSEIL_CPP_PV}:${ABSEIL_CPP_PV%.*}[${LIBCXX_USEDEP},${LIBSTDCXX_USEDEP},cxx_standard_cxx11?,cxx_standard_cxx14?,cxx_standard_cxx17?]
	dev-cpp/abseil-cpp:=
	>=dev-libs/openssl-1.1.0g:0[-bindist(-)]
	dev-libs/openssl:=
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	>=net-dns/c-ares-1.15.0
	net-dns/c-ares:=
	>=sys-libs/zlib-1.2.11
	sys-libs/zlib:=
	dev-python/protobuf:${PROTOBUF_PYTHON_SLOT}/3.12[${PYTHON_USEDEP}]
	dev-python/protobuf:=
"
DEPEND+="
	${RDEPEND}
"
# TODO: doc: requirements.bazel.txt
BDEPEND+="
	>=dev-python/coverage-4.0[${PYTHON_USEDEP}]
	>=dev-python/cython-0.29.8:0.29[${PYTHON_USEDEP}]
	dev-python/cython:=
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/wheel-0.29[${PYTHON_USEDEP}]
	doc? (
		>=dev-python/six-1.10[${PYTHON_USEDEP}]
		>=dev-python/sphinx-1.8.1[${PYTHON_USEDEP}]
		dev-python/alabaster[${PYTHON_USEDEP}]
	)
"
PATCHES=(
	"${FILESDIR}/grpcio-1.30.2-cc-flag-test-fix.patch"
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
	sed -i -r \
		-e "\|third_party/abseil-cpp/.*[.]cc|d" \
		"src/python/grpcio/grpc_core_dependencies.py" \
		|| die
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
eerror "Do \`eselect cython set ${expected_cython_slot}\` to continue"
eerror
eerror "Actual cython version:\t${actual_cython_pv}"
eerror "Expected cython version\t${expected_cython_slot}"
eerror
		die
	fi
}

python_configure() {
	append-cppflags -I"${ESYSROOT}/usr/lib/abseil-cpp/${ABSEIL_CPP_PV%.*}/include"
	export PATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PATH="${ESYSROOT}/usr/bin/grpc/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	export PYTHONPATH="${ESYSROOT}/usr/bin/protobuf/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}:${PYTHONPATH}"
	check_cython
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
