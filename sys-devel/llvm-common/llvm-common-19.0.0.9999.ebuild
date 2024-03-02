# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ "${PV}" =~ "9999" ]] ; then
	IUSE+="
		fallback-commit
	"
fi

inherit llvm-ebuilds

_llvm_set_globals() {
	if [[ "${USE}" =~ "fallback-commit" && "${PV}" =~ "9999" ]] ; then
einfo "Using fallback commit"
		EGIT_OVERRIDE_COMMIT_LLVM_LLVM_PROJECT="${FALLBACK_LLVM19_COMMIT}"
	fi
}
_llvm_set_globals
unset -f _llvm_set_globals

inherit elisp-common llvm.org

DESCRIPTION="Common files shared between multiple slots of LLVM"
HOMEPAGE="https://llvm.org/"
LICENSE="
	Apache-2.0-with-LLVM-exceptions
	UoI-NCSA
"
SLOT="0"
IUSE="emacs"
RDEPEND="
	!sys-devel/llvm:0
"
BDEPEND="
	emacs? (
		>=app-editors/emacs-23.1:*
	)
"
LLVM_COMPONENTS=(
	"llvm/utils/vim"
)
llvm.org_set_globals

SITEFILE="50llvm-gentoo.el"
BYTECOMPFLAGS="-L emacs"

src_compile() {
	default

	use emacs && elisp-compile emacs/*.el
}

src_install() {
	insinto /usr/share/vim/vimfiles
	doins -r vim/*/
	# some users may find it useful
	newdoc vim/README README.vim
	dodoc vim/vimrc

	if use emacs ; then
		elisp-install llvm emacs/*.{el,elc}
		elisp-make-site-file "${SITEFILE}" llvm
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
