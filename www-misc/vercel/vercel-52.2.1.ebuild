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

PNPM_AUDIT_FIX_ARGS=(
)

PNPM_INSTALL_ARGS=(
)

inherit pnpm rust rustflags-hardened

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
IUSE+=" ebuild_revision_1"
SLOT="0"
DEPEND+="
"
RDEPEND+="
	${DEPEND}
"
BDEPEND+="
	dev-util/rustup
	net-libs/nodejs:${NODE_SLOT}
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
	rustup-init-gentoo -s || die
	export PATH="${HOME}/.cargo/bin:${PATH}"
	"${RUSTC}" --version || die
	rustflags-hardened_append
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
	dodir "/opt/vercel"
	shopt -s dotglob # Copy hidden files
	doins -r "packages/cli/package.json"
	doins -r "packages/cli/dist"
	doins -r "packages/cli/node_modules"
	shopt -u dotglob # Skip hidden files

	cat "${FILESDIR}/vc" > "${T}/vc" || die
	sed -i -e "s|@NODE_SLOT@|${NODE_SLOT}|g" "${T}/vc"
	doexe "${T}/vc"
	dosym "/usr/bin/vc" "/usr/bin/vercel"

	sanitize_file_permissions
	fperms 0755 "/opt/vercel/dist/vc.js"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
