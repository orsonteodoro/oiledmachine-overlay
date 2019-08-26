# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Modular Bitcoin CPU miner in C"
HOMEPAGE="https://bitcointalk.org/?topic=168174"
MY_PN="bfgminer"
SRC_URI="http://luke.dashjr.org/programs/bitcoin/files/${MY_PN}/${PV}/${MY_PN}-${PV}.txz -> ${MY_PN}-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"

IUSE="adl +cpumining examples hardened keccak lm_sensors ncurses +opencl proxy proxy_getwork proxy_stratum screen scrypt +sha256d +udev udev-broad-rules unicode"
IUSE+=" pgo boinc"
IUSE+=" video_cards_fglrx video_cards_amdgpu"
REQUIRED_USE='
	|| ( keccak scrypt sha256d )
	|| ( cpumining opencl proxy )
	adl? ( opencl )
	keccak? ( || ( cpumining opencl proxy ) )
	lm_sensors? ( opencl )
	scrypt? ( || ( cpumining opencl proxy ) )
	sha256d? ( || ( cpumining opencl proxy ) )
	unicode? ( ncurses )
	proxy? ( || ( proxy_getwork proxy_stratum ) )
	proxy_getwork? ( proxy )
	proxy_stratum? ( proxy )
'
REQUIRED_USE+='
	cpumining
	boinc
'


DEPEND='
	net-misc/curl
	ncurses? (
		sys-libs/ncurses:=[unicode?]
	)
	>=dev-libs/jansson-2
	dev-libs/libbase58
	net-libs/libblkmaker
	udev? (
		virtual/udev
	)
	lm_sensors? (
		sys-apps/lm_sensors
	)
	proxy_getwork? (
		net-libs/libmicrohttpd
	)
	proxy_stratum? (
		dev-libs/libevent
	)
	screen? (
		app-misc/screen
		|| (
			>=sys-apps/coreutils-8.15
			sys-freebsd/freebsd-bin
			app-misc/realpath
		)
	)
'
RDEPEND="${DEPEND}
	opencl? (
		|| (
			virtual/opencl
			dev-util/nvidia-cuda-sdk[opencl]
			video_cards_fglrx? ( || ( x11-drivers/ati-drivers ) )
			video_cards_amdgpu? ( || ( dev-util/amdapp x11-drivers/amdgpu-pro[opencl] ) )
		)
	)
"
DEPEND="${DEPEND}
	virtual/pkgconfig
	>=dev-libs/uthash-1.9.7
	sys-apps/sed
	cpumining? (
		amd64? (
			>=dev-lang/yasm-1.0.1
		)
		x86? (
			>=dev-lang/yasm-1.0.1
		)
	)
"
DEPEND+="
	!net-misc/bfgminer
	boinc? ( sci-misc/boinc sci-misc/boinc-server )
"

S="${WORKDIR}/bfgminer-${PV}"

pkg_setup() {
	if use pgo; then
		if [[ -z "${BOINC_BFGMINER_CPU_ARGS}" ]]; then
			die "Configure your BOINC_BFGMINER_CPU_ARGS to use for PGO optimization.  You must set the number of shares (--shares) or you will get an infinite loop."
		fi
	fi
}

src_prepare() {
        epatch "${FILESDIR}"/bfgminer-5.5.0-boinc.patch
        epatch "${FILESDIR}"/boinc-bfgminer-3.10.10-2.patch
	epatch "${FILESDIR}"/boinc-bfgminer-3.10.10-3.patch
	epatch "${FILESDIR}"/boinc-bfgminer-3.10.10-4.patch
	epatch "${FILESDIR}"/boinc-bfgminer-3.10.10-5.patch
	epatch "${FILESDIR}"/boinc-bfgminer-3.10.10-disableinitforwrapper.patch

	eapply_user
}

src_configure() {
	true
	#conf run in src_compile
}

_src_configure() {
	local CFLAGS="${CFLAGS}"
	local with_curses
	use hardened && CFLAGS="${CFLAGS} -no-pie"

	if use ncurses; then
		if use unicode; then
			with_curses='--with-curses=ncursesw'
		else
			with_curses='--with-curses=ncurses'
		fi
	else
		with_curses='--without-curses'
	fi

	LIBS="${LIBS} ${PGO_LIBS}" \
	LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}" \
	CPPFLAGS="${CPPFLAGS} ${PGO_CPPFLAGS}" \
	CFLAGS="${CFLAGS} ${PGO_CFLAGS}" \
	CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" \
	CFLAGS="${CFLAGS}" \
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable adl) \
		$(use_enable cpumining) \
		$(use_enable keccak) \
		$(use_enable opencl) \
		$(use_enable scrypt) \
		$(use_enable sha256d) \
		--with-system-libblkmaker \
		$with_curses \
		$(use_with udev libudev) \
		$(use_enable udev-broad-rules broad-udevrules) \
		$(use_with lm_sensors sensors) \
		$(use_with proxy_getwork libmicrohttpd) \
		$(use_with proxy_stratum libevent)

}

src_compile() {
        cd "${S}"

	INSTRUMENT_CFLAGS=""
	INSTRUMENT_LDFLAGS=""
	INSTRUMENT_LIBS=""
	PROFILE_DATA_CFLAGS=""
	PROFILE_DATA_LDFLAGS=""
	PROFILE_DATA_LIBS=""
	if $(tc-is-gcc); then
		INSTRUMENT_CFLAGS="-fprofile-generate"
		INSTRUMENT_LDFLAGS="-fprofile-generate"
		INSTRUMENT_LIBS=""

		PROFILE_DATA_CFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LDFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LIBS=""
	elif $(tc-is-clang); then
		INSTRUMENT_CFLAGS="-fprofile-instr-generate"
		INSTRUMENT_LDFLAGS="-fprofile-instr-generate"
		INSTRUMENT_LIBS=""

		PROFILE_DATA_CFLAGS="-fprofile-instr-use=${T}/code.profdata"
		PROFILE_DATA_LDFLAGS="-fprofile-instr-use=${T}/code.profdata"
		PROFILE_DATA_LIBS=""
	else
		die "Check your compiler CC and CXX must be clang/clang++ or gcc/g++."
	fi

        if use pgo ; then
		PGO_CFLAGS="${INSTRUMENT_CFLAGS}" PGO_CXXFLAGS="${INSTRUMENT_CFLAGS}" PGO_CPPFLAGS="${INSTRUMENT_CFLAGS}" PGO_LDFLAGS="${INSTRUMENT_LDFLAGS}" PGO_LIBS="${INSTRUMENT_LIBS}" _src_configure
                emake || die
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
		LOG=$(LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./bfgminer -S cpu:auto ${BOINC_BFGMINER_CPU_ARGS})
		echo "${LOG}" | grep "Mined 2 accepted shares of 1 requested"
                if [[ "$?" != "0" ]] ; then
                        die "simulating failed"
                fi
		if [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
			llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
		fi
                make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" _src_configure
                emake || die
        else
		PGO_CFLAGS="" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" _src_configure
                emake || die
        fi
}

src_install() {
	emake install DESTDIR="$D"
	if ! use examples; then
		rm -r "${D}/usr/share/doc/${PF}/rpc-examples"
	fi
	if ! use screen; then
		rm "${D}/usr/bin/start-bfgminer.sh"
	fi
	mv "${D}"/usr/bin/bfgminer "${D}"/usr/bin/bfgminer-cpu
	mv "${D}"/usr/bin/bfgminer-rpc "${D}"/usr/bin/bfgminer-cpu-rpc
	rm "${D}"/usr/share/bfgminer/opencl/*.cl #gpu-kernels
}

pkg_postinst() {
	einfo "The result.txt contains the result."
}
