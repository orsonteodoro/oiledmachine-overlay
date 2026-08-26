# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Aug 25, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1787641200 # From `date +%s -d "Aug 25, 2026"` From blog date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/08/stable-channel-update-for-desktop_0256176589.html"
VULNERABILITIES_FIXED=(
	# 152.0.7977.64
	"CVE-2026-79282;UAF;"
	"CVE-2026-79290;UAF;"
	"CVE-2026-79054;UAF;"
	"CVE-2026-79121;IV;"
	"CVE-2026-79224;UAF;"
	"CVE-2026-79052;UAF;"
	"CVE-2026-79150;UAF;"
	"CVE-2026-78935;;"
	"CVE-2026-79012;UAF;"
	"CVE-2026-79200;UAF;"
	"CVE-2026-78989;OOBR;"
	"CVE-2026-79069;MC;"
	"CVE-2026-79175;TC;"
	"CVE-2026-79218;;"
	"CVE-2026-79195;UAF;"
	"CVE-2026-78939;UAF;"
	"CVE-2026-79194;UAF;"
	"CVE-2026-79247;UAF;"
	"CVE-2026-79219;UAF;"
	"CVE-2026-79047;UAF;"
	"CVE-2026-79292;IO;"
	"CVE-2026-78986;;"
	"CVE-2026-79039;UAF;"
	"CVE-2026-78934;RC;"
	"CVE-2026-79011;;"
	"CVE-2026-78911;;"
	"CVE-2026-79257;UAF;"
	"CVE-2026-79202;UAF;"
	"CVE-2026-79212;;"
	"CVE-2026-79183;UAF;"
	"CVE-2026-79155;RC;"
	"CVE-2026-79093;;"
	"CVE-2026-79019;OOBW;"
	"CVE-2026-79187;UAF;"
	"CVE-2026-79288;IV;"
	"CVE-2026-79130;BO;"
	"CVE-2026-78965;;"
	"CVE-2026-79117;RC;"
	"CVE-2026-79082;;"
	"CVE-2026-79111;IV;"
	"CVE-2026-79072;IV;"
	"CVE-2026-79142;BO;"
	"CVE-2026-78948;BO;"
	"CVE-2026-78908;INFOLEAK, ID;"
	"CVE-2026-78895;INFOLEAK, ID;"
	"CVE-2026-79043;OOBW;"
	"CVE-2026-79235;UAF;"
	"CVE-2026-79232;UAF;"
	"CVE-2026-79118;;"
	"CVE-2026-79174;;"
	"CVE-2026-78900;IV;"
	"CVE-2026-79188;OOBW;"
	"CVE-2026-79189;OOBW;"
	"CVE-2026-79048;OOBW;"
	"CVE-2026-79240;OOBW;"
	"CVE-2026-79014;RC;"
	"CVE-2026-79198;UAF;"
	"CVE-2026-79131;OOBW;"
	"CVE-2026-79149;UAF;"
	"CVE-2026-79275;UAF;"
	"CVE-2026-79138;OOBW;"
	"CVE-2026-79026;UAF;"
	"CVE-2026-79027;UAF;"
	"CVE-2026-78904;TC;"
	"CVE-2026-78899;UAF;"
	"CVE-2026-78954;;"
	"CVE-2026-79274;INFOLEAK, ID;"
	"CVE-2026-78938;TC;"
	"CVE-2026-78952;OOBW, CRSH, DoS;"
	"CVE-2026-79236;TC;"
	"CVE-2026-79078;UAF;"
	"CVE-2026-79209;TC;"
	"CVE-2026-79030;;"
	"CVE-2026-79216;BO;"
	"CVE-2026-79007;;"
	"CVE-2026-78893;INFOLEAK, ID;"
	"CVE-2026-79222;;"
	"CVE-2026-79071;RC;"
	"CVE-2026-79076;IV;"
	"CVE-2026-79088;;"
	"CVE-2026-79104;;"
	"CVE-2026-79044;;"
	"CVE-2026-78958;;"
	"CVE-2026-78961;;"
	"CVE-2026-79262;;"
	"CVE-2026-79106;IV;"
	"CVE-2026-79176;;"
	"CVE-2026-78966;;"
	"CVE-2026-79186;;"
	"CVE-2026-79267;RC;"
	"CVE-2026-79016;;"
	"CVE-2026-79010;;"
	"CVE-2026-79286;;"
	"CVE-2026-78945;UAF;"
	"CVE-2026-78999;;"
	"CVE-2026-78941;INFOLEAK, ID;"
	"CVE-2026-79032;IV;"
	"CVE-2026-79109;IV;"
	"CVE-2026-79256;;"
	"CVE-2026-79237;;"
	"CVE-2026-78898;;"
	"CVE-2026-78985;;"
	"CVE-2026-79028;;"
	"CVE-2026-79210;UAF;"
	"CVE-2026-79046;RC;"
	"CVE-2026-79129;UAF;"
	"CVE-2026-78937;UAF;"
	"CVE-2026-78987;INFOLEAK, ID;"
	"CVE-2026-78990;UAF;"
	"CVE-2026-78909;UAF;"
	"CVE-2026-79271;INFOLEAK, ID;"
	"CVE-2026-79144;INFOLEAK, ID;"
	"CVE-2026-79065;IV;"
	"CVE-2026-79192;IV;"
	"CVE-2026-79140;UAF;"
	"CVE-2026-79128;UAF;"
	"CVE-2026-78942;;"
	"CVE-2026-79116;;"
	"CVE-2026-79006;;"
	"CVE-2026-79095;INFOLEAK, ID;"
	"CVE-2026-79084;;"
	"CVE-2026-78991;RC;"
	"CVE-2026-79248;;"
	"CVE-2026-78891;BO;"
	"CVE-2026-79031;;"
	"CVE-2026-79110;;"
	"CVE-2026-79136;;"
	"CVE-2026-78907;;"
	"CVE-2026-79087;;"
	"CVE-2026-79231;BO;"
	"CVE-2026-78969;;"
	"CVE-2026-79137;;"
	"CVE-2026-79057;RC;"
	"CVE-2026-78894;RC;"
	"CVE-2026-79264;;"
	"CVE-2026-78910;BO;"
	"CVE-2026-79066;IV;"
	"CVE-2026-79255;IV;"
	"CVE-2026-79086;;"
	"CVE-2026-79038;;"
	"CVE-2026-78940;;"
	"CVE-2026-79107;;"
	"CVE-2026-79120;;"
	"CVE-2026-79270;;"
	"CVE-2026-79067;;"
	"CVE-2026-79213;;"
	"CVE-2026-78943;IV;"
	"CVE-2026-79259;IV;"
	"CVE-2026-79208;;"
	"CVE-2026-79251;IV;"
	"CVE-2026-79226;;"
	"CVE-2026-79042;;"
	"CVE-2026-79122;INFOLEAK, ID;"
	"CVE-2026-79199;;"
	"CVE-2026-79013;IV;"
	"CVE-2026-79074;INFOLEAK, ID;"
	"CVE-2026-79215;IO;"
	"CVE-2026-79049;;"
	"CVE-2026-79132;IV;"
	"CVE-2026-79201;;"
	"CVE-2026-79051;;"
	"CVE-2026-79053;;"
	"CVE-2026-79285;;"
	"CVE-2026-78906;RC;"
	"CVE-2026-79250;;"
	"CVE-2026-79020;OOBR;"
	"CVE-2026-79217;;"
	"CVE-2026-79204;;"
	"CVE-2026-78912;;"
	"CVE-2026-78955;;"
	"CVE-2026-79143;;"
	"CVE-2026-79241;OOBR;"
	"CVE-2026-78967;;"
	"CVE-2026-79214;IV;"
	"CVE-2026-79228;;"
	"CVE-2026-78953;;"
	"CVE-2026-79229;;"
	"CVE-2026-79002;;"
	"CVE-2026-79272;IV;"
	"CVE-2026-79127;OOBW;"
	"CVE-2026-79151;IV;"
	"CVE-2026-78936;;"
	"CVE-2026-78905;TC;"
	"CVE-2026-79050;;"
	"CVE-2026-79008;IV;"
	"CVE-2026-78975;;"
	"CVE-2026-79287;;"
	"CVE-2026-79094;RC;"
	"CVE-2026-79173;;"
	"CVE-2026-78976;IV;"
	"CVE-2026-79276;;"
	"CVE-2026-79191;;"
	"CVE-2026-79099;;"
	"CVE-2026-79024;INFOLEAK, ID;"
	"CVE-2026-79193;INFOLEAK, ID;"
	"CVE-2026-79242;;"
	"CVE-2026-79180;;"
	"CVE-2026-79293;INFOLEAK, ID;"
	"CVE-2026-79023;;"
	"CVE-2026-79146;INFOLEAK, ID;"
	"CVE-2026-79238;;"
	"CVE-2026-78949;;"
	"CVE-2026-79291;INFOLEAK, ID;"
	"CVE-2026-79283;;"
	"CVE-2026-78892;;"
	"CVE-2026-79070;;"
	"CVE-2026-79205;;"
	"CVE-2026-78903;;"
	"CVE-2026-78959;;"
	"CVE-2026-79234;;"
	"CVE-2026-78983;UAF;"
	"CVE-2026-79083;;"
	"CVE-2026-78944;UAF;"
	"CVE-2026-79178;;"
	"CVE-2026-79059;INFOLEAK, ID;"
	"CVE-2026-79245;UAF;"
	"CVE-2026-78978;OOBR;"
	"CVE-2026-79103;;"
	"CVE-2026-79154;;"
	"CVE-2026-79230;IV;"
	"CVE-2026-79068;;"
	"CVE-2026-79269;;"
	"CVE-2026-79085;;"
	"CVE-2026-79134;;"
	"CVE-2026-79064;UAF;"
	"CVE-2026-79003;;"
	"CVE-2026-79220;INFOLEAK, ID;"
	"CVE-2026-78951;UAF;"
	"CVE-2026-79249;;"
	"CVE-2026-79091;UAF;"
	"CVE-2026-79265;;"
	"CVE-2026-78913;UAF;"
	"CVE-2026-79258;;"
	"CVE-2026-79211;;"
	"CVE-2026-79252;INFOLEAK, ID;"
	"CVE-2026-78962;;"
	"CVE-2026-78901;RC;"
	"CVE-2026-79097;UAF;"
	"CVE-2026-79227;TC;"
	"CVE-2026-79203;IV;"
	"CVE-2026-79033;;"
	"CVE-2026-79139;IV;"
	"CVE-2026-79221;;"
	"CVE-2026-79034;INFOLEAK, ID;"
	"CVE-2026-79075;INFOLEAK, ID;"
	"CVE-2026-78960;INFOLEAK, ID;"
	"CVE-2026-78984;;"
	"CVE-2026-78963;IV;"
	"CVE-2026-79004;OOBR;"
	"CVE-2026-79182;IV;"
	"CVE-2026-79185;INFOLEAK, ID;"
	"CVE-2026-79073;IV;"
	"CVE-2026-79266;UAF;"
	"CVE-2026-79025;IV;"
	"CVE-2026-79141;;"
	"CVE-2026-78974;;"
	"CVE-2026-79055;INFOLEAK, ID;"
	"CVE-2026-79263;RC;"
	"CVE-2026-79124;INFOLEAK, ID;"
	"CVE-2026-79184;;"
	"CVE-2026-79289;;"
	"CVE-2026-79001;INFOLEAK, ID;"
	"CVE-2026-79077;;"
	"CVE-2026-78950;IO;"
	"CVE-2026-79196;RC;"
	"CVE-2026-79000;IV;"
	"CVE-2026-78979;RC;"
	"CVE-2026-79181;;"
	"CVE-2026-79190;;"
	"CVE-2026-79206;OOBR;"
	"CVE-2026-78897;;"
	"CVE-2026-79119;UAF;"
	"CVE-2026-79089;RC;"
	"CVE-2026-79147;INFOLEAK, ID;"
	"CVE-2026-79098;;"
	"CVE-2026-79022;;"
	"CVE-2026-79233;;"
	"CVE-2026-79261;;"
	"CVE-2026-78977;;"
	"CVE-2026-79040;;"
	"CVE-2026-79273;;"
	"CVE-2026-79243;IV;"
	"CVE-2026-79123;IV;"
	"CVE-2026-79005;;"
	"CVE-2026-79090;;"
	"CVE-2026-78946;;"
	"CVE-2026-78968;;"
	"CVE-2026-79041;;"
	"CVE-2026-79284;;"
	"CVE-2026-78896;INFOLEAK, ID;"
	"CVE-2026-79058;;"
	"CVE-2026-79009;;"
	"CVE-2026-79060;;"
	"CVE-2026-79177;;"
	"CVE-2026-78956;TC;"
	"CVE-2026-79239;OOBR;"
	"CVE-2026-79015;IV;"
	"CVE-2026-79108;;"
	"CVE-2026-79056;UAF;"
	"CVE-2026-79018;INFOLEAK, ID;"
	"CVE-2026-78980;IV;"
	"CVE-2026-78947;;"
	"CVE-2026-79244;UAF;"
	"CVE-2026-79112;OOBR;"
	"CVE-2026-79246;INFOLEAK, ID;"
	"CVE-2026-79223;IO;"
	"CVE-2026-79045;TC;"
	"CVE-2026-79197;UAF;"
	"CVE-2026-79148;Ob1;"
	"CVE-2026-79125;INFOLEAK, ID;"
	"CVE-2026-79207;INFOLEAK, ID;"
	"CVE-2026-79017;RC;"
	"CVE-2026-79105;IV;"
	"CVE-2026-79225;;"
	"CVE-2026-79021;;"
	"CVE-2026-79133;;"
	"CVE-2026-79179;;"
	"CVE-2026-79152;;"
	"CVE-2026-78981;INFOLEAK, ID;"
	"CVE-2026-78957;INFOLEAK, ID;"
	"CVE-2026-79126;;"
	"CVE-2026-78915;RC;"
	"CVE-2026-79253;IV;"
	"CVE-2026-79260;IV;"
	"CVE-2026-79254;;"
	"CVE-2026-78914;;"
	"CVE-2026-78964;UAF;"
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

IUSE="gtk3 +gtk4 qt6 selinux"
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
