# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U22

# This ebuild has AI generated code.

MY_PN="Gogh"

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="no"
PYTHON_COMPAT=( "python3_"{10..12} )

declare -A NEEDS_LIMITED_USER=(
	["alacritty"]=1			# cfg:  ${HOME}/.config/alacritty/alacritty.yml
					#       ${HOME}/.alacritty.yml
					#       ${HOME}/alacritty/alacritty.toml
					#       ${HOME}/alacritty.toml
					#       ${XDG_CONFIG_HOME}/alacritty/alacritty.toml
					#       ${XDG_CONFIG_HOME}/alacritty.toml
					#       ${XDG_CONFIG_HOME}/alacritty/alacritty.yml
					#       ${XDG_CONFIG_HOME}/alacritty.yml
	["foot"]=1			# cfg:  ${HOME}/.config/foot/foot.ini
	["gnome-terminal"]=1		# dconf
	["guake"]=1			# dconf
	["io-elementary-t"]=1		# gsettings
	["iTerm-app"]=1			# open ${PROFILE_NAME}.itermcolors
	["kitty"]=1			# cfg:  ${HOME}/.config/kitty/kitty.conf
	["kmscon"]=0			# cfg:  /etc/kmscon/kmscon.conf
	["konsole"]=1			# cfg:  ${HOME}/.config/konsolerc
	["linux"]=1			# cfg:  /usr/local/share/vtrgb-gogh/<theme_name>
					#       ${HOME}/.vtrgb-gogh/<theme>
	["mate-terminal"]=1		# dconf
	["mintty"]=1			# cfg:  ${HOME}/.minttyrc
	["pantheon-terminal"]=1		# gsettings
	["terminator"]=1		# cfg:  ${XDG_CONFIG_HOME}/terminator/config
					#       ${HOME}/.config/terminator/config
	["termux"]=1			# cfg:  ${HOME}/.termux/colors.properties
	["tilix"]=1			# dconf
	["xfce4-terminal"]=0		# systemwide:  ${HOME}/.local/share/xfce4/terminal/colorschemes/<theme-name>.theme
					# cfg:  ${HOME}/.config/xfce4/terminal/terminalrc
	["wezterm"]=1			# printf
)

declare -A TERMS=(
	["alacritty"]="alacritty"
	["foot"]="foot"
	["gnome-terminal"]="gnome-terminal"
	["guake"]="guake"
	["io-elementary-t"]="io.elementary.t"
	["iTerm-app"]="iTerm.app"
	["kitty"]="kitty"
	["kmscon"]="kmscon"
	["konsole"]="konsole"
	["linux"]="linux"
	["mate-terminal"]="mate-terminal"
	["mintty"]="mintty"
	["pantheon-terminal"]="pantheon-terminal"
	["terminator"]="terminator"
	["termux"]="termux"
	["tilix"]="tilix"
	["xfce4-terminal"]="xfce4-terminal"
	["wezterm"]="wezterm"
)

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/Gogh-Co/Gogh.git"
	FALLBACK_COMMIT="4dc3618b1a650c4116b80b215d4e59203a6718a5" # Mar 25, 2026
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_PN}-${PV}"
	SRC_URI="
https://github.com/Gogh-Co/Gogh/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="Gogh is a collection of color schemes for terminal emulators"
HOMEPAGE="
	https://github.com/Gogh-Co/Gogh
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/"$(ver_cut "1-2" "${PV}")
IUSE+="
${!TERMS[@]}
"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	iTerm-app? (
		kernel_Darwin
	)
	|| (
		${!TERMS[@]}
	)
"
RDEPEND+="
	${PYTHON_DEPS}
	gnome-terminal? (
		gnome-base/dconf
	)
	guake? (
		gnome-base/dconf
	)
	io-elementary-t? (
		dev-libs/glib
	)
	linux? (
		sys-apps/kbd
	)
	mate-terminal? (
		gnome-base/dconf
	)
	pantheon-terminal? (
		dev-libs/glib
	)
	tilix? (
		gnome-base/dconf
	)
	xfce4-terminal? (
		x11-terms/xfce4-terminal[-color-themes]
		!x11-terms/tinted-terminal-xfce4
		!x11-terms/xfce4-terminal-catppuccin-theme
	)
	$(python_gen_cond_dep '
		>=dev-python/ruamel-yaml-0.17.21[${PYTHON_USEDEP}]
		dev-python/unidecode[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/tomli[${PYTHON_USEDEP}]
		dev-python/tomli-w[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
	')
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
"
DOCS=( "README.md" )

pkg_setup() {
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

python_prepare() {
	sed -i -e "s|python3|${EPYTHON}|g" "apply-colors.sh" || die
}

src_compile() {
	local x
	for x in "${!TERMS[@]}" ; do
		if use "${x}" ; then
			export TERMINAL="${TERMS[${x}]}"
		fi
	done
	if use xfce4-terminal ; then
		"./gogh.sh" "ALL"
	fi
}

sanitize_file_permissions() {
	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		[[ -L "${path}" ]] && continue
		chown "root:root" "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Bourne-Again shell script" ; then
			chmod 0755 "${path}" || die
		elif [[ "${path}" =~ ".sh"$ ]] ; then
			chmod 0755 "${path}" || die
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'
}


src_install() {
	insinto "/opt/${PN}"
	doins -r *
	exeinto "/usr/bin"
	doexe "${FILESDIR}/gogh"

	if use xfce4-terminal ; then
		insinto "/usr/share/xfce4/terminal/colorschemes"
		doins -r "${HOME}/.local/share/xfce4/terminal/colorschemes"/*
	fi

	fperms 0775 "/opt/${PN}/"

	docinto "licenses"
	dodoc "LICENSE"

	sanitize_file_permissions
}

pkg_postinst() {
	local needs_limited_user=0
	local x
	for x in ${!NEEDS_LIMITED_USER[@]} ; do
		if use "${x}" && ${NEEDS_LIMITED_USER[${x}]} ; then
ewarn "${x} needs the themes applied manually as limited user through /usr/bin/gogh"
		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
