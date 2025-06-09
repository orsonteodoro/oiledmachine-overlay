# Copyright 2008-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

#
# About the confusing versioning.
#
# Upstream uses 4.21.12 for their python package in __init__.py.  See https://github.com/protocolbuffers/protobuf/blob/v3.21.12/python/google/protobuf/__init__.py#L33
# The versioning here corresponds to configure.ac.
# 3.21.12 is equivalent to 4.21.12 and equivalent to 21.12.
#

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream supports up to 3.10

inherit distutils-r1

PARENT_PN="${PN/-python/}"
PARENT_PV="$(ver_cut 2-)"
PARENT_P="${PARENT_PN}-${PARENT_PV}"

if [[ "${PV}" == *9999 ]]; then
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
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" ebuild_revision_1"
RDEPEND="
	${PYTHON_DEPS}
	dev-libs/protobuf:${SLOT}
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
	"${FILESDIR}/${PN}-3.20.3-python311.patch"
)

python_prepare_all() {
	pushd "${WORKDIR}/${PARENT_P}" >/dev/null 2>&1 || die
		[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
		eapply_user
	popd >/dev/null 2>&1 || die
	distutils-r1_python_prepare_all
}

src_configure() {
	DISTUTILS_ARGS=(
		--cpp_implementation
	)
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}/install" -name "*.pth" -type f -delete || die
}
