# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Film Emulsion-Like Camera Rendering Transforms for Blender"
HOMEPAGE="https://sobotka.github.io/filmic-blender/"
KEYWORDS="amd64 ~x86"
# No license on new files discovered or old files if any and no default licenses.
LICENSE="all-rights-reserved"
SLOT="sheepit/${PV}" # 0/${PV} for latest, sheepit/${PV} for sheep it only
RESTRICT="fetch mirror"
RDEPEND="media-gfx/blender:=[color-management]" # reinstall if new blender
inherit desktop xdg
FILMIC_COMMIT="f94ebab8ad3ad917d3201230ebca1bc3a93b7c86"
DEST_FN="filmic-${FILMIC_COMMIT}.zip"
SRC_URI="\
https://github.com/sobotka/filmic-blender/archive/${FILMIC_COMMIT}.zip \
	-> ${DEST_FN}"
DL_URL="https://github.com/sobotka/filmic-blender/tree/${FILMIC_COMMIT}"
S="${WORKDIR}/filmic-blender-${FILMIC_COMMIT}"

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"You need to obtain filmic-blender from ${DN_URL} and rename it as ${DEST_FN} \
then place it in ${distdir}"
}

src_install() {
	cd "${S}" || die
	for p in $(find "${EROOT}/var/db/pkg/media-gfx/" -maxdepth 1 \
			-name "blender*") ; do
		local blender_slot=
		local ebuild_path=$(realpath ${p}/*ebuild)
		local entry_name=
		local exe_path=
		local share_slot=
		local slot=
		local icon_name=

		pv=$(cat "${p}/PF" | cut -f 2 -d "-")
		[[ "${pv}" =~ 2.79b ]] || continue

		slot=$(cat "${p}/SLOT")
		slot_maj=${slot%/*}
		if bzcat "${p}/environment.bz2" \
			| grep -q -F -e "parent-datafiles-dir-change" ; then
			# ebuild from this overlay
			exe_path="/usr/bin/blender-${slot_maj}"
			entry_name="Blender ${pv}"
			icon_name="blender-${slot_maj}"
			share_slot="${slot_maj}"
			blender_slot="${slot_maj}"
			exe_path="/usr/bin/blender-${slot_maj}"
		else
			# ebuild from gentoo-overlay
			exe_path="/usr/bin/blender"
			entry_name="Blender"
			icon_name="blender"
			blender_slot="${slot_maj}"
			share_slot=$(ver_cut 1-2 $(cat "${p}/PF" | cut -f 2 -d "-"))
			exe_path="/usr/bin/blender"
		fi

		insinto \
/usr/share/blender/${share_slot}/datafiles/colormanagement_filmic_sheepit
		doins -r *

		# avoid file conflict
		cp "${ED}/usr/share/applications/env-filmic-blender-sheepit"{,-${pv}}".desktop" || die

		exeinto /usr/bin
		newexe "${FILESDIR}/blender-filmic-sheepit" \
			"blender-${blender_slot}-filmic-sheepit"
		sed -i -e "s|___BLENDER_CREATOR_PATH___|${exe_path}|g" \
			"${ED}/usr/bin/blender-${blender_slot}-filmic-sheepit" || die
		sed -i -e "s|\${SLOT}|${blender_slot}|g" \
			"${ED}/usr/bin/blender-${blender_slot}-filmic-sheepit" || die
	done
}
