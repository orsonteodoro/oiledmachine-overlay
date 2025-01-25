# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# See also
# https://github.com/oven-sh/bun/blob/bun-v1.2.0/cmake/tools/SetupWebKit.cmake#L5

CPU_FLAGS_X86=(
	cpu_flags_x86_avx2
)
LLVM_COMPAT=( 18 )
LOCKFILE_VER="1.2"
NODE_VERSION="20"
RUST_COMPAT=(
	"1.81.0" # llvm 18
	"1.80.0" # llvm 18
	"1.79.0" # llvm 18
	"1.78.0" # llvm 18
)
WEBKIT_PV="621.1.11"
YARN_SLOT="1"

inherit cmake yarn

#KEYWORDS="~amd64 ~arm64"
S="${WORKDIR}/${PN}-${PN}-v${PV}"
SRC_URI="
https://github.com/oven-sh/bun/archive/refs/tags/bun-v${PV}.tar.gz
"

DESCRIPTION="Incredibly fast JavaScript runtime, bundler, test runner, and package manager – all in one"
HOMEPAGE="
https://bun.sh/
https://github.com/oven-sh/bun
"
LICENSE="
	(
		BSD
		BSD-2
		CC0-1.0
		public-domain
	)
	(
		BSD
		ISC
		MIT
		openssl
		SSLeay
	)
	Apache-2.0
	BSD
	BSD-2
	icu-72.1
	LGPL-2
	LGPL-2.1
	MIT
	ZLIB
	|| (
		MIT
		|| (
			Artistic
			GPL-1+
		)
	)
	|| (
		BSD
		GPL-2
	)
"
RESTRICT="mirror"
SLOT="${LOCKFILE_VER}"
IUSE+="
${CPU_FLAGS_X86[@]}
doc ebuild_revision_1
"
gen_rust_depend() {
	local s
	for s in ${RUST_COMPAT[@]} ; do
		echo "
			dev-lang/rust-bin:${s}
			dev-lang/rust:${s}
		"
	done
}
gen_llvm_depend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			llvm-core/llvm:${s}
			llvm-core/clang:${s}
			llvm-core/lld:${s}
		"
	done
}
RDEPEND+="
	$(gen_llvm_depend)
	sys-apps/bun-webkit:${LOCKFILE_VER}-${WEBKIT_PV%%.*}
	sys-apps/bun-webkit:=
	llvm-core/llvm:=
	llvm-core/clang:=
	llvm-core/lld:=
"
DEPEND+="
	${RDEPEND}
"
BOOTSTRAP_BDEPEND="
	net-libs/nodejs:${NODE_VERSION}[corepack]
	sys-apps/yarn:${YARN_SLOT}
"
BDEPEND+="
	${BOOTSTRAP_BDEPEND}
	$(gen_llvm_depend)
	$(gen_rust_depend)
	dev-build/cmake
	llvm-core/llvm:=
	llvm-core/clang:=
	llvm-core/lld:=
"
PATCHES=(
	"${FILESDIR}/${PN}-1.2.0-llvm-path.patch"
	"${FILESDIR}/${PN}-1.2.0-webkit-path.patch"
)

pkg_setup() {
	yarn_pkg_setup
}

src_unpack() {
ewarn "Ebuild is in development"
	unpack ${A}
}

emulate_bun() {
	# Emulate bun because the baseline builds are all broken and produce
	# illegal instruction.
	mkdir -p "${HOME}/.bun/bin"
cat <<EOF > "${HOME}/.bun/bin/bun"
#!/bin/bash
ARGS=( "$@" )
COMMAND="${ARGS[0]}"
ARGS=( "${ARGS[@]:1}" )
if [[ "${COMMAND}" == "x" ]] ; then
	npx "${ARGS[@]}"
else
	yarn "${ARGS[@]}"
fi
EOF
	chmod +x "${HOME}/.bun/bin/bun" || die
	export PATH="${HOME}/.bun/bin:${PATH}"
	bun --version || die
}

src_prepare() {
	cmake_src_prepare
	yarn_hydrate
	yarn add npx
	emulate_bun
	bun --version || die
	bun x --version || die
}

get_bun_arch() {
	if [[ "${ELIBC}" == "gnu" ]] ; then
		echo "gnu"
	elif [[ "${ELIBC}" == "musl" ]] ; then
		echo "musl"
	else
eerror "ELIBC=${ELIBC} is not supported"
		die
	fi
}

check_rust() {
	local rust_pv=$(rustc --version \
		| cut -f 2 -d " ")
	local installed_pkgs=()
	local found=0
	local s
	for s in ${RUST_COMPAT[@]} ; do
		local v1="${rust_pv%.*}"
		local v2="${s%.*}"
		if ver_test "${v1}" -eq "${v2}" ; then
			found=1
		fi
		if has_version "dev-lang/rust:${s}" ; then
			installed_pkgs+=( "dev-lang/rust:${s}" )
		fi
		if has_version "dev-lang/rust-bin:${s}" ; then
			installed_pkgs+=( "dev-lang/rust-bin:${s}" )
		fi
	done
	if (( ${found} == 0 )) ; then
eerror
eerror "You need to see \`eselect rust\` to switch to a llvm ${LLVM_COMPAT[@]} compatible"
eerror "Rust build."
eerror
eerror "Actual rustc:  ${rust_pv}"
eerror "Expected rustc:  ${RUST_COMPAT[@]}"
eerror "Installed rust packages:  ${installed_pkgs[@]}"
eerror
	fi
}

src_configure() {
	yarn_hydrate
	emulate_bun
	check_rust
	export CARGO_HOME="${ESYSROOT}/usr/bin"
	local mycmakeargs=(
		-DWEBKIT_LOCAL=ON
		-DWEBKIT_PATH="/usr/share/bun-webkit/${LOCKFILE_VER}-${WEBKIT_PV%%.*}"
	)
	ABI="${arch}" \
	cmake_src_configure
}

src_compile() {
	yarn_hydrate
	cmake_src_compile
}

src_install() {
	local d=$(get_dir)
	pushd "${d}" >/dev/null 2>&1 || die
		exeinto "/usr/bin"
		doexe "bun"
	popd >/dev/null 2>&1 || die
	pushd "${WORKDIR}/bun-bun-v${PV}" >/dev/null 2>&1 || die
		docinto "licenses"
		dodoc "LICENSE.md"
		if use doc ; then
			docinto "readmes"
			dodoc "README.md"
			insinto "/usr/share/${PN}"
			doins -r "docs"
		fi
	popd >/dev/null 2>&1 || die
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
