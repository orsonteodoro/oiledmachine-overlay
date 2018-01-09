# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A delightful community-driven framework for managing your zsh configuration that includes optional plugins and themes."
HOMEPAGE="http://ohmyz.sh/"
COMMIT="c3b072eace1ce19a48e36c2ead5932ae2d2e06d9"
SRC_URI="https://github.com/robbyrussell/oh-my-zsh/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="branding powerline"

RDEPEND="app-shells/zsh
         powerline? ( media-fonts/powerline-symbols )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"

ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"
ZSH_EDEST="${EPREFIX}${ZSH_DEST}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

src_prepare() {
	local i
	for i in "${S}"/tools/*install* "${S}"/tools/*upgrade*
	do
		test -f "${i}" && : >"${i}"
	done
	sed -i -e 's!ZSH=$HOME/.oh-my-zsh!ZSH='"${ZSH_EDEST}"'!' "${S}/${ZSH_TEMPLATE}" || die
	sed -i -e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' "${S}/${ZSH_TEMPLATE}" || die
	sed -i -e '/zstyle.*cache/d' "${S}/lib/completion.zsh" || die

	if use branding ; then
		sed -i -e 's!ZSH_THEME="robbyrussell"![[ -z "${ZSH_THEME}" ]] \&\& ZSH_THEME="gentoo"!g' "${S}/${ZSH_TEMPLATE}" || die
	else
		sed -i -e 's!ZSH_THEME="robbyrussell"![[ -z "${ZSH_THEME}" ]] \&\& ZSH_THEME="robbyrussell"!g' "${S}/${ZSH_TEMPLATE}" || die
	fi

	eapply_user
}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
}

pkg_postinst() {
	einfo "You must add \`source '${ZSH_DEST}/${ZSH_TEMPLATE}'\` to your ~/.zshrc."
	if ! use powerline ; then
		einfo "Some themes like agnoster require media-fonts/powerline-symbols to display arrows properly."
	fi
}
