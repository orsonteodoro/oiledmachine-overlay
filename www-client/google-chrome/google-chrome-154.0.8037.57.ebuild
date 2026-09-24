# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Sep 22, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1790060400 # From `date +%s -d "Sep 22, 2026"` From blog date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/09/stable-channel-update-for-desktop_0856730748.html"
VULNERABILITIES_FIXED=(
	# 154.0.8037.57
	"CVE-2026-95350;BO;"
	"CVE-2026-95357;OOBW;"
	"CVE-2026-95339;UAF;"
	"CVE-2026-95281;BO;"
	"CVE-2026-95313;UAF;"
	"CVE-2026-95349;BO;"
	"CVE-2026-95284;BO;"
	"CVE-2026-95322;OOBW;"
	"CVE-2026-95329;OOBW;"
	"CVE-2026-95356;UAF;"
	"CVE-2026-95310;UAF;"
	"CVE-2026-95301;;"
	"CVE-2026-95291;WPP2BWBUI, UI;"
	"CVE-2026-95355;;"
	"CVE-2026-95315;UAF;"
	"CVE-2026-95298;UAF;"
	"CVE-2026-95372;UAF;"
	"CVE-2026-95324;;"
	"CVE-2026-95283;BO;"
	"CVE-2026-95293;;"
	"CVE-2026-95274;;"
	"CVE-2026-95282;UAF;"
	"CVE-2026-95373;UAF;"
	"CVE-2026-95277;UAF;"
	"CVE-2026-95348;UAF;"
	"CVE-2026-95335;UAF;"
	"CVE-2026-95338;UAF;"
	"CVE-2026-95318;BO;"
	"CVE-2026-95286;TC;"
	"CVE-2026-95365;TC;"
	"CVE-2026-95343;UAF;"
	"CVE-2026-95280;RC;"
	"CVE-2026-95304;OOBW;"
	"CVE-2026-95306;TC;"
	"CVE-2026-95299;UAF;"
	"CVE-2026-95351;UAF;"
	"CVE-2026-95287;;"
	"CVE-2026-95366;;"
	"CVE-2026-95382;IV;"
	"CVE-2026-95381;IV;"
	"CVE-2026-95331;OOBW;"
	"CVE-2026-95297;;"
	"CVE-2026-95375;;"
	"CVE-2026-95302;;"
	"CVE-2026-95362;;"
	"CVE-2026-95369;II;"
	"CVE-2026-95376;;"
	"CVE-2026-95359;;"
	"CVE-2026-95294;WPP2BWBUI, UI;"
	"CVE-2026-95337;WPP2BWBUI, UI;"
	"CVE-2026-95346;WPP2BWBUI, UI;"
	"CVE-2026-95320;;"
	"CVE-2026-95317;;"
	"CVE-2026-95345;UAF;"
	"CVE-2026-95330;IV;"
	"CVE-2026-95370;II;"
	"CVE-2026-95303;;"
	"CVE-2026-95360;RC;"
	"CVE-2026-95295;INFOLEAK, ID;"
	"CVE-2026-95276;IV;"
	"CVE-2026-95314;;"
	"CVE-2026-95371;;"
	"CVE-2026-95353;UAF;"
	"CVE-2026-95363;WPP2BWBUI, UI;"
	"CVE-2026-95341;IV;"
	"CVE-2026-95354;UAF;"
	"CVE-2026-95384;RC;"
	"CVE-2026-95336;INFOLEAK, ID;"
	"CVE-2026-95290;;"
	"CVE-2026-95325;UAF;"
	"CVE-2026-95275;;"
	"CVE-2026-95374;;"
	"CVE-2026-95300;;"
	"CVE-2026-95321;WPP2BWBUI, UI;"
	"CVE-2026-95323;WPP2BWBUI, UI;"
	"CVE-2026-95332;;"
	"CVE-2026-95312;INFOLEAK, ID;"
	"CVE-2026-95344;RC;"
	"CVE-2026-95289;;"
	"CVE-2026-95347;UAF;"
	"CVE-2026-95311;;"
	"CVE-2026-95358;;"
	"CVE-2026-95333;UAF;"
	"CVE-2026-95307;WPP2BWBUI, UI;"
	"CVE-2026-95285;;"
	"CVE-2026-95278;;"
	"CVE-2026-95327;INFOLEAK, ID;"
	"CVE-2026-95334;;"
	"CVE-2026-95308;IO;"
	"CVE-2026-95292;;"
	"CVE-2026-95352;;"
	"CVE-2026-95279;WPP2BWBUI, UI;"
	"CVE-2026-95367;INFOLEAK, ID;"
	"CVE-2026-95385;II;"
	"CVE-2026-95368;;"
	"CVE-2026-95319;UAF;"
	"CVE-2026-95326;;"
	"CVE-2026-95309;WPP2BWBUI, UI;"
	"CVE-2026-95361;;"
	"CVE-2026-95288;WPP2BWBUI, UI;"
	"CVE-2026-95380;TC;"
	"CVE-2026-95342;;"
	"CVE-2026-95296;;"
	"CVE-2026-95316;;"
	"CVE-2026-95328;;"
	"CVE-2026-95340;;"
	"CVE-2026-95364;IV;"
	"CVE-2026-95305;WPP2BWBUI, UI;"
)

CHKL_TIMESTAMPS=(
	"app-accessibility/at-spi2-core-9999"
	"dev-libs/expat-9999"
	"dev-libs/glib-2.90.9999"
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
ebuild_revision_3
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
