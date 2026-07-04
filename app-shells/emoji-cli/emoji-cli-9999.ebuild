# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="0fbb2e48e07218c5a2776100a4c708b21cb06688"
	EGIT_REPO_URI="https://github.com/b4b4r07/emoji-cli.git"
	EGIT_BRANCH="master"
	EGIT_COMMIT="HEAD"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	KEYWORDS="~amd64"
	die "FIXME"
fi

DESCRIPTION="Emoji completion on the command line"
LICENSE="MIT"
HOMEPAGE="https://github.com/b4b4r07/emoji-cli"
SLOT="0"
IUSE+=" doc fallback-commit fzf peco percol"
REQUIRED_USE="
	^^ (
		fzf
		peco
		percol
	)
"
RDEPEND="
	app-misc/jq
	app-shells/zsh
	|| (
		fzf? (
			app-shells/fzf[zsh-completion,tmux]
		)
		peco? (
			app-shells/peco
		)
		percol? (
			app-shells/percol
		)
	)
"
S="${WORKDIR}/${P}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md )

src_unpack() {
	if in_iuse fallback-commit && use fallback-commit ; then
		EGIT_COMMIT="${FALLBACK_COMMIT}"
	fi
	git-r3_fetch
	git-r3_checkout
}

src_prepare() {
	default
	sed -i 's|\^s|^\||g' emoji-cli.zsh || die
}

src_install() {
	insinto "/usr/share/zsh/site-contrib"
	doins emoji-cli.zsh dict
}

pkg_postinst() {
einfo
einfo "Add \`source /usr/share/zsh/site-contrib/emoji-cli.zsh\` to your personal"
einfo "/home/<USER>/.zshrc."
einfo
einfo "The default binding ^s has been changed to ^| to get it to atleast work."
einfo "You can manually change it by setting EMOJI_CLI_KEYBIND."
einfo
}
