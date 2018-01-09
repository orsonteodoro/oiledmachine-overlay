# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="Emoji completion on the command line"
HOMEPAGE="https://github.com/b4b4r07/emoji-cli"
COMMIT="5179c1ee4c4eb4c82d025d20eb5acb1d58af6389"
SRC_URI="https://github.com/b4b4r07/emoji-cli/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="doc fzf peco percol"
REQUIRED_USE="^^ ( fzf peco percol )"

RDEPEND="app-shells/zsh
         || ( fzf? ( app-shells/fzf[zsh-completion,tmux] )
              peco? ( app-shells/peco )
              percol? ( app-shells/percol ) )
         app-misc/jq
         "
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	sed -i 's|\^s|^a|g' emoji-cli.zsh
	eapply_user
}

src_install() {
	mkdir -p "${D}/usr/share/zsh/site-contrib"
	cp -a emoji-cli.zsh dict "${D}"/usr/share/zsh/site-contrib/
	if use doc ; then
		mkdir -p "${D}/usr/share/${PN}"
		cp -a "README.md" "${D}"/usr/share/${PN}/
	fi
}

pkg_postinst() {
	einfo "Add \`source /usr/share/zsh/site-contrib/emoji-cli.zsh\` to your personal /home/<USER>/.zshrc."
	einfo "The default binding ^s has been changed to ^a to get it to atleast work.  You can manually change it by setting EMOJI_CLI_KEYBIND."
}
