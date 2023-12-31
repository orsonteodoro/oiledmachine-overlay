# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This fork of nano is based on 5.6.1_p20210415 from the master branch

EAPI=8

LIVE_TYPE="git"
PYTHON_COMPAT=( python3_{8..11} )
inherit autotools flag-o-matic git-r3 java-pkg-opt-2 python-single-r1

NANO_YCMD_COMMIT="4f52bbc46b1c593f3f7ae58f76820297251fe5ad"
if [[ "${LIVE_TYPE}" == "git" ]] ; then
	IUSE+=" +fallback-commit"
	inherit git-r3
	S="${WORKDIR}/${PN}-${PV}"
elif [[ "${LIVE_TYPE}" == "snapshot" ]] ; then
	EGIT_COMMIT="${NANO_YCMD_COMMIT}"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="GNU GPL'd Pico clone with more functionality with ycmd support"
HOMEPAGE="
	https://www.nano-editor.org/
	https://wiki.gentoo.org/wiki/Nano/Basics_Guide
	https://github.com/orsonteodoro/nano-ycmd
"
LICENSE="GPL-3+ LGPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="0"
YCMD_SLOTS=( 47 46 45 44 43 )
IUSE+="
bear debug justify libgcrypt +magic minimal ncurses nettle ninja nls slang
+spell static openmp openssl system-clangd -system-gnulib system-gocode
system-godef system-gopls system-mono system-omnisharp system-racerd system-rust
system-rustc system-tsserver unicode ycm-generator ycmd-43 ycmd-44 ycmd-45
ycmd-46 +ycmd-47

r19
"
GNULIB_PV="2023.01.16.09.58.30"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	!minimal
	^^ (
		libgcrypt
		nettle
		openssl
	)
	^^ (
		${YCMD_SLOTS[@]/#/ycmd-}
	)
	bear? (
		ycm-generator
	)
	ninja? (
		ycm-generator
	)
	ycm-generator? (
		|| (
			bear
			ninja
		)
	)
"
LIB_DEPEND="
	!ncurses? (
		slang? (
			sys-libs/slang:=[static-libs(+)]
		)
	)
	>=sys-libs/ncurses-5.9-r1:0=[unicode(+)]
	sys-libs/ncurses:0=[static-libs(+)]
	magic? (
		sys-apps/file:=[static-libs(+)]
	)
	nls? (
		virtual/libintl
	)
"
gen_ycmd_rdepend() {
	local s
	for s in ${YCMD_SLOTS[@]} ; do
		echo "
			ycmd-${s}? (
				$(python_gen_cond_dep "dev-util/ycmd:${s}[\${PYTHON_USEDEP}]")
			)
		"
	done
}
RDEPEND+="
	${PYTHON_DEPS}
	$(gen_ycmd_rdepend)
	!static? (
		${LIB_DEPEND//\[static-libs(+)]}
	)
	>=app-shells/bash-4
	dev-libs/nxjson
	net-libs/neon
	bear? (
		dev-util/bear[${PYTHON_SINGLE_USEDEP}]
	)
	libgcrypt? (
		dev-libs/glib
		dev-libs/libgcrypt
	)
	ninja? (
		dev-util/ninja
	)
	nettle? (
		dev-libs/nettle
	)
	openmp? (
		sys-libs/libomp
	)
	openssl? (
		>=dev-libs/openssl-3
	)
	ycm-generator? (
		$(python_gen_cond_dep 'dev-util/ycm-generator[${PYTHON_USEDEP}]')
	)
"
DEPEND+="
	${RDEPEND}
	system-gnulib? (
		>=dev-libs/gnulib-${GNULIB_PV}
	)
"
BDEPEND+="
	virtual/pkgconfig
	nls? (
		sys-devel/gettext
	)
	static? (
		${LIB_DEPEND}
	)
"
GNULIB_COMMIT="2cf7f442f52f70b3df6eb396eb93ea08e54883c5" # listed in ./autogen.sh
GNULIB_COMMIT_SHORT="${GNULIB_COMMIT:0:7}"
if [[ "${LIVE_TYPE}" == "snapshot" ]] ; then
	SRC_URI+="
https://github.com/orsonteodoro/nano-ycmd/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
fi
SRC_URI+="
http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=snapshot;h=${GNULIB_COMMIT};sf=tgz
	-> gnulib-${GNULIB_COMMIT_SHORT}.tar.gz
"
BD_ABS=""
PATCHES=(
	"${FILESDIR}/nano-ycmd-9999-use-external-gnulib.patch"
)

pkg_setup() {
	if use java ; then
		java-pkg-opt-2_pkg_setup
		local java_vendor=$(java-pkg_get-vm-vendor)
		if ! [[ "${java_vendor}" =~ "openjdk" ]] ; then
ewarn
ewarn "Java vendor mismatch.  Runtime failure or quirks may show."
ewarn
ewarn "Actual Java vendor:  ${java_vendor}"
ewarn "Expected java vendor:  openjdk"
ewarn
		fi
	fi
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ ${PV} =~ 9999 && "${LIVE_TYPE}" == "git" ]] ; then
		EGIT_REPO_URI="https://github.com/orsonteodoro/nano-ycmd.git"
		use fallback-commit && EGIT_COMMIT="${NANO_YCMD_COMMIT}"
		EGIT_BRANCH="ymcd-code-completion"
		git-r3_fetch
		git-r3_checkout
		S="${WORKDIR}/${PN}-${PV}"
	fi
	unpack ${A}
	local actual_gnulib_commit=$(grep "gnulib_hash" "${S}/autogen.sh" \
		| head -n 1 \
		| cut -f 2 -d "\"")
	local expected_gnulib_commit="${GNULIB_COMMIT}"
	if ! grep -q "${expected_gnulib_commit}" "${S}/autogen.sh" ; then
eerror
eerror "The gnulib snapshot needs to be updated:"
eerror
eerror "Expected commit:\t${GNULIB_COMMIT}"
eerror "Actual commit:\t${actual_gnulib_commit}"
eerror
		die
	fi
	mv gnulib-${GNULIB_COMMIT_SHORT} "${S}/gnulib" || die
}

src_prepare() {
	ewarn "This ebuild is a Work In Progress (WIP)"
	default
	eapply "${FILESDIR}/${PN}-9999-rename-as-ynano.patch"
	export GNULIB_USE_TARBALL=1
	if use system-gnulib ; then
		export GNULIB_USE_SYSTEM=1
	else
		export GNULIB_USE_SYSTEM=0
	fi
	./autogen.sh
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
		--bindir="${EPREFIX}/bin"
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
		JAVA_PATH="${java_path}"
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
		--bindir="${EPREFIX}/bin"
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
	local s
	for s in ${YCMD_SLOTS[@]} ; do
		use ycmd-${s} && ycmd_slot=${s}
	done
	BD_ABS="$(python_get_sitedir)/ycmd/${ycmd_slot}"
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
	local java_path=""
	local mono_path=""
	local racerd_path=""
	local rls_path=""
	local rust_toolchain_path=""
	local rustc_path=""
	local omnisharp_path=""
	local tsserver_path=""
	if use java ; then
		local java_vendor=$(java-pkg_get-vm-vendor)
		local java_slot
		if use ycmd-46 || use ycmd-47 ; then
			java_slot=17
		elif use ycmd-44 || use ycmd-45 ; then
			java_slot=11
		else
			java_slot=8
		fi
		  if [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}" ]] ; then
			jp="${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}"
		elif [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}" ]] ; then
			jp="${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}"
		fi
		[[ -n "${jp}" ]] && jp="${jp}/bin/java"
		java_path="${jp}"
	fi
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
				local rv=$(best_version 'dev-lang/rust-bin' \
					| sed -e "s|dev-lang/rust-bin-||")
				rv=$(ver_cut 1-3 ${rv})
				rls_path="/opt/rust-bin-${rv}/bin/rls"
			elif has_version 'dev-lang/rust' ; then
				local rv=$(best_version 'dev-lang/rust' \
					| sed -e "s|dev-lang/rust-||")
				rv=$(ver_cut 1-3 ${rv})
				rls_path="/usr/lib/rust/${rv}/bin/rls"
			fi
		elif use ycmd-44 || use ycmd-45 || use ycmd-46 || use ycmd-47 ; then
			if has_version 'dev-lang/rust-bin' ; then
				local rv=$(best_version 'dev-lang/rust-bin' \
					| sed -e "s|dev-lang/rust-bin-||")
				rv=$(ver_cut 1-3 ${rv})
				rust_toolchain_path="/opt/rust-bin-${rv}"
			elif has_version 'dev-lang/rust' ; then
				local rv=$(best_version 'dev-lang/rust' \
					| sed -e "s|dev-lang/rust-||")
				rv=$(ver_cut 1-3 ${rv})
				rust_toolchain_path="/usr/lib/rust/${rv}"
			fi
		else
eerror
eerror "Unsupported ycmd version for system-rust USE flag"
eerror
			die
		fi
	else
		if use ycmd-43 ; then
			rls_path="${BD_ABS}/third_party/rls/bin/rls"
		elif use ycmd-44 || use ycmd-45 || use ycmd-46 || use ycmd-47 ; then
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
		elif use ycmd-44 || use ycmd-45 || use ycmd-46 || use ycmd-47 ; then
			tsserver_path="${BD_ABS}/third_party/tsserver/node_modules/typescript/bin/tsserver"
		fi
	fi

	if use ycmd-43 ; then
		econf_ycmd_slot_43
	elif use ycmd-44 || use ycmd-45 || use ycmd-46 || use ycmd-47 ; then
		econf_ycmd_slot_44
	else
eerror
eerror "You must choose either ${YCMD_SLOTS[@]/#/ycmd-} USE flag."
eerror
		die
	fi
}

src_install() {
	default
	# Removes htmldir
	rm -rf "${ED}"/trash || die
	# Remove merge conflicts
	rm -rf "${ED}/etc/" \
		"${ED}/bin/rnano" \
		"${ED}/usr/share" || die
	dodoc doc/sample.nanorc
	docinto html
	dodoc doc/faq.html
	insinto /etc
	newins doc/sample.nanorc nanorc
	if ! use minimal ; then
		# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}/etc/nanorc" || die
	fi
	dodir /usr/bin
	dosym /bin/ynano /usr/bin/ynano
	newdoc README.md README.nano-ycmd.md
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 7497cc6 9999_p20210419 (20230630) with ycmd-45
# connecting to ycmd:  passed
# python completion:  passed
# GetDoc (python):  passed with workaround ; requires removal of invalid .ycm_extra_conf.py, or setting confirm_extra_conf=0 in ycmd.c, or source code change to handle this.
# GoToDefinition (python):  passed

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 7497cc6 9999_p20210419 (20230630) with ycmd-47
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 1d09284 9999 (20230702) with ycmd-47
# connecting to ycmd:  passed
# python completion:  passed
# GetDoc (python):  passed with workaround ; requires removal of invalid .ycm_extra_conf.py, or setting confirm_extra_conf=0 in ycmd.c, or source code change to handle this.
# GoToDefinition (python):  passed
