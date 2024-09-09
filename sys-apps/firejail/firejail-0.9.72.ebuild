# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

DOTTED_FILENAMES=(
blender-2.8
chromium-common-hardened.inc
com.github.bleakgrey.tootle
com.github.dahenson.agenda
com.github.johnfactotum.Foliate
com.github.phase1geo.minder
com.github.tchx84.Flatseal
com.gitlab.newsflash
display-im6.q16
feh-network.inc
gimp-2.10
gimp-2.8
idea.sh
io.github.lainsce.Notejot
mpg123.bin
openoffice.org
org.gnome.NautilusPreviewer
ping-hardened.inc
runenpass.sh
start-tor-browser.desktop
studio.sh
ts3client_runscript.sh
electron-hardened.inc
)
# This is done for modular install.
FIREJAIL_MAX_ENVS=${FIREJAIL_MAX_ENVS:-512}
FIREJAIL_PROFILES=(
0ad 1password 2048-qt 7z 7za 7zr Books Builder Cheese Cryptocat Cyberfox
Discord DiscordCanary Documents FossaMail Fritzing Gitter JDownloader Logs
Maelstrom Maps Mathematica Natron PCSX2 PPSSPPQt PPSSPPSDL QMediathekView
QOwnNotes Screenshot Telegram Thunar Viber VirtualBox XMind Xephyr Xvfb
ZeGrapher abiword abrowser acat adiff agetpkg akonadi_control akregator
alacarte alienarena alienarena-wrapper alpine alpinef als amarok amule amuled
android-studio anki anydesk aosp apack apktool apostrophe ar arch-audit
archaudit-report archiver-common ardour4 ardour5 arduino arepack aria2c ark arm
artha assogiate asunder atom atom-beta atool atril atril-previewer
atril-thumbnailer audacious audacity audio-recorder aunpack authenticator
authenticator-rs autokey-common autokey-gtk autokey-qt autokey-run
autokey-shell avidemux avidemux3_cli avidemux3_jobs_qt5 avidemux3_qt5 aweather
awesome b2sum ballbuster ballbuster-wrapper baloo_file
baloo_filemetadata_temp_extractor balsa baobab barrier basilisk bcompare beaker
bibletime bibtex bijiben bitcoin-qt bitlbee bitwarden blackbox bleachbit
blender blender-2_8 bless blobby blobwars bluefish bnox brackets brasero brave
brave-browser brave-browser-beta brave-browser-dev brave-browser-nightly
brave-browser-stable bsdcat bsdcpio bsdtar build-systems-common bundle bunzip2
bzcat bzflag bzip2 cachy-browser caja calibre calligra calligraauthor
calligraconverter calligraflow calligragemini calligraplan calligraplanwork
calligrasheets calligrastage calligrawords cameramonitor cantata cargo catfish
cawbird celluloid chafa chatterino checkbashisms cheese cherrytree chromium
chromium-browser chromium-browser-privacy chromium-common
chromium-common-hardened_inc chromium-freeworld cin cinelerra cinelerra-gg
cksum clamav clamdscan clamdtop clamscan clamtk claws-mail clawsker clementine
clion clion-eap clipgrab clipit cliqz clocks cmake cmus code code-oss codium
cointop cola colorful colorful-wrapper com_github_bleakgrey_tootle
com_github_dahenson_agenda com_github_johnfactotum_Foliate
com_github_phase1geo_minder com_github_tchx84_Flatseal com_gitlab_newsflash
conkeror conky conplay corebird cower coyim cpio crawl crawl-tiles crow
cryptocat curl cvlc cyberfox d-feet darktable dbus-send dconf dconf-editor ddgr
ddgtk deadbeef default deluge desktopeditors devhelp devilspie devilspie2
dex2jar dia dig digikam dillo dino dino-im discord discord-canary
discord-common display display-im6_q16 dnox dnscrypt-proxy dnsmasq dolphin
dolphin-emu dooble dooble-qt4 dosbox dragon drawio drill dropbox easystroke
ebook-convert ebook-edit ebook-meta ebook-polish ebook-viewer electron
electron-hardened_inc electron-mail electrum element-desktop elinks emacs
email-common empathy enchant enchant-2 enchant-lsmod enchant-lsmod-2 engrampa
enox enpass eo-common eog eom ephemeral epiphany equalx et etr etr-wrapper
evince evince-previewer evince-thumbnailer evolution exfalso exiftool falkon
fbreader fdns feedreader feh feh-network_inc ferdi fetchmail ffmpeg
ffmpegthumbnailer ffplay ffprobe file file-manager-common file-roller filezilla
firedragon firefox firefox-beta firefox-common firefox-common-addons
firefox-developer-edition firefox-esr firefox-nightly firefox-wayland
firefox-x11 five-or-more flacsplt flameshot flashpeak-slimjet flowblade fluxbox
font-manager fontforge fossamail four-in-a-row fractal franz freecad freecadcmd
freeciv freeciv-gtk3 freeciv-mp-gtk3 freecol freemind freeoffice-planmaker
freeoffice-presentations freeoffice-textmaker freetube freshclam frogatto
frozen-bubble ftp funnyboat gajim gajim-history-manager galculator gallery-dl
gapplication gcalccmd gcloud gconf gconf-editor gconf-merge-schema
gconf-merge-tree gconfpkg gconftool-2 gdu geany geary gedit geekbench geeqie
gfeeds gget ghb ghostwriter gimp gimp-2_10 gimp-2_8 gist gist-paste git
git-cola gitg github-desktop gitter gjs gl-117 gl-117-wrapper glaxium
glaxium-wrapper globaltime gmpc gnome-2048 gnome-books gnome-builder
gnome-calculator gnome-calendar gnome-character-map gnome-characters
gnome-chess gnome-clocks gnome-contacts gnome-documents gnome-font-viewer
gnome-hexgl gnome-keyring gnome-keyring-3 gnome-klotski gnome-latex gnome-logs
gnome-mahjongg gnome-maps gnome-mines gnome-mplayer gnome-mpv gnome-music
gnome-nettool gnome-nibbles gnome-passwordsafe gnome-photos gnome-pie
gnome-pomodoro gnome-recipes gnome-ring gnome-robots gnome-schedule
gnome-screenshot gnome-sound-recorder gnome-sudoku gnome-system-log
gnome-taquin gnome-tetravex gnome-todo gnome-twitch gnome-weather
gnome_games-common gnote gnubik godot godot3 goldendict goobox google-chrome
google-chrome-beta google-chrome-stable google-chrome-unstable google-earth
google-earth-pro google-play-music-desktop-player googler googler-common gpa
gpg gpg-agent gpg2 gpicview gpredict gradio gramps
gravity-beams-and-evaporating-stars gsettings gsettings-data-convert
gsettings-schema-convert gtar gthumb gtk-lbry-viewer gtk-pipe-viewer
gtk-straw-viewer gtk-update-icon-cache gtk-youtube-viewer gtk2-youtube-viewer
gtk3-youtube-viewer guayadeque gucharmap gummi gunzip guvcview gwenview gzexe
gzip handbrake handbrake-gtk hashcat hasher-common hedgewars hexchat highlight
hitori homebank host hugin hyperrogue i2prouter i3 iagno icecat icedove
iceweasel idea ideaIC idea_sh imagej img2txt impressive imv inkscape inkview
inox io_github_lainsce_Notejot ipcalc ipcalc-ng iridium iridium-browser itch
jami-gnome jd-gui jdownloader jerry jitsi jitsi-meet-desktop jumpnbump
jumpnbump-menu k3b kaffeine kalgebra kalgebramobile karbon kate kazam kcalc
kdeinit4 kdenlive kdiff3 keepass keepass2 keepassx keepassx2 keepassxc
keepassxc-cli keepassxc-proxy kfind kget kid3 kid3-cli kid3-qt kino
kiwix-desktop klatexformula klatexformula_cmdl klavaro kmail kmplayer knotes
kodi konversation kopete krita krunner ktorrent ktouch kube kwin_x11 kwrite
latex latex-common lbry-viewer lbunzip2 lbzcat lbzip2 leafpad less librecad
libreoffice librewolf librewolf-nightly lifeograph liferea lightsoff lincity-ng
links links-common links2 linphone linuxqq lmms lobase localc lodraw loffice
lofromtemplate loimpress lollypop lomath loweb lowriter lrunzip lrz lrzcat
lrzip lrztar lrzuntar lsar lugaru luminance-hdr lutris lximage-qt lxmusic lynx
lyx lzcat lzcmp lzdiff lzegrep lzfgrep lzgrep lzip lzless lzma lzmadec lzmainfo
lzmore lzop macrofusion magicor make makedeb makepkg man manaplus marker
masterpdfeditor masterpdfeditor4 masterpdfeditor5 mate-calc mate-calculator
mate-color-select mate-dictionary mathematica matrix-mirage mattermost-desktop
mcabber mcomix md5sum mdr mediainfo mediathekview megaglest megaglest_editor
meld mencoder mendeleydesktop menulibre meson meteo-qt microsoft-edge
microsoft-edge-beta microsoft-edge-dev midori min mindless minecraft-launcher
minetest minitube mirage mirrormagic mocp mousepad mp3splt mp3splt-gtk mp3wrap
mpDris2 mpd mpg123 mpg123-alsa mpg123-id3dump mpg123-jack mpg123-nas
mpg123-openal mpg123-oss mpg123-portaudio mpg123-pulse mpg123-strip mpg123_bin
mplayer mpsyt mpv mrrescue ms-excel ms-office ms-onenote ms-outlook
ms-powerpoint ms-skype ms-word mtpaint multimc multimc5 mumble mupdf mupdf-gl
mupdf-x11 mupdf-x11-curl mupen64plus muraster musescore musictube musixmatch
mutool mutt mypaint mypaint-ora-thumbnailer nano natron nautilus ncdu ncdu2
nemo neochat neomutt netactview nethack nethack-vultures netsurf neverball
neverball-wrapper neverputt neverputt-wrapper newsbeuter newsboat newsflash
nextcloud nextcloud-desktop nheko nicotine nitroshare nitroshare-cli
nitroshare-nmh nitroshare-send nitroshare-ui node node-gyp nodejs-common nomacs
noprofile notable notify-send npm npx nslookup nuclear nvim nylas nyx obs
ocenaudio odt2txt oggsplt okular onboard onionshare onionshare-cli
onionshare-gui ooffice ooviewdoc open-invaders openarena openarena_ded openbox
opencity openclonk openmw openmw-launcher openoffice_org openshot openshot-qt
openstego openttd opera opera-beta opera-developer orage
org_gnome_NautilusPreviewer ostrichriders otter-browser out123 p7zip palemoon
pandoc parole patch pavucontrol pavucontrol-qt pcmanfm pcsxr pdfchain pdflatex
pdfmod pdfsam pdftotext peek penguin-command photoflare picard pidgin pinball
pinball-wrapper ping ping-hardened_inc pingus pinta pioneer pip pipe-viewer
pithos pitivi pix pkglog planmaker18 planmaker18free playonlinux pluma plv
pngquant polari ppsspp pragha presentations18 presentations18free profanity psi
psi-plus pybitmessage pycharm-community pycharm-professional pzstd qbittorrent
qcomicbook qemu-launcher qemu-system-x86_64 qgis qlipper qmmp qnapi qpdfview qq
qrencode qt-faststart qtox quadrapassel quassel quaternion quiterss quodlibet
qupzilla qutebrowser raincat rambox ranger redeclipse rednotebook redshift
regextester remmina retroarch rhythmbox rhythmbox-client ricochet riot-desktop
riot-web ripperx ristretto rnano rocketchat rpcs3 rsync-download_only rtin
rtorrent rtv rtv-addons runenpass_sh rview rvim sayonara scallion scorched3d
scorched3d-wrapper scorchwentbonkers scp scribus sdat2img seafile-applet
seahorse seahorse-adventures seahorse-daemon seahorse-tool seamonkey
seamonkey-bin secret-tool semver server servo sftp sha1sum sha224sum sha256sum
sha384sum sha512sum shellcheck shortwave shotcut shotwell signal-cli
signal-desktop silentarmy simple-scan simplescreenrecorder simutrans skanlite
skypeforlinux slack slashem smplayer smtube smuxi-frontend-gnome snox soffice
softmaker-common sol songrec sound-juicer soundconverter spectacle spectral
spectre-meltdown-checker spotify sqlitebrowser ssh ssh-agent ssmtp
standardnotes-desktop start-tor-browser start-tor-browser_desktop steam
steam-native steam-runtime stellarium straw-viewer strawberry strings studio_sh
subdownloader sum supertux2 supertuxkart supertuxkart-wrapper surf sushi sway
swell-foop sylpheed synfigstudio sysprof sysprof-cli tar tb-starter-wrapper
tcpdump teams teams-for-linux teamspeak3 teeworlds telegram telegram-desktop
telnet terasology tesseract tex textmaker18 textmaker18free thunar thunderbird
thunderbird-beta thunderbird-wayland tilp tin tmux tor tor-browser
tor-browser-ar tor-browser-ca tor-browser-cs tor-browser-da tor-browser-de
tor-browser-el tor-browser-en tor-browser-en-us tor-browser-es
tor-browser-es-es tor-browser-fa tor-browser-fr tor-browser-ga-ie
tor-browser-he tor-browser-hu tor-browser-id tor-browser-is tor-browser-it
tor-browser-ja tor-browser-ka tor-browser-ko tor-browser-nb tor-browser-nl
tor-browser-pl tor-browser-pt-br tor-browser-ru tor-browser-sv-se
tor-browser-tr tor-browser-vi tor-browser-zh-cn tor-browser-zh-tw
tor-browser_ar tor-browser_ca tor-browser_cs tor-browser_da tor-browser_de
tor-browser_el tor-browser_en tor-browser_en-US tor-browser_es
tor-browser_es-ES tor-browser_fa tor-browser_fr tor-browser_ga-IE
tor-browser_he tor-browser_hu tor-browser_id tor-browser_is tor-browser_it
tor-browser_ja tor-browser_ka tor-browser_ko tor-browser_nb tor-browser_nl
tor-browser_pl tor-browser_pt-BR tor-browser_ru tor-browser_sv-SE
tor-browser_tr tor-browser_vi tor-browser_zh-CN tor-browser_zh-TW torbrowser
torbrowser-launcher torcs totem tracker transgui transmission-cli
transmission-common transmission-create transmission-daemon transmission-edit
transmission-gtk transmission-qt transmission-remote transmission-remote-cli
transmission-remote-gtk transmission-show tremulous trojita truecraft
ts3client_runscript_sh tshark tuir tutanota-desktop tuxguitar tvbrowser twitch
udiskie uefitool uget-gtk unar unbound uncompress unf unknown-horizons unlzma
unrar unxz unzip unzstd utox uudeview uzbl-browser viewnior viking vim vimcat
vimdiff vimpager vimtutor virtualbox vivaldi vivaldi-beta vivaldi-snapshot
vivaldi-stable vlc vmware vmware-player vmware-view vmware-workstation vscodium
vulturesclaw vultureseye vym w3m warmux warsow warzone2100 waterfox
waterfox-classic waterfox-current webstorm webui-aria2 weechat weechat-curses
wesnoth wget wget2 whalebird whois widelands wine wire-desktop wireshark
wireshark-gtk wireshark-qt wordwarvi wpp wps wpspdf x-terminal-emulator
x2goclient xbill xcalc xchat xed xfburn xfce4-dict xfce4-mixer xfce4-notes
xfce4-screenshooter xiphos xlinks xlinks2 xmms xmr-stak xonotic xonotic-glx
xonotic-sdl xonotic-sdl-wrapper xournal xournalpp xpdf xplayer
xplayer-audio-preview xplayer-video-thumbnailer xpra xreader xreader-previewer
xreader-thumbnailer xviewer xxd xz xzcat xzcmp xzdec xzdiff xzegrep xzfgrep
xzgrep xzless xzmore yandex-browser yarn yelp youtube youtube-dl youtube-dl-gui
youtube-viewer youtube-viewers-common youtubemusic-nativefier yt-dlp ytmdesktop
zaproxy zart zathura zcat zcmp zdiff zeal zegrep zfgrep zforce zgrep zim zless
zmore znew zoom zpaq zstd zstdcat zstdgrep zstdless zstdmt zulip
)
FIREJAIL_PROFILES_IUSE="${FIREJAIL_PROFILES[@]/#/firejail_profiles_}"
#GEN_EBUILD=1 # Uncomment to regen ebuild parts
LLVM_COMPAT=( {18..14} )
PYTHON_COMPAT=( python3_{9..12} )
TEST_SET="distro" # distro or full
X11_COMPAT=(
1password 2048-qt Books Builder Documents Fritzing Logs Maps PCSX2
QMediathekView Screenshot Viber abiword akregator alacarte alienarena
alienarena-wrapper alpine amarok anki apostrophe ark artha
assogiate atom atril audacious audacity authenticator-rs autokey-gtk autokey-qt
avidemux avidemux3_jobs_qt5 avidemux3_qt5 ballbuster-wrapper baloo_file balsa
beaker bijiben bitcoin-qt bitwarden blobby bnox brasero brave brave-browser
cachy-browser calligra cantata cawbird celluloid chatterino cheese chromium
chromium-browser chromium-browser-privacy chromium-freeworld clamtk claws-mail
clawsker clementine clocks code colorful-wrapper com_github_bleakgrey_tootle
com_github_dahenson_agenda com_github_johnfactotum_Foliate
com_github_phase1geo_minder com_github_tchx84_Flatseal crow dconf dconf-editor
ddgtk deluge devhelp digikam dillo dnox dolphin-emu dooble dooble-qt4
electron-mail electrum enox eog ephemeral equalx etr etr-wrapper
evince evince-previewer evince-thumbnailer exfalso falkon feedreader ffmpeg
file-roller firefox five-or-more flameshot flashpeak-slimjet
four-in-a-row fractal freeciv freeciv-gtk3 freeciv-mp-gtk3 freetube
frozen-bubble gajim gapplication gcalccmd geary gedit gfeeds
ghostwriter gimp git-cola gitg github-desktop gjs gl-117 gl-117-wrapper glaxium
glaxium-wrapper gnome-2048 gnome-books gnome-builder
gnome-calculator gnome-calendar gnome-character-map gnome-characters
gnome-chess gnome-clocks gnome-contacts gnome-documents gnome-font-viewer
gnome-hexgl gnome-keyring gnome-keyring-3 gnome-klotski
gnome-latex gnome-logs gnome-mahjongg gnome-maps gnome-mines gnome-mplayer
gnome-mpv gnome-music gnome-nettool gnome-nibbles gnome-passwordsafe
gnome-photos gnome-pie gnome-pomodoro gnome-recipes gnome-ring gnome-robots
gnome-schedule gnome-screenshot gnome-sound-recorder gnome-sudoku
gnome-system-log gnome-taquin gnome-tetravex gnome-todo gnome-twitch
gnome-weather gnote gnubik godot google-chrome google-chrome-beta
google-chrome-unstable gradio gramps gtk-lbry-viewer
gtk-pipe-viewer gtk-straw-viewer gtk-update-icon-cache gtk-youtube-viewer
gtk2-youtube-viewer gtk3-youtube-viewer gucharmap guvcview gwenview
handbrake-gtk hitori homebank i2prouter iagno impressive inkscape inox
io_github_lainsce_Notejot iridium jami-gnome jerry jitsi-meet-desktop
k3b kaffeine kate kazam kcalc kdeinit4 kdenlive kdiff3 keepassxc
kfind kget kid3 kid3-qt klatexformula kmplayer konversation kopete krunner
ktorrent ktouch kube kwin_x11 kwrite
libreoffice librewolf lifeograph lightsoff linuxqq
lollypop lximage-qt lyx man marker mate-calc mattermost-desktop mcomix
menulibre meteo-qt microsoft-edge microsoft-edge-beta
microsoft-edge-dev midori min minecraft-launcher minitube mirage mp3splt-gtk
musictube mutt mypaint nautilus neochat neomutt neverball-wrapper
neverputt-wrapper newsflash nextcloud nheko nitroshare nomacs notable nuclear
ocenaudio okular onboard onionshare-gui open-invaders openarena openmw openshot
openshot-qt opera opera-beta opera-developer org_gnome_NautilusPreviewer
otter-browser pavucontrol pavucontrol-qt pcmanfm pcsxr pdfchain peek photoflare
pinball-wrapper ppsspp pragha psi pybitmessage
qcomicbook qgis qt-faststart qtox quadrapassel quaternion quodlibet
qutebrowser raincat rambox rednotebook rhythmbox riot-web rocketchat
rtv scorched3d-wrapper scribus seahorse seamonkey secret-tool
shortwave shotwell signal-desktop simutrans skanlite
skypeforlinux slack smuxi-frontend-gnome snox spectacle spectral
standardnotes-desktop steam supertuxkart supertuxkart-wrapper swell-foop
sylpheed sysprof teams teams-for-linux telegram terasology thunar thunderbird
totem transgui transmission-gtk transmission-qt
transmission-remote-gtk trojita tutanota-desktop twitch
udiskie uget-gtk unzip uzbl-browser virtualbox vivaldi vlc vmware
vmware-player vmware-view warzone2100 whalebird wire-desktop wireshark
wireshark-gtk wireshark-qt x2goclient xfce4-notes xfce4-screenshooter xmms
xonotic xonotic-sdl xonotic-sdl-wrapper yandex-browser yelp youtube
youtube-dl-gui youtubemusic-nativefier ytmdesktop zathura
zeal zim zoom

hexchat
obs
pidgin
pitivi
qbittorrent
xchat
)

inherit flag-o-matic linux-info python-single-r1 toolchain-funcs virtualx

gen_clang_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
		(
			sys-devel/clang:${s}
			sys-devel/llvm:${s}
		)
		"
	done
}

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	IUSE+=" fallback-commit"
else
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
	SRC_URI="https://github.com/netblue30/${PN}/releases/download/${PV}/${P}.tar.xz"
fi

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"
LICENSE="GPL-2"
SLOT="0"
IUSE+="
${FIREJAIL_PROFILES_IUSE[@]}
apparmor +chroot contrib +dbusproxy +file-transfer +firejail_profiles_default
+firejail_profiles_server +globalcfg +network +private-home selinux +suid
test-profiles test-x11 +userns vanilla wrapper X xpra xvfb
ebuild-revision-1
"
RDEPEND+="
	!sys-apps/firejail-lts
	apparmor? (
		>=sys-libs/libapparmor-2.13.3
	)
	contrib? (
		${PYTHON_DEPS}
	)
	dbusproxy? (
		>=sys-apps/xdg-dbus-proxy-0.1.2
	)
	selinux? (
		>=sys-libs/libselinux-8.1.0
	)
	X? (
		x11-base/xorg-server[xvfb?]
	)
	xpra? (
		x11-base/xorg-server
		>=x11-wm/xpra-3.0.6[firejail]
	)
"
DEPEND+="
	${RDEPEND}
	>=sys-libs/libseccomp-2.4.3
"
BDEPEND+="
	|| (
		>=sys-devel/gcc-12
		$(gen_clang_bdepend)
	)
	test? (
		>=app-arch/xz-utils-5.2.4
		>=dev-tcltk/expect-5.45.4
	)
	test-x11? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
"
GUI_REQUIRED_USE="
firejail_profiles_1password? ( || ( X xpra ) )
firejail_profiles_2048-qt? ( || ( X xpra ) )
firejail_profiles_Books? ( || ( X xpra ) )
firejail_profiles_Builder? ( || ( X xpra ) )
firejail_profiles_Documents? ( || ( X xpra ) )
firejail_profiles_Fritzing? ( || ( X xpra ) )
firejail_profiles_Logs? ( || ( X xpra ) )
firejail_profiles_Maps? ( || ( X xpra ) )
firejail_profiles_PCSX2? ( || ( X xpra ) )
firejail_profiles_QMediathekView? ( || ( X xpra ) )
firejail_profiles_Screenshot? ( || ( X xpra ) )
firejail_profiles_Viber? ( || ( X xpra ) )
firejail_profiles_abiword? ( || ( X xpra ) )
firejail_profiles_akregator? ( || ( X xpra ) )
firejail_profiles_alacarte? ( || ( X xpra ) )
firejail_profiles_alienarena? ( || ( X xpra ) )
firejail_profiles_alienarena-wrapper? ( || ( X xpra ) )
firejail_profiles_alpine? ( || ( X xpra ) )
firejail_profiles_amarok? ( || ( X xpra ) )
firejail_profiles_anki? ( || ( X xpra ) )
firejail_profiles_apostrophe? ( || ( X xpra ) )
firejail_profiles_ark? ( || ( X xpra ) )
firejail_profiles_artha? ( || ( X xpra ) )
firejail_profiles_assogiate? ( || ( X xpra ) )
firejail_profiles_atom? ( || ( X xpra ) )
firejail_profiles_atril? ( || ( X xpra ) )
firejail_profiles_audacious? ( || ( X xpra ) )
firejail_profiles_audacity? ( || ( X xpra ) )
firejail_profiles_authenticator-rs? ( || ( X xpra ) )
firejail_profiles_autokey-gtk? ( || ( X xpra ) )
firejail_profiles_autokey-qt? ( || ( X xpra ) )
firejail_profiles_avidemux? ( || ( X xpra ) )
firejail_profiles_avidemux3_jobs_qt5? ( || ( X xpra ) )
firejail_profiles_avidemux3_qt5? ( || ( X xpra ) )
firejail_profiles_ballbuster-wrapper? ( || ( X xpra ) )
firejail_profiles_baloo_file? ( || ( X xpra ) )
firejail_profiles_balsa? ( || ( X xpra ) )
firejail_profiles_beaker? ( || ( X xpra ) )
firejail_profiles_bijiben? ( || ( X xpra ) )
firejail_profiles_bitcoin-qt? ( || ( X xpra ) )
firejail_profiles_bitwarden? ( || ( X xpra ) )
firejail_profiles_blobby? ( || ( X xpra ) )
firejail_profiles_bnox? ( || ( X xpra ) )
firejail_profiles_brasero? ( || ( X xpra ) )
firejail_profiles_brave? ( || ( X xpra ) )
firejail_profiles_brave-browser? ( || ( X xpra ) )
firejail_profiles_cachy-browser? ( || ( X xpra ) )
firejail_profiles_calligra? ( || ( X xpra ) )
firejail_profiles_cantata? ( || ( X xpra ) )
firejail_profiles_cawbird? ( || ( X xpra ) )
firejail_profiles_celluloid? ( || ( X xpra ) )
firejail_profiles_chatterino? ( || ( X xpra ) )
firejail_profiles_cheese? ( || ( X xpra ) )
firejail_profiles_chromium? ( || ( X xpra ) )
firejail_profiles_chromium-browser? ( || ( X xpra ) )
firejail_profiles_chromium-browser-privacy? ( || ( X xpra ) )
firejail_profiles_chromium-freeworld? ( || ( X xpra ) )
firejail_profiles_clamtk? ( || ( X xpra ) )
firejail_profiles_claws-mail? ( || ( X xpra ) )
firejail_profiles_clawsker? ( || ( X xpra ) )
firejail_profiles_clementine? ( || ( X xpra ) )
firejail_profiles_clocks? ( || ( X xpra ) )
firejail_profiles_code? ( || ( X xpra ) )
firejail_profiles_colorful-wrapper? ( || ( X xpra ) )
firejail_profiles_com_github_bleakgrey_tootle? ( || ( X xpra ) )
firejail_profiles_com_github_dahenson_agenda? ( || ( X xpra ) )
firejail_profiles_com_github_johnfactotum_Foliate? ( || ( X xpra ) )
firejail_profiles_com_github_phase1geo_minder? ( || ( X xpra ) )
firejail_profiles_com_github_tchx84_Flatseal? ( || ( X xpra ) )
firejail_profiles_crow? ( || ( X xpra ) )
firejail_profiles_dconf? ( || ( X xpra ) )
firejail_profiles_dconf-editor? ( || ( X xpra ) )
firejail_profiles_ddgtk? ( || ( X xpra ) )
firejail_profiles_deluge? ( || ( X xpra ) )
firejail_profiles_devhelp? ( || ( X xpra ) )
firejail_profiles_digikam? ( || ( X xpra ) )
firejail_profiles_dillo? ( || ( X xpra ) )
firejail_profiles_dnox? ( || ( X xpra ) )
firejail_profiles_dolphin-emu? ( || ( X xpra ) )
firejail_profiles_dooble? ( || ( X xpra ) )
firejail_profiles_dooble-qt4? ( || ( X xpra ) )
firejail_profiles_electron-mail? ( || ( X xpra ) )
firejail_profiles_electrum? ( || ( X xpra ) )
firejail_profiles_enox? ( || ( X xpra ) )
firejail_profiles_eog? ( || ( X xpra ) )
firejail_profiles_ephemeral? ( || ( X xpra ) )
firejail_profiles_equalx? ( || ( X xpra ) )
firejail_profiles_etr? ( || ( X xpra ) )
firejail_profiles_etr-wrapper? ( || ( X xpra ) )
firejail_profiles_evince? ( || ( X xpra ) )
firejail_profiles_evince-previewer? ( || ( X xpra ) )
firejail_profiles_evince-thumbnailer? ( || ( X xpra ) )
firejail_profiles_exfalso? ( || ( X xpra ) )
firejail_profiles_falkon? ( || ( X xpra ) )
firejail_profiles_feedreader? ( || ( X xpra ) )
firejail_profiles_ffmpeg? ( || ( X xpra ) )
firejail_profiles_file-roller? ( || ( X xpra ) )
firejail_profiles_firefox? ( || ( X xpra ) )
firejail_profiles_five-or-more? ( || ( X xpra ) )
firejail_profiles_flameshot? ( || ( X xpra ) )
firejail_profiles_flashpeak-slimjet? ( || ( X xpra ) )
firejail_profiles_four-in-a-row? ( || ( X xpra ) )
firejail_profiles_fractal? ( || ( X xpra ) )
firejail_profiles_freeciv? ( || ( X xpra ) )
firejail_profiles_freeciv-gtk3? ( || ( X xpra ) )
firejail_profiles_freeciv-mp-gtk3? ( || ( X xpra ) )
firejail_profiles_freetube? ( || ( X xpra ) )
firejail_profiles_frozen-bubble? ( || ( X xpra ) )
firejail_profiles_gajim? ( || ( X xpra ) )
firejail_profiles_gapplication? ( || ( X xpra ) )
firejail_profiles_gcalccmd? ( || ( X xpra ) )
firejail_profiles_geary? ( || ( X xpra ) )
firejail_profiles_gedit? ( || ( X xpra ) )
firejail_profiles_gfeeds? ( || ( X xpra ) )
firejail_profiles_ghostwriter? ( || ( X xpra ) )
firejail_profiles_gimp? ( || ( X xpra ) )
firejail_profiles_git-cola? ( || ( X xpra ) )
firejail_profiles_gitg? ( || ( X xpra ) )
firejail_profiles_github-desktop? ( || ( X xpra ) )
firejail_profiles_gjs? ( || ( X xpra ) )
firejail_profiles_gl-117? ( || ( X xpra ) )
firejail_profiles_gl-117-wrapper? ( || ( X xpra ) )
firejail_profiles_glaxium? ( || ( X xpra ) )
firejail_profiles_glaxium-wrapper? ( || ( X xpra ) )
firejail_profiles_gnome-2048? ( || ( X xpra ) )
firejail_profiles_gnome-books? ( || ( X xpra ) )
firejail_profiles_gnome-builder? ( || ( X xpra ) )
firejail_profiles_gnome-calculator? ( || ( X xpra ) )
firejail_profiles_gnome-calendar? ( || ( X xpra ) )
firejail_profiles_gnome-character-map? ( || ( X xpra ) )
firejail_profiles_gnome-characters? ( || ( X xpra ) )
firejail_profiles_gnome-chess? ( || ( X xpra ) )
firejail_profiles_gnome-clocks? ( || ( X xpra ) )
firejail_profiles_gnome-contacts? ( || ( X xpra ) )
firejail_profiles_gnome-documents? ( || ( X xpra ) )
firejail_profiles_gnome-font-viewer? ( || ( X xpra ) )
firejail_profiles_gnome-hexgl? ( || ( X xpra ) )
firejail_profiles_gnome-keyring? ( || ( X xpra ) )
firejail_profiles_gnome-keyring-3? ( || ( X xpra ) )
firejail_profiles_gnome-klotski? ( || ( X xpra ) )
firejail_profiles_gnome-latex? ( || ( X xpra ) )
firejail_profiles_gnome-logs? ( || ( X xpra ) )
firejail_profiles_gnome-mahjongg? ( || ( X xpra ) )
firejail_profiles_gnome-maps? ( || ( X xpra ) )
firejail_profiles_gnome-mines? ( || ( X xpra ) )
firejail_profiles_gnome-mplayer? ( || ( X xpra ) )
firejail_profiles_gnome-mpv? ( || ( X xpra ) )
firejail_profiles_gnome-music? ( || ( X xpra ) )
firejail_profiles_gnome-nettool? ( || ( X xpra ) )
firejail_profiles_gnome-nibbles? ( || ( X xpra ) )
firejail_profiles_gnome-passwordsafe? ( || ( X xpra ) )
firejail_profiles_gnome-photos? ( || ( X xpra ) )
firejail_profiles_gnome-pie? ( || ( X xpra ) )
firejail_profiles_gnome-pomodoro? ( || ( X xpra ) )
firejail_profiles_gnome-recipes? ( || ( X xpra ) )
firejail_profiles_gnome-ring? ( || ( X xpra ) )
firejail_profiles_gnome-robots? ( || ( X xpra ) )
firejail_profiles_gnome-schedule? ( || ( X xpra ) )
firejail_profiles_gnome-screenshot? ( || ( X xpra ) )
firejail_profiles_gnome-sound-recorder? ( || ( X xpra ) )
firejail_profiles_gnome-sudoku? ( || ( X xpra ) )
firejail_profiles_gnome-system-log? ( || ( X xpra ) )
firejail_profiles_gnome-taquin? ( || ( X xpra ) )
firejail_profiles_gnome-tetravex? ( || ( X xpra ) )
firejail_profiles_gnome-todo? ( || ( X xpra ) )
firejail_profiles_gnome-twitch? ( || ( X xpra ) )
firejail_profiles_gnome-weather? ( || ( X xpra ) )
firejail_profiles_gnote? ( || ( X xpra ) )
firejail_profiles_gnubik? ( || ( X xpra ) )
firejail_profiles_godot? ( || ( X xpra ) )
firejail_profiles_google-chrome? ( || ( X xpra ) )
firejail_profiles_google-chrome-beta? ( || ( X xpra ) )
firejail_profiles_google-chrome-unstable? ( || ( X xpra ) )
firejail_profiles_gradio? ( || ( X xpra ) )
firejail_profiles_gramps? ( || ( X xpra ) )
firejail_profiles_gtk-lbry-viewer? ( || ( X xpra ) )
firejail_profiles_gtk-pipe-viewer? ( || ( X xpra ) )
firejail_profiles_gtk-straw-viewer? ( || ( X xpra ) )
firejail_profiles_gtk-update-icon-cache? ( || ( X xpra ) )
firejail_profiles_gtk-youtube-viewer? ( || ( X xpra ) )
firejail_profiles_gtk2-youtube-viewer? ( || ( X xpra ) )
firejail_profiles_gtk3-youtube-viewer? ( || ( X xpra ) )
firejail_profiles_gucharmap? ( || ( X xpra ) )
firejail_profiles_guvcview? ( || ( X xpra ) )
firejail_profiles_gwenview? ( || ( X xpra ) )
firejail_profiles_handbrake-gtk? ( || ( X xpra ) )
firejail_profiles_hitori? ( || ( X xpra ) )
firejail_profiles_homebank? ( || ( X xpra ) )
firejail_profiles_i2prouter? ( || ( X xpra ) )
firejail_profiles_iagno? ( || ( X xpra ) )
firejail_profiles_impressive? ( || ( X xpra ) )
firejail_profiles_inkscape? ( || ( X xpra ) )
firejail_profiles_inox? ( || ( X xpra ) )
firejail_profiles_io_github_lainsce_Notejot? ( || ( X xpra ) )
firejail_profiles_iridium? ( || ( X xpra ) )
firejail_profiles_jami-gnome? ( || ( X xpra ) )
firejail_profiles_jerry? ( || ( X xpra ) )
firejail_profiles_jitsi-meet-desktop? ( || ( X xpra ) )
firejail_profiles_k3b? ( || ( X xpra ) )
firejail_profiles_kaffeine? ( || ( X xpra ) )
firejail_profiles_kate? ( || ( X xpra ) )
firejail_profiles_kazam? ( || ( X xpra ) )
firejail_profiles_kcalc? ( || ( X xpra ) )
firejail_profiles_kdeinit4? ( || ( X xpra ) )
firejail_profiles_kdenlive? ( || ( X xpra ) )
firejail_profiles_kdiff3? ( || ( X xpra ) )
firejail_profiles_keepassxc? ( || ( X xpra ) )
firejail_profiles_kfind? ( || ( X xpra ) )
firejail_profiles_kget? ( || ( X xpra ) )
firejail_profiles_kid3? ( || ( X xpra ) )
firejail_profiles_kid3-qt? ( || ( X xpra ) )
firejail_profiles_klatexformula? ( || ( X xpra ) )
firejail_profiles_kmplayer? ( || ( X xpra ) )
firejail_profiles_konversation? ( || ( X xpra ) )
firejail_profiles_kopete? ( || ( X xpra ) )
firejail_profiles_krunner? ( || ( X xpra ) )
firejail_profiles_ktorrent? ( || ( X xpra ) )
firejail_profiles_ktouch? ( || ( X xpra ) )
firejail_profiles_kube? ( || ( X xpra ) )
firejail_profiles_kwin_x11? ( || ( X xpra ) )
firejail_profiles_kwrite? ( || ( X xpra ) )
firejail_profiles_libreoffice? ( || ( X xpra ) )
firejail_profiles_librewolf? ( || ( X xpra ) )
firejail_profiles_lifeograph? ( || ( X xpra ) )
firejail_profiles_lightsoff? ( || ( X xpra ) )
firejail_profiles_linuxqq? ( || ( X xpra ) )
firejail_profiles_lollypop? ( || ( X xpra ) )
firejail_profiles_lximage-qt? ( || ( X xpra ) )
firejail_profiles_lyx? ( || ( X xpra ) )
firejail_profiles_man? ( || ( X xpra ) )
firejail_profiles_marker? ( || ( X xpra ) )
firejail_profiles_mate-calc? ( || ( X xpra ) )
firejail_profiles_mattermost-desktop? ( || ( X xpra ) )
firejail_profiles_mcomix? ( || ( X xpra ) )
firejail_profiles_menulibre? ( || ( X xpra ) )
firejail_profiles_meteo-qt? ( || ( X xpra ) )
firejail_profiles_microsoft-edge? ( || ( X xpra ) )
firejail_profiles_microsoft-edge-beta? ( || ( X xpra ) )
firejail_profiles_microsoft-edge-dev? ( || ( X xpra ) )
firejail_profiles_midori? ( || ( X xpra ) )
firejail_profiles_min? ( || ( X xpra ) )
firejail_profiles_minecraft-launcher? ( || ( X xpra ) )
firejail_profiles_minitube? ( || ( X xpra ) )
firejail_profiles_mirage? ( || ( X xpra ) )
firejail_profiles_mp3splt-gtk? ( || ( X xpra ) )
firejail_profiles_musictube? ( || ( X xpra ) )
firejail_profiles_mutt? ( || ( X xpra ) )
firejail_profiles_mypaint? ( || ( X xpra ) )
firejail_profiles_nautilus? ( || ( X xpra ) )
firejail_profiles_neochat? ( || ( X xpra ) )
firejail_profiles_neomutt? ( || ( X xpra ) )
firejail_profiles_neverball-wrapper? ( || ( X xpra ) )
firejail_profiles_neverputt-wrapper? ( || ( X xpra ) )
firejail_profiles_newsflash? ( || ( X xpra ) )
firejail_profiles_nextcloud? ( || ( X xpra ) )
firejail_profiles_nheko? ( || ( X xpra ) )
firejail_profiles_nitroshare? ( || ( X xpra ) )
firejail_profiles_nomacs? ( || ( X xpra ) )
firejail_profiles_notable? ( || ( X xpra ) )
firejail_profiles_nuclear? ( || ( X xpra ) )
firejail_profiles_ocenaudio? ( || ( X xpra ) )
firejail_profiles_okular? ( || ( X xpra ) )
firejail_profiles_onboard? ( || ( X xpra ) )
firejail_profiles_onionshare-gui? ( || ( X xpra ) )
firejail_profiles_open-invaders? ( || ( X xpra ) )
firejail_profiles_openarena? ( || ( X xpra ) )
firejail_profiles_openmw? ( || ( X xpra ) )
firejail_profiles_openshot? ( || ( X xpra ) )
firejail_profiles_openshot-qt? ( || ( X xpra ) )
firejail_profiles_opera? ( || ( X xpra ) )
firejail_profiles_opera-beta? ( || ( X xpra ) )
firejail_profiles_opera-developer? ( || ( X xpra ) )
firejail_profiles_org_gnome_NautilusPreviewer? ( || ( X xpra ) )
firejail_profiles_otter-browser? ( || ( X xpra ) )
firejail_profiles_pavucontrol? ( || ( X xpra ) )
firejail_profiles_pavucontrol-qt? ( || ( X xpra ) )
firejail_profiles_pcmanfm? ( || ( X xpra ) )
firejail_profiles_pcsxr? ( || ( X xpra ) )
firejail_profiles_pdfchain? ( || ( X xpra ) )
firejail_profiles_peek? ( || ( X xpra ) )
firejail_profiles_photoflare? ( || ( X xpra ) )
firejail_profiles_pinball-wrapper? ( || ( X xpra ) )
firejail_profiles_ppsspp? ( || ( X xpra ) )
firejail_profiles_pragha? ( || ( X xpra ) )
firejail_profiles_psi? ( || ( X xpra ) )
firejail_profiles_pybitmessage? ( || ( X xpra ) )
firejail_profiles_qcomicbook? ( || ( X xpra ) )
firejail_profiles_qgis? ( || ( X xpra ) )
firejail_profiles_qt-faststart? ( || ( X xpra ) )
firejail_profiles_qtox? ( || ( X xpra ) )
firejail_profiles_quadrapassel? ( || ( X xpra ) )
firejail_profiles_quaternion? ( || ( X xpra ) )
firejail_profiles_quodlibet? ( || ( X xpra ) )
firejail_profiles_qutebrowser? ( || ( X xpra ) )
firejail_profiles_raincat? ( || ( X xpra ) )
firejail_profiles_rambox? ( || ( X xpra ) )
firejail_profiles_rednotebook? ( || ( X xpra ) )
firejail_profiles_rhythmbox? ( || ( X xpra ) )
firejail_profiles_riot-web? ( || ( X xpra ) )
firejail_profiles_rocketchat? ( || ( X xpra ) )
firejail_profiles_rtv? ( || ( X xpra ) )
firejail_profiles_scorched3d-wrapper? ( || ( X xpra ) )
firejail_profiles_scribus? ( || ( X xpra ) )
firejail_profiles_seahorse? ( || ( X xpra ) )
firejail_profiles_seamonkey? ( || ( X xpra ) )
firejail_profiles_secret-tool? ( || ( X xpra ) )
firejail_profiles_shortwave? ( || ( X xpra ) )
firejail_profiles_shotwell? ( || ( X xpra ) )
firejail_profiles_signal-desktop? ( || ( X xpra ) )
firejail_profiles_simutrans? ( || ( X xpra ) )
firejail_profiles_skanlite? ( || ( X xpra ) )
firejail_profiles_skypeforlinux? ( || ( X xpra ) )
firejail_profiles_slack? ( || ( X xpra ) )
firejail_profiles_smuxi-frontend-gnome? ( || ( X xpra ) )
firejail_profiles_snox? ( || ( X xpra ) )
firejail_profiles_spectacle? ( || ( X xpra ) )
firejail_profiles_spectral? ( || ( X xpra ) )
firejail_profiles_standardnotes-desktop? ( || ( X xpra ) )
firejail_profiles_steam? ( || ( X xpra ) )
firejail_profiles_supertuxkart? ( || ( X xpra ) )
firejail_profiles_supertuxkart-wrapper? ( || ( X xpra ) )
firejail_profiles_swell-foop? ( || ( X xpra ) )
firejail_profiles_sylpheed? ( || ( X xpra ) )
firejail_profiles_sysprof? ( || ( X xpra ) )
firejail_profiles_teams? ( || ( X xpra ) )
firejail_profiles_teams-for-linux? ( || ( X xpra ) )
firejail_profiles_telegram? ( || ( X xpra ) )
firejail_profiles_terasology? ( || ( X xpra ) )
firejail_profiles_thunar? ( || ( X xpra ) )
firejail_profiles_thunderbird? ( || ( X xpra ) )
firejail_profiles_totem? ( || ( X xpra ) )
firejail_profiles_transgui? ( || ( X xpra ) )
firejail_profiles_transmission-gtk? ( || ( X xpra ) )
firejail_profiles_transmission-qt? ( || ( X xpra ) )
firejail_profiles_transmission-remote-gtk? ( || ( X xpra ) )
firejail_profiles_trojita? ( || ( X xpra ) )
firejail_profiles_tutanota-desktop? ( || ( X xpra ) )
firejail_profiles_twitch? ( || ( X xpra ) )
firejail_profiles_udiskie? ( || ( X xpra ) )
firejail_profiles_uget-gtk? ( || ( X xpra ) )
firejail_profiles_unzip? ( || ( X xpra ) )
firejail_profiles_uzbl-browser? ( || ( X xpra ) )
firejail_profiles_virtualbox? ( || ( X xpra ) )
firejail_profiles_vivaldi? ( || ( X xpra ) )
firejail_profiles_vlc? ( || ( X xpra ) )
firejail_profiles_vmware? ( || ( X xpra xvfb ) )
firejail_profiles_vmware-player? ( || ( X xpra ) )
firejail_profiles_vmware-view? ( || ( X xpra ) )
firejail_profiles_warzone2100? ( || ( X xpra ) )
firejail_profiles_whalebird? ( || ( X xpra ) )
firejail_profiles_wire-desktop? ( || ( X xpra ) )
firejail_profiles_wireshark? ( || ( X xpra ) )
firejail_profiles_wireshark-gtk? ( || ( X xpra ) )
firejail_profiles_wireshark-qt? ( || ( X xpra ) )
firejail_profiles_x2goclient? ( || ( X xpra ) )
firejail_profiles_xfce4-notes? ( || ( X xpra ) )
firejail_profiles_xfce4-screenshooter? ( || ( X xpra ) )
firejail_profiles_xmms? ( || ( X xpra ) )
firejail_profiles_xonotic? ( || ( X xpra ) )
firejail_profiles_xonotic-sdl? ( || ( X xpra ) )
firejail_profiles_xonotic-sdl-wrapper? ( || ( X xpra ) )
firejail_profiles_yandex-browser? ( || ( X xpra ) )
firejail_profiles_yelp? ( || ( X xpra ) )
firejail_profiles_youtube? ( || ( X xpra ) )
firejail_profiles_youtube-dl-gui? ( || ( X xpra ) )
firejail_profiles_youtubemusic-nativefier? ( || ( X xpra ) )
firejail_profiles_ytmdesktop? ( || ( X xpra ) )
firejail_profiles_zathura? ( || ( X xpra ) )
firejail_profiles_zeal? ( || ( X xpra ) )
firejail_profiles_zim? ( || ( X xpra ) )
firejail_profiles_zoom? ( || ( X xpra ) )

firejail_profiles_hexchat? ( || ( X xpra ) )
firejail_profiles_obs? ( || ( X xpra ) )
firejail_profiles_pidgin? ( || ( X xpra ) )
firejail_profiles_pitivi? ( || ( X xpra ) )
firejail_profiles_qbittorrent? ( || ( X xpra ) )
firejail_profiles_xchat? ( || ( X xpra ) )
"
REQUIRED_USE+="
	${GUI_REQUIRED_USE}
	!test
	suid
	contrib? (
		${PYTHON_REQUIRED_USE}
	)
	test-x11? (
		test
	)
	test-profiles? (
		test
	)
	xpra? (
		X
	)
	xvfb? (
		X
	)
"

#	Not required until uncommented
#	firejail_profiles_chromium-common? ( firejail_profiles_chromium-common-hardened.inc )
#	firejail_profiles_electron? ( firejail_profiles_chromium-common-hardened.inc )
#	firejail_profiles_feh? ( firejail_profiles_feh-network.inc )
#	firejail_profiles_firefox-common? ( firejail_profiles_firefox-common-addons )
#	firejail_profiles_rtv? ( firejail_profiles_rtv-addons )

REQUIRED_USE+="
	firejail_profiles_1password? ( firejail_profiles_electron )
	firejail_profiles_7z? ( firejail_profiles_archiver-common )
	firejail_profiles_7za? ( firejail_profiles_7z )
	firejail_profiles_7zr? ( firejail_profiles_7z )
	firejail_profiles_Books? ( firejail_profiles_gnome-books )
	firejail_profiles_Builder? ( firejail_profiles_gnome-builder )
	firejail_profiles_Cheese? ( firejail_profiles_cheese )
	firejail_profiles_Cyberfox? ( firejail_profiles_cyberfox )
	firejail_profiles_Discord? ( firejail_profiles_discord )
	firejail_profiles_DiscordCanary? ( firejail_profiles_discord-canary )
	firejail_profiles_Documents? ( firejail_profiles_gnome-documents )
	firejail_profiles_FossaMail? ( firejail_profiles_fossamail )
	firejail_profiles_Gitter? ( firejail_profiles_gitter )
	firejail_profiles_Logs? ( firejail_profiles_gnome-logs )
	firejail_profiles_Maps? ( firejail_profiles_gnome-maps )
	firejail_profiles_Natron? ( firejail_profiles_natron )
	firejail_profiles_PPSSPPQt? ( firejail_profiles_ppsspp )
	firejail_profiles_PPSSPPSDL? ( firejail_profiles_ppsspp )
	firejail_profiles_Screenshot? ( firejail_profiles_gnome-screenshot )
	firejail_profiles_Telegram? ( firejail_profiles_telegram )
	firejail_profiles_Thunar? ( firejail_profiles_file-manager-common )
	firejail_profiles_VirtualBox? ( firejail_profiles_virtualbox )
	firejail_profiles_abrowser? ( firejail_profiles_firefox-common )
	firejail_profiles_acat? ( firejail_profiles_atool )
	firejail_profiles_adiff? ( firejail_profiles_atool )
	firejail_profiles_alienarena-wrapper? ( firejail_profiles_alienarena )
	firejail_profiles_alpinef? ( firejail_profiles_alpine )
	firejail_profiles_als? ( firejail_profiles_atool )
	firejail_profiles_amuled? ( firejail_profiles_amule )
	firejail_profiles_apack? ( firejail_profiles_atool )
	firejail_profiles_ar? ( firejail_profiles_archiver-common )
	firejail_profiles_ardour4? ( firejail_profiles_ardour5 )
	firejail_profiles_arepack? ( firejail_profiles_atool )
	firejail_profiles_atom? ( firejail_profiles_electron )
	firejail_profiles_atom-beta? ( firejail_profiles_atom )
	firejail_profiles_atool? ( firejail_profiles_archiver-common )
	firejail_profiles_atril-previewer? ( firejail_profiles_atril )
	firejail_profiles_atril-thumbnailer? ( firejail_profiles_atril )
	firejail_profiles_aunpack? ( firejail_profiles_atool )
	firejail_profiles_autokey-gtk? ( firejail_profiles_autokey-common )
	firejail_profiles_autokey-qt? ( firejail_profiles_autokey-common )
	firejail_profiles_autokey-run? ( firejail_profiles_autokey-common )
	firejail_profiles_autokey-shell? ( firejail_profiles_autokey-common )
	firejail_profiles_avidemux3_cli? ( firejail_profiles_avidemux )
	firejail_profiles_avidemux3_jobs_qt5? ( firejail_profiles_avidemux3_qt5 )
	firejail_profiles_avidemux3_qt5? ( firejail_profiles_avidemux )
	firejail_profiles_b2sum? ( firejail_profiles_hasher-common )
	firejail_profiles_ballbuster-wrapper? ( firejail_profiles_ballbuster )
	firejail_profiles_baloo_filemetadata_temp_extractor? ( firejail_profiles_baloo_file )
	firejail_profiles_balsa? ( firejail_profiles_email-common )
	firejail_profiles_basilisk? ( firejail_profiles_firefox-common )
	firejail_profiles_beaker? ( firejail_profiles_electron )
	firejail_profiles_bibtex? ( firejail_profiles_latex-common )
	firejail_profiles_bitwarden? ( firejail_profiles_electron )
	firejail_profiles_bnox? ( firejail_profiles_chromium-common )
	firejail_profiles_brave? ( firejail_profiles_chromium-common )
	firejail_profiles_brave-browser? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-beta? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-dev? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-nightly? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-stable? ( firejail_profiles_brave )
	firejail_profiles_bsdcat? ( firejail_profiles_bsdtar )
	firejail_profiles_bsdcpio? ( firejail_profiles_bsdtar )
	firejail_profiles_bsdtar? ( firejail_profiles_archiver-common )
	firejail_profiles_bundle? ( firejail_profiles_build-systems-common )
	firejail_profiles_bunzip2? ( firejail_profiles_gzip )
	firejail_profiles_bzcat? ( firejail_profiles_gzip )
	firejail_profiles_bzip2? ( firejail_profiles_gzip )
	firejail_profiles_cachy-browser? ( firejail_profiles_firefox-common )
	firejail_profiles_caja? ( firejail_profiles_file-manager-common )
	firejail_profiles_calligraauthor? ( firejail_profiles_calligra )
	firejail_profiles_calligraconverter? ( firejail_profiles_calligra )
	firejail_profiles_calligraflow? ( firejail_profiles_calligra )
	firejail_profiles_calligragemini? ( firejail_profiles_calligra )
	firejail_profiles_calligraplan? ( firejail_profiles_calligra )
	firejail_profiles_calligraplanwork? ( firejail_profiles_calligra )
	firejail_profiles_calligrasheets? ( firejail_profiles_calligra )
	firejail_profiles_calligrastage? ( firejail_profiles_calligra )
	firejail_profiles_calligrawords? ( firejail_profiles_calligra )
	firejail_profiles_cargo? ( firejail_profiles_build-systems-common )
	firejail_profiles_chromium? ( firejail_profiles_chromium-common )
	firejail_profiles_chromium-browser? ( firejail_profiles_chromium )
	firejail_profiles_chromium-browser-privacy? ( firejail_profiles_chromium )
	firejail_profiles_chromium-freeworld? ( firejail_profiles_chromium )
	firejail_profiles_cinelerra? ( firejail_profiles_cin )
	firejail_profiles_cinelerra-gg? ( firejail_profiles_cin )
	firejail_profiles_cksum? ( firejail_profiles_hasher-common )
	firejail_profiles_clamdscan? ( firejail_profiles_clamav )
	firejail_profiles_clamdtop? ( firejail_profiles_clamav )
	firejail_profiles_clamscan? ( firejail_profiles_clamav )
	firejail_profiles_claws-mail? ( firejail_profiles_email-common )
	firejail_profiles_clion-eap? ( firejail_profiles_clion )
	firejail_profiles_cliqz? ( firejail_profiles_firefox-common )
	firejail_profiles_clocks? ( firejail_profiles_gnome-clocks )
	firejail_profiles_cmake? ( firejail_profiles_build-systems-common )
	firejail_profiles_code? ( firejail_profiles_electron )
	firejail_profiles_code-oss? ( firejail_profiles_code )
	firejail_profiles_codium? ( firejail_profiles_vscodium )
	firejail_profiles_cola? ( firejail_profiles_git-cola )
	firejail_profiles_colorful-wrapper? ( firejail_profiles_colorful )
	firejail_profiles_conplay? ( firejail_profiles_mpg123 )
	firejail_profiles_cpio? ( firejail_profiles_archiver-common )
	firejail_profiles_crawl-tiles? ( firejail_profiles_crawl )
	firejail_profiles_cryptocat? ( firejail_profiles_Cryptocat )
	firejail_profiles_cvlc? ( firejail_profiles_vlc )
	firejail_profiles_cyberfox? ( firejail_profiles_firefox-common )
	firejail_profiles_ddgr? ( firejail_profiles_googler-common )
	firejail_profiles_devilspie2? ( firejail_profiles_devilspie )
	firejail_profiles_dino-im? ( firejail_profiles_dino )
	firejail_profiles_discord? ( firejail_profiles_discord-common )
	firejail_profiles_discord-canary? ( firejail_profiles_discord-common )
	firejail_profiles_discord-common? ( firejail_profiles_electron )
	firejail_profiles_dnox? ( firejail_profiles_chromium-common )
	firejail_profiles_dolphin? ( firejail_profiles_file-manager-common )
	firejail_profiles_dooble-qt4? ( firejail_profiles_dooble )
	firejail_profiles_ebook-convert? ( firejail_profiles_calibre )
	firejail_profiles_ebook-edit? ( firejail_profiles_calibre )
	firejail_profiles_ebook-meta? ( firejail_profiles_calibre )
	firejail_profiles_ebook-polish? ( firejail_profiles_calibre )
	firejail_profiles_ebook-viewer? ( firejail_profiles_calibre )
	firejail_profiles_electron-mail? ( firejail_profiles_electron )
	firejail_profiles_element-desktop? ( firejail_profiles_riot-desktop )
	firejail_profiles_elinks? ( firejail_profiles_links-common )
	firejail_profiles_enchant-2? ( firejail_profiles_enchant )
	firejail_profiles_enchant-lsmod? ( firejail_profiles_enchant )
	firejail_profiles_enchant-lsmod-2? ( firejail_profiles_enchant )
	firejail_profiles_enox? ( firejail_profiles_chromium-common )
	firejail_profiles_eog? ( firejail_profiles_eo-common )
	firejail_profiles_eom? ( firejail_profiles_eo-common )
	firejail_profiles_et? ( firejail_profiles_wps )
	firejail_profiles_etr-wrapper? ( firejail_profiles_etr )
	firejail_profiles_evince-previewer? ( firejail_profiles_evince )
	firejail_profiles_evince-thumbnailer? ( firejail_profiles_evince )
	firejail_profiles_exfalso? ( firejail_profiles_quodlibet )
	firejail_profiles_ffmpegthumbnailer? ( firejail_profiles_ffmpeg )
	firejail_profiles_ffplay? ( firejail_profiles_ffmpeg )
	firejail_profiles_ffprobe? ( firejail_profiles_ffmpeg )
	firejail_profiles_firedragon? ( firejail_profiles_firefox-common )
	firejail_profiles_firefox? ( firejail_profiles_firefox-common )
	firejail_profiles_firefox-beta? ( firejail_profiles_firefox )
	firejail_profiles_firefox-developer-edition? ( firejail_profiles_firefox )
	firejail_profiles_firefox-esr? ( firejail_profiles_firefox )
	firejail_profiles_firefox-nightly? ( firejail_profiles_firefox )
	firejail_profiles_firefox-wayland? ( firejail_profiles_firefox )
	firejail_profiles_firefox-x11? ( firejail_profiles_firefox )
	firejail_profiles_five-or-more? ( firejail_profiles_gnome_games-common )
	firejail_profiles_flacsplt? ( firejail_profiles_mp3splt )
	firejail_profiles_flashpeak-slimjet? ( firejail_profiles_chromium-common )
	firejail_profiles_fossamail? ( firejail_profiles_firefox )
	firejail_profiles_four-in-a-row? ( firejail_profiles_gnome_games-common )
	firejail_profiles_freecadcmd? ( firejail_profiles_freecad )
	firejail_profiles_freeciv-gtk3? ( firejail_profiles_freeciv )
	firejail_profiles_freeciv-mp-gtk3? ( firejail_profiles_freeciv )
	firejail_profiles_freeoffice-planmaker? ( firejail_profiles_softmaker-common )
	firejail_profiles_freeoffice-presentations? ( firejail_profiles_softmaker-common )
	firejail_profiles_freeoffice-textmaker? ( firejail_profiles_softmaker-common )
	firejail_profiles_freetube? ( firejail_profiles_electron )
	firejail_profiles_gajim-history-manager? ( firejail_profiles_gajim )
	firejail_profiles_gallery-dl? ( firejail_profiles_youtube-dl )
	firejail_profiles_gcalccmd? ( firejail_profiles_gnome-calculator )
	firejail_profiles_gconf-editor? ( firejail_profiles_gconf )
	firejail_profiles_gconf-merge-schema? ( firejail_profiles_gconf )
	firejail_profiles_gconf-merge-tree? ( firejail_profiles_gconf )
	firejail_profiles_gconfpkg? ( firejail_profiles_gconf )
	firejail_profiles_gconftool-2? ( firejail_profiles_gconf )
	firejail_profiles_ghb? ( firejail_profiles_handbrake )
	firejail_profiles_gist-paste? ( firejail_profiles_gist )
	firejail_profiles_github-desktop? ( firejail_profiles_electron )
	firejail_profiles_gl-117-wrapper? ( firejail_profiles_gl-117 )
	firejail_profiles_glaxium-wrapper? ( firejail_profiles_glaxium )
	firejail_profiles_gnome-2048? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-character-map? ( firejail_profiles_gucharmap )
	firejail_profiles_gnome-keyring-3? ( firejail_profiles_gnome-keyring )
	firejail_profiles_gnome-klotski? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-mahjongg? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-mines? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-mpv? ( firejail_profiles_celluloid )
	firejail_profiles_gnome-nibbles? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-robots? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-sudoku? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-taquin? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-tetravex? ( firejail_profiles_gnome_games-common )
	firejail_profiles_godot3? ( firejail_profiles_godot )
	firejail_profiles_google-chrome? ( firejail_profiles_chromium-common )
	firejail_profiles_google-chrome-beta? ( firejail_profiles_chromium-common )
	firejail_profiles_google-chrome-stable? ( firejail_profiles_google-chrome )
	firejail_profiles_google-chrome-unstable? ( firejail_profiles_chromium-common )
	firejail_profiles_google-earth-pro? ( firejail_profiles_google-earth )
	firejail_profiles_googler? ( firejail_profiles_googler-common )
	firejail_profiles_gpg2? ( firejail_profiles_gpg )
	firejail_profiles_gsettings? ( firejail_profiles_dconf )
	firejail_profiles_gsettings-data-convert? ( firejail_profiles_gconf )
	firejail_profiles_gsettings-schema-convert? ( firejail_profiles_gconf )
	firejail_profiles_gtar? ( firejail_profiles_tar )
	firejail_profiles_gtk-lbry-viewer? ( firejail_profiles_lbry-viewer )
	firejail_profiles_gtk-pipe-viewer? ( firejail_profiles_pipe-viewer )
	firejail_profiles_gtk-straw-viewer? ( firejail_profiles_straw-viewer )
	firejail_profiles_gtk-youtube-viewer? ( firejail_profiles_youtube-viewer )
	firejail_profiles_gtk2-youtube-viewer? ( firejail_profiles_youtube-viewer )
	firejail_profiles_gtk3-youtube-viewer? ( firejail_profiles_youtube-viewer )
	firejail_profiles_gummi? ( firejail_profiles_latex-common )
	firejail_profiles_gunzip? ( firejail_profiles_gzip )
	firejail_profiles_gzexe? ( firejail_profiles_gzip )
	firejail_profiles_gzip? ( firejail_profiles_archiver-common )
	firejail_profiles_handbrake-gtk? ( firejail_profiles_handbrake )
	firejail_profiles_hitori? ( firejail_profiles_gnome_games-common )
	firejail_profiles_icecat? ( firejail_profiles_firefox-common )
	firejail_profiles_icedove? ( firejail_profiles_firefox )
	firejail_profiles_iceweasel? ( firejail_profiles_firefox )
	firejail_profiles_idea? ( firejail_profiles_idea_sh )
	firejail_profiles_ideaIC? ( firejail_profiles_idea_sh )
	firejail_profiles_inkview? ( firejail_profiles_inkscape )
	firejail_profiles_inox? ( firejail_profiles_chromium-common )
	firejail_profiles_ipcalc-ng? ( firejail_profiles_ipcalc )
	firejail_profiles_iridium? ( firejail_profiles_chromium-common )
	firejail_profiles_iridium-browser? ( firejail_profiles_iridium )
	firejail_profiles_jdownloader? ( firejail_profiles_JDownloader )
	firejail_profiles_jitsi-meet-desktop? ( firejail_profiles_electron )
	firejail_profiles_jumpnbump-menu? ( firejail_profiles_jumpnbump )
	firejail_profiles_kalgebramobile? ( firejail_profiles_kalgebra )
	firejail_profiles_karbon? ( firejail_profiles_krita )
	firejail_profiles_keepass2? ( firejail_profiles_keepass )
	firejail_profiles_keepassx2? ( firejail_profiles_keepassx )
	firejail_profiles_keepassxc-cli? ( firejail_profiles_keepassxc )
	firejail_profiles_keepassxc-proxy? ( firejail_profiles_keepassxc )
	firejail_profiles_kid3-cli? ( firejail_profiles_kid3 )
	firejail_profiles_kid3-qt? ( firejail_profiles_kid3 )
	firejail_profiles_klatexformula_cmdl? ( firejail_profiles_klatexformula )
	firejail_profiles_knotes? ( firejail_profiles_kmail )
	firejail_profiles_latex? ( firejail_profiles_latex-common )
	firejail_profiles_lbry-viewer? ( firejail_profiles_youtube-viewers-common )
	firejail_profiles_lbunzip2? ( firejail_profiles_gzip )
	firejail_profiles_lbzcat? ( firejail_profiles_gzip )
	firejail_profiles_lbzip2? ( firejail_profiles_gzip )
	firejail_profiles_librewolf? ( firejail_profiles_firefox-common )
	firejail_profiles_librewolf-nightly? ( firejail_profiles_librewolf )
	firejail_profiles_lightsoff? ( firejail_profiles_gnome_games-common )
	firejail_profiles_links? ( firejail_profiles_links-common )
	firejail_profiles_links2? ( firejail_profiles_links-common )
	firejail_profiles_linuxqq? ( firejail_profiles_electron )
	firejail_profiles_lobase? ( firejail_profiles_libreoffice )
	firejail_profiles_localc? ( firejail_profiles_libreoffice )
	firejail_profiles_lodraw? ( firejail_profiles_libreoffice )
	firejail_profiles_loffice? ( firejail_profiles_libreoffice )
	firejail_profiles_lofromtemplate? ( firejail_profiles_libreoffice )
	firejail_profiles_loimpress? ( firejail_profiles_libreoffice )
	firejail_profiles_lomath? ( firejail_profiles_libreoffice )
	firejail_profiles_loweb? ( firejail_profiles_libreoffice )
	firejail_profiles_lowriter? ( firejail_profiles_libreoffice )
	firejail_profiles_lrunzip? ( firejail_profiles_cpio )
	firejail_profiles_lrz? ( firejail_profiles_cpio )
	firejail_profiles_lrzcat? ( firejail_profiles_cpio )
	firejail_profiles_lrzip? ( firejail_profiles_cpio )
	firejail_profiles_lrztar? ( firejail_profiles_cpio )
	firejail_profiles_lrzuntar? ( firejail_profiles_cpio )
	firejail_profiles_lsar? ( firejail_profiles_ar )
	firejail_profiles_lyx? ( firejail_profiles_latex-common )
	firejail_profiles_lzcat? ( firejail_profiles_cpio )
	firejail_profiles_lzcmp? ( firejail_profiles_cpio )
	firejail_profiles_lzdiff? ( firejail_profiles_cpio )
	firejail_profiles_lzegrep? ( firejail_profiles_cpio )
	firejail_profiles_lzfgrep? ( firejail_profiles_cpio )
	firejail_profiles_lzgrep? ( firejail_profiles_cpio )
	firejail_profiles_lzip? ( firejail_profiles_cpio )
	firejail_profiles_lzless? ( firejail_profiles_cpio )
	firejail_profiles_lzma? ( firejail_profiles_cpio )
	firejail_profiles_lzmadec? ( firejail_profiles_xzdec )
	firejail_profiles_lzmainfo? ( firejail_profiles_cpio )
	firejail_profiles_lzmore? ( firejail_profiles_cpio )
	firejail_profiles_lzop? ( firejail_profiles_cpio )
	firejail_profiles_make? ( firejail_profiles_build-systems-common )
	firejail_profiles_makedeb? ( firejail_profiles_makepkg )
	firejail_profiles_masterpdfeditor4? ( firejail_profiles_masterpdfeditor )
	firejail_profiles_masterpdfeditor5? ( firejail_profiles_masterpdfeditor )
	firejail_profiles_mate-calculator? ( firejail_profiles_mate-calc )
	firejail_profiles_mathematica? ( firejail_profiles_Mathematica )
	firejail_profiles_matrix-mirage? ( firejail_profiles_mirage )
	firejail_profiles_mattermost-desktop? ( firejail_profiles_electron )
	firejail_profiles_md5sum? ( firejail_profiles_hasher-common )
	firejail_profiles_megaglest_editor? ( firejail_profiles_megaglest )
	firejail_profiles_mencoder? ( firejail_profiles_mplayer )
	firejail_profiles_meson? ( firejail_profiles_build-systems-common )
	firejail_profiles_microsoft-edge? ( firejail_profiles_chromium-common )
	firejail_profiles_microsoft-edge-beta? ( firejail_profiles_chromium-common )
	firejail_profiles_microsoft-edge-dev? ( firejail_profiles_chromium-common )
	firejail_profiles_min? ( firejail_profiles_chromium-common )
	firejail_profiles_mp3wrap? ( firejail_profiles_mp3splt )
	firejail_profiles_mpg123-alsa? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-id3dump? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-jack? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-nas? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-openal? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-oss? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-portaudio? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-pulse? ( firejail_profiles_mpg123 )
	firejail_profiles_mpg123-strip? ( firejail_profiles_mpg123 )
	firejail_profiles_ms-excel? ( firejail_profiles_ms-office )
	firejail_profiles_ms-onenote? ( firejail_profiles_ms-office )
	firejail_profiles_ms-outlook? ( firejail_profiles_ms-office )
	firejail_profiles_ms-powerpoint? ( firejail_profiles_ms-office )
	firejail_profiles_ms-skype? ( firejail_profiles_ms-office )
	firejail_profiles_ms-word? ( firejail_profiles_ms-office )
	firejail_profiles_multimc? ( firejail_profiles_multimc5 )
	firejail_profiles_mupdf-gl? ( firejail_profiles_mupdf )
	firejail_profiles_mupdf-x11? ( firejail_profiles_mupdf )
	firejail_profiles_mupdf-x11-curl? ( firejail_profiles_mupdf )
	firejail_profiles_muraster? ( firejail_profiles_mupdf )
	firejail_profiles_mutool? ( firejail_profiles_mupdf )
	firejail_profiles_mypaint-ora-thumbnailer? ( firejail_profiles_mypaint )
	firejail_profiles_nautilus? ( firejail_profiles_file-manager-common )
	firejail_profiles_ncdu2? ( firejail_profiles_ncdu )
	firejail_profiles_nemo? ( firejail_profiles_file-manager-common )
	firejail_profiles_neverball-wrapper? ( firejail_profiles_neverball )
	firejail_profiles_neverputt? ( firejail_profiles_neverball )
	firejail_profiles_neverputt-wrapper? ( firejail_profiles_neverputt )
	firejail_profiles_newsbeuter? ( firejail_profiles_newsboat )
	firejail_profiles_nextcloud-desktop? ( firejail_profiles_nextcloud )
	firejail_profiles_nitroshare-cli? ( firejail_profiles_nitroshare )
	firejail_profiles_nitroshare-nmh? ( firejail_profiles_nitroshare )
	firejail_profiles_nitroshare-send? ( firejail_profiles_nitroshare )
	firejail_profiles_nitroshare-ui? ( firejail_profiles_nitroshare )
	firejail_profiles_node? ( firejail_profiles_nodejs-common )
	firejail_profiles_node-gyp? ( firejail_profiles_nodejs-common )
	firejail_profiles_notable? ( firejail_profiles_electron )
	firejail_profiles_npm? ( firejail_profiles_nodejs-common )
	firejail_profiles_npx? ( firejail_profiles_nodejs-common )
	firejail_profiles_nuclear? ( firejail_profiles_electron )
	firejail_profiles_oggsplt? ( firejail_profiles_mp3splt )
	firejail_profiles_onionshare? ( firejail_profiles_onionshare-gui )
	firejail_profiles_onionshare-cli? ( firejail_profiles_onionshare-gui )
	firejail_profiles_ooffice? ( firejail_profiles_libreoffice )
	firejail_profiles_ooviewdoc? ( firejail_profiles_libreoffice )
	firejail_profiles_openarena_ded? ( firejail_profiles_openarena )
	firejail_profiles_openmw-launcher? ( firejail_profiles_openmw )
	firejail_profiles_openshot-qt? ( firejail_profiles_openshot )
	firejail_profiles_opera? ( firejail_profiles_chromium-common )
	firejail_profiles_opera-beta? ( firejail_profiles_chromium-common )
	firejail_profiles_opera-developer? ( firejail_profiles_chromium-common )
	firejail_profiles_out123? ( firejail_profiles_mpg123 )
	firejail_profiles_p7zip? ( firejail_profiles_7z )
	firejail_profiles_palemoon? ( firejail_profiles_firefox-common )
	firejail_profiles_pavucontrol-qt? ( firejail_profiles_pavucontrol )
	firejail_profiles_pcmanfm? ( firejail_profiles_file-manager-common )
	firejail_profiles_pdflatex? ( firejail_profiles_latex-common )
	firejail_profiles_pinball-wrapper? ( firejail_profiles_pinball )
	firejail_profiles_pip? ( firejail_profiles_build-systems-common )
	firejail_profiles_pipe-viewer? ( firejail_profiles_youtube-viewers-common )
	firejail_profiles_planmaker18? ( firejail_profiles_softmaker-common )
	firejail_profiles_planmaker18free? ( firejail_profiles_softmaker-common )
	firejail_profiles_playonlinux? ( firejail_profiles_wine )
	firejail_profiles_presentations18? ( firejail_profiles_softmaker-common )
	firejail_profiles_presentations18free? ( firejail_profiles_softmaker-common )
	firejail_profiles_pycharm-professional? ( firejail_profiles_pycharm-community )
	firejail_profiles_pzstd? ( firejail_profiles_zstd )
	firejail_profiles_qq? ( firejail_profiles_linuxqq )
	firejail_profiles_qt-faststart? ( firejail_profiles_ffmpeg )
	firejail_profiles_quadrapassel? ( firejail_profiles_gnome_games-common )
	firejail_profiles_qupzilla? ( firejail_profiles_falkon )
	firejail_profiles_ranger? ( firejail_profiles_file-manager-common )
	firejail_profiles_rhythmbox-client? ( firejail_profiles_rhythmbox )
	firejail_profiles_riot-desktop? ( firejail_profiles_riot-web )
	firejail_profiles_riot-web? ( firejail_profiles_electron )
	firejail_profiles_rnano? ( firejail_profiles_nano )
	firejail_profiles_rocketchat? ( firejail_profiles_electron )
	firejail_profiles_rtin? ( firejail_profiles_tin )
	firejail_profiles_rview? ( firejail_profiles_vim )
	firejail_profiles_rvim? ( firejail_profiles_vim )
	firejail_profiles_scorched3d-wrapper? ( firejail_profiles_scorched3d )
	firejail_profiles_scp? ( firejail_profiles_ssh )
	firejail_profiles_seahorse-daemon? ( firejail_profiles_seahorse )
	firejail_profiles_seahorse-tool? ( firejail_profiles_seahorse )
	firejail_profiles_seamonkey-bin? ( firejail_profiles_seamonkey )
	firejail_profiles_secret-tool? ( firejail_profiles_gnome-keyring )
	firejail_profiles_semver? ( firejail_profiles_nodejs-common )
	firejail_profiles_sftp? ( firejail_profiles_ssh )
	firejail_profiles_sha1sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha224sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha256sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha384sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha512sum? ( firejail_profiles_hasher-common )
	firejail_profiles_signal-desktop? ( firejail_profiles_electron )
	firejail_profiles_skypeforlinux? ( firejail_profiles_electron )
	firejail_profiles_slack? ( firejail_profiles_electron )
	firejail_profiles_snox? ( firejail_profiles_chromium-common )
	firejail_profiles_soffice? ( firejail_profiles_libreoffice )
	firejail_profiles_start-tor-browser? ( firejail_profiles_start-tor-browser_desktop )
	firejail_profiles_steam-native? ( firejail_profiles_steam )
	firejail_profiles_steam-runtime? ( firejail_profiles_steam )
	firejail_profiles_straw-viewer? ( firejail_profiles_youtube-viewers-common )
	firejail_profiles_sum? ( firejail_profiles_hasher-common )
	firejail_profiles_supertuxkart-wrapper? ( firejail_profiles_supertuxkart )
	firejail_profiles_swell-foop? ( firejail_profiles_gnome_games-common )
	firejail_profiles_sylpheed? ( firejail_profiles_email-common )
	firejail_profiles_sysprof-cli? ( firejail_profiles_sysprof )
	firejail_profiles_tar? ( firejail_profiles_archiver-common )
	firejail_profiles_tb-starter-wrapper? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_teams? ( firejail_profiles_electron )
	firejail_profiles_teams-for-linux? ( firejail_profiles_electron )
	firejail_profiles_telegram-desktop? ( firejail_profiles_telegram )
	firejail_profiles_tex? ( firejail_profiles_latex-common )
	firejail_profiles_textmaker18? ( firejail_profiles_softmaker-common )
	firejail_profiles_textmaker18free? ( firejail_profiles_softmaker-common )
	firejail_profiles_thunar? ( firejail_profiles_Thunar )
	firejail_profiles_thunderbird? ( firejail_profiles_firefox-common )
	firejail_profiles_thunderbird-beta? ( firejail_profiles_thunderbird )
	firejail_profiles_thunderbird-wayland? ( firejail_profiles_thunderbird )
	firejail_profiles_tor-browser? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ar? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ca? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-cs? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-da? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-de? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-el? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-en? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-en-us? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-es? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-es-es? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-fa? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-fr? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ga-ie? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-he? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-hu? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-id? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-is? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-it? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ja? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ka? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ko? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-nb? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-nl? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-pl? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-pt-br? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-ru? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-sv-se? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-tr? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-vi? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-zh-cn? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser-zh-tw? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ar? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ca? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_cs? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_da? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_de? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_el? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_en? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_en-US? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_es? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_es-ES? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_fa? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_fr? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ga-IE? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_he? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_hu? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_id? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_is? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_it? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ja? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ka? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ko? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_nb? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_nl? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_pl? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_pt-BR? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_ru? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_sv-SE? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_tr? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_vi? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_zh-CN? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_tor-browser_zh-TW? ( firejail_profiles_torbrowser-launcher )
	firejail_profiles_torbrowser? ( firejail_profiles_firefox-common )
	firejail_profiles_transmission-cli? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-create? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-daemon? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-edit? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-gtk? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-qt? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-remote? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-remote-cli? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-remote-gtk? ( firejail_profiles_transmission-common )
	firejail_profiles_transmission-show? ( firejail_profiles_transmission-common )
	firejail_profiles_tshark? ( firejail_profiles_wireshark )
	firejail_profiles_tuir? ( firejail_profiles_rtv )
	firejail_profiles_tutanota-desktop? ( firejail_profiles_electron )
	firejail_profiles_twitch? ( firejail_profiles_electron )
	firejail_profiles_unar? ( firejail_profiles_ar )
	firejail_profiles_uncompress? ( firejail_profiles_gzip )
	firejail_profiles_unlzma? ( firejail_profiles_cpio )
	firejail_profiles_unrar? ( firejail_profiles_archiver-common )
	firejail_profiles_unxz? ( firejail_profiles_cpio )
	firejail_profiles_unzip? ( firejail_profiles_archiver-common )
	firejail_profiles_unzstd? ( firejail_profiles_zstd )
	firejail_profiles_vimcat? ( firejail_profiles_vim )
	firejail_profiles_vimdiff? ( firejail_profiles_vim )
	firejail_profiles_vimpager? ( firejail_profiles_vim )
	firejail_profiles_vimtutor? ( firejail_profiles_vim )
	firejail_profiles_vivaldi? ( firejail_profiles_chromium-common )
	firejail_profiles_vivaldi-beta? ( firejail_profiles_vivaldi )
	firejail_profiles_vivaldi-snapshot? ( firejail_profiles_vivaldi )
	firejail_profiles_vivaldi-stable? ( firejail_profiles_vivaldi )
	firejail_profiles_vmware-player? ( firejail_profiles_vmware )
	firejail_profiles_vmware-workstation? ( firejail_profiles_vmware )
	firejail_profiles_vscodium? ( firejail_profiles_code )
	firejail_profiles_vulturesclaw? ( firejail_profiles_nethack-vultures )
	firejail_profiles_vultureseye? ( firejail_profiles_nethack-vultures )
	firejail_profiles_waterfox? ( firejail_profiles_firefox-common )
	firejail_profiles_waterfox-classic? ( firejail_profiles_waterfox )
	firejail_profiles_waterfox-current? ( firejail_profiles_waterfox )
	firejail_profiles_weechat-curses? ( firejail_profiles_weechat )
	firejail_profiles_wget2? ( firejail_profiles_wget )
	firejail_profiles_whalebird? ( firejail_profiles_electron )
	firejail_profiles_wire-desktop? ( firejail_profiles_electron )
	firejail_profiles_wireshark-gtk? ( firejail_profiles_wireshark )
	firejail_profiles_wireshark-qt? ( firejail_profiles_wireshark )
	firejail_profiles_wpp? ( firejail_profiles_wps )
	firejail_profiles_wpspdf? ( firejail_profiles_wps )
	firejail_profiles_xlinks? ( firejail_profiles_links )
	firejail_profiles_xlinks2? ( firejail_profiles_links2 )
	firejail_profiles_xonotic-glx? ( firejail_profiles_xonotic )
	firejail_profiles_xonotic-sdl? ( firejail_profiles_xonotic )
	firejail_profiles_xonotic-sdl-wrapper? ( firejail_profiles_xonotic )
	firejail_profiles_xournalpp? ( firejail_profiles_xournal )
	firejail_profiles_xplayer-audio-preview? ( firejail_profiles_xplayer )
	firejail_profiles_xplayer-video-thumbnailer? ( firejail_profiles_xplayer )
	firejail_profiles_xreader-previewer? ( firejail_profiles_xreader )
	firejail_profiles_xreader-thumbnailer? ( firejail_profiles_xreader )
	firejail_profiles_xxd? ( firejail_profiles_cpio )
	firejail_profiles_xz? ( firejail_profiles_cpio )
	firejail_profiles_xzcat? ( firejail_profiles_cpio )
	firejail_profiles_xzcmp? ( firejail_profiles_cpio )
	firejail_profiles_xzdec? ( firejail_profiles_archiver-common )
	firejail_profiles_xzdiff? ( firejail_profiles_cpio )
	firejail_profiles_xzegrep? ( firejail_profiles_cpio )
	firejail_profiles_xzfgrep? ( firejail_profiles_cpio )
	firejail_profiles_xzgrep? ( firejail_profiles_cpio )
	firejail_profiles_xzless? ( firejail_profiles_cpio )
	firejail_profiles_xzmore? ( firejail_profiles_cpio )
	firejail_profiles_yandex-browser? ( firejail_profiles_chromium-common )
	firejail_profiles_yarn? ( firejail_profiles_nodejs-common )
	firejail_profiles_youtube? ( firejail_profiles_electron )
	firejail_profiles_youtube-viewer? ( firejail_profiles_youtube-viewers-common )
	firejail_profiles_youtubemusic-nativefier? ( firejail_profiles_electron )
	firejail_profiles_yt-dlp? ( firejail_profiles_youtube-dl )
	firejail_profiles_ytmdesktop? ( firejail_profiles_electron )
	firejail_profiles_zcat? ( firejail_profiles_gzip )
	firejail_profiles_zcmp? ( firejail_profiles_gzip )
	firejail_profiles_zdiff? ( firejail_profiles_gzip )
	firejail_profiles_zegrep? ( firejail_profiles_gzip )
	firejail_profiles_zfgrep? ( firejail_profiles_gzip )
	firejail_profiles_zforce? ( firejail_profiles_gzip )
	firejail_profiles_zgrep? ( firejail_profiles_gzip )
	firejail_profiles_zless? ( firejail_profiles_gzip )
	firejail_profiles_zmore? ( firejail_profiles_gzip )
	firejail_profiles_znew? ( firejail_profiles_gzip )
	firejail_profiles_zoom? ( firejail_profiles_electron )
	firejail_profiles_zpaq? ( firejail_profiles_cpio )
	firejail_profiles_zstd? ( firejail_profiles_archiver-common )
	firejail_profiles_zstdcat? ( firejail_profiles_zstd )
	firejail_profiles_zstdgrep? ( firejail_profiles_zstd )
	firejail_profiles_zstdless? ( firejail_profiles_zstd )
	firejail_profiles_zstdmt? ( firejail_profiles_zstd )
"
PATCHES=(
	"${FILESDIR}/${PN}-0.9.70-envlimits.patch"
	"${FILESDIR}/${PN}-0.9.70-firecfg.config.patch"
)

get_impls() {
	echo "release"
	use test && echo "test"
}

gen_profile_array() {
einfo "Replace FIREJAIL_PROFILES with the following:"

	cd "${S}" ; \
	find "etc"/{profile-m-z,profile-a-l} -name "*.profile" \
		| cut -f 3 -d "/" \
		| sed -e "s|\.profile||g" \
		| sed -e "s|\.|_|g" \
		| sort \
		| tr "\n" " " \
		| fold -s -w 80 \
		| sed -E -e "s|[ ]*$||g"
	echo
}

gen_required_use() {
	# Regenerates the REQUIRED_USE dependency graph.

	# #1 identify and find all the nodes (aka points)
	# #2 connect the edges via conditional dependency

einfo "Replace REQUIRED_USE with the following:"

	local etc_folder="${S}/etc"

	local nodes=()

	local f
	for f in $(find "${etc_folder}/"{profile-a-l,profile-m-z} -name "*.profile") ; do
		local n=$(basename "${f}" \
			| sed -e "s|\.profile||g" \
			| sed -e "s|\.|_|g")
		nodes+=( "${n}" )
	done

	unset g
	declare -A g

	# The parent is always left hand side, the child is the right hand side in the bucket list

	local p
	for p in $(echo "${nodes[@]}" | tr " " "\n" | sort) ; do
		ls "${etc_folder}/"*"/${p}.profile" \
			>/dev/null \
			2>&1 \
			|| continue
		local profiles=$(grep -E \
			-e "include .*.profile" \
			$(ls "${etc_folder}/"*"/${p}.profile") \
				| sed -e "/^#/d")
		local childs=$(echo "${profiles}" \
			| sed -e "s|\.profile||" \
				-e "s|include ||" \
				-e "s|\.|_|g")
		if [[ -n "${childs}" ]] ; then
			childs=$(echo "${childs}" \
				| sed -e "s|^|firejail_profiles_|g")
			echo -e "\tfirejail_profiles_${p}? ( ${childs} )"  # parent: childs
		fi
	done
	echo
}

gen_x11_compat() {
einfo
einfo "Place the following in the X11_COMPAT array:"
einfo
	local CURSES_COMPAT=(
		weechat
		weechat-curses
	)
	local MISSING_NAMES=(
		amarok
		brave
		brave-browser
		brasero
		chromium
		clementine
		dillo
		firefox
		evince
		evince-previewer
		evince-thumbnailer
		google-chrome
		eog
		gramps
		hexchat
		nautilus
		obs
		pcmanfm
		pidgin
		pitivi
		qbittorrent
		thunar
		thunderbird
		uzbl-browser
		vivaldi
		vmware-player
		xchat
		xmms
		wireshark
		wireshark-gtk
		wireshark-qt
	# If it is uppercase, it is assumed is is a win port of that app.
	)
	local X_HEADLESS_COMPAT=(
		vmware
	)

	is_x_headless_compat() {
		local arg="${1}"
		local y
		for y in ${X_HEADLESS_COMPAT[@]} ; do
			if [[ "${arg}" == "${y}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	local x
	for x in $(grep -l -r -E -e "(tauri|electron|chromium|opengl|@x11|gtk|gnome|kde|sdl|qt|opengl|vulkan)" "${S}/etc/profile"*) ${MISSING_NAMES[@]} ; do \
		basename "${x}"; \
	done \
		| tr " " "\n" \
		| sed -e "/-common/d" \
		| sed -e "s|\.profile||g" \
		| sort \
		| uniq \
		| tr "\n" " " \
		| fold -s -w 80 \
		| sed -e "s| $||g" \
		| sed -e "s|\.|_|g"
einfo
einfo "Replace GUI_REQUIRED_USE with the following:"
einfo
	local L=$(for x in $(grep -l -r -E -e "(tauri|electron|chromium|opengl|@x11|gtk|gnome|kde|sdl|qt|opengl|vulkan)" "${S}/etc/profile"*) ${MISSING_NAMES[@]} ; do \
		basename "${x}"; \
	done \
		| tr " " "\n" \
		| sed -e "/-common/d" \
		| sed -e "s|\.profile||g" \
		| sort \
		| uniq \
		| tr "\n" " " \
		| fold -s -w 80 \
		| sed -e "s| $||g" \
		| sed -e "s|\.|_|g")
	for x in ${L[@]} ; do
		if is_x_headless_compat "${x}" ; then
echo "firejail_profiles_${x}? ( || ( X xpra xvfb ) )"
		else
echo "firejail_profiles_${x}? ( || ( X xpra ) )"
		fi
	done
}

gen_ebuild() {
	gen_profile_array
	gen_required_use
	#gen_x11_compat
eerror
eerror "Comment out GEN_EBUILD when you are done."
eerror
	die
}

pkg_setup() {
	python-single-r1_pkg_setup
	CONFIG_CHECK="~SQUASHFS"
	local WARNING_SQUASHFS="CONFIG_SQUASHFS: required for firejail --appimage mode"

	linux-info_pkg_setup
	local config_path=$(linux_config_path)
einfo "config_path:  ${config_path}"
	local lsm_list=$(grep -e "CONFIG_LSM" "${config_path}" \
		| cut -f 2 -d '"')
	if use apparmor ; then
		CONFIG_CHECK+=" ~SECURITY ~NET ~SECURITY_APPARMOR"
		if ! [[ "${lsm_list}" =~ "apparmor" ]] ; then
ewarn
ewarn "Missing apparmor in kernel .config CONFIG_LSM list."
ewarn "See also https://github.com/torvalds/linux/blob/v6.6/security/Kconfig#L234"
ewarn
		fi
	fi

	check_extra_config
	if use test && [[ "${TEST_SET}" == "full" ]] ; then
		if has userpriv $FEATURES ; then
eerror
eerror "You need to add FEATURES=\"\${FEATURES} -userpriv\" to complete testing"
eerror "in your per-package envvars"
eerror
			die
		fi
	fi
}

_src_prepare_test_full() {
	#
	# The problem with the tests is that they assume BROOT always,
	# and not SYSROOT agnostic, which makes it difficult to test
	# (our customizations) before installing.  The tests reference
	# the already installed version which is what we do not want.
	# We prefer the test the one that will be installed.
	#
einfo "Redirecting paths to isolated image (from \${ROOT} to \${ED})"
	for f in $(grep -l -r -e "/etc/firejail" "${S}/test") ; do
einfo "Editing ${f}:  /etc/firejail -> ${ED}/etc/firejail"
		sed -i -e "s| /etc/firejail| ${ED}/etc/firejail|g" \
			-e "s|--netfilter=/etc/firejail|--netfilter=${ED}/etc/firejail|g" \
			-e "s|--output=/etc/firejail|--output=${ED}/etc/firejail|g" \
			-e "s|\"/etc/firejail/default.profile|\"${ED}/etc/firejail/default.profile|g" \
			"${f}" || die
	done
	for f in $(grep -l -r -e "/usr/bin/firejail" "${S}/test") ; do
einfo "Editing ${f}:  /usr/bin/firejail -> ${ED}/usr/bin/firejail"
		sed -i -e "s|/usr/bin/firejail|${ED}/usr/bin/firejail|g" \
			"${f}" || die
	done
	for f in $(grep -l -r -e "PATH:/usr/lib/firejail:/usr/lib64/firejail" "${S}/test") ; do
einfo "Editing ${f}:  \$PATH:/usr/lib/firejail:/usr/lib64/firejail -> \$PATH:${ED}/usr/lib/firejail:${ED}/usr/lib64/firejail"
		sed -i -e "s|PATH:/usr/lib/firejail:/usr/lib64/firejail|PATH:${ED}/usr/lib/firejail:${ED}/usr/lib64/firejail|g" \
			"${f}" || die
	done
	for f in $(grep -l -r -e "/usr/share/doc/firejail" "${S}/test") ; do
einfo "Editing ${f}:  /usr/share/doc/firejail -> ${ED}/usr/share/doc/firejail-${PVR}"
		sed -i -e "s|/usr/share/doc/firejail|${ED}/usr/share/doc/firejail-${PVR}|g" \
			"${f}" || die
	done
#	for f in $(grep -l -r -e "PREFIX=/usr" "${S}") ; do
#einfo "Editing ${f}:  PREFIX=/usr -> PREFIX=${ED}/usr"
#		sed -i -e "s|PREFIX=/usr|PREFIX=${ED}/usr|g" \
#			"${f}" || die
#	done
}

src_prepare() {
	default

	if [[ "${GEN_EBUILD}" == "1" ]] ; then
		gen_ebuild
	fi

	if use xpra ; then
		eapply "${FILESDIR}/${PN}-0.9.64-xpra-speaker-override.patch"
	fi

	# Our toolchain already sets SSP by default but forcing it causes problems
	# on arches which don't support it. As for F_S, we again set it by defualt
	# in our toolchain, but forcing F_S=2 is actually a downgrade if 3 is set.
	sed -i \
		-e 's:-fstack-protector-all::' \
		-e 's:-D_FORTIFY_SOURCE=2::' \
		src/so.mk src/prog.mk || die

	find \
		-type f \
		\( \
			   -name "*.mk" \
			-o -name "configure" \
		\) \
		-exec \
			sed -i -r \
				-e "s/(-O2|-ggdb)//g" {} + \
				|| die

	# Fix up hardcoded paths to templates and docs
	local files=$(grep \
		-E \
		-l \
		-r '/usr/share/doc/firejail([^-]|$)' \
		"RELNOTES" \
		"src/man/" \
		"etc/profile"*"/" \
		"test/" \
		|| die)
	local file
	for file in ${files[@]} ; do
		sed -i -r \
			-e "s:/usr/share/doc/firejail([^-]|\$):/usr/share/doc/${PF}\1:" \
			"${file}" \
			|| die
	done

	# Remove compression of man pages
	sed -i -r -e \
'/rm -f \$\$man.gz; \\/d; '\
'/gzip -9n \$\$man; \\/d; '\
's|\*\.([[:digit:]])\) install -m 0644 \$\$man\.gz|\*\.\1\) install -m 0644 \$\$man|g' \
		Makefile || die

	if use contrib; then
		python_fix_shebang -f "contrib/"*".py"
	fi

	# Profile fixes:
	sed -i \
		-e "s|#private-lib|private-lib|g" \
		"etc/profile-a-l/file.profile" \
		|| die
	sed -i \
		-e "s|#private-lib|private|g" \
		"etc/profile-m-z/tar.profile" \
		|| die

	if use test ; then
		if [[ "${TEST_SET}" == "full" ]] ; then
			_src_prepare_test_full
		fi
	fi

	local impl
	for impl in $(get_impls) ; do
		cp -a "${S}" "${S}_${impl}" || die
	done
}

_src_configure_test_full() {
#	sed -i \
#		-e "s|MAX_ENVS 256|MAX_ENVS ${FIREJAIL_MAX_ENVS}|g" \
#		"src/firejail/firejail.h" \
#		|| die
#	grep -q -r \
#		-e "MAX_ENVS ${FIREJAIL_MAX_ENVS}" \
#		"src/firejail/firejail.h" \
#		|| die
#ewarn
#ewarn "Max envvars lifted to ${FIREJAIL_MAX_ENVS} for test build."
#ewarn "Setting changable by setting per-package envvar FIREJAIL_MAX_ENVS"
#ewarn
#einfo "Current envvar count: "$(env | wc -l)

	# firejail deprecated --profile-dir= so must be hardwired this way
	sed -i \
		-e "s|\$(sysconfdir)|${ED}/etc|g" \
		"src/common.mk.in" \
		|| die
#	test_opts+=(--prefix="${ED}/usr")
einfo "Editing ${BUILD_DIR}/test/filters/memwrexe.exp:  ./memwrexe -> ${BUILD_DIR}/test/filters/memwrexe"
	sed -i \
		-e "s|\./memwrexe|${BUILD_DIR}/test/filters/memwrexe|g" \
		"${BUILD_DIR}/test/filters/memwrexe.exp" \
		|| die
#	:
}

_src_configure() {
	local test_opts=()
	if [[ "${impl}" == "test" && "${TEST_SET}" == "full" ]] ; then
		_src_configure_test_full
	else
		test_opts=()
	fi

	local myconf=(
		$(use_enable apparmor)
		$(use_enable chroot)
		$(use_enable dbusproxy)
		$(use_enable file-transfer)
		$(use_enable globalcfg)
		$(use_enable network)
		$(use_enable private-home)
		$(use_enable selinux)
		$(use_enable suid)
		$(use_enable userns)
		$(use_enable X x11)
		${test_opts[@]}
		--disable-firetunnel
		--disable-lts
	)

	econf ${myconf[@]}
}

src_configure()
{
	# Make _FORTIFY_SOURCE work properly
	replace-flags '-O0' '-O1'

	local impl
	for impl in $(get_impls) ; do
		export BUILD_DIR="${S}_${impl}"
		cd "${BUILD_DIR}" || die
		_src_configure
	done
}

_src_compile() {
	emake CC="$(tc-getCC)"
	if [[ "${impl}" == "test" ]] ; then
		DESTDIR="${D}" emake install
	fi
}

src_compile()
{
	local impl
	for impl in $(get_impls) ; do
		export BUILD_DIR="${S}_${impl}"
		cd "${BUILD_DIR}" || die
		_src_compile
	done
}

WHITELIST_READONLY=(
	BROOT
	D
	DEFINED_PHASES
	EAPI
	EBUILD
	EBUILD_PHASE
	EBUILD_PHASE_FUNC
	ED
	EMERGE_FROM
	EPREFIX
	EROOT
	FILESDIR
	INHERITED
	KEYWORDS
	LICENSE
	MERGE_TYPE
	PM_EBUILD_HOOK_DIR
	PORTAGE_ACTUAL_DISTDIR
	PORTAGE_ARCHLIST
	PORTAGE_BASHRC
	PORTAGE_BIN_PATH
	PORTAGE_BUILDDIR
	PORTAGE_BUILD_GROUP
	PORTAGE_BUILD_USER
	PORTAGE_BZIP2_COMMAND
	PORTAGE_COLORMAP
	PORTAGE_CONFIGROOT
	PORTAGE_DEPCACHEDIR
	PORTAGE_GID
	PORTAGE_INST_GID
	PORTAGE_INST_UID
	PORTAGE_INTERNAL_CALLER
	PORTAGE_IPC_DAEMON
	PORTAGE_LOG_FILE
	PORTAGE_OVERRIDE_EPREFIX
	PORTAGE_PROPERTIES
	PORTAGE_PYM_PATH
	PORTAGE_PYTHON
	PORTAGE_PYTHONPATH
	PORTAGE_REPO_NAME
	PORTAGE_REPOSITORIES
	PORTAGE_RESTRICT
	PORTAGE_SIGPIPE_STATUS
	PORTAGE_TMPDIR
	PORTAGE_VERBOSE
	PORTAGE_WORKDIR_MODE
	PORTAGE_XATTR_EXCLUDE
	SLOT
	T
	USE
	WORKDIR
)

save_env()
{
	env -0 > "${T}/env.txt"
}

restore_env()
{
	while IFS= read -r -d $'\0' l
	do
		local allow=1
		k=$(echo "${l}" \
			| cut -f 1 -d "=" \
			| cut -f 1 -d "=")
		[[ "${k}" =~ "PORTAGE_REPOSITORIES" ]] && k="PORTAGE_REPOSITORIES"
		[[ "${k}" =~ "PORTAGE_COLORMAP" ]] && k="PORTAGE_COLORMAP"
		for w in ${WHITELIST_READONLY[@]} ; do
			[[ "${k}" == "${w}" ]] && allow=0
		done
		v=$(echo "${l}" | cut -f 2- -d "=")
		(( ${allow} == 1 )) && export ${k}="${v}"
	done < "${T}/env.txt"
	export IFS=$' \t\n'
}

wipe_env()
{
	local whitelist=(
		CFLAGS
		CHOST
		CXXFLAGS
		DIE_ON_CAPS_ERROR
		DIE_ON_GRSECURITY_ERROR
		DIE_ON_PROGRAM_LOAD_FAILURE
		DIE_ON_SECCOMP_ERROR
		DISPLAY
		IFS
		HOME
		LDFLAGS
		LD_LIBRARY_PATH
		PATH
		PWD
		S
		SANDBOX_ON
		SHELL
		TERM
		USE_CAPS
		USE_GRSECURITY
		USE_SECCOMP
		USER
	)

	env -0 > "${T}/env-dump.txt"

	local envs=()
	while IFS= read -r -d $'\0' l
	do
		n=$(echo "${l}" | cut -f 1 -d "=")
		[[ "${n}" =~ "PORTAGE_REPOSITORIES" ]] && n="PORTAGE_REPOSITORIES"
		[[ "${n}" =~ "PORTAGE_COLORMAP" ]] && n="PORTAGE_COLORMAP"
		local allow=1
		local w
		for w in ${whitelist[@]} ${WHITELIST_READONLY[@]} ; do
			[[ "${n}" == "${w}" ]] && allow=0
		done
		(( ${allow} == 1 )) && envs+=( "${n}" )
	done < "${T}/env-dump.txt"
	export IFS=$' \t\n'

	for n in ${envs[@]} ; do
		unset ${n}
	done
}

_src_test_full()
{
	# Setting these to test against the to be installed version not the one to be replaced.
	export PATH="${ED}/usr/bin:${PATH}"
	export LD_LIBRARY_PATH="${ED}/usr/$(get_libdir)/firejail:${LD_LIBRARY_PATH}"
einfo "PATH=\"${PATH}\""
einfo "LD_LIBRARY_PATH=\"${LD_LIBRARY_PATH}\""

	export SANDBOX_ON=0

	if [[ -f "/proc/sys/kernel/grsecurity" ]] ; then
		export USE_GRSECURITY=1
		export DIE_ON_GRSECURITY_ERROR=0
	else
		export USE_GRSECURITY=0
	fi
	if grep -q -e "^Seccomp" "/proc/self/status" ; then
		export USE_SECCOMP=1
		export DIE_ON_SECCOMP_ERROR=0
	else
		export USE_SECCOMP=0
	fi
	if [[ -f "/sys/kernel/security/apparmor/profiles" ]] ; then
		:
	fi
	export USE_CAPS=1
	export DIE_ON_CAPS_ERROR=0
	export DIE_ON_PROGRAM_LOAD_FAILURE=1

	# Upstream uses `make test-github` for CI
	local x11_tests=()
	local profile_tests=()
	local misc_tests=()
	use test-profiles && profile_tests+=(test-profiles)
	misc_tests=()
	# Mixes test-github and test-noprofiles with exclusions.
	local basic_tests=(
		test-private-lib
		test-fnetfilter
		test-fs
		test-utils
		test-sysutils
		test-environment
	)

	mkdir -p "${ED}/etc/firejail" || die
	touch "${ED}/etc/firejail/globals.local" || die

	# Sandboxed $HOME for HOME tests
#	echo \
#		"whitelist $(realpath ~/)" \
#		>> \
#		"${ED}/etc/firejail/globals.local" \
#		|| die
#	echo \
#		"whitelist $(realpath ~/)/_firejail_test_file1" \
#		>> \
#		"${ED}/etc/firejail/globals.local" \
#		|| die

	# Add globals for ricers
	echo \
		"private-lib gcc/*/*/libgomp.so.*" \
		>> \
		"${ED}/etc/firejail/globals.local" \
		|| die

	# Temporary enable list
	echo \
		"include file.profile #REMOVE_ME: temporary test addition" \
		>> \
		"${ED}/etc/firejail/server.profile" \
		|| die

	# It's safe to ignore these kinds of fldd warnings:
	#Warning fldd: cannot find libstdc++.so.6, skipping...
	#Warning fldd: cannot find libgcc_s.so.1, skipping...
	# pavcontrol still works with these warnings.

	touch "${T}/test-all.log" || die

	save_env

if true ; then
	for x in ${profile_tests[@]} ${basic_tests[@]} ${misc_tests[@]} ; do
einfo "Testing ${x}"
		wipe_env
		make ${x} 2>&1 >"${T}/test.log"
		local retcode=$?
		restore_env
		if (( ${retcode} == 0 )) ; then
einfo "${x} passed"
		else
eerror
eerror "Test failed for ${x}.  Return code: ${retcode}.  For details see"
eerror "${T}/test.log"
eerror
			die
		fi
		if grep -q -E -e "Error [0-9]+" "${T}/test.log" ; then
eerror
eerror "Test failed for ${x}.  For details see ${T}/test.log"
eerror
			die
		fi
		cat "${T}/test.log" >> "${T}/test-all.log" || die
	done
fi

	if use test-x11 ; then
		# For memwrexe.exp tests
#		echo \
#			"keep-var-tmp" \
#			>> \
#			"${ED}/etc/firejail/globals.local" \
#			|| die
#		echo \
#			"whitelist ${WORKDIR}/${PN}-${PV}*/test/filters/memwrexe*" \
#			>> \
#			"${ED}/etc/firejail/globals.local" \
#			|| die

		x11_tests+=(
			test-apps
			test-apps-x11
			test-apps-x11-xorg
			test-filters
		)
		for x in ${x11_tests[@]} ; do
			cd "${BUILD_DIR}" || die
einfo "Testing ${x}"
cat <<EOF > "${BUILD_DIR}/run.sh"
#!/bin/bash
cat /dev/null > "${T}/test-retcode.log"
make ${x} 2>&1 >"${T}/test.log"
echo -n "\$?" > "${T}/test-retcode.log"
exit \$(cat "${T}/test-retcode.log")
EOF
			chmod +x "${BUILD_DIR}/run.sh"
			wipe_env
			virtx "${BUILD_DIR}/run.sh"
			restore_env
			if grep -q -E -e "Error [0-9]+" "${T}/test.log" ; then
eerror
eerror "Test failed for ${x}.  For details see ${T}/test.log"
eerror
				die
			fi
			if [[ ! -f "${T}/test-retcode.log" ]] ; then
eerror
eerror "Missing retcode for ${x}"
eerror
				die
			fi
			local test_retcode=$(cat "${T}/test-retcode.log")
			if [[ "${test_retcode}" != "0" ]] ; then
eerror
eerror "Test failed for ${x}.  Return code: ${test_retcode}.  For details see"
eerror "${T}/test.log"
eerror
				die
			fi
			cat \
				"${T}/test.log" \
				>> \
				"${T}/test-all.log" \
				|| die
		done

#		sed -i \
#			-e "\|#REMOVE_ME|d" \
#			"${ED}/etc/firejail/globals.local" \
#			|| die

	fi
	export SANDBOX_ON=1

einfo "FIXME:  Error results:"
	grep -o -E -r \
		-e "TESTING ERROR [0-9.]+" "${T}/test-all.log" \
		-e "TESTING ERROR - grsecurity detection" \
		| sort \
		| uniq -c

	rm \
		"${ED}/etc/firejail/globals.local" \
		|| die

	sed -i \
		-e "\|#REMOVE_ME|d" \
		"${ED}/etc/firejail/server.profile" \
		|| die
}

_src_test_distro() {
	emake test-utils test-sysutils
}

src_test() {
	local impl
	for impl in $(get_impls) ; do
		export BUILD_DIR="${S}_${impl}"
		cd "${BUILD_DIR}" || die
		if [[ "${TEST_SET}" == "full" ]] ; then
			_src_test_full
		else
			_src_test_distro
		fi
	done
}

is_use_dotted() {
	local u="${1}"
	local fn
	for fn in ${DOTTED_FILENAMES[@]} ; do
		[[ "${fn//./_}" == "${u}" ]] && return 0
	done
	return 1
}

get_dotted_fn() {
	local u="${1}"
	local fn
	for fn in ${DOTTED_FILENAMES[@]} ; do
		if [[ "${fn//./_}" == "${u}" ]] ; then
			echo "${fn}"
			return
		fi
	done
	echo ""
}

gen_wrapper() {
	local profile_name="${1}"
	local exe_name="${1}"
einfo "Generating wrapper for ${profile_name}"

	local x11_flag=""

	is_x11_compat() {
		local arg="${1}"
		local x
		for x in ${X11_COMPAT[@]} ; do
			if [[ "${arg}" == "${x}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	if is_x11_compat "${profile_name}" ; then
		x11_flag="--x11"
	fi

cat <<EOF > "${ED}/usr/local/bin/${exe_name}"
#!/bin/bash
exec firejail ${x11_flag} --profile="${profile_name}" "${exe_name}" "\$@"
EOF
	fowners "root:root" "/usr/local/bin/${exe_name}"
	fperms 0755 "/usr/local/bin/${exe_name}"
}

_install_one_profile() {
	default

	if use contrib ; then
		python_scriptinto "/usr/$(get_libdir)/firejail"
		python_doscript "contrib/"*".py"
		insinto "/usr/$(get_libdir)/firejail"
		dobin "contrib/"*".sh"
	fi

	mkdir -p "${T}/profiles" || die
	mv $(find "${ED}/etc/firejail/" -name "*.profile") \
		"${T}/profiles" || die

	mkdir -p "${T}/profiles_processed" || die

	local pf
	for pf in ${FIREJAIL_PROFILES_IUSE} ; do
		local u="${pf/firejail_profiles_/}"
		local src
		local dest
		if is_use_dotted "${u}" ; then
			src=$(find "${T}/profiles" -name $(get_dotted_fn "${u}")".profile" \
				| sed -r -e "s|[ ]+||g")
			dest="${ED}/etc/firejail/"$(get_dotted_fn "${u}")".profile"
		else
			src=$(find "${T}/profiles" -name "${u}.profile" \
				| sed -r -e "s|[ ]+||g")
			dest="${ED}/etc/firejail/${u}.profile"
		fi
		if [[ ! -e "${src}" ]] ; then
eerror
eerror "u=${u}"
eerror "${src} is missing"
eerror
eerror "QA:  Try converting u value underscores (_) to a period (.) before"
eerror "adding to DOTTED_FILENAMES."
eerror
			die
		fi
		if use ${pf} ; then
einfo "Adding ${u} profile"
			mv "${src}" "${dest}" || die
			if use wrapper && ! [[ "${u}" =~ "-common" ]] && ! [[ "${u}" =~ "-wrapper" ]] ; then
				gen_wrapper "${u}"
			fi
		else
einfo "Rejecting ${u} profile"
			local dest="${T}/profiles_processed"
			mv "${src}" "${dest}" || die
		fi
	done

	for pf in $(find "${T}/profiles" | sed -e "1d") ; do
		local u=$(basename "${pf}" | sed -e "s|.profile||g")
ewarn "Q/A: Missing ${u} in IUSE flags."
	done
	if (( $(find "${T}/profiles" | sed -e "1d" | wc -l) != 0 )) ; then
eerror
eerror "${T}/profiles is not empty"
eerror
		die
	fi

einfo "Verifying release build"
	if grep -r -e "/image/" "${ED}/usr/bin" ; then
eerror
eerror "Detected test binaries"
eerror
		die
	fi
	if grep -r -e "/image/" "${ED}/usr/$(get_libdir)" ; then
eerror
eerror "Detected test libraries"
eerror
		die
	fi
}

src_install() {
	use wrapper && dodir "/usr/local/bin"
	local impl
	for impl in $(get_impls) ; do
		export BUILD_DIR="${S}_${impl}"
		cd "${BUILD_DIR}" || die

		# Test does not get installed due to modifications
		[[ "${impl}" == "test" ]] && continue

		_install_one_profile
	done

	if ! use vanilla ; then
		# Gentoo-specific profile customizations
		insinto "/etc/${PN}"
		local profile_local
		for profile_local in "${FILESDIR}/profile_"*"local" ; do
			newins "${profile_local}" "${profile_local/\/*profile_/}"
		done
	fi

	# Prevent sandbox violations when toolchain is firejailed
cat > "${T}/99firejail" <<-EOF || die
SANDBOX_WRITE="/run/firejail"
EOF
	insinto "/etc/sandbox.d"
	doins "${T}/99firejail"
	if use suid ; then
einfo "Setting suid bit for /usr/bin/firejail"
#		fperms u+s "/usr/bin/firejail"
	fi
}

pkg_postinst() {
	if use xpra ; then
einfo
einfo "A new custom args have been added to improve performance.  To lessen"
einfo "shuddering/skipping some apps may benefit by disabiling sound sound"
einfo "input and output forwarding."
einfo
einfo
einfo "New args (must be placed before --x11=xpra)"
einfo
einfo "  --xpra-speaker=0  # disables sound forwarding for xpra"
einfo "  --xpra-speaker=1  # enables sound forwarding for xpra"
einfo
einfo
einfo "Profile additions"
einfo
einfo "  xpra_speaker_off  # disables sound forwarding for xpra"
einfo "  xpra_speaker_on  # enables sound forwarding for xpra"
einfo
	fi
ewarn
ewarn "Files marked chmod uo+r permissions and filenames containing sensitive"
ewarn "info contained in the root directory are exposed to an attacker in the"
ewarn "sandbox.  They should be moved in either another disk, or in folder with"
ewarn "parent folder and descendants with uo-r chmod permissions or explicitly"
ewarn "added as a blacklist rule in /etc/firejail/globals.local."
ewarn
ewarn "Always check your sandbox profile in the shell to see if it meets your"
ewarn "privacy requirements."
einfo
einfo "Note to ricers and optimization fanatics:"
einfo
einfo "You may need to update /etc/firejail/globals.local to add"
einfo "private-lib gcc/*/*/libgomp.so.*"
einfo
einfo "The following optional USE flags are required if the disabled included"
einfo "profiles are uncommented inside:"
einfo
einfo "  firejail_profiles_chromium-common? ( firejail_profiles_chromium-common-hardened.inc )"
einfo "  firejail_profiles_electron? ( firejail_profiles_chromium-common-hardened.inc )"
einfo "  firejail_profiles_feh? ( firejail_profiles_feh-network.inc )"
einfo "  firejail_profiles_firefox-common? ( firejail_profiles_firefox-common-addons )"
einfo "  firejail_profiles_rtv? ( firejail_profiles_rtv-addons )"
einfo
	if ! use firejail_profiles_server ; then
ewarn "Disabling firejail_profiles_server disables default sandboxing for the root user"
	fi
	if use wrapper && use X ; then
ewarn
ewarn "The wrapper should auto add --x11, but some wrappers are missing it."
ewarn "If you would like to see --x11 support in the wrapper for that program,"
ewarn "send and issue request at the repo."
ewarn
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, ebuild-changes, profile-selection, testing-sections, audio-patch
# OILEDMACHINE-OVERLAY-META-WIP:  test-USE-flag
# OILEDMACHINE-OVERLAY-META-DETAILED-NOTES:  The test USE flag was found useful in correcting profile errors and why it kept around; however, it is garbage quality.
