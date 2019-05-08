# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="A delightful community-driven framework for managing your zsh configuration that includes optional plugins and themes."
HOMEPAGE="http://ohmyz.sh/"
COMMIT="ea3e666e04bfae31b37ef42dfe54801484341e46"
SRC_URI="https://github.com/robbyrussell/oh-my-zsh/archive/${COMMIT}.zip -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="branding powerline"
OMZSH_THEMES=( 3den adben af-magic afowler agnoster alanpeabody amuse apple arrow aussiegeek avit awesomepanda bira blinks bureau candy candy-kingdom clean cloud crcandy crunch cypher dallas darkblood daveverwer dieter dogenpunk dpoggi dst dstufft duellj eastwood edvardm emotty essembeh evan fino fino-time fishy flazz fletcherm fox frisk frontcube funky fwalch gallifrey gallois garyblessington gentoo geoffgarside gianu gnzh gozilla half-life humza imajes intheloop itchy jaischeema jbergantine jispwoso jnrowe jonathan josh jreese jtriley juanghurtado junkfood kafeitu kardan kennethreitz kiwi kolo kphoen lambda linuxonly lukerandall macovsky macovsky-ruby maran mgutz mh michelebologna mikeh miloshadzic minimal mira mortalscumbag mrtazz murilasso muse nanotech nebirhos nicoulaj norm obraun peepcode philips pmcgee pygmalion pygmalion-virtualenv re5et refined rgm risto rixius rkj rkj-repos robbyrussell sammy simonoff simple skaro smt Soliah sonicradish sorin sporty_256 steeef strug sunaku sunrise superjarin suvash takashiyoshida terminalparty theunraveler tjkirch tjkirch_mod tonotdo trapd00r wedisagree wezm wezm+ wuffers xiong-chiamiov xiong-chiamiov-plus ys zhann )
IUSE+=" ${OMZSH_THEMES[@]/#/-themes_}"
OMZSH_PLUGINS=( adb ansible ant apache2-macports arcanist archlinux asdf autoenv autojump autopep8 aws battery bbedit bgnotify boot2docker bower branch brew bundler bwana cabal cake cakephp3 capistrano cargo cask catimg celery chruby chucknorris cloudapp cloudfoundry codeclimate coffee colemak colored-man-pages colorize command-not-found common-aliases compleat composer copybuffer copydir copyfile cp cpanm dash debian dircycle dirhistory dirpersist django dnf docker docker-compose docker-machine doctl dotenv droplr drush eecms emacs ember-cli emoji emoji-clock emotty encode64 extract fabric fancy-ctrl-z fasd fastfile fbterm fd fedora firewalld forklift fossil frontend-search fzf gas gb geeknote gem git git-auto-fetch git-extras gitfast git-flow git-flow-avh github git-hubflow gitignore git-prompt git-remote-branch glassfish globalias gnu-utils go golang gpg-agent gradle grails grunt gulp hanami helm heroku history history-substring-search homestead httpie iterm2 iwhois jake-node jenv jhbuild jira jruby jsontools jump kate keychain kitchen knife knife_ssh kops kubectl kube-ps1 laravel laravel4 laravel5 last-working-dir lein lighthouse lol macports magic-enter man marked2 mercurial meteor minikube mix mix-fast mosh mvn mysql-macports n98-magerun nanoc ng nmap node nomad npm npx nvm nyan oc osx otp pass paver pep8 percol per-directory-history perl perms phing pip pj pod postgres pow powder powify profiles pyenv pylint python rails rake rake-fast rand-quote rbenv rbfu react-native rebar redis-cli repo ripgrep ros rsync ruby rust rvm safe-paste salt sbt scala scd screen scw sfdx sfffe shrink-path singlechar spring sprunge ssh-agent stack sublime sudo supervisor suse svcat svn svn-fast-info swiftpm symfony symfony2 systemadmin systemd taskwarrior terminalapp terminitor terraform textastic textmate thefuck themes thor tig timer tmux tmux-cssh tmuxinator torrent transfer tugboat ubuntu ufw urltools vagrant vagrant-prompt vault vim-interaction vi-mode virtualenv virtualenvwrapper vscode vundle wakeonlan wd web-search wp-cli xcode yarn yii yii2 yum z zeus zsh-navigation-tools zsh_reload )
IUSE+=" ${OMZSH_PLUGINS[@]/#/-plugins_}"

RDEPEND="app-shells/zsh
         powerline? ( media-fonts/powerline-symbols )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}-${COMMIT}"
REQUIRED_USE="branding? ( themes_gentoo ) themes_agnoster? ( powerline ) themes_emotty? ( powerline ) themes_amuse? ( powerline )"

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
