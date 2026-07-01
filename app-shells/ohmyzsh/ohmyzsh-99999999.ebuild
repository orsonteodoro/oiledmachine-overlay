# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EMOJI_LANG_DEFAULT=${EMOJI_LANG_DEFAULT:-"en"}
ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"
ZSH_EDEST="${ZSH_DEST}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

CHKL_TIMESTAMPS=(
	"app-shells/zsh-9999"
)

inherit chkl secure-version

if [[ "${PV}" =~ "99999999" ]] ; then
	FALLBACK_COMMIT="65749801cf4c3b1f3c79a20001909d72dadd307f"
	EGIT_REPO_URI="https://github.com/ohmyzsh/ohmyzsh.git"
	EGIT_BRANCH="master"
	S="${WORKDIR}/${PN}-${PV}"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
fi

DESCRIPTION="A framework for managing your zsh configuration with plugins and themes"
HOMEPAGE="
http://ohmyz.sh/
https://github.com/ohmyzsh/ohmyzsh
"
LICENSE="
	(
		all-rights-reserved
		Apache-2.0
	)
	(
		all-rights-reserved
		GPL-2+
	)
	(
		all-rights-reserved
		MIT
	)
	Apache-2.0
	BSD
	BSD-2
	GPL-2
	GPL-2+
	GPL-3
	GPL-3+
	ISC
	MIT
	MPL-2.0
	unicode
	Unicode-DFS-2016
	WTFPL-2
	ZLIB
"

# tools/install.sh - Apache-2.0
# The Apache-2.0 license template doesn't contain all rights reserved.
# The BSD has all rights reserved in the license template.
# The GPL-2+ does not have all rights reserved in the license template.

SLOT="0"

EMOJI_DEPENDS="
	>=dev-lang/perl-${PERL_PV}
	dev-perl/Path-Class
"
RDEPEND+="
	${EMOJI_DEPENDS}
	${PYTHON_DEPS}
	>=app-shells/zsh-${ZSH_PV}:=
	app-alternatives/awk:*
	>=sys-apps/grep-${GREP_PV}:=
	x11-misc/xdg-utils:=
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=app-shells/zsh-${ZSH_PV}
"

pkg_setup() {
	:
}

src_unpack() {
	if [[ "${PV}" =~ "99999999" ]] ; then
		if use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	fi

	cd "${S}" || die
}

src_prepare() {
	default
	local i
	for i in "${S}/tools/"*"install"* "${S}/tools/"*"upgrade"*
	do
		test -f "${i}" && : >"${i}"
	done
	sed -i \
		-e 's!ZSH=$HOME/.oh-my-zsh!ZSH='"${ZSH_EDEST}"'!' \
		"${S}/${ZSH_TEMPLATE}" \
		|| die
	sed -i \
		-e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' \
		"${S}/${ZSH_TEMPLATE}" \
		|| die
	sed -i \
		-e '/zstyle.*cache/d' \
		"${S}/lib/completion.zsh" \
		|| die

	sed -i \
		-e 's!ZSH_THEME="robbyrussell"![[ -z "${ZSH_THEME}" ]] \&\& ZSH_THEME="robbyrussell"!g' \
		"${S}/${ZSH_TEMPLATE}" \
		|| die

	if [[ -n "${OMZ_CHM_VIEWER}" ]] ; then
		sed -i \
			-e "s|xchm|${OMZ_CHM_VIEWER}|" \
			"${S}/plugins/common-aliases/common-aliases.plugin.zsh" \
			|| die
	fi
	if [[ -n "${OMZ_PDF_VIEWER}" ]] ; then
		sed -i \
			-e "s|acroread|${OMZ_PDF_VIEWER}|" \
			"${S}/plugins/common-aliases/common-aliases.plugin.zsh" \
			|| die
	fi
	if [[ -n "${OMZ_PS_VIEWER}" ]] ; then
		sed -i \
			-e "s|gv|${OMZ_PS_VIEWER}|" \
			"${S}/plugins/common-aliases/common-aliases.plugin.zsh" \
			|| die
	fi
	if [[ -n "${OMZ_DJVU_VIEWER}" ]] ; then
		sed -i \
			-e "s|djview|${OMZ_DJVU_VIEWER}|" \
			"${S}/plugins/common-aliases/common-aliases.plugin.zsh" \
			|| die
	fi
	if [[ -n "${OMZ_DVI_VIEWER}" ]] ; then
		sed -i \
			-e "s|xdvi|${OMZ_DVI_VIEWER}|" \
			"${S}/plugins/common-aliases/common-aliases.plugin.zsh" \
			|| die
	fi
	if [[ -n "${OMZ_MEDIA_PLAYER}" ]] ; then
		sed -i \
			-e "s|mplayer|${OMZ_MEDIA_PLAYER}|" \
			"${S}/plugins/common-aliases/common-aliases.plugin.zsh" \
			|| die
	fi

	sed -i -e "s|python2|python3|" "${S}/plugins/salt/_salt" || die
}

src_configure() {
	chkl_check_many_timestamps
}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
}

pkg_postinst() {
	einfo
	einfo "You must add \`source '${ZSH_DEST}/${ZSH_TEMPLATE}'\`"
	einfo "to your ~/.zshrc."
	einfo

	optfeature_header "Install optional packages:"

	optfeature "adben theme support" "games-misc/fortune-mod"
	optfeature "adben theme support" "net-misc/wget"
	optfeature "adben theme support" "dev-vcs/subversion"
	optfeature "agnoster theme support" "media-fonts/powerline-symbols"
	optfeature "agnoster theme support" "dev-vcs/bzr"
	optfeature "agnoster theme support" "dev-vcs/git"
	optfeature "amuse theme support" "media-fonts/powerline-symbols"
	optfeature "apple theme support" "dev-vcs/cvs"
	optfeature "apple theme support" "dev-vcs/git"
	optfeature "apple theme support" "dev-vcs/subversion"
	optfeature "avit theme support" "dev-vcs/git"
	optfeature "bureau theme support" "dev-vcs/git"
	optfeature "dogenpunk theme support" "dev-vcs/git"
	optfeature "eastwood theme support" "dev-vcs/git"
	optfeature "emotty theme support" "media-fonts/powerline-symbols"
	optfeature "emotty theme support" "dev-vcs/git"
	optfeature "frisk theme support" "dev-vcs/bzr"
	optfeature "gallois theme support" "dev-vcs/git"
	optfeature "gentoo theme support" "dev-vcs/cvs"
	optfeature "gentoo theme support" "dev-vcs/git"
	optfeature "gentoo theme support" "dev-vcs/subversion"
	optfeature "half-life theme support" "dev-vcs/git"
	optfeature "half-life theme support" "dev-vcs/subversion"
	optfeature "kiwi theme support" "dev-vcs/subversion"
	optfeature "kolo theme support" "dev-vcs/subversion"
	optfeature "nicoulaj theme support" "dev-vcs/bzr"
	optfeature "michelebologna theme support" "dev-vcs/git"
	optfeature "minimal theme support" "dev-vcs/subversion"
	optfeature "mortalscumbag theme support" "dev-vcs/git"
	optfeature "oldgallois theme support" "dev-vcs/git"
	optfeature "peepcode theme support" "dev-vcs/git"
	optfeature "refined theme support" "dev-vcs/bzr"
	optfeature "rjk-repos theme support" "dev-vcs/bzr"
	optfeature "smt theme support" "dev-vcs/git"
	optfeature "Soliah theme support" "dev-vcs/git"
	optfeature "steeef theme support" "dev-vcs/git"
	optfeature "steeef theme support" "dev-vcs/subversion"
	optfeature "sunrise theme support" "dev-vcs/git"
	optfeature "wedisagree theme support" "dev-vcs/git"
	optfeature "ys theme support" "dev-vcs/subversion"
	optfeature "zhann theme support" "dev-vcs/git"
	optfeature "zhann theme support" "dev-vcs/subversion"

	optfeature "1password plugin support" "=app-misc/1password-cli-2"
	optfeature "adb plugin support" "dev-util/android-tools"
	optfeature "ag plugin support" "app-misc/ag"
	optfeature "aliases plugin support" "dev-lang/python"
	optfeature "ansible plugin support" "app-admin/ansible"
	optfeature "ant plugin support" "dev-java/ant"
	optfeature "arcanist plugin support" "dev-util/arcanist"
	optfeature "archlinux plugin support" "app-admin/sudo"
	optfeature "archlinux plugin support" "app-crypt/gnupg"
	optfeature "archlinux plugin support" "net-misc/curl"
	optfeature "archlinux plugin support" "sys-apps/pacman"
	optfeature "autojump plugin support" "app-shells/autojump"
	optfeature "autopep8 plugin support" "dev-python/autopep8[${PYTHON_USEDEP}]"
	optfeature "aws plugin support" "dev-python/awscli[${PYTHON_USEDEP}]"
	optfeature "azure plugin support" "app-misc/jq"
	optfeature "battery plugin support" "sys-power/acpi"
	optfeature "bazel plugin support" "dev-build/bazel"
	optfeature "bazel plugin support" "dev-libs/openssl"
	optfeature "bedtools plugin support" "sci-biology/bedtools"
	optfeature "bgnotify with X support" "x11-apps/xprop"
	optfeature "bgnotify with dialog support" "x11-libs/libnotify"
	optfeature "bgnotify with dialog support" "kde-apps/kdialog"
	optfeature "bower plugin support" "dev-nodejs/bower"
	optfeature "bundler plugin support" "dev-ruby/bundler"
	optfeature "cabal plugin support" "dev-haskell/cabal"
	optfeature "capistrano plugin support" "dev-ruby/capistrano"
	optfeature "cask plugin support" "app-emacs/cask"
	optfeature "catimg plugin support" "media-gfx/imagemagick[png]"
	optfeature "celery plugin support" "dev-python/celery[${PYTHON_USEDEP}]"
	optfeature "chruby plugin support" "dev-lang/ruby"
	optfeature "chruby plugin support" "dev-ruby/chruby"
	optfeature "chucknorris plugin support" "games-misc/fortune-mod"
	optfeature "coffee plugin support for tmux clipboard" "app-misc/tmux"
	optfeature "coffee plugin support for wayland clipboard" "gui-apps/wl-clipboard"
	optfeature "coffee plugin support for x11 clipboard" "x11-misc/xclip"
	optfeature "coffee plugin support for x11 clipboard" "x11-misc/xsel"
	optfeature "colored-man-pages plugin support" "sys-apps/groff"
	optfeature "colorize plugin support" "dev-python/pygments[${PYTHON_USEDEP}]"
	optfeature "composer plugin support" "dev-lang/php"
	optfeature "composer plugin support" "net-misc/curl"
	optfeature "composer plugin support" "dev-php/composer"
	optfeature "common-aliases plugin support" "sys-process/procps"
	optfeature "common-aliases plugin support" "dev-python/pygments"
	optfeature "common-aliases plugin support for ace" "app-arch/unace"
	optfeature "common-aliases plugin support for chm viewer" "app-text/xchm"
	optfeature "common-aliases plugin support for pdf viewer" "app-text/acroread"
	optfeature "common-aliases plugin support for ps viewer" "app-text/gv"
	optfeature "common-aliases plugin support for dvi viewer" "app-text/xdvik"
	optfeature "common-aliases plugin support for djvu viewer" "app-text/djview"
	optfeature "common-aliases plugin support for media player" "media-video/mplayer"
	optfeature "common-aliases plugin support for rar" "app-arch/unrar"
	optfeature "common-aliases plugin support for zip" "app-arch/unzip"
	optfeature "common-aliases plugin support for zip" "app-arch/zip"
	optfeature "copybuffer plugin support for tmux clipboard" "app-misc/tmux"
	optfeature "copybuffer plugin support for wayland clipboard" "gui-apps/wl-clipboard"
	optfeature "copybuffer plugin support for x11 clipboard" "x11-misc/xclip"
	optfeature "copybuffer plugin support for x11 clipboard" "x11-misc/xsel"
	optfeature "copyfile plugin support for tmux clipboard" "app-misc/tmux"
	optfeature "copyfile plugin support for wayland clipboard" "gui-apps/wl-clipboard"
	optfeature "copyfile plugin support for x11 clipboard" "x11-misc/xclip"
	optfeature "copyfile plugin support for x11 clipboard" "x11-misc/xsel"
	optfeature "cpanm plugin support" "dev-perl/App-cpanminus"
	optfeature "debian plugin support" "app-admin/sudo"
	optfeature "debian plugin support" "app-arch/dpkg"
	optfeature "deno plugin support" "net-libs/deno"
	optfeature "direnv plugin support" "dev-util/direnv"
	optfeature "django plugin support" "dev-python/django[${PYTHON_USEDEP}]"
	optfeature "dnf plugin support" "app-admin/sudo"
	optfeature "docker plugin support" "app-containers/docker"
	optfeature "docker-compose plugin support" "app-emulation/docker-compose"
	optfeature "docker-machine plugin support" "app-emulation/docker-machine"
	optfeature "doctl plugin support" "app-admin/doctl"
	optfeature "dotnet plugin support" "dev-dotnet/dotnet-sdk-bin"
	optfeature "drush plugin support" "app-admin/drush"
	optfeature "drush plugin support" "app-admin/sudo"
	optfeature "eecms plugin support" "dev-lang/php"
	optfeature "emacs plugin support" ">=app-editors/emacs-24.0"
	optfeature "emoji plugin support" "media-fonts/noto-color-emoji"
	optfeature "emoji plugin support" "media-fonts/noto-color-emoji-bin"
	optfeature "emoji plugin support" "media-fonts/noto-emoji"
	optfeature "emoji plugin support" "media-fonts/emojione-color-font"
	optfeature "emoji plugin support" "media-fonts/symbola"
	optfeature "emoji plugin support" "media-fonts/twemoji-color-font"
	optfeature "emoji plugin support" "media-fonts/unifont"
	optfeature "emoji-clock plugin support" "media-fonts/noto-color-emoji"
	optfeature "emoji-clock plugin support" "media-fonts/noto-color-emoji-bin"
	optfeature "emoji-clock plugin support" "media-fonts/noto-emoji"
	optfeature "emoji-clock plugin support" "media-fonts/emojione-color-font"
	optfeature "emoji-clock plugin support" "media-fonts/symbola"
	optfeature "emoji-clock plugin support" "media-fonts/twemoji-color-font"
	optfeature "emoji-clock plugin support" "media-fonts/unifont"
	optfeature "emotty plugin support" "media-fonts/noto-color-emoji"
	optfeature "emotty plugin support" "media-fonts/noto-color-emoji-bin"
	optfeature "emotty plugin support" "media-fonts/noto-emoji"
	optfeature "emotty plugin support" "media-fonts/emojione-color-font"
	optfeature "emotty plugin support" "media-fonts/symbola"
	optfeature "emotty plugin support" "media-fonts/twemoji-color-font"
	optfeature "emotty plugin support" "media-fonts/unifont"
	optfeature "encode64 plugin support" "sys-apps/coreutils"
	optfeature "extract plugin support" "net-misc/curl"
	optfeature "extract plugin support for 7zip" "app-arch/p7zip"
	optfeature "extract plugin support for bzip2" "app-arch/bzip2"
	optfeature "extract plugin support for deb" "app-arch/bzip2"
	optfeature "extract plugin support for deb" "app-arch/pigz"
	optfeature "extract plugin support for deb" "app-arch/xz-utils"
	optfeature "extract plugin support for deb" "app-arch/tar"
	optfeature "extract plugin support for deb" "sys-devel/binutils"
	optfeature "extract plugin support for gzip" "app-arch/pigz"
	optfeature "extract plugin support for lrzip" "app-arch/lrzip"
	optfeature "extract plugin support for lz4" "app-arch/lz4"
	optfeature "extract plugin support for lzip" "app-arch/lzip"
	optfeature "extract plugin support for lzma" "app-arch/xz-utils"
	optfeature "extract plugin support for lzw" "app-arch/ncompress"
	optfeature "extract plugin support for unzip" "app-arch/unzip"
	optfeature "extract plugin support for rar" "app-arch/unrar"
	optfeature "extract plugin support for rpm" "app-arch/cpio"
	optfeature "extract plugin support for rpm" "app-arch/rpm"
	optfeature "extract plugin support for xz" "app-arch/xz-utils"
	optfeature "extract plugin support for zstd" "app-arch/zstd"
	optfeature "eza plugin support" "sys-apps/eza"
	optfeature "fabric plugin support" "dev-python/fabric[${PYTHON_USEDEP}]"
	optfeature "fasd plugin support" "app-misc/fasd"
	optfeature "fbterm plugin support" "app-i18n/fbterm"
	optfeature "fd plugin support" "sys-apps/fd"
	optfeature "firewalld plugin support" "app-admin/sudo"
	optfeature "firewalld plugin support" "net-firewall/firewalld"
	optfeature "flutter plugin support" "dev-util/flutter"
	optfeature "fnm plugin support" "dev-util/fnm"
	optfeature "fossil plugin support" "dev-vcs/fossil"
	optfeature "fzf plugin support" "app-shells/fzf"
	optfeature "gcloud plugin support" "app-misc/google-cloud-sdk"
	optfeature "gh plugin support" "dev-util/github-cli"
	optfeature "geeknote plugin support" "app-misc/geeknote"
	optfeature "gem plugin support" "virtual/rubygems"
	optfeature "git plugin support" "dev-vcs/git"
	optfeature "git-auto-fetch plugin support" "dev-vcs/git"
	optfeature "git-commit plugin support" "dev-vcs/git"
	optfeature "git-extras plugin support" "dev-vcs/git"
	optfeature "git-extras plugin support" "dev-vcs/git-extras"
	optfeature "git-flow plugin support" "dev-vcs/git"
	optfeature "git-flow-avh plugin support" "dev-vcs/git"
	optfeature "git-hubflow plugin support" "dev-vcs/git"
	optfeature "git-lfs plugin support" "dev-vcs/git-lfs"
	optfeature "git-prompt plugin support" "dev-lang/python"
	optfeature "git-prompt plugin support" "dev-vcs/git"
	optfeature "gitfast plugin support" "dev-vcs/git"
	optfeature "gitfast plugin support" "net-misc/curl"
	optfeature "github plugin support" "dev-vcs/git"
	optfeature "github plugin support" "dev-vcs/hub"
	optfeature "github plugin support" "net-misc/curl"
	optfeature "gitignore plugin support" "net-misc/curl"
	optfeature "globalias plugin support" "sys-apps/grep[pcre]"
	optfeature "gnu-utils plugin support" "sys-apps/coreutils"
	optfeature "golang plugin support" "dev-lang/go"
	optfeature "gpg-agent plugin support" "app-crypt/gnupg"
	optfeature "gradle plugin support" "dev-java/gradle-bin"
	optfeature "grc plugin support" "app-misc/grc"
	optfeature "helm plugin support" "app-admin/helm"
	optfeature "heroku plugin support" "dev-util/heroku-cli"
	optfeature "history-substring-search plugin support" "app-editors/emacs"
	optfeature "history-substring-search plugin support" "dev-vcs/git"
	optfeature "hitchhiker plugin support" "games-misc/cowsay"
	optfeature "hitchhiker plugin support" "games-misc/fortune-mod"
	optfeature "hitokoto plugin support" "net-misc/curl"
	optfeature "httpie plugin support" "net-misc/httpie"
	optfeature "invoke plugin support" "dev-python/invoke[${PYTHON_USEDEP}]"
	optfeature "ipfs plugin support" "net-p2p/go-ipfs"
	optfeature "jenv plugin support" "virtual/jre"
	optfeature "jfrog plugin support" "dev-util/jfrog-cli"
	optfeature "jira plugin support" "dev-python/jira[${PYTHON_USEDEP}]"
	optfeature "jsontools plugin support" "dev-lang/python"
	optfeature "jsontools plugin support" "dev-lang/ruby"
	optfeature "jsontools plugin support" "net-libs/nodejs"
	optfeature "juju plugin support" "app-admin/juju"
	optfeature "kate plugin support" "kde-apps/kate"
	optfeature "keychain plugin support" "net-misc/keychain"
	optfeature "kube-ps1 plugin support" "sys-cluster/kubernetes"
	optfeature "kubectx plugin support" "app-admin/kubectx"
	optfeature "kops plugin support" "sys-cluster/kops"
	optfeature "laravel plugin support" "dev-lang/php"
	optfeature "laravel4 plugin support" "dev-lang/php"
	optfeature "laravel5 plugin support" "dev-lang/php"
	optfeature "lein plugin support" "dev-java/leiningen-bin"
	optfeature "lol plugin support" "net-misc/curl"
	optfeature "lol plugin support" "sys-process/procps"
	optfeature "lpass plugin support" "app-admin/lastpass-cli"
	optfeature "lxd plugin support" "app-containers/lxd"
	optfeature "man plugin support" "virtual/man"
	optfeature "magic-enter plugin support" "dev-vcs/git"
	optfeature "minikube plugin support" "sys-cluster/minikube"
	optfeature "mix plugin support" "dev-lang/elixir"
	optfeature "mix-fast plugin support" "dev-lang/elixir"
	optfeature "mercurial plugin support" "dev-vcs/mercurial"
	optfeature "mongocli plugin support" "dev-db/mongodb"
	optfeature "mvn plugin support" "dev-java/maven-bin"
	optfeature "mvn plugin support" "sys-apps/grep[pcre]"
	optfeature "n98-magerun plugin support" "net-misc/wget"
	optfeature "nanoc plugin support" "www-apps/nanoc"
	optfeature "nats plugin support" "net-misc/natscli"
	optfeature "nmap plugin support" "app-admin/sudo"
	optfeature "nmap plugin support" "net-analyzer/nmap"
	optfeature "node plugin support" "net-libs/nodejs"
	optfeature "nomad plugin support" "sys-cluster/nomad"
	optfeature "npm plugin support" "net-libs/nodejs[npm]"
	optfeature "oc plugin support" "app-admin/openshift-client-tools"
	optfeature "oc plugin support" "app-emulation/openshift-cli"
	optfeature "oc plugin support" "sys-cluster/openshift-client-bin"
	optfeature "octozen plugin support" "net-misc/curl"
	optfeature "otp plugin support" "app-crypt/gnupg"
	optfeature "otp plugin support" "sys-auth/oath-toolkit"
	optfeature "pass plugin support" "app-admin/pass"
	optfeature "pass plugin support" "app-crypt/gnupg"
	optfeature "paver plugin support" "dev-python/paver[${PYTHON_USEDEP}]"
	optfeature "pep8 plugin support" "dev-python/pep8[${PYTHON_USEDEP}]"
	optfeature "percol plugin support" "app-shells/percol"
	optfeature "perl plugin support" "dev-lang/perl"
	optfeature "perl plugin support" "net-misc/curl"
	optfeature "perl plugin support" "sys-apps/grep[pcre]"
	optfeature "perl plugin support with perlbrew support" "dev-perl/App-perlbrew"
	optfeature "pip plugin support" "dev-python/pip[${PYTHON_USEDEP}]"
	optfeature "pip plugin support" "net-misc/curl"
	optfeature "pipenv plugin support" "dev-python/pipenv[${PYTHON_USEDEP}]"
	optfeature "phing plugin support" "dev-php/phing"
	optfeature "pip plugin support" "net-misc/curl"
	optfeature "pm2 plugin support" "sys-process/pm2"
	optfeature "podman plugin support" "app-containers/podman"
	optfeature "poetry plugin support" "dev-python/poetry[${PYTHON_USEDEP}]"
	optfeature "pre-commit plugin support" "dev-vcs/pre-commit[${PYTHON_SINGLE_USEDEP}]"
	optfeature "pyenv plugin support" "dev-lang/python"
	optfeature "pylint plugin support" "dev-python/pylint[${PYTHON_USEDEP}]"
	optfeature "python plugin support" "dev-lang/python"
	optfeature "rails plugin support" "dev-lang/ruby"
	optfeature "rails plugin support" "dev-ruby/rails[ruby_targets_ruby32?]"
	optfeature "rails plugin support" "dev-ruby/rake[ruby_targets_ruby32?]"
	optfeature "rake plugin support" "app-admin/sudo"
	optfeature "rake plugin support" "dev-ruby/rake"
	optfeature "rake-fast plugin support" "dev-ruby/rake"
	optfeature "rand-quote plugin support" "net-misc/curl"
	optfeature "rbenv plugin support" "dev-lang/ruby"
	optfeature "rbenv plugin support" "dev-ruby/rbenv"
	optfeature "rbw plugin support" "app-admin/rbw"
	optfeature "rebar plugin support" "dev-util/rebar3"
	optfeature "redis-cli plugin support" "dev-db/redis"
	optfeature "repo plugin support" "dev-vcs/repo"
	optfeature "ripgrep plugin support" "sys-apps/ripgrep"
	optfeature "ros plugin support" "dev-lisp/roswell"
	optfeature "rsync plugin support" "net-misc/rsync"
	optfeature "ruby plugin support" "dev-lang/ruby"
	optfeature "ruby plugin support" "dev-ruby/rubygems[ruby_targets_ruby32?]"
	optfeature "rust plugin support" "dev-lang/rust-bin"
	optfeature "rust plugin support" "dev-lang/rust"
	optfeature "rvm plugin support" "dev-ruby/rvm"
	optfeature "samtools plugin support" "sci-biology/samtools"
	optfeature "salt plugin support" "app-admin/salt"
	optfeature "salt plugin support" "dev-lang/python"
	optfeature "sbt plugin support" "dev-java/sbt"
	optfeature "sbt plugin support" "dev-java/sbt-bin"
	optfeature "screen plugin support" "app-misc/screen"
	optfeature "scala plugin support" "dev-lang/scala"
	optfeature "scw plugin support" "app-admin/scaleway-cli"
	optfeature "sfffe plugin support" "sys-apps/ack"
	optfeature "shell-proxy plugin support" "dev-lang/python"
	optfeature "sigstore plugin support" "app-containers/cosign"
	optfeature "singlechar plugin support" "app-admin/sudo"
	optfeature "singlechar plugin support" "net-misc/curl"
	optfeature "singlechar plugin support" "net-misc/wget"
	optfeature "snap plugin support" "app-containers/snapd"
	optfeature "sprunge plugin support" "net-misc/curl"
	optfeature "ssh plugin support" "virtual/ssh"
	optfeature "ssh-agent plugin support" "virtual/ssh"
	optfeature "stack plugin support" "dev-haskell/stack"
	optfeature "starship plugin support" "app-shells/starship"
	optfeature "stripe plugin support" "dev-util/stripe-cli"
	optfeature "sublime plugin support" "app-editors/sublime-text"
	optfeature "sublime-merge plugin support" "dev-vcs/sublime-merge"
	optfeature "sudo plugin support" "app-admin/sudo"
	optfeature "supervisor plugin support" "app-admin/supervisor"
	optfeature "suse plugin support" "app-admin/sudo"
	optfeature "suse plugin support" "sys-apps/zypper"
	optfeature "svn plugin support" "dev-vcs/subversion"
	optfeature "svn-fast-info plugin support" "dev-vcs/subversion"
	optfeature "symfony plugin support" "dev-lang/php"
	optfeature "symfony plugin support" "dev-php/symfony-console"
	optfeature "symfony2 plugin support" "dev-lang/php"
	optfeature "symfony2 plugin support" "dev-php/symfony-console"
	optfeature "systemadmin plugin support" "app-alternatives/awk"
	optfeature "systemadmin plugin support" "net-analyzer/tcpdump"
	optfeature "systemadmin plugin support" "sys-apps/net-tools"
	optfeature "systemadmin plugin support" "sys-process/procps"
	optfeature "systemadmin plugin support for ping" "sys-apps/iproute2"  # for ping?
	optfeature "systemadmin plugin support for ping" "sys-apps/net-tools" # for ping?
	optfeature "systemd plugin support" "app-admin/sudo"
	optfeature "systemd plugin support" "sys-apps/systemd"
	optfeature "systemadmin plugin support" "app-admin/sudo"
	optfeature "systemadmin plugin support" "net-misc/curl"
	optfeature "taskwarrior plugin support" "app-misc/task"
	optfeature "terraform plugin support" "app-admin/terraform"
	optfeature "tig plugin support" "dev-vcs/tig"
	optfeature "thefuck plugin support" "app-shells/thefuck"
	optfeature "thor plugin support" "dev-ruby/thor"
	optfeature "tmux plugin support" "app-misc/tmux"
	optfeature "toolbox plugin support" "app-containers/toolbox"
	optfeature "transfer plugin support" "app-crypt/gnupg"
	optfeature "transfer plugin support" "net-misc/curl"
	optfeature "ubuntu plugin support" "app-admin/sudo"
	optfeature "ubuntu plugin support" "sys-apps/apt"
	optfeature "ufw plugin support" "net-firewall/ufw"
	optfeature "universalarchive plugin support for 7zip" "app-arch/p7zip"
	optfeature "universalarchive plugin support for bzip2" "app-arch/bzip2"
	optfeature "universalarchive plugin support for gzip" "app-arch/pigz"
	optfeature "universalarchive plugin support for lzma" "app-arch/xz-utils"
	optfeature "universalarchive plugin support for lzo" "app-arch/lzop"
	optfeature "universalarchive plugin support for lzw" "app-arch/ncompress"
	optfeature "universalarchive plugin support for rar" "app-arch/unrar"
	optfeature "universalarchive plugin support for xz" "app-arch/xz-utils"
	optfeature "universalarchive plugin support for zip" "app-arch/unzip"
	optfeature "universalarchive plugin support for zip" "app-arch/zip"
	optfeature "universalarchive plugin support for zstd" "app-arch/zstd"
	optfeature "urltools plugin support" "dev-lang/php"
	optfeature "urltools plugin support" "dev-lang/python"
	optfeature "urltools plugin support" "dev-lang/ruby"
	optfeature "urltools plugin support" "net-libs/nodejs"
	optfeature "vagrant plugin support" "app-emulation/vagrant"
	optfeature "vagrant-prompt" "app-emulation/vagrant"
	optfeature "vim-interaction plugin support" "app-editors/gvim"
	optfeature "virtualenvwrapper plugin support" "dev-python/virtualenvwrapper[${PYTHON_USEDEP}]"
	optfeature "vscode plugin support" "app-editors/visual-studio-code"
	optfeature "vscode plugin support" "app-editors/visual-studio-code-bin"
	optfeature "vscode plugin support" "app-editors/vscode"
	optfeature "vscode plugin support" "app-editors/vscode-bin"
	optfeature "vundle plugin support" "app-editors/vim"
	optfeature "wakeonlan plugin support" "net-misc/wakeonlan"
	optfeature "watson plugin support" "dev-python/td-watson[${PYTHON_USEDEP}]"
	optfeature "wp-cli plugin support" "app-admin/wp-cli"
	optfeature "yum plugin support" "app-admin/sudo"
	optfeature "zoxide plugin support" "app-shells/zoxide"
	optfeature "zsh-interactive-cd plugin support" "app-shells/fzf"
	optfeature "zsh-navigation-tools plugin support" "dev-vcs/subversion"

	if use kernel_Darwin ; then
		optfeature "apache2-macports plugin support" "app-admin/sudo"
		optfeature "macos plugin support" "net-misc/curl"
		optfeature "postgres plugin support" "dev-db/postgresql"
		optfeature "pow plugin support" "sys-process/lsof"
		optfeature "xcode plugin support" "app-admin/sudo"
	fi
ewarn "Installing unnecessary packages increases the chances of a successful living off the land (LotL) attack."
}

# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  ebuild
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  customization, delete-unused-themes, delete-unused-plugins, dependency-checks

