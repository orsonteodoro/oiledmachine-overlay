# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils cmake-utils

DESCRIPTION="Caesium Command Line Tools - Lossy/lossless image compression tool using mozjpeg and zopflipng"
HOMEPAGE="http://saerasoft.com/caesium/clt"
CAESIUMCTL_COMMIT="6de55b23c9330b048f7cc5c3036e801bd69eac9c"
SRC_URI="https://github.com/Lymphatus/CaesiumCLT/archive/${CAESIUMCTL_COMMIT}.zip -> caesiumctl-${CAESIUMCTL_COMMIT}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libcaesium
	 media-libs/libjpeg-turbo"
DEPEND="${RDEPEND}"

S="${WORKDIR}/caesium-clt-${CAESIUMCTL_COMMIT}"
