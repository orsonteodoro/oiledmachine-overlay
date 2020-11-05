# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A delightful community-driven framework for managing your zsh"
DESCRIPTION+=" configuration that includes optional plugins and themes."
HOMEPAGE="http://ohmyz.sh/"
LICENSE="MIT
	 unicode
	 plugins_bazel? ( Apache-2.0 )
	 plugins_kube-ps1? ( Apache-2.0 )
	 plugins_sfdx? ( Apache-2.0 )
	 plugins_coffee? ( BSD )
	 plugins_docker? ( BSD )
	 plugins_history-substring-search? ( BSD )
	 plugins_httpie? ( BSD )
	 plugins_kitchen? ( BSD )
	 plugins_ripgrep? ( BSD )
	 plugins_scala? ( BSD )
	 plugins_yarn? ( BSD )
	 plugins_git-escape-magic? ( BSD-2 )
	 plugins_gitfast? ( GPL-2 )
	 plugins_pass? ( GPL-2+ )
	 plugins_geeknote? ( GPL-3+ )
	 plugins_gradle? ( MIT )
	 plugins_grunt? ( MIT )
	 plugins_gulp? ( MIT )
	 plugins_lando? ( MIT )
	 plugins_osx? ( MIT )
	 plugins_taskwarrior? ( MIT )
	 plugins_wd? ( MIT )
	 plugins_zsh-navigation-tools? ( MIT GPL-3 )
	 plugins_shrink-path? ( WTFPL-2 )
	 plugins_z? ( WTFPL-2 )
	 plugins_per-directory-history? ( ZLIB )"
KEYWORDS="~alpha ~amd64 ~amd64-linux ~arm ~arm64 ~hppa ~ia64 ~m68k ~m68k-mint \
~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sh ~sparc ~sparc-solaris ~sparc64-solaris \
~x64-macos ~x64-solaris ~x86 ~x86-linux ~x86-macos ~x86-solaris"
PYTHON_COMPAT=( python3_{6,7,8} )
USE_RUBY="ruby24 ruby25 ruby26 ruby27"
RUBY_OPTIONAL=1
EMOJI_LANG_DEFAULT=${EMOJI_LANG_DEFAULT:=en}
inherit eutils python-r1 ruby-ng
EGIT_COMMIT="3e6ee85a161c8089955c19364728e167025a911d"
FN="${EGIT_COMMIT}.zip"
A_URL="https://github.com/ohmyzsh/ohmyzsh/archive/${FN}"
P_URL="https://github.com/ohmyzsh/ohmyzsh/tree/${EGIT_COMMIT}"
SRC_URI="${A_URL} -> ${P}.zip"
# Probably needs to be done because the archive contains the UNICODE data file.
# It should be addressed upstream to get rid of emoji-data.txt.
RESTRICT="fetch"
SLOT="0"
IUSE="branding bzr clipboard curl emojis update-emoji-data java git gpg"
IUSE+=" mercurial nodejs powerline perlbrew python ruby rust subversion sudo"
IUSE+=" uri wget"
IUSE+=" 7zip ace bzip2 gzip lrzip lz4 lzip lzma unzip rar rpm xz zip zstd"
OMZSH_THEMES=( 3den adben af-magic afowler agnoster alanpeabody amuse apple \
arrow aussiegeek avit awesomepanda bira blinks bureau candy-kingdom candy \
clean cloud crcandy crunch cypher dallas darkblood daveverwer dieter dogenpunk \
dpoggi dstufft dst duellj eastwood edvardm emotty essembeh evan fino-time fino \
fishy flazz fletcherm fox frisk frontcube funky fwalch gallifrey gallois \
garyblessington gentoo geoffgarside gianu gnzh gozilla half-life humza imajes \
intheloop itchy jaischeema jbergantine jispwoso jnrowe jonathan josh jreese \
jtriley juanghurtado junkfood kafeitu kardan kennethreitz kiwi kolo kphoen \
lambda linuxonly lukerandall macovsky-ruby macovsky maran mgutz mh mlh \
michelebologna mikeh miloshadzic minimal mira mortalscumbag mrtazz murilasso \
muse nanotech nebirhos nicoulaj norm obraun peepcode philips pmcgee \
pygmalion-virtualenv pygmalion re5et refined rgm risto rixius rkj-repos rkj \
robbyrussell sammy simonoff simple skaro smt Soliah sonicradish sorin \
sporty_256 steeef strug sunaku sunrise superjarin suvash takashiyoshida \
terminalparty theunraveler tjkirch_mod tjkirch tonotdo trapd00r wedisagree \
wezm+ wezm wuffers xiong-chiamiov-plus xiong-chiamiov ys zhann )
IUSE+=" ${OMZSH_THEMES[@]/#/-themes_}"
OMZSH_PLUGINS=( adb alias-finder ansible ant apache2-macports arcanist \
archlinux asdf autoenv autojump autopep8 aws battery bazel bbedit bgnotify \
boot2docker bower branch brew bundler cabal cake cakephp3 capistrano cargo \
cask catimg celery chruby chucknorris cloudapp cloudfoundry codeclimate coffee \
colemak colored-man-pages colorize command-not-found common-aliases compleat \
composer copybuffer copydir copyfile cp cpanm dash debian dircycle direnv \
dirhistory dirpersist django dnf dnote docker docker-compose docker-machine \
doctl dotnet dotenv droplr drush eecms emacs ember-cli emoji emoji-clock \
emotty encode64 extract fabric fancy-ctrl-z fasd fastfile fbterm fd fedora \
firewalld flutter forklift fossil frontend-search fzf gas gatsby gb gcloud \
geeknote gem git git-auto-fetch git-escape-magic git-extras gitfast git-flow \
git-flow-avh github git-hubflow gitignore git-lfs git-prompt git-remote-branch \
glassfish globalias gnu-utils go golang gpg-agent gradle grails grunt gulp \
hanami helm heroku hitokoto history history-substring-search homestead httpie \
iterm2 jake-node jenv jfrog jhbuild jira jruby jsontools jump kate keychain \
kitchen knife knife_ssh kops kubectl kube-ps1 lando laravel laravel4 laravel5 \
last-working-dir ldx lein lighthouse lol macports magic-enter man marked2 \
mercurial meteor minikube mix mix-fast mosh mvn mysql-macports n98-magerun \
nanoc ng nmap node nomad npm npx nvm nyan oc osx otp pass paver pep8 percol \
per-directory-history perl perms phing pip pipenv pj please pod postgres pow \
powder powify profiles pyenv pylint python rails rake rake-fast rand-quote \
rbenv rbfu react-native rebar redis-cli repo ripgrep ros rsync ruby rust \
rustup rvm safe-paste salt sbt scala scd screen scw sdk sfdx sfffe shell-proxy \
shrink-path singlechar spring sprunge ssh-agent stack sublime sublime-merge \
sudo supervisor \
suse svcat svn svn-fast-info swiftpm symfony symfony2 systemadmin systemd \
taskwarrior terminitor terraform textastic textmate thefuck themes thor tig \
timer tmux tmux-cssh tmuxinator torrent transfer tugboat ubuntu ufw urltools \
vagrant vagrant-prompt vault vim-interaction vi-mode virtualenv \
virtualenvwrapper vscode vundle wakeonlan wd web-search wp-cli xcode yarn yii \
yii2 yum z zeus zsh-interactive-cd zsh-navigation-tools zsh_reload )
IUSE+=" ${OMZSH_PLUGINS[@]/#/-plugins_}"
RDEPEND_COMMON_ALIASES=()
if [[ -z "${OMZ_CHM_VIEWER}" ]] ; then
RDEPEND_COMMON_ALIASES+=( app-text/xchm )
fi
if [[ -z "${OMZ_PDF_VIEWER}" ]] ; then
RDEPEND_COMMON_ALIASES+=( app-text/acroread )
fi
if [[ -z "${OMZ_PS_VIEWER}" ]] ; then
RDEPEND_COMMON_ALIASES+=( app-text/gv )
fi
if [[ -z "${OMZ_DVI_VIEWER}" ]] ; then
RDEPEND_COMMON_ALIASES+=( app-text/xdvik )
fi
if [[ -z "${OMZ_DJVU_VIEWER}" ]] ; then
RDEPEND_COMMON_ALIASES+=( app-text/djview )
fi
if [[ -z "${OMZ_MEDIA_PLAYER}" ]] ; then
RDEPEND_COMMON_ALIASES+=( media-video/mplayer )
fi
PLUGINS_RDEPEND="
	 plugins_adb? ( dev-util/android-tools )
	 plugins_ansible? ( app-admin/ansible )
	 plugins_ant? ( dev-java/ant )
	 plugins_arcanist? ( dev-util/arcanist )
	 plugins_autojump? ( app-shells/autojump )
	 plugins_aws? ( dev-python/awscli )
	 plugins_battery? ( sys-power/acpi )
	 plugins_bazel? ( dev-util/bazel )
	 plugins_bower? ( dev-nodejs/bower )
	 plugins_bundler? ( dev-ruby/bundler )
	 plugins_cabal? ( dev-haskell/cabal )
	 plugins_cargo? ( dev-lang/rust )
	 plugins_catimg? ( media-gfx/imagemagick[png] )
	 plugins_celery? ( dev-python/celery )
	 plugins_chucknorris? ( games-misc/fortune-mod )
	 plugins_colorize? ( dev-python/pygments )
	 plugins_colored-man-pages? ( sys-apps/groff )
	 plugins_common-aliases? ( ${RDEPEND_COMMON_ALIASES[@]}
				   sys-process/procps
				   dev-python/pygments )
	 plugins_composer? ( dev-lang/php dev-php/composer )
	 plugins_cpanm? ( dev-perl/App-cpanminus )
	 plugins_debian? ( app-arch/dpkg )
	 plugins_direnv? ( dev-util/direnv )
	 plugins_django? ( dev-python/django )
	 plugins_docker-compose? ( app-emulation/docker-compose )
	 plugins_docker-machine? ( app-emulation/docker-machine )
	 plugins_doctl? ( app-admin/doctl )
	 plugins_dotnet? ( || ( dev-dotnet/cli-tools
				dev-dotnet/dotnetcore-sdk-bin ) )
	 plugins_drush? ( app-admin/drush )
	 plugins_eecms? ( dev-lang/php )
	 plugins_emacs? ( >=app-editors/emacs-24.0 )
	 plugins_emoji? ( dev-lang/perl dev-perl/Path-Class )
	 plugins_fasd? ( app-misc/fasd )
	 plugins_fbterm? ( app-i18n/fbterm )
	 plugins_firewalld? ( net-firewall/firewalld )
	 plugins_flutter? ( dev-util/flutter )
	 plugins_fossil? ( dev-vcs/fossil )
	 plugins_fzf? ( app-shells/fzf )
	 plugins_gb? ( dev-go/gb )
	 plugins_gcloud? ( app-misc/google-cloud-sdk )
	 plugins_geeknote? ( app-misc/geeknote )
	 plugins_gem? ( virtual/rubygems )
	 plugins_github? ( dev-vcs/hub )
	 plugins_git-extras? ( dev-vcs/git-extras )
	 plugins_git-lfs? ( dev-vcs/git-lfs )
	 plugins_gnu-utils? ( sys-apps/coreutils )
	 plugins_go? ( dev-lang/go )
	 plugins_golang? ( dev-lang/go )
	 plugins_globalias? ( sys-apps/grep[pcre] )
	 plugins_gradle? ( virtual/gradle )
	 plugins_helm? ( app-admin/helm )
	 plugins_heroku? ( dev-util/heroku-cli )
	 plugins_jira? ( dev-python/jira )
	 plugins_jfrog? ( dev-util/jfrog-cli )
	 plugins_kate? ( kde-apps/kate )
	 plugins_keychain? ( net-misc/keychain )
	 plugins_kops? ( sys-cluster/kops )
	 plugins_kube-ps1? ( sys-cluster/kubernetes )
	 plugins_kubectl? ( sys-cluster/kubernetes )
	 plugins_laravel? ( dev-lang/php )
	 plugins_laravel4? ( dev-lang/php )
	 plugins_laravel5? ( dev-lang/php )
	 plugins_lol? ( sys-process/procps )
	 plugins_man? ( virtual/man )
	 plugins_minikube? ( sys-cluster/minikube )
	 plugins_mix? ( dev-lang/elixir )
	 plugins_mvn? ( dev-java/maven-bin
			sys-apps/grep[pcre] )
	 plugins_nanoc? ( www-apps/nanoc )
	 plugins_nmap? ( net-analyzer/nmap )
	 plugins_nomad? ( sys-cluster/nomad )
	 plugins_npm? ( net-libs/nodejs[npm] )
	 plugins_otp? ( sys-auth/oath-toolkit )
	 plugins_oc? ( || ( app-emulation/openshift-cli \
		sys-cluster/openshift-client-bin \
		app-admin/openshift-client-tools ) )
	 plugins_paver? ( dev-python/paver )
	 plugins_percol? ( app-shells/percol )
	 plugins_pep8? ( dev-python/pep8 )
	 plugins_perl? ( dev-lang/perl
			 perlbrew? ( dev-perl/App-perlbrew )
			 sys-apps/grep[pcre] )
	 plugins_phing? ( dev-php/phing )
	 plugins_pip? ( dev-python/pip )
	 plugins_pipenv? ( dev-python/pipenv )
	 plugins_postgres? ( dev-db/postgresql )
	 plugins_pylint? ( dev-python/pylint )
	 plugins_rails? ( || ( dev-ruby/rails
				dev-lang/ruby
				dev-ruby/rake ) )
	 plugins_rake-fast? ( dev-ruby/rake )
	 plugins_rand-quote? ( net-misc/curl )
	 plugins_rebar? ( dev-util/rebar3 )
	 plugins_redis-cli? ( dev-db/redis )
	 plugins_repo? ( dev-util/repo )
	 plugins_ripgrep? ( sys-apps/ripgrep )
	 plugins_ros? ( dev-lisp/roswell )
	 plugins_rsync? ( net-misc/rsync )
	 plugins_ruby? ( dev-lang/ruby dev-ruby/rubygems )
	 plugins_rvm? ( dev-ruby/rvm )
	 plugins_salt? ( app-admin/salt dev-lang/python )
	 plugins_sbt? ( || ( dev-java/sbt dev-java/sbt-bin ) )
	 plugins_scala? ( dev-lang/scala )
	 plugins_screen? ( app-misc/screen )
	 plugins_scw? ( app-admin/scaleway-cli )
	 plugins_sfffe? ( sys-apps/ack )
	 plugins_stack? ( dev-haskell/stack )
	 plugins_sublime? ( app-editors/sublime-text )
	 plugins_sublime-merge? ( dev-vcs/sublime-merge )
	 plugins_supervisor? ( app-admin/supervisor )
	 plugins_svn-fast-info? ( >=dev-vcs/subversion-1.6 )
	 plugins_systemadmin? ( || ( sys-apps/iproute2 sys-apps/net-tools )
				sys-apps/net-tools
				sys-apps/findutils
				sys-process/procps
				net-analyzer/tcpdump )
	 plugins_systemd? ( sys-apps/systemd )
	 plugins_symfony? ( dev-lang/php dev-php/symfony-console )
	 plugins_symfony2? ( dev-lang/php dev-php/symfony-console )
	 plugins_taskwarrior? ( app-misc/task )
	 plugins_terraform? ( app-admin/terraform )
	 plugins_thefuck? ( app-shells/thefuck )
	 plugins_thor? ( dev-ruby/thor )
	 plugins_tig? ( dev-vcs/tig )
	 plugins_tmux? ( app-misc/tmux )
	 plugins_vagrant? ( app-emulation/vagrant )
	 plugins_vagrant-prompt? ( app-emulation/vagrant )
	 plugins_vim-interaction? ( app-editors/gvim )
	 plugins_virtualenvwrapper? ( dev-python/virtualenvwrapper )
	 plugins_vscode? ( || ( app-editors/visual-studio-code
				app-editors/visual-studio-code-bin
				app-editors/vscode
				app-editors/vscode-bin ) )
	 plugins_vundle? ( app-editors/vim )
	 plugins_wakeonlan? ( net-misc/wakeonlan )
	 plugins_yarn? ( sys-apps/yarn )
	 plugins_wp-cli? ( app-admin/wp-cli )
	 plugins_zsh-interactive-cd? ( app-shells/fzf )
	 plugins_zsh-navigation-tools? ( sys-process/procps )"
#	 plugins_urltools? ( || ( dev-lang/perl
#				  net-libs/nodejs
#				  dev-lang/php
#				  dev-lang/ruby
#				  dev-lang/python ) )
#	 plugins_jsontools? ( || ( dev-lang/ruby
#				   dev-lang/python
#				   net-libs/nodejs ) )
THEMES_RDEPEND="
	 themes_adben? ( games-misc/fortune-mod )
	 "
RDEPEND="${PLUGINS_RDEPEND}
	 ${PYTHON_DEPS}
	 ${THEMES_RDEPEND}
	 7zip? ( app-arch/p7zip )
	 >=app-shells/zsh-4.3.9
	 ace? ( app-arch/unace )
	 bzr? ( dev-vcs/bzr )
	 clipboard? ( || ( x11-misc/xclip x11-misc/xsel app-misc/tmux ) )
	 emojis? ( || ( media-fonts/noto-color-emoji
			media-fonts/noto-color-emoji-bin
			media-fonts/emojione-color-font
			media-fonts/unifont
			media-fonts/twemoji-color-font
			media-fonts/symbola ) )
	 git? ( dev-vcs/git )
	 gpg? ( app-crypt/gnupg )
	 java? ( virtual/jre )
	 bzip2? ( app-arch/bzip2 )
	 gzip? ( app-arch/pigz )
	 lrzip? ( app-arch/lrzip )
	 lz4? ( app-arch/lz4 )
	 lzip? ( app-arch/lzip )
	 lzma? ( app-arch/xz-utils )
	 mercurial? ( dev-vcs/mercurial )
	 nodejs? ( net-libs/nodejs )
         powerline? ( media-fonts/powerline-symbols )
	 python? ( ${PYTHON_DEPS} )
	 rar? ( app-arch/unrar )
	 rpm? ( app-arch/cpio
		app-arch/rpm )
	 ruby? ( $(ruby_implementations_depend) )
	 rust? ( virtual/rust )
	 subversion? ( dev-vcs/subversion )
	 sudo? ( app-admin/sudo )
	 update-emoji-data? ( dev-perl/XML-LibXML
			      dev-perl/Text-Unaccent )
	 unzip? ( app-arch/unzip )
	 virtual/awk
	 wget? ( net-misc/wget )
	 x11-misc/xdg-utils
	 xz? ( app-arch/xz-utils )
	 zip? ( app-arch/unzip )
	 zstd? ( app-arch/zstd )"
DEPEND="${RDEPEND}
	net-misc/wget"
S="${WORKDIR}/${PN//-/}-${EGIT_COMMIT}"
REQUIRED_USE="branding? ( themes_gentoo )
	      themes_agnoster? ( powerline )
	      themes_emotty? ( powerline )
	      themes_amuse? ( powerline )
	      plugins_coffee? ( clipboard )
	      plugins_copybuffer? ( clipboard )
	      plugins_copydir? ( clipboard )
	      plugins_copyfile? ( clipboard )
	      plugins_emoji-clock? ( emojis )
	      plugins_emoji? ( emojis )
	      plugins_emotty? ( emojis plugins_emoji !update-emoji-data )
	      plugins_git? ( git )
	      plugins_github? ( git )
	      plugins_git-auto-fetch? ( git )
	      plugins_git-extras? ( git )
	      plugins_gitfast? ( git )
	      plugins_git-hubflow? ( git )
	      plugins_git-prompt? ( git )
	      plugins_git-remote-branch? ( git )
	      plugins_git-flow? ( git )
	      plugins_magic-enter? ( git )
	      plugins_jenv? ( java )
	      plugins_mercurial? ( mercurial )
	      plugins_node? ( nodejs )
	      plugins_svn? ( subversion )
	      plugins_svn-fast-info? ( subversion )
	      plugins_apache2-macports? ( sudo )
	      plugins_debian? ( sudo )
	      plugins_dnf? ( sudo )
	      plugins_drush? ( sudo )
	      plugins_firewalld? ( sudo )
	      plugins_archlinux? ( sudo )
	      plugins_macports? ( sudo )
	      plugins_mysql-macports? ( sudo )
	      plugins_nmap? ( sudo )
	      plugins_rake? ( sudo )
	      plugins_singlechar? ( sudo )
	      plugins_sudo? ( sudo )
	      plugins_suse? ( sudo )
	      plugins_systemd? ( sudo )
	      plugins_systemadmin? ( sudo )
	      plugins_ubuntu? ( sudo )
	      plugins_xcode? ( sudo )
	      plugins_yum? ( sudo )
	      gpg? ( || (
		plugins_archlinux
		plugins_gpg-agent
		plugins_otp
		plugins_pass ) )
	      plugins_archlinux? ( gpg )
	      plugins_gpg-agent? ( gpg )
	      plugins_otp? ( gpg )
	      plugins_pass? ( gpg )
	      plugins_common-aliases? ( ace rar zip )
	      plugins_extract? ( || ( 7zip bzip2 gzip lrzip lz4 lzip lzma unzip
					rar rpm xz zstd ) )
	      plugins_archlinux? ( curl )
	      plugins_composer? ( curl )
	      plugins_gitfast? ( curl )
	      plugins_github? ( curl )
	      plugins_gitignore? ( curl )
	      plugins_hitokoto? ( curl )
	      plugins_lol? ( curl )
	      plugins_osx? ( curl )
	      plugins_perl? ( curl )
	      plugins_pip? ( curl )
	      plugins_rand-quote? ( curl )
	      plugins_singlechar? ( curl )
	      plugins_sprunge? ( curl )
	      plugins_systemadmin? ( curl )
	      plugins_transfer? ( curl )
	      curl? ( || (
		plugins_extract
		plugins_archlinux
		plugins_composer
		plugins_gitfast
		plugins_github
		plugins_gitignore
		plugins_hitokoto
		plugins_lol
		plugins_osx
		plugins_perl
		plugins_pip
		plugins_rand-quote
		plugins_singlechar
		plugins_sprunge
		plugins_systemadmin
		plugins_transfer ) )
	      plugins_cloudapp? ( ruby )
	      plugins_rbenv? ( ruby )
	      plugins_rust? ( rust )
	      plugins_salt? ( python )
	      wget? ( || (
		plugins_singlechar
		plugins_n98-magerun
	      ) )
	      themes_adben? ( wget )
	      update-emoji-data? ( plugins_emoji )
"
ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"
ZSH_EDEST="${EPREFIX}${ZSH_DEST}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

pkg_setup() {
	if use update-emoji-data ; then
		if has network-sandbox $FEATURES ; then
			die \
"${PN} require network-sandbox to be disabled in FEATURES on a per-package \
basis in order to update emoji data."
		fi
	fi
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	einfo \
"\n\
You must also read and agree to the licenses:\n\
  https://www.unicode.org/license.html\n\
  http://www.unicode.org/copyright.html\n\
\n\
Before downloading ${P}\n\
\n\
If you agree, you may download\n\
  - ${FN}\n\
from oh-my-zsh's GitHub page\n\
\n\
${P_URL}\n\
\n\
which the URL should be\n\
\n\
${A_URL}\n\
\n\
and rename it to ${P}.zip and place them in ${distdir}\n\
or you can \`wget -O ${distdir}/${P}.zip ${A_URL}\`\n\
\n"
}

src_unpack() {
	default

	cd "${S}" || die

	if use update-emoji-data ; then
		eapply \
"${FILESDIR}/oh-my-zsh-emoji-plugin-update-for-emoji-updater-perl-script-for-international-support-and-emoji-13_x-support.patch"
		einfo "update-emoji-data USE flag is experimental, and"
		einfo "It's not an official patch."
	fi

	if use update-emoji-data ; then
		pushd "${S}"/plugins/emoji || die
			perl update_emoji.pl "${EMOJI_LANG_DEFAULT}" || die
		popd
	fi
}

src_prepare() {
	default
	local i
	for i in "${S}"/tools/*install* "${S}"/tools/*upgrade*
	do
		test -f "${i}" && : >"${i}"
	done
	sed -i -e 's!ZSH=$HOME/.oh-my-zsh!ZSH='"${ZSH_EDEST}"'!' \
		"${S}/${ZSH_TEMPLATE}" || die
	sed -i -e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' "${S}/${ZSH_TEMPLATE}" \
		|| die
	sed -i -e '/zstyle.*cache/d' "${S}/lib/completion.zsh" || die

	if use branding ; then
		sed -i \
-e 's!\
ZSH_THEME="robbyrussell"!\
[[ -z "${ZSH_THEME}" ]] \&\& ZSH_THEME="gentoo"!g' \
		  "${S}/${ZSH_TEMPLATE}" || die
	else
		sed -i \
-e 's!\
ZSH_THEME="robbyrussell"!\
[[ -z "${ZSH_THEME}" ]] \&\& ZSH_THEME="robbyrussell"!g' \
		  "${S}/${ZSH_TEMPLATE}" || die
	fi

	if use plugins_common-aliases ; then
		if [[ -n "${OMZ_CHM_VIEWER}" ]] ; then
			sed -i -e "s|xchm|${OMZ_CHM_VIEWER}|" \
				"${S}/plugins/common-aliases/common-aliases.plugin.zsh" || die
		fi
		if [[ -n "${OMZ_PDF_VIEWER}" ]] ; then
			sed -i -e "s|acroread|${OMZ_PDF_VIEWER}|" \
				"${S}/plugins/common-aliases/common-aliases.plugin.zsh" || die
		fi
		if [[ -n "${OMZ_PS_VIEWER}" ]] ; then
			sed -i -e "s|gv|${OMZ_PS_VIEWER}|" \
				"${S}/plugins/common-aliases/common-aliases.plugin.zsh" || die
		fi
		if [[ -n "${OMZ_DJVU_VIEWER}" ]] ; then
			sed -i -e "s|djview|${OMZ_DJVU_VIEWER}|" \
				"${S}/plugins/common-aliases/common-aliases.plugin.zsh" || die
		fi
		if [[ -n "${OMZ_DVI_VIEWER}" ]] ; then
			sed -i -e "s|xdvi|${OMZ_DVI_VIEWER}|" \
				"${S}/plugins/common-aliases/common-aliases.plugin.zsh" || die
		fi
		if [[ -n "${OMZ_MEDIA_PLAYER}" ]] ; then
			sed -i -e "s|mplayer|${OMZ_MEDIA_PLAYER}|" \
				"${S}/plugins/common-aliases/common-aliases.plugin.zsh" || die
		fi
	fi

	if use plugins_gem ; then
		ewarn "The plugins_gem requires modding."
	fi

	if use plugins_salt ; then
		sed -i -e "s|python2|python3|" "${S}/plugins/salt/_salt" || die
	fi

	REQ_THEMES=$(echo "$USE" | grep -E -o -e "themes_[^ ]+")
	mv themes themes.trash
	mkdir themes
	for theme in ${REQ_THEMES} ; do
		#einfo "${theme}"
		theme=${theme//themes_/}
		TRASH="themes.trash"
		if [ -f ${TRASH}/${theme}.zsh-theme ] ; then
			#einfo "Keeping ${theme}..."
			cp -a ${TRASH}/${theme}.zsh-theme themes/ \
			  || die #for some reason mv doesn't work as expected
		else
			eerror "${theme} doesn't exist"
			die
		fi
	done

	REQ_PLUGINS=$(echo "$USE" | grep -E -o -e "plugins_[^ ]+")
	mv plugins plugins.trash
	mkdir plugins
	for plugin in ${REQ_PLUGINS} ; do
		plugin=${plugin//plugins_/}
		TRASH="plugins.trash"
		if [ -d ${TRASH}/${plugin} ] ; then
			#einfo "Keeping ${plugin}..."
			cp -a ${TRASH}/${plugin} plugins/ || die
		else
			eerror "${plugin} doesn't exist"
			die
		fi
	done

	rm -rf themes.trash
	rm -rf plugins.trash
}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
	if use plugins_emoji ; then
		insinto "${ZSH_DEST}/plugins/emoji/Unicode-DFS"
		doins "${FILESDIR}/Unicode-DFS"
	fi
}

pkg_postinst() {
	einfo "You must add \`source '${ZSH_DEST}/${ZSH_TEMPLATE}'\`"
	einfo "to your ~/.zshrc."
}
