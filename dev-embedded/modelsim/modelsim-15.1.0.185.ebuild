# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils check-reqs

DESCRIPTION="ModelSim"
HOMEPAGE="http://dl.altera.com/?edition=lite"
SRC_URI="ModelSimSetup-15.1.0.185-linux.run"

LICENSE="QUARTUS-PRIME-15.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="altera-edition altera-starter-edition desktop-menu-fix"
REQUIRED_USE="^^ ( altera-edition altera-starter-edition )"

RDEPEND="desktop-menu-fix? ( x11-terms/xfce4-terminal )
	 "
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S="${WORKDIR}"

CHECKREQS_DISK_BUILD="4960M"
CHECKREQS_DISK_USR="3720M"

VER="${PV:0:4}"
F="ModelSimSetup-${PV}-linux.run"
pkg_setup() {
	if [[ ! -f "${DISTDIR}/${F}" ]]; then
		die "Place ${F} in /usr/portage/distfiles"
	fi
}

src_unpack() {
	cp "${DISTDIR}/${F}" "${T}"
}

src_prepare() {
	chmod +x "${T}/${F}"

	eapply_user
}

src_install() {
	mkdir -p "${D}/opt/altera/${VER}"
	cd "${T}"
	myedition="modelsim_ase"
	if use altera-starter-edition; then
		myedition="modelsim_ase"
	elif use altera-edition; then
		myedition="modelsim_ae"
	fi

	./"${F}" --mode unattended --installdir "${D}/opt/altera/${VER}" --modelsim_edition "${myedition}"

	#menu wrapper
	mkdir -p "${D}/usr/bin"
	echo "#!/bin/bash" > "${D}/usr/bin/modelsim"
	if use desktop-menu-fix; then
		echo "if [[ \"\${#XDG_CURRENT_DESKTOP}\" > \"0\"  ]]; then" >> "${D}/usr/bin/modelsim" >> "${D}/usr/bin/modelsim"
	        echo "  xfce4-terminal -x /bin/sh -c \"cd /opt/altera/${VER}/${myedition}/linuxaloem/; ./vsim \$*\"" >> "${D}/usr/bin/modelsim"
		echo 'else' >> "${D}/usr/bin/modelsim"
	        echo "  cd /opt/altera/${VER}/${myedition}/linuxaloem/" >> "${D}/usr/bin/modelsim"
	        echo "  ./vsim \$*" >> "${D}/usr/bin/modelsim"
		echo "fi" >> "${D}/usr/bin/modelsim"
	else
	        echo "cd /opt/altera/${VER}/${myedition}/linuxaloem/" >> "${D}/usr/bin/modelsim"
	        echo "./vsim \$*" >> "${D}/usr/bin/modelsim"
	fi
	chmod +x "${D}/usr/bin/modelsim"

	make_desktop_entry "/usr/bin/modelsim" "ModelSim" "/opt/altera/${VER}/${myedition}/tcl/bitmaps/opt.gif" "Development;IDE"
}

pkg_config() {
	einfo "Place the ModelSim license.dat file in /opt/licenses/ "
}
