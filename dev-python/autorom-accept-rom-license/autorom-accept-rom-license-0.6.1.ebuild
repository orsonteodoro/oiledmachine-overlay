# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export AUTOROM_DOWNLOAD_METHOD="offline"
ID1="61b22aefce4456920ba99f2c36906eda"
ID2="00046ac3403768bfe45857610a3d333b8e35e026"
export AUTOROM_FILE_NAME="${PN}-roms-${ID1:0:7}-${ID2:0:7}.tar.gz.b64"
PYTHON_COMPAT=( python3_10 ) # Upstream tested up to 3.10

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/AutoROM-${PV}/packages/AutoROM.accept-rom-license"
SRC_URI="
https://github.com/Farama-Foundation/AutoROM/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
https://gist.githubusercontent.com/jjshoots/${ID1}/raw/${ID2}/Roms.tar.gz.b64
	-> ${PN}-roms-${ID1:0:7}-${ID2:0:7}.tar.gz.b64
"

DESCRIPTION="A tool to automate installing Atari ROMs for the Arcade Learning \
Environment"
HOMEPAGE="
https://github.com/Farama-Foundation/AutoROM
"
LICENSE="MIT"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" test"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/autorom-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/Farama-Notifications[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/ale-py[${PYTHON_USEDEP}]
		dev-python/multi-agent-ale-py[${PYTHON_USEDEP}]
	)
"
_PATCHES=(
	"${FILESDIR}/autorom-accept-rom-license-0.6.1-offline-install.patch"
)

python_install_all() {
	distutils-r1_python_install_all
	rm -rf $(find "${ED}" -name "__pycache__")
}

python_prepare_all() {
	S="${WORKDIR}/AutoROM-${PV}"
	pushd "${S}" || die
		eapply ${_PATCHES[@]}
	popd || die
	S="${WORKDIR}/AutoROM-${PV}/packages/AutoROM.accept-rom-license"
	pushd "${S}" || die
		distutils-r1_python_prepare_all
	popd || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
