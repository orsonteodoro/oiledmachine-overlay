# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U 22.04

declare -A _PROFILE_GRAPH
declare -A APPARMOR_PROFILE
declare -A ARGS
declare -A AUTO_BLACKLIST
declare -A COMMAND
declare -A LANDLOCK
declare -A LANDLOCK_PROC
declare -A LANDLOCK_READ
declare -A LANDLOCK_WRITE
declare -A LANDLOCK_EXECUTE
declare -A LANDLOCK_SPECIAL
declare -A OOM
declare -A SECCOMP
declare -A SECCOMP_BLOCK
declare -A SECCOMP_KEEP
declare -A MALLOC_BACKEND
declare -A PATH_CORRECTION
declare -A SCOPE
declare -A SCUDO_FREE_IMMEDIATE
declare -A XEPHYR_WH
declare -A X_BACKEND

_PROFILE_GRAPH["_1password"]="electron-common"
_PROFILE_GRAPH["_7z"]="archiver-common"
_PROFILE_GRAPH["_7za"]="7z"
_PROFILE_GRAPH["_7zr"]="7z"
_PROFILE_GRAPH["Books"]="gnome-books"
_PROFILE_GRAPH["Builder"]="gnome-builder"
_PROFILE_GRAPH["Cheese"]="cheese"
_PROFILE_GRAPH["Cyberfox"]="cyberfox"
_PROFILE_GRAPH["Discord"]="discord"
_PROFILE_GRAPH["DiscordCanary"]="discord-canary"
_PROFILE_GRAPH["DiscordPTB"]="discord-ptb"
_PROFILE_GRAPH["Documents"]="gnome-documents"
_PROFILE_GRAPH["FBReader"]="fbreader"
_PROFILE_GRAPH["FossaMail"]="fossamail"
_PROFILE_GRAPH["Gitter"]="gitter"
_PROFILE_GRAPH["Logs"]="gnome-logs"
_PROFILE_GRAPH["Maps"]="gnome-maps"
_PROFILE_GRAPH["Natron"]="natron"
_PROFILE_GRAPH["PPSSPPQt"]="ppsspp"
_PROFILE_GRAPH["PPSSPPSDL"]="ppsspp"
_PROFILE_GRAPH["Postman"]="postman"
_PROFILE_GRAPH["Screenshot"]="gnome-screenshot"
_PROFILE_GRAPH["Telegram"]="telegram"
_PROFILE_GRAPH["Thunar"]="file-manager-common"
_PROFILE_GRAPH["VirtualBox"]="virtualbox"
_PROFILE_GRAPH["abrowser"]="firefox-common"
_PROFILE_GRAPH["acat"]="atool"
_PROFILE_GRAPH["adiff"]="atool"
_PROFILE_GRAPH["alienarena-wrapper"]="alienarena"
_PROFILE_GRAPH["alpinef"]="alpine"
_PROFILE_GRAPH["als"]="atool"
_PROFILE_GRAPH["amuled"]="amule"
_PROFILE_GRAPH["ani-cli"]="mpv"
_PROFILE_GRAPH["apack"]="atool"
_PROFILE_GRAPH["ar"]="archiver-common"
_PROFILE_GRAPH["ardour4"]="ardour5"
_PROFILE_GRAPH["arepack"]="atool"
_PROFILE_GRAPH["armcord"]="electron-common"
_PROFILE_GRAPH["atom"]="electron-common"
_PROFILE_GRAPH["atom-beta"]="atom"
_PROFILE_GRAPH["atool"]="archiver-common"
_PROFILE_GRAPH["atril-previewer"]="atril"
_PROFILE_GRAPH["atril-thumbnailer"]="atril"
_PROFILE_GRAPH["aunpack"]="atool"
_PROFILE_GRAPH["autokey-gtk"]="autokey-common"
_PROFILE_GRAPH["autokey-qt"]="autokey-common"
_PROFILE_GRAPH["autokey-run"]="autokey-common"
_PROFILE_GRAPH["autokey-shell"]="autokey-common"
_PROFILE_GRAPH["avidemux3_cli"]="avidemux"
_PROFILE_GRAPH["avidemux3_jobs_qt5"]="avidemux3_qt5"
_PROFILE_GRAPH["avidemux3_qt5"]="avidemux"
_PROFILE_GRAPH["b2sum"]="hasher-common"
_PROFILE_GRAPH["b3sum"]="hasher-common"
_PROFILE_GRAPH["ballbuster-wrapper"]="ballbuster"
_PROFILE_GRAPH["baloo_filemetadata_temp_extractor"]="baloo_file"
_PROFILE_GRAPH["balsa"]="email-common"
_PROFILE_GRAPH["basilisk"]="firefox-common"
_PROFILE_GRAPH["beaker"]="electron-common"
_PROFILE_GRAPH["bibtex"]="latex-common"
_PROFILE_GRAPH["bitwarden"]="electron-common"
_PROFILE_GRAPH["bitwarden-desktop"]="bitwarden"
_PROFILE_GRAPH["bnox"]="chromium-common"
_PROFILE_GRAPH["brave"]="chromium-common"
_PROFILE_GRAPH["brave-browser"]="brave"
_PROFILE_GRAPH["brave-browser-beta"]="brave"
_PROFILE_GRAPH["brave-browser-dev"]="brave"
_PROFILE_GRAPH["brave-browser-nightly"]="brave"
_PROFILE_GRAPH["brave-browser-stable"]="brave"
_PROFILE_GRAPH["brz"]="git"
_PROFILE_GRAPH["bsdcat"]="bsdtar"
_PROFILE_GRAPH["bsdcpio"]="bsdtar"
_PROFILE_GRAPH["bsdtar"]="archiver-common"
_PROFILE_GRAPH["bundle"]="build-systems-common"
_PROFILE_GRAPH["bunzip2"]="gzip"
_PROFILE_GRAPH["bzcat"]="gzip"
_PROFILE_GRAPH["bzip2"]="gzip"
_PROFILE_GRAPH["bzr"]="brz"
_PROFILE_GRAPH["cachy-browser"]="firefox-common"
_PROFILE_GRAPH["caja"]="file-manager-common"
_PROFILE_GRAPH["calligraauthor"]="calligra"
_PROFILE_GRAPH["calligraconverter"]="calligra"
_PROFILE_GRAPH["calligraflow"]="calligra"
_PROFILE_GRAPH["calligragemini"]="calligra"
_PROFILE_GRAPH["calligraplan"]="calligra"
_PROFILE_GRAPH["calligraplanwork"]="calligra"
_PROFILE_GRAPH["calligrasheets"]="calligra"
_PROFILE_GRAPH["calligrastage"]="calligra"
_PROFILE_GRAPH["calligrawords"]="calligra"
_PROFILE_GRAPH["caprine"]="electron-common"
_PROFILE_GRAPH["cargo"]="build-systems-common"
_PROFILE_GRAPH["chromium"]="chromium-common"
_PROFILE_GRAPH["chromium-browser"]="chromium"
_PROFILE_GRAPH["chromium-browser-privacy"]="chromium"
_PROFILE_GRAPH["chromium-common"]="blink-common"
_PROFILE_GRAPH["chromium-freeworld"]="chromium"
_PROFILE_GRAPH["cinelerra"]="cin"
_PROFILE_GRAPH["cinelerra-gg"]="cin"
_PROFILE_GRAPH["cksum"]="hasher-common"
_PROFILE_GRAPH["clamdscan"]="clamav"
_PROFILE_GRAPH["clamdtop"]="clamav"
_PROFILE_GRAPH["clamscan"]="clamav"
_PROFILE_GRAPH["claws-mail"]="email-common"
_PROFILE_GRAPH["clion-eap"]="clion"
_PROFILE_GRAPH["cliqz"]="firefox-common"
_PROFILE_GRAPH["clocks"]="gnome-clocks"
_PROFILE_GRAPH["cmake"]="build-systems-common"
_PROFILE_GRAPH["code"]="electron-common"
_PROFILE_GRAPH["code-oss"]="code"
_PROFILE_GRAPH["codium"]="vscodium"
_PROFILE_GRAPH["cola"]="git-cola"
_PROFILE_GRAPH["colorful-wrapper"]="colorful"
_PROFILE_GRAPH["conplay"]="mpg123"
_PROFILE_GRAPH["cpio"]="archiver-common"
_PROFILE_GRAPH["crawl-tiles"]="crawl"
_PROFILE_GRAPH["cryptocat"]="Cryptocat"
_PROFILE_GRAPH["cvlc"]="vlc"
_PROFILE_GRAPH["cyberfox"]="firefox-common"
_PROFILE_GRAPH["d-feet"]="dbus-debug-common"
_PROFILE_GRAPH["d-spy"]="dbus-debug-common"
_PROFILE_GRAPH["ddgr"]="googler-common"
_PROFILE_GRAPH["devilspie2"]="devilspie"
_PROFILE_GRAPH["dino-im"]="dino"
_PROFILE_GRAPH["discord"]="discord-common"
_PROFILE_GRAPH["discord-canary"]="discord-common"
_PROFILE_GRAPH["discord-common"]="electron-common"
_PROFILE_GRAPH["discord-ptb"]="discord-common"
_PROFILE_GRAPH["dnox"]="chromium-common"
_PROFILE_GRAPH["dolphin"]="file-manager-common"
_PROFILE_GRAPH["dooble-qt4"]="dooble"
_PROFILE_GRAPH["dtui"]="dbus-debug-common"
_PROFILE_GRAPH["ebook-convert"]="calibre"
_PROFILE_GRAPH["ebook-edit"]="calibre"
_PROFILE_GRAPH["ebook-meta"]="calibre"
_PROFILE_GRAPH["ebook-polish"]="calibre"
_PROFILE_GRAPH["ebook-viewer"]="calibre"
_PROFILE_GRAPH["electron-common"]="blink-common"
_PROFILE_GRAPH["electron-mail"]="electron-common"
_PROFILE_GRAPH["element-desktop"]="riot-desktop"
_PROFILE_GRAPH["elinks"]="links-common"
_PROFILE_GRAPH["enchant-2"]="enchant"
_PROFILE_GRAPH["enchant-lsmod"]="enchant"
_PROFILE_GRAPH["enchant-lsmod-2"]="enchant-2"
_PROFILE_GRAPH["enox"]="chromium-common"
_PROFILE_GRAPH["eog"]="eo-common"
_PROFILE_GRAPH["eom"]="eo-common"
_PROFILE_GRAPH["et"]="wps"
_PROFILE_GRAPH["etr-wrapper"]="etr"
_PROFILE_GRAPH["evince-previewer"]="evince"
_PROFILE_GRAPH["evince-thumbnailer"]="evince"
_PROFILE_GRAPH["exfalso"]="quodlibet"
_PROFILE_GRAPH["ffmpegthumbnailer"]="ffmpeg"
_PROFILE_GRAPH["ffplay"]="ffmpeg"
_PROFILE_GRAPH["ffprobe"]="ffmpeg"
_PROFILE_GRAPH["firedragon"]="firefox-common"
_PROFILE_GRAPH["firefox"]="firefox-common"
_PROFILE_GRAPH["firefox-beta"]="firefox"
_PROFILE_GRAPH["firefox-developer-edition"]="firefox"
_PROFILE_GRAPH["firefox-esr"]="firefox"
_PROFILE_GRAPH["firefox-nightly"]="firefox"
_PROFILE_GRAPH["firefox-wayland"]="firefox"
_PROFILE_GRAPH["firefox-x11"]="firefox"
_PROFILE_GRAPH["five-or-more"]="gnome_games-common"
_PROFILE_GRAPH["fix-qdf"]="qpdf"
_PROFILE_GRAPH["flacsplt"]="mp3splt"
_PROFILE_GRAPH["flashpeak-slimjet"]="chromium-common"
_PROFILE_GRAPH["floorp"]="firefox-common"
_PROFILE_GRAPH["fossamail"]="firefox"
_PROFILE_GRAPH["four-in-a-row"]="gnome_games-common"
_PROFILE_GRAPH["freecadcmd"]="freecad"
_PROFILE_GRAPH["freeciv-gtk3"]="freeciv"
_PROFILE_GRAPH["freeciv-mp-gtk3"]="freeciv"
_PROFILE_GRAPH["freeoffice-planmaker"]="softmaker-common"
_PROFILE_GRAPH["freeoffice-presentations"]="softmaker-common"
_PROFILE_GRAPH["freeoffice-textmaker"]="softmaker-common"
_PROFILE_GRAPH["freetube"]="electron-common"
_PROFILE_GRAPH["gajim-history-manager"]="gajim"
_PROFILE_GRAPH["gallery-dl"]="yt-dlp"
_PROFILE_GRAPH["gcalccmd"]="gnome-calculator"
_PROFILE_GRAPH["gconf-editor"]="gconf"
_PROFILE_GRAPH["gconf-merge-schema"]="gconf"
_PROFILE_GRAPH["gconf-merge-tree"]="gconf"
_PROFILE_GRAPH["gconfpkg"]="gconf"
_PROFILE_GRAPH["gconftool-2"]="gconf"
_PROFILE_GRAPH["gh"]="git"
_PROFILE_GRAPH["ghb"]="handbrake"
_PROFILE_GRAPH["gist-paste"]="gist"
_PROFILE_GRAPH["github-desktop"]="electron-common"
_PROFILE_GRAPH["gl-117-wrapper"]="gl-117"
_PROFILE_GRAPH["glaxium-wrapper"]="glaxium"
_PROFILE_GRAPH["gnome-2048"]="gnome_games-common"
_PROFILE_GRAPH["gnome-character-map"]="gucharmap"
_PROFILE_GRAPH["gnome-keyring"]="gnome-keyring-daemon"
_PROFILE_GRAPH["gnome-keyring-3"]="gnome-keyring"
_PROFILE_GRAPH["gnome-klotski"]="gnome_games-common"
_PROFILE_GRAPH["gnome-logs"]="system-log-common"
_PROFILE_GRAPH["gnome-mahjongg"]="gnome_games-common"
_PROFILE_GRAPH["gnome-mines"]="gnome_games-common"
_PROFILE_GRAPH["gnome-mpv"]="celluloid"
_PROFILE_GRAPH["gnome-nibbles"]="gnome_games-common"
_PROFILE_GRAPH["gnome-robots"]="gnome_games-common"
_PROFILE_GRAPH["gnome-sudoku"]="gnome_games-common"
_PROFILE_GRAPH["gnome-system-log"]="system-log-common"
_PROFILE_GRAPH["gnome-taquin"]="gnome_games-common"
_PROFILE_GRAPH["gnome-tetravex"]="gnome_games-common"
_PROFILE_GRAPH["godot3"]="godot"
_PROFILE_GRAPH["google-chrome"]="chromium-common"
_PROFILE_GRAPH["google-chrome-beta"]="chromium-common"
_PROFILE_GRAPH["google-chrome-stable"]="google-chrome"
_PROFILE_GRAPH["google-chrome-unstable"]="chromium-common"
_PROFILE_GRAPH["google-earth-pro"]="google-earth"
_PROFILE_GRAPH["googler"]="googler-common"
_PROFILE_GRAPH["gpg2"]="gpg"
_PROFILE_GRAPH["gsettings"]="dconf"
_PROFILE_GRAPH["gsettings-data-convert"]="gconf"
_PROFILE_GRAPH["gsettings-schema-convert"]="gconf"
_PROFILE_GRAPH["gtar"]="tar"
_PROFILE_GRAPH["gtk-lbry-viewer"]="gtk-youtube-viewers-common lbry-viewer"
_PROFILE_GRAPH["gtk-pipe-viewer"]="gtk-youtube-viewers-common pipe-viewer"
_PROFILE_GRAPH["gtk-straw-viewer"]="gtk-youtube-viewers-common straw-viewer"
_PROFILE_GRAPH["gtk-youtube-viewer"]="gtk-youtube-viewers-common youtube-viewer"
_PROFILE_GRAPH["gtk2-youtube-viewer"]="gtk-youtube-viewers-common youtube-viewer"
_PROFILE_GRAPH["gtk3-youtube-viewer"]="gtk-youtube-viewers-common youtube-viewer"
_PROFILE_GRAPH["gummi"]="latex-common"
_PROFILE_GRAPH["gunzip"]="gzip"
_PROFILE_GRAPH["gzexe"]="gzip"
_PROFILE_GRAPH["gzip"]="archiver-common"
_PROFILE_GRAPH["handbrake-gtk"]="handbrake"
_PROFILE_GRAPH["hitori"]="gnome_games-common"
_PROFILE_GRAPH["icecat"]="firefox-common"
_PROFILE_GRAPH["icedove"]="firefox"
_PROFILE_GRAPH["iceweasel"]="firefox"
_PROFILE_GRAPH["idea"]="idea_sh"
_PROFILE_GRAPH["ideaIC"]="idea_sh"
_PROFILE_GRAPH["inkview"]="inkscape"
_PROFILE_GRAPH["inox"]="chromium-common"
_PROFILE_GRAPH["ipcalc-ng"]="ipcalc"
_PROFILE_GRAPH["iridium"]="chromium-common"
_PROFILE_GRAPH["iridium-browser"]="iridium"
_PROFILE_GRAPH["jami"]="jami-gnome"
_PROFILE_GRAPH["jdownloader"]="JDownloader"
_PROFILE_GRAPH["jitsi-meet-desktop"]="electron-common"
_PROFILE_GRAPH["journal-viewer"]="system-log-common"
_PROFILE_GRAPH["jumpnbump-menu"]="jumpnbump"
_PROFILE_GRAPH["kalgebramobile"]="kalgebra"
_PROFILE_GRAPH["karbon"]="krita"
_PROFILE_GRAPH["keepass2"]="keepass"
_PROFILE_GRAPH["keepassx2"]="keepassx"
_PROFILE_GRAPH["keepassxc-cli"]="keepassxc"
_PROFILE_GRAPH["keepassxc-proxy"]="keepassxc"
_PROFILE_GRAPH["kid3-cli"]="kid3"
_PROFILE_GRAPH["kid3-qt"]="kid3"
_PROFILE_GRAPH["klatexformula_cmdl"]="klatexformula"
_PROFILE_GRAPH["knotes"]="kmail"
_PROFILE_GRAPH["kontact"]="kmail"
_PROFILE_GRAPH["latex"]="latex-common"
_PROFILE_GRAPH["lbry-viewer"]="youtube-viewers-common"
_PROFILE_GRAPH["lbry-viewer-gtk"]="gtk-youtube-viewers-common lbry-viewer"
_PROFILE_GRAPH["lbunzip2"]="gzip"
_PROFILE_GRAPH["lbzcat"]="gzip"
_PROFILE_GRAPH["lbzip2"]="gzip"
_PROFILE_GRAPH["librewolf"]="firefox-common"
_PROFILE_GRAPH["librewolf-nightly"]="librewolf"
_PROFILE_GRAPH["lightsoff"]="gnome_games-common"
_PROFILE_GRAPH["links"]="links-common"
_PROFILE_GRAPH["links2"]="links-common"
_PROFILE_GRAPH["linuxqq"]="electron-common"
_PROFILE_GRAPH["lobase"]="libreoffice"
_PROFILE_GRAPH["lobster"]="mpv"
_PROFILE_GRAPH["localc"]="libreoffice"
_PROFILE_GRAPH["lodraw"]="libreoffice"
_PROFILE_GRAPH["loffice"]="libreoffice"
_PROFILE_GRAPH["lofromtemplate"]="libreoffice"
_PROFILE_GRAPH["loimpress"]="libreoffice"
_PROFILE_GRAPH["lomath"]="libreoffice"
_PROFILE_GRAPH["loweb"]="libreoffice"
_PROFILE_GRAPH["lowriter"]="libreoffice"
_PROFILE_GRAPH["lrunzip"]="cpio"
_PROFILE_GRAPH["lrz"]="cpio"
_PROFILE_GRAPH["lrzcat"]="cpio"
_PROFILE_GRAPH["lrzip"]="cpio"
_PROFILE_GRAPH["lrztar"]="cpio"
_PROFILE_GRAPH["lrzuntar"]="cpio"
_PROFILE_GRAPH["lsar"]="ar"
_PROFILE_GRAPH["lyx"]="latex-common"
_PROFILE_GRAPH["lz4"]="archiver-common"
_PROFILE_GRAPH["lz4c"]="lz4"
_PROFILE_GRAPH["lz4cat"]="lz4"
_PROFILE_GRAPH["lzcat"]="cpio"
_PROFILE_GRAPH["lzcmp"]="cpio"
_PROFILE_GRAPH["lzdiff"]="cpio"
_PROFILE_GRAPH["lzegrep"]="cpio"
_PROFILE_GRAPH["lzfgrep"]="cpio"
_PROFILE_GRAPH["lzgrep"]="cpio"
_PROFILE_GRAPH["lzip"]="cpio"
_PROFILE_GRAPH["lzless"]="cpio"
_PROFILE_GRAPH["lzma"]="cpio"
_PROFILE_GRAPH["lzmadec"]="xzdec"
_PROFILE_GRAPH["lzmainfo"]="cpio"
_PROFILE_GRAPH["lzmore"]="cpio"
_PROFILE_GRAPH["lzop"]="cpio"
_PROFILE_GRAPH["make"]="build-systems-common"
_PROFILE_GRAPH["makedeb"]="makepkg"
_PROFILE_GRAPH["masterpdfeditor4"]="masterpdfeditor"
_PROFILE_GRAPH["masterpdfeditor5"]="masterpdfeditor"
_PROFILE_GRAPH["mate-calculator"]="mate-calc"
_PROFILE_GRAPH["mathematica"]="Mathematica"
_PROFILE_GRAPH["matrix-mirage"]="mirage"
_PROFILE_GRAPH["mattermost-desktop"]="electron-common"
_PROFILE_GRAPH["md5sum"]="hasher-common"
_PROFILE_GRAPH["megaglest_editor"]="megaglest"
_PROFILE_GRAPH["mencoder"]="mplayer"
_PROFILE_GRAPH["meson"]="build-systems-common"
_PROFILE_GRAPH["microsoft-edge"]="chromium-common"
_PROFILE_GRAPH["microsoft-edge-beta"]="chromium-common"
_PROFILE_GRAPH["microsoft-edge-dev"]="chromium-common"
_PROFILE_GRAPH["microsoft-edge-stable"]="microsoft-edge"
_PROFILE_GRAPH["min"]="chromium-common"
_PROFILE_GRAPH["mov-cli"]="mpv"
_PROFILE_GRAPH["mp3wrap"]="mp3splt"
_PROFILE_GRAPH["mpg123-alsa"]="mpg123"
_PROFILE_GRAPH["mpg123-id3dump"]="mpg123"
_PROFILE_GRAPH["mpg123-jack"]="mpg123"
_PROFILE_GRAPH["mpg123-nas"]="mpg123"
_PROFILE_GRAPH["mpg123-openal"]="mpg123"
_PROFILE_GRAPH["mpg123-oss"]="mpg123"
_PROFILE_GRAPH["mpg123-portaudio"]="mpg123"
_PROFILE_GRAPH["mpg123-pulse"]="mpg123"
_PROFILE_GRAPH["mpg123-strip"]="mpg123"
_PROFILE_GRAPH["ms-excel"]="ms-office"
_PROFILE_GRAPH["ms-onenote"]="ms-office"
_PROFILE_GRAPH["ms-outlook"]="ms-office"
_PROFILE_GRAPH["ms-powerpoint"]="ms-office"
_PROFILE_GRAPH["ms-skype"]="ms-office"
_PROFILE_GRAPH["ms-word"]="ms-office"
_PROFILE_GRAPH["multimc"]="multimc5"
_PROFILE_GRAPH["mupdf-gl"]="mupdf"
_PROFILE_GRAPH["mupdf-x11"]="mupdf"
_PROFILE_GRAPH["mupdf-x11-curl"]="mupdf"
_PROFILE_GRAPH["muraster"]="mupdf"
_PROFILE_GRAPH["mutool"]="mupdf"
_PROFILE_GRAPH["mypaint-ora-thumbnailer"]="mypaint"
_PROFILE_GRAPH["nautilus"]="file-manager-common"
_PROFILE_GRAPH["ncdu2"]="ncdu"
_PROFILE_GRAPH["nemo"]="file-manager-common"
_PROFILE_GRAPH["neverball-wrapper"]="neverball"
_PROFILE_GRAPH["neverputt"]="neverball"
_PROFILE_GRAPH["neverputt-wrapper"]="neverputt"
_PROFILE_GRAPH["newsbeuter"]="newsboat"
_PROFILE_GRAPH["nextcloud-desktop"]="nextcloud"
_PROFILE_GRAPH["nitroshare-cli"]="nitroshare"
_PROFILE_GRAPH["nitroshare-nmh"]="nitroshare"
_PROFILE_GRAPH["nitroshare-send"]="nitroshare"
_PROFILE_GRAPH["nitroshare-ui"]="nitroshare"
_PROFILE_GRAPH["node"]="nodejs-common"
_PROFILE_GRAPH["node-gyp"]="nodejs-common"
_PROFILE_GRAPH["notable"]="electron-common"
_PROFILE_GRAPH["npm"]="nodejs-common"
_PROFILE_GRAPH["npx"]="nodejs-common"
_PROFILE_GRAPH["nuclear"]="electron-common"
_PROFILE_GRAPH["obsidian"]="electron-common"
_PROFILE_GRAPH["oggsplt"]="mp3splt"
_PROFILE_GRAPH["onionshare"]="onionshare-gui"
_PROFILE_GRAPH["onionshare-cli"]="onionshare-gui"
_PROFILE_GRAPH["ooffice"]="libreoffice"
_PROFILE_GRAPH["ooviewdoc"]="libreoffice"
_PROFILE_GRAPH["openarena_ded"]="openarena"
_PROFILE_GRAPH["openmw-launcher"]="openmw"
_PROFILE_GRAPH["openshot-qt"]="openshot"
_PROFILE_GRAPH["opera"]="chromium-common"
_PROFILE_GRAPH["opera-beta"]="chromium-common"
_PROFILE_GRAPH["opera-developer"]="chromium-common"
_PROFILE_GRAPH["out123"]="mpg123"
_PROFILE_GRAPH["p7zip"]="7z"
_PROFILE_GRAPH["palemoon"]="firefox-common"
_PROFILE_GRAPH["pavucontrol-qt"]="pavucontrol"
_PROFILE_GRAPH["pcmanfm"]="file-manager-common"
_PROFILE_GRAPH["pdflatex"]="latex-common"
_PROFILE_GRAPH["pinball-wrapper"]="pinball"
_PROFILE_GRAPH["pip"]="build-systems-common"
_PROFILE_GRAPH["pipe-viewer"]="youtube-viewers-common"
_PROFILE_GRAPH["pipe-viewer-gtk"]="gtk-youtube-viewers-common pipe-viewer"
_PROFILE_GRAPH["planmaker18"]="softmaker-common"
_PROFILE_GRAPH["planmaker18free"]="softmaker-common"
_PROFILE_GRAPH["playonlinux"]="wine"
_PROFILE_GRAPH["pnpm"]="nodejs-common"
_PROFILE_GRAPH["pnpx"]="nodejs-common"
_PROFILE_GRAPH["postman"]="electron-common"
_PROFILE_GRAPH["presentations18"]="softmaker-common"
_PROFILE_GRAPH["presentations18free"]="softmaker-common"
_PROFILE_GRAPH["pycharm-professional"]="pycharm-community"
_PROFILE_GRAPH["pzstd"]="zstd"
_PROFILE_GRAPH["qemu-launcher"]="qemu-common"
_PROFILE_GRAPH["qemu-system-x86_64"]="qemu-common"
_PROFILE_GRAPH["qq"]="linuxqq"
_PROFILE_GRAPH["qt-faststart"]="ffmpeg"
_PROFILE_GRAPH["quadrapassel"]="gnome_games-common"
_PROFILE_GRAPH["qupzilla"]="falkon"
_PROFILE_GRAPH["ranger"]="file-manager-common"
_PROFILE_GRAPH["rhash"]="hasher-common"
_PROFILE_GRAPH["rhythmbox-client"]="rhythmbox"
_PROFILE_GRAPH["riot-desktop"]="riot-web"
_PROFILE_GRAPH["riot-web"]="electron-common"
_PROFILE_GRAPH["rnano"]="nano"
_PROFILE_GRAPH["rocketchat"]="electron-common"
_PROFILE_GRAPH["rtin"]="tin"
_PROFILE_GRAPH["rview"]="vim"
_PROFILE_GRAPH["rvim"]="vim"
_PROFILE_GRAPH["scorched3d-wrapper"]="scorched3d"
_PROFILE_GRAPH["scp"]="ssh"
_PROFILE_GRAPH["seahorse-daemon"]="seahorse"
_PROFILE_GRAPH["seahorse-tool"]="seahorse"
_PROFILE_GRAPH["seamonkey-bin"]="seamonkey"
_PROFILE_GRAPH["secret-tool"]="gnome-keyring"
_PROFILE_GRAPH["semver"]="nodejs-common"
_PROFILE_GRAPH["session-messenger"]="session-desktop"
_PROFILE_GRAPH["session-messenger-desktop"]="session-desktop"
_PROFILE_GRAPH["sftp"]="ssh"
_PROFILE_GRAPH["sha1sum"]="hasher-common"
_PROFILE_GRAPH["sha224sum"]="hasher-common"
_PROFILE_GRAPH["sha256sum"]="hasher-common"
_PROFILE_GRAPH["sha384sum"]="hasher-common"
_PROFILE_GRAPH["sha512sum"]="hasher-common"
_PROFILE_GRAPH["signal-desktop"]="electron-common"
_PROFILE_GRAPH["skypeforlinux"]="electron-common"
_PROFILE_GRAPH["slack"]="electron-common"
_PROFILE_GRAPH["snox"]="chromium-common"
_PROFILE_GRAPH["soffice"]="libreoffice"
_PROFILE_GRAPH["standard-notes"]="standardnotes-desktop"
_PROFILE_GRAPH["start-tor-browser"]="start-tor-browser_desktop"
_PROFILE_GRAPH["steam-native"]="steam"
_PROFILE_GRAPH["steam-runtime"]="steam"
_PROFILE_GRAPH["straw-viewer"]="youtube-viewers-common"
_PROFILE_GRAPH["sum"]="hasher-common"
_PROFILE_GRAPH["supertuxkart-wrapper"]="supertuxkart"
_PROFILE_GRAPH["swell-foop"]="gnome_games-common"
_PROFILE_GRAPH["sylpheed"]="email-common"
_PROFILE_GRAPH["sysprof-cli"]="sysprof"
_PROFILE_GRAPH["tar"]="archiver-common"
_PROFILE_GRAPH["tb-starter-wrapper"]="torbrowser-launcher"
_PROFILE_GRAPH["teams"]="electron-common"
_PROFILE_GRAPH["teams-for-linux"]="electron-common"
_PROFILE_GRAPH["telegram-desktop"]="telegram"
_PROFILE_GRAPH["termshark"]="wireshark"
_PROFILE_GRAPH["tex"]="latex-common"
_PROFILE_GRAPH["textmaker18"]="softmaker-common"
_PROFILE_GRAPH["textmaker18free"]="softmaker-common"
_PROFILE_GRAPH["thunar"]="Thunar"
_PROFILE_GRAPH["thunderbird"]="firefox-common"
_PROFILE_GRAPH["thunderbird-beta"]="thunderbird"
_PROFILE_GRAPH["thunderbird-wayland"]="thunderbird"
_PROFILE_GRAPH["tidal-hifi"]="electron-common"
_PROFILE_GRAPH["tor-browser"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ar"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ca"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-cs"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-da"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-de"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-el"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-en"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-en-us"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-es"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-es-es"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-fa"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-fr"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ga-ie"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-he"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-hu"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-id"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-is"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-it"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ja"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ka"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ko"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-nb"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-nl"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-pl"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-pt-br"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-ru"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-sv-se"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-tr"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-vi"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-zh-cn"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser-zh-tw"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ar"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ca"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_cs"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_da"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_de"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_el"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_en"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_en-US"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_es"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_es-ES"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_fa"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_fr"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ga-IE"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_he"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_hu"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_id"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_is"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_it"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ja"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ka"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ko"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_nb"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_nl"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_pl"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_pt-BR"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_ru"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_sv-SE"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_tr"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_vi"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_zh-CN"]="torbrowser-launcher"
_PROFILE_GRAPH["tor-browser_zh-TW"]="torbrowser-launcher"
_PROFILE_GRAPH["torbrowser"]="firefox-common"
_PROFILE_GRAPH["tqemu"]="qemu-common"
_PROFILE_GRAPH["transmission-cli"]="transmission-common"
_PROFILE_GRAPH["transmission-create"]="transmission-common"
_PROFILE_GRAPH["transmission-daemon"]="transmission-common"
_PROFILE_GRAPH["transmission-edit"]="transmission-common"
_PROFILE_GRAPH["transmission-gtk"]="transmission-common"
_PROFILE_GRAPH["transmission-qt"]="transmission-common"
_PROFILE_GRAPH["transmission-remote"]="transmission-common"
_PROFILE_GRAPH["transmission-remote-cli"]="transmission-common"
_PROFILE_GRAPH["transmission-remote-gtk"]="transmission-common"
_PROFILE_GRAPH["transmission-show"]="transmission-common"
_PROFILE_GRAPH["tshark"]="wireshark"
_PROFILE_GRAPH["tuir"]="rtv"
_PROFILE_GRAPH["tutanota-desktop"]="electron-common"
_PROFILE_GRAPH["twitch"]="electron-common"
_PROFILE_GRAPH["unar"]="ar"
_PROFILE_GRAPH["uncompress"]="gzip"
_PROFILE_GRAPH["unlz4"]="lz4"
_PROFILE_GRAPH["unlzma"]="cpio"
_PROFILE_GRAPH["unrar"]="archiver-common"
_PROFILE_GRAPH["unxz"]="cpio"
_PROFILE_GRAPH["unzip"]="archiver-common"
_PROFILE_GRAPH["unzstd"]="zstd"
_PROFILE_GRAPH["upscayl"]="electron-common"
_PROFILE_GRAPH["vimcat"]="vim"
_PROFILE_GRAPH["vimdiff"]="vim"
_PROFILE_GRAPH["vimpager"]="vim"
_PROFILE_GRAPH["vimtutor"]="vim"
_PROFILE_GRAPH["vivaldi"]="chromium-common"
_PROFILE_GRAPH["vivaldi-beta"]="vivaldi"
_PROFILE_GRAPH["vivaldi-snapshot"]="vivaldi"
_PROFILE_GRAPH["vivaldi-stable"]="vivaldi"
_PROFILE_GRAPH["vmplayer"]="vmware"
_PROFILE_GRAPH["vmware-player"]="vmware"
_PROFILE_GRAPH["vmware-workstation"]="vmware"
_PROFILE_GRAPH["vscodium"]="code"
_PROFILE_GRAPH["vulturesclaw"]="nethack-vultures"
_PROFILE_GRAPH["vultureseye"]="nethack-vultures"
_PROFILE_GRAPH["waterfox"]="firefox-common"
_PROFILE_GRAPH["waterfox-classic"]="waterfox"
_PROFILE_GRAPH["waterfox-current"]="waterfox"
_PROFILE_GRAPH["weechat-curses"]="weechat"
_PROFILE_GRAPH["wget2"]="wget"
_PROFILE_GRAPH["whalebird"]="electron-common"
_PROFILE_GRAPH["wire-desktop"]="electron-common"
_PROFILE_GRAPH["wireshark-gtk"]="wireshark"
_PROFILE_GRAPH["wireshark-qt"]="wireshark"
_PROFILE_GRAPH["wpp"]="wps"
_PROFILE_GRAPH["wpspdf"]="wps"
_PROFILE_GRAPH["xlinks"]="links"
_PROFILE_GRAPH["xlinks2"]="links2"
_PROFILE_GRAPH["xonotic-glx"]="xonotic"
_PROFILE_GRAPH["xonotic-sdl"]="xonotic"
_PROFILE_GRAPH["xonotic-sdl-wrapper"]="xonotic"
_PROFILE_GRAPH["xournalpp"]="xournal"
_PROFILE_GRAPH["xplayer-audio-preview"]="xplayer"
_PROFILE_GRAPH["xplayer-video-thumbnailer"]="xplayer"
_PROFILE_GRAPH["xreader-previewer"]="xreader"
_PROFILE_GRAPH["xreader-thumbnailer"]="xreader"
_PROFILE_GRAPH["xxd"]="cpio"
_PROFILE_GRAPH["xz"]="cpio"
_PROFILE_GRAPH["xzcat"]="cpio"
_PROFILE_GRAPH["xzcmp"]="cpio"
_PROFILE_GRAPH["xzdec"]="archiver-common"
_PROFILE_GRAPH["xzdiff"]="cpio"
_PROFILE_GRAPH["xzegrep"]="cpio"
_PROFILE_GRAPH["xzfgrep"]="cpio"
_PROFILE_GRAPH["xzgrep"]="cpio"
_PROFILE_GRAPH["xzless"]="cpio"
_PROFILE_GRAPH["xzmore"]="cpio"
_PROFILE_GRAPH["yandex-browser"]="chromium-common"
_PROFILE_GRAPH["yarn"]="nodejs-common"
_PROFILE_GRAPH["youtube"]="electron-common"
_PROFILE_GRAPH["youtube-dl"]="yt-dlp"
_PROFILE_GRAPH["youtube-viewer"]="youtube-viewers-common"
_PROFILE_GRAPH["youtube-viewer-gtk"]="gtk-youtube-viewers-common youtube-viewer"
_PROFILE_GRAPH["youtubemusic-nativefier"]="electron-common"
_PROFILE_GRAPH["ytmdesktop"]="electron-common"
_PROFILE_GRAPH["zcat"]="gzip"
_PROFILE_GRAPH["zcmp"]="gzip"
_PROFILE_GRAPH["zdiff"]="gzip"
_PROFILE_GRAPH["zegrep"]="gzip"
_PROFILE_GRAPH["zfgrep"]="gzip"
_PROFILE_GRAPH["zforce"]="gzip"
_PROFILE_GRAPH["zgrep"]="gzip"
_PROFILE_GRAPH["zless"]="gzip"
_PROFILE_GRAPH["zlib-flate"]="qpdf"
_PROFILE_GRAPH["zmore"]="gzip"
_PROFILE_GRAPH["znew"]="gzip"
_PROFILE_GRAPH["zoom"]="electron-common"
_PROFILE_GRAPH["zpaq"]="cpio"
_PROFILE_GRAPH["zstd"]="archiver-common"
_PROFILE_GRAPH["zstdcat"]="zstd"
_PROFILE_GRAPH["zstdgrep"]="zstd"
_PROFILE_GRAPH["zstdless"]="zstd"
_PROFILE_GRAPH["zstdmt"]="zstd"

declare -A _SCOPE=(
	["X"]="ban"
	["Xephyr"]="ban" # Breaks --x11=xephyr
	["xpra"]="ban" # Causes Authorization required, but no authorization protocol specified
	["Xvfb"]="ban" # Breaks --x11=xvfb
	["x-terminal-emulator"]="ban"
)

CFLAGS_HARDENED_USE_CASES="secure-critical sandbox sensitive-data untrusted-data"
DOTTED_FILENAMES=(
blender-2.8
blender-3.6
blink-common-hardened.inc
chromium-common-hardened.inc
com.github.bleakgrey.tootle
com.github.dahenson.agenda
com.github.johnfactotum.Foliate
com.github.phase1geo.minder
com.github.tchx84.Flatseal
com.gitlab.newsflash
display-im6.q16
electron-common-hardened.inc
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
Discord DiscordCanary DiscordPTB Documents FBReader FossaMail Fritzing Gitter
JDownloader Logs Maelstrom Maps Mathematica Natron PCSX2 PPSSPPQt PPSSPPSDL
Postman QMediathekView QOwnNotes Screenshot Telegram Thunar Viber VirtualBox
XMind Xephyr Xvfb ZeGrapher abiword abrowser acat adiff agetpkg akonadi_control
akregator alacarte alienarena alienarena-wrapper alienblaster alpine alpinef
als amarok amule amuled android-studio ani-cli anki anydesk aosp apack apktool
apostrophe ar arch-audit archaudit-report archiver-common ardour4 ardour5
arduino arepack aria2c aria2p aria2rpc ark arm armcord artha assogiate asunder
atom atom-beta atool atril atril-previewer atril-thumbnailer audacious audacity
audio-recorder aunpack authenticator authenticator-rs autokey-common
autokey-gtk autokey-qt autokey-run autokey-shell avidemux avidemux3_cli
avidemux3_jobs_qt5 avidemux3_qt5 aweather awesome axel b2sum b3sum ballbuster
ballbuster-wrapper baloo_file baloo_filemetadata_temp_extractor balsa baobab
barrier basilisk bcompare beaker bibletime bibtex bijiben bitcoin-qt bitlbee
bitwarden bitwarden-desktop blackbox bleachbit blender blender-2_8 blender-3_6
bless blink-common blink-common-hardened_inc blobby blobwars bluefish bnox
bpftop brackets brasero brave brave-browser brave-browser-beta
brave-browser-dev brave-browser-nightly brave-browser-stable brz bsdcat bsdcpio
bsdtar build-systems-common buku bundle bunzip2 bzcat bzflag bzip2 bzr
cachy-browser caja calibre calligra calligraauthor calligraconverter
calligraflow calligragemini calligraplan calligraplanwork calligrasheets
calligrastage calligrawords cameramonitor cantata caprine cargo catfish cawbird
celluloid chafa chatterino checkbashisms cheese cherrytree chromium
chromium-browser chromium-browser-privacy chromium-common
chromium-common-hardened_inc chromium-freeworld cin cinelerra cinelerra-gg
cksum clac clamav clamdscan clamdtop clamscan clamtk claws-mail clawsker
clementine clion clion-eap clipgrab clipit cliqz clocks cloneit cmake cmus code
code-oss codium cointop cola colorful colorful-wrapper
com_github_bleakgrey_tootle com_github_dahenson_agenda
com_github_johnfactotum_Foliate com_github_phase1geo_minder
com_github_tchx84_Flatseal com_gitlab_newsflash conkeror conky conplay corebird
cower coyim cpio crawl crawl-tiles crow cryptocat curl cvlc cyberfox d-feet
d-spy daisy darktable dbus-debug-common dbus-send dconf dconf-editor ddgr ddgtk
deadbeef deadlink default deluge desktopeditors devhelp devilspie devilspie2
dex2jar dexios dia dig digikam dillo dino dino-im discord discord-canary
discord-common discord-ptb display display-im6_q16 dnox dnscrypt-proxy dnsmasq
dolphin dolphin-emu dooble dooble-qt4 dosbox dragon drawio drill dropbox dtui
easystroke ebook-convert ebook-edit ebook-meta ebook-polish ebook-viewer
editorconfiger electron-cash electron-common electron-common-hardened_inc
electron-mail electrum element-desktop elinks emacs email-common empathy
enchant enchant-2 enchant-lsmod enchant-lsmod-2 engrampa enox enpass eo-common
eog eom ephemeral epiphany equalx erd et etr etr-wrapper evince
evince-previewer evince-thumbnailer evolution exfalso exiftool falkon fbreader
fdns feedreader feh feh-network_inc ferdi fetchmail ffmpeg ffmpegthumbnailer
ffplay ffprobe file file-manager-common file-roller filezilla firedragon
firefox firefox-beta firefox-common firefox-common-addons
firefox-developer-edition firefox-esr firefox-nightly firefox-wayland
firefox-x11 five-or-more fix-qdf flacsplt flameshot flashpeak-slimjet floorp
flowblade fluffychat fluxbox foliate font-manager fontforge fossamail
four-in-a-row fractal franz freecad freecadcmd freeciv freeciv-gtk3
freeciv-mp-gtk3 freecol freemind freeoffice-planmaker freeoffice-presentations
freeoffice-textmaker freetube freshclam frogatto frozen-bubble ftp funnyboat
gajim gajim-history-manager galculator gallery-dl gapplication gcalccmd gcloud
gconf gconf-editor gconf-merge-schema gconf-merge-tree gconfpkg gconftool-2 gdu
geany geary gedit geekbench geeqie geki2 geki3 gfeeds gget gh ghb ghostwriter
gimp gimp-2_10 gimp-2_8 gist gist-paste git git-cola gitg github-desktop gitter
gjs gl-117 gl-117-wrapper glaxium glaxium-wrapper globaltime gmpc gnome-2048
gnome-books gnome-boxes gnome-builder gnome-calculator gnome-calendar
gnome-character-map gnome-characters gnome-chess gnome-clocks gnome-contacts
gnome-documents gnome-font-viewer gnome-hexgl gnome-keyring gnome-keyring-3
gnome-keyring-daemon gnome-klotski gnome-latex gnome-logs gnome-mahjongg
gnome-maps gnome-mines gnome-mplayer gnome-mpv gnome-music gnome-nettool
gnome-nibbles gnome-passwordsafe gnome-photos gnome-pie gnome-pomodoro
gnome-recipes gnome-ring gnome-robots gnome-schedule gnome-screenshot
gnome-sound-recorder gnome-sudoku gnome-system-log gnome-taquin gnome-tetravex
gnome-todo gnome-twitch gnome-weather gnome_games-common gnote gnubik godot
godot3 goldendict goobox google-chrome google-chrome-beta google-chrome-stable
google-chrome-unstable google-earth google-earth-pro
google-play-music-desktop-player googler googler-common gpa gpg gpg-agent gpg2
gpicview gpredict gradio gramps gravity-beams-and-evaporating-stars
green-recoder gsettings gsettings-data-convert gsettings-schema-convert gtar
gthumb gtk-lbry-viewer gtk-pipe-viewer gtk-straw-viewer gtk-update-icon-cache
gtk-youtube-viewer gtk-youtube-viewers-common gtk2-youtube-viewer
gtk3-youtube-viewer guayadeque gucharmap gummi gunzip guvcview gwenview gzexe
gzip handbrake handbrake-gtk hashcat hasher-common hedgewars hexchat highlight
hitori homebank host hugin hyperrogue i2prouter i3 iagno icecat icedove
iceweasel idea ideaIC idea_sh imagej img2txt impressive imv inkscape inkview
inox io_github_lainsce_Notejot ipcalc ipcalc-ng iridium iridium-browser irssi
itch jami jami-gnome jd-gui jdownloader jerry jitsi jitsi-meet-desktop
journal-viewer jumpnbump jumpnbump-menu k3b kaffeine kalgebra kalgebramobile
karbon kate kazam kcalc kdeinit4 kdenlive kdiff3 keepass keepass2 keepassx
keepassx2 keepassxc keepassxc-cli keepassxc-proxy kfind kget kid3 kid3-cli
kid3-qt kino kiwix-desktop klatexformula klatexformula_cmdl klavaro kmail
kmplayer knotes kodi kontact konversation kopete koreader krita krunner
ktorrent ktouch kube kwin_x11 kwrite latex latex-common lbreakouthd lbry-viewer
lbry-viewer-gtk lbunzip2 lbzcat lbzip2 leafpad ledger-live-desktop less lettura
librecad libreoffice librewolf librewolf-nightly lifeograph liferea lightsoff
lincity-ng links links-common links2 linphone linuxqq lmms lobase lobster
localc localsend_app lodraw loffice lofromtemplate loimpress lollypop lomath
loupe loweb lowriter lrunzip lrz lrzcat lrzip lrztar lrzuntar lsar lugaru
luminance-hdr lutris lximage-qt lxmusic lynx lyriek lyx lz4 lz4c lz4cat lzcat
lzcmp lzdiff lzegrep lzfgrep lzgrep lzip lzless lzma lzmadec lzmainfo lzmore
lzop macrofusion magicor make makedeb makepkg man manaplus marker
masterpdfeditor masterpdfeditor4 masterpdfeditor5 mate-calc mate-calculator
mate-color-select mate-dictionary mathematica matrix-mirage mattermost-desktop
mcabber mcomix md5sum mdr mediainfo mediathekview megaglest megaglest_editor
meld mencoder mendeleydesktop menulibre meson metadata-cleaner meteo-qt
microsoft-edge microsoft-edge-beta microsoft-edge-dev microsoft-edge-stable
midori mimetype min mindless minecraft-launcher minetest minitube mirage
mirrormagic mocp monero-wallet-cli mousepad mov-cli mp3splt mp3splt-gtk mp3wrap
mpDris2 mpd mpg123 mpg123-alsa mpg123-id3dump mpg123-jack mpg123-nas
mpg123-openal mpg123-oss mpg123-portaudio mpg123-pulse mpg123-strip mpg123_bin
mplayer mpsyt mpv mrrescue ms-excel ms-office ms-onenote ms-outlook
ms-powerpoint ms-skype ms-word mtpaint mullvad-browser multimc multimc5 mumble
mupdf mupdf-gl mupdf-x11 mupdf-x11-curl mupen64plus muraster musescore
musictube musixmatch mutool mutt mypaint mypaint-ora-thumbnailer nano natron
nautilus ncdu ncdu2 nemo neochat neomutt netactview nethack nethack-vultures
netsurf neverball neverball-wrapper neverputt neverputt-wrapper newsbeuter
newsboat newsflash nextcloud nextcloud-desktop nheko nhex nicotine nitroshare
nitroshare-cli nitroshare-nmh nitroshare-send nitroshare-ui node node-gyp
nodejs-common nomacs noprofile notable notify-send npm npx nslookup nuclear
nvim nylas nyx obs obsidian ocenaudio odt2txt oggsplt okular onboard onionshare
onionshare-cli onionshare-gui ooffice ooviewdoc open-invaders openarena
openarena_ded openbox opencity openclonk openmw openmw-launcher openoffice_org
openshot openshot-qt openstego openttd opera opera-beta opera-developer orage
org_gnome_NautilusPreviewer ostrichriders otter-browser out123 p7zip palemoon
pandoc parole parsecd patch pavucontrol pavucontrol-qt pcmanfm pcsxr pdfchain
pdflatex pdfmod pdfsam pdftotext peek penguin-command photoflare picard pidgin
pinball pinball-wrapper ping ping-hardened_inc pingus pinta pioneer pip
pipe-viewer pipe-viewer-gtk pithos pitivi pix pkglog planmaker18
planmaker18free playonlinux pluma plv pngquant pnpm pnpx polari postman ppsspp
pragha presentations18 presentations18free prismlauncher profanity psi psi-plus
pybitmessage pycharm-community pycharm-professional pzstd qbittorrent
qcomicbook qemu-common qemu-launcher qemu-system-x86_64 qgis qlipper qmmp qnapi
qpdf qpdfview qq qrencode qt-faststart qt5ct qt6ct qtox quadrapassel quassel
quaternion quiterss quodlibet qupzilla qutebrowser raincat rambox ranger
rawtherapee reader redeclipse rednotebook redshift regextester remmina
retroarch rhash rhythmbox rhythmbox-client ricochet riot-desktop riot-web
ripperx ristretto rnano rocketchat rpcs3 rssguard rsync-download_only rtin
rtorrent rtv rtv-addons runenpass_sh rview rvim rymdport sayonara scallion
scorched3d scorched3d-wrapper scorchwentbonkers scp scribus sdat2img
seafile-applet seahorse seahorse-adventures seahorse-daemon seahorse-tool
seamonkey seamonkey-bin secret-tool semver server servo session-desktop
session-messenger session-messenger-desktop sftp sha1sum sha224sum sha256sum
sha384sum sha512sum shellcheck shortwave shotcut shotwell signal-cli
signal-desktop silentarmy simple-scan simplescreenrecorder simutrans
singularity skanlite skypeforlinux slack slashem smplayer smtube
smuxi-frontend-gnome sniffnet snox soffice softmaker-common sol songrec
sound-juicer soundconverter spectacle spectral spectre-meltdown-checker spotify
sqlitebrowser ssh ssh-agent ssmtp standard-notes standardnotes-desktop
start-tor-browser start-tor-browser_desktop statusof steam steam-native
steam-runtime stellarium straw-viewer strawberry strings studio_sh
subdownloader sum supertux2 supertuxkart supertuxkart-wrapper surf sushi sway
swell-foop sylpheed syncthing synfigstudio sysprof sysprof-cli
system-log-common tar tb-starter-wrapper tcpdump teams teams-for-linux
teamspeak3 teeworlds telegram telegram-desktop telnet terasology termshark
tesseract tex textmaker18 textmaker18free textroom thunar thunderbird
thunderbird-beta thunderbird-wayland tidal-hifi tilp tin tiny-rdm tmux tor
tor-browser tor-browser-ar tor-browser-ca tor-browser-cs tor-browser-da
tor-browser-de tor-browser-el tor-browser-en tor-browser-en-us tor-browser-es
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
torbrowser-launcher torcs totem tqemu tracker transgui transmission-cli
transmission-common transmission-create transmission-daemon transmission-edit
transmission-gtk transmission-qt transmission-remote transmission-remote-cli
transmission-remote-gtk transmission-show tremc tremulous trojita truecraft
ts3client_runscript_sh tshark tuir tutanota-desktop tuxguitar tuxtype tvbrowser
tvnamer twitch typespeed udiskie uefitool uget-gtk unar unbound uncompress unf
unknown-horizons unlz4 unlzma unrar unxz unzip unzstd upscayl url-eater utox
uudeview uzbl-browser viewnior viking vim vimcat vimdiff vimpager vimtutor
virt-manager virtualbox vivaldi vivaldi-beta vivaldi-snapshot vivaldi-stable
vlc vmplayer vmware vmware-player vmware-view vmware-workstation vscodium
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
youtube-viewer youtube-viewer-gtk youtube-viewers-common
youtubemusic-nativefier yt-dlp ytmdesktop zaproxy zart zathura zcat zcmp zdiff
zeal zegrep zfgrep zforce zgrep zim zless zlib-flate zmore znew zoom zpaq zstd
zstdcat zstdgrep zstdless zstdmt zulip
)
FIREJAIL_PROFILES_IUSE="${FIREJAIL_PROFILES[@]/#/firejail_profiles_}"
#GEN_EBUILD=1 # Uncomment to regen ebuild parts
GUI_REQUIRED_USE="
firejail_profiles_1password? ( || ( xephyr xpra ) )
firejail_profiles_2048-qt? ( || ( xephyr xpra ) )
firejail_profiles_Books? ( || ( xephyr xpra ) )
firejail_profiles_Builder? ( || ( xephyr xpra ) )
firejail_profiles_Documents? ( || ( xephyr xpra ) )
firejail_profiles_Fritzing? ( || ( xephyr xpra ) )
firejail_profiles_Logs? ( || ( xephyr xpra ) )
firejail_profiles_Maps? ( || ( xephyr xpra ) )
firejail_profiles_PCSX2? ( || ( xephyr xpra ) )
firejail_profiles_QMediathekView? ( || ( xephyr xpra ) )
firejail_profiles_Screenshot? ( || ( xephyr xpra ) )
firejail_profiles_Viber? ( || ( xephyr xpra ) )
firejail_profiles_abiword? ( || ( xephyr xpra ) )
firejail_profiles_abrowser? ( || ( xephyr xpra ) )
firejail_profiles_akregator? ( || ( xephyr xpra ) )
firejail_profiles_alacarte? ( || ( xephyr xpra ) )
firejail_profiles_alienarena? ( || ( xephyr xpra ) )
firejail_profiles_alienarena-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_alienblaster? ( || ( xephyr xpra ) )
firejail_profiles_alpine? ( || ( xephyr xpra ) )
firejail_profiles_amarok? ( || ( xephyr xpra ) )
firejail_profiles_amule? ( || ( xephyr xpra ) )
firejail_profiles_anki? ( || ( xephyr xpra ) )
firejail_profiles_apostrophe? ( || ( xephyr xpra ) )
firejail_profiles_ark? ( || ( xephyr xpra ) )
firejail_profiles_armcord? ( || ( xephyr xpra ) )
firejail_profiles_artha? ( || ( xephyr xpra ) )
firejail_profiles_assogiate? ( || ( xephyr xpra ) )
firejail_profiles_atom? ( || ( xephyr xpra ) )
firejail_profiles_atril? ( || ( xephyr xpra ) )
firejail_profiles_audacious? ( || ( xephyr xpra ) )
firejail_profiles_audacity? ( || ( xephyr xpra ) )
firejail_profiles_authenticator-rs? ( || ( xephyr xpra ) )
firejail_profiles_autokey-gtk? ( || ( xephyr xpra ) )
firejail_profiles_autokey-qt? ( || ( xephyr xpra ) )
firejail_profiles_avidemux? ( || ( xephyr xpra ) )
firejail_profiles_avidemux3_jobs_qt5? ( || ( xephyr xpra ) )
firejail_profiles_avidemux3_qt5? ( || ( xephyr xpra ) )
firejail_profiles_ballbuster-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_baloo_file? ( || ( xephyr xpra ) )
firejail_profiles_balsa? ( || ( xephyr xpra ) )
firejail_profiles_basilisk? ( || ( xephyr xpra ) )
firejail_profiles_beaker? ( || ( xephyr xpra ) )
firejail_profiles_bijiben? ( || ( xephyr xpra ) )
firejail_profiles_bitcoin-qt? ( || ( xephyr xpra ) )
firejail_profiles_bitwarden? ( || ( xephyr xpra ) )
firejail_profiles_blobby? ( || ( xephyr xpra ) )
firejail_profiles_bluefish? ( || ( xephyr xpra ) )
firejail_profiles_bnox? ( || ( xephyr xpra ) )
firejail_profiles_brasero? ( || ( xephyr xpra ) )
firejail_profiles_brave? ( || ( xephyr xpra ) )
firejail_profiles_brave-browser? ( || ( xephyr xpra ) )
firejail_profiles_cachy-browser? ( || ( xephyr xpra ) )
firejail_profiles_calligra? ( || ( xephyr xpra ) )
firejail_profiles_calligraauthor? ( || ( xephyr xpra ) )
firejail_profiles_calligraconverter? ( || ( xephyr xpra ) )
firejail_profiles_calligraflow? ( || ( xephyr xpra ) )
firejail_profiles_calligragemini? ( || ( xephyr xpra ) )
firejail_profiles_calligraplan? ( || ( xephyr xpra ) )
firejail_profiles_calligraplanwork? ( || ( xephyr xpra ) )
firejail_profiles_calligrasheets? ( || ( xephyr xpra ) )
firejail_profiles_calligrastage? ( || ( xephyr xpra ) )
firejail_profiles_calligrawords? ( || ( xephyr xpra ) )
firejail_profiles_cantata? ( || ( xephyr xpra ) )
firejail_profiles_caprine? ( || ( xephyr xpra ) )
firejail_profiles_cawbird? ( || ( xephyr xpra ) )
firejail_profiles_celluloid? ( || ( xephyr xpra ) )
firejail_profiles_chatterino? ( || ( xephyr xpra ) )
firejail_profiles_cheese? ( || ( xephyr xpra ) )
firejail_profiles_chromium? ( || ( xephyr xpra ) )
firejail_profiles_chromium-browser? ( || ( xephyr xpra ) )
firejail_profiles_chromium-browser-privacy? ( || ( xephyr xpra ) )
firejail_profiles_chromium-freeworld? ( || ( xephyr xpra ) )
firejail_profiles_cinelerra? ( || ( xephyr xpra ) )
firejail_profiles_clamtk? ( || ( xephyr xpra ) )
firejail_profiles_claws-mail? ( || ( xephyr xpra ) )
firejail_profiles_clawsker? ( || ( xephyr xpra ) )
firejail_profiles_clementine? ( || ( xephyr xpra ) )
firejail_profiles_cliqz? ( || ( xephyr xpra ) )
firejail_profiles_clocks? ( || ( xephyr xpra ) )
firejail_profiles_code? ( || ( xephyr xpra ) )
firejail_profiles_colorful-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_com_github_bleakgrey_tootle? ( || ( xephyr xpra ) )
firejail_profiles_com_github_dahenson_agenda? ( || ( xephyr xpra ) )
firejail_profiles_com_github_phase1geo_minder? ( || ( xephyr xpra ) )
firejail_profiles_com_github_tchx84_Flatseal? ( || ( xephyr xpra ) )
firejail_profiles_crow? ( || ( xephyr xpra ) )
firejail_profiles_cyberfox? ( || ( xephyr xpra ) )
firejail_profiles_dconf? ( || ( xephyr xpra ) )
firejail_profiles_dconf-editor? ( || ( xephyr xpra ) )
firejail_profiles_ddgtk? ( || ( xephyr xpra ) )
firejail_profiles_deluge? ( || ( xephyr xpra ) )
firejail_profiles_devhelp? ( || ( xephyr xpra ) )
firejail_profiles_digikam? ( || ( xephyr xpra ) )
firejail_profiles_dillo? ( || ( xephyr xpra ) )
firejail_profiles_dnox? ( || ( xephyr xpra ) )
firejail_profiles_dolphin-emu? ( || ( xephyr xpra ) )
firejail_profiles_dooble? ( || ( xephyr xpra ) )
firejail_profiles_dooble-qt4? ( || ( xephyr xpra ) )
firejail_profiles_electron-cash? ( || ( xephyr xpra ) )
firejail_profiles_electron-mail? ( || ( xephyr xpra ) )
firejail_profiles_electrum? ( || ( xephyr xpra ) )
firejail_profiles_enox? ( || ( xephyr xpra ) )
firejail_profiles_eog? ( || ( xephyr xpra ) )
firejail_profiles_ephemeral? ( || ( xephyr xpra ) )
firejail_profiles_epiphany? ( || ( xephyr xpra ) )
firejail_profiles_equalx? ( || ( xephyr xpra ) )
firejail_profiles_etr? ( || ( xephyr xpra ) )
firejail_profiles_etr-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_evince? ( || ( xephyr xpra ) )
firejail_profiles_evince-previewer? ( || ( xephyr xpra ) )
firejail_profiles_evince-thumbnailer? ( || ( xephyr xpra ) )
firejail_profiles_exfalso? ( || ( xephyr xpra ) )
firejail_profiles_falkon? ( || ( xephyr xpra ) )
firejail_profiles_feedreader? ( || ( xephyr xpra ) )
firejail_profiles_ferdi? ( || ( xephyr xpra ) )
firejail_profiles_ffmpeg? ( || ( xephyr xpra ) )
firejail_profiles_file-roller? ( || ( xephyr xpra ) )
firejail_profiles_firedragon? ( || ( xephyr xpra ) )
firejail_profiles_firefox? ( || ( xephyr xpra ) )
firejail_profiles_firefox-beta? ( || ( xephyr xpra ) )
firejail_profiles_firefox-developer-edition? ( || ( xephyr xpra ) )
firejail_profiles_firefox-esr? ( || ( xephyr xpra ) )
firejail_profiles_firefox-nightly? ( || ( xephyr xpra ) )
firejail_profiles_firefox-wayland? ( || ( xephyr xpra ) )
firejail_profiles_firefox-x11? ( || ( xephyr xpra ) )
firejail_profiles_five-or-more? ( || ( xephyr xpra ) )
firejail_profiles_flameshot? ( || ( xephyr xpra ) )
firejail_profiles_flashpeak-slimjet? ( || ( xephyr xpra ) )
firejail_profiles_floorp? ( || ( xephyr xpra ) )
firejail_profiles_fluffychat? ( || ( xephyr xpra ) )
firejail_profiles_foliate? ( || ( xephyr xpra ) )
firejail_profiles_fossamail? ( || ( xephyr xpra ) )
firejail_profiles_four-in-a-row? ( || ( xephyr xpra ) )
firejail_profiles_fractal? ( || ( xephyr xpra ) )
firejail_profiles_freecad? ( || ( xephyr xpra ) )
firejail_profiles_freeciv? ( || ( xephyr xpra ) )
firejail_profiles_freeciv-gtk3? ( || ( xephyr xpra ) )
firejail_profiles_freeciv-mp-gtk3? ( || ( xephyr xpra ) )
firejail_profiles_freetube? ( || ( xephyr xpra ) )
firejail_profiles_frozen-bubble? ( || ( xephyr xpra ) )
firejail_profiles_gajim? ( || ( xephyr xpra ) )
firejail_profiles_gapplication? ( || ( xephyr xpra ) )
firejail_profiles_gcalccmd? ( || ( xephyr xpra ) )
firejail_profiles_geany? ( || ( xephyr xpra ) )
firejail_profiles_geary? ( || ( xephyr xpra ) )
firejail_profiles_gedit? ( || ( xephyr xpra ) )
firejail_profiles_geeqie? ( || ( xephyr xpra ) )
firejail_profiles_geki2? ( || ( xephyr xpra ) )
firejail_profiles_geki3? ( || ( xephyr xpra ) )
firejail_profiles_gfeeds? ( || ( xephyr xpra ) )
firejail_profiles_ghostwriter? ( || ( xephyr xpra ) )
firejail_profiles_gimp? ( || ( xephyr xpra ) )
firejail_profiles_git-cola? ( || ( xephyr xpra ) )
firejail_profiles_gitg? ( || ( xephyr xpra ) )
firejail_profiles_github-desktop? ( || ( xephyr xpra ) )
firejail_profiles_gitter? ( || ( xephyr xpra ) )
firejail_profiles_gl-117? ( || ( xephyr xpra ) )
firejail_profiles_gl-117-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_glaxium? ( || ( xephyr xpra ) )
firejail_profiles_glaxium-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_gnome-2048? ( || ( xephyr xpra ) )
firejail_profiles_gnome-books? ( || ( xephyr xpra ) )
firejail_profiles_gnome-boxes? ( || ( xephyr xpra ) )
firejail_profiles_gnome-builder? ( || ( xephyr xpra ) )
firejail_profiles_gnome-calculator? ( || ( xephyr xpra ) )
firejail_profiles_gnome-calendar? ( || ( xephyr xpra ) )
firejail_profiles_gnome-character-map? ( || ( xephyr xpra ) )
firejail_profiles_gnome-characters? ( || ( xephyr xpra ) )
firejail_profiles_gnome-chess? ( || ( xephyr xpra ) )
firejail_profiles_gnome-clocks? ( || ( xephyr xpra ) )
firejail_profiles_gnome-contacts? ( || ( xephyr xpra ) )
firejail_profiles_gnome-documents? ( || ( xephyr xpra ) )
firejail_profiles_gnome-font-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gnome-hexgl? ( || ( xephyr xpra ) )
firejail_profiles_gnome-keyring? ( || ( xephyr xpra ) )
firejail_profiles_gnome-keyring-3? ( || ( xephyr xpra ) )
firejail_profiles_gnome-keyring-daemon? ( || ( xephyr xpra ) )
firejail_profiles_gnome-klotski? ( || ( xephyr xpra ) )
firejail_profiles_gnome-latex? ( || ( xephyr xpra ) )
firejail_profiles_gnome-logs? ( || ( xephyr xpra ) )
firejail_profiles_gnome-mahjongg? ( || ( xephyr xpra ) )
firejail_profiles_gnome-maps? ( || ( xephyr xpra ) )
firejail_profiles_gnome-mines? ( || ( xephyr xpra ) )
firejail_profiles_gnome-mplayer? ( || ( xephyr xpra ) )
firejail_profiles_gnome-mpv? ( || ( xephyr xpra ) )
firejail_profiles_gnome-music? ( || ( xephyr xpra ) )
firejail_profiles_gnome-nettool? ( || ( xephyr xpra ) )
firejail_profiles_gnome-nibbles? ( || ( xephyr xpra ) )
firejail_profiles_gnome-passwordsafe? ( || ( xephyr xpra ) )
firejail_profiles_gnome-photos? ( || ( xephyr xpra ) )
firejail_profiles_gnome-pie? ( || ( xephyr xpra ) )
firejail_profiles_gnome-pomodoro? ( || ( xephyr xpra ) )
firejail_profiles_gnome-recipes? ( || ( xephyr xpra ) )
firejail_profiles_gnome-ring? ( || ( xephyr xpra ) )
firejail_profiles_gnome-robots? ( || ( xephyr xpra ) )
firejail_profiles_gnome-schedule? ( || ( xephyr xpra ) )
firejail_profiles_gnome-screenshot? ( || ( xephyr xpra ) )
firejail_profiles_gnome-sound-recorder? ( || ( xephyr xpra ) )
firejail_profiles_gnome-sudoku? ( || ( xephyr xpra ) )
firejail_profiles_gnome-system-log? ( || ( xephyr xpra ) )
firejail_profiles_gnome-taquin? ( || ( xephyr xpra ) )
firejail_profiles_gnome-tetravex? ( || ( xephyr xpra ) )
firejail_profiles_gnome-todo? ( || ( xephyr xpra ) )
firejail_profiles_gnome-twitch? ( || ( xephyr xpra ) )
firejail_profiles_gnome-weather? ( || ( xephyr xpra ) )
firejail_profiles_gnote? ( || ( xephyr xpra ) )
firejail_profiles_gnubik? ( || ( xephyr xpra ) )
firejail_profiles_godot? ( || ( xephyr xpra ) )
firejail_profiles_godot3? ( || ( xephyr xpra ) )
firejail_profiles_google-chrome? ( || ( xephyr xpra ) )
firejail_profiles_google-chrome-beta? ( || ( xephyr xpra ) )
firejail_profiles_google-chrome-unstable? ( || ( xephyr xpra ) )
firejail_profiles_google-earth? ( || ( xephyr xpra ) )
firejail_profiles_google-earth-pro? ( || ( xephyr xpra ) )
firejail_profiles_gradio? ( || ( xephyr xpra ) )
firejail_profiles_gramps? ( || ( xephyr xpra ) )
firejail_profiles_green-recoder? ( || ( xephyr xpra ) )
firejail_profiles_gtk-lbry-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gtk-pipe-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gtk-straw-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gtk-update-icon-cache? ( || ( xephyr xpra ) )
firejail_profiles_gtk-youtube-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gtk2-youtube-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gtk3-youtube-viewer? ( || ( xephyr xpra ) )
firejail_profiles_gucharmap? ( || ( xephyr xpra ) )
firejail_profiles_guvcview? ( || ( xephyr xpra ) )
firejail_profiles_gwenview? ( || ( xephyr xpra ) )
firejail_profiles_handbrake-gtk? ( || ( xephyr xpra ) )
firejail_profiles_hexchat? ( || ( xephyr xpra ) )
firejail_profiles_hitori? ( || ( xephyr xpra ) )
firejail_profiles_homebank? ( || ( xephyr xpra ) )
firejail_profiles_hugin? ( || ( xephyr xpra ) )
firejail_profiles_i2prouter? ( || ( xephyr xpra ) )
firejail_profiles_iagno? ( || ( xephyr xpra ) )
firejail_profiles_icecat? ( || ( xephyr xpra ) )
firejail_profiles_icedove? ( || ( xephyr xpra ) )
firejail_profiles_iceweasel? ( || ( xephyr xpra ) )
firejail_profiles_impressive? ( || ( xephyr xpra ) )
firejail_profiles_inkscape? ( || ( xephyr xpra ) )
firejail_profiles_inox? ( || ( xephyr xpra ) )
firejail_profiles_io_github_lainsce_Notejot? ( || ( xephyr xpra ) )
firejail_profiles_iridium? ( || ( xephyr xpra ) )
firejail_profiles_jami? ( || ( xephyr xpra ) )
firejail_profiles_jami-gnome? ( || ( xephyr xpra ) )
firejail_profiles_jerry? ( || ( xephyr xpra ) )
firejail_profiles_jitsi-meet-desktop? ( || ( xephyr xpra ) )
firejail_profiles_journal-viewer? ( || ( xephyr xpra ) )
firejail_profiles_k3b? ( || ( xephyr xpra ) )
firejail_profiles_kaffeine? ( || ( xephyr xpra ) )
firejail_profiles_kate? ( || ( xephyr xpra ) )
firejail_profiles_kazam? ( || ( xephyr xpra ) )
firejail_profiles_kcalc? ( || ( xephyr xpra ) )
firejail_profiles_kdeinit4? ( || ( xephyr xpra ) )
firejail_profiles_kdenlive? ( || ( xephyr xpra ) )
firejail_profiles_kdiff3? ( || ( xephyr xpra ) )
firejail_profiles_keepassxc? ( || ( xephyr xpra ) )
firejail_profiles_kfind? ( || ( xephyr xpra ) )
firejail_profiles_kget? ( || ( xephyr xpra ) )
firejail_profiles_kid3? ( || ( xephyr xpra ) )
firejail_profiles_kid3-qt? ( || ( xephyr xpra ) )
firejail_profiles_klatexformula? ( || ( xephyr xpra ) )
firejail_profiles_kmplayer? ( || ( xephyr xpra ) )
firejail_profiles_kodi? ( || ( xephyr xpra ) )
firejail_profiles_konversation? ( || ( xephyr xpra ) )
firejail_profiles_kopete? ( || ( xephyr xpra ) )
firejail_profiles_krunner? ( || ( xephyr xpra ) )
firejail_profiles_ktorrent? ( || ( xephyr xpra ) )
firejail_profiles_ktouch? ( || ( xephyr xpra ) )
firejail_profiles_kube? ( || ( xephyr xpra ) )
firejail_profiles_kwin_x11? ( || ( xephyr xpra ) )
firejail_profiles_kwrite? ( || ( xephyr xpra ) )
firejail_profiles_lbreakouthd? ( || ( xephyr xpra ) )
firejail_profiles_lbry-viewer-gtk? ( || ( xephyr xpra ) )
firejail_profiles_leafpad? ( || ( xephyr xpra ) )
firejail_profiles_ledger-live-desktop? ( || ( xephyr xpra ) )
firejail_profiles_lettura? ( || ( xephyr xpra ) )
firejail_profiles_libreoffice? ( || ( xephyr xpra ) )
firejail_profiles_librewolf? ( || ( xephyr xpra ) )
firejail_profiles_lifeograph? ( || ( xephyr xpra ) )
firejail_profiles_lightsoff? ( || ( xephyr xpra ) )
firejail_profiles_linuxqq? ( || ( xephyr xpra ) )
firejail_profiles_lollypop? ( || ( xephyr xpra ) )
firejail_profiles_loupe? ( || ( xephyr xpra ) )
firejail_profiles_lximage-qt? ( || ( xephyr xpra ) )
firejail_profiles_lyx? ( || ( xephyr xpra ) )
firejail_profiles_man? ( || ( xephyr xpra ) )
firejail_profiles_marker? ( || ( xephyr xpra ) )
firejail_profiles_mate-calc? ( || ( xephyr xpra ) )
firejail_profiles_mattermost-desktop? ( || ( xephyr xpra ) )
firejail_profiles_mcomix? ( || ( xephyr xpra ) )
firejail_profiles_menulibre? ( || ( xephyr xpra ) )
firejail_profiles_metadata-cleaner? ( || ( xephyr xpra ) )
firejail_profiles_meteo-qt? ( || ( xephyr xpra ) )
firejail_profiles_microsoft-edge? ( || ( xephyr xpra ) )
firejail_profiles_microsoft-edge-beta? ( || ( xephyr xpra ) )
firejail_profiles_microsoft-edge-dev? ( || ( xephyr xpra ) )
firejail_profiles_midori? ( || ( xephyr xpra ) )
firejail_profiles_min? ( || ( xephyr xpra ) )
firejail_profiles_minecraft-launcher? ( || ( xephyr xpra ) )
firejail_profiles_minitube? ( || ( xephyr xpra ) )
firejail_profiles_mirage? ( || ( xephyr xpra ) )
firejail_profiles_mousepad? ( || ( xephyr xpra ) )
firejail_profiles_mp3splt-gtk? ( || ( xephyr xpra ) )
firejail_profiles_mumble? ( || ( xephyr xpra ) )
firejail_profiles_musictube? ( || ( xephyr xpra ) )
firejail_profiles_mutt? ( || ( xephyr xpra ) )
firejail_profiles_mypaint? ( || ( xephyr xpra ) )
firejail_profiles_nautilus? ( || ( xephyr xpra ) )
firejail_profiles_neochat? ( || ( xephyr xpra ) )
firejail_profiles_neomutt? ( || ( xephyr xpra ) )
firejail_profiles_netsurf? ( || ( xephyr xpra ) )
firejail_profiles_neverball-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_neverputt-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_newsflash? ( || ( xephyr xpra ) )
firejail_profiles_nextcloud? ( || ( xephyr xpra ) )
firejail_profiles_nheko? ( || ( xephyr xpra ) )
firejail_profiles_nitroshare? ( || ( xephyr xpra ) )
firejail_profiles_nomacs? ( || ( xephyr xpra ) )
firejail_profiles_notable? ( || ( xephyr xpra ) )
firejail_profiles_nuclear? ( || ( xephyr xpra ) )
firejail_profiles_obs? ( || ( xephyr xpra ) )
firejail_profiles_obsidian? ( || ( xephyr xpra ) )
firejail_profiles_ocenaudio? ( || ( xephyr xpra ) )
firejail_profiles_okular? ( || ( xephyr xpra ) )
firejail_profiles_onboard? ( || ( xephyr xpra ) )
firejail_profiles_onionshare-gui? ( || ( xephyr xpra ) )
firejail_profiles_open-invaders? ( || ( xephyr xpra ) )
firejail_profiles_openarena? ( || ( xephyr xpra ) )
firejail_profiles_openmw? ( || ( xephyr xpra ) )
firejail_profiles_openshot? ( || ( xephyr xpra ) )
firejail_profiles_openshot-qt? ( || ( xephyr xpra ) )
firejail_profiles_opera? ( || ( xephyr xpra ) )
firejail_profiles_opera-beta? ( || ( xephyr xpra ) )
firejail_profiles_opera-developer? ( || ( xephyr xpra ) )
firejail_profiles_org_gnome_NautilusPreviewer? ( || ( xephyr xpra ) )
firejail_profiles_otter-browser? ( || ( xephyr xpra ) )
firejail_profiles_palemoon? ( || ( xephyr xpra ) )
firejail_profiles_pavucontrol? ( || ( xephyr xpra ) )
firejail_profiles_pavucontrol-qt? ( || ( xephyr xpra ) )
firejail_profiles_pcmanfm? ( || ( xephyr xpra ) )
firejail_profiles_pcsxr? ( || ( xephyr xpra ) )
firejail_profiles_pdfchain? ( || ( xephyr xpra ) )
firejail_profiles_peek? ( || ( xephyr xpra ) )
firejail_profiles_photoflare? ( || ( xephyr xpra ) )
firejail_profiles_pidgin? ( || ( xephyr xpra ) )
firejail_profiles_pinball-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_pinta? ( || ( xephyr xpra ) )
firejail_profiles_pipe-viewer-gtk? ( || ( xephyr xpra ) )
firejail_profiles_pitivi? ( || ( xephyr xpra ) )
firejail_profiles_postman? ( || ( xephyr xpra ) )
firejail_profiles_ppsspp? ( || ( xephyr xpra ) )
firejail_profiles_pragha? ( || ( xephyr xpra ) )
firejail_profiles_psi? ( || ( xephyr xpra ) )
firejail_profiles_pybitmessage? ( || ( xephyr xpra ) )
firejail_profiles_qbittorrent? ( || ( xephyr xpra ) )
firejail_profiles_qcomicbook? ( || ( xephyr xpra ) )
firejail_profiles_qgis? ( || ( xephyr xpra ) )
firejail_profiles_qt-faststart? ( || ( xephyr xpra ) )
firejail_profiles_qt5ct? ( || ( xephyr xpra ) )
firejail_profiles_qt6ct? ( || ( xephyr xpra ) )
firejail_profiles_qtox? ( || ( xephyr xpra ) )
firejail_profiles_quadrapassel? ( || ( xephyr xpra ) )
firejail_profiles_quaternion? ( || ( xephyr xpra ) )
firejail_profiles_quodlibet? ( || ( xephyr xpra ) )
firejail_profiles_qupzilla? ( || ( xephyr xpra ) )
firejail_profiles_qutebrowser? ( || ( xephyr xpra ) )
firejail_profiles_raincat? ( || ( xephyr xpra ) )
firejail_profiles_rambox? ( || ( xephyr xpra ) )
firejail_profiles_rawtherapee? ( || ( xephyr xpra ) )
firejail_profiles_rednotebook? ( || ( xephyr xpra ) )
firejail_profiles_rhythmbox? ( || ( xephyr xpra ) )
firejail_profiles_riot-web? ( || ( xephyr xpra ) )
firejail_profiles_ripperx? ( || ( xephyr xpra ) )
firejail_profiles_ristretto? ( || ( xephyr xpra ) )
firejail_profiles_rocketchat? ( || ( xephyr xpra ) )
firejail_profiles_rssguard? ( || ( xephyr xpra ) )
firejail_profiles_rtv? ( || ( xephyr xpra ) )
firejail_profiles_rymdport? ( || ( xephyr xpra ) )
firejail_profiles_scorched3d-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_scribus? ( || ( xephyr xpra ) )
firejail_profiles_seahorse? ( || ( xephyr xpra ) )
firejail_profiles_seamonkey? ( || ( xephyr xpra ) )
firejail_profiles_seamonkey-bin? ( || ( xephyr xpra ) )
firejail_profiles_secret-tool? ( || ( xephyr xpra ) )
firejail_profiles_session-desktop? ( || ( xephyr xpra ) )
firejail_profiles_shortwave? ( || ( xephyr xpra ) )
firejail_profiles_shotcut? ( || ( xephyr xpra ) )
firejail_profiles_shotwell? ( || ( xephyr xpra ) )
firejail_profiles_signal-desktop? ( || ( xephyr xpra ) )
firejail_profiles_simutrans? ( || ( xephyr xpra ) )
firejail_profiles_singularity? ( || ( xephyr xpra ) )
firejail_profiles_skanlite? ( || ( xephyr xpra ) )
firejail_profiles_skypeforlinux? ( || ( xephyr xpra ) )
firejail_profiles_slack? ( || ( xephyr xpra ) )
firejail_profiles_smuxi-frontend-gnome? ( || ( xephyr xpra ) )
firejail_profiles_snox? ( || ( xephyr xpra ) )
firejail_profiles_spectacle? ( || ( xephyr xpra ) )
firejail_profiles_spectral? ( || ( xephyr xpra ) )
firejail_profiles_spotify? ( || ( xephyr xpra ) )
firejail_profiles_standardnotes-desktop? ( || ( xephyr xpra ) )
firejail_profiles_start-tor-browser_desktop? ( || ( xephyr xpra ) )
firejail_profiles_steam? ( || ( xephyr xpra ) )
firejail_profiles_supertuxkart? ( || ( xephyr xpra ) )
firejail_profiles_supertuxkart-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_surf? ( || ( xephyr xpra ) )
firejail_profiles_swell-foop? ( || ( xephyr xpra ) )
firejail_profiles_sylpheed? ( || ( xephyr xpra ) )
firejail_profiles_synfigstudio? ( || ( xephyr xpra ) )
firejail_profiles_sysprof? ( || ( xephyr xpra ) )
firejail_profiles_tb-starter-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_teams? ( || ( xephyr xpra ) )
firejail_profiles_teams-for-linux? ( || ( xephyr xpra ) )
firejail_profiles_teamspeak3? ( || ( xephyr xpra ) )
firejail_profiles_telegram? ( || ( xephyr xpra ) )
firejail_profiles_telegram-desktop? ( || ( xephyr xpra ) )
firejail_profiles_terasology? ( || ( xephyr xpra ) )
firejail_profiles_thunar? ( || ( xephyr xpra ) )
firejail_profiles_thunderbird? ( || ( xephyr xpra ) )
firejail_profiles_tidal-hifi? ( || ( xephyr xpra ) )
firejail_profiles_tiny-rdm? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ar? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ca? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-cs? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-da? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-de? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-el? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-en? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-en-us? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-es? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-es-es? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-fa? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-fr? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ga-ie? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-he? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-hu? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-id? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-is? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-it? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ja? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ka? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ko? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-nb? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-nl? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-pl? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-pt-br? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-ru? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-sv-se? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-tr? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-vi? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-zh-cn? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser-zh-tw? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ar? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ca? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_cs? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_da? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_de? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_el? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_en? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_en-US? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_es? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_es-ES? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_fa? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_fr? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ga-IE? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_he? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_hu? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_id? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_is? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_it? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ja? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ka? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ko? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_nb? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_nl? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_pl? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_pt-BR? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_ru? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_sv-SE? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_tr? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_vi? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_zh-CN? ( || ( xephyr xpra ) )
firejail_profiles_tor-browser_zh-TW? ( || ( xephyr xpra ) )
firejail_profiles_torbrowser? ( || ( xephyr xpra ) )
firejail_profiles_torbrowser-launcher? ( || ( xephyr xpra ) )
firejail_profiles_totem? ( || ( xephyr xpra ) )
firejail_profiles_transgui? ( || ( xephyr xpra ) )
firejail_profiles_transmission-gtk? ( || ( xephyr xpra ) )
firejail_profiles_transmission-qt? ( || ( xephyr xpra ) )
firejail_profiles_transmission-remote-gtk? ( || ( xephyr xpra ) )
firejail_profiles_trojita? ( || ( xephyr xpra ) )
firejail_profiles_tutanota-desktop? ( || ( xephyr xpra ) )
firejail_profiles_tuxtype? ( || ( xephyr xpra ) )
firejail_profiles_twitch? ( || ( xephyr xpra ) )
firejail_profiles_typespeed? ( || ( xephyr xpra ) )
firejail_profiles_udiskie? ( || ( xephyr xpra ) )
firejail_profiles_uget-gtk? ( || ( xephyr xpra ) )
firejail_profiles_unzip? ( || ( xephyr xpra ) )
firejail_profiles_upscayl? ( || ( xephyr xpra ) )
firejail_profiles_uzbl-browser? ( || ( xephyr xpra ) )
firejail_profiles_virt-manager? ( || ( xephyr xpra ) )
firejail_profiles_virtualbox? ( || ( xephyr xpra ) )
firejail_profiles_vivaldi? ( || ( xephyr xpra ) )
firejail_profiles_vlc? ( || ( xephyr xpra ) )
firejail_profiles_vmware? ( || ( xephyr xpra xvfb ) )
firejail_profiles_vmware-player? ( || ( xephyr xpra ) )
firejail_profiles_vmware-view? ( || ( xephyr xpra ) )
firejail_profiles_vscodium? ( || ( xephyr xpra ) )
firejail_profiles_warzone2100? ( || ( xephyr xpra ) )
firejail_profiles_waterfox? ( || ( xephyr xpra ) )
firejail_profiles_whalebird? ( || ( xephyr xpra ) )
firejail_profiles_wire-desktop? ( || ( xephyr xpra ) )
firejail_profiles_wireshark? ( || ( xephyr xpra ) )
firejail_profiles_wireshark-gtk? ( || ( xephyr xpra ) )
firejail_profiles_wireshark-qt? ( || ( xephyr xpra ) )
firejail_profiles_x-terminal-emulator? ( || ( xephyr xpra ) )
firejail_profiles_x2goclient? ( || ( xephyr xpra ) )
firejail_profiles_xchat? ( || ( xephyr xpra ) )
firejail_profiles_xfburn? ( || ( xephyr xpra ) )
firejail_profiles_xfce4-notes? ( || ( xephyr xpra ) )
firejail_profiles_xfce4-screenshooter? ( || ( xephyr xpra ) )
firejail_profiles_xmms? ( || ( xephyr xpra ) )
firejail_profiles_xonotic? ( || ( xephyr xpra ) )
firejail_profiles_xonotic-sdl? ( || ( xephyr xpra ) )
firejail_profiles_xonotic-sdl-wrapper? ( || ( xephyr xpra ) )
firejail_profiles_xpdf? ( || ( xephyr xpra ) )
firejail_profiles_yandex-browser? ( || ( xephyr xpra ) )
firejail_profiles_yelp? ( || ( xephyr xpra ) )
firejail_profiles_youtube? ( || ( xephyr xpra ) )
firejail_profiles_youtube-dl-gui? ( || ( xephyr xpra ) )
firejail_profiles_youtube-viewer-gtk? ( || ( xephyr xpra ) )
firejail_profiles_youtubemusic-nativefier? ( || ( xephyr xpra ) )
firejail_profiles_ytmdesktop? ( || ( xephyr xpra ) )
firejail_profiles_zathura? ( || ( xephyr xpra ) )
firejail_profiles_zeal? ( || ( xephyr xpra ) )
firejail_profiles_zim? ( || ( xephyr xpra ) )
firejail_profiles_zoom? ( || ( xephyr xpra ) )
"
HARDENED_ALLOCATORS_IUSE=(
	hardened_malloc
	mimalloc
	scudo
)
LLVM_COMPAT=( {18..16} )
declare -A _PATH_CORRECTION=(
	["spotify"]="/opt/spotify/spotify-client/spotify"
)
PYTHON_COMPAT=( python3_{9..12} )
TEST_SET="distro" # distro or full
X11_COMPAT=(
1password 2048-qt Books Builder Documents Fritzing Logs Maps PCSX2
QMediathekView Screenshot Viber abiword abrowser akregator alacarte alienarena
alienarena-wrapper alienblaster alpine amarok amule anki apostrophe ark armcord
artha assogiate atom atril audacious audacity authenticator-rs autokey-gtk
autokey-qt avidemux avidemux3_jobs_qt5 avidemux3_qt5 ballbuster-wrapper
baloo_file balsa basilisk beaker bijiben bitcoin-qt bitwarden blobby bluefish
bnox brasero brave brave-browser cachy-browser calligra calligraauthor
calligraconverter calligraflow calligragemini calligraplan calligraplanwork
calligrasheets calligrastage calligrawords cantata caprine cawbird celluloid
chatterino cheese chromium chromium-browser chromium-browser-privacy
chromium-freeworld cinelerra clamtk claws-mail clawsker clementine cliqz clocks
code colorful-wrapper com_github_bleakgrey_tootle com_github_dahenson_agenda
com_github_phase1geo_minder com_github_tchx84_Flatseal crow cyberfox dconf
dconf-editor ddgtk deluge devhelp digikam dillo dnox dolphin-emu dooble
dooble-qt4 electron-cash electron-mail electrum enox eog ephemeral epiphany
equalx etr etr-wrapper evince evince-previewer evince-thumbnailer exfalso
falkon feedreader ferdi ffmpeg file-roller firedragon firefox firefox-beta
firefox-developer-edition firefox-esr firefox-nightly firefox-wayland
firefox-x11 five-or-more flameshot flashpeak-slimjet floorp fluffychat foliate
fossamail four-in-a-row fractal freecad freeciv freeciv-gtk3 freeciv-mp-gtk3
freetube frozen-bubble gajim gapplication gcalccmd geany geary gedit geeqie
geki2 geki3 gfeeds ghostwriter gimp git-cola gitg github-desktop gitter gjs
gl-117 gl-117-wrapper glaxium glaxium-wrapper gnome-2048 gnome-books
gnome-boxes gnome-builder gnome-calculator gnome-calendar gnome-character-map
gnome-characters gnome-chess gnome-clocks gnome-contacts gnome-documents
gnome-font-viewer gnome-hexgl gnome-keyring gnome-keyring-3
gnome-keyring-daemon gnome-klotski gnome-latex gnome-logs gnome-mahjongg
gnome-maps gnome-mines gnome-mplayer gnome-mpv gnome-music gnome-nettool
gnome-nibbles gnome-passwordsafe gnome-photos gnome-pie gnome-pomodoro
gnome-recipes gnome-ring gnome-robots gnome-schedule gnome-screenshot
gnome-sound-recorder gnome-sudoku gnome-system-log gnome-taquin gnome-tetravex
gnome-todo gnome-twitch gnome-weather gnote gnubik godot godot3 google-chrome
google-chrome-beta google-chrome-unstable google-earth google-earth-pro gradio
gramps green-recoder gtk-lbry-viewer gtk-pipe-viewer gtk-straw-viewer
gtk-update-icon-cache gtk-youtube-viewer gtk2-youtube-viewer
gtk3-youtube-viewer gucharmap guvcview gwenview handbrake-gtk hexchat hitori
homebank hugin i2prouter iagno icecat icedove iceweasel impressive inkscape
inox io_github_lainsce_Notejot iridium jami jami-gnome jerry jitsi-meet-desktop
journal-viewer k3b kaffeine kate kazam kcalc kdeinit4 kdenlive kdiff3 keepassxc
kfind kget kid3 kid3-qt klatexformula kmplayer kodi konversation kopete krunner
ktorrent ktouch kube kwin_x11 kwrite lbreakouthd lbry-viewer-gtk leafpad
ledger-live-desktop lettura libreoffice librewolf lifeograph lightsoff linuxqq
lollypop loupe lximage-qt lyx man marker mate-calc mattermost-desktop mcomix
menulibre metadata-cleaner meteo-qt microsoft-edge microsoft-edge-beta
microsoft-edge-dev midori min minecraft-launcher minitube mirage mousepad
mp3splt-gtk mumble musictube mutt mypaint nautilus neochat neomutt netsurf
neverball-wrapper neverputt-wrapper newsflash nextcloud nheko nitroshare nomacs
notable nuclear obs obsidian ocenaudio okular onboard onionshare-gui
open-invaders openarena openmw openshot openshot-qt opera opera-beta
opera-developer org_gnome_NautilusPreviewer otter-browser palemoon pavucontrol
pavucontrol-qt pcmanfm pcsxr pdfchain peek photoflare pidgin pinball-wrapper
pinta pipe-viewer-gtk pitivi postman ppsspp pragha psi pybitmessage qbittorrent
qcomicbook qgis qt-faststart qt5ct qt6ct qtox quadrapassel quaternion quodlibet
qupzilla qutebrowser raincat rambox rawtherapee rednotebook rhythmbox riot-web
ripperx ristretto rocketchat rssguard rtv rymdport scorched3d-wrapper scribus
seahorse seamonkey seamonkey-bin secret-tool session-desktop shortwave shotcut
shotwell signal-desktop simutrans singularity skanlite skypeforlinux slack
smuxi-frontend-gnome snox spectacle spectral spotify standardnotes-desktop
start-tor-browser_desktop steam supertuxkart supertuxkart-wrapper surf
swell-foop sylpheed synfigstudio sysprof tb-starter-wrapper teams
teams-for-linux teamspeak3 telegram telegram-desktop terasology thunar
thunderbird tidal-hifi tiny-rdm tor-browser tor-browser-ar tor-browser-ca
tor-browser-cs tor-browser-da tor-browser-de tor-browser-el tor-browser-en
tor-browser-en-us tor-browser-es tor-browser-es-es tor-browser-fa
tor-browser-fr tor-browser-ga-ie tor-browser-he tor-browser-hu tor-browser-id
tor-browser-is tor-browser-it tor-browser-ja tor-browser-ka tor-browser-ko
tor-browser-nb tor-browser-nl tor-browser-pl tor-browser-pt-br tor-browser-ru
tor-browser-sv-se tor-browser-tr tor-browser-vi tor-browser-zh-cn
tor-browser-zh-tw tor-browser_ar tor-browser_ca tor-browser_cs tor-browser_da
tor-browser_de tor-browser_el tor-browser_en tor-browser_en-US tor-browser_es
tor-browser_es-ES tor-browser_fa tor-browser_fr tor-browser_ga-IE
tor-browser_he tor-browser_hu tor-browser_id tor-browser_is tor-browser_it
tor-browser_ja tor-browser_ka tor-browser_ko tor-browser_nb tor-browser_nl
tor-browser_pl tor-browser_pt-BR tor-browser_ru tor-browser_sv-SE
tor-browser_tr tor-browser_vi tor-browser_zh-CN tor-browser_zh-TW torbrowser
torbrowser-launcher totem transgui transmission-gtk transmission-qt
transmission-remote-gtk trojita tutanota-desktop tuxtype twitch typespeed
udiskie uget-gtk unzip upscayl uzbl-browser virt-manager virtualbox vivaldi vlc
vmware vmware-player vmware-view vscodium warzone2100 waterfox whalebird
wire-desktop wireshark wireshark-gtk wireshark-qt x-terminal-emulator
x2goclient xchat xfburn xfce4-notes xfce4-screenshooter xmms xonotic
xonotic-sdl xonotic-sdl-wrapper xpdf yandex-browser yelp youtube youtube-dl-gui
youtube-viewer-gtk youtubemusic-nativefier ytmdesktop zathura zeal zim zoom
)
X_BLACKLIST=(
# False positives for X support.
	"gjs"
)
# Avoid broken resolution issue
X_FALLBACKS=(
	"leafpad:xpra"
	"x-terminal-emulator:xpra"
)
X_HEADLESS_COMPAT=(
# These are x11 sandboxed apps that could be headless and may use xvfb.
	"vmware"
)
X_XEPHYR_ONLY=(
)
X_XPRA_ONLY=(
	# Ban those that perform unexpected behavior like eager window close
	# with xephyr.
	"firefox"
	"firefox-beta"
	"firefox-developer-edition"
	"firefox-esr"
	"firefox-nightly"
	"firefox-wayland"
	"firefox-x11"
)


inherit cflags-hardened flag-o-matic linux-info python-single-r1 toolchain-funcs
inherit virtualx

gen_clang_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
		llvm_slot_${s}? (
			llvm-core/clang:${s}
			llvm-core/lld:${s}
			llvm-core/llvm:${s}
			scudo? (
				llvm-runtimes/compiler-rt-sanitizers[scudo]
			)
		)
		"
	done
}

if [[ "${PV}" =~ "9999" ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/netblue30/firejail.git"
	FIREJAIL_FALLBACK_COMMIT="1a576d15a9339b8f70ae3056e2413e58931072d5" # Jan 17, 2025 # working
#	FIREJAIL_FALLBACK_COMMIT="897f12dd88c1add667ecb211b61b6126a49c7065" # Sep 1, 2024 # working
	IUSE+=" fallback-commit"
else
	KEYWORDS="amd64 ~arm ~arm64 ~x86"
	SRC_URI="
https://github.com/netblue30/${PN}/releases/download/${PV}/${P}.tar.xz
	"
fi

DESCRIPTION="Security sandbox for any type of processes"
HOMEPAGE="https://firejail.wordpress.com/"
LICENSE="GPL-2"
SLOT="0"
IUSE+="
${FIREJAIL_PROFILES_IUSE[@]}
${HARDENED_ALLOCATORS_IUSE[@]}
${LLVM_COMPAT[@]/#/llvm_slot_}
apparmor auto +chroot clang contrib +dbusproxy +file-transfer +firejail_profiles_default
+firejail_profiles_server +globalcfg landlock +network +private-home selfrando selinux
+suid test-profiles test-x11 +userns vanilla wrapper X xephyr xpra xvfb
ebuild_revision_39
"
REQUIRED_USE+="
	${GUI_REQUIRED_USE}
	!test
	suid
	clang? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	contrib? (
		${PYTHON_REQUIRED_USE}
	)
	scudo? (
		clang
	)
	test-x11? (
		test
	)
	test-profiles? (
		test
	)
	xephyr? (
		X
	)
	xpra? (
		X
	)
	xvfb? (
		X
	)
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
	hardened_malloc? (
		dev-libs/hardened_malloc
	)
	mimalloc? (
		dev-libs/mimalloc[hardened]
	)
	selfrando? (
		dev-cpp/selfrando
	)
	selinux? (
		>=sys-libs/libselinux-8.1.0
	)
	X? (
		x11-base/xorg-server[xvfb?]
	)
	xpra? (
		x11-wm/xpra[X,avif,client,cython,firejail,gtk3,jpeg,rencodeplus,server,webp]
		|| (
			=x11-wm/xpra-6*
			=x11-wm/xpra-5*
		)
		x11-wm/xpra:=
		x11-base/xorg-server
	)
	xephyr? (
		x11-base/xorg-server[xephyr?]
	)
"
DEPEND+="
	${RDEPEND}
	>=sys-libs/libseccomp-2.4.3
"
BDEPEND+="
	$(gen_clang_bdepend)
	>=sys-devel/gcc-12
	test? (
		>=app-arch/xz-utils-5.2.4
		>=dev-tcltk/expect-5.45.4
	)
	test-x11? (
		x11-base/xorg-server[xvfb]
		x11-apps/xhost
	)
"

#	Not required until uncommented
#	firejail_profiles_blink-common? ( firejail_profiles_blink-common-hardened.inc )
#	firejail_profiles_chromium-common? ( firejail_profiles_chromium-common-hardened.inc )
#	firejail_profiles_electron-common? ( firejail_profiles_electron-common-hardened.inc )
#	firejail_profiles_feh? ( firejail_profiles_feh-network.inc )
#	firejail_profiles_firefox-common? ( firejail_profiles_firefox-common-addons )
#	firejail_profiles_rtv? ( firejail_profiles_rtv-addons )

REQUIRED_USE+="
	firejail_profiles_1password? ( firejail_profiles_electron-common )
	firejail_profiles_7z? ( firejail_profiles_archiver-common )
	firejail_profiles_7za? ( firejail_profiles_7z )
	firejail_profiles_7zr? ( firejail_profiles_7z )
	firejail_profiles_Books? ( firejail_profiles_gnome-books )
	firejail_profiles_Builder? ( firejail_profiles_gnome-builder )
	firejail_profiles_Cheese? ( firejail_profiles_cheese )
	firejail_profiles_Cyberfox? ( firejail_profiles_cyberfox )
	firejail_profiles_Discord? ( firejail_profiles_discord )
	firejail_profiles_DiscordCanary? ( firejail_profiles_discord-canary )
	firejail_profiles_DiscordPTB? ( firejail_profiles_discord-ptb )
	firejail_profiles_Documents? ( firejail_profiles_gnome-documents )
	firejail_profiles_FBReader? ( firejail_profiles_fbreader )
	firejail_profiles_FossaMail? ( firejail_profiles_fossamail )
	firejail_profiles_Gitter? ( firejail_profiles_gitter )
	firejail_profiles_Logs? ( firejail_profiles_gnome-logs )
	firejail_profiles_Maps? ( firejail_profiles_gnome-maps )
	firejail_profiles_Natron? ( firejail_profiles_natron )
	firejail_profiles_PPSSPPQt? ( firejail_profiles_ppsspp )
	firejail_profiles_PPSSPPSDL? ( firejail_profiles_ppsspp )
	firejail_profiles_Postman? ( firejail_profiles_postman )
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
	firejail_profiles_ani-cli? ( firejail_profiles_mpv )
	firejail_profiles_apack? ( firejail_profiles_atool )
	firejail_profiles_ar? ( firejail_profiles_archiver-common )
	firejail_profiles_ardour4? ( firejail_profiles_ardour5 )
	firejail_profiles_arepack? ( firejail_profiles_atool )
	firejail_profiles_armcord? ( firejail_profiles_electron-common )
	firejail_profiles_atom? ( firejail_profiles_electron-common )
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
	firejail_profiles_b3sum? ( firejail_profiles_hasher-common )
	firejail_profiles_ballbuster-wrapper? ( firejail_profiles_ballbuster )
	firejail_profiles_baloo_filemetadata_temp_extractor? ( firejail_profiles_baloo_file )
	firejail_profiles_balsa? ( firejail_profiles_email-common )
	firejail_profiles_basilisk? ( firejail_profiles_firefox-common )
	firejail_profiles_beaker? ( firejail_profiles_electron-common )
	firejail_profiles_bibtex? ( firejail_profiles_latex-common )
	firejail_profiles_bitwarden? ( firejail_profiles_electron-common )
	firejail_profiles_bitwarden-desktop? ( firejail_profiles_bitwarden )
	firejail_profiles_bnox? ( firejail_profiles_chromium-common )
	firejail_profiles_brave? ( firejail_profiles_chromium-common )
	firejail_profiles_brave-browser? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-beta? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-dev? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-nightly? ( firejail_profiles_brave )
	firejail_profiles_brave-browser-stable? ( firejail_profiles_brave )
	firejail_profiles_brz? ( firejail_profiles_git )
	firejail_profiles_bsdcat? ( firejail_profiles_bsdtar )
	firejail_profiles_bsdcpio? ( firejail_profiles_bsdtar )
	firejail_profiles_bsdtar? ( firejail_profiles_archiver-common )
	firejail_profiles_bundle? ( firejail_profiles_build-systems-common )
	firejail_profiles_bunzip2? ( firejail_profiles_gzip )
	firejail_profiles_bzcat? ( firejail_profiles_gzip )
	firejail_profiles_bzip2? ( firejail_profiles_gzip )
	firejail_profiles_bzr? ( firejail_profiles_brz )
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
	firejail_profiles_caprine? ( firejail_profiles_electron-common )
	firejail_profiles_cargo? ( firejail_profiles_build-systems-common )
	firejail_profiles_chromium? ( firejail_profiles_chromium-common )
	firejail_profiles_chromium-browser? ( firejail_profiles_chromium )
	firejail_profiles_chromium-browser-privacy? ( firejail_profiles_chromium )
	firejail_profiles_chromium-common? ( firejail_profiles_blink-common )
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
	firejail_profiles_code? ( firejail_profiles_electron-common )
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
	firejail_profiles_d-feet? ( firejail_profiles_dbus-debug-common )
	firejail_profiles_d-spy? ( firejail_profiles_dbus-debug-common )
	firejail_profiles_ddgr? ( firejail_profiles_googler-common )
	firejail_profiles_devilspie2? ( firejail_profiles_devilspie )
	firejail_profiles_dino-im? ( firejail_profiles_dino )
	firejail_profiles_discord? ( firejail_profiles_discord-common )
	firejail_profiles_discord-canary? ( firejail_profiles_discord-common )
	firejail_profiles_discord-common? ( firejail_profiles_electron-common )
	firejail_profiles_discord-ptb? ( firejail_profiles_discord-common )
	firejail_profiles_dnox? ( firejail_profiles_chromium-common )
	firejail_profiles_dolphin? ( firejail_profiles_file-manager-common )
	firejail_profiles_dooble-qt4? ( firejail_profiles_dooble )
	firejail_profiles_dtui? ( firejail_profiles_dbus-debug-common )
	firejail_profiles_ebook-convert? ( firejail_profiles_calibre )
	firejail_profiles_ebook-edit? ( firejail_profiles_calibre )
	firejail_profiles_ebook-meta? ( firejail_profiles_calibre )
	firejail_profiles_ebook-polish? ( firejail_profiles_calibre )
	firejail_profiles_ebook-viewer? ( firejail_profiles_calibre )
	firejail_profiles_electron-common? ( firejail_profiles_blink-common )
	firejail_profiles_electron-mail? ( firejail_profiles_electron-common )
	firejail_profiles_element-desktop? ( firejail_profiles_riot-desktop )
	firejail_profiles_elinks? ( firejail_profiles_links-common )
	firejail_profiles_enchant-2? ( firejail_profiles_enchant )
	firejail_profiles_enchant-lsmod? ( firejail_profiles_enchant )
	firejail_profiles_enchant-lsmod-2? ( firejail_profiles_enchant-2 )
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
	firejail_profiles_fix-qdf? ( firejail_profiles_qpdf )
	firejail_profiles_flacsplt? ( firejail_profiles_mp3splt )
	firejail_profiles_flashpeak-slimjet? ( firejail_profiles_chromium-common )
	firejail_profiles_floorp? ( firejail_profiles_firefox-common )
	firejail_profiles_fossamail? ( firejail_profiles_firefox )
	firejail_profiles_four-in-a-row? ( firejail_profiles_gnome_games-common )
	firejail_profiles_freecadcmd? ( firejail_profiles_freecad )
	firejail_profiles_freeciv-gtk3? ( firejail_profiles_freeciv )
	firejail_profiles_freeciv-mp-gtk3? ( firejail_profiles_freeciv )
	firejail_profiles_freeoffice-planmaker? ( firejail_profiles_softmaker-common )
	firejail_profiles_freeoffice-presentations? ( firejail_profiles_softmaker-common )
	firejail_profiles_freeoffice-textmaker? ( firejail_profiles_softmaker-common )
	firejail_profiles_freetube? ( firejail_profiles_electron-common )
	firejail_profiles_gajim-history-manager? ( firejail_profiles_gajim )
	firejail_profiles_gallery-dl? ( firejail_profiles_yt-dlp )
	firejail_profiles_gcalccmd? ( firejail_profiles_gnome-calculator )
	firejail_profiles_gconf-editor? ( firejail_profiles_gconf )
	firejail_profiles_gconf-merge-schema? ( firejail_profiles_gconf )
	firejail_profiles_gconf-merge-tree? ( firejail_profiles_gconf )
	firejail_profiles_gconfpkg? ( firejail_profiles_gconf )
	firejail_profiles_gconftool-2? ( firejail_profiles_gconf )
	firejail_profiles_gh? ( firejail_profiles_git )
	firejail_profiles_ghb? ( firejail_profiles_handbrake )
	firejail_profiles_gist-paste? ( firejail_profiles_gist )
	firejail_profiles_github-desktop? ( firejail_profiles_electron-common )
	firejail_profiles_gl-117-wrapper? ( firejail_profiles_gl-117 )
	firejail_profiles_glaxium-wrapper? ( firejail_profiles_glaxium )
	firejail_profiles_gnome-2048? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-character-map? ( firejail_profiles_gucharmap )
	firejail_profiles_gnome-keyring? ( firejail_profiles_gnome-keyring-daemon )
	firejail_profiles_gnome-keyring-3? ( firejail_profiles_gnome-keyring )
	firejail_profiles_gnome-klotski? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-logs? ( firejail_profiles_system-log-common )
	firejail_profiles_gnome-mahjongg? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-mines? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-mpv? ( firejail_profiles_celluloid )
	firejail_profiles_gnome-nibbles? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-robots? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-sudoku? ( firejail_profiles_gnome_games-common )
	firejail_profiles_gnome-system-log? ( firejail_profiles_system-log-common )
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
	firejail_profiles_gtk-lbry-viewer? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_lbry-viewer )
	firejail_profiles_gtk-pipe-viewer? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_pipe-viewer )
	firejail_profiles_gtk-straw-viewer? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_straw-viewer )
	firejail_profiles_gtk-youtube-viewer? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_youtube-viewer )
	firejail_profiles_gtk2-youtube-viewer? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_youtube-viewer )
	firejail_profiles_gtk3-youtube-viewer? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_youtube-viewer )
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
	firejail_profiles_jami? ( firejail_profiles_jami-gnome )
	firejail_profiles_jdownloader? ( firejail_profiles_JDownloader )
	firejail_profiles_jitsi-meet-desktop? ( firejail_profiles_electron-common )
	firejail_profiles_journal-viewer? ( firejail_profiles_system-log-common )
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
	firejail_profiles_kontact? ( firejail_profiles_kmail )
	firejail_profiles_latex? ( firejail_profiles_latex-common )
	firejail_profiles_lbry-viewer? ( firejail_profiles_youtube-viewers-common )
	firejail_profiles_lbry-viewer-gtk? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_lbry-viewer )
	firejail_profiles_lbunzip2? ( firejail_profiles_gzip )
	firejail_profiles_lbzcat? ( firejail_profiles_gzip )
	firejail_profiles_lbzip2? ( firejail_profiles_gzip )
	firejail_profiles_librewolf? ( firejail_profiles_firefox-common )
	firejail_profiles_librewolf-nightly? ( firejail_profiles_librewolf )
	firejail_profiles_lightsoff? ( firejail_profiles_gnome_games-common )
	firejail_profiles_links? ( firejail_profiles_links-common )
	firejail_profiles_links2? ( firejail_profiles_links-common )
	firejail_profiles_linuxqq? ( firejail_profiles_electron-common )
	firejail_profiles_lobase? ( firejail_profiles_libreoffice )
	firejail_profiles_lobster? ( firejail_profiles_mpv )
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
	firejail_profiles_lz4? ( firejail_profiles_archiver-common )
	firejail_profiles_lz4c? ( firejail_profiles_lz4 )
	firejail_profiles_lz4cat? ( firejail_profiles_lz4 )
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
	firejail_profiles_mattermost-desktop? ( firejail_profiles_electron-common )
	firejail_profiles_md5sum? ( firejail_profiles_hasher-common )
	firejail_profiles_megaglest_editor? ( firejail_profiles_megaglest )
	firejail_profiles_mencoder? ( firejail_profiles_mplayer )
	firejail_profiles_meson? ( firejail_profiles_build-systems-common )
	firejail_profiles_microsoft-edge? ( firejail_profiles_chromium-common )
	firejail_profiles_microsoft-edge-beta? ( firejail_profiles_chromium-common )
	firejail_profiles_microsoft-edge-dev? ( firejail_profiles_chromium-common )
	firejail_profiles_microsoft-edge-stable? ( firejail_profiles_microsoft-edge )
	firejail_profiles_min? ( firejail_profiles_chromium-common )
	firejail_profiles_mov-cli? ( firejail_profiles_mpv )
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
	firejail_profiles_notable? ( firejail_profiles_electron-common )
	firejail_profiles_npm? ( firejail_profiles_nodejs-common )
	firejail_profiles_npx? ( firejail_profiles_nodejs-common )
	firejail_profiles_nuclear? ( firejail_profiles_electron-common )
	firejail_profiles_obsidian? ( firejail_profiles_electron-common )
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
	firejail_profiles_pipe-viewer-gtk? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_pipe-viewer )
	firejail_profiles_planmaker18? ( firejail_profiles_softmaker-common )
	firejail_profiles_planmaker18free? ( firejail_profiles_softmaker-common )
	firejail_profiles_playonlinux? ( firejail_profiles_wine )
	firejail_profiles_pnpm? ( firejail_profiles_nodejs-common )
	firejail_profiles_pnpx? ( firejail_profiles_nodejs-common )
	firejail_profiles_postman? ( firejail_profiles_electron-common )
	firejail_profiles_presentations18? ( firejail_profiles_softmaker-common )
	firejail_profiles_presentations18free? ( firejail_profiles_softmaker-common )
	firejail_profiles_pycharm-professional? ( firejail_profiles_pycharm-community )
	firejail_profiles_pzstd? ( firejail_profiles_zstd )
	firejail_profiles_qemu-launcher? ( firejail_profiles_qemu-common )
	firejail_profiles_qemu-system-x86_64? ( firejail_profiles_qemu-common )
	firejail_profiles_qq? ( firejail_profiles_linuxqq )
	firejail_profiles_qt-faststart? ( firejail_profiles_ffmpeg )
	firejail_profiles_quadrapassel? ( firejail_profiles_gnome_games-common )
	firejail_profiles_qupzilla? ( firejail_profiles_falkon )
	firejail_profiles_ranger? ( firejail_profiles_file-manager-common )
	firejail_profiles_rhash? ( firejail_profiles_hasher-common )
	firejail_profiles_rhythmbox-client? ( firejail_profiles_rhythmbox )
	firejail_profiles_riot-desktop? ( firejail_profiles_riot-web )
	firejail_profiles_riot-web? ( firejail_profiles_electron-common )
	firejail_profiles_rnano? ( firejail_profiles_nano )
	firejail_profiles_rocketchat? ( firejail_profiles_electron-common )
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
	firejail_profiles_session-messenger? ( firejail_profiles_session-desktop )
	firejail_profiles_session-messenger-desktop? ( firejail_profiles_session-desktop )
	firejail_profiles_sftp? ( firejail_profiles_ssh )
	firejail_profiles_sha1sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha224sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha256sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha384sum? ( firejail_profiles_hasher-common )
	firejail_profiles_sha512sum? ( firejail_profiles_hasher-common )
	firejail_profiles_signal-desktop? ( firejail_profiles_electron-common )
	firejail_profiles_skypeforlinux? ( firejail_profiles_electron-common )
	firejail_profiles_slack? ( firejail_profiles_electron-common )
	firejail_profiles_snox? ( firejail_profiles_chromium-common )
	firejail_profiles_soffice? ( firejail_profiles_libreoffice )
	firejail_profiles_standard-notes? ( firejail_profiles_standardnotes-desktop )
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
	firejail_profiles_teams? ( firejail_profiles_electron-common )
	firejail_profiles_teams-for-linux? ( firejail_profiles_electron-common )
	firejail_profiles_telegram-desktop? ( firejail_profiles_telegram )
	firejail_profiles_termshark? ( firejail_profiles_wireshark )
	firejail_profiles_tex? ( firejail_profiles_latex-common )
	firejail_profiles_textmaker18? ( firejail_profiles_softmaker-common )
	firejail_profiles_textmaker18free? ( firejail_profiles_softmaker-common )
	firejail_profiles_thunar? ( firejail_profiles_Thunar )
	firejail_profiles_thunderbird? ( firejail_profiles_firefox-common )
	firejail_profiles_thunderbird-beta? ( firejail_profiles_thunderbird )
	firejail_profiles_thunderbird-wayland? ( firejail_profiles_thunderbird )
	firejail_profiles_tidal-hifi? ( firejail_profiles_electron-common )
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
	firejail_profiles_tqemu? ( firejail_profiles_qemu-common )
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
	firejail_profiles_tutanota-desktop? ( firejail_profiles_electron-common )
	firejail_profiles_twitch? ( firejail_profiles_electron-common )
	firejail_profiles_unar? ( firejail_profiles_ar )
	firejail_profiles_uncompress? ( firejail_profiles_gzip )
	firejail_profiles_unlz4? ( firejail_profiles_lz4 )
	firejail_profiles_unlzma? ( firejail_profiles_cpio )
	firejail_profiles_unrar? ( firejail_profiles_archiver-common )
	firejail_profiles_unxz? ( firejail_profiles_cpio )
	firejail_profiles_unzip? ( firejail_profiles_archiver-common )
	firejail_profiles_unzstd? ( firejail_profiles_zstd )
	firejail_profiles_upscayl? ( firejail_profiles_electron-common )
	firejail_profiles_vimcat? ( firejail_profiles_vim )
	firejail_profiles_vimdiff? ( firejail_profiles_vim )
	firejail_profiles_vimpager? ( firejail_profiles_vim )
	firejail_profiles_vimtutor? ( firejail_profiles_vim )
	firejail_profiles_vivaldi? ( firejail_profiles_chromium-common )
	firejail_profiles_vivaldi-beta? ( firejail_profiles_vivaldi )
	firejail_profiles_vivaldi-snapshot? ( firejail_profiles_vivaldi )
	firejail_profiles_vivaldi-stable? ( firejail_profiles_vivaldi )
	firejail_profiles_vmplayer? ( firejail_profiles_vmware )
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
	firejail_profiles_whalebird? ( firejail_profiles_electron-common )
	firejail_profiles_wire-desktop? ( firejail_profiles_electron-common )
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
	firejail_profiles_youtube? ( firejail_profiles_electron-common )
	firejail_profiles_youtube-dl? ( firejail_profiles_yt-dlp )
	firejail_profiles_youtube-viewer? ( firejail_profiles_youtube-viewers-common )
	firejail_profiles_youtube-viewer-gtk? ( firejail_profiles_gtk-youtube-viewers-common
firejail_profiles_youtube-viewer )
	firejail_profiles_youtubemusic-nativefier? ( firejail_profiles_electron-common )
	firejail_profiles_ytmdesktop? ( firejail_profiles_electron-common )
	firejail_profiles_zcat? ( firejail_profiles_gzip )
	firejail_profiles_zcmp? ( firejail_profiles_gzip )
	firejail_profiles_zdiff? ( firejail_profiles_gzip )
	firejail_profiles_zegrep? ( firejail_profiles_gzip )
	firejail_profiles_zfgrep? ( firejail_profiles_gzip )
	firejail_profiles_zforce? ( firejail_profiles_gzip )
	firejail_profiles_zgrep? ( firejail_profiles_gzip )
	firejail_profiles_zless? ( firejail_profiles_gzip )
	firejail_profiles_zlib-flate? ( firejail_profiles_qpdf )
	firejail_profiles_zmore? ( firejail_profiles_gzip )
	firejail_profiles_znew? ( firejail_profiles_gzip )
	firejail_profiles_zoom? ( firejail_profiles_electron-common )
	firejail_profiles_zpaq? ( firejail_profiles_cpio )
	firejail_profiles_zstd? ( firejail_profiles_archiver-common )
	firejail_profiles_zstdcat? ( firejail_profiles_zstd )
	firejail_profiles_zstdgrep? ( firejail_profiles_zstd )
	firejail_profiles_zstdless? ( firejail_profiles_zstd )
	firejail_profiles_zstdmt? ( firejail_profiles_zstd )

"
PATCHES=(
	"${FILESDIR}/${PN}-0.9.70-envlimits.patch"
	"${FILESDIR}/${PN}-3f4d6df-firecfg.config.patch"
	"${FILESDIR}/extra-patches/${PN}-009110a-disable-xcsecurity.patch"
	"${FILESDIR}/extra-patches/${PN}-009110a-disable-xcsecurity-usage.patch"
	"${FILESDIR}/extra-patches/${PN}-1a576d1-profile-fixes.patch"
	"${FILESDIR}/extra-patches/${PN}-3bbc6b5-private-bin-no-local-default-yes.patch" # Fix all wrappers and mpv
	"${FILESDIR}/extra-patches/${PN}-1b2d18e-add-rhash-profile.patch"
	"${FILESDIR}/extra-patches/${PN}-1b2d18e-add-upscayl-profile.patch"
	"${FILESDIR}/extra-patches/${PN}-1b2d18e-default-1080p.patch"
	"${FILESDIR}/extra-patches/${PN}-1b2d18e-add-caprine-profile.patch"
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

# Based on gen_required_use()
gen_dep_graph() {
	# Regenerates the REQUIRED_USE dependency graph.

	# #1 identify and find all the nodes (aka points)
	# #2 connect the edges via conditional dependency

einfo "Add in global scope the following:"

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
				| sed -e "s|^||g" \
				| tr "\n" " " \
				| sed -r -e "s|[ ]+$||g")
			if [[ "${p:0:1}" =~ ^[0-9] ]] ; then
				echo -e "_PROFILE_GRAPH[\"_${p}\"]=\"${childs}\""  # parent: childs
			else
				echo -e "_PROFILE_GRAPH[\"${p}\"]=\"${childs}\""  # parent: childs
			fi
		fi
	done
	echo
}

gen_x11_compat() {
einfo
einfo "Place the following in the X11_COMPAT array:"
einfo
	local CURSES_COMPAT=(
# This list are apps that may run in the console but are organized like a GUI.
		"weechat"
		"weechat-curses"
	)
	local X_APPS_MISSING_REQUIRED_USE=(
		"amarok"
		"amule"
		"bluefish"
		"brave"
		"brave-browser"
		"brasero"
		"calligraauthor"
		"calligraconverter"
		"calligraflow"
		"calligragemini"
		"calligraplan"
		"calligraplanwork"
		"calligrasheets"
		"calligrastage"
		"calligrawords"
		"chromium"
		"cinelerra"
		"clementine"
		"dillo"
		"ferdi"
		"firefox"
		"freecad"
		"geany"
		"geeqie"
		"gitter"
		"epiphany"
		"evince"
		"evince-previewer"
		"evince-thumbnailer"
		"godot3"
		"google-chrome"
		"eog"
		"google-earth"
		"google-earth-pro"
		"gramps"
		"hexchat"
		"hugin"
		"kodi"
		"leafpad"
		"mousepad"
		"mumble"
		"nautilus"
		"netsurf"
		"obs"
		"pcmanfm"
		"pidgin"
		"pinta"
		"pitivi"
		"qbittorrent"
		"rawtherapee"
		"ripperx"
		"ristretto"
		"qupzilla"
		"seamonkey-bin"
		"shotcut"
		"spotify"
		"surf"
		"synfigstudio"
		"teamspeak3"
		"telegram-desktop"
		"thunar"
		"thunderbird"
		"uzbl-browser"
		"vivaldi"
		"vmware-player"
		"vscodium"
		"x-terminal-emulator"
		"xchat"
		"xfburn"
		"xmms"
		"waterfox"
		"wireshark"
		"wireshark-gtk"
		"wireshark-qt"
		"xpdf"
	# If it is uppercase, it is assumed is is a win port of that app.
	)

	is_x_blacklisted() {
		local arg="${1}"
		local y
		for y in ${X_BLACKLIST[@]} ; do
			if [[ "${arg}" == "${y}" ]] ; then
				return 0
			fi
		done
		return 1
	}

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

	is_xephyr_only() {
		local arg="${1}"
		local y
		for y in ${X_XEPHYR_ONLY[@]} ; do
			if [[ "${arg}" == "${y}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	is_xpra_only() {
		local arg="${1}"
		local y
		for y in ${X_XPRA_ONLY[@]} ; do
			if [[ "${arg}" == "${y}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	local x
	for x in $(grep -l -r -E -e "(tauri|electron|chromium|firefox.profile|firefox-common|torbrowser-launcher|opengl|@x11|gtk|gnome|kde|sdl|qt|opengl|vulkan)" "${S}/etc/profile"*) ${X_APPS_MISSING_REQUIRED_USE[@]} ; do \
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
	local L=$(for x in $(grep -l -r -E -e "(tauri|electron|chromium|firefox.profile|firefox-common|torbrowser-launcher|opengl|@x11|gtk|gnome|kde|sdl|qt|opengl|vulkan)" "${S}/etc/profile"*) ${X_APPS_MISSING_REQUIRED_USE[@]} ; do \
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
		if is_x_blacklisted "${x}" ; then
			:
		elif is_x_headless_compat "${x}" && is_xephyr_only "${x}" ; then
echo "firejail_profiles_${x}? ( || ( xephyr ) )"
		elif is_x_headless_compat "${x}" && is_xpra_only "${x}" ; then
echo "firejail_profiles_${x}? ( || ( xpra ) )"
		elif is_x_headless_compat "${x}" ; then
echo "firejail_profiles_${x}? ( || ( xephyr xpra xvfb ) )"
		else
echo "firejail_profiles_${x}? ( || ( xephyr xpra ) )"
		fi
	done
}

gen_ebuild() {
	gen_profile_array
	gen_required_use
	gen_dep_graph
	gen_x11_compat
eerror
eerror "Comment out GEN_EBUILD when you are done."
eerror
	die
}

check_kernel_config() {
	linux-info_pkg_setup

	CONFIG_CHECK="
		~PROC_FS
		~DEVTMPFS
		~TMPFS
		~UNIX
		~SYSFS
		~FILE_LOCKING
		~BINFMT_SCRIPT
	"
	WARNING_PROC_FS="CONFIG_PROC_FS is required by ${PN} for /proc support."
	WARNING_DEVTMPFS="CONFIG_DEVTMPFS is required by ${PN} for /dev support and chroot."
	WARNING_TMPFS="CONFIG_TMPFS is required by ${PN} for /run, testing /dev/shm, dbus support."
	WARNING_UNIX="CONFIG_UNIX is required by ${PN} for socket(AF_UNIX,...) support."
	WARNING_SYSFS="CONFIG_SYSFS may be required by ${PN} for ipvlan support."
	WARNING_DEVPTS_FS="CONFIG_DEVPTS_FS may be required by ${PN} for testing or private-dev sandboxing."
	WARNING_FILE_LOCKING="CONFIG_FILE_LOCKING is required by ${PN} for chroot and pid sandboxing."
	WARNING_BINFMT_SCRIPT="CONFIG_BINFMT_SCRIPT is required by ${PN} for contrib, tools, testing scripts."
	check_extra_config

	if has_version "virtual/jack" ; then
		CONFIG_CHECK="
			~MMU
			~SHMEM
		"
		WARNING_MMU="CONFIG_MMU is required by ${PN} for sound support for jack."
		WARNING_SHMEM="CONFIG_SHMEM is required by ${PN} for sound sound support for jack."
		check_extra_config
	fi

	if [[ -e "/etc/portage/env/firejail.conf" ]] ; then
		local owner=$(stat -c "%U:%G" "/etc/portage/env/firejail.conf")
		local perms=$(stat -c "%a" "/etc/portage/env/firejail.conf")
		if [[ "${owner}" != "root:root" ]] ; then
eerror "Check contents for tampering and change owner to root:root for /etc/portage/env/firejail.conf"
			die
		fi
		if [[ "${perms}" == "640" ]] ; then
			:
		elif [[ "${perms}" == "644" ]] ; then
			:
		else
eerror "Check contents for tampering and change file permissions to 644 or 640 for /etc/portage/env/firejail.conf"
			die
		fi
		source "/etc/portage/env/firejail.conf"
	fi
	python-single-r1_pkg_setup
	CONFIG_CHECK="
		~BLOCK
		~MISC_FILESYSTEMS
		~SQUASHFS
	"
	WARNING_BLOCK="CONFIG_BLOCK is required for firejail --appimage mode."
	WARNING_MISC_FILESYSTEMS="CONFIG_MISC_FILESYSTEMS is required for firejail --appimage mode."
	WARNING_SQUASHFS="CONFIG_SQUASHFS is required for firejail --appimage mode."
	check_extra_config

	CONFIG_CHECK="
		~NET
		~SECCOMP
		~SECCOMP_FILTER
	"
	WARNING_NET="CONFIG_NET is required for seccomp-bpf for sandboxing or limiting the capabilities of the attacker."
	WARNING_SECCOMP="CONFIG_SECCOMP is required for seccomp-bpf for sandboxing or limiting the capabilities of the attacker."
	WARNING_SECCOMP_FILTER="CONFIG_SECCOMP_FILTER is required for seccomp-bpf for sandboxing or limiting the capabilities of the attacker."
	check_extra_config

	local config_path=$(linux_config_path)
einfo "config_path:  ${config_path}"
	local lsm_list=$(grep -e "CONFIG_LSM" "${config_path}" \
		| cut -f 2 -d '"')

	if use selinux ; then
		CONFIG_CHECK="
			~AUDIT
			~NET
			~INET
			~SYSFS
			~MULTIUSER
			~SECURITY
			~SECURITY_NETWORK
			~SECURITY_SELINUX
		"
		if ! [[ "${lsm_list}" =~ "selinux" ]] ; then
ewarn
ewarn "Missing  selinux  in kernel .config CONFIG_LSM list."
ewarn "See also https://github.com/torvalds/linux/blob/v6.6/security/Kconfig#L234"
ewarn
		fi
		WARNING_AUDIT="CONFIG_AUDIT is required for SELinux LSM support."
		WARNING_NET="CONFIG_NET is required for SELinux LSM support."
		WARNING_INET="CONFIG_INET is required for SELinux LSM support."
		WARNING_SYSFS="CONFIG_SYSFS is required for SELinux LSM support."
		WARNING_MULTIUSER="CONFIG_MULTIUSER is required for SELinux LSM support."
		WARNING_SECURITY="CONFIG_SECURITY is required for SELinux LSM support."
		WARNING_SECURITY_NETWORK="CONFIG_SECURITY_NETWORK is required for SELinux LSM support."
		WARNING_SECURITY_SELINUX="CONFIG_SECURITY_SELINUX is required for SELinux LSM for access control."
		check_extra_config
	fi

	if use apparmor ; then
		CONFIG_CHECK="
			~SYSFS
			~MULTIUSER
			~SECURITY
			~NET
			~SECURITY_APPARMOR
		"
		if ! [[ "${lsm_list}" =~ "apparmor" ]] ; then
ewarn
ewarn "Missing  apparmor  in kernel .config CONFIG_LSM list."
ewarn "See also https://github.com/torvalds/linux/blob/v6.6/security/Kconfig#L234"
ewarn
		fi
		WARNING_SYSFS="CONFIG_SYSFS is required for AppArmor LSM support."
		WARNING_MULTIUSER="CONFIG_MULTIUSER is required for AppArmor LSM support."
		WARNING_SECURITY="CONFIG_NET is required for AppArmor LSM."
		WARNING_SECURITY="CONFIG_SECURITY is required for AppArmor LSM."
		WARNING_SECURITY_APPARMOR="CONFIG_SECURITY_LANDLOCK is required for AppArmor LSM for access control."
		check_extra_config
	fi

	if use landlock ; then
		CONFIG_CHECK="
			~SYSFS
			~MULTIUSER
			~SECURITY
			~SECURITY_LANDLOCK
		"
		if ! [[ "${lsm_list}" =~ "landlock" ]] ; then
ewarn
ewarn "Missing landlock in kernel .config CONFIG_LSM list."
ewarn "See also https://github.com/torvalds/linux/blob/v6.6/security/Kconfig#L234"
ewarn
		fi
		WARNING_SYSFS="CONFIG_SYSFS is required for Landlock LSM support."
		WARNING_MULTIUSER="CONFIG_MULTIUSER is required for Landlock LSM support."
		WARNING_SECURITY="CONFIG_SECURITY is required for Landlock LSM support."
		WARNING_SECURITY_LANDLOCK="CONFIG_SECURITY_LANDLOCK is required for Landlock LSM to impose filesystem restrictions to sandboxed processes and their children."
		check_extra_config
	fi

	if use scudo ; then
# See https://llvm.org/docs/ScudoHardenedAllocator.html#randomness
		CONFIG_CHECK="
			~RELOCATABLE
			~RANDOMIZE_BASE
		"
		if [[ "${ARCH}" == "amd64" ]] ; then
			CONFIG_CHECK+="
				~RANDOMIZE_MEMORY
			"
		fi
		WARNING_RELOCATABLE="CONFIG_RELOCATABLE is required by Scudo."
		WARNING_RANDOMIZE_BASE="CONFIG_RANDOMIZE_BASE (KASLR) is required by Scudo."
		WARNING_RANDOMIZE_MEMORY="CONFIG_RANDOMIZE_MEMORY is required by Scudo."
		check_extra_config
	fi

	if [[ -n "${AUTO_BLACKLIST[@]}" ]] ; then
eerror "The AUTO_BLACKLIST has been changed to SCOPE[@].  See metadata.xml or \`epkginfo -x sys-apps/firejail::oiledmachine-overlay\` for details."
		die
	fi
}

pkg_setup() {
	check_kernel_config
	if use test && [[ "${TEST_SET}" == "full" ]] ; then
		if has userpriv $FEATURES ; then
eerror
eerror "You need to add FEATURES=\"\${FEATURES} -userpriv\" to complete testing"
eerror "in your per-package envvars"
eerror
			die
		fi
	fi

	if ! use scudo && ! use mimalloc && ! use hardened_malloc ; then
ewarn
ewarn "You are not using a hardened allocator for heap protection."
ewarn "USE=scudo, USE=mimalloc, USE=hardened_malloc can provide for a hardened"
ewarn "malloc."
ewarn
	fi
	if [[ "${ARCH}" == "arm64" ]] && ! use hardened_malloc ; then
einfo
einfo "You may use hardened_malloc for MTE support for arm64 to mitigate"
einfo "against buffer overflows and use-after-free."
einfo
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

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FIREJAIL_FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

get_selfrando_arch() {
	if [[ "${ARCH}" == "amd64" ]] ; then
		echo "x86_64"
	elif [[ "${ARCH}" == "arm64" ]] ; then
		echo "arm64"
	else
		die "ARCH=${ARCH} is not supported by Selfrando"
	fi
}

src_prepare() {
	default

	if [[ "${GEN_EBUILD}" == "1" ]] ; then
		gen_ebuild
	fi

	if use xpra ; then
		eapply "${FILESDIR}/extra-patches/${PN}-0.9.64-xpra-speaker-override.patch"
		eapply "${FILESDIR}/extra-patches/${PN}-009110a-xpra-opengl.patch"
		eapply "${FILESDIR}/extra-patches/${PN}-1a576d1-disable-xpra-splash.patch"
	fi

	# Our toolchain already sets SSP by default but forcing it causes problems
	# on arches which don't support it. As for F_S, we again set it by defualt
	# in our toolchain, but forcing F_S=2 is actually a downgrade if 3 is set.
	sed -i \
		-e 's:-fstack-protector-all::' \
		-e 's:-D_FORTIFY_SOURCE=2::' \
		"src/so.mk" \
		"src/prog.mk" \
		|| die

	local ldflags=""
	local cflags=""
	if use selfrando ; then
		filter-flags '-fuse-ld=*'
einfo "Adding Selfrando flags"
		export SR_CFLAGS="-ffunction-sections -fPIC -fuse-ld=bfd"
		export SR_CXXFLAGS="${SR_CFLAGS}"
		SR_BIN="/usr/lib/selfrando/bin"
		SR_LIBDIR="/usr/lib/selfrando/bin/$(get_selfrando_arch)"
	# Never add SR_BIN to PATH.  Only do it with -B arg.
		[[ -e "${SR_BIN}/traplinker" ]] || die
		export SR_LDFLAGS="-B${SR_BIN} -Wl,-rpath,${SR_LIBDIR} -Wl,--gc-sections -Wl,-fuse-ld=bfd"
		cflags="${SR_CFLAGS}"
		ldflags="${SR_LDFLAGS}"
	else
einfo "Adding shuffle-sections ROP mitigation flags"
		cflags="-ffunction-sections"
		if tc-ld-is-lld ; then
			ldflags="-Wl,--shuffle-sections=0"
		elif tc-ld-is-mold ; then
			ldflags="-Wl,--shuffle-sections"
		else
ewarn "Use LLD or mold for ROP mitigation"
		fi
	fi
	[[ -n "${cflags}" ]] && append-flags ${cflags}
	[[ -n "${ldflags}" ]] && append-flags ${ldflags}


	cflags-hardened_append
	cflags="${cflags} ${CFLAGS_HARDENED_CFLAGS}"
	ldflags="${ldflags} ${CFLAGS_HARDENED_LDFLAGS}"

	sed -i \
		-e "s:-ggdb::g" \
		-e "s:-Wall:${cflags} -Wall:g" \
		-e "s:-Wl,-z,relro:-Wl,-z,relro ${ldflags}:g" \
		"config.mk.in" \
		|| die

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
		$(use_enable landlock)
		$(use_enable network)
		$(use_enable private-home)
		$(use_enable selinux)
		$(use_enable suid)
		$(use_enable userns)
		$(use_enable X x11)
		${test_opts[@]}
	)

	econf ${myconf[@]}
}

src_configure()
{
	# Make _FORTIFY_SOURCE=2 work
	replace-flags "-O0" "-O1"

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
	if use selfrando ; then
		grep -e "-static" "${T}/build.log" && die "Add -Wl,-z,norelro to SR_LDFLAGS"
		if readelf -x .txtrp "${S}_release/src/firejail/firejail" | grep -q "was not dumped" ; then
eerror "Selfrando verification failed"
			die
		fi
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

# See also https://github.com/llvm/llvm-project/blob/llvmorg-18.1.8/compiler-rt/cmake/Modules/AllSupportedArchDefs.cmake
get_llvm_arch() {
	if [[ "${ARCH}" == "amd64" ]] ; then
		echo "x86_64"
	elif [[ "${ARCH}" == "x86" ]] ; then
		echo "i386"
	elif [[ "${ARCH}" == "arm64" ]] ; then
		echo "aarch64"
	elif [[ "${ARCH}" == "arm" ]] ; then
		echo "arm"
	elif [[ "${ARCH}" == "loong" ]] ; then
		echo "loongarch64"
	elif [[ "${CHOST}" =~ "mips64" ]] ; then
		echo "mips64"
	elif [[ "${CHOST}" =~ "mips" ]] ; then
		echo "mips"
	elif [[ "${ARCH}" == "ppc64" ]] ; then
		echo "ppc"
	elif [[ "${CHOST}" =~ "riscv64" ]] ; then
		echo "riscv64"
	elif [[ "${CHOST}" =~ "riscv32" ]] ; then
		echo "riscv32"
	elif [[ "${CHOST}" == "sparc" ]] ; then
		echo "sparc"
	elif [[ "${CHOST}" == "s390x" ]] ; then
		echo "s390x"
	fi
}

_gen_one_wrapper() {
	local raw_profile_name="${1}"
	local profile_name="${1}"
	local wrapper_name="${2}"
	local exe_path="${3}"
einfo "Generating wrapper for ${wrapper_name}"
	if [[ "${profile_name:0:1}" =~ ^[0-9] ]] ; then
# You cannot use a number as the prefix to associative array.
		profile_name="_${1}"
	fi

	local x11_arg=""

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

# We must send a deprecation notice or removal notice because
# the security will be severely lowered.
	if \
		[[ \
			   "${X_BACKEND[${profile_name}]}" == "xorg" \
			|| "${X_BACKEND[${profile_name}]}" == "auto" \
		]] \
	; then
eerror
eerror "X_BACKEND[PROFILE]=xorg|auto has been removed."
eerror "Use X_BACKEND[PROFILE]=xpra|xephyr to continue."
eerror
	fi

	if \
		[[ \
			   "${X_BACKEND[${profile_name}]}" == "game" \
			|| "${X_BACKEND[${profile_name}]}" == "gaming" \
			|| "${X_BACKEND[${profile_name}]}" == "opengl" \
		]] \
	; then
eerror
eerror "X_BACKEND[PROFILE]=game|gaming|opengl has been renamed to"
eerror "X_BACKEND[PROFILE]=gaming-sandboxed|opengl-sandboxed"
eerror
eerror "Convert to the new values to continue."
eerror
		die
	fi

	local preferred_fallback=""
	local x
	for x in ${X_FALLBACKS[@]} ; do
		local fallback_profile=${x%:*}
		local x_backend=${x#*:}
		if [[ "${profile_name}" =~ "${fallback_profile}" ]] ; then
			preferred_fallback="${x_backend}"
			break
		fi
	done

	is_xephyr_only() {
		local arg="${1}"
		local y
		for y in ${X_XEPHYR_ONLY[@]} ; do
			if [[ "${arg}" == "${y}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	is_xpra_only() {
		local arg="${1}"
		local y
		for y in ${X_XPRA_ONLY[@]} ; do
			if [[ "${arg}" == "${y}" ]] ; then
				return 0
			fi
		done
		return 1
	}

	local picked_xephyr=0
	if ! use X ; then
		:
	elif [[ "${X_BACKEND[${profile_name}]}" =~ ("disable"|"none"|"unsandboxed"|"gaming-unsandboxed"|"opengl-unsandboxed") ]] ; then
		:
	elif is_xpra_only "${profile_name}" ; then
einfo "Forcing xpra for ${profile_name}"
		x11_arg="--x11=xpra"
	elif is_xephyr_only "${profile_name}" ; then
einfo "Forcing xephyr for ${profile_name}"
		picked_xephyr=1
		x11_arg="--x11=xephyr"
	elif [[ "${X_BACKEND[${profile_name}]}" =~ ("gaming-sandboxed"|"opengl-sandboxed") ]] ; then
		x11_arg="--x11=xpra"
	elif [[ "${X_BACKEND[${profile_name}]}" =~ ("xpra") ]] ; then
		x11_arg="--x11=xpra"
	elif [[ "${X_BACKEND[${profile_name}]}" == "xephyr" ]] ; then
		picked_xephyr=1
		x11_arg="--x11=xephyr"
	elif [[ "${X_BACKEND[${profile_name}]}" =~ ("/dev/null"|"headless"|"xvfb") ]] ; then
		x11_arg="--x11=xvfb"
	elif [[ "${X_BACKEND[${profile_name}]}" == "auto" ]] ; then
		x11_arg="--x11"
	elif is_x11_compat "${profile_name}" && [[ "${preferred_fallback}" == "xpra" ]] && use xpra ; then
		x11_arg="--x11=xpra"
	elif is_x11_compat "${profile_name}" && [[ "${preferred_fallback}" == "xephyr" ]] && use xephyr ; then
		picked_xephyr=1
		x11_arg="--x11=xephyr"
	elif is_x11_compat "${profile_name}" && [[ "${preferred_fallback}" == "xvfb" ]] && use xvfb ; then
		x11_arg="--x11=xvfb"
	elif is_x11_compat "${profile_name}" && use xpra ; then
		x11_arg="--x11=xpra"
	elif is_x11_compat "${profile_name}" && use xephyr ; then
		picked_xephyr=1
		x11_arg="--x11=xephyr"
	# For --x11=org, see issue 1741 in firejail repo
	fi

	if (( ${picked_xephyr} == 1 )) ; then
		if [[ -z "${XEPHYR_WH[${profile_name}]}" ]] ; then
ewarn "XEPHYR_WH[${profile_name}] is unset.  The default 1920x1080 will be used.  Consider setting it to either 1280x720, 1920x1080, 2560x1440, 3840x2160 instead."
ewarn "See metadata.xml or \`epkginfo -x sys-apps/firejail::oiledmachine-overlay\` for details."
		fi
	fi

	local profile_path=""
	if [[ "${COMMAND[${exe_name}]}" == "1" ]] ; then
		:
	elif is_use_dotted "${u}" ; then
		profile_path=$(find "${T}/profiles" "${T}/profiles_processed" "${S}/etc/profile"* -name $(get_dotted_fn "${u}")".profile")
	else
		profile_path=$(find "${T}/profiles" "${T}/profiles_processed" "${S}/etc/profile"* -name "${u}.profile")
	fi

	if [[ "${COMMAND[${exe_name}]}" == "1" ]] ; then
		:
	elif [[ -n "${x11_arg}" ]] && grep -q -e "x11 none" "${profile_path}" ; then
	# False positive
		x11_arg=""
	fi

	local allocator_args=""
	local allocator_args_scudo=""
	local allocator_args_mimalloc=""
	local allocator_args_hardened_malloc=""
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		if use "llvm_slot_${s}" && has_version "llvm-runtimes/compiler-rt-sanitizers:${s}[scudo]" ; then
			if [[ "${SCUDO_FREE_IMMEDIATE[${profile_name}]}" != "1" ]] ; then
				allocator_args_scudo+=" --env=SCUDO_OPTIONS='quarantine_size_kb=256:quarantine_max_chunk_size=2048:thread_local_quarantine_size_kb=64' "
			fi
			allocator_args_scudo+=" --env=LD_PRELOAD=/usr/lib/clang/${s}/lib/linux/libclang_rt.scudo_standalone-$(get_llvm_arch).so"
			break
		fi
	done
	if use mimalloc ; then
		allocator_args_mimalloc="--env=LD_PRELOAD=/usr/$(get_libdir)/libmimalloc-secure.so"
	fi
	if use hardened_malloc ; then
		allocator_args_hardened_malloc="--env=LD_PRELOAD=/usr/$(get_libdir)/libhardened_malloc.so"
	fi

	local PROFILE_NEEDS_SYSTEM_ALLOCATOR=(
	# Ban if it it is statically linked.
		"firefox"
		"firefox-bin"
		"google-chrome"
		"google-chrome-beta"
		"google-chrome-stable"
		"google-chrome-unstable"
		"spotify"

	# Still broken with browser plugin disabled
		"obs"
	)

	local force_system_allocator=0

	if [[ "${_PROFILE_GRAPH[${profile_name}]}" =~ "electron-common" ]] ; then
		force_system_allocator=1
	elif [[ "${exe_path}" =~ "firefox-bin" ]] ; then
		force_system_allocator=1
	fi

	local x
	for x in ${PROFILE_NEEDS_SYSTEM_ALLOCATOR[@]} ; do
		if [[ "${profile_name}" == "firefox" ]] && has_version "www-client/firefox" && ! has_version "www-client/firefox[jemalloc]" ; then
			:
		elif [[ "${profile_name}" == "chromium" ]] && has_version "www-client/chromium" && ! has_version "www-client/chromium[partitionalloc]" ; then
			:
		elif [[ "${profile_name}" == "${x}" ]] ; then
			force_system_allocator=1
			break
		fi
	done

	# Sort by data remittance policy (most scrambled on top, least scrambled bottom)
	if (( ${force_system_allocator} == 1 )) ; then
		:
	elif [[ "${MALLOC_BACKEND[${profile_name}]}" == "mimalloc" ]] && use mimalloc ; then
		allocator_args="${allocator_args_mimalloc}"
	elif [[ "${MALLOC_BACKEND[${profile_name}]}" == "scudo" ]] && use scudo ; then
		allocator_args="${allocator_args_scudo}"
	elif [[ "${MALLOC_BACKEND[${profile_name}]}" == "hardened_malloc" ]] && use hardened_malloc ; then
		allocator_args="${allocator_args_hardened_malloc}"
	elif [[ "${MALLOC_BACKEND[${profile_name}]}" == "system-malloc" ]] ; then
		:
	elif use mimalloc ; then
		allocator_args="${allocator_args_mimalloc}"
	elif use scudo ; then
		allocator_args="${allocator_args_scudo}"
	elif use hardened_malloc ; then
		allocator_args="${allocator_args_hardened_malloc}"
	fi

	local landlock_arg=""
	if use landlock ; then
		if [[ -n "${LANDLOCK[${profile_name}]}" ]] ; then
			landlock_arg="--landlock"
		fi
		if [[ -n "${LANDLOCK_READ[${profile_name}]}" ]] ; then
			local L=(
				echo
			)
			local p
			while IFS=, read p ; do
				landlock_arg+=" --landlock.read=${p}"
			done <<< ${LANDLOCK_READ[${profile_name}]}
		fi
		if [[ -n "${LANDLOCK_WRITE[${profile_name}]}" ]] ; then
			local p
			while IFS=, read p ; do
				landlock_arg+=" --landlock.write=${p}"
			done <<< ${LANDLOCK_WRITE[${profile_name}]}
		fi
		if [[ -n "${LANDLOCK_SPECIAL[${profile_name}]}" ]] ; then
			local p
			while IFS=, read p ; do
				landlock_arg+=" --landlock.special=${p}"
			done <<< ${LANDLOCK_SPECIAL[${profile_name}]}
		fi
		if [[ -n "${LANDLOCK_EXECUTE[${profile_name}]}" ]] ; then
			local p
			while IFS=, read p ; do
				landlock_arg+=" --landlock.execute=${p}"
			done <<< ${LANDLOCK_EXECUTE[${profile_name}]}
		fi
		if [[ -n "${LANDLOCK_PROC[${profile_name}]}" ]] ; then
			local x="${LANDLOCK_PROC[${profile_name}]}"
			landlock_arg+=" --landlock.proc=${x}"
		fi
	fi

	local wh_arg=""
	if [[ -n "${XEPHYR_WH[${profile_name}]}" ]] ; then
		wh_arg="--xephyr-screen=${XEPHYR_WH[${profile_name}]}"
	fi

	local apparmor_arg=""
	if [[ "${APPARMOR_PROFILE[${profile_name}]}" == "default" ]] ; then
		apparmor_arg="--apparmor"
	elif [[ -n "${APPARMOR_PROFILE[${profile_name}]}" ]] ; then
		apparmor_arg="--apparmor=${APPARMOR_PROFILE[${profile_name}]}"
	fi

	local seccomp_arg=""
	if [[ -n "${SECCOMP[${profile_name}]}" ]] ; then
		seccomp_arg+=" --seccomp"
	fi

	if [[ -n "${SECCOMP_BLOCK[${profile_name}]}" ]] ; then
		seccomp_arg+=" --seccomp.drop=${SECCOMP_BLOCK[${profile_name}]}"
	fi

	if [[ -n "${SECCOMP_KEEP[${profile_name}]}" ]] ; then
		seccomp_arg=+" --seccomp.keep=${SECCOMP_KEEP[${profile_name}]}"
	fi

	local args=""
	if [[ -n "${ARGS[${profile_name}]}" ]] ; then
		args="${ARGS[${profile_name}]}"
	fi

	local profile_arg=""
	if [[ -e "${profile_path}" ]] ; then
		profile_arg="--profile=${raw_profile_name}"
	else
		profile_arg="--noprofile"
	fi

	local pulse_arg=""
	if [[ "${profile_name}" == "pavucontrol" ]] ; then
		pulse_arg+="--keep-config-pulse"
	fi

	local folder="bin"

	local is_allowed_wrapper=1

	if [[ "${scope}" =~ ("ban"|"blacklist"|"blacklisted") ]] ; then
		is_allowed_wrapper=0
	fi

	local oom_arg=""
	if [[ -n "${OOM[${profile_name}]}" ]] ; then
		oom_arg="--oom=${OOM[${profile_name}]}"
	fi

	local all_args=(
		${apparmor_arg}
		${x11_arg}
		${allocator_args}
		${wh_arg}
		${seccomp_arg}
		${landlock_arg}
		${profile_arg}
		${pulse_arg}
		${oom_arg}
		${args}
	)

	if (( ${is_allowed_wrapper} == 1 )) ; then
cat <<EOF > "${ED}/usr/local/${folder}/${wrapper_name}" || die
#!/bin/bash
if [[ "\${EUID}" == "0" || "\${EUID}" == "250" ]] ; then
	"${exe_path}" "\$@"
elif [[ -n "\${DISPLAY}" ]] ; then
	exec firejail ${all_args[@]} "${exe_path}" "\$@"
else
	exec firejail ${all_args[@]} "${exe_path}" "\$@"
fi
EOF
		fowners "root:root" "/usr/local/${folder}/${wrapper_name}"
		fperms 0755 "/usr/local/${folder}/${wrapper_name}"
	fi
}

gen_wrapper() {
	local u="${1}"
	local profile_name="${1}"
	if [[ "${profile_name:0:1}" =~ ^[0-9] ]] ; then
# You cannot use a number as the prefix to associative array.
		profile_name="_${1}"
	fi

	local exe_path=""
	if [[ -n "${PATH_CORRECTION[${profile_name}]}" ]] ; then
		exe_path="${PATH_CORRECTION[${profile_name}]}"
	elif [[ -n "${_PATH_CORRECTION[${profile_name}]}" ]] ; then
		exe_path="${_PATH_CORRECTION[${profile_name}]}"
	else
		exe_path="/usr/bin/${exe_name}"
	fi

	if [[ "${u}" == "firefox" ]] ; then
		if has_version "www-client/firefox" ; then
			_gen_one_wrapper "${u}" "firefox" "${exe_path}"
		fi
		if has_version "www-client/firefox-bin" ; then
			_gen_one_wrapper "${u}" "firefox-bin" "/usr/bin/firefox-bin"
		fi
	elif [[ "${u}" == "x-terminal-emulator" ]] ; then
		local terms=(
			alacritty
			aterm
			cool-retro-term
			gnome-terminal
			guake
			kitty
			kterm
			konsole
			lxterminal
			mate-terminal
			ptyxis
			qterminal
			roxterm
			rxvt-unicode
			sakura
			st
			terminator
			terminology
			tilda
			wezterm
			xfce4-terminal
			xterm
			yakuake
			yeahconsole
			zutty
		)
		local exe_name
		for exe_name in ${terms[@]} ; do
			local exe_path=""
			if [[ -n "${PATH_CORRECTION[${exe_name}]}" ]] ; then
				exe_path="${PATH_CORRECTION[${exe_name}]}"
			elif [[ -n "${_PATH_CORRECTION[${exe_name}]}" ]] ; then
				exe_path="${_PATH_CORRECTION[${exe_name}]}"
			elif [[ -e "/usr/bin/${exe_name}" ]] ; then
				exe_path="/usr/bin/${exe_name}"
			fi
			if [[ -e "${exe_path}" ]] ; then
				_gen_one_wrapper "${u}" "${exe_name}" "${exe_path}"
			fi
		done
	elif [[ -e "${exe_path}" ]] ; then
		_gen_one_wrapper "${u}" "${u}" "${exe_path}"
	fi
}

# recursive
get_profile_deps() {
	local nodes=( ${@} )
	(( ${#nodes[@]} == 0 )) && return
	local node
	for node in ${nodes[@]} ; do
		echo "${node}"
		get_profile_deps ${_PROFILE_GRAPH[${node}]}
	done
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

	get_scope() {
		local arg="${1}"

		if [[ "${SCOPE[${arg}]}" ]] ; then
			# User scope override
			echo "${SCOPE[${arg}]}"
		elif [[ -n "${_SCOPE[${arg}]}" ]] ; then
			# Ebuild scope
			echo "${_SCOPE[${arg}]}"
		else
			echo ""
		fi
	}

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
#			die
			continue
		fi

		local raw_profile_name="${u}"
		local profile_name="${u}"
		if [[ "${profile_name:0:1}" =~ ^[0-9] ]] ; then
# You cannot use a number as the prefix to associative array.
			profile_name="_${u}"
		fi

		local exe_path=""
		local exe_name="${u}"
		if [[ -n "${PATH_CORRECTION[${profile_name}]}" ]] ; then
			exe_path="${PATH_CORRECTION[${profile_name}]}"
		elif [[ -n "${_PATH_CORRECTION[${profile_name}]}" ]] ; then
			exe_path="${_PATH_CORRECTION[${profile_name}]}"
		else
			exe_path="/usr/bin/${exe_name}"
		fi

		local scope
		scope=$(get_scope "${profile_name}")

		if use auto && use wrapper && [[ -e "${exe_path}" || "${u}" =~ "x-terminal-emulator" ]] && ! [[ "${u}" =~ "-common" ]] && ! [[ "${u}" =~ "-wrapper" ]] && ! [[ "${scope}" =~ ("ban"|"blacklist"|"blacklisted") ]] ; then
einfo "Auto adding ${u} profile"
			local deps=( $(get_profile_deps ${_PROFILE_GRAPH[${profile_name}]}) )
			queued_profile_deps+=( ${deps[@]} )
			#einfo "deps for ${u}:  ${deps[@]}"
			mv "${src}" "${dest}" || die
			gen_wrapper "${u}"
		elif ( use auto || use ${pv} ) && [[ "${u}" =~ ("default"|"server") ]] ; then
			mv "${src}" "${dest}" || die
		elif use ${pf} ; then
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
	local queued_profile_deps=()
	use wrapper && dodir "/usr/local/bin"
	local impl
	for impl in $(get_impls) ; do
		export BUILD_DIR="${S}_${impl}"
		cd "${BUILD_DIR}" || die

		# Test does not get installed due to modifications
		[[ "${impl}" == "test" ]] && continue

		_install_one_profile
	done

	if use auto && use wrapper ; then
		mv "${T}/profiles_processed/"* "${T}/profiles"
		local pf
		for pf in ${queued_profile_deps[@]} ; do
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
			if [[ ! -e "${dest}" && -e "${src}" ]] ; then
einfo "Auto copying ${u} as a missing profile dependency"
				mv "${src}" "${dest}" || die
			fi
		done
	fi

	if (( "${#COMMAND[@]}" >= "1" )) ; then
		local x
		for x in ${!COMMAND[@]} ; do
			local exe_name="${x}"
			gen_wrapper "${exe_name}"
		done
	fi

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
einfo "  firejail_profiles_blink-common? ( firejail_profiles_blink-common-hardened.inc )"
einfo "  firejail_profiles_chromium-common? ( firejail_profiles_chromium-common-hardened.inc )"
einfo "  firejail_profiles_electron-common? ( firejail_profiles_electron-common-hardened.inc )"
einfo "  firejail_profiles_feh? ( firejail_profiles_feh-network.inc )"
einfo "  firejail_profiles_firefox-common? ( firejail_profiles_firefox-common-addons )"
einfo "  firejail_profiles_rtv? ( firejail_profiles_rtv-addons )"
einfo
	if ! use firejail_profiles_server ; then
ewarn
ewarn "Disabling firejail_profiles_server disables default sandboxing for the"
ewarn "root user"
ewarn
	fi
ewarn
ewarn "The /usr/local/firejail-bin has been removed.  You should remove"
ewarn "PATH=\"/usr/local/firejail-bin:\${PATH}\" from ~/.bashrc."
ewarn

# We do not enable suid by default because it can cause privilege escalation.
# suid is necessary for it to work properly on X.
	if use X && has_version "x11-base/xorg-server" && ! has_version "x11-base/xorg-server[suid]" ; then
ewarn "${PN} may require x11-base/xorg-server[suid] for it to work properly in X environments."
	fi

	if use X && ! use suid ; then
ewarn "${PN} may require ${CATEGORY}/${PN}[suid] for it to work properly in X environments."
	fi
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-MOD-TYPE:  patches, ebuild-changes, profile-selection, testing-sections, audio-patch
# OILEDMACHINE-OVERLAY-META-WIP:  test-USE-flag
# OILEDMACHINE-OVERLAY-META-DETAILED-NOTES:  The test USE flag was found useful in correcting profile errors and why it kept around; however, it is garbage quality.
# OILEDMACHINE-OVERLAY-TEST:  PASSED (1a576d1 with xpra 5.0.11 and 6.2.1, 20250118)
# OILEDMACHINE-OVERLAY-TEST:  PASSED (897f12d, 20250118)

# Tested for both 1a576d1, 897f12d
# For sys-apps/firejail
# USE="X auto chroot clang fallback-commit landlock private-home suid userns
# wrapper xephyr xpra -apparmor -contrib -dbusproxy -file-transfer -globalcfg
# -hardened_malloc -mimalloc -network -scudo -selfrando (-selinux) -test
# -test-profiles -test-x11 -vanilla -xvfb"
