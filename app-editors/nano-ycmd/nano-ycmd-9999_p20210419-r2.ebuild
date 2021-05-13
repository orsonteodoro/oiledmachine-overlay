# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This fork of nano is based on 5.6.1_p20210415 from the master branch

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit autotools eutils flag-o-matic python-single-r1

DESCRIPTION="GNU GPL'd Pico clone with more functionality with ycmd support"
HOMEPAGE="https://www.nano-editor.org/ \
https://wiki.gentoo.org/wiki/Nano/Basics_Guide \
https://github.com/orsonteodoro/nano-ycmd"
LICENSE="GPL-3+ LGPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+=" bear debug justify libgcrypt +magic minimal ncurses nettle ninja nls
slang +spell static openmp openssl system-clangd system-gnulib system-gocode
system-godef system-gopls system-mono system-omnisharp system-racerd system-rust
system-rustc system-tsserver unicode +ycmd-43 ycmd-44 ycmd-45 ycm-generator"
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}
	      ^^ ( libgcrypt nettle openssl )
	      ^^ ( ycmd-43 ycmd-44 ycmd-45 )
	      bear? ( ycm-generator )
	      ninja? ( ycm-generator )
	      ycm-generator? ( || ( bear ninja ) )"
LIB_DEPEND="
	!ncurses? ( slang? ( sys-libs/slang:=[static-libs(+)] ) )
	>=sys-libs/ncurses-5.9-r1:0=[unicode?]
	sys-libs/ncurses:0=[static-libs(+)]
	magic? ( sys-apps/file:=[static-libs(+)] )
	nls? ( virtual/libintl )"
RDEPEND+=" ${PYTHON_DEPS}
	!static? ( ${LIB_DEPEND//\[static-libs(+)]} )
	>=app-shells/bash-4
	dev-libs/nxjson
	net-libs/neon
	bear? ( dev-util/bear[${PYTHON_SINGLE_USEDEP}] )
	libgcrypt? ( dev-libs/libgcrypt )
	ninja? ( dev-util/ninja )
	nettle? ( dev-libs/nettle )
	openmp? ( sys-libs/libomp )
	openssl? ( dev-libs/openssl
		   dev-libs/glib )
	ycm-generator? ( $(python_gen_cond_dep 'dev-util/ycm-generator[${PYTHON_USEDEP}]' python3_{7,8,9,10}) )
	ycmd-43? ( $(python_gen_cond_dep 'dev-util/ycmd:43[${PYTHON_USEDEP}]' python3_{7,8,9,10}) )
	ycmd-44? ( $(python_gen_cond_dep 'dev-util/ycmd:44[${PYTHON_USEDEP}]' python3_{7,8,9,10}) )
	ycmd-45? ( $(python_gen_cond_dep 'dev-util/ycmd:45[${PYTHON_USEDEP}]' python3_{7,8,9,10}) )"
DEPEND+=" ${RDEPEND}
	system-gnulib? ( >=dev-libs/gnulib-2018.01.23.08.42.00 )"
BDEPEND+=" virtual/pkgconfig
	nls? ( sys-devel/gettext )
	static? ( ${LIB_DEPEND} )"
EGIT_COMMIT="7497cc6cee14d4a2d406975d478facb20d19e62a"
GNULIB_COMMIT="c9b44f214c7c798c7701c7a281584e262b263655" # listed in ./autogen.sh
GNULIB_COMMIT_SHORT="${GNULIB_COMMIT:0:7}"
SRC_URI="\
https://github.com/orsonteodoro/nano-ycmd/archive/${EGIT_COMMIT}.tar.gz \
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=snapshot;h=${GNULIB_COMMIT};sf=tgz \
	-> gnulib-${GNULIB_COMMIT_SHORT}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
BD_REL="ycmd/${SLOT}"
BD_ABS=""

src_unpack() {
	unpack ${A}
	mv gnulib-${GNULIB_COMMIT_SHORT} "${S}/gnulib" || die
}

src_prepare() {
	ewarn "This ebuild is a Work In Progress (WIP)"
	default
	eapply "${FILESDIR}/${PN}-9999_p20210417-rename-as-ynano.patch"
	if use system-gnulib ; then
		eapply "${FILESDIR}/${PN}-9999.20180201-autogen-use-system-gnulib.patch"
		./autogen.sh
	else
		eapply "${FILESDIR}/${PN}-9999_p20210417-autogen-no-git.patch"
		./autogen.sh
	fi
}

econf_ycmd_slot_43() {
	local envars=(
		RUST_TOOLCHAIN_PATH=""
		GOPLS_PATH="${gopls_path}"
		MONO_PATH="${mono_path}"
		NINJA_PATH="/usr/bin/ninja"
		RLS_PATH="${rls_path}"
		RUSTC_PATH="${rustc_path}"
		TSSERVER_PATH="${tsserver_path}"
		OMNISHARP_PATH="${omnisharp_path}"
		YCMD_PATH="${BD_ABS}/ycmd"
		YCMD_PYTHON_PATH="/usr/bin/${EPYTHON}"
		YCMG_PATH="/usr/bin/config_gen.py"
		YCMG_PYTHON_PATH="/usr/bin/${EPYTHON}"
	)
	local args=(
		"${myconf[@]}"
		--bindir="${EPREFIX}"/bin
		--disable-wrapping-as-root
		--enable-ycmd
		--htmldir=/trash
		$(use_enable !minimal color)
		$(use_enable !minimal multibuffer)
		$(use_enable !minimal nanorc)
		$(use_enable debug)
		$(use_enable justify)
		$(use_enable magic libmagic)
		$(use_enable minimal tiny)
		$(use_enable nls)
		$(use_enable spell speller)
		$(use_enable unicode utf8)
		$(use_with bear)
		$(use_with libgcrypt)
		$(use_with nettle)
		$(use_with ninja)
		$(use_with openmp)
		$(use_with openssl)
		$(use_with ycm-generator)
		$(usex ncurses --without-slang $(use_with slang))
	)
	export ${envars[@]}
	einfo "${envars[@]} econf ${args[@]}"
	econf ${args[@]}
}

econf_ycmd_slot_44() {
	local envars=(
		RUST_TOOLCHAIN_PATH=""
		GOPLS_PATH="${gopls_path}"
		MONO_PATH="${mono_path}"
		NINJA_PATH="/usr/bin/ninja"
		RUST_TOOLCHAIN_PATH="${rust_toolchain_path}"
		TSSERVER_PATH="${tsserver_path}"
		OMNISHARP_PATH="${omnisharp_path}"
		YCMD_PATH="${BD_ABS}/ycmd"
		YCMD_PYTHON_PATH="/usr/bin/${EPYTHON}"
		YCMG_PATH="/usr/bin/config_gen.py"
		YCMG_PYTHON_PATH="/usr/bin/${EPYTHON}"
	)
	local args=(
		"${myconf[@]}"
		--bindir="${EPREFIX}"/bin
		--disable-wrapping-as-root
		--enable-ycmd
		--htmldir=/trash
		$(use_enable !minimal color)
		$(use_enable !minimal multibuffer)
		$(use_enable !minimal nanorc)
		$(use_enable debug)
		$(use_enable justify)
		$(use_enable magic libmagic)
		$(use_enable minimal tiny)
		$(use_enable nls)
		$(use_enable spell speller)
		$(use_enable unicode utf8)
		$(use_with bear)
		$(use_with libgcrypt)
		$(use_with nettle)
		$(use_with ninja)
		$(use_with openmp)
		$(use_with openssl)
		$(use_with ycm-generator)
		$(usex ncurses --without-slang $(use_with slang))
	)
	export ${envars[@]}
	einfo "${envars[@]} econf ${args[@]}"
	econf ${args[@]}
}

src_configure() {
	if use ycmd-43 ; then
		ycmd_slot=43
	elif use ycmd-44 ; then
		ycmd_slot=44
	elif use ycmd-45 ; then
		ycmd_slot=45
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

	local clangd_path=""
	local gocode_path=""
	local godef_path=""
	local gopls_path=""
	local mono_path=""
	local racerd_path=""
	local rls_path=""
	local rust_toolchain_path=""
	local rustc_path=""
	local omnisharp_path=""
	local tsserver_path=""
	if use system-clangd ; then
		gocode_path="/usr/bin/clangd"
	else
		gocode_path="${BD_ABS}/third_party/clangd/output/bin/clangd"
	fi
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
	if use system-gopls ; then
		godef_path="/usr/bin/gopls"
	else
		godef_path="${BD_ABS}/third_party/go/bin/gopls"
	fi
	if use system-mono ; then
		mono_path="/usr/bin/mono"
	else
		mono_path="${BD_ABS}/third_party/omnisharp-roslyn/bin/mono"
	fi
	if use system-racerd ; then
		racerd_path="/usr/bin/racerd"
	else
		racerd_path="${BD_ABS}/third_party/racerd/racerd"
	fi
	if use system-rust ; then
		if use ycmd-43 ; then
			if has_version 'dev-lang/rust-bin' ; then
				local rv=$(best_version 'dev-lang/rust-bin' | sed -e "s|dev-lang/rust-bin-||")
				rv=$(ver_cut 1-3 ${rv})
				rls_path="/opt/rust-bin-${rv}/bin/rls"
			elif has_version 'dev-lang/rust' ; then
				local rv=$(best_version 'dev-lang/rust' | sed -e "s|dev-lang/rust-||")
				rv=$(ver_cut 1-3 ${rv})
				rls_path="/usr/lib/rust/${rv}/bin/rls"
			fi
		elif use ycmd-44 || use ycmd-45 ; then
			if has_version 'dev-lang/rust-bin' ; then
				local rv=$(best_version 'dev-lang/rust-bin' | sed -e "s|dev-lang/rust-bin-||")
				rv=$(ver_cut 1-3 ${rv})
				rust_toolchain_path="/opt/rust-bin-${rv}"
			elif has_version 'dev-lang/rust' ; then
				local rv=$(best_version 'dev-lang/rust' | sed -e "s|dev-lang/rust-||")
				rv=$(ver_cut 1-3 ${rv})
				rust_toolchain_path="/usr/lib/rust/${rv}"
			fi
		else
			die "Unsupported ycmd version for system-rust USE flag"
		fi
	else
		if use ycmd-43 ; then
			rls_path="${BD_ABS}/third_party/rls/bin/rls"
		elif use ycmd-44 || use ycmd-45 ; then
			rust_toolchain_path="${BD_ABS}/third_party/rust-analyzer"
		fi
	fi
	if use system-rustc ; then
		rustc_path=""
	else
		rustc_path="${BD_ABS}/third_party/rls/bin/rustc"
	fi
	if use system-omnisharp ; then
		omnisharp_path="${BD_ABS}/ycmd/completers/cs/omnisharp.sh"
	else
		omnisharp_path="${BD_ABS}/third_party/omnisharp-roslyn/run"
	fi
	if use system-tsserver ; then
		tsserver_path="/usr/bin/tsserver"
	else
		if use ycmd-43 ; then
			tsserver_path="${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
		elif use ycmd-44 || use ycmd-45 ; then
			tsserver_path="${BD_ABS}/third_party/tsserver/node_modules/typescript/bin/tsserver"
		fi
	fi

	if use ycmd-43 ; then
		econf_ycmd_slot_43
	elif use ycmd-44 || use ycmd-45 ; then
		econf_ycmd_slot_44
	else
		die "You must choose either ycmd-43, ycmd-44, or ycmd-45 USE flag."
	fi
}

src_install() {
	default
	# removes htmldir
	rm -rf "${D}"/trash || die
	# remove merge conflicts
	rm -rf "${D}/etc/" \
		"${D}/bin/rnano" \
		"${D}/usr/share" || die
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
