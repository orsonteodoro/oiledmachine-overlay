# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This fork of nano is based on 2.9.3_p20180208

EAPI=7
DESCRIPTION="GNU GPL'd Pico clone with more functionality with ycmd support"
HOMEPAGE="https://www.nano-editor.org/ \
https://wiki.gentoo.org/wiki/Nano/Basics_Guide
https://github.com/orsonteodoro/nano-ycmd"
LICENSE="GPL-3+ LGPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="debug justify libgcrypt +magic minimal ncurses nettle nls slang +spell \
static openmp openssl system-gnulib system-gocode system-godef system-racerd \
unicode"
PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1
REQUIRED_USE="${PYTHON_REQUIRED_USE}
	      ^^ ( libgcrypt nettle openssl )"
YCMD_SLOT="1"
LIB_DEPEND="
	magic? ( sys-apps/file:=[static-libs(+)] )
	!ncurses? ( slang? ( sys-libs/slang:=[static-libs(+)] ) )
	nls? ( virtual/libintl )
	>=sys-libs/ncurses-5.9-r1:0=[unicode?]
	sys-libs/ncurses:0=[static-libs(+)]"
RDEPEND="${PYTHON_DEPS}
	>=app-shells/bash-4
	dev-libs/nxjson
	dev-util/bear[${PYTHON_SINGLE_USEDEP}]
	dev-util/ninja
	$(python_gen_cond_dep 'dev-util/ycm-generator[${PYTHON_USEDEP}]' python3_{6,7,8})
	$(python_gen_cond_dep 'dev-util/ycmd:'${YCMD_SLOT}'[${PYTHON_USEDEP}]' python3_{6,7,8} )
	libgcrypt? ( dev-libs/libgcrypt )
	nettle? ( dev-libs/nettle )
	net-libs/neon
	openmp? ( sys-libs/libomp )
	openssl? ( dev-libs/openssl
		   dev-libs/glib )
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )"
DEPEND="system-gnulib? ( >=dev-libs/gnulib-2018.01.23.08.42.00 )"
BDEPEND="nls? ( sys-devel/gettext )
	static? ( ${LIB_DEPEND} )
	virtual/pkgconfig"
inherit autotools eutils flag-o-matic
EGIT_COMMIT="14e4255c52c9f64cabaa2af28354e9752d27ae65"
GNULIB_COMMIT="4a236f16ce0ef97094ff2f6538d4dba90e72a523" # listed in ./autogen.sh
GNULIB_COMMIT_SHORT="${GNULIB_COMMIT:0:7}"
SRC_URI=\
"https://github.com/orsonteodoro/nano-ycmd/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}.tar.gz
http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=snapshot;h=${GNULIB_COMMIT};sf=tgz \
	-> gnulib-${GNULIB_COMMIT_SHORT}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_unpack() {
	unpack ${A}
	mv gnulib-${GNULIB_COMMIT_SHORT} "${S}/gnulib" || die
}

src_prepare() {
	default
	eapply "${FILESDIR}/${PN}-9999.20180201-rename-as-ynano.patch"
	if use system-gnulib ; then
		eapply "${FILESDIR}/${PN}-9999.20180201-autogen-use-system-gnulib.patch"
		./autogen.sh
	else
		eapply "${FILESDIR}/${PN}-9999.20180201-autogen-no-git.patch"
		./autogen.sh
	fi
}

src_configure() {
	if use ycmd-slot-1 ; then
		ycmd_slot=1
	elif use ycmd-slot-2 ; then
		ycmd_slot=2
	fi
	BD_REL="ycmd/${ycmd_slot}"
	BD_ABS="$(python_get_sitedir)/${BD_REL}"
	use static && append-ldflags -static
	local myconf=()
	case ${CHOST} in
		*-gnu*|*-uclibc*)
			myconf+=( "--with-wordbounds" )
			;; #467848
	esac

	local gocode_path=""
	local godef_path=""
	local racerd_path=""
	if use system-gocode ; then
		gocode_path="/usr/bin/gocode"
	else
		gocode_path="${BD_ABS}/third_party/gocode/gocode"
	fi
	if use system-godef ; then
		godef_path="/usr/bin/godef"
	else
		godef_path="${BD_ABS}/third_party/godef/godef"
	fi
	if use system-racerd ; then
		racerd_path="/usr/bin/racerd"
	else
		racerd_path="${BD_ABS}/third_party/racerd/racerd"
	fi

	GOCODE_PATH="${gocode_path}" \
	GODEF_PATH="${godef_path}" \
	NINJA_PATH="/usr/bin/ninja" \
	RACERD_PATH="${racerd_path}" \
	RUST_SRC_PATH="/usr/share/rust/src" \
	YCMD_PATH="${BD_ABS}/ycmd" \
	YCMD_PYTHON_PATH="/usr/bin/${EPYTHON}" \
	YCMG_PATH="/usr/bin/config_gen.py" \
	YCMG_PYTHON_PATH="/usr/bin/${EPYTHON}" \
	econf \
		"${myconf[@]}" \
		--bindir="${EPREFIX}"/bin \
		--disable-wrapping-as-root \
		--enable-ycmd \
		--htmldir=/trash \
		$(use_enable !minimal color) \
		$(use_enable !minimal multibuffer) \
		$(use_enable !minimal nanorc) \
		$(use_enable debug) \
		$(use_enable justify) \
		$(use_enable magic libmagic) \
		$(use_enable minimal tiny) \
		$(use_enable nls) \
		$(use_enable spell speller) \
		$(use_enable unicode utf8) \
		$(use_with libgcrypt) \
		$(use_with nettle) \
		$(use_with openmp) \
		$(use_with openssl) \
		$(usex ncurses --without-slang $(use_with slang))
}

src_install() {
	default
	# removes htmldir
	rm -rf "${D}"/trash || die
	# remove merge conflicts
	rm -rf "${D}/etc/" \
		"${D}/bin/rnano" \
		"${D}/usr/share"
	dodoc doc/sample.nanorc
	docinto html
	dodoc doc/faq.html
	insinto /etc
	newins doc/sample.nanorc nanorc
	if ! use minimal ; then
		# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}"/etc/nanorc || die
	fi
	dodir /usr/bin
	dosym /bin/ynano /usr/bin/ynano
}
