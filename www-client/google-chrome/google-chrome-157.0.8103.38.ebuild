# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_LANDLOCK=1
WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Nov 3, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1793661753 # From `date +%s -d "Mon, 2 Nov 2026 15:22:33 -0800"` From GitHub date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/11/stable-channel-update-for-desktop.html"
VULNERABILITIES_FIXED=(
	# 157.0.8103.38
	"CVE-2026-121156;BO;"
	"CVE-2026-121229;MC;"
	"CVE-2026-121246;UAF;"
	"CVE-2026-121035;UAF;"
	"CVE-2026-121247;BO;"
	"CVE-2026-121203;UAF;"
	"CVE-2026-121126;UAF;"
	"CVE-2026-121107;;"
	"CVE-2026-121197;OOBR;"
	"CVE-2026-121112;OOBR;"
	"CVE-2026-121174;;"
	"CVE-2026-121098;IV;"
	"CVE-2026-121074;MC;"
	"CVE-2026-121173;;"
	"CVE-2026-121233;TC;"
	"CVE-2026-121140;OOBR;"
	"CVE-2026-121095;;"
	"CVE-2026-121071;;"
	"CVE-2026-121207;;"
	"CVE-2026-121185;UAF;"
	"CVE-2026-121166;TC;"
	"CVE-2026-121047;BO;"
	"CVE-2026-121124;;"
	"CVE-2026-121118;UAF;"
	"CVE-2026-121188;UAF;"
	"CVE-2026-121113;BO;"
	"CVE-2026-121082;TC;"
	"CVE-2026-121083;UAF;"
	"CVE-2026-121179;UAF;"
	"CVE-2026-121180;BO;"
	"CVE-2026-121181;UAF;"
	"CVE-2026-121228;TC;"
	"CVE-2026-121080;UAF;"
	"CVE-2026-121044;UAF;"
	"CVE-2026-121051;WPP2BWBUI, UI;"
	"CVE-2026-121038;INFOLEAK, ID;"
	"CVE-2026-121090;;"
	"CVE-2026-121052;UAF;"
	"CVE-2026-121037;OOBW;"
	"CVE-2026-121086;BO;"
	"CVE-2026-121131;UAF;"
	"CVE-2026-121087;IV;"
	"CVE-2026-121178;UAF;"
	"CVE-2026-121100;UAF;"
	"CVE-2026-121148;UAF;"
	"CVE-2026-121089;UAF;"
	"CVE-2026-121250;UAF;"
	"CVE-2026-121032;OOBR;"
	"CVE-2026-121114;UAF;"
	"CVE-2026-121127;UAF;"
	"CVE-2026-121210;TC;"
	"CVE-2026-121057;TC;"
	"CVE-2026-121201;UAF;"
	"CVE-2026-121084;OOBR;"
	"CVE-2026-121094;TC;"
	"CVE-2026-121079;RC;"
	"CVE-2026-121143;;"
	"CVE-2026-121097;UAF;"
	"CVE-2026-121214;UAF;"
	"CVE-2026-121133;;"
	"CVE-2026-121249;BO;"
	"CVE-2026-121213;;"
	"CVE-2026-121241;UAF;"
	"CVE-2026-121224;;"
	"CVE-2026-121117;UAF;"
	"CVE-2026-121123;UAF;"
	"CVE-2026-121182;UAF;"
	"CVE-2026-121061;UAF;"
	"CVE-2026-121227;;"
	"CVE-2026-121226;TC;"
	"CVE-2026-121068;TC;"
	"CVE-2026-121137;TC;"
	"CVE-2026-121160;OOBR;"
	"CVE-2026-121036;UAF;"
	"CVE-2026-121104;;"
	"CVE-2026-121034;UAF;"
	"CVE-2026-121208;OOBR;"
	"CVE-2026-121129;UAF;"
	"CVE-2026-121211;UAF;"
	"CVE-2026-121078;TC;"
	"CVE-2026-121060;;"
	"CVE-2026-121076;UAF;"
	"CVE-2026-121221;TC;"
	"CVE-2026-121119;UAF;"
	"CVE-2026-121244;WPP2BWBUI, UI;"
	"CVE-2026-121242;IV;"
	"CVE-2026-121105;INFOLEAK, ID;"
	"CVE-2026-121237;IV;"
	"CVE-2026-121102;;"
	"CVE-2026-121120;IV;"
	"CVE-2026-121161;INFOLEAK, ID;"
	"CVE-2026-121062;;"
	"CVE-2026-121031;;"
	"CVE-2026-121063;;"
	"CVE-2026-121108;;"
	"CVE-2026-121199;;"
	"CVE-2026-121099;INFOLEAK, ID;"
	"CVE-2026-121196;PE;"
	"CVE-2026-121066;;"
	"CVE-2026-121256;;"
	"CVE-2026-121115;IV;"
	"CVE-2026-121234;PE;"
	"CVE-2026-121177;WPP2BWBUI, UI;"
	"CVE-2026-121193;;"
	"CVE-2026-121248;;"
	"CVE-2026-121106;INFOLEAK, ID;"
	"CVE-2026-121200;;"
	"CVE-2026-121039;;"
	"CVE-2026-121122;WPP2BWBUI, UI;"
	"CVE-2026-121219;IO;"
	"CVE-2026-121255;;"
	"CVE-2026-121231;;"
	"CVE-2026-121183;;"
	"CVE-2026-121072;;"
	"CVE-2026-121103;;"
	"CVE-2026-121136;;"
	"CVE-2026-121040;;"
	"CVE-2026-121030;;"
	"CVE-2026-121075;;"
	"CVE-2026-121220;;"
	"CVE-2026-121170;;"
	"CVE-2026-121059;INFOLEAK, ID;"
	"CVE-2026-121163;IV;"
	"CVE-2026-121088;;"
	"CVE-2026-121033;;"
	"CVE-2026-121254;INFOLEAK, ID;"
	"CVE-2026-121065;;"
	"CVE-2026-121171;;"
	"CVE-2026-121116;;"
	"CVE-2026-121239;INFOLEAK, ID;"
	"CVE-2026-121187;;"
	"CVE-2026-121132;INFOLEAK, ID;"
	"CVE-2026-121067;WPP2BWBUI, UI;"
	"CVE-2026-121096;;"
	"CVE-2026-121184;OOBR;"
	"CVE-2026-121215;WPP2BWBUI, UI;"
	"CVE-2026-121212;;"
	"CVE-2026-121194;;"
	"CVE-2026-121202;UAF;"
	"CVE-2026-121048;RC;"
	"CVE-2026-121070;UAF;"
	"CVE-2026-121257;UAF;"
	"CVE-2026-121218;TC;"
	"CVE-2026-121164;;"
	"CVE-2026-121223;;"
	"CVE-2026-121186;WPP2BWBUI, UI;"
	"CVE-2026-121176;;"
	"CVE-2026-121128;UAF;"
	"CVE-2026-121216;WPP2BWBUI, UI;"
	"CVE-2026-121158;INFOLEAK, ID;"
	"CVE-2026-121110;WPP2BWBUI, UI;"
	"CVE-2026-121042;;"
	"CVE-2026-121238;UAF;"
	"CVE-2026-121077;UAF;"
	"CVE-2026-121245;RC;"
	"CVE-2026-121049;OOBR;"
	"CVE-2026-121091;;"
	"CVE-2026-121167;;"
	"CVE-2026-121135;;"
	"CVE-2026-121209;WPP2BWBUI, UI;"
	"CVE-2026-121134;;"
	"CVE-2026-121217;UAF;"
	"CVE-2026-121109;;"
	"CVE-2026-121243;INFOLEAK, ID;"
	"CVE-2026-121053;WPP2BWBUI, UI;"
	"CVE-2026-121190;WPP2BWBUI, UI;"
	"CVE-2026-121125;INFOLEAK, ID;"
	"CVE-2026-121046;;"
	"CVE-2026-121222;;"
	"CVE-2026-121157;;"
	"CVE-2026-121235;INFOLEAK, ID;"
	"CVE-2026-121252;;"
	"CVE-2026-121168;;"
	"CVE-2026-121043;WPP2BWBUI, UI;"
	"CVE-2026-121111;;"
	"CVE-2026-121138;;"
	"CVE-2026-121055;;"
	"CVE-2026-121101;;"
	"CVE-2026-121236;IV;"
	"CVE-2026-121165;WPP2BWBUI, UI;"
	"CVE-2026-121253;;"
	"CVE-2026-121172;;"
	"CVE-2026-121206;WPP2BWBUI, UI;"
	"CVE-2026-121189;UAF;"
	"CVE-2026-121121;WPP2BWBUI, UI;"
	"CVE-2026-121130;;"
	"CVE-2026-121251;;"
	"CVE-2026-121085;;"
	"CVE-2026-121159;;"
	"CVE-2026-121204;;"
	"CVE-2026-121205;;"
	"CVE-2026-121050;RC;"
	"CVE-2026-121081;WPP2BWBUI, UI;"
	"CVE-2026-121240;IV;"
	"CVE-2026-121198;;"
	"CVE-2026-121225;;"
	"CVE-2026-121162;WPP2BWBUI, UI;"
	"CVE-2026-121045;WPP2BWBUI, UI;"
	"CVE-2026-121029;;"
	"CVE-2026-121054;IV;"
	"CVE-2026-121175;;"
	"CVE-2026-121092;;"
	"CVE-2026-121073;UAF;"
	"CVE-2026-121230;RC;"
	"CVE-2026-121093;OOBR;"
	"CVE-2026-121041;;"
	"CVE-2026-121232;;"
	"CVE-2026-121142;;"
	"CVE-2026-121069;UAF;"
	"CVE-2026-121169;;"
	"CVE-2026-121064;IV;"
	"CVE-2026-121195;;"
	"CVE-2026-121141;IV;"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.90.9999"
	"dev-qt/qtbase-6.9999"
	"gui-libs/gtk-4.25.9999"
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
ebuild_revision_5
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

pkg_postinst() {
	xdg_pkg_postinst
einfo "TIP:  If the interface is flickering, run google-chrome-stable in wayland or in x11 do \`google-chrome-stable --disable-gpu\`."
}

# OILEDMACHINE-OVERLAY-TEST:  PASSED 150.0.7871.124 (interactive testing, 20260714)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 151.0.7922.71 (interactive testing, 20260730)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 152.0.7977.64 (interactive testing, 20260826)
# OILEDMACHINE-OVERLAY-TEST:  PASSED 153.0.8010.36 (interactive testing, 20260909)
