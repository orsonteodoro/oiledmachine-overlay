# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_LANDLOCK=1
WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Oct 20, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1792440420 # From `date +%s -d "Oct 19, 2026 1:07 PM PDT"` From GitHub date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/10/stable-channel-update-for-desktop_02018666648.html"
VULNERABILITIES_FIXED=(
	"CVE-2026-113341;MC;"
	"CVE-2026-113279;MC;"
	"CVE-2026-113072;MC;"
	"CVE-2026-113280;MC;"
	"CVE-2026-113271;UAF;"
	"CVE-2026-113303;MC;"
	"CVE-2026-113101;UAF;"
	"CVE-2026-113097;UAF;"
	"CVE-2026-113098;MC;"
	"CVE-2026-113242;MC;"
	"CVE-2026-113058;UAF;"
	"CVE-2026-113082;MC;"
	"CVE-2026-113119;UAF;"
	"CVE-2026-113092;UAF;"
	"CVE-2026-113134;MC;"
	"CVE-2026-113339;UAF;"
	"CVE-2026-113317;MC;"
	"CVE-2026-113193;MC;"
	"CVE-2026-113117;IV;"
	"CVE-2026-113188;MC;"
	"CVE-2026-113104;MC;"
	"CVE-2026-113322;MC;"
	"CVE-2026-113163;UAF;"
	"CVE-2026-113253;UAF;"
	"CVE-2026-113298;UAF;"
	"CVE-2026-113315;MC;"
	"CVE-2026-113236;UAF;"
	"CVE-2026-113284;MC;"
	"CVE-2026-113141;UAF;"
	"CVE-2026-113316;IV;"
	"CVE-2026-113234;MC;"
	"CVE-2026-113252;IV;"
	"CVE-2026-113305;UAF;"
	"CVE-2026-113044;UAF;"
	"CVE-2026-113135;MC;"
	"CVE-2026-113266;MC;"
	"CVE-2026-113273;MC;"
	"CVE-2026-113293;UAF;"
	"CVE-2026-113225;MC;"
	"CVE-2026-113210;UAF;"
	"CVE-2026-113285;MC;"
	"CVE-2026-113324;UAF;"
	"CVE-2026-113334;IV;"
	"CVE-2026-113020;IV;"
	"CVE-2026-113222;UAF;"
	"CVE-2026-113318;MC;"
	"CVE-2026-113310;OOBR;"
	"CVE-2026-113338;UAF;"
	"CVE-2026-113093;MC;"
	"CVE-2026-113012;IV;"
	"CVE-2026-113175;IV;"
	"CVE-2026-113192;MC;"
	"CVE-2026-113309;OOBR;"
	"CVE-2026-113295;OOBR;"
	"CVE-2026-113217;UAF;"
	"CVE-2026-113040;IV;"
	"CVE-2026-113161;UAF;"
	"CVE-2026-113154;MC;"
	"CVE-2026-113336;MC;"
	"CVE-2026-113181;UAF;"
	"CVE-2026-113019;UAF;"
	"CVE-2026-113095;OOBR;"
	"CVE-2026-113160;UAF;"
	"CVE-2026-113212;MC;"
	"CVE-2026-113000;MC;"
	"CVE-2026-113179;UAF;"
	"CVE-2026-112993;UAF;"
	"CVE-2026-113055;TC;"
	"CVE-2026-113068;UAF;"
	"CVE-2026-113320;MC;"
	"CVE-2026-113231;IV;"
	"CVE-2026-113174;UAF;"
	"CVE-2026-113022;MC;"
	"CVE-2026-113079;UAF;"
	"CVE-2026-113191;UAF;"
	"CVE-2026-113250;UAF;"
	"CVE-2026-113109;MC;"
	"CVE-2026-113113;UAF;"
	"CVE-2026-113069;MC;"
	"CVE-2026-113006;OOBR;"
	"CVE-2026-113263;UAF;"
	"CVE-2026-113018;MC;"
	"CVE-2026-113301;MC;"
	"CVE-2026-113034;MC;"
	"CVE-2026-113094;MC;"
	"CVE-2026-113240;UAF;"
	"CVE-2026-113102;OOBR;"
	"CVE-2026-113142;MC;"
	"CVE-2026-113281;MC;"
	"CVE-2026-113035;OOBR;"
	"CVE-2026-113211;MC;"
	"CVE-2026-113011;UAF;"
	"CVE-2026-113198;UAF;"
	"CVE-2026-113257;MC;"
	"CVE-2026-113070;OOBR;"
	"CVE-2026-113176;MC;"
	"CVE-2026-113150;MC;"
	"CVE-2026-113311;UAF;"
	"CVE-2026-113078;IV;"
	"CVE-2026-113033;UAF;"
	"CVE-2026-113026;MC;"
	"CVE-2026-113302;UAF;"
	"CVE-2026-113164;MC;"
	"CVE-2026-113239;;"
	"CVE-2026-113131;MC;"
	"CVE-2026-113333;MC;"
	"CVE-2026-113147;IV;"
	"CVE-2026-113337;MC;"
	"CVE-2026-113127;MC;"
	"CVE-2026-113129;;"
	"CVE-2026-113264;IV;"
	"CVE-2026-113105;UAF;"
	"CVE-2026-113220;MC;"
	"CVE-2026-113275;UAF;"
	"CVE-2026-113283;MC;"
	"CVE-2026-113014;UAF;"
	"CVE-2026-113108;UAF;"
	"CVE-2026-113343;MC;"
	"CVE-2026-113319;UAF;"
	"CVE-2026-113057;;"
	"CVE-2026-113219;MC;"
	"CVE-2026-113005;MC;"
	"CVE-2026-113209;MC;"
	"CVE-2026-113166;MC;"
	"CVE-2026-113051;MC;"
	"CVE-2026-113196;;"
	"CVE-2026-113003;MC;"
	"CVE-2026-113155;UAF;"
	"CVE-2026-113290;UAF;"
	"CVE-2026-113183;MC;"
	"CVE-2026-113289;IV;"
	"CVE-2026-113146;MC;"
	"CVE-2026-113207;UAF;"
	"CVE-2026-113205;UAF;"
	"CVE-2026-113162;IV;"
	"CVE-2026-113118;MC;"
	"CVE-2026-113232;MC;"
	"CVE-2026-113327;UAF;"
	"CVE-2026-112999;UAF;"
	"CVE-2026-113249;IV;"
	"CVE-2026-113272;MC;"
	"CVE-2026-113112;UAF;"
	"CVE-2026-113321;UAF;"
	"CVE-2026-113059;MC;"
	"CVE-2026-113137;MC;"
	"CVE-2026-113208;UAF;"
	"CVE-2026-113238;MC;"
	"CVE-2026-113194;MC;"
	"CVE-2026-113189;UAF;"
	"CVE-2026-113060;IV;"
	"CVE-2026-113115;UAF;"
	"CVE-2026-113045;OOBR;"
	"CVE-2026-113307;MC;"
	"CVE-2026-113009;UAF;"
	"CVE-2026-113071;UAF;"
	"CVE-2026-113278;UAF;"
	"CVE-2026-113190;UAF;"
	"CVE-2026-112992;MC;"
	"CVE-2026-112995;UAF;"
	"CVE-2026-113261;UAF;"
	"CVE-2026-113172;MC;"
	"CVE-2026-113332;MC;"
	"CVE-2026-113262;UAF;"
	"CVE-2026-113149;MC;"
	"CVE-2026-113206;MC;"
	"CVE-2026-113185;MC;"
	"CVE-2026-113171;MC;"
	"CVE-2026-113042;UAF;"
	"CVE-2026-113276;MC;"
	"CVE-2026-113218;UAF;"
	"CVE-2026-113195;IV;"
	"CVE-2026-113328;IV;"
	"CVE-2026-113335;MC;"
	"CVE-2026-113255;UAF;"
	"CVE-2026-113076;UAF;"
	"CVE-2026-113325;MC;"
	"CVE-2026-113084;IV;"
	"CVE-2026-113308;UAF;"
	"CVE-2026-113224;MC;"
	"CVE-2026-113148;MC;"
	"CVE-2026-113010;OOBR;"
	"CVE-2026-113073;UAF;"
	"CVE-2026-113265;MC;"
	"CVE-2026-113329;OOBR;"
	"CVE-2026-113043;UAF;"
	"CVE-2026-113202;UAF;"
	"CVE-2026-113016;IV;"
	"CVE-2026-113246;MC;"
	"CVE-2026-113041;UAF;"
	"CVE-2026-113126;MC;"
	"CVE-2026-113031;MC;"
	"CVE-2026-113081;UAF;"
	"CVE-2026-113139;MC;"
	"CVE-2026-113128;;"
	"CVE-2026-113049;MC;"
	"CVE-2026-113032;MC;"
	"CVE-2026-113204;UAF;"
	"CVE-2026-113144;MC;"
	"CVE-2026-113054;OOBR;"
	"CVE-2026-113123;UAF;"
	"CVE-2026-113277;OOBR;"
	"CVE-2026-113136;MC;"
	"CVE-2026-113106;MC;"
	"CVE-2026-113001;UAF;"
	"CVE-2026-113064;MC;"
	"CVE-2026-113243;MC;"
	"CVE-2026-113326;MC;"
	"CVE-2026-113124;MC;"
	"CVE-2026-113230;IV;"
	"CVE-2026-113090;MC;"
	"CVE-2026-113158;UAF;"
	"CVE-2026-113077;MC;"
	"CVE-2026-113282;UAF;"
	"CVE-2026-113165;UAF;"
	"CVE-2026-113178;MC;"
	"CVE-2026-113110;MC;"
	"CVE-2026-113007;MC;"
	"CVE-2026-113187;UAF;"
	"CVE-2026-113075;UAF;"
	"CVE-2026-113259;UAF;"
	"CVE-2026-113228;UAF;"
	"CVE-2026-113099;IV;"
	"CVE-2026-113216;UAF;"
	"CVE-2026-113270;UAF;"
	"CVE-2026-113087;UAF;"
	"CVE-2026-113267;MC;"
	"CVE-2026-113304;MC;"
	"CVE-2026-113177;UAF;"
	"CVE-2026-113151;OOBR;"
	"CVE-2026-113028;UAF;"
	"CVE-2026-113120;IV;"
	"CVE-2026-112997;MC;"
	"CVE-2026-113037;UAF;"
	"CVE-2026-113153;MC;"
	"CVE-2026-113138;MC;"
	"CVE-2026-113030;;"
	"CVE-2026-113100;MC;"
	"CVE-2026-113221;UAF;"
	"CVE-2026-113344;UAF;"
	"CVE-2026-113342;MC;"
	"CVE-2026-113159;;"
	"CVE-2026-113233;OOBR;"
	"CVE-2026-113065;UAF;"
	"CVE-2026-113002;MC;"
	"CVE-2026-113199;OOBR;"
	"CVE-2026-113197;UAF;"
	"CVE-2026-113203;UAF;"
	"CVE-2026-113170;UAF;"
	"CVE-2026-113258;MC;"
	"CVE-2026-113297;;"
	"CVE-2026-113062;IV;"
	"CVE-2026-113096;MC;"
	"CVE-2026-113050;OOBR;"
	"CVE-2026-113008;MC;"
	"CVE-2026-113111;UAF;"
	"CVE-2026-113200;UAF;"
	"CVE-2026-113143;MC;"
	"CVE-2026-113157;INFOLEAK, ID;"
	"CVE-2026-113235;IV;"
	"CVE-2026-113089;IV;"
	"CVE-2026-113340;MC;"
	"CVE-2026-113052;MC;"
	"CVE-2026-113133;MC;"
	"CVE-2026-113086;IV;"
	"CVE-2026-113251;UAF;"
	"CVE-2026-113215;UAF;"
	"CVE-2026-113053;UAF;"
	"CVE-2026-113312;MC;"
	"CVE-2026-113323;UAF;"
	"CVE-2026-113114;UAF;"
	"CVE-2026-113015;UAF;"
	"CVE-2026-113091;UAF;"
	"CVE-2026-113168;UAF;"
	"CVE-2026-113229;UAF;"
	"CVE-2026-113256;UAF;"
	"CVE-2026-113103;UAF;"
	"CVE-2026-113056;MC;"
	"CVE-2026-113201;MC;"
	"CVE-2026-113027;MC;"
	"CVE-2026-113214;IV;"
	"CVE-2026-113004;MC;"
	"CVE-2026-113300;OOBW;"
	"CVE-2026-113213;MC;"
	"CVE-2026-113167;MC;"
	"CVE-2026-113223;MC;"
	"CVE-2026-113291;MC;"
	"CVE-2026-113241;MC;"
	"CVE-2026-113244;IV;"
	"CVE-2026-113048;MC;"
	"CVE-2026-113247;MC;"
	"CVE-2026-113023;IV;"
	"CVE-2026-113330;MC;"
	"CVE-2026-113226;MC;"
	"CVE-2026-113152;MC;"
	"CVE-2026-113029;;"
	"CVE-2026-113296;MC;"
	"CVE-2026-113306;IV;"
	"CVE-2026-113245;MC;"
	"CVE-2026-113299;MC;"
	"CVE-2026-113024;UAF;"
	"CVE-2026-113025;UAF;"
	"CVE-2026-113080;UAF;"
	"CVE-2026-113186;MC;"
	"CVE-2026-113180;MC;"
	"CVE-2026-113140;UAF;"
	"CVE-2026-113184;MC;"
	"CVE-2026-113017;UAF;"
	"CVE-2026-112998;MC;"
	"CVE-2026-113021;UAF;"
	"CVE-2026-113145;MC;"
	"CVE-2026-113292;IV;"
	"CVE-2026-113156;UAF;"
	"CVE-2026-113116;UAF;"
	"CVE-2026-113047;MC;"
	"CVE-2026-113173;IV;"
	"CVE-2026-113260;MC;"
	"CVE-2026-113269;MC;"
	"CVE-2026-113036;MC;"
	"CVE-2026-113268;MC;"
	"CVE-2026-113038;MC;"
	"CVE-2026-113313;MC;"
	"CVE-2026-113061;MC;"
	"CVE-2026-113248;MC;"
	"CVE-2026-113288;MC;"
	"CVE-2026-113085;UAF;"
	"CVE-2026-113107;UAF;"
	"CVE-2026-113066;MC;"
	"CVE-2026-113121;MC;"
	"CVE-2026-113287;UAF;"
	"CVE-2026-113132;MC;"
	"CVE-2026-113169;MC;"
	"CVE-2026-113254;MC;"
	"CVE-2026-113063;IV;"
	"CVE-2026-112994;MC;"
	"CVE-2026-113314;UAF;"
	"CVE-2026-113237;MC;"
	"CVE-2026-113331;MC;"
	"CVE-2026-113182;MC;"
	"CVE-2026-113046;IV;"
	"CVE-2026-113067;UAF;"
	"CVE-2026-113074;UAF;"
	"CVE-2026-113130;UAF;"
	"CVE-2026-113294;IV;"
	"CVE-2026-112996;MC;"
	"CVE-2026-113122;MC;"
	"CVE-2026-113227;UAF;"
	"CVE-2026-113286;MC;"
	"CVE-2026-113083;MC;"
	"CVE-2026-113088;MC;"
	"CVE-2026-113013;MC;"
	"CVE-2026-113125;MC;"
	"CVE-2026-113039;UAF;"
	"CVE-2026-113274;UAF;"
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
