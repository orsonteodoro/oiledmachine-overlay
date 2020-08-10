# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Rewrite of https://github.com/AppImage/zsync-curl, using modern \
C++, providing both a library and standalone tools."
HOMEPAGE="https://github.com/AppImage/zsync2"
LICENSE="Artistic" # project default license
# Third party licenses
LICENSE+=" MIT" # args, cpr
LICENSE+=" BSD" # googletest
LICENSE+=" all-rights-reserved GPL-2" # mongoose ; no all rights reserved in GPL-2
LICENSE+=" curl" # curl
LICENSE+=" all-rights-reserved ZLIB" # hashlib ; the ZLIB license does not have all rights reserved
LICENSE+=" Artistic" # librcksum, libzsync
LICENSE+=" ZLIB" # zlib
KEYWORDS="~amd64 ~x86"
DEPEND="${RDEPEND}"
SLOT="0/${PV}"
EGIT_COMMIT="10e85c0eab4da4a1a85a949fb0f69d77cef9972f"
EGIT_COMMIT_ARGS="b50b5c45ba1134e9f9b3fdf6f12d75ff725857bc"
EGIT_COMMIT_CPR="6d4ae7129093a47534166015a076e7bc83233677"
EGIT_COMMIT_GOOGLETEST="ec44c6c1675c25b9827aacd08c02433cccde7780"
EGIT_COMMIT_CPR_CURL="3ea76790571c1f7cf1bed34fabffd3cc20ad3dd3"
EGIT_COMMIT_CPR_GOOGLETEST="3be1ef9f1c6139654a7784c53aa833c7a37a3148"
EGIT_COMMIT_CPR_MONGOOSE="df9f7a795e65657017ab302d6367a49fdd4da183"
SRC_URI=\
"
https://github.com/AppImage/zsync2/archive/${EGIT_COMMIT}.tar.gz \
	 -> ${P}.tar.gz
https://github.com/Taywee/args/archive/${EGIT_COMMIT_ARGS}.tar.gz \
	-> ${P}-args.tar.gz
https://github.com/AppImage/cpr/archive/${EGIT_COMMIT_CPR}.tar.gz \
	-> ${P}-cpr.tar.gz
https://github.com/whoshuu/curl/archive/${EGIT_COMMIT_CPR_CURL}.tar.gz \
	-> ${P}-cpr-curl.tar.gz
https://github.com/whoshuu/googletest/archive/${EGIT_COMMIT_CPR_GOOGLETEST}.tar.gz \
	-> ${P}-cpr-googletest.tar.gz
https://github.com/whoshuu/mongoose/archive/${EGIT_COMMIT_CPR_MONGOOSE}.tar.gz \
	-> ${P}-cpr-mongoose.tar.gz
https://github.com/google/googletest/archive/${EGIT_COMMIT_GOOGLETEST}.tar.gz \
	-> ${P}-googletest.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
inherit cmake-utils
PATCHES=( "${FILESDIR}/${PN}-2.0.0_alpha1_p20200303-custom-libdir.patch" )

src_unpack() {
	unpack ${A}
	rm -rf "${S}/lib/"{args,cpr,gtest} || die
	ln -s "${WORKDIR}/args-${EGIT_COMMIT_ARGS}" \
		"${S}/lib/args" || die
	ln -s "${WORKDIR}/cpr-${EGIT_COMMIT_CPR}" \
		"${S}/lib/cpr" || die
	ln -s "${WORKDIR}/googletest-${EGIT_COMMIT_GOOGLETEST}" \
		"${S}/lib/gtest" || die
	rm -rf "${S}/lib/cpr/opt/"{curl,googletest,mongoose} || die
	ln -s "${WORKDIR}/curl-${EGIT_COMMIT_CPR_CURL}" \
		"${S}/lib/cpr/opt/curl" || die
	ln -s "${WORKDIR}/googletest-${EGIT_COMMIT_CPR_GOOGLETEST}" \
		"${S}/lib/cpr/opt/googletest" || die
	ln -s "${WORKDIR}/mongoose-${EGIT_COMMIT_CPR_MONGOOSE}" \
		"${S}/lib/cpr/opt/mongoose" || die
}

src_install() {
	cmake-utils_src_install
	dodoc README.md
	docinto licenses
	dodoc COPYING
	docinto licenses/thirdparty/args
	dodoc "${S}/lib/args/LICENSE"
	docinto licenses/thirdparty/cpr
	dodoc "${S}/lib/cpr/LICENSE"
	docinto licenses/thirdparty/cpr/thirdparty/curl
	dodoc "${S}/lib/cpr/opt/curl/COPYING"
	docinto licenses/thirdparty/cpr/thirdparty/googletest
	dodoc "${S}/lib/cpr/opt/googletest/LICENSE"
	docinto licenses/thirdparty/cpr/thirdparty/mongoose
	dodoc "${S}/lib/cpr/opt/mongoose/LICENSE"
	docinto licenses/thirdparty/gtest/googlemock
	dodoc "${S}/lib/gtest/googlemock/LICENSE"
	docinto licenses/thirdparty/gtest/googletest
	dodoc "${S}/lib/gtest/googletest/LICENSE"
	docinto licenses/thirdparty/librcksum
	head -n 15 "${S}/lib/librcksum/rcksum.h" \
		> "${T}/LICENSE" || die
	dodoc "${T}/LICENSE"
	docinto licenses/thirdparty/libzsync
	head -n 14 "${S}/lib/libzsync/zsync.h" \
		> "${T}/LICENSE" || die
	dodoc "${T}/LICENSE"
	docinto licenses/thirdparty/zlib
	head -n 29 "${S}/lib/zlib/zlib.h" \
		> "${T}/LICENSE" || die
	dodoc "${T}/LICENSE"
	docinto licenses/thirdparty/hashlib
	dodoc "${FILESDIR}/LICENSE.hashlib"
	insinto /usr/include/zsync2
	doins -r include/*
	doins -r lib/cpr/include/*
	doins lib/args/args.hxx
	insinto /usr/include/zsync2/hashlib
	doins -r lib/hashlib/include/hashlib/*
	# This needs to unbundled or it might cause merge conflict
	cd "${BUILD_DIR}" || die
	dolib.so lib/libcpr.so
	dolib.so lib/libzsync/libzsync.so
}
