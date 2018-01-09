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
OMZSH_THEMES=( 3den adben af-magic afowler agnoster alanpeabody amuse apple arrow aussiegeek avit awesomepanda bira blinks bureau candy-kingdom candy clean cloud crcandy crunch cypher dallas darkblood daveverwer dieter dogenpunk dpoggi dstufft dst duellj eastwood edvardm emotty essembeh evan example fino-time fino fishy flazz fletcherm fox frisk frontcube funky fwalch gallifrey gallois garyblessington gentoo geoffgarside gianu gnzh gozilla half-life humza imajes intheloop itchy jaischeema jbergantine jispwoso jnrowe jonathan josh jreese jtriley juanghurtado junkfood kafeitu kardan kennethreitz kiwi kolo kphoen lambda linuxonly lukerandall macovsky-ruby macovsky maran mgutz mh michelebologna mikeh miloshadzic minimal mira mortalscumbag mrtazz murilasso muse nanotech nebirhos nicoulaj norm obraun peepcode philips pmcgee pure pygmalion re5et refined rgm risto rixius rkj-repos rkj robbyrussell sammy simonoff simple skaro smt Soliah sonicradish sorin sporty_256 steeef strug sunaku sunrise superjarin suvash takashiyoshida terminalparty theunraveler tjkirch_mod tjkirch tonotdo trapd00r wedisagree wezm wezm+ wuffers xiong-chiamiov-plus xiong-chiamiov ys zhann )
IUSE+=" ${OMZSH_THEMES[@]/#/+themes_}"
OMZSH_PLUGINS=( adb ant apache2-macports arcanist archlinux asdf autoenv autojump autopep8 aws battery bbedit bgnotify boot2docker bower branch brew bundler bwana cabal cake cakephp3 capistrano cargo cask catimg celery chruby chucknorris cloudapp codeclimate coffee colemak colored-man-pages colorize command-not-found common-aliases compleat composer copybuffer copydir copyfile cp cpanm debian dircycle dirhistory dirpersist django dnf docker docker-compose docker-machine dotenv droplr emacs ember-cli emoji emoji-clock emotty encode64 extract fabric fancy-ctrl-z fasd fastfile fbterm fedora firewalld forklift fossil frontend-search gas gb geeknote gem git git-extras gitfast git-flow git-flow-avh github git-hubflow gitignore git-prompt git-remote-branch glassfish globalias gnu-utils go golang gpg-agent gradle grails grunt gulp helm heroku history history-substring-search httpie iterm2 iwhois jake-node jhbuild jira jruby jsontools jump kate kitchen knife knife_ssh kops kubectl laravel laravel4 laravel5 last-working-dir lein lighthouse lol macports man marked2 mercurial meteor mix mix-fast mosh mvn mysql-macports n98-magerun nanoc ng nmap node nomad npm npx nvm nyan oc osx pass paver pep8 per-directory-history perl perms phing pip pj pod postgres pow powder powify profiles pyenv pylint python rails rake rake-fast rand-quote rbenv rbfu react-native rebar redis-cli repo rsync ruby rust rvm safe-paste sbt scala scd screen scw sfffe shrink-path singlechar spring sprunge ssh-agent stack sublime sudo supervisor suse svn svn-fast-info swiftpm symfony symfony2 systemadmin systemd taskwarrior terminalapp terminitor terraform textastic textmate thefuck themes thor tig tmux tmux-cssh tmuxinator torrent tugboat ubuntu urltools vagrant vault vim-interaction vi-mode virtualenv virtualenvwrapper vundle wakeonlan wd web-search wp-cli xcode yarn yii yii2 yum z zeus zsh-navigation-tools zsh_reload )
IUSE+=" ${OMZSH_PLUGINS[@]/#/+plugins_}"

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

	REQ_THEMES=$(echo "$PKGUSE" | grep -o -P "themes_[^ ]+")
	mv themes themes.trash
	mkdir themes
	for theme in ${REQ_THEMES} ; do
		theme=${theme//themes_/}
		TRASH="themes.trash"
		if [ -f ${TRASH}/${theme}.zsh-theme ] ; then
			einfo "Keeping ${theme}..."
			cp -a ${TRASH}/${theme}.zsh-theme themes/ || die #for some reason mv doesn't work as expected
		else
			eerror "${theme} doesn't exist"
			die
		fi
	done

	REQ_PLUGINS=$(echo "$PKGUSE" | grep -o -P "plugins_[^ ]+")
	mv plugins plugins.trash
	mkdir plugins
	for plugin in ${REQ_PLUGINS} ; do
		plugin=${plugin//plugins_/}
		TRASH="plugins.trash"
		if [ -d ${TRASH}/${plugin} ] ; then
			einfo "Keeping ${plugin}..."
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
