# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

USE_RUBY="ruby24 ruby25 ruby26"
RUBY_OPTIONAL=1

inherit eutils python-r1 ruby-ng

DESCRIPTION="A delightful community-driven framework for managing your zsh configuration that includes optional plugins and themes."
HOMEPAGE="http://ohmyz.sh/"
COMMIT="9524db7398f405b26091f58fa8e2125d4e440a24"
SRC_URI="https://github.com/robbyrussell/oh-my-zsh/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT
	 plugins_shrink-path? ( WTFPL-2 )
	 plugins_z? ( WTFPL-2 )
	 plugins_coffee? ( BSD )
	 plugins_docker? ( BSD )
	 plugins_history-substring-search? ( BSD )
	 plugins_httpie? ( BSD )
	 plugins_kitchen? ( BSD )
	 plugins_ripgrep? ( BSD )
	 plugins_yarn? ( BSD )
	 plugins_git-escape-magic? ( BSD-2 )
	 plugins_gitfast? ( GPL-2 )
	 plugins_pass? ( GPL-2+ )
	 plugins_geeknote? ( GPL-3+ )
	 plugins_grunt? ( MIT )
	 plugins_gulp? ( MIT )
	 plugins_osx? ( MIT )
	 plugins_taskwarrior? ( MIT )
	 plugins_wd? ( MIT )
	 plugins_zsh-navigation-tools? ( MIT GPL-3 )
	 plugins_kube-ps1? ( Apache-2.0 )
	 plugins_sfdx? ( Apache-2.0 )
        "
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="branding bzr clipboard curl emojis java git gpg mercurial nodejs powerline python ruby rust subversion sudo wget"
IUSE+=" 7zip bzip2 gzip lzma unzip rar xz"
OMZSH_THEMES=( 3den adben af-magic afowler agnoster alanpeabody amuse apple arrow aussiegeek avit awesomepanda bira blinks bureau candy-kingdom candy clean cloud crcandy crunch cypher dallas darkblood daveverwer dieter dogenpunk dpoggi dstufft dst duellj eastwood edvardm emotty essembeh evan fino-time fino fishy flazz fletcherm fox frisk frontcube funky fwalch gallifrey gallois garyblessington gentoo geoffgarside gianu gnzh gozilla half-life humza imajes intheloop itchy jaischeema jbergantine jispwoso jnrowe jonathan josh jreese jtriley juanghurtado junkfood kafeitu kardan kennethreitz kiwi kolo kphoen lambda linuxonly lukerandall macovsky-ruby macovsky maran mgutz mh michelebologna mikeh miloshadzic minimal mira mortalscumbag mrtazz murilasso muse nanotech nebirhos nicoulaj norm obraun peepcode philips pmcgee pygmalion-virtualenv pygmalion re5et refined rgm risto rixius rkj-repos rkj robbyrussell sammy simonoff simple skaro smt Soliah sonicradish sorin sporty_256 steeef strug sunaku sunrise superjarin suvash takashiyoshida terminalparty theunraveler tjkirch_mod tjkirch tonotdo trapd00r wedisagree wezm+ wezm wuffers xiong-chiamiov-plus xiong-chiamiov ys zhann )
IUSE+=" ${OMZSH_THEMES[@]/#/-themes_}"
OMZSH_PLUGINS=( adb alias-finder ansible ant apache2-macports arcanist archlinux asdf autoenv autojump autopep8 aws battery bbedit bgnotify boot2docker bower branch brew bundler cabal cake cakephp3 capistrano cargo cask catimg celery chruby chucknorris cloudapp cloudfoundry codeclimate coffee colemak colored-man-pages colorize command-not-found common-aliases compleat composer copybuffer copydir copyfile cp cpanm dash debian dircycle dirhistory dirpersist django dnf dnote docker docker-compose docker-machine doctl dotenv droplr drush eecms emacs ember-cli emoji emoji-clock emotty encode64 extract fabric fancy-ctrl-z fasd fastfile fbterm fd fedora firewalld forklift fossil frontend-search fzf gas gatsby gb geeknote gem git git-auto-fetch git-escape-magic git-extras gitfast git-flow git-flow-avh github git-hubflow gitignore git-prompt git-remote-branch glassfish globalias gnu-utils go golang gpg-agent gradle grails grunt gulp hanami helm heroku history history-substring-search homestead httpie iterm2 jake-node jenv jhbuild jira jruby jsontools jump kate keychain kitchen knife knife_ssh kops kubectl kube-ps1 laravel laravel4 laravel5 last-working-dir lein lighthouse lol macports magic-enter man marked2 mercurial meteor minikube mix mix-fast mosh mvn mysql-macports n98-magerun nanoc ng nmap node nomad npm npx nvm nyan oc osx otp pass paver pep8 percol per-directory-history perl perms phing pip pipenv pj please pod postgres pow powder powify profiles pyenv pylint python rails rake rake-fast rand-quote rbenv rbfu react-native rebar redis-cli repo ripgrep ros rsync ruby rust rvm safe-paste salt sbt scala scd screen scw sdk sfdx sfffe shrink-path singlechar spring sprunge ssh-agent stack sublime sudo supervisor suse svcat svn svn-fast-info swiftpm symfony symfony2 systemadmin systemd taskwarrior terminalapp terminitor terraform textastic textmate thefuck themes thor tig timer tmux tmux-cssh tmuxinator torrent transfer tugboat ubuntu ufw urltools vagrant vagrant-prompt vault vim-interaction vi-mode virtualenv virtualenvwrapper vscode vundle wakeonlan wd web-search wp-cli xcode yarn yii yii2 yum z zeus zsh-navigation-tools zsh_reload )
IUSE+=" ${OMZSH_PLUGINS[@]/#/-plugins_}"

PLUGINS_DEPEND="
	 plugins_adb? ( dev-util/android-tools )
	 plugins_ansible? ( app-admin/ansible )
	 plugins_ant? ( dev-java/ant )
	 plugins_autojump? ( app-shells/autojump )
	 plugins_aws? ( dev-python/awscli )
	 plugins_battery? ( sys-power/acpi )
	 plugins_bundler? ( dev-ruby/bundler )
	 plugins_cabal? ( dev-haskell/cabal )
	 plugins_cargo? ( virtual/cargo )
	 plugins_catimg? ( media-gfx/imagemagick[png] )
	 plugins_celery? ( dev-python/celery )
	 plugins_chucknorris? ( games-misc/fortune-mod )
	 plugins_colorize? ( dev-python/pygments )
	 plugins_django? ( dev-python/django )
	 plugins_docker-machine? ( app-emulation/docker-machine )
	 plugins_doctl? ( app-admin/doctl )
	 plugins_drush? ( app-admin/drush )
	 plugins_emacs? ( >=app-editors/emacs-24.0 )
	 plugins_fbterm? ( app-i18n/fbterm )
	 plugins_firewalld? ( net-firewall/firewalld )
	 plugins_fossil? ( dev-vcs/fossil )
	 plugins_fzf? ( app-shells/fzf )
	 plugins_gb? ( dev-go/gb )
	 plugins_go? ( dev-lang/go )
	 plugins_golang? ( dev-lang/go )
	 plugins_gradle? ( virtual/gradle )
	 plugins_helm? ( app-admin/helm )
	 plugins_heroku? ( dev-util/heroku-cli )
	 plugins_jira? ( dev-python/jira )
	 plugins_kate? ( kde-apps/kate )
	 plugins_knife_ssh? ( virtual/ssh )
	 plugins_kops? ( sys-cluster/kops )
	 plugins_kubectl? ( sys-cluster/kubectl )
	 plugins_laravel? ( dev-lang/php )
	 plugins_laravel4? ( dev-lang/php )
	 plugins_laravel5? ( dev-lang/php )
	 plugins_man? ( virtual/man )
	 plugins_minikube? ( sys-cluster/minikube )
	 plugins_mvn? ( dev-java/maven-bin )
	 plugins_nmap? ( net-analyzer/nmap )
	 plugins_nomad? ( sys-cluster/nomad )
	 plugins_npm? ( net-libs/nodejs[npm] )
	 plugins_otp? ( sys-auth/oath-toolkit )
	 plugins_paver? ( dev-python/paver )
	 plugins_percol? ( app-shells/percol )
	 plugins_pep8? ( dev-python/pep8 )
	 plugins_perl? ( dev-lang/perl )
	 plugins_phing? ( dev-php/phing )
	 plugins_pip? ( dev-python/pip )
	 plugins_pipenv? ( dev-python/pipenv )
	 plugins_postgres? ( dev-db/postgresql )
	 plugins_pylint? ( dev-python/pylint )
	 plugins_rails? ( || ( dev-ruby/rails dev-lang/ruby dev-ruby/rake ) )
	 plugins_rake-fast? ( dev-ruby/rake )
	 plugins_rand-quote? ( net-misc/curl )
	 plugins_repo? ( dev-util/repo )
	 plugins_ros? ( dev-lisp/roswell )
	 plugins_rsync? ( net-misc/rsync )
	 plugins_ruby? ( dev-lang/ruby dev-ruby/rubygems )
	 plugins_salt? ( dev-lang/python:2.7 )
	 plugins_scala? ( dev-lang/scala )
	 plugins_sfffe? ( sys-apps/ack )
	 plugins_stack? ( dev-haskell/stack )
	 plugins_sublime? ( app-editors/sublime-text )
	 plugins_supervisor? ( app-admin/supervisor )
	 plugins_systemd? ( sys-apps/systemd )
	 plugins_symfony? ( dev-lang/php dev-php/symfony-console )
	 plugins_symfony2? ( dev-lang/php dev-php/symfony-console )
	 plugins_terraform? ( app-admin/terraform )
	 plugins_thefuck? ( app-shells/thefuck )
	 plugins_thor? ( dev-ruby/thor )
	 plugins_tig? ( dev-vcs/tig )
	 plugins_tmux? ( app-misc/tmux )
	 plugins_vagrant? ( app-emulation/vagrant )
	 plugins_vagrant-prompt? ( app-emulation/vagrant )
	 plugins_vim-interaction? ( app-editors/gvim )
	 plugins_virtualenvwrapper? ( dev-python/virtualenvwrapper )
	 plugins_vscode? ( || ( app-editors/visual-studio-code app-editors/visual-studio-code-bin app-editors/vscode app-editors/vscode-bin ) )
	 plugins_vundle? ( app-editors/vim )
	 plugins_wakeonlan? ( net-misc/wakeonlan )
	 plugins_yarn? ( sys-apps/yarn )
	 plugins_wp-cli? ( app-admin/wp-cli )
              "
#	 plugins_urltools? ( || ( dev-lang/perl net-libs/nodejs dev-lang/php dev-lang/ruby dev-lang/python ) )
#	 plugins_jsontools? ( || ( dev-lang/ruby dev-lang/python net-libs/nodejs ) )
THEMES_DEPEND="
	 themes_adben? ( games-misc/fortune-mod )
	 "
RDEPEND="app-shells/zsh
	 bzr? ( dev-vcs/bzr )
	 clipboard? ( || ( x11-misc/xclip x11-misc/xsel ) )
	 emojis? ( || ( media-fonts/noto-color-emoji media-fonts/noto-color-emoji-bin media-fonts/emojione-color-font media-fonts/unifont media-fonts/twemoji-color-font media-fonts/symbola ) )
	 git? ( dev-vcs/git )
	 gpg? ( app-crypt/gnupg )
	 java? ( virtual/jre )
         powerline? ( media-fonts/powerline-symbols )
	 python? ( ${PYTHON_DEPS} )
	 rust? ( virtual/rust )
	 sudo? ( app-admin/sudo )
	 bzip2? ( app-arch/bzip2 )
	 gzip? ( app-arch/pigz )
	 lzma? ( app-arch/xz-utils )
	 mercurial? ( dev-vcs/mercurial )
	 nodejs? ( net-libs/nodejs )
	 ${PLUGINS_DEPEND}
	 ${PYTHON_DEPS}
	 rar? ( app-arch/unrar )
	 ruby? ( $(ruby_implementations_depend) )
	 subversion? ( dev-vcs/subversion )
	 ${THEMES_DEPEND}
	 unzip? ( app-arch/unzip )
	 virtual/awk
	 wget? ( net-misc/wget )
	 x11-misc/xdg-utils
	 xz? ( app-arch/xz-utils )
	 7zip? ( app-arch/p7zip )
	"
DEPEND="${RDEPEND}"
S="${WORKDIR}/all/${PN}-${COMMIT}"
REQUIRED_USE="branding? ( themes_gentoo ) themes_agnoster? ( powerline ) themes_emotty? ( powerline ) themes_amuse? ( powerline )
	      plugins_emoji-clock? ( emojis )
	      plugins_emoji? ( emojis )
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
	      plugins_dnf? ( sudo )
	      plugins_drush? ( sudo )
	      plugins_firewalld? ( sudo )
	      plugins_archlinux? ( sudo )
	      plugins_macports? ( sudo )
	      plugins_mysql-macports? ( sudo )
	      plugins_nmap? ( sudo )
	      plugins_rake? ( sudo )
	      plugins_sudo? ( sudo )
	      plugins_suse? ( sudo )
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
	      plugins_extract? ( || ( 7zip bzip2 gzip lzma unzip rar xz ) )
	      plugins_archlinux? ( curl )
	      plugins_composer? ( curl )
	      plugins_gitfast? ( curl )
	      plugins_github? ( curl )
	      plugins_gitignore? ( curl )
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
		plugins_lol
		plugins_osx
		plugins_perl
		plugins_pip
		plugins_rand-quote
		plugins_singlechar
		plugins_sprunge
		plugins_systemadmin
		plugins_transfer ) )
	      plugins_salt? ( python_targets_python2_7 )
	      plugins_cloudapp? ( ruby )
	      plugins_rbenv? ( ruby )
	      plugins_rust? ( rust )
	      wget? ( || (
		plugins_singlechar
		plugins_n98-magerun
	      ) )
	      themes_adben? ( wget )
             "

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

	REQ_THEMES=$(echo "$USE" | grep -o -P "themes_[^ ]+")
	mv themes themes.trash
	mkdir themes
	for theme in ${REQ_THEMES} ; do
		#einfo "${theme}"
		theme=${theme//themes_/}
		TRASH="themes.trash"
		if [ -f ${TRASH}/${theme}.zsh-theme ] ; then
			#einfo "Keeping ${theme}..."
			cp -a ${TRASH}/${theme}.zsh-theme themes/ || die #for some reason mv doesn't work as expected
		else
			eerror "${theme} doesn't exist"
			die
		fi
	done

	REQ_PLUGINS=$(echo "$USE" | grep -o -P "plugins_[^ ]+")
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

	eapply_user
}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
}

pkg_postinst() {
	einfo "You must add \`source '${ZSH_DEST}/${ZSH_TEMPLATE}'\` to your ~/.zshrc."
}
