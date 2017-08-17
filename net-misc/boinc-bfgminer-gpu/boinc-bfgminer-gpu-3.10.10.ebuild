# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils flag-o-matic

DESCRIPTION="Modular Bitcoin ASIC/FPGA/GPU/CPU miner in C"
HOMEPAGE="https://bitcointalk.org/?topic=168174"
SRC_URI="http://luke.dashjr.org/programs/bitcoin/files/bfgminer/${PV}/bfgminer-${PV}.tbz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

# TODO: knc (needs i2c-tools header)
IUSE="+adl antminer avalon bifury bitforce bfsb bigpic bitfury cpumining drillbit examples hardened hashbuster hashbuster2 hashfast icarus klondike +libusb littlefury lm_sensors metabank modminer nanofury ncurses +opencl proxy proxy_getwork proxy_stratum screen scrypt twinfury +udev unicode x6500 ztex pgo boinc"
REQUIRED_USE='
	|| ( antminer avalon bfsb bifury bigpic bitforce bitfury cpumining drillbit hashbuster hashbuster2 hashfast icarus klondike littlefury metabank modminer nanofury opencl proxy twinfury x6500 ztex )
	adl? ( opencl )
	bfsb? ( bitfury )
	bigpic? ( bitfury )
	drillbit? ( bitfury )
	hashbuster? ( bitfury )
	hashbuster2? ( bitfury libusb )
	klondike? ( libusb )
	littlefury? ( bitfury )
	lm_sensors? ( opencl )
	metabank? ( bitfury )
	nanofury? ( bitfury )
	scrypt? ( || ( cpumining opencl proxy ) )
	twinfury? ( bitfury )
	unicode? ( ncurses )
	proxy? ( || ( proxy_getwork proxy_stratum ) )
	proxy_getwork? ( proxy )
	proxy_stratum? ( proxy )
	x6500? ( libusb )
	ztex? ( libusb )
	boinc
'

DEPEND='
	!net-misc/bfgminer
	boinc? ( sci-misc/boinc sci-misc/boinc-server )
	net-misc/curl
	ncurses? (
		sys-libs/ncurses:=[unicode?]
	)
	>=dev-libs/jansson-2
	net-libs/libblkmaker:=
	udev? (
		virtual/udev
	)
	hashbuster? (
		dev-libs/hidapi
	)
	libusb? (
		virtual/libusb:1
	)
	lm_sensors? (
		sys-apps/lm_sensors
	)
	nanofury? (
		dev-libs/hidapi
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
	sys-devel/automake:1.14
"

S="${WORKDIR}/bfgminer-${PV}"

pkg_setup() {
	if use pgo; then
		if [[ -z "${BOINC_BFGMINER_GPU_ARGS}" ]]; then
			die "Configure your BOINC_BFGMINER_GPU_ARGS to use for PGO optimization.  You must set the number of shares (--shares) or you will get an infinite loop."
		fi
	fi
}

src_prepare() {
	eapply "${FILESDIR}"/bfgminer-3.10.5-boinc.patch
	eapply "${FILESDIR}"/boinc-bfgminer-3.10.10-2.patch
	eapply "${FILESDIR}"/boinc-bfgminer-3.10.10-3.patch
	eapply "${FILESDIR}"/boinc-bfgminer-3.10.10-4.patch
	eapply "${FILESDIR}"/boinc-bfgminer-3.10.10-5.patch
	eapply "${FILESDIR}"/boinc-bfgminer-3.10.10-disableinitforwrapper.patch

	eapply_user
}

src_configure() {
	true
	#conf run in src_compile
}

function run_config {
	local CFLAGS="${CFLAGS}"
	local with_curses

	if use hardened ; then
		append-cflags -nopie
		append-cxxflags -nopie
		append-ldflags -nopie
	fi

	if use ncurses; then
		if use unicode; then
			with_curses='--with-curses=ncursesw'
		else
			with_curses='--with-curses=ncurses'
		fi
	else
		with_curses='--without-curses'
	fi

	append-cppflags -D_GLIBCXX_USE_CXX11_ABI=0

	LIBS="${LIBS} ${PGO_LIBS}" \
	LDFLAGS="${LDFLAGS} ${PGO_LDFLAGS}" \
	CPPFLAGS="${CPPFLAGS} ${PGO_CPPFLAGS}" \
	CFLAGS="${CFLAGS} ${PGO_CFLAGS}" \
	CXXFLAGS="${CXXFLAGS} ${PGO_CXXFLAGS}" \
	econf \
		--docdir="/usr/share/doc/${PF}" \
		$(use_enable adl) \
		$(use_enable antminer) \
		$(use_enable avalon) \
		$(use_enable bifury) \
		$(use_enable bitforce) \
		$(use_enable bfsb) \
		$(use_enable bigpic) \
		$(use_enable bitfury) \
		$(use_enable cpumining) \
		$(use_enable drillbit) \
		$(use_enable hashbuster) \
		$(use_enable hashbuster2 hashbusterusb) \
		$(use_enable hashfast) \
		$(use_enable icarus) \
		$(use_enable klondike) \
		$(use_enable littlefury) \
		$(use_enable metabank) \
		$(use_enable modminer) \
		$(use_enable nanofury) \
		$(use_enable opencl) \
		$(use_enable scrypt) \
		$(use_enable twinfury) \
		--with-system-libblkmaker \
		$with_curses \
		$(use_with udev libudev) \
		$(use_with lm_sensors sensors) \
		$(use_with proxy_getwork libmicrohttpd) \
		$(use_with proxy_stratum libevent) \
		$(use_enable x6500) \
		$(use_enable ztex)
}

src_compile() {
        cd "${S}"

	INSTRUMENT_CFLAGS=""
	INSTRUMENT_LDFLAGS=""
	INSTRUMENT_LIBS=""
	PROFILE_DATA_CFLAGS=""
	PROFILE_DATA_LDFLAGS=""
	PROFILE_DATA_LIBS=""
	if [[ "${CC}" == "gcc" || "${CXX}" == "g++" ]]; then
		INSTRUMENT_CFLAGS="-fprofile-generate"
		INSTRUMENT_LDFLAGS="-fprofile-generate"
		INSTRUMENT_LIBS=""

		PROFILE_DATA_CFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LDFLAGS="-fprofile-use -fprofile-correction"
		PROFILE_DATA_LIBS=""
	elif [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
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
		PGO_CFLAGS="${INSTRUMENT_CFLAGS}" PGO_CXXFLAGS="${INSTRUMENT_CFLAGS}" PGO_CPPFLAGS="${INSTRUMENT_CFLAGS}" PGO_LDFLAGS="${INSTRUMENT_LDFLAGS}" PGO_LIBS="${INSTRUMENT_LIBS}" run_config
                emake || die
                einfo "Please wait while we are simulating work for the PGO optimization.  This may take hours."
       	        LOG=$(LLVM_PROFILE_FILE="${T}/code-%p.profraw" ./bfgminer -S opencl:auto ${BOINC_BFGMINER_GPU_ARGS})
		echo "${LOG}" | grep "Mined 2 accepted shares of 1 requested"
                if [[ "$?" != "0" ]] ; then
                        die "simulating failed"
                fi
		if [[ "${CC}" == "clang" || "${CXX}" == "clang++" ]]; then
			llvm-profdata merge -output="${T}"/code.profdata "${T}"/code-*.profraw
		fi
                make clean
		PGO_CFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CXXFLAGS="${PROFILE_DATA_CFLAGS}" PGO_CPPFLAGS="${PROFILE_DATA_CFLAGS}" PGO_LDFLAGS="${PROFILE_DATA_LDFLAGS}" PGO_LIBS="${PROFILE_DATA_LIBS}" run_config
                emake || die
        else
		PGO_CFLAGS="" PGO_CXXFLAGS="" PGO_CPPFLAGS="" PGO_LDFLAGS="" PGO_LIBS="" run_config
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
	mv "${D}"/usr/bin/bfgminer "${D}"/usr/bin/bfgminer-gpu
	mv "${D}"/usr/bin/bfgminer-rpc "${D}"/usr/bin/bfgminer-rpc-gpu
}

pkg_postinst() {
	einfo "The result.txt contains the result."
}
