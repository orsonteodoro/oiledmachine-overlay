# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE UAF"

PYTHON_COMPAT=( python3_{10..14} )

CHKL_TIMESTAMPS=(
	"app-accessibility/espeak-ng-9999"
	"dev-libs/dotconf-9999"
	"dev-libs/glib-2.89.9999"
	"media-libs/alsa-lib-9999"
	"media-libs/libpulse-9999"
	"media-libs/libsndfile-9999"
	"media-video/pipewire-9999"
	"sys-apps/systemd-9999"
)

inherit autotools cflags-hardened chkl python-r1 systemd secure-version toolchain-funcs

if [[ "${PV}" =~ "9999" ]] ; then
	FALLBACK_COMMIT="7d0902d531800ef93ed4239b44c355481910217d"
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://github.com/brailcom/speechd.git"
	if [[ -n "${FALLBACK_COMMIT}" ]] ; then
		IUSE+=" fallback-commit"
	fi
	inherit git-r3
else
	SRC_URI="https://github.com/brailcom/speechd/releases/download/${PV}/${P}.tar.gz"
fi

DESCRIPTION="Speech synthesis interface"
HOMEPAGE="https://freebsoft.org/speechd"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~sparc x86"
IUSE+=" alsa ao +espeak flite nas pulseaudio pipewire +python systemd"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="python? ( ${PYTHON_DEPS} )
	>=dev-libs/dotconf-${DOTCONF_PV}:=
	>=dev-libs/glib-${GLIB_PV}:=
	>=media-libs/libsndfile-${LIBSNDFILE_PV}:=
	alsa? ( >=media-libs/alsa-lib-${ALSA_LIB_PV}:= )
	ao? ( media-libs/libao:= )
	espeak? ( >=app-accessibility/espeak-ng-${ESPEAK_NG_PV}:= )
	flite? ( >=app-accessibility/flite-${FLITE_PV}:= )
	nas? ( >=media-libs/nas-${NAS_PV}:= )
	pulseaudio? ( >=media-libs/libpulse-${LIBPULSE_PV}:= )
	pipewire? ( >=media-video/pipewire-${PIPEWIRE_PV}:= )
	systemd? ( >=sys-apps/systemd-${SYSTEMD_PV}:= )
"
RDEPEND="${DEPEND}
	python? ( dev-python/pyxdg:=[${PYTHON_USEDEP}] )"
BDEPEND="
	sys-apps/help2man
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig"

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
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
	eautoreconf
}

src_configure() {
	chkl_check_many_timestamps
	cflags-hardened_append

	# bug 573732
	export GIT_CEILING_DIRECTORIES="${WORKDIR}"

	# manpages can't be generated w/o launching programs
	tc-is-cross-compiler && export ac_cv_prog_HELP2MAN=

	local myeconfargs=(
		--disable-ltdl
		--disable-python
		--disable-static
		--with-baratinoo=no
		--with-ibmtts=no
		--with-kali=no
		--with-pico=no
		--with-voxin=no
		--with-espeak=no
		$(use_with alsa)
		$(use_with ao libao)
		$(use_with espeak espeak-ng)
		$(use_with flite)
		$(use_with nas)
		$(use_with pulseaudio pulse)
		$(use_with pipewire)
		# Technically we should always install these under the "small files" QA
		# rule. But upstream uses presence of the user unit dir to define
		# USE_LIBSYSTEMD and link in code which consumes systemd/sd-daemon.h,
		# and the corresponding *user* files have a hard dependency on that
		# code. There is no standalone --with-systemd.
		"$(use_with systemd systemdsystemunitdir "$(systemd_get_systemunitdir)")"
		"$(use_with systemd systemduserunitdir "$(systemd_get_userunitdir)")"
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	use python && python_copy_sources

	# LDFLAGS fixed in master, remove w/ >0.12.1
	emake LDFLAGS="${LDFLAGS}"

	if use python; then
		building() {
			cd src/api/python || die
			emake \
				pyexecdir="$(python_get_sitedir)" \
				pythondir="$(python_get_sitedir)"
		}
		python_foreach_impl run_in_build_dir building
	fi
}

src_install() {
	default

	if use python; then
		installation() {
			cd src/api/python || die
			emake \
				DESTDIR="${D}" \
				pyexecdir="$(python_get_sitedir)" \
				pythondir="$(python_get_sitedir)" \
				install
		}
		python_foreach_impl run_in_build_dir installation
		python_replicate_script "${ED}"/usr/bin/spd-conf
		python_foreach_impl python_optimize
	fi

	find "${D}" -name '*.la' -type f -delete || die
}

pkg_postinst() {
	local editconfig="n"
	if ! use espeak; then
		ewarn "You have disabled espeak-ng, which is speech-dispatcher's"
		ewarn "default speech synthesizer."
		ewarn
		editconfig="y"
	fi
	if ! use pulseaudio; then
		ewarn "You have disabled pulseaudio support."
		ewarn "pulseaudio is speech-dispatcher's default audio subsystem."
		ewarn
		editconfig="y"
	fi
	if [[ "${editconfig}" == "y" ]]; then
		ewarn "You must edit ${EROOT}/etc/speech-dispatcher/speechd.conf"
		ewarn "and make sure the settings there match your system."
		ewarn
	fi

	if tc-is-cross-compiler; then
		ewarn "The manpages are not generated due to cross-compilation."
		ewarn "Launching the commands with --help is equivalent."
	fi
}
