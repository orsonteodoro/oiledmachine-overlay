# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit

DESCRIPTION="Emoji completion on the command line"
LICENSE="MIT"
HOMEPAGE="https://github.com/b4b4r07/emoji-cli"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~x86"
SLOT="0"
IUSE="doc fzf peco percol"
REQUIRED_USE="^^ ( fzf peco percol )"
RDEPEND="
	app-misc/jq
	app-shells/zsh
	|| (
		fzf? ( app-shells/fzf[zsh-completion,tmux] )
		peco? ( app-shells/peco )
		percol? ( app-shells/percol )
	)
"
EGIT_COMMIT="26e2d67d566bfcc741891c8e063a00e0674abc92"
SRC_URI="
https://github.com/b4b4r07/emoji-cli/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
RESTRICT="mirror"
DOCS=( CHANGELOG.md README.md )

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
