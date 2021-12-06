# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
USE_RUBY="ruby26 ruby27 ruby30"

inherit eutils python-r1 ruby-ng

DESCRIPTION="A delightful community-driven framework for managing your zsh \
configuration that includes optional plugins and themes."
HOMEPAGE="http://ohmyz.sh/"
LICENSE="MIT
	 Apache-2.0
	 unicode
	 omz_plugins_bazel? ( Apache-2.0 )
	 omz_plugins_kube-ps1? ( Apache-2.0 )
	 omz_plugins_sfdx? ( Apache-2.0 )
	 omz_plugins_coffee? ( BSD )
	 omz_plugins_docker? ( BSD )
	 omz_plugins_history-substring-search? ( BSD )
	 omz_plugins_httpie? ( BSD )
	 omz_plugins_kitchen? ( BSD )
	 omz_plugins_ripgrep? ( BSD )
	 omz_plugins_scala? ( BSD )
	 omz_plugins_yarn? ( BSD )
	 omz_plugins_git-escape-magic? ( BSD-2 )
	 omz_plugins_gitfast? ( GPL-2 )
	 omz_plugins_pass? ( GPL-2+ )
	 omz_plugins_geeknote? ( GPL-3+ )
	 omz_plugins_term_tab? ( GPL-2+ )
	 omz_plugins_zbell? ( ISC )
	 omz_plugins_dotnet? ( all-rights-reserved MIT )
	 omz_plugins_aliases? ( MIT )
	 omz_plugins_gradle? ( MIT )
	 omz_plugins_grunt? ( MIT )
	 omz_plugins_gulp? ( MIT )
	 omz_plugins_ipfs? ( MIT )
	 omz_plugins_lando? ( MIT )
	 omz_plugins_macos? ( MIT )
	 omz_plugins_osx? ( MIT )
	 omz_plugins_taskwarrior? ( MIT )
	 omz_plugins_wd? ( MIT )
	 omz_plugins_zsh-navigation-tools? ( MIT GPL-3 )
	 omz_plugins_shrink-path? ( WTFPL-2 )
	 omz_plugins_z? ( WTFPL-2 )
	 omz_plugins_per-directory-history? ( ZLIB )"

# tools/install.sh - Apache-2.0

# Live ebuilds do not get keyworded.

RUBY_OPTIONAL=1
EMOJI_LANG_DEFAULT=${EMOJI_LANG_DEFAULT:=en}
EGIT_COMMIT="841f3cb0bb7663fa1062ffc59acb7b4581dc1d0f"
FN_SRC="${EGIT_COMMIT}.zip"
FN_DST="${P}-${EGIT_COMMIT:0:7}.zip"
A_URL="https://github.com/ohmyzsh/ohmyzsh/archive/${FN_SRC}"
P_URL="https://github.com/ohmyzsh/ohmyzsh/tree/${EGIT_COMMIT}"
SRC_URI="${A_URL} -> ${FN_DST}"
# Probably needs to be done because the archive contains the UNICODE data file.
# It should be addressed upstream to get rid of emoji-data.txt.
RESTRICT+=" fetch"
SLOT="0"
IUSE+=" branding bzr clipboard curl emojis update-emoji-data java git gpg
mercurial nodejs powerline perlbrew python ruby rust subversion sudo
uri wget
7zip ace bzip2 deb gzip lrzip lz4 lzip lzma lzo lzw unzip rar rpm tar xz zip zstd"
OMZSH_THEMES=(
3den Soliah adben af-magic afowler agnoster alanpeabody amuse apple arrow
aussiegeek avit awesomepanda bira blinks bureau candy-kingdom candy clean cloud
crcandy crunch cypher dallas darkblood daveverwer dieter dogenpunk dpoggi dst
dstufft duellj eastwood edvardm emotty essembeh evan fino-time fino fishy flazz
fletcherm fox frisk frontcube funky fwalch gallifrey gallois garyblessington
gentoo geoffgarside gianu gnzh gozilla half-life humza imajes intheloop itchy
jaischeema jbergantine jispwoso jnrowe jonathan josh jreese jtriley
juanghurtado junkfood kafeitu kardan kennethreitz kiwi kolo kphoen lambda
linuxonly lukerandall macovsky-ruby macovsky maran mgutz mh michelebologna
mikeh miloshadzic minimal mira mlh mortalscumbag mrtazz murilasso muse nanotech
nebirhos nicoulaj norm obraun peepcode philips pmcgee pygmalion-virtualenv
pygmalion random re5et refined rgm risto rixius rkj-repos rkj robbyrussell
sammy simonoff simple skaro smt sonicradish sorin sporty_256 steeef strug
sunaku sunrise superjarin suvash takashiyoshida terminalparty theunraveler
tjkirch tjkirch_mod tonotdo trapd00r wedisagree wezmx wezm wuffers
xiong-chiamiov-plus xiong-chiamiov ys zhann
)

IUSE+=" ${OMZSH_THEMES[@]/#/-omz_themes_}"
OMZSH_PLUGINS=(
adb ag alias-finder aliases ansible ant apache2-macports arcanist archlinux
asdf autoenv autojump autopep8 aws battery bazel bbedit bedtools bgnotify
boot2docker bower branch brew bundler cabal cake cakephp3 capistrano cargo cask
catimg celery chruby chucknorris cloudfoundry codeclimate coffee colemak
colored-man-pages colorize command-not-found common-aliases compleat composer
copybuffer copydir copyfile cp cpanm dash debian deno dircycle direnv
dirhistory dirpersist django dnf dnote docker docker-compose docker-machine
doctl dotenv dotnet droplr drush eecms emacs ember-cli emoji emoji-clock emotty
encode64 extract fabric fancy-ctrl-z fasd fastfile fbterm fd firewalld flutter
fnm forklift fossil frontend-search fzf gas gatsby gb gcloud geeknote gem
genpass gh git git-auto-fetch git-escape-magic git-extras git-flow git-flow-avh
git-hubflow git-lfs git-prompt gitfast github gitignore glassfish globalias
gnu-utils golang gpg-agent gradle grails grc grunt gulp hanami helm heroku
history history-substring-search hitchhiker hitokoto homestead httpie invoke
ionic ipfs isodate iterm2 jake-node jenv jfrog jhbuild jira jruby jsontools
juju jump kate keychain kitchen kn knife knife_ssh kops kube-ps1 kubectl
kubectx lando laravel laravel4 laravel5 last-working-dir lein lighthouse lol
lxd macos macports magic-enter man marked2 mercurial meteor microk8s minikube
mix mix-fast mongocli mosh mvn mysql-macports n98-magerun nanoc ng nmap node
nomad npm npx nvm oc octozen osx otp pass paver pep8 per-directory-history
percol perl perms phing pip pipenv pj please pm2 pod postgres pow powder powify
profiles pyenv pylint python rails rake rake-fast rand-quote rbenv rbfu
react-native rebar redis-cli repo ripgrep ros rsync ruby rust rustup rvm
safe-paste salt samtools sbt scala scd screen scw sdk sfdx sfffe shell-proxy
shrink-path singlechar spring sprunge ssh-agent stack sublime sublime-merge
sudo supervisor suse svcat svn svn-fast-info swiftpm symfony symfony2
systemadmin systemd taskwarrior term_tab terminitor terraform textastic
textmate thefuck themes thor tig timer tmux tmux-cssh tmuxinator torrent
transfer tugboat ubuntu ufw universalarchive urltools vagrant vagrant-prompt
vault vi-mode vim-interaction virtualenv virtualenvwrapper vscode vundle
wakeonlan wd web-search wp-cli xcode yarn yii yii2 yum z zbell zeus zoxide
zsh-interactive-cd zsh-navigation-tools zsh_reload
)
IUSE+=" ${OMZSH_PLUGINS[@]/#/-omz_plugins_}"
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
	omz_plugins_adb? ( dev-util/android-tools )
	omz_plugins_ansible? ( app-admin/ansible )
	omz_plugins_ant? ( dev-java/ant )
	omz_plugins_arcanist? ( dev-util/arcanist )
	omz_plugins_autojump? ( app-shells/autojump )
	omz_plugins_aws? ( dev-python/awscli )
	omz_plugins_battery? ( sys-power/acpi )
	omz_plugins_bazel? ( dev-util/bazel )
	omz_plugins_bower? ( dev-nodejs/bower )
	omz_plugins_bundler? ( dev-ruby/bundler )
	omz_plugins_cabal? ( dev-haskell/cabal )
	omz_plugins_capistrano? ( dev-ruby/capistrano )
	omz_plugins_cargo? ( dev-lang/rust )
	omz_plugins_catimg? ( media-gfx/imagemagick[png] )
	omz_plugins_celery? ( dev-python/celery )
	omz_plugins_chucknorris? ( games-misc/fortune-mod )
	omz_plugins_colorize? ( dev-python/pygments )
	omz_plugins_colored-man-pages? ( sys-apps/groff )
	omz_plugins_common-aliases? ( ${RDEPEND_COMMON_ALIASES[@]}
				   sys-process/procps
				   dev-python/pygments )
	omz_plugins_composer? ( dev-lang/php dev-php/composer )
	omz_plugins_cpanm? ( dev-perl/App-cpanminus )
	omz_plugins_debian? ( app-arch/dpkg )
	omz_plugins_direnv? ( dev-util/direnv )
	omz_plugins_django? ( dev-python/django )
	omz_plugins_docker-compose? ( app-emulation/docker-compose )
	omz_plugins_docker-machine? ( app-emulation/docker-machine )
	omz_plugins_doctl? ( app-admin/doctl )
	omz_plugins_dotnet? ( || ( dev-dotnet/cli-tools
				dev-dotnet/dotnetcore-sdk-bin ) )
	omz_plugins_drush? ( app-admin/drush )
	omz_plugins_eecms? ( dev-lang/php )
	omz_plugins_emacs? ( >=app-editors/emacs-24.0 )
	omz_plugins_fasd? ( app-misc/fasd )
	omz_plugins_fbterm? ( app-i18n/fbterm )
	omz_plugins_firewalld? ( net-firewall/firewalld )
	omz_plugins_flutter? ( dev-util/flutter )
	omz_plugins_fossil? ( dev-vcs/fossil )
	omz_plugins_fzf? ( app-shells/fzf )
	omz_plugins_gb? ( dev-go/gb )
	omz_plugins_gcloud? ( app-misc/google-cloud-sdk )
	omz_plugins_geeknote? ( app-misc/geeknote )
	omz_plugins_gem? ( virtual/rubygems )
	omz_plugins_github? ( dev-vcs/hub )
	omz_plugins_git-extras? ( dev-vcs/git-extras )
	omz_plugins_git-lfs? ( dev-vcs/git-lfs )
	omz_plugins_gnu-utils? ( sys-apps/coreutils )
	omz_plugins_golang? ( dev-lang/go )
	omz_plugins_globalias? ( sys-apps/grep[pcre] )
	omz_plugins_gradle? ( dev-java/gradle-bin )
	omz_plugins_grc? ( app-misc/grc )
	omz_plugins_helm? ( app-admin/helm )
	omz_plugins_heroku? ( dev-util/heroku-cli )
	omz_plugins_hitchhiker? ( games-misc/cowsay
				   games-misc/fortune-mod )
	omz_plugins_httpie? ( net-misc/httpie )
	omz_plugins_jira? ( dev-python/jira )
	omz_plugins_jfrog? ( dev-util/jfrog-cli )
	omz_plugins_kate? ( kde-apps/kate )
	omz_plugins_keychain? ( net-misc/keychain )
	omz_plugins_kops? ( sys-cluster/kops )
	omz_plugins_kube-ps1? ( sys-cluster/kubernetes )
	omz_plugins_kubectl? ( sys-cluster/kubernetes )
	omz_plugins_laravel? ( dev-lang/php )
	omz_plugins_laravel4? ( dev-lang/php )
	omz_plugins_laravel5? ( dev-lang/php )
	omz_plugins_lol? ( sys-process/procps )
	omz_plugins_man? ( virtual/man )
	omz_plugins_minikube? ( sys-cluster/minikube )
	omz_plugins_mix? ( dev-lang/elixir )
	omz_plugins_mongocli? ( dev-db/mongodb )
	omz_plugins_mvn? ( dev-java/maven-bin
			sys-apps/grep[pcre] )
	omz_plugins_nanoc? ( www-apps/nanoc )
	omz_plugins_nmap? ( net-analyzer/nmap )
	omz_plugins_nomad? ( sys-cluster/nomad )
	omz_plugins_npm? ( net-libs/nodejs[npm] )
	omz_plugins_otp? ( sys-auth/oath-toolkit )
	omz_plugins_oc? ( || ( app-emulation/openshift-cli \
		sys-cluster/openshift-client-bin \
		app-admin/openshift-client-tools ) )
	omz_plugins_paver? ( dev-python/paver )
	omz_plugins_percol? ( app-shells/percol )
	omz_plugins_pep8? ( dev-python/pep8 )
	omz_plugins_perl? ( dev-lang/perl
			 perlbrew? ( dev-perl/App-perlbrew )
			 sys-apps/grep[pcre] )
	omz_plugins_phing? ( dev-php/phing )
	omz_plugins_pip? ( dev-python/pip )
	omz_plugins_pipenv? ( dev-python/pipenv )
	omz_plugins_postgres? ( dev-db/postgresql )
	omz_plugins_pylint? ( dev-python/pylint )
	omz_plugins_rails? ( || ( dev-ruby/rails
				dev-lang/ruby
				dev-ruby/rake ) )
	omz_plugins_rake-fast? ( dev-ruby/rake )
	omz_plugins_rand-quote? ( net-misc/curl )
	omz_plugins_rebar? ( dev-util/rebar3 )
	omz_plugins_redis-cli? ( dev-db/redis )
	omz_plugins_repo? ( dev-util/repo )
	omz_plugins_ripgrep? ( sys-apps/ripgrep )
	omz_plugins_ros? ( dev-lisp/roswell )
	omz_plugins_rsync? ( net-misc/rsync )
	omz_plugins_ruby? ( dev-lang/ruby dev-ruby/rubygems )
	omz_plugins_rvm? ( dev-ruby/rvm )
	omz_plugins_salt? ( app-admin/salt dev-lang/python )
	omz_plugins_sbt? ( || ( dev-java/sbt dev-java/sbt-bin ) )
	omz_plugins_scala? ( dev-lang/scala )
	omz_plugins_screen? ( app-misc/screen )
	omz_plugins_scw? ( app-admin/scaleway-cli )
	omz_plugins_sfffe? ( sys-apps/ack )
	omz_plugins_stack? ( dev-haskell/stack )
	omz_plugins_sublime? ( app-editors/sublime-text )
	omz_plugins_sublime-merge? ( dev-vcs/sublime-merge )
	omz_plugins_supervisor? ( app-admin/supervisor )
	omz_plugins_svn-fast-info? ( >=dev-vcs/subversion-1.6 )
	omz_plugins_systemadmin? ( || ( sys-apps/iproute2
				sys-apps/net-tools )
				sys-apps/net-tools
				sys-apps/findutils
				sys-process/procps
				net-analyzer/tcpdump )
	omz_plugins_systemd? ( sys-apps/systemd )
	omz_plugins_symfony? ( dev-lang/php dev-php/symfony-console )
	omz_plugins_symfony2? ( dev-lang/php dev-php/symfony-console )
	omz_plugins_taskwarrior? ( app-misc/task )
	omz_plugins_terraform? ( app-admin/terraform )
	omz_plugins_thefuck? ( app-shells/thefuck )
	omz_plugins_thor? ( dev-ruby/thor )
	omz_plugins_tig? ( dev-vcs/tig )
	omz_plugins_tmux? ( app-misc/tmux )
	omz_plugins_vagrant? ( app-emulation/vagrant )
	omz_plugins_vagrant-prompt? ( app-emulation/vagrant )
	omz_plugins_vim-interaction? ( app-editors/gvim )
	omz_plugins_virtualenvwrapper? ( dev-python/virtualenvwrapper )
	omz_plugins_vscode? ( || ( app-editors/visual-studio-code
				app-editors/visual-studio-code-bin
				app-editors/vscode
				app-editors/vscode-bin ) )
	omz_plugins_vundle? ( app-editors/vim )
	omz_plugins_wakeonlan? ( net-misc/wakeonlan )
	omz_plugins_yarn? ( sys-apps/yarn )
	omz_plugins_wp-cli? ( app-admin/wp-cli )
	omz_plugins_zsh-interactive-cd? ( app-shells/fzf )
	omz_plugins_zsh-navigation-tools? ( sys-process/procps )
	omz_plugins_zoxide? ( app-shells/zoxide )
"
#	omz_plugins_urltools? ( || ( dev-lang/perl
#				  net-libs/nodejs
#				  dev-lang/php
#				  dev-lang/ruby
#				  dev-lang/python ) )
#	omz_plugins_jsontools? ( || ( dev-lang/ruby
#				   dev-lang/python
#				   net-libs/nodejs ) )
THEMES_RDEPEND="
	 omz_themes_adben? ( games-misc/fortune-mod )"
CDEPEND=" >=app-shells/zsh-4.3.9"
RDEPEND+=" ${CDEPEND}
	 ${PLUGINS_RDEPEND}
	 ${PYTHON_DEPS}
	 ${THEMES_RDEPEND}
	 7zip? ( app-arch/p7zip )
	 ace? ( app-arch/unace )
	 bzr? ( dev-vcs/bzr )
	 clipboard? ( || ( x11-misc/xclip x11-misc/xsel app-misc/tmux ) )
	 deb? ( sys-devel/binutils )
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
	 lzo? ( app-arch/lzop )
	 lzw? ( app-arch/ncompress )
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
	 tar? ( app-arch/tar )
	 unzip? ( app-arch/unzip )
	 virtual/awk
	 wget? ( net-misc/wget )
	 x11-misc/xdg-utils
	 xz? ( app-arch/xz-utils )
	 zip? ( app-arch/unzip
		app-arch/zip )
	 zstd? ( app-arch/zstd )"
DEPEND+=" ${RDEPEND}"
BDEPEND+=" ${CDEPEND}
	net-misc/wget
	omz_plugins_emoji? ( dev-lang/perl dev-perl/Path-Class )
	update-emoji-data? ( dev-perl/XML-LibXML
			     dev-perl/Text-Unaccent )"
S="${WORKDIR}/${PN//-/}-${EGIT_COMMIT}"
REQUIRED_USE+=" branding? ( omz_themes_gentoo )
	deb? ( gzip bzip2 lzma tar xz )
	python? ( ${PYTHON_REQUIRED_USE} )
	gpg? ( || (
		omz_plugins_archlinux
		omz_plugins_gpg-agent
		omz_plugins_otp
		omz_plugins_pass ) )
	omz_themes_agnoster? ( powerline )
	omz_themes_emotty? ( powerline )
	omz_themes_amuse? ( powerline )
	omz_plugins_coffee? ( clipboard )
	omz_plugins_copybuffer? ( clipboard )
	omz_plugins_copydir? ( clipboard )
	omz_plugins_copyfile? ( clipboard )
	omz_plugins_emoji-clock? ( emojis )
	omz_plugins_emoji? ( emojis )
	omz_plugins_emotty? ( emojis omz_plugins_emoji !update-emoji-data )
	omz_plugins_git? ( git )
	omz_plugins_github? ( git )
	omz_plugins_git-auto-fetch? ( git )
	omz_plugins_git-extras? ( git )
	omz_plugins_gitfast? ( git )
	omz_plugins_git-hubflow? ( git )
	omz_plugins_git-prompt? ( git )
	omz_plugins_git-flow? ( git )
	omz_plugins_magic-enter? ( git )
	omz_plugins_jenv? ( java )
	omz_plugins_mercurial? ( mercurial )
	omz_plugins_node? ( nodejs )
	omz_plugins_svn? ( subversion )
	omz_plugins_svn-fast-info? ( subversion )
	omz_plugins_apache2-macports? ( sudo )
	omz_plugins_debian? ( sudo )
	omz_plugins_dnf? ( sudo )
	omz_plugins_drush? ( sudo )
	omz_plugins_firewalld? ( sudo )
	omz_plugins_archlinux? ( sudo )
	omz_plugins_macports? ( sudo )
	omz_plugins_mysql-macports? ( sudo )
	omz_plugins_nmap? ( sudo )
	omz_plugins_rake? ( sudo )
	omz_plugins_singlechar? ( sudo )
	omz_plugins_sudo? ( sudo )
	omz_plugins_suse? ( sudo )
	omz_plugins_systemd? ( sudo )
	omz_plugins_systemadmin? ( sudo )
	omz_plugins_ubuntu? ( sudo )
	omz_plugins_universalarchive? ( 7zip bzip2 gzip lzma lzo lzw
						rar xz zip zstd )
	omz_plugins_xcode? ( sudo )
	omz_plugins_yum? ( sudo )
	omz_plugins_archlinux? ( gpg )
	omz_plugins_gpg-agent? ( gpg )
	omz_plugins_otp? ( gpg )
	omz_plugins_pass? ( gpg )
	omz_plugins_common-aliases? ( ace rar zip )
	omz_plugins_extract? ( || ( 7zip bzip2 deb gzip lrzip lz4 lzip
					lzma lzw unzip rar rpm xz zstd ) )
	omz_plugins_archlinux? ( curl )
	omz_plugins_composer? ( curl )
	omz_plugins_gitfast? ( curl )
	omz_plugins_github? ( curl )
	omz_plugins_gitignore? ( curl )
	omz_plugins_hitokoto? ( curl )
	omz_plugins_lol? ( curl )
	omz_plugins_osx? ( curl )
	omz_plugins_perl? ( curl )
	omz_plugins_pip? ( curl )
	omz_plugins_rand-quote? ( curl )
	omz_plugins_singlechar? ( curl )
	omz_plugins_sprunge? ( curl )
	omz_plugins_systemadmin? ( curl )
	omz_plugins_transfer? ( curl )
	curl? ( || (
		omz_plugins_extract
		omz_plugins_archlinux
		omz_plugins_composer
		omz_plugins_gitfast
		omz_plugins_github
		omz_plugins_gitignore
		omz_plugins_hitokoto
		omz_plugins_lol
		omz_plugins_osx
		omz_plugins_perl
		omz_plugins_pip
		omz_plugins_rand-quote
		omz_plugins_singlechar
		omz_plugins_sprunge
		omz_plugins_systemadmin
		omz_plugins_transfer ) )
	omz_plugins_rbenv? ( ruby )
	omz_plugins_rust? ( rust )
	omz_plugins_salt? ( python )
	wget? ( || (
		omz_plugins_singlechar
		omz_plugins_n98-magerun
	) )
	omz_themes_adben? ( wget )
	update-emoji-data? ( omz_plugins_emoji )"
ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"
ZSH_EDEST="${EPREFIX}${ZSH_DEST}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

#GEN_EBUILD="1" # Uncomment to auto generate parts of the ebuild

pkg_setup() {
	if use update-emoji-data ; then
		if has network-sandbox $FEATURES ; then
eerror
eerror "${PN} require network-sandbox to be disabled in FEATURES on a"
eerror "per-package basis in order to update emoji data."
eerror
			die
		fi
	fi
	if use ruby ; then
		ruby-ng_pkg_setup
	fi
	if use python ; then
		python_setup
	fi
}

pkg_nofetch() {
	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	# The restriction is here because of plugins/emoji/emoji-data.txt
einfo
einfo "You must also read and agree to the licenses:"
einfo "  https://www.unicode.org/license.html"
einfo "  http://www.unicode.org/copyright.html"
einfo "Before downloading ${P}."
einfo
einfo "If you agree, you may download ${FN_SRC}"
einfo "from oh-my-zsh's GitHub page located at ${P_URL}"
einfo "which the download URL should be ${A_URL}"
einfo "and rename it to ${FN_DST} and place them in ${distdir}"
einfo "or you can \`wget -O ${distdir}/${FN_DST} ${A_URL}\`"
einfo
}

MISSING_DEPENDS=()
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

	local plugins=$(ls -1 "${S}/plugins" \
		| tr "\n" " " \
		| fold -w 80 -s \
		| sed -e "s| $||g")
	local n
	for n in ${plugins} ; do
		local x
		local found=0
		for x in $(echo "${PLUGINS_RDEPEND}" \
			| tr " " "\n" \
			| grep -E -o -e "omz_plugins_[^ ?]+" \
			| sed -e "s|omz_plugins_||g") ; do
			if [[ "${n}" == "${x}" ]] ; then
				found=1
			fi
		done
		if (( ${found} == 0 )) ; then
			MISSING_DEPENDS+=( "${n}" )
		fi
	done
	if [[ -n "${GEN_EBUILD}" && "${GEN_EBUILD}" == 1 ]] ; then
		einfo "Please update the following:"

		einfo "OMZSH_PLUGINS:"
		echo -e "${plugins}"

		echo
		echo
		echo

		einfo "OMZSH_THEMES:"
		local themes=$(ls -1 "${S}/themes" \
			| tr "\n" " " \
			| sed -e "s|.zsh-theme||g" -e "s|wezm[+]|wezmx|g" \
			| fold -w 80 -s \
			| sed -e "s| $||g")
		echo -e "${themes}"

		echo
		echo
		echo

		einfo "\${REPO_DIR}/profiles/desc/omz_plugins.desc"

		for n in ${plugins} ; do
			echo "${n} - Installs the ${n} plugin."
		done

		echo
		echo
		echo

		einfo "\${REPO_DIR}/profiles/desc/omz_themes.desc"

		for n in ${themes} ; do
			echo "${n} - Adds the ${n} theme."
		done

		echo
		echo
		echo

		einfo "Missing PLUGINS_RDEPEND for"
		for n in ${MISSING_DEPENDS[@]} ; do
			echo "${n}"
		done
		die
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

	if use omz_plugins_common-aliases ; then
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

	if use omz_plugins_gem ; then
		ewarn "The omz_plugins_gem requires modding."
	fi

	if use omz_plugins_salt ; then
		sed -i -e "s|python2|python3|" "${S}/plugins/salt/_salt" || die
	fi

	REQ_THEMES=$(echo "$USE" | grep -E -o -e "omz_themes_[^ ]+")
	mv themes themes.trash
	mkdir themes
	for theme in ${REQ_THEMES} ; do
		#einfo "${theme}"
		theme=${theme//omz_themes_/}
		theme=${theme//wezmx/wezm+}
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

	REQ_PLUGINS=$(echo "$USE" | grep -E -o -e "omz_plugins_[^ ]+")
	mv plugins plugins.trash
	mkdir plugins
	for plugin in ${REQ_PLUGINS} ; do
		plugin=${plugin//omz_plugins_/}
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
	if use omz_plugins_emoji ; then
		insinto "${ZSH_DEST}/plugins/emoji/Unicode-DFS"
		doins "${FILESDIR}/Unicode-DFS"
	fi
}

pkg_postinst() {
	einfo
	einfo "You must add \`source '${ZSH_DEST}/${ZSH_TEMPLATE}'\`"
	einfo "to your ~/.zshrc."
	einfo

	if (( "${#MISSING_DEPENDS[@]}" > 0 )) ; then
		# Too many too add and inspect =(
ewarn
ewarn "The following have not yet had their dependencies added to the ebuild"
ewarn "and may require manual installation:"
ewarn
		echo "${MISSING_DEPENDS[@]/#/omz_plugins_}" | fold -w 80 -s
	fi
}
