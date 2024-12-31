# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="84bf836a4d9e130045c962c47ac4206395d4393b" # Jul 18, 2022
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	EGIT_REPO_URI="https://github.com/sobotka/filmic-blender.git"
	inherit git-r3
else
	KEYWORDS="amd64"
	SRC_URI="FIXME"
fi
S="${WORKDIR}/${P}"

DESCRIPTION="Film Emulsion-Like Camera Rendering Transforms for Blender®"
HOMEPAGE="https://sobotka.github.io/filmic-blender/"
# No license on new files discovered or old files if any and no default licenses.
# For commentary from the author about licensing numbers, see:
# https://github.com/sobotka/filmic-blender/pull/29#issuecomment-502137400
LICENSE="all-rights-reserved"
RESTRICT="fetch mirror"
SLOT="0/$(ver_cut 1-2 ${PV})" # 0/${PV} for latest
IUSE+=" fallback-commit"
# Reinstall if new blender
RDEPEND+="
	media-gfx/blender:=[color-management]
"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	cd "${S}" || die
	local package_names=(
		$(find \
			"${EROOT}/var/db/pkg/media-gfx/" \
			-maxdepth 1 \
			-name "blender*") \
	)
	local p
	for p in ${package_names[@]} ; do
		local blender_slot=
		local ebuild_path=$(realpath "${p}/"*".ebuild")
		local entry_name=
		local exe_path=
		local share_slot=
		local slot=
		local icon_name=
		local s

		local pv=$(cat "${p}/PF" \
			| cut -f 2 -d "-")

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
			local _version_frag=$(cat "${p}/PF" \
				| cut -f 2 -d "-")
			share_slot=$(ver_cut 1-2 "${_version_frag}")
			exe_path="/usr/bin/blender"
		fi

		insinto "/usr/share/blender/${share_slot}/datafiles/colormanagement_filmic"
		doins -r *

		make_desktop_entry \
			"env OCIO=/usr/share/blender/${share_slot}/datafiles/colormanagement_filmic/config.ocio ${exe_path} %f" \
			"${entry_name} (Filmic)" \
			"${icon_name}" \
			"Graphics;3DGraphics;"

		# Avoid file conflict
		cp -a \
			"${ED}/usr/share/applications/env-filmic-blender"{"","-${pv}"}".desktop" \
			|| die

		exeinto "/usr/bin"
		newexe \
			"${FILESDIR}/blender-filmic" \
			"blender-${blender_slot}-filmic"
		sed -i \
			-e "s|___BLENDER_CREATOR_PATH___|${exe_path}|g" \
			"${ED}/usr/bin/blender-${blender_slot}-filmic" \
			|| die
		sed -i \
			-e "s|\${SLOT}|${blender_slot}|g" \
			"${ED}/usr/bin/blender-${blender_slot}-filmic" \
			|| die
	done
	rm \
		"${ED}/usr/share/applications/env-filmic-blender.desktop" \
		|| die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
