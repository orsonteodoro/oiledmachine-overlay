# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Java based plugin allowing LateralGM to compile games using \
ENIGMA."
HOMEPAGE="https://github.com/enigma-dev/lgmplugin"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
SLOT="0/${PV}"
ECJ_V="4.4"
JAVA_V="1.7"
RDEPEND="games-util/lateralgm
	 virtual/jre"
DEPEND="|| ( dev-java/icedtea
	     dev-java/icedtea-bin )
	dev-java/jna[nio-buffers]
	games-util/lateralgm"
BDEPEND="dev-java/eclipse-ecj:${ECJ_V}
	 virtual/jdk"
EGIT_COMMIT="c305accc8e6bb5edbefeab4d77dc3e3958eea905"
SRC_URI=\
"https://github.com/enigma-dev/lgmplugin/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz"
inherit enigma eutils multilib-build
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"

patch_impl() {
	local suffix=""
	local descriptor_suffix=""
	if [[ "${EENIGMA}" == "linux" ]] ; then
		suffix="-${ABI}"
		descriptor_suffix=" (${ABI})"
	fi

	which /usr/bin/ecj-4.4 || die
	sed -i -e \
"s|\
JC = ecj -1.6 -nowarn -cp .|\
JC = /usr/bin/ecj-${ECJ_V} -${JAVA_V} -nowarn -cp .|" \
		Makefile || die
	sed -i -e \
"s|\
../plugins/shared/jna.jar:\
../lgm16b4.jar:\
/usr/share/java/eclipse-ecj.jar:\
/usr/share/java/ecj.jar\
|\
/usr/share/jna/lib/jna.jar:\
/usr/$(get_libdir)/enigma/${EENIGMA}${suffix}/lateralgm.jar:\
/usr/share/eclipse-ecj-${ECJ_V}/lib/ecj.jar|" \
		Makefile || die
	sed -i -e "s|../plugins/enigma.jar|enigma.jar|" Makefile || die
	sed -i -e "s|        |\t|" Makefile || die
	sed -i -e \
"s|\
../lateralgm.jar \
shared/svnkit.jar \
shared/jna.jar\
|\
../lateralgm.jar \
/usr/$(get_libdir)/enigma/${EENIGMA}${suffix}/swinglayout-lgm.jar \
/usr/share/jna/lib/jna.jar|" \
		META-INF/MANIFEST.MF || die
}

src_prepare() {
	default

	enigma_copy_sources
	platform_prepare() {
		cd "${BUILD_DIR}" || die
		multilib_copy_sources
	}
	enigma_foreach_impl platform_prepare

	platform_prepare2() {
		cd "${BUILD_DIR}" || die
		ml_install_abi() {
			cd "${BUILD_DIR}" || die
			patch_impl
		}
		multilib_foreach_abi ml_install_abi
	}
	enigma_foreach_impl platform_prepare2
}

src_compile() {
	platform_compile() {
		cd "${BUILD_DIR}" || die
		ml_install_abi() {
			cd "${BUILD_DIR}" || die
			#icedtea is required because of missing classes
			MAKEOPTS="-j1" \
			emake
		}
		multilib_foreach_abi ml_compile_abi
	}
	enigma_foreach_impl platform_compile
}

src_install() {
	platform_install() {
		cd "${BUILD_DIR}" || die
		ml_install_abi() {
			cd "${BUILD_DIR}" || die
			local suffix=""
			local descriptor_suffix=""
			if [[ "${EENIGMA}" == "linux" ]] ; then
				suffix="-${ABI}"
				descriptor_suffix=" (${ABI})"
			fi
			insinto "/usr/$(get_libdir)/enigma/${EENIGMA}${suffix}/plugins"
			doins enigma.jar
		}
		multilib_foreach_abi ml_install_abi
	}
	enigma_foreach_impl platform_install
}
