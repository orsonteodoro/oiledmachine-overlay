# Copyright 2011-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WEB_KERNEL_CONFIG_CHECK_YAMA=1

CHROMIUM_LANGS="af am ar bg bn ca cs da de el en-GB es es-419 et fa fi fil fr gu he
	hi hr hu id it ja kn ko lt lv ml mr ms nb nl pl pt-BR pt-PT ro ru sk sl sr
	sv sw ta te th tr uk ur vi zh-CN zh-TW"

MITIGATION_DATE="Jul 29, 2026" # Official annoucement (blog)
MITIGATION_LAST_UPDATE=1785308400 # From `date +%s -d "Jul 29, 2026"` From blog date
MITIGATION_URI="https://chromereleases.googleblog.com/2026/07/stable-channel-update-for-desktop_0887107924.html"
VULNERABILITIES_FIXED=(
	"CVE-2026-17650;UAF;"
	"CVE-2026-17651;IV;"
	"CVE-2026-17652;UAF;"
	"CVE-2026-17653;UAF;"
	"CVE-2026-17654;RC;"
	"CVE-2026-17655;IV;"
	"CVE-2026-17656;UAF;"
	"CVE-2026-17657;UAF;"
	"CVE-2026-17658;UAF;"
	"CVE-2026-17659;II;"
	"CVE-2026-17660;IV;"
	"CVE-2026-17661;UAF;"
	"CVE-2026-17662;ISPE;"
	"CVE-2026-17663;IV;"
	"CVE-2026-17664;IV;"
	"CVE-2026-17665;UAF;"
	"CVE-2026-17666;ICI;"
	"CVE-2026-17667;BUSE;"
	"CVE-2026-17668;BUSE;"
	"CVE-2026-17669;II;"
	"CVE-2026-17670;UAF;"
	"CVE-2026-17671;IV;"
	"CVE-2026-17672;IV;"
	"CVE-2026-17673;IO;"
	"CVE-2026-17674;II;"
	"CVE-2026-17675;OOBW;"
	"CVE-2026-17676;II;"
	"CVE-2026-17677;II;"
	"CVE-2026-17678;OOBR;"
	"CVE-2026-17679;IV;"
	"CVE-2026-17680;HO;"
	"CVE-2026-17681;IV;"
	"CVE-2026-17682;IO;"
	"CVE-2026-17683;II;"
	"CVE-2026-17684;IV;"
	"CVE-2026-17685;UAF;"
	"CVE-2026-17686;IV;"
	"CVE-2026-17687;TC;"
	"CVE-2026-17688;UAF;"
	"CVE-2026-17689;BUSE;"
	"CVE-2026-17690;IV;"
	"CVE-2026-17691;OOBW;"
	"CVE-2026-17692;UAF;"
	"CVE-2026-17693;II;"
	"CVE-2026-17694;UAF;"
	"CVE-2026-17695;II;"
	"CVE-2026-17696;ID, SC;"
	"CVE-2026-17697;TC;"
	"CVE-2026-17698;IV;"
	"CVE-2026-17699;UAF;"
	"CVE-2026-17700;IV;"
	"CVE-2026-17701;OOBR;"
	"CVE-2026-17702;II;"
	"CVE-2026-17703;BPB;"
	"CVE-2026-17704;UAF;"
	"CVE-2026-17705;IO;"
	"CVE-2026-17706;IV;"
	"CVE-2026-17707;BUSE;"
	"CVE-2026-17708;UAF;"
	"CVE-2026-17709;RC;"
	"CVE-2026-17710;II;"
	"CVE-2026-17711;RC;"
	"CVE-2026-17712;RC;"
	"CVE-2026-17713;IV;"
	"CVE-2026-17714;BUSE;"
	"CVE-2026-17715;II;"
	"CVE-2026-17716;UAF;"
	"CVE-2026-17717;IO;"
	"CVE-2026-17718;UAF;"
	"CVE-2026-17719;UAF;"
	"CVE-2026-17720;ISPE;"
	"CVE-2026-17721;OOBW;"
	"CVE-2026-17722;BOIL;"
	"CVE-2026-17723;UAF;"
	"CVE-2026-17724;RC;"
	"CVE-2026-17725;TC;"
	"CVE-2026-17726;IO;"
	"CVE-2026-17727;OOBW;"
	"CVE-2026-17728;II;"
	"CVE-2026-17758;HO;"
	"CVE-2026-17732;II;"
	"CVE-2026-17729;UAF;"
	"CVE-2026-17730;ID, SC;"
	"CVE-2026-17731;II;"
	"CVE-2026-17733;II;"
	"CVE-2026-17734;II;"
	"CVE-2026-17735;IV;"
	"CVE-2026-17736;IV;"
	"CVE-2026-17737;UAF;"
	"CVE-2026-17738;IV;"
	"CVE-2026-17739;ISPE;"
	"CVE-2026-17740;BUSE;"
	"CVE-2026-17741;IV;"
	"CVE-2026-17742;ISPE;"
	"CVE-2026-17743;ISPE;"
	"CVE-2026-17744;II;"
	"CVE-2026-17745;OOBR;"
	"CVE-2026-17746;UAF;"
	"CVE-2026-17747;IV;"
	"CVE-2026-17748;II;"
	"CVE-2026-17749;IV;"
	"CVE-2026-17750;UAF;"
	"CVE-2026-17751;II;"
	"CVE-2026-17752;UAF;"
	"CVE-2026-17753;II;"
	"CVE-2026-17754;II;"
	"CVE-2026-17755;BISI;"
	"CVE-2026-17756;ISPE;"
	"CVE-2026-17757;BUSE;"
	"CVE-2026-17759;BUSE;"
	"CVE-2026-17760;ID, SC;"
	"CVE-2026-17761;IV;"
	"CVE-2026-17762;II;"
	"CVE-2026-17763;II;"
	"CVE-2026-17764;II;"
	"CVE-2026-17765;II;"
	"CVE-2026-17766;IV;"
	"CVE-2026-17767;IV;"
	"CVE-2026-17768;IV;"
	"CVE-2026-17769;IV;"
	"CVE-2026-17770;OOBR;"
	"CVE-2026-17771;BUSE;"
	"CVE-2026-17772;OOBR;"
	"CVE-2026-17773;IV;"
	"CVE-2026-17774;IV;"
	"CVE-2026-17775;II;"
	"CVE-2026-17776;BPB;"
	"CVE-2026-17777;II;"
	"CVE-2026-17778;UAF;"
	"CVE-2026-17779;II;"
	"CVE-2026-17780;II;"
	"CVE-2026-17781;II;"
	"CVE-2026-17782;BISI;"
	"CVE-2026-17783;II;"
	"CVE-2026-17784;UAF;"
	"CVE-2026-17785;BUSE;"
	"CVE-2026-17786;IV;"
	"CVE-2026-17787;II;"
	"CVE-2026-17788;II;"
	"CVE-2026-17789;IV;"
	"CVE-2026-17790;BUSE;"
	"CVE-2026-17791;IV;"
	"CVE-2026-17792;II;"
	"CVE-2026-17793;II;"
	"CVE-2026-17794;IV;"
	"CVE-2026-17795;IV;"
	"CVE-2026-17796;ID, SC;"
	"CVE-2026-17797;II;"
	"CVE-2026-17798;II;"
	"CVE-2026-17799;IV;"
	"CVE-2026-17800;ID, SC;"
	"CVE-2026-17801;OOBA;"
	"CVE-2026-17802;ID, SC;"
	"CVE-2026-17803;IV;"
	"CVE-2026-17804;UAF;"
	"CVE-2026-17805;ISPE;"
	"CVE-2026-17806;IV;"
	"CVE-2026-17807;UAF;"
	"CVE-2026-17808;BUSE;"
	"CVE-2026-17809;IV;"
	"CVE-2026-17810;BUSE;"
	"CVE-2026-17811;UAF;"
	"CVE-2026-17812;II;"
	"CVE-2026-17813;ISPE;"
	"CVE-2026-17814;IV;"
	"CVE-2026-17815;ISPE;"
	"CVE-2026-17816;II;"
	"CVE-2026-17817;II;"
	"CVE-2026-17818;II;"
	"CVE-2026-17819;II;"
	"CVE-2026-17820;ISPE;"
	"CVE-2026-17821;ISPE;"
	"CVE-2026-17822;II;"
	"CVE-2026-17823;ISPE;"
	"CVE-2026-17824;ISPE;"
	"CVE-2026-17825;ISPE;"
	"CVE-2026-17826;II;"
	"CVE-2026-17827;II;"
	"CVE-2026-17828;II;"
	"CVE-2026-17829;ISPE;"
	"CVE-2026-17830;II;"
	"CVE-2026-17831;IV;"
	"CVE-2026-17832;UAF;"
	"CVE-2026-17833;II;"
	"CVE-2026-17834;II;"
	"CVE-2026-17835;II;"
	"CVE-2026-17836;UAF;"
	"CVE-2026-17837;IV;"
	"CVE-2026-17838;BISI;"
	"CVE-2026-17839;II;"
	"CVE-2026-17840;BISI;"
	"CVE-2026-17841;RC;"
	"CVE-2026-17842;II;"
	"CVE-2026-17843;II;"
	"CVE-2026-17844;IV;"
	"CVE-2026-17845;II;"
	"CVE-2026-17846;II;"
	"CVE-2026-17847;IV;"
	"CVE-2026-17848;IV;"
	"CVE-2026-17849;II;"
	"CVE-2026-17850;II;"
	"CVE-2026-17851;ID, SC;"
	"CVE-2026-17852;II;"
	"CVE-2026-17853;II;"
	"CVE-2026-17854;ISPE;"
	"CVE-2026-17855;RC;"
	"CVE-2026-17856;II;"
	"CVE-2026-17857;II;"
	"CVE-2026-17858;BUSE;"
	"CVE-2026-17859;ID, SC;"
	"CVE-2026-17860;IV;"
	"CVE-2026-17861;IV;"
	"CVE-2026-17862;UAF;"
	"CVE-2026-17863;II;"
	"CVE-2026-17864;II;"
	"CVE-2026-17865;II;"
	"CVE-2026-17866;TC;"
	"CVE-2026-17867;IV;"
	"CVE-2026-17868;ISPE;"
	"CVE-2026-17869;OOBR;"
	"CVE-2026-17870;IV;"
	"CVE-2026-17871;II;"
	"CVE-2026-17872;ICI;"
	"CVE-2026-17873;ISPE;"
	"CVE-2026-17874;II;"
	"CVE-2026-17875;UAF;"
	"CVE-2026-17876;II;"
	"CVE-2026-17877;II;"
	"CVE-2026-17878;II;"
	"CVE-2026-17879;II;"
	"CVE-2026-17880;II;"
	"CVE-2026-17881;UAF;"
	"CVE-2026-17882;BPB;"
	"CVE-2026-17883;II;"
	"CVE-2026-17884;BOIL;"
	"CVE-2026-17885;II;"
	"CVE-2026-17886;UAF;"
	"CVE-2026-17887;UAF;"
	"CVE-2026-17888;IV;"
	"CVE-2026-17889;BUSE;"
	"CVE-2026-17890;IV;"
	"CVE-2026-17891;UAF;"
	"CVE-2026-17892;II;"
	"CVE-2026-17893;IV;"
	"CVE-2026-17894;UAF;"
	"CVE-2026-17895;II;"
	"CVE-2026-17896;UAF;"
	"CVE-2026-17897;II;"
	"CVE-2026-17898;UAF;"
	"CVE-2026-17899;ISPE;"
	"CVE-2026-17900;II;"
	"CVE-2026-17901;II;"
	"CVE-2026-17902;II;"
	"CVE-2026-17903;ISPE;"
	"CVE-2026-17904;ISPE;"
	"CVE-2026-17905;II;"
	"CVE-2026-17906;IV;"
	"CVE-2026-17907;ID, SC;"
	"CVE-2026-17908;IV;"
	"CVE-2026-17909;IV;"
	"CVE-2026-17910;ISPE;"
	"CVE-2026-17911;ISPE;"
	"CVE-2026-17912;II;"
	"CVE-2026-17913;II;"
	"CVE-2026-17914;ID, SC;"
	"CVE-2026-17915;II;"
	"CVE-2026-17916;ISPE;"
	"CVE-2026-17917;BPB;"
	"CVE-2026-17918;UAF;"
	"CVE-2026-17919;ISPE;"
	"CVE-2026-17920;UAF;"
	"CVE-2026-17921;IV;"
	"CVE-2026-17922;II;"
	"CVE-2026-17923;BPB;"
	"CVE-2026-17924;UAF;"
	"CVE-2026-17925;II;"
	"CVE-2026-17926;IV;"
	"CVE-2026-17927;ISPE;"
	"CVE-2026-17928;II;"
	"CVE-2026-17929;IV;"
	"CVE-2026-17930;IV;"
	"CVE-2026-17931;II;"
	"CVE-2026-17932;UAF;"
	"CVE-2026-17933;II;"
	"CVE-2026-17934;IV;"
	"CVE-2026-17935;HO;"
	"CVE-2026-17936;II;"
	"CVE-2026-17937;II;"
	"CVE-2026-17938;II;"
	"CVE-2026-17939;II;"
	"CVE-2026-17940;IV;"
	"CVE-2026-17941;II;"
	"CVE-2026-17942;ID, SC;"
	"CVE-2026-17943;II;"
	"CVE-2026-17944;II;"
	"CVE-2026-17945;II;"
	"CVE-2026-17946;BUSE;"
	"CVE-2026-17947;UAF;"
	"CVE-2026-17948;TC;"
	"CVE-2026-17949;BUSE;"
	"CVE-2026-17950;BPB;"
	"CVE-2026-17951;HO;"
	"CVE-2026-17952;II;"
	"CVE-2026-17953;ISPE;"
	"CVE-2026-17954;BPB;"
	"CVE-2026-17955;IV;"
	"CVE-2026-17956;II;"
	"CVE-2026-17957;II;"
	"CVE-2026-17958;II;"
	"CVE-2026-17959;II;"
	"CVE-2026-17960;II;"
	"CVE-2026-17961;II;"
	"CVE-2026-17962;II;"
	"CVE-2026-17963;II;"
	"CVE-2026-17964;BISI;"
	"CVE-2026-17965;BISI;"
	"CVE-2026-17966;II;"
	"CVE-2026-17967;UAF;"
	"CVE-2026-17968;BUSE;"
	"CVE-2026-17969;II;"
	"CVE-2026-17970;IV;"
	"CVE-2026-17971;II;"
	"CVE-2026-17972;II;"
	"CVE-2026-17973;II;"
	"CVE-2026-17974;ISPE;"
	"CVE-2026-17975;II;"
	"CVE-2026-17976;BPB;"
	"CVE-2026-17977;BPB;"
	"CVE-2026-17978;ID, SC;"
	"CVE-2026-17979;RC;"
	"CVE-2026-17980;II;"
	"CVE-2026-17981;II;"
	"CVE-2026-17982;IV;"
	"CVE-2026-17983;BISI;"
	"CVE-2026-17984;II;"
	"CVE-2026-17985;ISPE;"
	"CVE-2026-17986;ISPE;"
	"CVE-2026-17987;IV;"
	"CVE-2026-17988;IV;"
	"CVE-2026-17989;TC;"
	"CVE-2026-17990;IV;"
	"CVE-2026-17991;IV;"
	"CVE-2026-17992;BUSE;"
	"CVE-2026-17993;RC;"
	"CVE-2026-17994;II;"
	"CVE-2026-17995;OOBR;"
	"CVE-2026-17996;II;"
	"CVE-2026-17997;II;"
	"CVE-2026-17998;BISI;"
	"CVE-2026-17999;BISI;"
	"CVE-2026-18000;ISPE;"
	"CVE-2026-18001;II;"
	"CVE-2026-18002;IV;"
	"CVE-2026-18003;II;"
	"CVE-2026-18004;ISPE;"
	"CVE-2026-18005;II;"
	"CVE-2026-18006;II;"
	"CVE-2026-18007;II;"
	"CVE-2026-18008;II;"
	"CVE-2026-18009;IV;"
	"CVE-2026-18010;II;"
	"CVE-2026-18011;II;"
	"CVE-2026-18012;UAF;"
	"CVE-2026-18013;II;"
	"CVE-2026-18014;IV;"
	"CVE-2026-18015;II;"
	"CVE-2026-18016;ISPE;"
	"CVE-2026-18017;UAF;"
	"CVE-2026-18018;II;"
	"CVE-2026-18019;ID, SC;"
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
