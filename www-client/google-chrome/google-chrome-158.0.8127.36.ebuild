# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_LANDLOCK=1
WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Nov 17, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1794430898 # From `date +%s -d "Wed, 11 Nov 2026 13:01:38 -0800"` From GitHub date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/11/stable-channel-update-for-desktop_01699533288.html"
VULNERABILITIES_FIXED=(
	# 158.0.8127.36
	"CVE-2026-130963;UAF;"
	"CVE-2026-131031;OOBW;"
	"CVE-2026-131060;BO;"
	"CVE-2026-131008;UAF;"
	"CVE-2026-131054;OOBW;"
	"CVE-2026-130975;UAF;"
	"CVE-2026-130910;;"
	"CVE-2026-130943;UAF;"
	"CVE-2026-130994;UAF;"
	"CVE-2026-130909;UAF;"
	"CVE-2026-131065;UAF;"
	"CVE-2026-131100;UAF;"
	"CVE-2026-130979;UAF;"
	"CVE-2026-131079;UAF;"
	"CVE-2026-130940;IV;"
	"CVE-2026-130954;;"
	"CVE-2026-130996;OOBW;"
	"CVE-2026-130970;URES;"
	"CVE-2026-131057;OOBR;"
	"CVE-2026-130945;UAF;"
	"CVE-2026-131084;UAF;"
	"CVE-2026-131090;UAF;"
	"CVE-2026-130982;IAPC;"
	"CVE-2026-131021;UAF;"
	"CVE-2026-131022;UAF;"
	"CVE-2026-131081;IAPC;"
	"CVE-2026-130961;IAPC;"
	"CVE-2026-130984;IAPC;"
	"CVE-2026-130946;IAPC;"
	"CVE-2026-131045;IAPC;"
	"CVE-2026-131042;UAF;"
	"CVE-2026-131059;UAF;"
	"CVE-2026-130934;IAPC;"
	"CVE-2026-130951;UAF;"
	"CVE-2026-131013;BO;"
	"CVE-2026-130941;IAPC;"
	"CVE-2026-131068;UAF;"
	"CVE-2026-130907;UAF;"
	"CVE-2026-130914;URES;"
	"CVE-2026-131082;UAF;"
	"CVE-2026-130915;UAF;"
	"CVE-2026-131044;UAF;"
	"CVE-2026-131025;OOBR;"
	"CVE-2026-131033;IAPC;"
	"CVE-2026-130977;URES;"
	"CVE-2026-130980;UAF;"
	"CVE-2026-131039;UAF;"
	"CVE-2026-131050;UAF;"
	"CVE-2026-131104;OOBR;"
	"CVE-2026-131103;URES;"
	"CVE-2026-131093;UAF;"
	"CVE-2026-130957;IV;"
	"CVE-2026-131076;URES;"
	"CVE-2026-131083;URES;"
	"CVE-2026-131002;URES;"
	"CVE-2026-130968;UAF;"
	"CVE-2026-131007;URES;"
	"CVE-2026-131092;UAF;"
	"CVE-2026-130932;RE;"
	"CVE-2026-130944;UAF;"
	"CVE-2026-131023;RC;"
	"CVE-2026-131004;UAF;"
	"CVE-2026-130926;PE, CD;"
	"CVE-2026-131101;OOBR;"
	"CVE-2026-131089;BO, CRSH, DoS;"
	"CVE-2026-130952;URES;"
	"CVE-2026-131063;UAF;"
	"CVE-2026-130999;UAF;"
	"CVE-2026-131080;WPP2BWBUI, UI;"
	"CVE-2026-131019;INFOLEAK, ID;"
	"CVE-2026-131095;INFOLEAK, ID;"
	"CVE-2026-130987;RC;"
	"CVE-2026-130942;;"
	"CVE-2026-130958;URES;"
	"CVE-2026-131020;UAF;"
	"CVE-2026-131048;IAPC;"
	"CVE-2026-131062;;"
	"CVE-2026-131006;RC;"
	"CVE-2026-130971;OOBW;"
	"CVE-2026-131075;IV;"
	"CVE-2026-131069;INFOLEAK, ID;"
	"CVE-2026-130992;IAPC;"
	"CVE-2026-131010;UAF;"
	"CVE-2026-130986;IAPC;"
	"CVE-2026-130990;IAPC;"
	"CVE-2026-130962;ICU;"
	"CVE-2026-131000;IV;"
	"CVE-2026-131024;IAPC;"
	"CVE-2026-130948;UAF;"
	"CVE-2026-130923;OOBW;"
	"CVE-2026-131015;IAPC;"
	"CVE-2026-130937;IAPC;"
	"CVE-2026-131053;IAPC;"
	"CVE-2026-130917;UAF;"
	"CVE-2026-131087;TC;"
	"CVE-2026-131061;BO;"
	"CVE-2026-130960;UAF;"
	"CVE-2026-131070;INFOLEAK, ID;"
	"CVE-2026-130936;INFOLEAK, ID;"
	"CVE-2026-131026;INFOLEAK, ID;"
	"CVE-2026-131056;UAF;"
	"CVE-2026-131043;UAF;"
	"CVE-2026-130930;UAF;"
	"CVE-2026-131066;URES;"
	"CVE-2026-131028;IAPC;"
	"CVE-2026-131064;IAPC;"
	"CVE-2026-131047;RC;"
	"CVE-2026-130976;UAF;"
	"CVE-2026-131077;OOBW;"
	"CVE-2026-130965;URES;"
	"CVE-2026-131086;URES;"
	"CVE-2026-130905;WPP2BWBUI, UI;"
	"CVE-2026-130938;UAF;"
	"CVE-2026-131036;WPP2BWBUI, UI;"
	"CVE-2026-131014;PE, CD;"
	"CVE-2026-131052;RC;"
	"CVE-2026-130985;IV;"
	"CVE-2026-130947;IO;"
	"CVE-2026-130995;WPP2BWBUI, UI;"
	"CVE-2026-131091;IAPC;"
	"CVE-2026-130997;ICU;"
	"CVE-2026-131038;IAPC;"
	"CVE-2026-131096;IAPC;"
	"CVE-2026-130913;;"
	"CVE-2026-131017;INFOLEAK, ID;"
	"CVE-2026-130959;IAPC;"
	"CVE-2026-130933;INFOLEAK, ID;"
	"CVE-2026-130929;UAF;"
	"CVE-2026-130956;IV;"
	"CVE-2026-131067;IAPC;"
	"CVE-2026-131030;PE;"
	"CVE-2026-130991;URES;"
	"CVE-2026-131051;IAPC;"
	"CVE-2026-131058;WPP2BWBUI, UI;"
	"CVE-2026-131032;PE, CD;"
	"CVE-2026-131094;IAPC;"
	"CVE-2026-131071;PE, CD;"
	"CVE-2026-131046;IV;"
	"CVE-2026-130928;CI;"
	"CVE-2026-131078;UAF;"
	"CVE-2026-130924;IAPC;"
	"CVE-2026-130969;IAPC;"
	"CVE-2026-131003;PE, CD;"
	"CVE-2026-131097;IAPC;"
	"CVE-2026-131074;UAF;"
	"CVE-2026-130989;IAPC;"
	"CVE-2026-130974;UAF;"
	"CVE-2026-131011;UVAR;"
	"CVE-2026-130988;OOBR;"
	"CVE-2026-131106;BO;"
	"CVE-2026-130939;IAPC;"
	"CVE-2026-130935;INFOLEAK, ID;"
	"CVE-2026-131088;IV;"
	"CVE-2026-131041;IV;"
	"CVE-2026-131016;IAPC;"
	"CVE-2026-131040;IAPC;"
	"CVE-2026-130925;RC;"
	"CVE-2026-130921;;"
	"CVE-2026-130912;IV;"
	"CVE-2026-130967;IAPC;"
	"CVE-2026-131009;WPP2BWBUI, UI;"
	"CVE-2026-130978;IAPC;"
	"CVE-2026-130931;IAPC;"
	"CVE-2026-130908;IAPC;"
	"CVE-2026-131099;OOBR;"
	"CVE-2026-131072;IAPC;"
	"CVE-2026-131034;IAPC;"
	"CVE-2026-131073;IAPC;"
	"CVE-2026-130983;IAPC;"
	"CVE-2026-131105;IAPC;"
	"CVE-2026-130911;RC;"
	"CVE-2026-131102;WPP2BWBUI, UI;"
	"CVE-2026-121101;IAPC;"
	"CVE-2026-130916;IAPC;"
	"CVE-2026-131018;PE, CD;"
	"CVE-2026-131085;CJ;"
	"CVE-2026-130981;INFOLEAK, ID;"
	"CVE-2026-130973;IAPC;"
	"CVE-2026-131027;;"
	"CVE-2026-131012;IAPC;"
	"CVE-2026-131029;IV;"
	"CVE-2026-131049;UAF;"
	"CVE-2026-130955;WPP2BWBUI, UI;"
	"CVE-2026-131035;OOBR;"
	"CVE-2026-130927;IAPC;"
	"CVE-2026-130949;WPP2BWBUI, UI;"
	"CVE-2026-130906;IAPC;"
	"CVE-2026-131005;UAF;"
	"CVE-2026-130920;INFOLEAK, ID;"
	"CVE-2026-130953;IAPC;"
	"CVE-2026-130922;WPP2BWBUI, UI;"
	"CVE-2026-130964;PE, CD;"
	"CVE-2026-130993;UAF;"
	"CVE-2026-130998;IV;"
	"CVE-2026-130950;TC;"
	"CVE-2026-131055;;"
	"CVE-2026-130919;RC;"
	"CVE-2026-131001;BO;"
	"CVE-2026-130966;OOBR;"
	"CVE-2026-131098;OOBR;"
	"CVE-2026-131037;;"
	"CVE-2026-130972;;"
	"CVE-2026-130918;UAF;"
	"CVE-2026-130904;IAPC;"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.91.9999"
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
ebuild_revision_6
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
