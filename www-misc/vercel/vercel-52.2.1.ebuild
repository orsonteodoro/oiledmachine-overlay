# Copyright 2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# U24

# No lockfile will be provided.  It is understood it will be updated frequently.

# Rust 1.95.0

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# PNPM_UPDATER_VERSIONS="52.0.0" pnpm_updater_update_locks.sh

MY_PN="vercel"
MY_P="${MY_PN}-${PV}"

NODE_SLOT="24"
PNPM_SLOT="9"
PNPM_TARBALL="${MY_P}.tar.gz"
RUST_MAX_VER="1.95.0" # Inclusive
RUST_MIN_VER="1.95.0" # llvm-22.1
RUST_PV="${RUST_MIN_VER}"
RUST_EXPECTED_TIMESTAMP=20260414 # Same as 1.95.0 release date

LLVM_SLOT=22
LLVM_COMPAT=( ${LLVM_SLOT} )

PNPM_AUDIT_FIX_ARGS=(
)

PNPM_INSTALL_ARGS=(
)

inherit flag-o-matic pnpm rust

S="${WORKDIR}/${MY_PN}-${MY_PN}-${PV}"
SRC_URI="
https://github.com/vercel/vercel/archive/refs/tags/vercel@${PV}.tar.gz
	-> ${MY_P}.tar.gz
"

DESCRIPTION="Vercel CLI"
HOMEPAGE="
	https://github.com/vercel/vercel
	https://vercel.com/docs/cli
"
LICENSE="
	Apache-2.0
	Vercel-Legal
	Vercel-Privacy-Policy
"
KEYWORDS="~amd64"
IUSE+=" ebuild_revision_3"
SLOT="0"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-util/rustup
	net-libs/nodejs:${NODE_SLOT}
	llvm-core/clang:${LLVM_SLOT}
	llvm-core/llvm:${LLVM_SLOT}
	llvm-core/lld:${LLVM_SLOT}
	sys-apps/pnpm:${PNPM_SLOT}
	|| (
		dev-lang/rust-bin:${RUST_PV}
		dev-lang/rust:${RUST_PV}
	)
	|| (
		dev-lang/rust-bin:=
		dev-lang/rust:=
	)
"
RESTRICT="mirror"

verify_rust() {
	if "${RUSTC}" --version | grep -q "nightly" ; then
		local actual_timestamp=$(rustc --version | cut -f 4 -d " " | sed -e "s|)||g" | sed -e "s|-||g")
		local expected_timestamp=${RUST_EXPECTED_TIMESTAMP}
		if (( ${current_timestamp} < ${expected_timestamp} )) ; then
eerror "You need to re-emerge =dev-lang/rust-bin-9999 or =dev-lang/rust"
eerror "Actual timestamp:  ${actual_timestamp}"
eerror "Expected timestamp:  >= ${expected_timestamp}"
			die
		fi
	fi
}

pkg_setup() {
	export TURBO_TELEMETRY_DISABLED=1
	export DO_NOT_TRACK=1
	pnpm_pkg_setup
	rust_pkg_setup
	verify_rust
}

src_unpack() {
	pnpm_src_unpack
}

src_configure() {
	export TURBO_TELEMETRY_DISABLED=1
	export DO_NOT_TRACK=1

	export PATH="/usr/lib/llvm/${LLVM_SLOT}/bin:${PATH}"
# Prevent
# note: gcc: error: unrecognized command-line option '--target=wasm32-wasip2'
	export CC="${CHOST}-clang-22" # Same as Rust's 1.95.0 LLVM slot
	export CXX="${CHOST}-clang++-22"
	export CPP="${CC} -E"
	unset LD
	filter-flags "-fuse-ld=*"

	rustup-init-gentoo -s || die
	export PATH="${HOME}/.cargo/bin:${PATH}"
	"${RUSTC}" --version || die

	filter-flags "-fuse-ld=*"
	append-flags "-fuse-ld=lld"

einfo "CC:  ${CC}"
einfo "CXX:  ${CXX}"
einfo "CPP:  ${CPP}"
einfo "LD:  ${LD}"
einfo "CFLAGS:  ${CFLAGS}"
einfo "CXXFLAGS:  ${CXXFLAGS}"
einfo "LDFLAGS:  ${LDFLAGS}"
}

src_compile() {
	pnpm_hydrate
	epnpm --version
	epnpm "build"
}

sanitize_file_permissions() {
	# Include hidden files
	shopt -s dotglob

	local path
einfo "Sanitizing file/folder permissions"
	IFS=$'\n'
	for path in $(find "${ED}") ; do
		[[ -L "${path}" ]] && continue
		chown root:root "${path}" || die
		if file "${path}" | grep -q -e "directory" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* shared object" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "ELF .* executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Perl script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Python script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "POSIX shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Bourne-Again shell script" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "Node.js script executable" ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "WebAssembly (wasm) binary" ; then
			chmod 0755 "${path}" || die
		elif [[ "${path}" =~ ".sh"$ ]] ; then
			chmod 0755 "${path}" || die
		elif file "${path}" | grep -q -e "symbolic link" ; then
			:
		else
			chmod 0644 "${path}" || die
		fi
	done
	IFS=$' \t\n'

	# Exclude hidden files
	shopt -u dotglob
}

src_install() {
	shopt -s dotglob # Copy hidden files

	insinto "/opt/vercel"
	doins -r "packages/cli/package.json"
	doins -r "packages/cli/dist"
	doins -r "packages/cli/node_modules"

	cat "${FILESDIR}/vc" > "${T}/vc" || die
	sed -i -e "s|@NODE_SLOT@|${NODE_SLOT}|g" "${T}/vc"
	exeinto "/usr/bin"
	doexe "${T}/vc"
	dosym "/usr/bin/vc" "/usr/bin/vercel"

	sanitize_file_permissions
	fperms 0755 "/opt/vercel/dist/vc.js"

	shopt -u dotglob # Skip hidden files
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
