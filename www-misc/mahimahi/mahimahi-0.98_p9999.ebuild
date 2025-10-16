# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libstdcxx-compat
GCC_COMPAT=(
	${LIBSTDCXX_COMPAT_STDCXX20[@]}
)
PYTHON_COMPAT=( "python3_"{8..11} )

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/ravinet/mahimahi.git"
	FALLBACK_COMMIT="f1346c38c415abfc98626dd82450f49a57033603" # Apr 14, 2025
	inherit git-r3
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
else
	SRC_URI="
		FIXME
	"
	S="${WORKDIR}/${P}"
	die "FIXME"
fi

inherit autotools libstdcxx-slot

DESCRIPTION="Web performance measurement toolkit"
HOMEPAGE="
http://mahimahi.mit.edu/
https://github.com/ravinet/mahimahi
"
LICENSE="GPL-3+"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" alt-ssl gnuplot +sudo +sysctl"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
"
DEPEND+="
	${PYTHON_DEPS}
	>=www-servers/apache-2[apache2_modules_authz_core,apache2_mpms_prefork,ssl]
	app-misc/ssl-cert-snakeoil
	dev-libs/apr
	dev-libs/protobuf:=
	net-firewall/iptables
	net-dns/dnsmasq
	sys-apps/iproute2
	x11-libs/libxcb
	x11-libs/pango
	virtual/libc
	gnuplot? (
		sci-visualization/gnuplot
	)
	sudo? (
		app-admin/sudo
	)
	sysctl? (
		sys-process/procps
	)
	|| (
		>=dev-libs/openssl-3
		alt-ssl? (
			virtual/libc
		)
	)
"
# >=openssl-3 is only allowed for gpl3 compatibility
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	${PYTHON_DEPS}
	virtual/libc
"
SRC_URI="
"
RESTRICT="mirror"

PATCHES=(
	"${FILESDIR}/${PN}-0.98-remove-prefork.patch"
	"${FILESDIR}/${PN}-0.98-BUFFER_SIZE.patch"
)

unpack_live() {
	use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
	git-r3_fetch
	git-r3_checkout
	local actual_version=$(grep "AC_INIT" "${S}/configure.ac" \
		| cut -f 2 -d "," \
		| sed -e "s| \[||" -e "s|\]||")
	local expected_version=$(ver_cut 1-2 "${PV}")
	if ver_test "${actual_version}" -ne "${expected_version}" ; then
eerror
eerror "A version inconsistency detected which may change DEPENDs."
eerror
eerror "Expected version:\t${expected_version}"
eerror "Actual version:\t${actual_version}"
eerror
eerror "Use the fallback-commit USE flag to continue."
eerror
		die
	fi
}

pkg_setup() {
	libstdcxx-slot_verify
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		unpack_live
	else
		unpack ${A}
	fi
}

src_configure() {
	eautoreconf
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${ED}" install
}

pkg_postinst() {
einfo
einfo "This package requires the changes to the kernel .config:"
einfo
einfo "  CONFIG_EXPERT=y"
einfo "  CONFIG_PROC_FS=y"
einfo "  CONFIG_PROC_SYSCTL=y"
einfo "  CONFIG_SYSCTL=y"
einfo "  CONFIG_NET=y"
einfo "  CONFIG_INET=y"
einfo "  CONFIG_NETDEVICES=y"
einfo "  CONFIG_NET_CORE=y"
einfo "  CONFIG_INET=y"
einfo "  CONFIG_TUN=y"
einfo
einfo
einfo "Port forwarding is required with either 1 of the following:"
einfo
	if use sysctl ; then
einfo "  sysctl -w net.ipv4.ip_forward=1           # as root"
einfo "  sudo sysctl -w net.ipv4.ip_forward=1      # as non-root with sudo"
einfo "  pkexec sysctl -w net.ipv4.ip_forward=1    # as non-root with pkexec/polkit"
	else
einfo "  echo 1 > /proc/sys/net/ipv4/ip_forward                                          # as root"
einfo "  echo 1 | sudo dd oflag=append conv=notrunc of=/proc/sys/net/ipv4/ip_forward     # as non-root with sudo"
einfo "  echo 1 | pkexec dd oflag=append conv=notrunc of=/proc/sys/net/ipv4/ip_forward   # as non-root with pkexec/polkit"
	fi
einfo
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
