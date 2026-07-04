# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

MY_PV="${PV/_pre*}"
MY_P="pulseaudio-${MY_PV}"

CFLAGS_HARDENED_USE_CASES="untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CRSH DOS DF H MC ML PE OOB RC SYM"

CHKL_TIMESTAMPS=(
	"dev-libs/glib-2.89.9999"
	"media-libs/libsndfile-9999"
	"sys-apps/dbus-9999"
	"sys-apps/systemd-9999"
	"x11-libs/libX11-9999"
	"x11-libs/libxcb-9999"
)

inherit bash-completion-r1 cflags-hardened chkl flag-o-matic gnome2-utils meson-multilib optfeature secure-version systemd udev

DESCRIPTION="Libraries for PulseAudio clients"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/PulseAudio/"

if [[ ${PV} = 9999 ]]; then
	FALLBACK_COMMIT="b096704c0d42c5e784deb781a07b23cfb5286a82"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/pulseaudio/pulseaudio"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://freedesktop.org/software/pulseaudio/releases/${MY_P}.tar.xz"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
fi

LICENSE="LGPL-2.1+"

SLOT="0"
IUSE+="
+asyncns dbus doc +glib gtk pipewire pulseaudio-daemon selinux systemd test valgrind X
ebuild_revision_1
"
RESTRICT="!test? ( test )"

# NOTE: libpcre needed in some cases, bug #472228
# TODO: libatomic_ops is only needed on some architectures and conditions, and then at runtime too
RDEPEND="
	dev-libs/libatomic_ops:=
	>=media-libs/libsndfile-${LIBSNDFILE_PV}:=[${MULTILIB_USEDEP}]
	asyncns? ( >=net-libs/libasyncns-0.1:=[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-${DBUS_PV}:=[${MULTILIB_USEDEP}] )
	elibc_mingw? ( dev-libs/libpcre:= )
	glib? ( >=dev-libs/glib-${GLIB_PV}:=[${MULTILIB_USEDEP}] )
	gtk? ( >=x11-libs/gtk+-${GTK3_PV}:3= )
	selinux? ( sec-policy/selinux-pulseaudio:* )
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
	valgrind? ( dev-debug/valgrind:= )
	X? (
		>=x11-libs/libX11-${LIBX11_PV}:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-${LIBXCB_PV}:=[${MULTILIB_USEDEP}]
	)
	!<media-sound/pulseaudio-16.1
	!<media-sound/pulseaudio-daemon-16.99.1
"

DEPEND="${RDEPEND}
	test? ( >=dev-libs/check-0.9.10:= )
	X? ( x11-base/xorg-proto:= )
"

# pulseaudio ships a bundled xmltoman, which uses XML::Parser
BDEPEND="
	>=dev-lang/perl-${PERL_PV}
	dev-perl/XML-Parser
	sys-devel/gettext
	sys-devel/m4
	virtual/libiconv
	virtual/libintl
	virtual/pkgconfig
	doc? ( app-text/doxygen )
"
PDEPEND="
	pipewire? (
		>=media-video/pipewire-${PIPEWIRE_PV}[sound-server(+)]
	)
	pulseaudio-daemon? (
		media-sound/pulseaudio-daemon
	)
"

DOCS=( NEWS README )

# patches merged upstream, to be removed with 17.1 or later bump
PATCHES=(
#	"${FILESDIR}/pulseaudio-17.0-backport-pr807.patch"
)

src_unpack() {
	if [[ ${PV} = 9999 ]]; then
		if in_iuse fallback-commit && use fallback-commit ; then
			EGIT_COMMIT="${FALLBACK_COMMIT}"
		fi
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_prepare() {
	default

	# disable autospawn by client
	sed -i -e 's:; autospawn = yes:autospawn = no:g' src/pulse/client.conf.in || die

	gnome2_environment_reset
}

multilib_src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append
	append-ldflags $(test-flags-CCLD -Wl,--undefined-version)

	local emesonargs=(
		--localstatedir="${EPREFIX}"/var

		-Ddaemon=false
		-Dclient=true
		$(meson_native_use_feature doc doxygen)
		-Dgcov=false
		# tests involve random modules, so just do them for the native # TODO: tests should run always
		$(meson_native_use_feature test tests)
		-Ddatabase=simple # Not used for non-daemon, simple database avoids external dep checks
		-Dstream-restore-clear-old-devices=true
		-Drunning-from-build-tree=false

		# Paths
		-Dmodlibexecdir="${EPREFIX}/usr/$(get_libdir)/pulseaudio/modules" # Was $(get_libdir)/${P}
		-Dsystemduserunitdir=$(systemd_get_userunitdir)
		-Dudevrulesdir="${EPREFIX}$(get_udevdir)/rules.d"
		-Dbashcompletiondir="$(get_bashcompdir)" # Alternatively DEPEND on app-shells/bash-completion for pkg-config to provide the value

		# Optional features
		-Dalsa=disabled
		$(meson_feature asyncns)
		-Davahi=disabled
		-Dbluez5=disabled
		-Dbluez5-gstreamer=disabled
		-Dbluez5-native-headset=false
		-Dbluez5-ofono-headset=false
		$(meson_feature dbus)
		-Delogind=disabled
		-Dfftw=disabled
		$(meson_feature glib) # WARNING: toggling this likely changes ABI
		-Dgsettings=disabled
		-Dgstreamer=disabled
		$(meson_native_use_feature gtk)
		-Dhal-compat=false
		-Dipv6=true
		-Djack=disabled
		-Dlirc=disabled
		-Dopenssl=disabled
		-Dorc=disabled
		-Doss-output=disabled
		-Dsamplerate=disabled # Matches upstream
		-Dsoxr=disabled
		-Dspeex=disabled
		$(meson_native_use_feature systemd)
		-Dtcpwrap=disabled
		-Dudev=disabled
		$(meson_native_use_feature valgrind)
		$(meson_feature X x11)

		# Echo cancellation
		-Dadrian-aec=false
		-Dwebrtc-aec=disabled
	)

	if multilib_is_native_abi; then
		# Make padsp work for non-native ABI, supposedly only possible with glibc;
		# this is used by /usr/bin/padsp that comes from native build, thus we need
		# this argument for native build
		if use elibc_glibc; then
			emesonargs+=( -Dpulsedsp-location="${EPREFIX}"'/usr/\\$$LIB/pulseaudio' )
		fi
	else
		emesonargs+=( -Dman=false )
		if ! use elibc_glibc; then
			# Non-glibc multilib is probably non-existent but just in case:
			ewarn "padsp wrapper for OSS emulation will only work with native ABI applications!"
		fi
	fi

	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile

	if multilib_is_native_abi; then
		if use doc; then
			einfo "Generating documentation ..."
			meson_src_compile doxygen
		fi
	fi
}

multilib_src_install() {
	# The files referenced in the DOCS array do not exist in the multilib source directory,
	# therefore clear the variable when calling the function that will access it.
	DOCS= meson_src_install

	# Upstream installs 'pactl' if client is built, with all symlinks except for
	# 'pulseaudio', 'pacmd' and 'pasuspender' which are installed if server is built.
	# This trips QA warning, workaround:
	# - install missing aliases in media-libs/libpulse (client build)
	# - remove corresponding symlinks in media-sound/pulseaudio-daemonclient (server build)
	bashcomp_alias pactl pulseaudio
	bashcomp_alias pactl pacmd
	bashcomp_alias pactl pasuspender

	if multilib_is_native_abi; then
		if use doc; then
			einfo "Installing documentation ..."
			docinto html
			dodoc -r doxygen/html/.
		fi
	fi
}

multilib_src_install_all() {
	einstalldocs

	find "${ED}" \( -name '*.a' -o -name '*.la' \) -delete || die
}

pkg_postinst() {
	optfeature_header "PulseAudio can be enhanced by installing the following:"
	use dbus && optfeature "restricted realtime capabilities via D-Bus" sys-auth/rtkit
}
