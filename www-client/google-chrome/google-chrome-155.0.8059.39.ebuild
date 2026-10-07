# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_LANDLOCK=1
WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Oct 6, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1791270000 # From `date +%s -d "Oct 6, 2026"` From blog date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/10/stable-channel-update-for-desktop_086471744.html"
VULNERABILITIES_FIXED=(
	# 155.0.8059.39
	"CVE-2026-106382;UAF;"
	"CVE-2026-106197;UAF;"
	"CVE-2026-106358;UAF;"
	"CVE-2026-106347;UAF;"
	"CVE-2026-102322;;"
	"CVE-2026-106245;;"
	"CVE-2026-106327;;"
	"CVE-2026-106366;;"
	"CVE-2026-106258;;"
	"CVE-2026-106376;;"
	"CVE-2026-106308;;"
	"CVE-2026-106215;;"
	"CVE-2026-106369;;"
	"CVE-2026-106293;TC;"
	"CVE-2026-106377;RC;"
	"CVE-2026-106412;RC;"
	"CVE-2026-106243;;"
	"CVE-2026-106214;INFOLEAK, ID;"
	"CVE-2026-106364;;"
	"CVE-2026-106239;IO;"
	"CVE-2026-106426;RC;"
	"CVE-2026-106419;UAF;"
	"CVE-2026-106396;IV;"
	"CVE-2026-106323;;"
	"CVE-2026-106231;;"
	"CVE-2026-106202;;"
	"CVE-2026-106273;;"
	"CVE-2026-106203;;"
	"CVE-2026-106332;IO;"
	"CVE-2026-106281;UAF;"
	"CVE-2026-106298;UAF;"
	"CVE-2026-106193;UAF;"
	"CVE-2026-106255;RC;"
	"CVE-2026-106393;UAF;"
	"CVE-2026-106227;UAF;"
	"CVE-2026-106379;;"
	"CVE-2026-106211;UAF;"
	"CVE-2026-106329;;"
	"CVE-2026-106248;UAF;"
	"CVE-2026-106235;UAF;"
	"CVE-2026-106257;UAF;"
	"CVE-2026-106268;UAF;"
	"CVE-2026-106278;UAF;"
	"CVE-2026-106233;UAF;"
	"CVE-2026-106318;UAF;"
	"CVE-2026-106411;UAF;"
	"CVE-2026-106423;UAF;"
	"CVE-2026-106346;IV;"
	"CVE-2026-106190;UAF;"
	"CVE-2026-106357;UAF;"
	"CVE-2026-106240;TC;"
	"CVE-2026-106184;;"
	"CVE-2026-106383;UAF;"
	"CVE-2026-106349;UAF;"
	"CVE-2026-106421;UAF;"
	"CVE-2026-106204;UAF;"
	"CVE-2026-106200;UAF;"
	"CVE-2026-106265;WPP2BWBUI, UI;"
	"CVE-2026-106238;RC;"
	"CVE-2026-106324;;"
	"CVE-2026-106420;;"
	"CVE-2026-106222;;"
	"CVE-2026-106208;;"
	"CVE-2026-106286;;"
	"CVE-2026-106181;;"
	"CVE-2026-106315;UAF;"
	"CVE-2026-106274;;"
	"CVE-2026-106365;;"
	"CVE-2026-106267;;"
	"CVE-2026-106194;;"
	"CVE-2026-106313;;"
	"CVE-2026-106283;UAF;"
	"CVE-2026-106291;UAF;"
	"CVE-2026-106300;RC;"
	"CVE-2026-106314;;"
	"CVE-2026-106223;;"
	"CVE-2026-106242;INFOLEAK, ID;"
	"CVE-2026-106241;;"
	"CVE-2026-106381;;"
	"CVE-2026-106217;;"
	"CVE-2026-106425;;"
	"CVE-2026-106225;;"
	"CVE-2026-106363;;"
	"CVE-2026-106266;;"
	"CVE-2026-106189;;"
	"CVE-2026-106335;UAF;"
	"CVE-2026-106415;INFOLEAK, ID;"
	"CVE-2026-106224;;"
	"CVE-2026-106185;IV;"
	"CVE-2026-106244;;"
	"CVE-2026-106407;;"
	"CVE-2026-106389;;"
	"CVE-2026-106397;;"
	"CVE-2026-106196;;"
	"CVE-2026-106414;IV;"
	"CVE-2026-106408;;"
	"CVE-2026-106261;;"
	"CVE-2026-106406;;"
	"CVE-2026-106290;;"
	"CVE-2026-106378;PE;"
	"CVE-2026-106198;;"
	"CVE-2026-106326;;"
	"CVE-2026-106354;;"
	"CVE-2026-106342;INFOLEAK, ID;"
	"CVE-2026-106424;INFOLEAK, ID;"
	"CVE-2026-106253;;"
	"CVE-2026-106279;;"
	"CVE-2026-106361;;"
	"CVE-2026-106402;;"
	"CVE-2026-106311;CJ;"
	"CVE-2026-106246;;"
	"CVE-2026-106302;WPP2BWBUI, UI;"
	"CVE-2026-106416;;"
	"CVE-2026-106182;WPP2BWBUI, UI;"
	"CVE-2026-106282;WPP2BWBUI, UI;"
	"CVE-2026-106392;INFOLEAK, ID;"
	"CVE-2026-106188;;"
	"CVE-2026-106370;;"
	"CVE-2026-106356;CJ;"
	"CVE-2026-106405;RC;"
	"CVE-2026-106322;;"
	"CVE-2026-106280;;"
	"CVE-2026-106206;IV;"
	"CVE-2026-106180;;"
	"CVE-2026-106303;;"
	"CVE-2026-106201;RC;"
	"CVE-2026-106333;;"
	"CVE-2026-106228;;"
	"CVE-2026-106289;;"
	"CVE-2026-106277;INFOLEAK, ID;"
	"CVE-2026-106410;;"
	"CVE-2026-106284;OOBR;"
	"CVE-2026-106209;WPP2BWBUI, UI;"
	"CVE-2026-106216;;"
	"CVE-2026-106328;;"
	"CVE-2026-106387;;"
	"CVE-2026-106400;CJ;"
	"CVE-2026-106205;;"
	"CVE-2026-106213;RC;"
	"CVE-2026-106230;;"
	"CVE-2026-106367;;"
	"CVE-2026-106226;IV;"
	"CVE-2026-106229;WPP2BWBUI, UI;"
	"CVE-2026-106232;WPP2BWBUI, UI;"
	"CVE-2026-106391;;"
	"CVE-2026-106336;;"
	"CVE-2026-106403;;"
	"CVE-2026-106373;UAF;"
	"CVE-2026-106301;;"
	"CVE-2026-106292;BO;"
	"CVE-2026-106262;;"
	"CVE-2026-106360;INFOLEAK, ID;"
	"CVE-2026-106375;;"
	"CVE-2026-106348;INFOLEAK, ID;"
	"CVE-2026-106307;;"
	"CVE-2026-106212;;"
	"CVE-2026-106398;;"
	"CVE-2026-106388;;"
	"CVE-2026-106271;;"
	"CVE-2026-106395;;"
	"CVE-2026-106304;OOBR;"
	"CVE-2026-106401;OOBW;"
	"CVE-2026-106330;INFOLEAK, ID;"
	"CVE-2026-106295;;"
	"CVE-2026-106352;;"
	"CVE-2026-106337;WPP2BWBUI, UI;"
	"CVE-2026-106263;IV;"
	"CVE-2026-106404;;"
	"CVE-2026-106183;;"
	"CVE-2026-106386;;"
	"CVE-2026-106351;;"
	"CVE-2026-106384;;"
	"CVE-2026-106207;RC;"
	"CVE-2026-106321;INFOLEAK, ID;"
	"CVE-2026-106210;;"
	"CVE-2026-106254;INFOLEAK, ID;"
	"CVE-2026-106372;;"
	"CVE-2026-106341;TC;"
	"CVE-2026-106409;;"
	"CVE-2026-106340;;"
	"CVE-2026-106276;WPP2BWBUI, UI;"
	"CVE-2026-106338;WPP2BWBUI, UI;"
	"CVE-2026-106317;WPP2BWBUI, UI;"
	"CVE-2026-106344;;"
	"CVE-2026-106359;;"
	"CVE-2026-106353;IV;"
	"CVE-2026-106312;;"
	"CVE-2026-106191;;"
	"CVE-2026-106250;;"
	"CVE-2026-106309;;"
	"CVE-2026-106187;;"
	"CVE-2026-106394;;"
	"CVE-2026-106306;;"
	"CVE-2026-106427;;"
	"CVE-2026-106252;;"
	"CVE-2026-106287;;"
	"CVE-2026-106297;;"
	"CVE-2026-106260;;"
	"CVE-2026-106362;;"
	"CVE-2026-106275;;"
	"CVE-2026-106199;;"
	"CVE-2026-106299;IV;"
	"CVE-2026-106422;;"
	"CVE-2026-106186;;"
	"CVE-2026-106247;BO;"
	"CVE-2026-106192;INFOLEAK, ID;"
	"CVE-2026-106399;OOBR;"
	"CVE-2026-106264;;"
	"CVE-2026-106285;WPP2BWBUI, UI;"
	"CVE-2026-106220;INFOLEAK, ID;"
	"CVE-2026-106417;IO;"
	"CVE-2026-106221;;"
	"CVE-2026-106259;;"
	"CVE-2026-106296;;"
	"CVE-2026-106249;;"
	"CVE-2026-106374;TC;"
	"CVE-2026-106380;WPP2BWBUI, UI;"
	"CVE-2026-106179;WPP2BWBUI, UI;"
	"CVE-2026-106368;WPP2BWBUI, UI;"
	"CVE-2026-106237;INFOLEAK, ID;"
	"CVE-2026-106331;IV;"
	"CVE-2026-106270;;"
	"CVE-2026-106350;;"
	"CVE-2026-106288;;"
	"CVE-2026-106305;WPP2BWBUI, UI;"
	"CVE-2026-106418;;"
	"CVE-2026-106343;IV;"
	"CVE-2026-106371;;"
	"CVE-2026-106256;INFOLEAK, ID;"
	"CVE-2026-106413;RC;"
	"CVE-2026-106339;;"
	"CVE-2026-106320;;"
	"CVE-2026-106195;;"
	"CVE-2026-106316;WPP2BWBUI, UI;"
	"CVE-2026-106385;RC;"
	"CVE-2026-106325;;"
	"CVE-2026-106390;;"
	"CVE-2026-106294;;"
	"CVE-2026-106334;INFOLEAK, ID;"
	"CVE-2026-106236;WPP2BWBUI, UI;"
	"CVE-2026-106251;WPP2BWBUI, UI;"
	"CVE-2026-106310;;"
	"CVE-2026-106345;;"
	"CVE-2026-106272;WPP2BWBUI, UI;"
	"CVE-2026-106355;;"
	"CVE-2026-106234;UAF;"
	"CVE-2026-106269;UAF;"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.90.9999"
	"dev-qt/qtbase-6.9999"
	"gui-libs/gtk-4.24.9999"
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
ebuild_revision_4
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
	>=media-libs/alsa-lib-${ALSA_LIB_PV}
	>=media-libs/mesa-${MESA_PV}[gbm(+)]
	>=net-misc/curl-${CURL_PV}
	>=net-print/cups-${CUPS_PV}
	>=sys-apps/dbus-${DBUS_PV}
	>=sys-libs/glibc-${GLIBC_PV}
	>=sys-libs/libcap-${LIBCAP_PV}
	>=x11-libs/cairo-${CAIRO_PV}
	>=x11-libs/gdk-pixbuf-${GDK_PIXBUF_PV}
	>=x11-libs/libdrm-${LIBDRM_PV}
	>=x11-libs/libX11-${LIBX11_PV}
	>=x11-libs/libXext-${LIBXEXT_PV}
	>=x11-libs/libXfixes-${LIBXFIXES_PV}
	>=x11-libs/libXrandr-${LIBXRANDR_PV}
	>=x11-libs/libxcb-${LIBXCB_PV}
	>=x11-libs/libxkbcommon-${LIBXKBCOMMON_PV}
	>=x11-libs/libxshmfence-${LIBXSHMFENCE_PV}
	>=x11-libs/pango-${PANGO_PV}
	>=x11-misc/xdg-utils-${XDG_UTILS_PV}
	media-fonts/liberation-fonts
	sys-kernel/secure-kernel:*[landlock,mseal]
	x11-libs/libXcomposite
	x11-libs/libXdamage
	gtk3? (
		>=x11-libs/gtk+-${GTK3_PV}:3[X]
	)
	gtk4? (
		>=gui-libs/gtk-${GTK4_PV}:4[X]
	)
	qt6? (
		>=dev-qt/qtbase-${QTBASE6_PV}:6[gui,widgets]
	)
	selinux? (
		sec-policy/selinux-chromium:*
	)
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
