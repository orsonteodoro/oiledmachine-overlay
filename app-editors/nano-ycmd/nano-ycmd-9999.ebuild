# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This fork of nano is based on 5.6.1_p20210415 from the master branch

EAPI=8

CFLAGS_HARDENED_USE_CASES="security-critical sensitive-data untrusted-data"

LLVM_COMPAT=( {20..18} )

BD_ABS=""
LIVE_TYPE="git"
FALLBACK_COMMIT="569cf4ca5031c1aade5f2ee32478375c6565d115" # 20250628
GNULIB_COMMIT="d9083a4cc638cf9c7dfc3cc534a7c6b4debf50ab" # listed in ./autogen.sh
GNULIB_PV="2025.04.10.16.42.14" # See committer timestamp from https://cgit.git.savannah.gnu.org/cgit/gnulib.git/commit/?id=d9083a4cc638cf9c7dfc3cc534a7c6b4debf50ab
PYTHON_COMPAT=( "python3_"{11..13} ) # Same as ycmd
YCMD_SLOTS=( 48 )

inherit autotools cflags-hardened check-compiler-switch flag-o-matic git-r3 java-pkg-opt-2 llvm-r1 python-single-r1

if [[ "${LIVE_TYPE}" == "git" ]] ; then
	inherit git-r3
	IUSE+=" +fallback-commit"
	S="${WORKDIR}/${PN}-${PV}"
elif [[ "${LIVE_TYPE}" == "snapshot" ]] ; then
	EGIT_COMMIT="${FALLBACK_COMMIT}"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

if [[ "${LIVE_TYPE}" == "snapshot" ]] ; then
	SRC_URI+="
https://github.com/orsonteodoro/nano-ycmd/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}-${EGIT_COMMIT:0:7}.tar.gz
	"
fi
SRC_URI+="
http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=snapshot;h=${GNULIB_COMMIT};sf=tgz
	-> gnulib-${GNULIB_COMMIT:0:7}.tar.gz
"

DESCRIPTION="GNU GPL'd Pico clone with more functionality with ycmd support"
HOMEPAGE="
	https://www.nano-editor.org/
	https://wiki.gentoo.org/wiki/Nano/Basics_Guide
	https://github.com/orsonteodoro/nano-ycmd
"
LICENSE="
	GPL-3+
	LGPL-2+
"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE+="
${LLVM_COMPAT[@]/#/llvm_slot_}
bear debug hardened_malloc justify libgcrypt +magic minimal mimalloc
ncurses nettle ninja nls +popup random safeclib +spell static
openssl scudo system-clangd -system-gnulib system-gocode system-godef system-gopls
system-mono system-omnisharp system-racerd system-rust system-rustc
system-tsserver unicode ycm-generator +ycmd-48
ebuild_revision_80
"
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
	?? (
		hardened_malloc
		mimalloc
	)
	bear? (
		ycm-generator
	)
	ninja? (
		ycm-generator
	)
	scudo? (
		^^ (
			${LLVM_COMPAT[@]/#/llvm_slot_}
		)
	)
	ycm-generator? (
		|| (
			bear
			ninja
		)
	)
"
LIB_DEPEND="
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
		local impl
		for impl in ${PYTHON_COMPAT[@]} ; do
			echo "
				ycmd-${s}? (
					python_single_target_${impl}? (
						dev-util/ycmd:${s}[python_targets_${impl}(-)]
					)
				)
			"
		done
	done
}

gen_scudo_rdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm_slot_${s}? (
				llvm-core/clang-runtime:${s}[sanitize]
				llvm-core/llvm:${s}
				llvm-runtimes/compiler-rt-sanitizers:${s}[scudo]
			)
		"
	done
}

RDEPEND+="
	$(gen_ycmd_rdepend)
	${PYTHON_DEPS}
	!static? (
		${LIB_DEPEND//\[static-libs(+)]}
	)
	>=app-shells/bash-4
	dev-libs/jansson
	dev-libs/safeclib[strmax-128k]
	net-misc/curl
	bear? (
		dev-util/bear[${PYTHON_SINGLE_USEDEP}]
	)
	hardened_malloc? (
		dev-libs/hardened_malloc
	)
	libgcrypt? (
		dev-libs/glib
		dev-libs/libgcrypt
	)
	mimalloc? (
		dev-libs/mimalloc[hardened(+)]
	)
	ninja? (
		dev-build/ninja
	)
	nettle? (
		dev-libs/nettle
	)
	openssl? (
		>=dev-libs/openssl-3
	)
	scudo? (
		$(gen_scudo_rdepend)
	)
	ycm-generator? (
		$(python_gen_cond_dep '
			dev-util/ycm-generator[${PYTHON_USEDEP}]
		')
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
PATCHES=(
	"${FILESDIR}/nano-ycmd-9999-3b23184-use-external-gnulib-${GNULIB_COMMIT:0:7}.patch"
)

pkg_setup() {
	check-compiler-switch_start
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


	if use scudo ; then
		local llvm_slot
		for llvm_slot in ${LLVM_COMPAT[@]} ; do
			if use "llvm_slot_${llvm_slot}" ; then
				LLVM_SLOT="${llvm_slot}"
				break
			fi
		done
		llvm-r1_pkg_setup
einfo "PATH=${PATH} (before)"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/llvm\/[0-9]+/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}/usr/lib/llvm/${LLVM_SLOT}/bin|g")
einfo "PATH=${PATH} (after)"
        fi
}

src_unpack() {
	if [[ "${PV}" =~ "9999" && "${LIVE_TYPE}" == "git" ]] ; then
		EGIT_REPO_URI="https://github.com/orsonteodoro/nano-ycmd.git"
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
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
	mv \
		"gnulib-${GNULIB_COMMIT:0:7}" \
		"${S}/gnulib" \
		|| die
}

src_prepare() {
ewarn "This ebuild is a Work In Progress (WIP)"
	default
	eapply "${FILESDIR}/${PN}-9999-5921964-rename-as-ynano.patch"
#	eapply "${FILESDIR}/test.patch"
	export GNULIB_USE_TARBALL=1
	if use system-gnulib ; then
		export GNULIB_USE_SYSTEM=1
	else
		export GNULIB_USE_SYSTEM=0
	fi
	./autogen.sh
}

get_llvm_arch() {
	if [[ "${ABI}" == "amd64" ]] ; then
		echo "x86_64"
	elif [[ "${ABI}" == "x86" ]] ; then
		echo "i386"
	elif [[ "${ABI}" == "arm64" ]] ; then
		echo "aarch64"
	elif [[ "${ABI}" == "arm" ]] ; then
		echo "arm"
	elif [[ "${CHOST}" =~ "mipsel" ]] ; then
		echo "mipsel"
	elif [[ "${CHOST}" =~ "mips64el" ]] ; then
		echo "mips64el"
	elif [[ "${CHOST}" =~ "mips64" ]] ; then
		echo "mips64"
	elif [[ "${CHOST}" == "mips-" ]] ; then
		echo "mips"
	elif [[ "${CHOST}" =~ "powerpc64le" ]] ; then
		echo "powerpc64le"
	elif [[ "${CHOST}" =~ "powerpc64" ]] ; then
		echo "powerpc64"
	elif [[ "${ABI}" == "hexagon" ]] ; then
		echo "hexagon"
	elif [[ "${CHOST}" == "loongarch64" ]] ; then
		echo "loongarch64"
	elif [[ "${CHOST}" == "riscv" ]] ; then
		echo "riscv64"
	fi
}

econf_ycmd_slot_45() {
	local lib_safe_paths="/usr/$(get_libdir)"
	local bin_safe_paths=$(echo "${safe_paths}" \
		| tr ";" "\n" \
		| sort \
		| uniq \
		| tr "\n" ";" \
		| sed -e "s|;$||g" -e "s|^;||g")
	local scudo_path=""
	if use scudo ; then
		local arch=$(get_llvm_arch)
		which "${CHOST}-clang-${LLVM_SLOT}" 2>&1 >/dev/null || die
		scudo_path=$(realpath $("${CHOST}-clang-${LLVM_SLOT}" -print-file-name="libclang_rt.scudo_standalone-${arch}.so"))
		einfo "scudo_path:  ${scudo_path}"
		lib_safe_paths+=";"$(dirname "${scudo_path}")
	fi
	einfo "bin_safe_paths:  ${bin_safe_paths}"
	einfo "lib_safe_paths:  ${lib_safe_paths}"
	local envars=(
		RUST_TOOLCHAIN_PATH=""
		GOPLS_PATH="${gopls_path}"
		JAVA_PATH="${java_path}"
		MONO_PATH="${mono_path}"
		NINJA_PATH="/usr/bin/ninja"
		OMNISHARP_PATH="${omnisharp_path}"
		RUST_TOOLCHAIN_PATH="${rust_toolchain_path}"
		TSSERVER_PATH="${tsserver_path}"
		YCMD_PATH="${BD_ABS}/ycmd"
		YCMD_PYTHON_PATH="/usr/bin/${EPYTHON}"
		YCMG_PATH="/usr/bin/config_gen.py"
		YCMG_PYTHON_PATH="/usr/bin/${EPYTHON}"
	)
	local args=(
		"${myconf[@]}"
		--bindir="${EPREFIX}/bin"
		--enable-ycmd
		--htmldir="/trash"
		--with-bin-safe-paths="${bin_safe_paths}"
		--with-lib-safe-paths="${lib_safe_paths}"
		$(use_enable !minimal color)
		$(use_enable !minimal multibuffer)
		$(use_enable !minimal nanorc)
		$(use_enable debug)
		$(use_enable justify)
		$(use_enable magic libmagic)
		$(use_enable minimal tiny)
		$(use_enable nls)
		$(use_enable popup ycmd-popup)
		$(use_enable random)
		$(use_enable spell speller)
		$(use_enable unicode utf8)
		$(use_with bear)
		$(use_with libgcrypt)
		$(use_with nettle)
		$(use_with ninja)
		$(use_with openssl)
		$(use_with ycm-generator)
	)

	local safeclib_fallback="${SAFECLIB_FALLBACK:-return_error}"
	if [[ "${safeclib_fallback}" == "fatal" ]] ; then
		args+=(
			--with-safeclib-error=fatal
		)
	elif [[ "${safeclib_fallback}" == "fallback" ]] ; then
		args+=(
			--with-safeclib-error=fallback
		)
	elif [[ "${safeclib_fallback}" == "return_error" ]] ; then
		args+=(
			--with-safeclib-error=return_error
		)
	else
		args+=(
			--with-safeclib-error=fatal
		)
	fi

	if use scudo ; then
		args+=(
			--with-scudo-lib="${scudo_path}"
		)
	fi

	local sandbox_lib_path="/usr/$(get_libdir)/libsandbox.so"
	einfo "sandbox_lib_path:  ${sandbox_lib_path}"
	args+=(
		--with-sandbox-lib="${sandbox_lib_path}"
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

	check-compiler-switch_end
	if is-flagq "-flto*" && check-compiler-switch_is_lto_changed ; then
	# Prevent static-libs IR mismatch.
einfo "Detected compiler switch.  Disabling LTO."
		filter-lto
	fi
	strip-flags
	replace-flags '-O*' '-O2'

	cflags-hardened_append

	local myconf=()
	local clangd_path=""
	local gocode_path=""
	local godef_path=""
	local gopls_path=""
	local java_path=""
	local mono_path=""
	local omnisharp_path=""
	local racerd_path=""
	local rls_path=""
	local rust_toolchain_path=""
	local rustc_path=""
	local tsserver_path=""
	local safe_paths=""

	if use hardened_malloc ; then
		myconf+=(
			--with-allocator=hardened-malloc
		)
	elif use mimalloc ; then
		myconf+=(
			--with-allocator=mimalloc-secure
		)
	else
		myconf+=(
			--with-allocator=libc
		)
	fi

	if use safeclib ; then
		myconf+=(
			--with-safeclib
		)
	fi

	if use java ; then
		local java_vendor=$(java-pkg_get-vm-vendor)
		local java_slot
		if use ycmd-48 ; then
			java_slot=17
		fi
		  if [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}" ]] ; then
			java_path="${EPREFIX}/usr/lib/jvm/${java_vendor}-${java_slot}"
		elif [[ -L "${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}" ]] ; then
			java_path="${EPREFIX}/usr/lib/jvm/${java_vendor}-bin-${java_slot}"
		fi
		[[ -n "${java_path}" ]] && java_path="${java_path}/bin/java"
	fi
	if use system-clangd ; then
		gocode_path="/usr/bin/clangd"
		safe_paths+=";/usr/bin"
	else
		gocode_path="${BD_ABS}/third_party/clangd/output/bin/clangd"
		safe_paths+=";${BD_ABS}/third_party/clangd/output/bin"
	fi
	if use system-gocode ; then
		gocode_path="/usr/bin/gocode"
		safe_paths+=";/usr/bin"
	else
		gocode_path="${BD_ABS}/third_party/gocode/gocode"
		safe_paths+=";${BD_ABS}/third_party/gocode"
	fi
	if use system-godef ; then
		godef_path="/usr/bin/godef"
		safe_paths+=";/usr/bin"
	else
		godef_path="${BD_ABS}/third_party/godef/godef"
		safe_paths+=";${BD_ABS}/third_party/godef"
	fi
	if use system-gopls ; then
		godef_path="/usr/bin/gopls"
		safe_paths+=";/usr/bin"
	else
		godef_path="${BD_ABS}/third_party/go/bin/gopls"
		safe_paths+=";${BD_ABS}/third_party/go/bin"
	fi
	if use system-mono ; then
		mono_path="/usr/bin/mono"
		safe_paths+=";/usr/bin"
	else
		mono_path="${BD_ABS}/third_party/omnisharp-roslyn/bin/mono"
		safe_paths+=";${BD_ABS}/third_party/omnisharp-roslyn/bin"
	fi
	if use system-racerd ; then
		racerd_path="/usr/bin/racerd"
		safe_paths+=";/usr/bin"
	else
		racerd_path="${BD_ABS}/third_party/racerd/racerd"
		safe_paths+=";${BD_ABS}/third_party/racerd"
	fi
	if use system-rust ; then
		if use ycmd-48 ; then
			if has_version 'dev-lang/rust-bin' ; then
				local rv=$(best_version 'dev-lang/rust-bin' \
					| sed -e "s|dev-lang/rust-bin-||")
				rv=$(ver_cut 1-3 ${rv})
				rust_toolchain_path="/opt/rust-bin-${rv}"
				safe_paths+=";/opt/rust-bin-${rv}"
			elif has_version 'dev-lang/rust' ; then
				local rv=$(best_version 'dev-lang/rust' \
					| sed -e "s|dev-lang/rust-||")
				rv=$(ver_cut 1-3 ${rv})
				rust_toolchain_path="/usr/lib/rust/${rv}"
				safe_paths+=";/usr/lib/rust/${rv}"
			fi
		else
eerror "Unsupported ycmd version for system-rust USE flag"
			die
		fi
	else
		if use ycmd-48 ; then
			rust_toolchain_path="${BD_ABS}/third_party/rust-analyzer"
			safe_paths+=";${BD_ABS}/third_party/rust-analyzer"
		fi
	fi
	if use system-rustc ; then
		rustc_path=""
	else
		rustc_path="${BD_ABS}/third_party/rls/bin/rustc"
		safe_paths+=";${BD_ABS}/third_party/rls/bin"
	fi
	if use system-omnisharp ; then
		omnisharp_path="${BD_ABS}/ycmd/completers/cs/omnisharp.sh"
		safe_paths+=";${BD_ABS}/ycmd/completers/cs"
	else
		omnisharp_path="${BD_ABS}/third_party/omnisharp-roslyn/run"
		safe_paths+=";${BD_ABS}/third_party/omnisharp-roslyn"
	fi
	if use system-tsserver ; then
		tsserver_path="/usr/bin/tsserver"
		safe_paths+=";/usr/bin"
	else
		if use ycmd-48 ; then
			tsserver_path="${BD_ABS}/third_party/tsserver/node_modules/typescript/bin/tsserver"
			safe_paths+=";${BD_ABS}/third_party/tsserver/node_modules/typescript/bin"
		fi
	fi

	if use ycmd-48 ; then
		econf_ycmd_slot_45
	else
eerror "You must choose either ${YCMD_SLOTS[@]/#/ycmd-} USE flag."
		die
	fi
}

src_install() {
	default
	# Removes htmldir
	rm -rf \
		"${ED}/trash" \
		|| die
	# Remove merge conflicts
	rm -rf \
		"${ED}/etc/" \
		"${ED}/bin/rnano" \
		"${ED}/usr/share" \
		|| die
	dodoc "doc/sample.nanorc"
	docinto "html"
	dodoc "doc/faq.html"
	insinto "/etc"
	newins "doc/sample.nanorc" "nanorc"
	if ! use minimal ; then
	# Enable colorization by default.
		sed -i \
			-e '/^# include /s:# *::' \
			"${ED}/etc/nanorc" \
			|| die
	fi
	dodir "/usr/bin"
	dosym "/bin/ynano" "/usr/bin/ynano"
	newdoc "README.md" "README.nano-ycmd.md"
	if use scudo ; then
ewarn "You must re-emerge this package if Scudo is updated or recompiled."
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 7497cc6 9999_p20210419 (20230630) with ycmd-45
# connecting to ycmd:  passed
# python completion:  passed
# GetDoc (python):  passed with workaround ; requires removal of invalid .ycm_extra_conf.py, or setting confirm_extra_conf=0 in ycmd.c, or source code change to handle this.
# GoToDefinition (python):  passed

# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 7497cc6 9999_p20210419 (20230630) with ycmd-47
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) 1d09284 9999 (20230702) with ycmd-47
# OILEDMACHINE-OVERLAY-TEST:  PASSED (interactive) a8aa4bb 9999 (20250607) with ycmd-48
# connecting to ycmd:  passed
# python completion:  passed
# GetDoc (python):  passed with workaround ; requires removal of invalid .ycm_extra_conf.py, or setting confirm_extra_conf=0 in ycmd.c, or source code change to handle this.
# GoToDefinition (python):  passed
