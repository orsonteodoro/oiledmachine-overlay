# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="face_morpher_plus"

FALLBACK_COMMIT="27e6b07fb22732d99a7126d9df86c4e451e6c1c4" # Aug 19, 2018
PYTHON_COMPAT=( "python3_"{10..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/HighCWu/face_morpher_plus.git"
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${FALLBACK_COMMIT}"
	SRC_URI="
https://github.com/HighCWu/face_morpher_plus/archive/${FALLBACK_COMMIT}.tar.gz
	-> ${P}-${FALLBACK_COMMIT:0:7}.tar.gz
	"
fi

DESCRIPTION="Face morpher plus based on facemorpher"
HOMEPAGE="
	https://github.com/HighCWu/face_morpher_plus
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" jpeg png"
RDEPEND+="
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/facemorpher[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/scipy[${PYTHON_USEDEP}]
	dev-python/stasm[${PYTHON_USEDEP}]
	media-libs/opencv[${PYTHON_USEDEP},jpeg?,png?,python]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_compile() {
	:
}

src_install() {
	docinto "licenses"
	dodoc "LICENSE"
	python_moduleinto "${MY_PN}"
	python_foreach_impl python_domodule "plotter.py" "process.py"
	dodir /usr/bin
cat <<EOF > "${ED}/usr/bin/${PN}"
#!/usr/bin
cd "/usr/lib/${EPYTHON}/site-packages/${PN}"
${EPYTHON} process.py "\$@"
EOF
	fperms 0755 "/usr/bin/${PN}"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
