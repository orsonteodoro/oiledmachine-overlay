# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Simple http wrapper around jedi"
HOMEPAGE="http://code.google.com/p/argparse"
COMMIT="c376aadd89c7687ecf2c7a68f4cbecab3bbcd57b"
PROJECT_NAME="JediHTTP"
SRC_URI="https://github.com/vheon/${PROJECT_NAME}/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=dev-python/jedi-0.10.0[${PYTHON_USEDEP}]
         dev-python/bottle[${PYTHON_USEDEP}]
         dev-python/argparse[${PYTHON_USEDEP}]
         dev-python/waitress[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PROJECT_NAME}-${COMMIT}"

python_prepare_all() {
	rm -rf "jedihttp/tests"
	echo -e "#!/usr/bin/python\n$(cat jedihttp.py)" > jedihttp.py

	eapply "${FILESDIR}/${PN}-9999.20170103.patch"

	eapply_user

	distutils-r1_python_prepare_all
}

src_compile() {
	true
}

src_install() {
        inst() {
		mkdir -p "${D}/$(python_get_sitedir)"
		chmod +x jedihttp.py
		cp -a jedihttp.py "${D}/$(python_get_sitedir)"
                python_domodule jedihttp
        }

	python_foreach_impl inst

	link() {
		mkdir -p "${D}/usr/lib/python-exec/${EPYTHON}"
		ln -s "$(python_get_sitedir)/jedihttp.py" "${D}/usr/lib/python-exec/${EPYTHON}/jedihttp.py"
	}

	python_foreach_impl link

	mkdir -p "${D}/usr/bin/"
	ln -s "${D}/usr/lib/python-exec/python-exec2" "${D}/usr/bin/jedihttp.py"
}
