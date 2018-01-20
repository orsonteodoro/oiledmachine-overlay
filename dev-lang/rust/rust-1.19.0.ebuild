# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-any-r1 versionator toolchain-funcs \
	multilib multilib-minimal multilib-build \
	flag-o-matic

if [[ ${PV} = *beta* ]]; then
	betaver=${PV//*beta}
	BETA_SNAPSHOT="${betaver:0:4}-${betaver:4:2}-${betaver:6:2}"
	MY_P="rustc-beta"
	SLOT="beta/${PV}"
	SRC="${BETA_SNAPSHOT}/rustc-beta-src.tar.gz"
	KEYWORDS=""
else
	ABI_VER="$(get_version_component_range 1-2)"
	SLOT="stable/${ABI_VER}"
	MY_P="rustc-${PV}"
	SRC="${MY_P}-src.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

get_triple() {
	if [[ ${ARCH} = "amd64" ]]; then
		TRIPLE_HOST="x86_64-unknown-linux-gnu"
		if use abi_x86_64 ; then
			TRIPLE="x86_64-unknown-linux-gnu"
			TRIPLE_CC="x86_64-pc-linux-gnu"
		elif use abi_x86_32 ; then
			TRIPLE="i686-unknown-linux-gnu"
			TRIPLE_CC="i686-pc-linux-gnu"
		else
			die "Unsupported ABI"
		fi
	else
		TRIPLE_HOST="i686-unknown-linux-gnu"
		TRIPLE="i686-unknown-linux-gnu"
		TRIPLE_CC="i686-pc-linux-gnu"
	fi
}

CARGO_VERSION="0.$(($(get_version_component_range 2) + 1)).0"
STAGE0_VERSION="1.$(($(get_version_component_range 2) - 1)).0"
STAGE0_VERSION_CARGO="0.$(($(get_version_component_range 2))).0"
BOOTSTRAP_DATE="2017-06-08" # found in src/stage0.txt

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="abi_x86_64? (
			https://static.rust-lang.org/dist/rustc-${STAGE0_VERSION}-x86_64-unknown-linux-gnu.tar.gz
			https://static.rust-lang.org/dist/rust-std-${STAGE0_VERSION}-x86_64-unknown-linux-gnu.tar.gz
			https://static.rust-lang.org/dist/cargo-${STAGE0_VERSION_CARGO}-x86_64-unknown-linux-gnu.tar.gz
		)
		abi_x86_32? (
			https://static.rust-lang.org/dist/rustc-${STAGE0_VERSION}-i686-unknown-linux-gnu.tar.gz
			https://static.rust-lang.org/dist/rust-std-${STAGE0_VERSION}-i686-unknown-linux-gnu.tar.gz
			https://static.rust-lang.org/dist/cargo-${STAGE0_VERSION_CARGO}-i686-unknown-linux-gnu.tar.gz
		)
		https://static.rust-lang.org/dist/rustc-${PV}-src.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"

IUSE="clang debug doc libcxx"
_ABIS="abi_x86_32 abi_x86_64 abi_x86_x32 abi_mips_n32 abi_mips_n64 abi_mips_o32 abi_ppc_32 abi_ppc_64 abi_s390_32 abi_s390_64"
IUSE+=" ${_ABIS}"
REQUIRED_USE="libcxx? ( clang )"
REQUIRED_USE+=" ^^ ( ${_ABIS} )"

RDEPEND="libcxx? ( sys-libs/libcxx )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
	>=dev-util/cmake-3.4.3
"

PDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
	>=dev-util/cargo-${CARGO_VERSION}[${MULTILIB_USEDEP}]"

S="${WORKDIR}/rustc-${PV}-src"

src_unpack() {
	unpack ${A##* }
}

src_prepare() {
	default

	#epatch "${FILESDIR}/${PN}-1.19.0-disable-sanity-for-cross-compiler.patch"

	multilib_copy_sources
}

multilib_src_configure() {
	echo "No configure step for rust"
}

multilib_src_compile() {
	get_triple
	einfo "TRIPLE_HOST=${TRIPLE_HOST}"
	einfo "TRIPLE=${TRIPLE}"
	local stage0="rust-${STAGE0_VERSION}-${TRIPLE}"
	local stage0_host="rust-${STAGE0_VERSION}-${TRIPLE_HOST}"

	if use debug ; then
		local optimized="false";
		local debug="true";
	else
		local optimized="true";
		local debug="false";
	fi

	cat <<- EOF > config.toml
	[llvm]
	optimize = ${optimized}
	assertions = ${debug}
	[build]
	docs = false
	submodules = false
	python = "${EPYTHON}"
	vendor = true
	build = "${TRIPLE}"
	host = ["${TRIPLE}"]
	target = ["${TRIPLE}"]
	[install]
	prefix = "${EPREFIX}/usr"
	libdir = "$(get_libdir)/${P}"
	mandir = "share/${P}/man"
	docdir = "share/${P}/doc"
	[rust]
	optimize = ${optimized}
	default-linker = "$(tc-getBUILD_CC)"
	default-ar = "$(tc-getBUILD_AR)"
	channel = "${SLOT%%/*}"
	rpath = false
	optimize-tests = ${optimized}
	EOF

	local cache_dir="build/cache/${BOOTSTRAP_DATE}"
	mkdir -p ${cache_dir}
	for i in ${A}; do
		cp "${DISTDIR}/${i}" $cache_dir/
	done

	#rust's x.py bombs if you put the -m32 in the CC or CXX
	if use abi_x86_32 ; then
		export CC="${CC// -m32/}"
		export CXX="${CXX// -m32/}"
		append-cflags -m32
		append-cxxflags -m32
	elif use abi_x86_64 ; then
		export CC="${CC// -m64/}"
		export CXX="${CXX// -m64/}"
		append-cflags -m64
		append-cxxflags -m64
	else
		die "Arch is not supported"
	fi

	${EPYTHON} x.py build || die
}

multilib_src_install() {
	get_triple
	default

	local obj="build/${TRIPLE}/stage2"
	dobin "${obj}/bin/rustc" "${obj}/bin/rustdoc"
	dobin src/etc/rust-gdb src/etc/rust-lldb
	insinto "/usr/$(get_libdir)"
	doins -r "${obj}/lib/"*
	dodoc COPYRIGHT
	doman man/*

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/usr/$(get_libdir)/${P}"
	MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	EOF
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"

	if use ycmd ; then
		if [ "${ABI}" == "${DEFAULT_ABI}" ] ; then
			dodir /usr/share/rust
			insinto /usr/share/rust
			doins -r src/*
		fi
	fi
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-${PV}."

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-vim to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
