# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="w3crapcli/last.fm provides a command line interface for the \
last.fm web service"
LICENSE="WTFPL-2"
HOMEPAGE="https://github.com/l29ah/w3crapcli"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE+="
doc download-tracks gettracks glistfm grab-lastfm-userpic lastfmpost mpv
mplayerfm savedconfig r1
"
REQUIRED_USE+=" savedconfig" # \
# Potential security problem.  Portage doesn't encrypt environment.bz2
# especially security sensitive variables.
# Some setups may have unencrypted root but encrypted home.
DEPEND+="
	download-tracks? (
		app-shells/zsh
		app-text/tidy-html5
		dev-haskell/haxml
		net-misc/curl
		net-misc/wget
	)
	gettracks? (
		dev-lang/ghc
		net-misc/curl
	)
	glistfm? (
		net-misc/curl
	)
	grab-lastfm-userpic? (
		net-misc/wget
	)
	lastfmpost? (
		net-misc/wget
	)
	mplayerfm? (
		media-sound/scrobbler
		media-libs/mutagen
	)
	mpv? (
		dev-lang/lua
		media-sound/scrobbler
		media-video/mpv[lua]
	)
"
# use media-sound/scrobbler from booboo overlay
EGIT_COMMIT="3bd665ada8d514ef39c2629bc4f1be0f2a3d0b67"
FN_PREFIX="w3crapcli-last.fm-${EGIT_COMMIT}-"
BASE_URL=\
"https://raw.githubusercontent.com/l29ah/w3crapcli/${EGIT_COMMIT}/last.fm/"
N_FILES=6 # N-1
REMOTE_FNS=(
	download-tracks
	gettracks.hs
	glistfm.sh
	grab-lastfm-userpic
	lastfmpost
	mplayerfm
	mpv-lastfm.lua
)
CACHED_FNS=( ${REMOTE_FNS[@]/#/${FN_PREFIX}} )
url_generator() {
	local s=""
	local i
	for ((i=0 ; i <= ${N_FILES} ; i+=1)) ; do
		s+=" ${BASE_URL}${REMOTE_FNS[${i}]} -> ${FN_PREFIX}${REMOTE_FNS[${i}]}"
	done
	echo ${s}
}
SRC_URI="
$(url_generator)
https://github.com/l29ah/w3crapcli/blob/${EGIT_COMMIT}/LICENSE
	-> w3crapcli-${EGIT_COMMIT}-LICENSE
https://github.com/l29ah/w3crapcli/blob/${EGIT_COMMIT}/README.md
	-> w3crapcli-${EGIT_COMMIT}-README.md
"
RESTRICT="mirror"
S="${WORKDIR}/${PN}-${PV}"
DOCS=( README.md )

sanitize_variables() {
	USERFOLDER=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	USEROWNER=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	LFM_NAME=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	LFM_PASS=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	APP_NAME=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
	APP_API_KEYAPP_SHARED_SECRET=$(dd bs=4096 count=1 if=/dev/random of=/dev/stdout 2>/dev/null | base64)
}

pkg_setup() {
# The emerge system needs a special API to handle sensitive data.
# Possible ebuild system flaw.
# It is possible for environment.bz2 to save data across multiple emerged package in plaintext.
ewarn
ewarn "Do not set LFM_NAME, LFM_PASS, APP_API_KEY, APP_SHARED_SECRET"
ewarn "if multiple prior ebuild packages are being emerged prior to ${PN}."
# It could happen if passed via command line but only should be passed via the
# package.env system.
ewarn "Only ${PN} should be emerged alone with this information."
ewarn
ewarn "After being built, this information provided via package.env or"
ewarn "by patch should be sanitized from forensics attacks."
ewarn
	sleep 30
	if use savedconfig ; then
		if [[ -z "${SAVEDCONFIG_PATH}" ]] ; then
eerror
eerror "You must define SAVEDCONFIG_PATH environment variable as the abspath"
eerror "to the settings."
eerror
			die
		fi
		if [[ ! -f "${SAVEDCONFIG_PATH}" ]] ; then
cat \
<<EOF
------------------ CUT BELOW -------------------------------
USERFOLDER="/home/myname"
USEROWNER="myowner"
USERGROUP="mygroup"
LFM_NAME="mylastfmname"
LFM_PASS="mylastfmpass"
APP_NAME="myappname"
APP_API_KEY="myappapikey"
APP_SHARED_SECRET="myappsharedsecret"
------------------ CUT ABOVE -------------------------------
EOF
eerror
eerror "You must fill out your own savedconfig before preceeding.  Copy and"
eerror "edit the into ${SAVEDCONFIG_PATH} and try again.  Make sure the"
eerror "permission is 700 and stored in a encrypted device."
eerror
			die
		fi
	fi
}

src_unpack() {
	mkdir -p "${S}"
	cd "${S}"
	unpack ${A}
	for i in $(seq 0 ${N_FILES}) ; do
		einfo "copying ${DISTDIR}/${FN_PREFIX}${REMOTE_FNS[${i}]}"
		cat "${DISTDIR}/${FN_PREFIX}${REMOTE_FNS[${i}]}" \
			> "${REMOTE_FNS[${i}]}" || die
	done
	cat "${DISTDIR}/w3crapcli-${EGIT_COMMIT}-LICENSE" \
			> LICENSE
	cat "${DISTDIR}/w3crapcli-${EGIT_COMMIT}-README.md" \
			> README.md
}

src_prepare() {
	default
	if use mplayerfm ; then
		ewarn "mplayerfm uses deleted script.  Provide user patch to fix"
		:;
		#eapply "${FILESDIR}/mplayerfm-use-hauzer-scrobbler.patch"
	fi
}

src_install() {
	exeinto "/usr/share/${PN}"
	doexe ${REMOTE_FNS[@]}
	dodoc LICENSE
}

cpown() {
	local src=$(realpath "${1}")
	local src_basename=$(basename "${src}")
	local dest=$(realpath "${2}")
	cp -a "${src}" "${dest}" || die
	if [[ ! -d "${dest}" ]] ; then
		mkdir -p "${dest}" || die
		chown ${USEROWNER}:${USERGROUP} \
			"${dest}" || die
	fi
	chown -R ${USEROWNER}:${USERGROUP} \
		"${d}/${src_basename}" || die
	einfo "Copied ${src_basename} to ${dest}"
	chown 0700 "${d}/${src_basename}" || die
}

_set_settings() {
	local d="${USERFOLDER}/.local/bin"
	mkdir -p "${d}" || die
	local s="/usr/share/${PN}"
	if use download-tracks ; then
		cpown "${s}/download-tracks" "${d}"
	fi
	if use gettracks ; then
		cpown "${s}/gettracks.hs" "${d}"
		sed -i -e "s|ae26d4892e373c6fc188acf7e3cb36c3|${APP_API_KEY}|g" \
			"${d}/gettracks.hs" || die
	fi
	if use glistfm ; then
		cpown "${s}/glistfm.sh" "${d}"
		sed -i -e "s|b25b959554ed76058ac220b7b2e0a026|${APP_API_KEY}|g" \
			"${d}/glistfm.sh" || die
	fi
	if use grab-lastfm-userpic ; then
		cpown "${s}/grab-lastfm-userpic" "${d}"
	fi
	if use lastfmpost ; then
		cpown "${s}/lastfmpost" "${d}"
		sed -i -e "s|<USERNAME>|${LFM_NAME}|g" \
			"${d}/lastfmpost" || die
		sed -i -e "s|<PASSWORD>|${LFM_PASS}|g" \
			"${d}/lastfmpost" || die
	fi
	if use mplayerfm ; then
		cpown "${s}/mplayerfm" "${d}"
	fi
	if use mpv ; then
		cpown "${s}/mpv-lastfm.lua" \
			"${USERFOLDER}/.config/mpv/scripts/"
	fi
	einfo "Add ${d} to your profile's PATH"
	warn_sanitize_credentials
	sanitize_variables
	unset LFM_PASS
	unset APP_API_KEY
	unset APP_SHARED_SECRET
}

pkg_postinst() {
einfo
einfo "Obtain an API key from http://www.last.fm/api/accounts .  You need to"
einfo "add the user home directory to the PATH environmental variable in"
einfo "~/.bashrc ."
einfo
	if ! use savedconfig ; then
einfo
einfo "Do a \`emerge ${PN} --config\` to manually complete the installation."
einfo
	else
		source "${SAVEDCONFIG_PATH}"
		_set_settings
	fi
}

warn_sanitize_credentials() {
ewarn
ewarn "When you unemerge this program, use shred on all of the following"
ewarn
ewarn "  ${USERFOLDER}/.local/bin/gettracks.hs"
ewarn "  ${USERFOLDER}/.local/bin/glistfm.sh"
ewarn "  ${USERFOLDER}/.local/bin/lastfmpost"
ewarn
}

pkg_config() {
	if ! use savedconfig ; then
		einfo "Enter the full path of the user home dir (/home/<username>)"
		read USERFOLDER
		einfo "Enter the file owner"
		read USEROWNER
		einfo "Enter the file group"
		read USERGROUP
		einfo "Enter your last.fm username:"
		read LFM_NAME
		einfo "Enter your last.fm password:"
		read LFM_PASS
		einfo "Enter the app name:"
		read APP_NAME
		einfo "Enter the app api key:"
		read APP_API_KEY
		einfo "Enter the shared secret:"
		read APP_SHARED_SECRET
		_set_settings
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
