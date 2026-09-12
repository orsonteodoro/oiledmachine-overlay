# Copyright 2024-2026 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# This ebuild uses AI generated code.

MY_PV="chromium-${PV}"

DISTDIR_DIR="/var/cache/distfiles"
BASE_DIR="${DISTDIR_DIR}/chromium-src"
CACHE_DIR="${DISTDIR_DIR}/chromium-src/${PV}"
INSTALL_PREFIX="/usr/share/chromium/${PV}"
#DOWNLOAD_FLAVOR="depot_tools" # tarball-full, tarball-lite, depot_tools
DOWNLOAD_FLAVOR="tarball-lite" # tarball-full, tarball-lite, depot_tools
PYTHON_COMPAT=( "python3_11" ) # See https://chromium.googlesource.com/chromium/tools/depot_tools/+/refs/heads/main/vpython.toml#1

# For lite versus full tarball see:
# https://github.com/OSSystems/meta-browser/issues/763
# https://groups.google.com/a/chromium.org/g/chromium-packagers/c/oE60kVFFMyQ/m/T26AJMc7AgAJ
# Added dirs:   https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipes/publish_tarball.py;l=291
# Pruned dirs:  https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipe_modules/chromium/resources/export_tarball.py;l=28
# Pruned list:  https://source.chromium.org/chromium/chromium/tools/build/+/main:recipes/recipes/publish_tarball.expected/basic.json

# The lite prunes the following:
# .git folders
# Build tools and source code (closure-compiler, llvm, node, rust)
# Debian sysroots
# Debug libraries
# NaCl
# Proprietary platform support
# Testing support (apache-linux, blink web tests, test samples, fuzzing data)

inherit dhms


KEYWORDS="~amd64 ~arm64 ~ppc64"
S="${WORKDIR}"
if [[ "${DOWNLOAD_FLAVOR}" == "tarball-lite" ]] ; then
	SRC_URI="
https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV}-lite.tar.xz
	"
elif [[ "${DOWNLOAD_FLAVOR}" == "tarball-full" ]] ; then
	SRC_URI="
https://commondatastorage.googleapis.com/chromium-browser-official/chromium-${PV}.tar.xz
	"
elif [[ "${DOWNLOAD_FLAVOR}" == "depot_tools" ]] ; then
	inherit python-single-r1 sandbox-changes
fi

DESCRIPTION="Chromium sources"
HOMEPAGE="https://www.chromium.org/"
LICENSE="
	chromium-$(ver_cut 1-3 ${PV}).x.html
"
RESTRICT="binchecks mirror strip test"
SLOT="${PV}"
IUSE+=" ebuild_revision_8"
RDEPEND+="
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-vcs/git
	dev-lang/python:3.11
	net-misc/curl
"
DOCS=( )

pkg_setup() {
	dhms_start
	if [[ "${DOWNLOAD_FLAVOR}" =~ ("depot_tools") ]] ; then
		sandbox-changes_no_network_sandbox "For downloading depot_tools and the Chromium source code"
		python-single-r1_pkg_setup
	fi
}

# AI prompt:  how can i get chromium 153.0.8010.36 for linux using gentoo ebuild
# using depot_tools? i can modify the sandbox. i need the download placed in
# /var/cache/distfiles/chromium-src/${PV}. it will use it if cache available and it has a
# /var/cache/distfiles/chromium-src/${PV}/.complete file. if the .complete file is
# missing, it will wipe and start all over for that point release.
_unpack_depot_tools() {
	# Allow writes to modify the cache structure under Portage's sandbox environment
	addwrite "${DISTDIR_DIR}"
	addwrite "${BASE_DIR}"
	addwrite "${CACHE_DIR}"

	# Ensure the parent caching directory exists
	mkdir -p "${BASE_DIR}" || die

	# Check for the existence and validity of the cache
	if [[ -d "${CACHE_DIR}" && -f "${CACHE_DIR}/.complete" ]]; then
		einfo "Found complete cache for Chromium ${PV}. Reusing cache..."
	else
		einfo "Cache missing or incomplete (.complete file not found)."
		einfo "Wiping target directory and starting clean for point release..."

		# Safely wipe and recreate the target directory
		rm -rf "${CACHE_DIR}"
		mkdir -p "${CACHE_DIR}"

		# Bypassing the sandbox dynamically for depot_tools operations
		# We add write permission explicitly to the specific point release cache folder
		export SANDBOX_WRITE="${SANDBOX_WRITE}:${CACHE_DIR}:${BASE_DIR}"

		# Setup temporary depot_tools inside the working directory to avoid host pollution
		local DEPOT_TOOLS_DIR="${WORKDIR}/depot_tools"
		einfo "Cloning depot_tools..."
		git clone --depth=1 https://chromium.googlesource.com/chromium/tools/depot_tools.git "${DEPOT_TOOLS_DIR}" || die

		# Export depot_tools to PATH and configure Python 3.11 requirement
		export PATH="${DEPOT_TOOLS_DIR}:${PATH}"
		export DEPOT_TOOLS_UPDATE=1
		export PYTHONHTTPSVERIFY=1

		# Navigate into our controlled persistent cache space to perform the checkout
		cd "${CACHE_DIR}" || die

		einfo "Initializing gclient for Chromium version ${PV}..."
		# Create the .gclient configuration tracking the PV tag release
		gclient config --name=src https://chromium.googlesource.com/chromium/src.git || die

		einfo "Syncing Chromium source tree (this will take a while and requires high network overhead)..."
		# Execute gclient sync, pinning explicitly to the PV release tag
		# --no-history optimizes space; --force handles unaligned submodule states
		gclient sync \
			--revision=src@${PV} \
			--no-history \
			--shallow \
			--force \
			--nohooks || die

		# Run the post-sync hooks required to pull toolchains and sysroots
		einfo "Running post-sync hooks..."
		gclient runhooks || die

		# Drop the tracking validation file marking the completion of a clean download
		touch "${CACHE_DIR}/.complete" || die
		einfo "Source fetch complete. Target validated with .complete file."
	fi

	# Standard Gentoo Workflow integration:
	# Copy or symlink the cache workspace content into Portage's standard WORKDIR
	# so that src_prepare() and src_compile() can proceed smoothly in isolated sandboxes.
	einfo "Populating Portage WORKDIR from persistent source cache..."
	mkdir -p "${S}/chromium-${PV}" || die

	# We use a hardlink or copy to maintain isolation during the build steps
	cp -al "${CACHE_DIR}/src/." "${S}/chromium-${PV}" || cp -a "${CACHE_DIR}/src/." "${S}/chromium-${PV}" || die
}

_unpack_tarball() {
	unpack ${A}
}

src_unpack() {
	if [[ "${DOWNLOAD_FLAVOR}" =~ ("tarball") ]] ; then
		_unpack_tarball
	else
		_unpack_depot_tools
	fi
}

# _method0() {
# Completion time:  0 days, 6 hrs, 46 mins, 52 secs
# Reasons for slowdown:
# 1. Output in console
# 2. cp -aT
# 3. scanelf
# 4. write to /var/db/pkg/.../CONTENTS
# 5. md5sum for each file for CONTENTS
# }

_method1() {
	rm -rf "${INSTALL_PREFIX}/sources"
	mkdir -p "${INSTALL_PREFIX}/sources"
	# Bypass scanelf and writing to /var/pkg/db
	# Use filesystem tricks (pointer change) to speed up merge time.
	mv "${WORKDIR}/chromium-${PV}/"* "${INSTALL_PREFIX}/sources" || die
	mv $(find "${WORKDIR}/chromium-${PV}/" -maxdepth 1 -name ".*" -type f) "${INSTALL_PREFIX}/sources" || die
# Completion time:  0 days, 0 hrs, 26 mins, 22 secs
}

src_install() {
	keepdir "${INSTALL_PREFIX}/sources"
	addwrite "/usr/share/"
	addwrite "/usr/share/chromium/"
	addwrite "/usr/share/chromium/${PV}"
	addwrite "${INSTALL_PREFIX}/sources"
	_method1
}

pkg_postinst() {
	dhms_end
ewarn "When emerge runs after the speedup changes it will wipe some files.  Please re-emerge again."
	local count=$(find "${INSTALL_PREFIX}/sources/" -type f | wc -l)
	echo "${count}" > "${INSTALL_PREFIX}/sources/file-count"
einfo "Files merged:"
	find "${INSTALL_PREFIX}/sources"
einfo "QA:  Update chromium ebuild with sources_count_expected=${count}"

	if [[ -e "/usr/share/chromium/sources" ]] ; then
	# Remove unislot
		rm -rf "/usr/share/chromium/sources"
	fi
	if [[ -e "/usr/share/chromium/${PV%.*}" ]] ; then
	# Remove mistake
		rm -rf "/usr/share/chromium/${PV%.*}"
	fi
}

pkg_preinst() {
	local x
	for x in ${REPLACING_VERSIONS} ; do
		local y=$(ver_cut "1-4" "${x}")
		if [[ "${y}" != "${PV}" ]] ; then
einfo "Removing ${PN}:${y}"
			rm -rf "/usr/share/chromium/${y}/sources" >/dev/null 2>&1 || true
		fi
	done
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]] ; then
		if ls "/usr/share/chromium/"*"/sources" > /dev/null 2>&1 ; then
einfo "Removing all ${PN} slots"
			rm -rf "/usr/share/chromium/"*"/sources" >/dev/null 2>&1 || true
		fi

		if [[ -e "/usr/share/chromium/sources" ]] ; then
einfo "Removing ${PN} unislot"
			rm -rf "/usr/share/chromium/sources" >/dev/null 2>&1 || true
		fi

		if [[ -e "/usr/share/chromium/${PV%.*}" ]] ; then
einfo "Removing messed up install of ${PN}-${PV%.*}"
			rm -rf "/usr/share/chromium/${PV%.*}" >/dev/null 2>&1 || true
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
