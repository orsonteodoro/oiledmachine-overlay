# Copyright 2008-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..11} ) # Upstream listed up to 3.10 but patch already applied for 3.11

inherit distutils-r1

PARENT_PN="${PN/-python/}"
PARENT_PV="$(ver_cut 2-)"
PARENT_P="${PARENT_PN}-${PARENT_PV}"

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
	EGIT_CHECKOUT_DIR="${WORKDIR}/${PARENT_P}"
	S="${WORKDIR}/${PARENT_P}/python"
else
	KEYWORDS="~amd64 ~x64-macos"
	S="${WORKDIR}/protobuf-${PV}"
	SRC_URI="
		mirror://pypi/${PN:0:1}/protobuf/protobuf-${PV}.tar.gz
			-> pypi-protobuf-${PV}.tar.gz
	"
fi

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
)

python_prepare_all() {
	pushd "${WORKDIR}/protobuf-${PV}" >/dev/null 2>&1 || die
		[[ -n "${PARENT_PATCHES[@]}" ]] && eapply "${PARENT_PATCHES[@]}"
		eapply_user
	popd >/dev/null 2>&1 || die
	distutils-r1_python_prepare_all
}

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}/install" -name "*.pth" -type f -delete || die
}
