# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

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
IUSE="branding clipboard git powerline"
OMZSH_THEMES=( 3den adben af-magic afowler agnoster alanpeabody amuse apple arrow aussiegeek avit awesomepanda bira blinks bureau candy-kingdom candy clean cloud crcandy crunch cypher dallas darkblood daveverwer dieter dogenpunk dpoggi dstufft dst duellj eastwood edvardm emotty essembeh evan fino-time fino fishy flazz fletcherm fox frisk frontcube funky fwalch gallifrey gallois garyblessington gentoo geoffgarside gianu gnzh gozilla half-life humza imajes intheloop itchy jaischeema jbergantine jispwoso jnrowe jonathan josh jreese jtriley juanghurtado junkfood kafeitu kardan kennethreitz kiwi kolo kphoen lambda linuxonly lukerandall macovsky-ruby macovsky maran mgutz mh michelebologna mikeh miloshadzic minimal mira mortalscumbag mrtazz murilasso muse nanotech nebirhos nicoulaj norm obraun peepcode philips pmcgee pygmalion-virtualenv pygmalion re5et refined rgm risto rixius rkj-repos rkj robbyrussell sammy simonoff simple skaro smt Soliah sonicradish sorin sporty_256 steeef strug sunaku sunrise superjarin suvash takashiyoshida terminalparty theunraveler tjkirch_mod tjkirch tonotdo trapd00r wedisagree wezm+ wezm wuffers xiong-chiamiov-plus xiong-chiamiov ys zhann )
IUSE+=" ${OMZSH_THEMES[@]/#/-themes_}"
OMZSH_PLUGINS=( adb alias-finder ansible ant apache2-macports arcanist archlinux asdf autoenv autojump autopep8 aws battery bbedit bgnotify boot2docker bower branch brew bundler cabal cake cakephp3 capistrano cargo cask catimg celery chruby chucknorris cloudapp cloudfoundry codeclimate coffee colemak colored-man-pages colorize command-not-found common-aliases compleat composer copybuffer copydir copyfile cp cpanm dash debian dircycle dirhistory dirpersist django dnf dnote docker docker-compose docker-machine doctl dotenv droplr drush eecms emacs ember-cli emoji emoji-clock emotty encode64 extract fabric fancy-ctrl-z fasd fastfile fbterm fd fedora firewalld forklift fossil frontend-search fzf gas gatsby gb geeknote gem git git-auto-fetch git-escape-magic git-extras gitfast git-flow git-flow-avh github git-hubflow gitignore git-prompt git-remote-branch glassfish globalias gnu-utils go golang gpg-agent gradle grails grunt gulp hanami helm heroku history history-substring-search homestead httpie iterm2 jake-node jenv jhbuild jira jruby jsontools jump kate keychain kitchen knife knife_ssh kops kubectl kube-ps1 laravel laravel4 laravel5 last-working-dir lein lighthouse lol macports magic-enter man marked2 mercurial meteor minikube mix mix-fast mosh mvn mysql-macports n98-magerun nanoc ng nmap node nomad npm npx nvm nyan oc osx otp pass paver pep8 percol per-directory-history perl perms phing pip pipenv pj please pod postgres pow powder powify profiles pyenv pylint python rails rake rake-fast rand-quote rbenv rbfu react-native rebar redis-cli repo ripgrep ros rsync ruby rust rvm safe-paste salt sbt scala scd screen scw sdk sfdx sfffe shrink-path singlechar spring sprunge ssh-agent stack sublime sudo supervisor suse svcat svn svn-fast-info swiftpm symfony symfony2 systemadmin systemd taskwarrior terminalapp terminitor terraform textastic textmate thefuck themes thor tig timer tmux tmux-cssh tmuxinator torrent transfer tugboat ubuntu ufw urltools vagrant vagrant-prompt vault vim-interaction vi-mode virtualenv virtualenvwrapper vscode vundle wakeonlan wd web-search wp-cli xcode yarn yii yii2 yum z zeus zsh-navigation-tools zsh_reload )
IUSE+=" ${OMZSH_PLUGINS[@]/#/-plugins_}"

RDEPEND="app-shells/zsh
	 clipboard? ( x11-misc/xclip )
	 git? ( dev-vcs/git )
         powerline? ( media-fonts/powerline-symbols )
	 plugins_autojump? ( app-shells/autojump )
	 plugins_bundler? ( dev-ruby/bundler )
	 plugins_cargo? ( dev-util/cargo )
	 plugins_colorize? ( dev-python/pygments )
	 plugins_chucknorris? ( games-misc/fortune-mod )
	 plugins_emacs? ( >=app-editors/emacs-24.0 )
	 plugins_sfffe? ( sys-apps/ack )
	 plugins_thefuck? ( app-shells/thefuck )
	 plugins_tmux? ( app-misc/tmux )
	 plugins_percol? ( app-shells/percol )
	 plugins_perl? ( dev-lang/perl )
	 plugins_pipenv? ( dev-python/pipenv )
	 plugins_vim-interaction? ( app-editors/gvim )
	 plugins_virtualenvwrapper? ( dev-python/virtualenvwrapper )
	 plugins_vundle? ( app-editors/vim )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"
REQUIRED_USE="branding? ( themes_gentoo ) themes_agnoster? ( powerline ) themes_emotty? ( powerline ) themes_amuse? ( powerline )
	      plugins_git? ( git )
	      plugins_github? ( git )
	      plugins_git-auto-fetch? ( git )
	      plugins_git-extras? ( git )
	      plugins_gitfast? ( git )
	      plugins_git-hubflow? ( git )
	      plugins_git-prompt? ( git )
	      plugins_git-remote-branch? ( git )
	      plugins_git-flow? ( git )
	      git? ( || ( plugins_git plugins_github plugins_git-auto-fetch plugins_git-extras plugins_gitfast plugins_git-hubflow plugins_git-prompt plugins_git-remote-branch plugins_git-flow ) )
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
