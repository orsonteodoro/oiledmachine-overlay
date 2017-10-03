# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )

inherit distutils-r1

DESCRIPTION=""
HOMEPAGE="https://gitorious.org/midstate/midstate"
COMMIT="1a67a27a158cb149802f72a243d9d5362fa687af"
SHORT_HASH="${COMMIT:0:7}"
PROJECT_NAME="midstate"
MAINTAINER_NAME="midstate"
SRC_URI="https://gitorious.org/${MAINTAINER_NAME}/${PROJECT_NAME}?p=${PROJECT_NAME}:${PROJECT_NAME}.git;a=snapshot;h=${COMMIT};sf=tgz -> ${PN}.${PV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${MAINTAINER_NAME}${PROJECT_NAME}-${SHORT_HASH}"

src_prepare() {
        eapply_user

        python_copy_sources

        python_foreach_impl python_prepare_all
}

python_prepare_all() {
	sed -i -e "s|python3.2|${EPYTHON}m|g" Makefile
}

src_compile() {
	emake
}

src_install() {
        inst() {
		mkdir -p "${D}/$(python_get_sitedir)"
		cp -a midstate.so "${D}/$(python_get_sitedir)"
        }

	python_foreach_impl inst
}
