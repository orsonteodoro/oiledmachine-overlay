# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs linux-info unpacker

DESCRIPTION="Radeon ProRender for Blender Material Library for Linux"
HOMEPAGE="https://www.amd.com/en/technologies/radeon-prorender-blender"
HOMEPAGE_DL=\
"https://www.amd.com/en/technologies/radeon-prorender-downloads"
LICENSE="AMD-RADEON-PRORENDER-BLENDER-EULA
	AMD-RADEON-PRORENDER-BLENDER-EULA-THIRD-PARTIES"
KEYWORDS="~amd64"
PLUGIN_NAME="rprblender"
MATLIB_NAME="rprmaterials"
S_FN="radeonprorendermateriallibraryinstaller.run"
MIN_BLENDER_V="2.80"
MAX_BLENDER_V="2.94" # exclusive
# Hash verified in Nov 13, 2021
SHA512SUM_MATLIB="f119d9002c2f1d2b260777393816660cb88a84e3e88e0c353297e787d5ce5672899c5b99527d42d28a86f5e6167931c7761d674148dadba1fc11b5d26980c317"
D_FN="${PN}-matlib-${SHA512SUM_MATLIB:0:7}.run"
SLOT="0/$(ver_cut 1-2 ${PV})"
RDEPEND="media-plugins/RadeonProRenderBlenderAddon"
RESTRICT="fetch strip"
SRC_URI="${D_FN}"
S="${WORKDIR}"
S_PLUGIN="${WORKDIR}/${PN}-${PV}-plugin"
S_MATLIB="${WORKDIR}/${PN}-${PV}-matlib"
D_USER_MATLIB="Documents/Radeon ProRender/Material Library"
D_MATERIALS="/usr/share/${PN}/${D_USER_MATLIB}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo "Please download"
	einfo "  - ${S_FN} (sha512sum is ${SHA512SUM_MATLIB})"
	einfo "from ${HOMEPAGE_DL} and rename it to ${D_FN} place it in ${distdir}"
}

_set_check_reqs_requirements() {
	# TODO update
	CHECKREQS_DISK_BUILD="970M"
	CHECKREQS_DISK_USR="739M"
}

pkg_pretend() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
}

pkg_setup() {
	_set_check_reqs_requirements
	check-reqs_pkg_setup
	ewarn \
"eclass/unpacker.eclass from the oiledmachine-overlay is required for \
Makeself 2.3.0 compatibility if ebuild copied to local repo."
}

src_unpack() {
	default
	mkdir -p "${S_MATLIB}" || die
	cd "${S_MATLIB}" || die
	unpack_makeself ${D_FN2}
}

src_install_systemwide_matlib() {
	cd "${S_MATLIB}" || die
	einfo "Copying materials..."
	dodir "${D_MATERIALS}"
	cp -a "${S_MATLIB}"/matlib/feature_MaterialLibrary/* \
		"${ED}/${D_MATERIALS}" || die
}

src_install_systemwide_plugin_meta() {
	mkdir -p "${S_PLUGIN}" || die
	cd "${S_PLUGIN}" || die
	local d
	DIRS=$(find /usr/share/blender/ -maxdepth 1 | tail -n +2)

	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files

	for d_ver in ${DIRS} ; do
		d_ver=$(basename ${d_ver})
		if ver_test ${MIN_BLENDER_V} -le ${d_ver} \
			&& ver_test ${d_ver} -lt ${MAX_BLENDER_V} ; then
			einfo "Blender ${d_ver} is supported.  Installing..."
			d_addon_base="/usr/share/blender/${d_ver}/scripts/addons_contrib"
			ed_addon_base="${ED}/${d_addon_base}"
			d_install="${d_addon_base}/${PLUGIN_NAME}"
			ed_install="${ED}/${d_install}"
			d_matlib_meta="${d_addon_base}/${MATLIB_NAME}"
			ed_matlib_meta="${ED}/${d_install}"

			exeinto "${d_matlib_meta}"
			doexe "${S_MATLIB}/uninstall.py"
			dodir "${d_matlib_meta}"
			dodir "${d_install}"
			echo "${D_MATERIALS}" > "${ed_matlib_meta}/.matlib_installed" || die
			echo "${D_MATERIALS}" > "${ed_install}/.matlib_installed" || die
		else
			einfo "Blender ${d_ver} not supported.  Skipping..."
		fi
	done

	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

src_install() {
	src_install_systemwide_plugin_meta
	src_install_systemwide_matlib

	cat <<EOF > ${T}/50${P}-matlib
RPR_MATERIAL_LIBRARY_PATH="${D_MATERIALS}/Xml"
EOF
	doenvd "${T}"/50${P}-matlib
}

pkg_postinst() {
	einfo
	einfo "The material library have been installed in:"
	einfo "${D_MATERIALS}"
	einfo
	env-update
	einfo "You must \`source /etc/profile\` or reboot in order for the Addon to see the material library"
	einfo
	einfo
	einfo "If you installed the material library previously, remove RPR_MATERIAL_LIBRARY_PATH from"
	einfo "your ~/.bashrc to use the system wide RPR_MATERIAL_LIBRARY_PATH setting or change it"
	einfo "per-profile to:"
	einfo
	einfo "export RPR_MATERIAL_LIBRARY_PATH=\"${D_MATERIALS}\""
	einfo
}
