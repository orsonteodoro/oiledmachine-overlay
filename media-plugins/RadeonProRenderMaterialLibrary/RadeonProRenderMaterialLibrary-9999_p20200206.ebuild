# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
MAX_BLENDER_V="2.93" # exclusive
SHA512SUM_MATLIB="f119d9002c2f1d2b260777393816660cb88a84e3e88e0c353297e787d5ce5672899c5b99527d42d28a86f5e6167931c7761d674148dadba1fc11b5d26980c317"
D_FN="${PN}-matlib-${SHA512SUM_MATLIB:0:7}.run"
SLOT="0/${PV}"
IUSE="systemwide"
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

	if ! use systemwide ; then
		if [[ -z "${RPR_USERS}" ]] ; then
			eerror "You must add RPR_USERS to your make.conf or per-package-wise"
			eerror "Example RPR_USERS=\"johndoe janedoe\""
			die
		fi
	fi
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

src_install_systemwide_plugin() {
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

src_install_per_user() {
	for u in ${RPR_USERS} ; do
		einfo "Installing addon for user: ${u}"
		local d_addon="/home/${u}/.local/share/${PLUGIN_NAME}"
		local ed_addon="${ED}/${d_addon}"
		local d_matlib_meta="/home/${u}/.local/share/rprmaterials"
		local ed_matlib_meta="${ED}/${d_matlib_meta}"
		local d_matlib="/home/${u}/${D_USER_MATLIB}"
		local ed_matlib="${ED}/${d_matlib}"

		cd "${S_MATLIB}" || die
		insinto "${d_matlib}"
		doins -r matlib/feature_MaterialLibrary/*
		exeinto "${d_matlib_meta}"
		doexe uninstall.py
		dodir "${d_matlib_meta}"
		dodir "${ed_addon}"
		echo "${d_matlib}" > "${ed_matlib_meta}/.matlib_installed" || die
		echo "${d_matlib}" > "${ed_addon}/.matlib_installed" || die
		fowners -R ${u}:${u} "${d_matlib}"
		fowners -R ${u}:${u} "${d_matlib_meta}"
		fowners -R ${u}:${u} "${d_addon}"
	done
}

src_install() {
	if use systemwide ; then
		src_install_systemwide_plugin # add metainfo
		src_install_systemwide_matlib

		cat <<EOF > ${T}/50${P}-matlib
RPR_MATERIAL_LIBRARY_PATH="${D_MATERIALS}/Xml"
EOF
		doenvd "${T}"/50${P}-matlib
	else
		src_install_per_user
	fi
}

pkg_postinst() {
	if use systemwide ; then
		einfo
		einfo "The material library have been installed in:"
		einfo "${D_MATERIALS}"
	else
		einfo "You must install this product manually through blender per user."
		for u in ${RPR_USERS} ; do
			local d_matlib="/home/${u}/${D_USER_MATLIB}/Xml"
			local blender_ver=$(ls "${EROOT}/usr/share/blender/")
			einfo "Materials location: ${d_matlib}"
			einfo "To tell ${PN} the location of the materials directory:"
			einfo
			einfo "  Add the following to /home/${u}/.bashrc"
			einfo "  export RPR_MATERIAL_LIBRARY_PATH=\"${d_matlib}\""
			einfo "  Then, re-log."
			einfo
		done
	fi
}
