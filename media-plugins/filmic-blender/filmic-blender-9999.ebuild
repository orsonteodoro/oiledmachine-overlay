# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop git-r3 xdg

DESCRIPTION="Film Emulsion-Like Camera Rendering Transforms for Blender"
HOMEPAGE="https://sobotka.github.io/filmic-blender/"
# No license on new files discovered or old files if any and no default licenses.
# For commentary from the author about licensing numbers, see:
# https://github.com/sobotka/filmic-blender/pull/29#issuecomment-502137400
LICENSE="all-rights-reserved"
KEYWORDS="amd64 ~x86"
SLOT="0/$(ver_cut 1-2 ${PV})" # 0/${PV} for latest
RDEPEND+=" media-gfx/blender:=[color-management]" # reinstall if new blender
IUSE+=" fallback-commit"
SRC_URI=""
S="${WORKDIR}/${P}"
RESTRICT="fetch mirror"

src_unpack() {
	EGIT_REPO_URI="https://github.com/sobotka/filmic-blender.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	use fallback-commit && EGIT_COMMIT="84bf836a4d9e130045c962c47ac4206395d4393b"
	git-r3_fetch
	git-r3_checkout
}

src_install() {
	cd "${S}" || die
	for p in $(find \
			"${EROOT}/var/db/pkg/media-gfx/" \
			-maxdepth 1 \
			-name "blender*") ; do
		local blender_slot=
		local ebuild_path=$(realpath ${p}/*ebuild)
		local entry_name=
		local exe_path=
		local share_slot=
		local slot=
		local icon_name=

		pv=$(cat "${p}/PF" | cut -f 2 -d "-")

		slot=$(cat "${p}/SLOT")
		slot_maj=${slot%/*}
		if bzcat "${p}/environment.bz2" \
			| grep -q -F -e "parent-datafiles-dir-change" ; then
			# Ebuild from this overlay
			exe_path="/usr/bin/blender-${slot_maj}"
			entry_name="Blender ${pv}"
			icon_name="blender-${slot_maj}"
			share_slot="${slot_maj}"
			blender_slot="${slot_maj}"
			exe_path="/usr/bin/blender-${slot_maj}"
		else
			# Ebuild from gentoo-overlay
			exe_path="/usr/bin/blender"
			entry_name="Blender"
			icon_name="blender"
			blender_slot="${slot_maj}"
			share_slot=$(ver_cut 1-2 $(cat "${p}/PF" | cut -f 2 -d "-"))
			exe_path="/usr/bin/blender"
		fi

		insinto /usr/share/blender/${share_slot}/datafiles/colormanagement_filmic
		doins -r *

		make_desktop_entry \
			"env OCIO=/usr/share/blender/${share_slot}/datafiles/colormanagement_filmic/config.ocio ${exe_path} %f" \
			"${entry_name} (Filmic)" \
			"${icon_name}" \
			"Graphics;3DGraphics;"

		# Avoid file conflict
		cp "${ED}/usr/share/applications/env-filmic-blender"{,-${pv}}".desktop" || die

		exeinto /usr/bin
		newexe "${FILESDIR}/blender-filmic" \
			"blender-${blender_slot}-filmic"
		sed -i -e "s|___BLENDER_CREATOR_PATH___|${exe_path}|g" \
			"${ED}/usr/bin/blender-${blender_slot}-filmic" || die
		sed -i -e "s|\${SLOT}|${blender_slot}|g" \
			"${ED}/usr/bin/blender-${blender_slot}-filmic" || die
	done
	rm "${ED}/usr/share/applications/env-filmic-blender.desktop" || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
