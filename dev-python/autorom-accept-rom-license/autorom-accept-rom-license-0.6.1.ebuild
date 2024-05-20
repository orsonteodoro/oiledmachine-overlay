# Copyright 2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

export AUTOROM_DOWNLOAD_METHOD="offline"
ID1="61b22aefce4456920ba99f2c36906eda"
ID2="00046ac3403768bfe45857610a3d333b8e35e026"
export AUTOROM_FILE_NAME="${PN}-roms-${ID1:0:7}-${ID2:0:7}.tar.gz.b64"
PYTHON_COMPAT=( python3_10 ) # Upstream tested up to 3.10
ROM_LIST=(
adventure.bin
air_raid.bin
alien.bin
amidar.bin
assault.bin
asterix.bin
asteroids.bin
atlantis.bin
atlantis2.bin
backgammon.bin
bank_heist.bin
basic_math.bin
battle_zone.bin
beam_rider.bin
berzerk.bin
blackjack.bin
bowling.bin
boxing.bin
breakout.bin
carnival.bin
casino.bin
centipede.bin
chopper_command.bin
combat.bin
crazy_climber.bin
crossbow.bin
darkchambers.bin
defender.bin
demon_attack.bin
donkey_kong.bin
double_dunk.bin
earthworld.bin
elevator_action.bin
enduro.bin
entombed.bin
et.bin
fishing_derby.bin
flag_capture.bin
freeway.bin
frogger.bin
frostbite.bin
galaxian.bin
gopher.bin
gravitar.bin
hangman.bin
haunted_house.bin
hero.bin
human_cannonball.bin
ice_hockey.bin
jamesbond.bin
journey_escape.bin
joust.bin
kaboom.bin
kangaroo.bin
keystone_kapers.bin
king_kong.bin
klax.bin
koolaid.bin
krull.bin
kung_fu_master.bin
laser_gates.bin
lost_luggage.bin
mario_bros.bin
maze_craze.bin
miniature_golf.bin
montezuma_revenge.bin
mr_do.bin
ms_pacman.bin
name_this_game.bin
othello.bin
pacman.bin
phoenix.bin
pitfall.bin
pitfall2.bin
pong.bin
pooyan.bin
private_eye.bin
qbert.bin
riverraid.bin
road_runner.bin
robotank.bin
seaquest.bin
sir_lancelot.bin
skiing.bin
solaris.bin
space_invaders.bin
space_war.bin
star_gunner.bin
superman.bin
surround.bin
tennis.bin
tetris.bin
tic_tac_toe_3d.bin
time_pilot.bin
trondead.bin
turmoil.bin
tutankham.bin
up_n_down.bin
venture.bin
video_checkers.bin
video_chess.bin
video_cube.bin
video_pinball.bin
warlords.bin
wizard_of_wor.bin
word_zapper.bin
yars_revenge.bin
zaxxon.bin
)

inherit distutils-r1

KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
S="${WORKDIR}/AutoROM-${PV}/packages/AutoROM.accept-rom-license"
SRC_URI="
https://github.com/Farama-Foundation/AutoROM/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	!skip-roms? (
https://gist.githubusercontent.com/jjshoots/${ID1}/raw/${ID2}/Roms.tar.gz.b64
	-> ${AUTOROM_FILE_NAME}
	)
"

DESCRIPTION="AutoROM ROMs"
HOMEPAGE="
https://github.com/Farama-Foundation/AutoROM
"
gen_rom_license() {
	local f
	for f in ${ROM_LIST[@]} ; do
		local name="${f/.bin}"
		echo "
			autorom_rom_${name}? (
				all-rights-reserved
			)
		"
	done
}
LICENSE="
	$(gen_rom_license)
	!skip-roms? (
		all-rights-reserved
	)
	MIT
"
RESTRICT="fetch mirror test"
SLOT="0/$(ver_cut 1-2 ${PV})"
gen_rom_iuse() {
	local f
	for f in ${ROM_LIST[@]} ; do
		echo "autorom_rom_${f/.bin}"
	done
}
# We do not auto opt-in to downloading ROMs in this ebuild.
IUSE+="
$(gen_rom_iuse)
+skip-roms test
"
gen_rom_required_use1() {
	local f
	for f in ${ROM_LIST[@]} ; do
		local name="${f/.bin}"
		echo "
			autorom_rom_${name}? (
				!skip-roms
			)
		"
	done
}
gen_rom_required_use2() {
	echo "
		!skip-roms? (
			|| (
	"
	local f
	for f in ${ROM_LIST[@]} ; do
		local name="${f/.bin}"
		echo "
				autorom_rom_${name}
		"
	done
	echo "
			)
		)
	"
}
REQUIRED_USE+="
	$(gen_rom_required_use1)
	$(gen_rom_required_use2)
	${PYTHON_REQUIRED_USE}
"
RDEPEND+="
	${PYTHON_DEPS}
	>=dev-python/autorom-${PV}:${SLOT}[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/Farama-Notifications[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/ale-py[${PYTHON_USEDEP}]
		dev-python/multi-agent-ale-py[${PYTHON_USEDEP}]
	)
"
_PATCHES=(
	"${FILESDIR}/autorom-accept-rom-license-0.6.1-offline-install.patch"
)

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	local src_fn
	local dest_fn
	if use skip-roms ; then
		:
	else
einfo
einfo "You must download, rename, and move the file to:"
einfo
einfo "Donwload URI:  https://gist.githubusercontent.com/jjshoots/${ID1}/raw/${ID2}/Roms.tar.gz.b64"
einfo "Destination:   ${distdir}/${AUTOROM_FILE_NAME}"
einfo
einfo "You may download the tarball if it applies:"
einfo
einfo "I own a license to these Atari 2600 ROMs."
einfo "I agree to not distribute these ROMs and wish to proceed."
einfo
einfo "You may skip downloading by using the skip-roms USE flag."
einfo
	fi
}

python_prepare_all() {
	S="${WORKDIR}/AutoROM-${PV}"
	pushd "${S}" >/dev/null 2>&1 || die
		eapply ${_PATCHES[@]}
	popd >/dev/null 2>&1 || die
	S="${WORKDIR}/AutoROM-${PV}/packages/AutoROM.accept-rom-license"
	pushd "${S}" >/dev/null 2>&1 || die
		distutils-r1_python_prepare_all
	popd >/dev/null 2>&1 || die
}

python_install() {
	if use skip-roms ; then
		export AUTOROM_SKIP_ROMS="yes"
ewarn
ewarn "You must manually add the ROM(s) in .bin format to:"
ewarn
ewarn "  /usr/lib/${EPYTHON}/site-packages/AutoROM/roms"
ewarn
		keepdir "/usr/lib/${EPYTHON}/site-packages/AutoROM/roms"
	else
		export AUTOROM_SKIP_ROMS="no"
	fi
	distutils-r1_python_install
}

python_install_all() {
	if use skip-roms ; then
		export AUTOROM_SKIP_ROMS="yes"
	else
		export AUTOROM_SKIP_ROMS="no"
	fi
	distutils-r1_python_install_all
	rm -rf $(find "${ED}" -name "__pycache__")

	local f
	for f in ${ROM_LIST[@]} ; do
		local name="${f/.bin}"
		if use "autorom_rom_${name}" ; then
einfo "Keeping ${name}.bin"
		else
einfo "Removing ${name}.bin"
			find "${ED}" -name "${name}.bin" -delete
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
