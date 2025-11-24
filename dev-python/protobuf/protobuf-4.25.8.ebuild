# Copyright 2008-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO:  change install location for multislot

#
# About the confusing versioning.
#
# Upstream uses 4.25.8 for their python package in __init__.py.  See https://github.com/protocolbuffers/protobuf/blob/v25.8/python/google/protobuf/__init__.py
# The protobuf-cpp versioning corresponds to configure.ac.
# Protobuf-cpp 4.25.8 use protobuf-python 4.25.8 and protobuf-cpp equivalent to 25.8.
#

# 3.21.12 is protobuf-cxx
# 4.21.12 is protobuf-python

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PROTOBUF_CPP_SLOT=4
PROTOBUF_PYTHON_SLOT=$(ver_cut "1-2" "${PV}")
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream supports up to 3.10

inherit distutils-r1 flag-o-matic

PARENT_PN="${PN/-python/}"
PARENT_PV="$(ver_cut 2-)"
PARENT_P="${PARENT_PN}-${PARENT_PV}"

if [[ "${PV}" == *"9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PARENT_P}"
else
	KEYWORDS="~amd64 ~x64-macos"
	SRC_URI="
		https://github.com/protocolbuffers/protobuf/archive/v${PARENT_PV}.tar.gz
			-> ${PARENT_P}.tar.gz
	"
fi
S="${WORKDIR}/${PARENT_P}/python"

DESCRIPTION="Python bindings for Google's Protocol Buffers"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
	https://pypi.org/project/protobuf/
"
LICENSE="BSD"
SLOT="${PROTOBUF_PYTHON_SLOT}/"$(ver_cut "1-2" "${PV}") # Use PYTHONPATH wrapper for app
IUSE+=" ebuild_revision_1"
RDEPEND="
	${PYTHON_DEPS}
	!dev-python/protobuf:0
	dev-libs/protobuf:${PROTOBUF_CPP_SLOT}/4.25
	dev-libs/protobuf:=
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	${PYTHON_DEPS}
"

distutils_enable_tests "pytest"

# Same than PATCHES but from repository's root directory,
# please see function `python_prepare_all` below.
# Simplier for users IMHO.
PARENT_PATCHES=(
)

# Here for patches within "python/" subdirectory.
PATCHES=(
	#"${FILESDIR}/${PN}-3.20.3-python311.patch"
)

python_prepare_all() {
	pushd "${WORKDIR}/${PARENT_P}" >/dev/null 2>&1 || die
		[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
		eapply_user
	popd >/dev/null 2>&1 || die
	distutils-r1_python_prepare_all
}

src_configure() {
	append-ldflags -L"${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/$(get_libdir)"
	export PATH="${ESYSROOT}/usr/lib/protobuf/${PROTOBUF_CPP_SLOT}/bin:${PATH}"
	DISTUTILS_ARGS=(
		--cpp_implementation
	)
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}/install" -name "*.pth" -type f -delete || die
}

src_install() {
	distutils-r1_src_install

	change_prefix() {
	# Change of base /usr -> /usr/lib/protobuf-python/${PROTOBUF_PYTHON_SLOT}
		local old_prefix="/usr/lib/${EPYTHON}"
		local new_prefix="/usr/lib/protobuf-python/${PROTOBUF_PYTHON_SLOT}/lib/${EPYTHON}"
		dodir $(dirname "${new_prefix}")
		mv "${ED}${old_prefix}" "${ED}${new_prefix}" || die
	}

	python_foreach_impl change_prefix
}
