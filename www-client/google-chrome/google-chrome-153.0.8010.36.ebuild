# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Sep 8, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1788418800 # From `date +%s -d "Sep 8, 2026"` From blog date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/09/stable-channel-update-for-desktop_0808145027.html"
VULNERABILITIES_FIXED=(
	# 153.0.8010.36
	"CVE-2026-87464;UAF;"
	"CVE-2026-87488;UAF;"
	"CVE-2026-87438;OOBW;"
	"CVE-2026-87527;BO;"
	"CVE-2026-87628;UAF;"
	"CVE-2026-87512;UAF;"
	"CVE-2026-87585;DF;"
	"CVE-2026-87444;MC;"
	"CVE-2026-87447;;"
	"CVE-2026-87440;OOBR;"
	"CVE-2026-87633;UAF;"
	"CVE-2026-87525;OOBR;"
	"CVE-2026-87578;UAF;"
	"CVE-2026-87517;RC;"
	"CVE-2026-87524;UAF;"
	"CVE-2026-87569;;"
	"CVE-2026-87554;RC;"
	"CVE-2026-87467;RC;"
	"CVE-2026-87492;;"
	"CVE-2026-87520;UAF;"
	"CVE-2026-87514;UAF;"
	"CVE-2026-87650;OOBR;"
	"CVE-2026-87596;OOBR;"
	"CVE-2026-87654;BO;"
	"CVE-2026-87604;OOBR;"
	"CVE-2026-87621;OOBW;"
	"CVE-2026-87647;;"
	"CVE-2026-87646;UAF;"
	"CVE-2026-87500;IV;"
	"CVE-2026-87572;;"
	"CVE-2026-87460;UAF;"
	"CVE-2026-87542;UAF;"
	"CVE-2026-87639;UAF;"
	"CVE-2026-87552;;"
	"CVE-2026-87651;;"
	"CVE-2026-87587;UAF;"
	"CVE-2026-87564;TC;"
	"CVE-2026-87498;;"
	"CVE-2026-87499;;"
	"CVE-2026-87607;UAF;"
	"CVE-2026-87558;UAF;"
	"CVE-2026-87581;UAF;"
	"CVE-2026-87480;UAF;"
	"CVE-2026-87612;TC;"
	"CVE-2026-87536;UAF;"
	"CVE-2026-87474;UAF;"
	"CVE-2026-87504;UAF;"
	"CVE-2026-87640;OOBR;"
	"CVE-2026-87491;EEITW, OOBW;"
	"CVE-2026-87478;;"
	"CVE-2026-87446;;"
	"CVE-2026-87657;UAF;"
	"CVE-2026-87434;;"
	"CVE-2026-87487;;"
	"CVE-2026-87453;;"
	"CVE-2026-87588;UAF;"
	"CVE-2026-87636;TC;"
	"CVE-2026-87611;;"
	"CVE-2026-87606;;"
	"CVE-2026-87456;;"
	"CVE-2026-87553;IV;"
	"CVE-2026-87658;INFOLEAK, ID;"
	"CVE-2026-87465;;"
	"CVE-2026-87515;;"
	"CVE-2026-87547;;"
	"CVE-2026-87442;;"
	"CVE-2026-87506;PE;"
	"CVE-2026-87433;RC;"
	"CVE-2026-87557;;"
	"CVE-2026-87457;RC;"
	"CVE-2026-87503;II;"
	"CVE-2026-87481;;"
	"CVE-2026-87537;;"
	"CVE-2026-87471;;"
	"CVE-2026-87485;;"
	"CVE-2026-87652;;"
	"CVE-2026-87582;;"
	"CVE-2026-87466;;"
	"CVE-2026-87603;;"
	"CVE-2026-87615;RC;"
	"CVE-2026-87642;;"
	"CVE-2026-87577;;"
	"CVE-2026-87449;;"
	"CVE-2026-87613;;"
	"CVE-2026-87645;IV;"
	"CVE-2026-87443;;"
	"CVE-2026-87630;IO;"
	"CVE-2026-87590;IV;"
	"CVE-2026-87580;;"
	"CVE-2026-87482;;"
	"CVE-2026-87497;;"
	"CVE-2026-87579;BO;"
	"CVE-2026-87576;;"
	"CVE-2026-87476;;"
	"CVE-2026-87475;;"
	"CVE-2026-87436;;"
	"CVE-2026-87479;WBSPI;"
	"CVE-2026-87513;;"
	"CVE-2026-87432;;"
	"CVE-2026-87560;;"
	"CVE-2026-87521;INFOLEAK, ID;"
	"CVE-2026-87539;;"
	"CVE-2026-87648;UAF;"
	"CVE-2026-87534;;"
	"CVE-2026-87562;;"
	"CVE-2026-87556;;"
	"CVE-2026-87508;;"
	"CVE-2026-87643;IO;"
	"CVE-2026-87573;IV;"
	"CVE-2026-87548;IV;"
	"CVE-2026-87501;;"
	"CVE-2026-87452;;"
	"CVE-2026-87516;;"
	"CVE-2026-87599;IV;"
	"CVE-2026-87507;;"
	"CVE-2026-87559;;"
	"CVE-2026-87472;IV;"
	"CVE-2026-87486;CJ;"
	"CVE-2026-87655;CJ;"
	"CVE-2026-87462;;"
	"CVE-2026-87649;;"
	"CVE-2026-87445;;"
	"CVE-2026-87567;;"
	"CVE-2026-87496;;"
	"CVE-2026-87441;;"
	"CVE-2026-87549;;"
	"CVE-2026-87458;;"
	"CVE-2026-87574;INFOLEAK, ID;"
	"CVE-2026-87495;INFOLEAK, ID;"
	"CVE-2026-87541;INFOLEAK, ID;"
	"CVE-2026-87451;INFOLEAK, ID;"
	"CVE-2026-87570;;"
	"CVE-2026-87555;;"
	"CVE-2026-87600;IV;"
	"CVE-2026-87532;IV;"
	"CVE-2026-87439;INFOLEAK, ID;"
	"CVE-2026-87450;;"
	"CVE-2026-87505;;"
	"CVE-2026-87622;;"
	"CVE-2026-87540;;"
	"CVE-2026-87594;;"
	"CVE-2026-87518;;"
	"CVE-2026-87589;;"
	"CVE-2026-87484;;"
	"CVE-2026-87530;;"
	"CVE-2026-87550;;"
	"CVE-2026-87494;UAF;"
	"CVE-2026-87483;;"
	"CVE-2026-87454;INFOLEAK, ID;"
	"CVE-2026-87616;;"
	"CVE-2026-87535;;"
	"CVE-2026-87644;;"
	"CVE-2026-87533;UAF;"
	"CVE-2026-87635;;"
	"CVE-2026-87641;RC;"
	"CVE-2026-87431;;"
	"CVE-2026-87493;;"
	"CVE-2026-87625;UAF;"
	"CVE-2026-87468;;"
	"CVE-2026-87563;IV;"
	"CVE-2026-87510;IV;"
	"CVE-2026-87435;INFOLEAK, ID;"
	"CVE-2026-87531;INFOLEAK, ID;"
	"CVE-2026-87637;UAF;"
	"CVE-2026-87529;;"
	"CVE-2026-87470;IV;"
	"CVE-2026-87586;OOBR;"
	"CVE-2026-87584;;"
	"CVE-2026-87632;;"
	"CVE-2026-87528;TC;"
	"CVE-2026-87623;;"
	"CVE-2026-87566;;"
	"CVE-2026-87638;OOBW;"
	"CVE-2026-87455;UAF;"
	"CVE-2026-87591;;"
	"CVE-2026-87526;UAF;"
	"CVE-2026-87609;UAF;"
	"CVE-2026-87610;;"
	"CVE-2026-87626;;"
	"CVE-2026-87629;;"
	"CVE-2026-87653;;"
	"CVE-2026-87634;UAF;"
	"CVE-2026-87429;;"
	"CVE-2026-87618;;"
	"CVE-2026-87614;;"
	"CVE-2026-87619;;"
	"CVE-2026-87561;;"
	"CVE-2026-87598;;"
	"CVE-2026-87519;;"
	"CVE-2026-87543;;"
	"CVE-2026-87522;;"
	"CVE-2026-87568;IV;"
	"CVE-2026-87656;IV;"
	"CVE-2026-87511;;"
	"CVE-2026-87627;;"
	"CVE-2026-87595;;"
	"CVE-2026-87592;OOBR;"
	"CVE-2026-87620;;"
	"CVE-2026-87502;;"
	"CVE-2026-87448;UAF;"
	"CVE-2026-87459;;"
	"CVE-2026-87463;;"
	"CVE-2026-87546;;"
	"CVE-2026-87538;CJ;"
	"CVE-2026-87545;INFOLEAK, ID;"
	"CVE-2026-87617;UAF;"
	"CVE-2026-87523;RC;"
	"CVE-2026-87565;INFOLEAK, ID;"
	"CVE-2026-87597;;"
	"CVE-2026-87624;;"
	"CVE-2026-87605;;"
	"CVE-2026-87490;INFOLEAK, ID;"
	"CVE-2026-87583;;"
	"CVE-2026-87509;;"
	"CVE-2026-87473;;"
	"CVE-2026-87461;INFOLEAK, ID;"
	"CVE-2026-87631;;"
	"CVE-2026-87469;IV;"
	"CVE-2026-87489;MC;"
	"CVE-2026-87575;;"
	"CVE-2026-87571;IV;"
	"CVE-2026-87477;INFOLEAK, ID;"
	"CVE-2026-87551;IV;"
	"CVE-2026-87608;IV;"
	"CVE-2026-87437;INFOLEAK, ID;"
	"CVE-2026-87602;OOBR;"
	"CVE-2026-87601;RC;"
	"CVE-2026-87544;;"
	"CVE-2026-87430;BO;"
	"CVE-2026-87593;INFOLEAK, ID;"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.89.9999"
	"dev-qt/qtbase-6.9999"
	"gui-libs/gtk-4.23.9999"
	"media-libs/alsa-lib-9999"
	"media-libs/mesa-9999"
	"net-misc/curl-9999"
	"net-print/cups-9999"
	"sys-apps/dbus-9999"
	"sys-libs/libcap-9999"
	"sys-libs/libselinux-9999"
	"x11-libs/cairo-9999"
	"x11-libs/gtk+-3.24.9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
	"x11-libs/libxkbcommon-9999"
)

inherit chkl chromium-2 desktop pax-utils secure-version unpacker vf web-kernel-config xdg

DESCRIPTION="The web browser from Google"
HOMEPAGE="https://www.google.com/chrome/"

if [[ ${PN} == google-chrome ]]; then
	MY_PN=${PN}-stable
else
	MY_PN=${PN}
fi

MY_P="${MY_PN}_${PV}-1"
SRC_URI="https://dl.google.com/linux/chrome/deb/pool/main/g/${MY_PN}/${MY_P}_amd64.deb"
S=${WORKDIR}

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="-* amd64"

IUSE="
gtk3 +gtk4 qt6 selinux
ebuild_revision_2
"
REQUIRED_USE="
	|| (
		gtk3
		gtk4
	)
"

RESTRICT="bindist mirror strip"

RDEPEND="
	>=app-accessibility/at-spi2-core-${AT_SPI2_CORE_PV}
	>=app-misc/ca-certificates-${CA_CERTIFICATES_PV}
	>=dev-libs/expat-${EXPAT_PV}
	>=dev-libs/glib-${GLIB_PV}
	>=dev-libs/nspr-${NSPR_PV}
	>=dev-libs/nss-${NSS_PV}
	media-fonts/liberation-fonts
	>=media-libs/alsa-lib-${ALSA_LIB_PV}
	>=media-libs/mesa-${MESA_PV}[gbm(+)]
	>=net-misc/curl-${CURL_PV}
	>=net-print/cups-${CUPS_PV}
	>=sys-apps/dbus-${DBUS_PV}
	>=sys-libs/glibc-${GLIBC_PV}
	>=sys-libs/libcap-${LIBCAP_PV}
	>=x11-libs/cairo-${CAIRO_PV}
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}
	gtk3? (
		>=x11-libs/gtk+-${GTK3_PV}:3[X]
	)
	gtk4? (
		>=gui-libs/gtk-${GTK4_PV}:4[X]
	)
	>=x11-libs/libdrm-${LIBDRM_PV}
	>=x11-libs/libX11-${LIBX11_PV}
	x11-libs/libXcomposite
	x11-libs/libXdamage
	>=x11-libs/libXext-${LIBXEXT_PV}
	>=x11-libs/libXfixes-${LIBXFIXES_PV}
	>=x11-libs/libXrandr-${LIBXRANDR_PV}
	>=x11-libs/libxcb-${LIBXCB_PV}
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}
	>=x11-libs/libxshmfence-${LIBXSHMFENCE_PV}
	>=x11-libs/pango-${PANGO_PV}
	>=x11-misc/xdg-utils-${XDG_UTILS_PV}
	qt6? ( >=dev-qt/qtbase-${QTBASE6_PV}:6[gui,widgets] )
	selinux? ( sec-policy/selinux-chromium:* )
"

QA_PREBUILT="*"
QA_DESKTOP_FILE="usr/share/applications/google-chrome.*\\.desktop"
CHROME_HOME="opt/google/chrome${PN#google-chrome}"

pkg_nofetch() {
	eerror "Please wait 24 hours and sync your tree before reporting a bug for google-chrome fetch failures."
}

pkg_pretend() {
	# Protect against people using autounmask overzealously
	use amd64 || die "google-chrome only works on amd64"
}

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
	web-kernel-config_setup

	if [[ -n "${MITIGATION_URI}" ]] ; then
einfo "Security announcement date:  ${MITIGATION_DATE}"
einfo "Security fixes applied:  ${MITIGATION_URI}"
	fi
	vf_show
}

src_unpack() {
	:
}

src_configure() {
	chkl_check_many_timestamps
}

src_install() {
	dodir /
	cd "${ED}" || die
	unpacker

	mv usr/share/doc/${MY_PN} usr/share/doc/${PF} || die

	# Since M141 Google Chrome comes with its own bundled cron
	# scripts which invoke `apt` directly. Useless on Gentoo!
	rm -r etc/cron.daily || die "Failed to remove cron scripts"
	rm -r "${CHROME_HOME}"/cron || die "Failed to remove cron scripts"

	gzip -d usr/share/doc/${PF}/changelog.gz || die
	gzip -d usr/share/man/man1/${MY_PN}.1.gz || die
	if [[ -L usr/share/man/man1/google-chrome.1.gz ]]; then
		rm usr/share/man/man1/google-chrome.1.gz || die
		dosym ${MY_PN}.1 usr/share/man/man1/google-chrome.1
	fi

	pushd "${CHROME_HOME}/locales" > /dev/null || die
	chromium_remove_language_paks
	popd > /dev/null || die

	rm "${CHROME_HOME}/libqt5_shim.so" || die
	if ! use qt6; then
		rm "${CHROME_HOME}/libqt6_shim.so" || die
	fi

	local suffix=
	[[ ${PN} == google-chrome-beta ]] && suffix=_beta
	[[ ${PN} == google-chrome-unstable ]] && suffix=_dev

	local size
	for size in 16 24 32 48 64 128 256 ; do
		newicon -s ${size} "${CHROME_HOME}/product_logo_${size}${suffix}.png" ${PN}.png
	done

	pax-mark m "${CHROME_HOME}/chrome"
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 150.0.7871.124 (interactive testing, 20260714)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 151.0.7922.71 (interactive testing, 20260730)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 152.0.7977.64 (interactive testing, 20260826)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 153.0.8010.36 (interactive testing, 20260909)
