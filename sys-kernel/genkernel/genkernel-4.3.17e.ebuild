# Copyright 2022-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# EXPERIMENTAL VERSION (UNSTABLE / NOT RECOMMENDED)

# The reuse of revision r7 was used so that newer bumps
# do not interfere with an ongoing patch update for a stable working build.
# This experimental series could have have been revision -r(x+1),
# and the stable series -rX, but this one will be frozen until it
# is at least in working state.

# 4.3.15s is the stable oiledmachine-overlay patches
# 4.3.15e is the experimental oiledmachine-overlay patches.

# Changes to the 4.2.x PGO will be backported to genkernel 4.0.x later.

# genkernel-9999        -> latest Git branch "master"
# genkernel-VERSION     -> normal genkernel release

# The original version of this ebuild is 4.2.6-r1::gentoo
# modified with subdir_mount, entry, llvm, pgo changes.  Revision
# bumps may change on the oiledmachine-overlay.

# Updated from changes from genkernel-4.3.17-r2.ebuild

MY_PV=$(ver_cut 1-3 "${PV}")
MY_P="${PN}-${MY_PV}"

EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
	mips
	ppc
	ppc64
	riscv
	s390
	sparc
	x86
)
LLVM_COMPAT=( {18..11} )
LLVM_LTO_SLOTS=( {18..11} )
LLVM_CFI_ARM64_SLOTS=( {18..12} )
LLVM_CFI_X86_SLOTS=( {18..13} )
LLVM_PGO_SLOTS=( {18..13} )
PYTHON_COMPAT=( "python3_"{10..12} )

inherit bash-completion-r1 flag-o-matic python-single-r1

# Whenever you bump a GKPKG, check if you have to move
# or add new patches!
VERSION_BCACHE_TOOLS="1.1_p20230217"
# boost-1.84.0 needs dev-build/b2 packaged
VERSION_BOOST="1.79.0"
VERSION_BTRFS_PROGS="6.7.1"
VERSION_BUSYBOX="1.36.1"
VERSION_COREUTILS="9.4"
VERSION_CRYPTSETUP="2.6.1"
VERSION_DMRAID="1.0.0.rc16-3"
VERSION_DROPBEAR="2022.83"
VERSION_EUDEV="3.2.14"
VERSION_EXPAT="2.5.0"
VERSION_E2FSPROGS="1.47.0"
VERSION_FUSE="2.9.9"
# gnupg-2.x needs several new deps packaged
VERSION_GPG="1.4.23"
VERSION_HWIDS="20210613"
# open-iscsi-2.1.9 static build not working yet
VERSION_ISCSI="2.1.8"
VERSION_JSON_C="0.18"
VERSION_KMOD="31"
VERSION_LIBAIO="0.3.113"
VERSION_LIBGCRYPT="1.10.3"
VERSION_LIBGPGERROR="1.51"
VERSION_LIBXCRYPT="4.4.38"
VERSION_LVM="2.03.22"
VERSION_LZO="2.10"
VERSION_MDADM="4.2"
VERSION_POPT="1.19"
VERSION_STRACE="6.15"
VERSION_THIN_PROVISIONING_TOOLS="0.9.0"
# unionfs-fuse-3.4 needs fuse:3
VERSION_UNIONFS_FUSE="2.0"
VERSION_USERSPACE_RCU="0.14.0"
VERSION_UTIL_LINUX="2.39.3"
VERSION_XFSPROGS="6.4.0"
VERSION_XZ="5.4.2"
VERSION_ZLIB="1.3.1"
VERSION_ZSTD="1.5.5"
VERSION_KEYUTILS="1.6.3"

VERSION_LIBJPEG="9e"
VERSION_LIBMCRYPT="2.5.8"
VERSION_MCRYPT="2.6.8"
VERSION_MHASH="0.9.9.9"
VERSION_STEGHIDE="0.5.1"

COMMON_URI="
	https://git.kernel.org/pub/scm/linux/kernel/git/colyli/bcache-tools.git/snapshot/a5e3753516bd39c431def86c8dfec8a9cea1ddd4.tar.gz -> bcache-tools-${VERSION_BCACHE_TOOLS}.tar.gz
	https://boostorg.jfrog.io/artifactory/main/release/${VERSION_BOOST}/source/boost_${VERSION_BOOST//./_}.tar.bz2
	https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${VERSION_BTRFS_PROGS}.tar.xz
	https://www.busybox.net/downloads/busybox-${VERSION_BUSYBOX}.tar.bz2
	mirror://gnu/coreutils/coreutils-${VERSION_COREUTILS}.tar.xz
	https://www.kernel.org/pub/linux/utils/cryptsetup/v$(ver_cut 1-2 ${VERSION_CRYPTSETUP})/cryptsetup-${VERSION_CRYPTSETUP}.tar.xz
	https://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	https://matt.ucc.asn.au/dropbear/releases/dropbear-${VERSION_DROPBEAR}.tar.bz2
	https://github.com/eudev-project/eudev/releases/download/v${VERSION_EUDEV}/eudev-${VERSION_EUDEV}.tar.gz
	https://github.com/libexpat/libexpat/releases/download/R_${VERSION_EXPAT//\./_}/expat-${VERSION_EXPAT}.tar.xz
	https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${VERSION_E2FSPROGS}/e2fsprogs-${VERSION_E2FSPROGS}.tar.xz
	https://github.com/libfuse/libfuse/releases/download/fuse-${VERSION_FUSE}/fuse-${VERSION_FUSE}.tar.gz
	mirror://gnupg/gnupg/gnupg-${VERSION_GPG}.tar.bz2
	https://github.com/gentoo/hwids/archive/hwids-${VERSION_HWIDS}.tar.gz
	https://github.com/open-iscsi/open-iscsi/archive/${VERSION_ISCSI}.tar.gz -> open-iscsi-${VERSION_ISCSI}.tar.gz
	https://s3.amazonaws.com/json-c_releases/releases/json-c-${VERSION_JSON_C}.tar.gz
	https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-${VERSION_KMOD}.tar.xz
	https://releases.pagure.org/libaio/libaio-${VERSION_LIBAIO}.tar.gz
	mirror://gnupg/libgcrypt/libgcrypt-${VERSION_LIBGCRYPT}.tar.bz2
	mirror://gnupg/libgpg-error/libgpg-error-${VERSION_LIBGPGERROR}.tar.bz2
	https://github.com/besser82/libxcrypt/releases/download/v${VERSION_LIBXCRYPT}/libxcrypt-${VERSION_LIBXCRYPT}.tar.xz
	https://mirrors.kernel.org/sourceware/lvm2/LVM2.${VERSION_LVM}.tgz
	https://www.oberhumer.com/opensource/lzo/download/lzo-${VERSION_LZO}.tar.gz
	https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-${VERSION_MDADM}.tar.xz
	http://ftp.rpm.org/popt/releases/popt-1.x/popt-${VERSION_POPT}.tar.gz
	https://github.com/strace/strace/releases/download/v${VERSION_STRACE}/strace-${VERSION_STRACE}.tar.xz
	https://github.com/jthornber/thin-provisioning-tools/archive/v${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz -> thin-provisioning-tools-${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz
	https://github.com/rpodgorny/unionfs-fuse/archive/v${VERSION_UNIONFS_FUSE}.tar.gz -> unionfs-fuse-${VERSION_UNIONFS_FUSE}.tar.gz
	https://lttng.org/files/urcu/userspace-rcu-${VERSION_USERSPACE_RCU}.tar.bz2
	https://www.kernel.org/pub/linux/utils/util-linux/v${VERSION_UTIL_LINUX:0:4}/util-linux-${VERSION_UTIL_LINUX}.tar.xz
	https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${VERSION_XFSPROGS}.tar.xz
	https://tukaani.org/xz/xz-${VERSION_XZ}.tar.gz
	https://zlib.net/zlib-${VERSION_ZLIB}.tar.gz
	https://github.com/facebook/zstd/archive/v${VERSION_ZSTD}.tar.gz -> zstd-${VERSION_ZSTD}.tar.gz
	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/keyutils-${VERSION_KEYUTILS}.tar.gz

	steghide? (
		https://www.ijg.org/files/jpegsrc.v${VERSION_LIBJPEG}.tar.gz
		mirror://sourceforge/mcrypt/libmcrypt-${VERSION_LIBMCRYPT}.tar.gz
		mirror://sourceforge/mcrypt/mcrypt-${VERSION_MCRYPT}.tar.gz
		mirror://sourceforge/mhash/mhash-${VERSION_MHASH}.tar.gz
		mirror://sourceforge/steghide/steghide-${VERSION_STEGHIDE}.tar.bz2
	)
"

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
	inherit git-r3
	SRC_URI="
		${COMMON_URI}
	"
else
	#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
	SRC_URI="
		${COMMON_URI}
		https://dev.gentoo.org/~bkohler/dist/${MY_P}.tar.xz
	"
fi
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Genkernel https://gitweb.gentoo.org/proj/genkernel.git/"
LICENSE="
	GPL-2
	entry? (
		GPL-2
		Linux-syscall-note
	)
	steghide? (
		GPL-2
		BSD
		IJG
		LGPL-2.1
		ZLIB
	)
"
RESTRICT=""
SLOT="0/experimental"
IUSE+=" ibm +firmware systemd"
IUSE+=" entry"					# Added by oteodoro.
IUSE+=" subdir_mount"				# Added by the muslx32 overlay.
IUSE+=" +llvm +lto cfi shadowcallstack"		# Added by the oiledmachine-overlay.
# Added by the oiledmachine-overlay. \
IUSE+="
	clang-pgo
	steghide
	sudo
	pgo-custom
	genkernel_trainers_crypto
	genkernel_trainers_memory
	genkernel_trainers_network
	genkernel_trainers_p2p
	genkernel_trainers_webcam
	genkernel_trainers_xscreensaver_2d
	genkernel_trainers_xscreensaver_3d
	genkernel_trainers_yt
"
REQUIRED_USE+="
	${PYTHON_REQUIRED_USE}
	cfi? (
		llvm
		lto
	)
	clang-pgo? (
		llvm
		|| (
			genkernel_trainers_crypto
			genkernel_trainers_memory
			genkernel_trainers_network
			genkernel_trainers_p2p
			genkernel_trainers_webcam
			genkernel_trainers_xscreensaver_2d
			genkernel_trainers_xscreensaver_3d
			genkernel_trainers_yt
		)
	)
	lto? (
		llvm
	)
	genkernel_trainers_crypto? (
		clang-pgo
	)
	genkernel_trainers_memory? (
		clang-pgo
	)
	genkernel_trainers_network? (
		clang-pgo
	)
	genkernel_trainers_p2p? (
		clang-pgo
	)
	genkernel_trainers_webcam? (
		clang-pgo
	)
	genkernel_trainers_xscreensaver_2d? (
		clang-pgo
	)
	genkernel_trainers_xscreensaver_3d? (
		clang-pgo
	)
	genkernel_trainers_yt? (
		clang-pgo
	)
	shadowcallstack? (
		cfi
	)
	steghide? (
		entry
	)
"
gen_scs_exclusion() {
	for a in ${EXCLUDE_SCS[@]} ; do
		echo "
			${a}? (
				!shadowcallstack
			)
		"
	done
}
REQUIRED_USE+="
	$(gen_scs_exclusion)
"

gen_clang_pgo_rdepends() {
	for s in ${LLVM_PGO_SLOTS[@]} ; do
		echo "
			(
				llvm-core/clang:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}

gen_llvm_rdepends() {
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			(
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}

gen_lto_rdepends() {
	for s in ${LLVM_LTO_SLOTS[@]} ; do
		echo "
			(
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}

gen_cfi_arm64_rdepends() {
	for s in ${LLVM_CFI_ARM64_SLOTS[@]} ; do
		echo "
			(
				=llvm-runtimes/clang-runtime-${s}*[compiler-rt,sanitize]
				=llvm-runtimes/compiler-rt-${s}*
				=llvm-runtimes/compiler-rt-sanitizers-${s}*[cfi?,shadowcallstack?]
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}

gen_cfi_x86_rdepends() {
	for s in ${LLVM_CFI_X86_SLOTS[@]} ; do
		echo "
			(
				=llvm-runtimes/clang-runtime-${s}*[compiler-rt,sanitize]
				=llvm-runtimes/compiler-rt-${s}*
				=llvm-runtimes/compiler-rt-sanitizers-${s}*[cfi?,shadowcallstack?]
				llvm-core/clang:${s}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}
			)
		"
	done
}

# Note:
# We need sys-devel/* deps like autoconf or automake at _runtime_
# because genkernel will usually build things like LVM2, cryptsetup,
# mdadm... during initramfs generation which will require these
# things.
DEPEND="
	app-text/asciidoc
"
RDEPEND+="
	${PYTHON_DEPS}
	>=app-misc/pax-utils-1.2.2
	app-alternatives/cpio
	app-portage/elt-patches
	app-portage/portage-utils
	app-text/asciidoc
	dev-build/cmake
	dev-util/gperf
	sys-apps/sandbox
	dev-build/autoconf
	dev-build/autoconf-archive
	dev-build/automake
	app-alternatives/bc
	app-alternatives/yacc
	app-alternatives/lex
	dev-build/libtool
	virtual/pkgconfig
	elibc_glibc? (
		sys-libs/glibc[static-libs(+)]
	)
	firmware? (
		sys-kernel/linux-firmware
	)
"
RDEPEND+="
	cfi? (
		amd64? (
			llvm? (
				|| (
					$(gen_cfi_x86_rdepends)
				)
			)
		)
		arm64? (
			llvm? (
				|| (
					$(gen_cfi_arm64_rdepends)
				)
			)
		)
	)
	clang-pgo? (
		sudo? (
			app-admin/sudo
		)
		|| (
			$(gen_clang_pgo_rdepends)
		)
	)
	firmware? (
		sys-kernel/linux-firmware
	)
	llvm? (
		lto? (
			|| (
				$(gen_lto_rdepends)
			)
		)
		|| (
			$(gen_llvm_rdepends)
		)
	)
	genkernel_trainers_crypto? (
		sys-fs/cryptsetup
	)
	genkernel_trainers_memory? (
		sys-apps/util-linux
		sys-process/procps
	)
	genkernel_trainers_network? (
		net-analyzer/traceroute
		net-misc/curl
		net-misc/iputils
	)
	genkernel_trainers_p2p? (
		net-p2p/ctorrent
		sys-apps/util-linux
		sys-process/procps
	)
	genkernel_trainers_webcam? (
		media-libs/libv4l[utils]
		media-video/ffmpeg[encode,v4l]
	)
	genkernel_trainers_yt? (
		$(python_gen_cond_dep 'dev-python/selenium[${PYTHON_USEDEP}]')
		|| (
			(
				www-client/chromium
			)
			(
				www-client/google-chrome
				www-apps/chromedriver-bin
			)
			(
				www-client/firefox[geckodriver]
			)
		)
	)
	genkernel_trainers_xscreensaver_2d? (
		sys-process/procps
		x11-misc/xscreensaver[X]
	)
	genkernel_trainers_xscreensaver_3d? (
		sys-process/procps
		virtual/opengl
		x11-misc/xscreensaver[X,opengl]
	)
"
PATCHES=(
	"${FILESDIR}/genkernel-4.3.16-globbing-workaround.patch"
)

pkg_setup() {
	filter-lto
	python-single-r1_pkg_setup
}

src_unpack() {
	if [[ "${PV}" =~ "9999" ]]; then
		git-r3_src_unpack
	else
		local gk_src_file
		for gk_src_file in ${A} ; do
			if [[ ${gk_src_file} == genkernel-* ]] ; then
				unpack "${gk_src_file}"
			fi
		done
	fi
}

src_prepare() {
	default
eerror
eerror "This particular ebuild revision is for development only.  Use the stable"
eerror "later revisions instead."
eerror
	die

	if [[ "${PV}" =~ "9999" ]] ; then
		einfo "Updating version tag"
		GK_V="$(git describe --tags | sed 's:^v::')-git"
		sed "/^GK_V/s,=.*,='${GK_V}',g" -i "${S}/genkernel"
		einfo "Producing ChangeLog from Git history..."
		pushd "${S}/.git" >/dev/null 2>&1 || die
			git log > "${S}/ChangeLog" || die
		popd >/dev/null 2>&1 || die
	fi

	eapply "${FILESDIR}/${PN}-4.2.3-compiler-noise.patch" # oiledmachine-overlay patch

	if use subdir_mount ; then # conditional and codeblock and use flag added by muslx32 overlay
		ewarn "The subdir_mount USE flag is untested for ${PV}.  Do not use at this time.  Use the 3.5.x.x ebuild instead."
		eapply "${FILESDIR}/${PN}-4.1.2-subdir-mount.patch" # oiledmachine-overlay patch
	fi

	if use entry ; then
		# Technically, one can't have plausable deniability because the packages are
		# named libgcrypt or cryptsetup or crypt anything.  One would have to
		# obfuscate or strip everything without crypt or the ciphers or anything
		# related.  This patch will try to fix the facade issue (aka immediate password
		# prompt) and the encrypted device referencing issue (destroying the plausable
		# deniability of plain).
		eapply "${FILESDIR}/${PN}-4.3.6-entry-r1.patch" # oiledmachine-overlay patch
		eapply "${FILESDIR}/${PN}-4.3.8-dmcrypt-plain-support-v3.patch" # oiledmachine-overlay patch
		eapply "${FILESDIR}/${PN}-4.3.6-fallback.patch" # oiledmachine-overlay patch
		ewarn
		ewarn "The entry USE flag is in testing."
		ewarn
		ewarn "DO NOT USE until you have filled out and edited the missing settings,"
		ewarn "and have a full understanding of the patch itself."
		ewarn
		eerror
		eerror "Complete emerge is stopped as safeguard.  Please wait for the finished"
		eerror "patch or fork ebuild.  The patch may result in data loss if there is"
		eerror "no backup bootdisk built with =genkernel-4.2.6-r2[crypt_root_plain]"
		eerror "for this experimental release."
		eerror
		die
	fi

	if use llvm ; then
		eapply "${FILESDIR}/${PN}-4.3.8-llvm-support-v6.patch" # oiledmachine-overlay patch
	fi

	if use clang-pgo ; then
		eapply "${FILESDIR}/${PN}-4.2.3-pgo-support.patch" # oiledmachine-overlay patch
	fi

	cp -aT "${FILESDIR}/genkernel-4.2.x" "${S}/patches" || die

	# Export all the versions that may be used by genkernel build.
	local v
	for v in $(set |awk -F= '/^VERSION_/{print $1}') ; do
		export ${v}
	done

	if use ibm ; then
		cp "${S}/arch/ppc64/kernel-2.6"{"-pSeries",""} || die
	else
		cp "${S}/arch/ppc64/kernel-2.6"{".g5",""} || die
	fi
}

src_compile() {
	emake PREFIX="/usr"
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	dodoc "AUTHORS" "ChangeLog" "README" "TODO"

	python_fix_shebang "${ED}/usr/share/genkernel/path_expander.py"

	newbashcomp "${FILESDIR}/genkernel-4.bash" "${PN}"
	insinto /etc
	doins "${FILESDIR}/initramfs.mounts"

	pushd "${DISTDIR}" &>/dev/null || die
		insinto "/usr/share/genkernel/distfiles"
		doins ${A/${MY_P}.tar.xz/}
	popd &>/dev/null || die

	# Workaround for bug 944499, for now this patch will live in FILESDIR and is
	# conditionally installed but we could add it to genkernel.git and conditionally
	# remove it here instead.
	if ! use systemd; then
		insinto "/usr/share/genkernel/patches/lvm/${VERSION_LVM}/"
		doins "${FILESDIR}/lvm2-2.03.20-dm_lvm_rules_no_systemd_v2.patch"
	fi
}

pkg_postinst() {
# Wiki is out of date
#elog
#elog 'Documentation is available in the genkernel manual page as well as the'
#elog 'following URL:'
#elog
#elog 'https://wiki.gentoo.org/wiki/Genkernel'
#elog

	local replacing_version
	for replacing_version in ${REPLACING_VERSIONS} ; do
		if ver_test "${replacing_version}" -lt 4 ; then
			# This is an upgrade which requires user review

ewarn
ewarn "Genkernel v4.x is a new major release which touches nearly everything."
ewarn "Be careful, read updated manpage and pay special attention to program"
ewarn "output regarding changed kernel command-line parameters!"
ewarn

			# Show this elog only once
			break
		fi
	done

	local n_kernels=$(find "/boot" -name 'kernel-genkernel-*' 2>/dev/null \
		| wc -l)
	if (( ${n_kernels} > 0 )) ; then
ewarn
ewarn 'The default kernel filename was changed from'
ewarn
ewarn '  "kernel-genkernel-<ARCH>-<KV>"'
ewarn
ewarn 'to'
ewarn
ewarn '  "vmlinuz-<KV>".'
ewarn
ewarn 'Please be aware that due to lexical ordering the *default* boot entry in'
ewarn 'your boot manager could still point to last kernel built with genkernel'
ewarn 'before that name change, resulting in booting old kernel when not paying'
ewarn 'attention on boot.'
ewarn
	fi

	# Show special warning for users depending on remote unlock capabilities
	local gk_config="${EROOT}/etc/genkernel.conf"
	if [[ -f "${gk_config}" ]] ; then
		if grep -q -E "^SSH=[\"\']?yes" "${gk_config}" 2>/dev/null ; then
			if ! grep -q "dosshd" "/proc/cmdline" 2>/dev/null ; then
ewarn
ewarn "IMPORTANT:"
ewarn
ewarn "SSH is currently enabled in your genkernel config file (${gk_config})."
ewarn "However, 'dosshd' is missing from current kernel command-line.  You MUST"
ewarn "add 'dosshd' to keep sshd enabled in genkernel v4+ initramfs!"
ewarn
			fi
		fi

		if grep -q -E "^CMD_CALLBACK=.*emerge.*@module-rebuild" "${gk_config}" 2>/dev/null ; then
elog ""
elog "Please remove 'emerge @module-rebuild' from genkernel config file"
elog "(${gk_config}) and make use of new MODULEREBUILD option instead."
elog ""
		fi
	fi

	local n_root_args=$(grep -o -- '\<root=' "/proc/cmdline" 2>/dev/null \
		| wc -l)
	if [[ ${n_root_args} -gt 1 ]] ; then
ewarn
ewarn "WARNING:"
ewarn
ewarn "Multiple root arguments (root=) on kernel command-line detected!  If you"
ewarn "are appending non-persistent device names to kernel command-line, the"
ewarn "next reboot could fail in case running system and initramfs do not agree"
ewarn "on detected root device name!"
ewarn
	fi

	if [[ -d "/run" ]] ; then
		local permission_run_expected="drwxr-xr-x"
		local permission_run=$(stat -c "%A" "/run")
		if [[ "${permission_run}" != "${permission_run_expected}" ]] ; then
ewarn
ewarn "Found the following problematic permissions:"
ewarn
ewarn "    ${permission_run} /run"
ewarn
ewarn "Expected:"
ewarn
ewarn "    ${permission_run_expected} /run"
ewarn
ewarn "This is known to be causing problems for any UDEV-enabled service."
ewarn
		fi
	fi

elog
elog "The 4.x Genkernel patches for subdir_mount are"
elog "experimental and untested."
elog
elog "To activate the USE flag do:"
elog "mkdir -p /etc/portage/profile"
elog "echo \"sys-kernel/genkernel -subdir_mount\" >> /etc/portage/profile/package.use.mask"
elog
elog "Use 3.x Genkernel series for tested reliable patch for subdir_mount."
elog
elog "Genkernel 4.x users should keep a backup of your old initramfs produced"
elog "by Genkernel 3.x just in case things go wrong."

ewarn
ewarn "You must load all modules by adding \"gk.hw.use-modules_load=1\" from"
ewarn "the kernel parameter list for grub or have the drivers built in to use"
ewarn " the kernel with the entry USE flag."
ewarn

ewarn
ewarn "The identifiers in /dev/disk/by-id/ have changed between older versions"
ewarn "of genkernel and this version.  Please update the kernel parameters"
ewarn "provided to for grub when switching between the two versions.  Go to"
ewarn "shell mode and \`ls /dev/disk/by-id\`.  Then, take a photo of the"
ewarn "changes and manually edit grub."
ewarn

	# LVM2 has commits in newer to avoid free after use
ewarn
ewarn "The dependencies may have vulnerabilities or have vulnerability"
ewarn "avoidance upstream."
ewarn

ewarn
ewarn "The --clang and --llvm have been replaced with --clang-kernel and"
ewarn "--llvm-kernel.  The former command line options may be removed."
ewarn

ewarn
ewarn "The --clang-utils or --llvm-utils options are experimental.  Only basic"
ewarn "initramfs modules were tested.  If runtime or buildtime failure occurs"
ewarn "with clang, you may need to switch to gcc for that package.  Details"
ewarn "can be found in genkernel-4.2.3-llvm-support-v2.patch.  Either fork the"
ewarn "ebuild, supply a user patch, or send the option as an issue request for"
ewarn "review."
ewarn

einfo
einfo "The --clang, --llvm, --clang-kernel, ---llvm-kernel do not imply --lto."
einfo "You must add --lto if you want to automatically configure and build with"
einfo "the lto and llvm."
einfo

	if use clang-pgo ; then
ewarn
ewarn "See the metadata.xml next to this ebuild for additional environment"
ewarn "variables for PGO training."
ewarn
ewarn "You still need to manually set the profraw version in the kernel config."
ewarn
	fi

ewarn
ewarn "Entry is currently in development but will announce when it is ready."
ewarn "It is pre-alpha quality at this time."
ewarn
ewarn "Access though the crypt_root_plain is provided as a fallback until"
ewarn "entry is production ready.  It is recommended to use genkernel-4.2.6-r2"
ewarn "or the highest revision instead."
ewarn

	if use steghide ; then
ewarn
ewarn "The steghide requires you manually embed the payload into a compatible"
ewarn "audio or image asset.  Only decode supported."
ewarn
	fi

ewarn
ewarn "This version with oiledmachine-overlay patches has not been tested."
ewarn "Do not use at this time.  Use 4.2.3 instead."
ewarn

ewarn
ewarn "For proper eudev and /dev/disk/{by-id,by-uuid,...} support the following"
ewarn "changes should be made so that it is built-in the kernel and not as a"
ewarn "module in the kernel config:"
ewarn
ewarn "  CONFIG_NET=y"
ewarn "  CONFIG_UNIX=y"
ewarn
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, pgo, lto, patch-additions
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
