# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="agent-python"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_10 python3_11 )

inherit python-single-r1

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/hashtopolis/agent-python.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/hashtopolis/agent-python/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi
S="${WORKDIR}/${MY_P}"

DESCRIPTION="The official Python agent for using the distributed hashcracker Hashtopolis"
HOMEPAGE="https://github.com/hashtopolis/agent-python"
LICENSE="GPL-3"
SLOT="0"
IUSE="test"
RESTRICT="test"
RDEPEND="
	$(python_gen_cond_dep '
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
"
DEPEND="
	${RDEPEND}
"
# TODO: package
# confidence
# tuspy
# py7zr
BDEPEND="
	dev-vcs/git
	app-arch/unzip
	test? (
		$(python_gen_cond_dep '
			dev-python/confidence[${PYTHON_USEDEP}]
			dev-python/py7zr[${PYTHON_USEDEP}]
			dev-python/pytest[${PYTHON_USEDEP}]
			dev-python/tuspy[${PYTHON_USEDEP}]
		')
	)
"
PATCHES=(
)
DOCS=( changelog.md README.md )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_install() {
	python_moduleinto hashtopolis
	python_domodule htpclient __main__.py
	docinto licenses
	dodoc LICENSE.txt
	einstalldocs

	exeinto /usr/bin
cat <<EOF > "${T}/hashtopolis"
#!/bin/bash
python /usr/lib/${EPYTHON}/site-packages/hashtopolis
EOF
	doexe "${T}/hashtopolis"
}

pkg_postinst() {
einfo "Emerge app-crypt/hashtopolis for the server."
}
