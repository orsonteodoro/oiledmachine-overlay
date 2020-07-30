# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Purely experimental playground for Go implementation of AppImage\
tools"
HOMEPAGE="https://github.com/probonopd/go-appimage"
LICENSE="MIT" # go-appimage project's default license
LICENSE+=" Apache-2.0 BSD BSD-2 EPL-1.0 GPL-3 ISC MPL-2.0" # dependencies of go various micropackages
# static libraries below
# aid = included in appimaged ; ait = included in appimagetool
LICENSE+=" BSD BSD-2 BSD-4 public-domain" # libarchive aid
LICENSE+=" GPL-2" # squashfs-tools ait aid
LICENSE+=" GPL-2+" # desktop-file-utils ait
LICENSE+=" GPL-3" # patchelf # ait
LICENSE+=" all-rights-reserved MIT" # runtime from runtime.c from AppImageKit # MIT license does not have all rights reserved
LICENSE+=" MIT" # upload tool
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
RDEPEND="sys-apps/dbus"
DEPEND="${RDEPEND}
	>=dev-lang/go-1.13.4"
SLOT="0/${PV}"
EGIT_COMMIT="4ac0e102e05507f43c82beef558d0eedba0e50ae"
SRC_URI=\
"https://github.com/probonopd/go-appimage/archive/${EGIT_COMMIT}.tar.gz
	 -> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/${PN}-9999_p20200722-gentooize.patch" )

# See scripts/build.sh

pkg_setup() {
	if has network-sandbox $FEATURES ; then
		die \
"${PN} requires network-sandbox to be disabled in FEATURES in order to download\n\
micropackages."
	fi
}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	chmod +x ./scripts/build.sh || die
	eapply ${PATCHES[@]}
	# Workaround emerge policy concerning downloads in src_compile phase.
	./scripts/build.sh
}

src_prepare() {
	# fork to compile
	touch "${T}/.portage_user_patches_applied"
	touch "${PORTAGE_BUILDDIR}/.user_patches_applied"
}

src_compile() {
	:;
}

# @FUNCTION: npm-utils_install_licenses
# @DESCRIPTION:
# Installs all licenses from main package and micropackages
# Standardizes the process.
install_licenses() {
	local source_dir="${1}"
	OIFS="${IFS}"
	export IFS=$'\n'
	for f in $(find "${source_dir}" \
	  -iname "*license*" -type f \
	  -o -iname "*copyright*" \
	  -o -iname "*copying*" \
	  -o -iname "*patent*" \
	  -o -iname "ofl.txt" \
	  -o -iname "*notice*" \
	  ) ; \
	do
		if [[ -f "${f}" ]] ; then
			d=$(dirname "${f}" | sed -r -e "s|^${source_dir}||")
		else
			d=$(echo "${f}" | sed -r -e "s|^${source_dir}||")
		fi
		docinto "licenses/${d}"
		dodoc -r "${f}"
	done
	export IFS="${OIFS}"
}

src_install() {
	exeinto /usr/bin
	BUILD_DIR="${WORKDIR}/go_build/src"
	# No support for multi go yet the other is false
	doexe "${BUILD_DIR}/"appimaged-${ARCH//x86/386}
	doexe "${BUILD_DIR}/"appimagetool-${ARCH//x86/386}
	dosym ../../../usr/bin/appimaged-${ARCH//x86/386} /usr/bin/appimaged
	dosym ../../../usr/bin/appimagetool-${ARCH//x86/386} /usr/bin/appimagetool
	install_licenses "${BUILD_DIR}"
	docinto licenses
	dodoc "${S}/LICENSE"
	docinto readme
	dodoc "${S}/README.md"
	cp "${S}/src/appimaged/README.md" > "${T}/appimaged-README.md"
	dodoc "${T}/appimaged-README.md"
	cp "${S}/src/appimagetool/README.md" > "${T}/appimagetool-README.md"
	dodoc "${T}/appimagetool-README.md"
}
