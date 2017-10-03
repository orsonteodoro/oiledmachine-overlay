# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION=""
HOMEPAGE="https://gitorious.org/bitcoin/python-base58?p=bitcoin:python-base58.git;a=summary"
COMMIT="4b6453f754b2d4026e7a48acbdc4e0bf2a5b8ef2"
SHORT_HASH="${COMMIT:0:7}"
PROJECT_NAME="python-base58"
MAINTAINER_NAME="bitcoin"
SRC_URI="https://gitorious.org/${MAINTAINER_NAME}/${PROJECT_NAME}?p=bitcoin:${PROJECT_NAME}.git;a=snapshot;h=${COMMIT};sf=tgz -> ${PN}.${PV}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MAINTAINER_NAME}${PROJECT_NAME}-${SHORT_HASH}"

python_prepare_all() {
	eapply_user

	distutils-r1_python_prepare_all
}

src_compile() {
	true
}

src_install() {
        inst() {
		mkdir -p "${D}/$(python_get_sitedir)"
		cp -a base58.py "${D}/$(python_get_sitedir)"
        }

	python_foreach_impl inst
}
