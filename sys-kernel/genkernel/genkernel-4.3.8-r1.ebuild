# Copyright 2022-2023 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# EXPERIMENTAL VERSION (UNSTABLE / NOT RECOMMENDED)

# The reuse of revision r7 was used so that newer bumps
# do not interfere with an ongoing patch update for a stable working build.
# This experimental series could have have been revision -r(x+1),
# and the stable series -rX, but this one will be frozen until it
# is at least in working state.

# 4.2.6-rX (highest revision) is stable oiledmachine-overlay patches
# 4.2.6-r1 is with Work in Progress (WIP) entry changes and experimental patches.

# Changes to the 4.2.x PGO will be backported to genkernel 4.0.x later.

# genkernel-9999        -> latest Git branch "master"
# genkernel-VERSION     -> normal genkernel release

# The original version of this ebuild is 4.2.6-r1::gentoo
# modified with subdir_mount, entry, llvm, pgo changes.  Revision
# bumps may change on the oiledmachine-overlay.

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit bash-completion-r1 python-single-r1

# Whenever you bump a GKPKG, check if you have to move
# or add new patches!
VERSION_BCACHE_TOOLS="1.0.8_p20141204"
VERSION_BOOST="1.79.0"
VERSION_BTRFS_PROGS="6.3.2"
VERSION_BUSYBOX="1.34.1"
VERSION_COREUTILS="9.3"
VERSION_CRYPTSETUP="2.4.1"
VERSION_DMRAID="1.0.0.rc16-3"
VERSION_DROPBEAR="2022.83"
VERSION_EUDEV="3.2.10"
VERSION_EXPAT="2.5.0"
VERSION_E2FSPROGS="1.46.4"
VERSION_FUSE="2.9.9"
VERSION_GPG="1.4.23"
VERSION_HWIDS="20210613"
VERSION_ISCSI="2.1.8"
VERSION_JSON_C="0.13.1"
VERSION_KMOD="30"
VERSION_LIBAIO="0.3.113"
VERSION_LIBGCRYPT="1.9.4"
VERSION_LIBGPGERROR="1.43"
VERSION_LIBXCRYPT="4.4.36"
VERSION_LVM="2.02.188"
VERSION_LZO="2.10"
VERSION_MDADM="4.1"
VERSION_POPT="1.18"
VERSION_STRACE="6.4"
VERSION_THIN_PROVISIONING_TOOLS="0.9.0"
VERSION_UNIONFS_FUSE="2.0"
VERSION_USERSPACE_RCU="0.14.0"
VERSION_UTIL_LINUX="2.38.1"
VERSION_XFSPROGS="6.3.0"
VERSION_XZ="5.4.3"
VERSION_ZLIB="1.2.13"
VERSION_ZSTD="1.5.5"
VERSION_KEYUTILS="1.6.3"

VERSION_LIBJPEG="9e"
VERSION_LIBMCRYPT="2.5.8"
VERSION_MCRYPT="2.6.8"
VERSION_MHASH="0.9.9.9"
VERSION_STEGHIDE="0.5.1"

COMMON_URI="
	https://github.com/g2p/bcache-tools/archive/399021549984ad27bf4a13ae85e458833fe003d7.tar.gz -> bcache-tools-${VERSION_BCACHE_TOOLS}.tar.gz
	https://boostorg.jfrog.io/artifactory/main/release/${VERSION_BOOST}/source/boost_${VERSION_BOOST//./_}.tar.bz2
	https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${VERSION_BTRFS_PROGS}.tar.xz
	https://www.busybox.net/downloads/busybox-${VERSION_BUSYBOX}.tar.bz2
	mirror://gnu/coreutils/coreutils-${VERSION_COREUTILS}.tar.xz
	https://www.kernel.org/pub/linux/utils/cryptsetup/v$(ver_cut 1-2 ${VERSION_CRYPTSETUP})/cryptsetup-${VERSION_CRYPTSETUP}.tar.xz
	https://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	https://matt.ucc.asn.au/dropbear/releases/dropbear-${VERSION_DROPBEAR}.tar.bz2
	https://dev.gentoo.org/~blueness/eudev/eudev-${VERSION_EUDEV}.tar.gz
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

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
	inherit git-r3
	S="${WORKDIR}/${P}"
	SRC_URI="${COMMON_URI}"
else
	SRC_URI="https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}.tar.xz
		${COMMON_URI}"
	#KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"
fi

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Genkernel https://gitweb.gentoo.org/proj/genkernel.git/"

LICENSE="GPL-2
	entry? ( GPL-2 Linux-syscall-note )
	steghide? ( GPL-2 BSD IJG LGPL-2.1 ZLIB )
"
SLOT="0"
RESTRICT=""
IUSE+=" ibm +firmware"
IUSE+=" entry"					# Added by oteodoro.
IUSE+=" subdir_mount"				# Added by the muslx32 overlay.
IUSE+=" +llvm +lto cfi shadowcallstack"		# Added by the oiledmachine-overlay.
IUSE+="
	clang-pgo
	steghide
	sudo
	pgo-custom
	pgo_trainer_crypto
	pgo_trainer_memory
	pgo_trainer_network
	pgo_trainer_p2p
	pgo_trainer_webcam
	pgo_trainer_xscreensaver_2d
	pgo_trainer_xscreensaver_3d
	pgo_trainer_yt
" # Added by the oiledmachine-overlay.
REQUIRED_USE+=" ${PYTHON_REQUIRED_USE}"
EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
	ia64
	mips
	ppc
	ppc64
	riscv
	s390
	sparc
	x86
)
REQUIRED_USE+="
	cfi? (
		llvm
		lto
	)
	clang-pgo? (
		llvm
		|| (
			pgo_trainer_crypto
			pgo_trainer_memory
			pgo_trainer_network
			pgo_trainer_p2p
			pgo_trainer_webcam
			pgo_trainer_xscreensaver_2d
			pgo_trainer_xscreensaver_3d
			pgo_trainer_yt
		)
	)
	lto? (
		llvm
	)
	pgo_trainer_crypto? (
		clang-pgo
	)
	pgo_trainer_memory? (
		clang-pgo
	)
	pgo_trainer_network? (
		clang-pgo
	)
	pgo_trainer_p2p? (
		clang-pgo
	)
	pgo_trainer_webcam? (
		clang-pgo
	)
	pgo_trainer_xscreensaver_2d? (
		clang-pgo
	)
	pgo_trainer_xscreensaver_3d? (
		clang-pgo
	)
	pgo_trainer_yt? (
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
REQUIRED_USE+=" "$(gen_scs_exclusion)

LLVM_SLOTS=(11 12 13 14)
LLVM_LTO_SLOTS=(11 12 13 14)
LLVM_CFI_ARM64_SLOTS=(12 13 14)
LLVM_CFI_X86_SLOTS=(13 14)
LLVM_PGO_SLOTS=(13 14)

gen_clang_pgo_rdepends() {
	for s in ${LLVM_PGO_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/llvm:${s}
			)
		"
	done
}

gen_llvm_rdepends() {
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/lld:${s}
				sys-devel/llvm:${s}
			)
		"
	done
}

gen_lto_rdepends() {
	for s in ${LLVM_LTO_SLOTS[@]} ; do
		echo "
			(
				sys-devel/clang:${s}
				sys-devel/lld:${s}
				sys-devel/llvm:${s}
			)
		"
	done
}

gen_cfi_arm64_rdepends() {
	for s in ${LLVM_CFI_ARM64_SLOTS[@]} ; do
		echo "
			(
				=sys-devel/clang-runtime-${s}*[compiler-rt,sanitize]
				=sys-libs/compiler-rt-${s}*
				=sys-libs/compiler-rt-sanitizers-${s}*[cfi?,shadowcallstack?]
				sys-devel/clang:${s}
				sys-devel/lld:${s}
				sys-devel/llvm:${s}
			)
		"
	done
}

gen_cfi_x86_rdepends() {
	for s in ${LLVM_CFI_X86_SLOTS[@]} ; do
		echo "
			(
				=sys-devel/clang-runtime-${s}*[compiler-rt,sanitize]
				=sys-libs/compiler-rt-${s}*
				=sys-libs/compiler-rt-sanitizers-${s}*[cfi?,shadowcallstack?]
				sys-devel/clang:${s}
				sys-devel/lld:${s}
				sys-devel/llvm:${s}
			)
		"
	done
}

# Note:
# We need sys-devel/* deps like autoconf or automake at _runtime_
# because genkernel will usually build things like LVM2, cryptsetup,
# mdadm... during initramfs generation which will require these
# things.
RDEPEND+="
	${PYTHON_DEPS}
	>=app-misc/pax-utils-1.2.2
	app-portage/elt-patches
	app-portage/portage-utils
	dev-util/gperf
	sys-apps/sandbox
	sys-devel/autoconf
	dev-build/autoconf-archive
	sys-devel/automake
	sys-devel/bc
	sys-devel/bison
	sys-devel/flex
	sys-devel/libtool
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
	pgo_trainer_crypto? (
		sys-fs/cryptsetup
	)
	pgo_trainer_memory? (
		sys-apps/util-linux
		sys-process/procps
	)
	pgo_trainer_network? (
		net-analyzer/traceroute
		net-misc/curl
		net-misc/iputils
	)
	pgo_trainer_p2p? (
		net-p2p/ctorrent
		sys-apps/util-linux
		sys-process/procps
	)
	pgo_trainer_webcam? (
		media-tv/v4l-utils
		media-video/ffmpeg[encode,v4l]
	)
	pgo_trainer_yt? (
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
	pgo_trainer_xscreensaver_2d? (
		sys-process/procps
		x11-misc/xscreensaver[X]
	)
	pgo_trainer_xscreensaver_3d? (
		sys-process/procps
		virtual/opengl
		x11-misc/xscreensaver[X,opengl]
	)
"

if [[ ${PV} == 9999* ]]; then
	DEPEND="${DEPEND} app-text/asciidoc"
fi

PATCHES=(
)

src_unpack() {
	if [[ ${PV} == 9999* ]]; then
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
eerror "This particular ebuild revision is for development only.  Use stable"
eerror "later revisions instead."
eerror
	die

	if [[ ${PV} == 9999* ]] ; then
		einfo "Updating version tag"
		GK_V="$(git describe --tags | sed 's:^v::')-git"
		sed "/^GK_V/s,=.*,='${GK_V}',g" -i "${S}"/genkernel
		einfo "Producing ChangeLog from Git history..."
		pushd "${S}/.git" >/dev/null || die
		git log > "${S}"/ChangeLog || die
		popd >/dev/null || die
	fi

	# Update software.sh
	sed -i \
		-e "s:VERSION_BCACHE_TOOLS:${VERSION_BCACHE_TOOLS}:"\
		-e "s:VERSION_BOOST:${VERSION_BOOST}:"\
		-e "s:VERSION_BTRFS_PROGS:${VERSION_BTRFS_PROGS}:"\
		-e "s:VERSION_BUSYBOX:${VERSION_BUSYBOX}:"\
		-e "s:VERSION_COREUTILS:${VERSION_COREUTILS}:"\
		-e "s:VERSION_CRYPTSETUP:${VERSION_CRYPTSETUP}:"\
		-e "s:VERSION_DMRAID:${VERSION_DMRAID}:"\
		-e "s:VERSION_DROPBEAR:${VERSION_DROPBEAR}:"\
		-e "s:VERSION_EUDEV:${VERSION_EUDEV}:"\
		-e "s:VERSION_EXPAT:${VERSION_EXPAT}:"\
		-e "s:VERSION_E2FSPROGS:${VERSION_E2FSPROGS}:"\
		-e "s:VERSION_FUSE:${VERSION_FUSE}:"\
		-e "s:VERSION_GPG:${VERSION_GPG}:"\
		-e "s:VERSION_HWIDS:${VERSION_HWIDS}:"\
		-e "s:VERSION_ISCSI:${VERSION_ISCSI}:"\
		-e "s:VERSION_JSON_C:${VERSION_JSON_C}:"\
		-e "s:VERSION_KMOD:${VERSION_KMOD}:"\
		-e "s:VERSION_LIBAIO:${VERSION_LIBAIO}:"\
		-e "s:VERSION_LIBGCRYPT:${VERSION_LIBGCRYPT}:"\
		-e "s:VERSION_LIBGPGERROR:${VERSION_LIBGPGERROR}:"\
		-e "s:VERSION_LIBXCRYPT:${VERSION_LIBXCRYPT}:"\
		-e "s:VERSION_LVM:${VERSION_LVM}:"\
		-e "s:VERSION_LZO:${VERSION_LZO}:"\
		-e "s:VERSION_MDADM:${VERSION_MDADM}:"\
		-e "s:VERSION_MULTIPATH_TOOLS:${VERSION_MULTIPATH_TOOLS}:"\
		-e "s:VERSION_POPT:${VERSION_POPT}:"\
		-e "s:VERSION_STRACE:${VERSION_STRACE}:"\
		-e "s:VERSION_THIN_PROVISIONING_TOOLS:${VERSION_THIN_PROVISIONING_TOOLS}:"\
		-e "s:VERSION_UNIONFS_FUSE:${VERSION_UNIONFS_FUSE}:"\
		-e "s:VERSION_USERSPACE_RCU:${VERSION_USERSPACE_RCU}:"\
		-e "s:VERSION_UTIL_LINUX:${VERSION_UTIL_LINUX}:"\
		-e "s:VERSION_XFSPROGS:${VERSION_XFSPROGS}:"\
		-e "s:VERSION_XZ:${VERSION_XZ}:"\
		-e "s:VERSION_ZLIB:${VERSION_ZLIB}:"\
		-e "s:VERSION_ZSTD:${VERSION_ZSTD}:"\
		"${S}"/defaults/software.sh \
		|| die "Could not adjust versions"

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
}

src_compile() {
	if [[ ${PV} == 9999* ]] ; then
		emake
	fi
}

src_install() {
	insinto /etc
	doins "${S}"/genkernel.conf

	doman genkernel.8
	dodoc AUTHORS ChangeLog README TODO
	dobin genkernel
	rm -f genkernel genkernel.8 AUTHORS ChangeLog README TODO genkernel.conf

	if use ibm ; then
		cp "${S}"/arch/ppc64/kernel-2.6{-pSeries,} || die
	else
		cp "${S}"/arch/ppc64/kernel-2.6{.g5,} || die
	fi

	insinto /usr/share/genkernel
	doins -r "${S}"/*

	fperms +x /usr/share/genkernel/gen_worker.sh
	fperms +x /usr/share/genkernel/path_expander.py

	python_fix_shebang "${ED}"/usr/share/genkernel/path_expander.py

	newbashcomp "${FILESDIR}"/genkernel-4.bash "${PN}"
	insinto /etc
	doins "${FILESDIR}"/initramfs.mounts

	pushd "${DISTDIR}" &>/dev/null || die
	insinto /usr/share/genkernel/distfiles
	doins ${A/${P}.tar.xz/}
	popd &>/dev/null || die
}

pkg_postinst() {
	# Wiki is out of date
	#echo
	#elog 'Documentation is available in the genkernel manual page'
	#elog 'as well as the following URL:'
	#echo
	#elog 'https://wiki.gentoo.org/wiki/Genkernel'
	#echo

	local replacing_version
	for replacing_version in ${REPLACING_VERSIONS} ; do
		if ver_test "${replacing_version}" -lt 4 ; then
			# This is an upgrade which requires user review

			ewarn ""
			ewarn "Genkernel v4.x is a new major release which touches"
			ewarn "nearly everything. Be careful, read updated manpage"
			ewarn "and pay special attention to program output regarding"
			ewarn "changed kernel command-line parameters!"

			# Show this elog only once
			break
		fi
	done

	if [[ $(find /boot -name 'kernel-genkernel-*' 2>/dev/null | wc -l) -gt 0 ]] ; then
		ewarn ''
		ewarn 'Default kernel filename was changed from "kernel-genkernel-<ARCH>-<KV>"'
		ewarn 'to "vmlinuz-<KV>". Please be aware that due to lexical ordering the'
		ewarn '*default* boot entry in your boot manager could still point to last kernel'
		ewarn 'built with genkernel before that name change, resulting in booting old'
		ewarn 'kernel when not paying attention on boot.'
	fi

	# Show special warning for users depending on remote unlock capabilities
	local gk_config="${EROOT}/etc/genkernel.conf"
	if [[ -f "${gk_config}" ]] ; then
		if grep -q -E "^SSH=[\"\']?yes" "${gk_config}" 2>/dev/null ; then
			if ! grep -q dosshd /proc/cmdline 2>/dev/null ; then
				ewarn ""
				ewarn "IMPORTANT: SSH is currently enabled in your genkernel config"
				ewarn "file (${gk_config}). However, 'dosshd' is missing from current"
				ewarn "kernel command-line. You MUST add 'dosshd' to keep sshd enabled"
				ewarn "in genkernel v4+ initramfs!"
			fi
		fi

		if grep -q -E "^CMD_CALLBACK=.*emerge.*@module-rebuild" "${gk_config}" 2>/dev/null ; then
			elog ""
			elog "Please remove 'emerge @module-rebuild' from genkernel config"
			elog "file (${gk_config}) and make use of new MODULEREBUILD option"
			elog "instead."
		fi
	fi

	local n_root_args=$(grep -o -- '\<root=' /proc/cmdline 2>/dev/null | wc -l)
	if [[ ${n_root_args} -gt 1 ]] ; then
		ewarn "WARNING: Multiple root arguments (root=) on kernel command-line detected!"
		ewarn "If you are appending non-persistent device names to kernel command-line,"
		ewarn "next reboot could fail in case running system and initramfs do not agree"
		ewarn "on detected root device name!"
	fi

	if [[ -d /run ]] ; then
		local permission_run_expected="drwxr-xr-x"
		local permission_run=$(stat -c "%A" /run)
		if [[ "${permission_run}" != "${permission_run_expected}" ]] ; then
			ewarn "Found the following problematic permissions:"
			ewarn ""
			ewarn "    ${permission_run} /run"
			ewarn ""
			ewarn "Expected:"
			ewarn ""
			ewarn "    ${permission_run_expected} /run"
			ewarn ""
			ewarn "This is known to be causing problems for any UDEV-enabled service."
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
	einfo "The --clang, --llvm, --clang-kernel, ---llvm-kernel do not imply"
	einfo "--lto.  You must add --lto if you want to automatically"
	einfo "configure and build with the lto and llvm."
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
	ewarn "For proper eudev and /dev/disk/{by-id,by-uuid,...} support the"
	ewarn "following changes should be made so that it is built-in the"
	ewarn "kernel and not as a module in the kernel config:"
	ewarn
	ewarn "  CONFIG_NET=y"
	ewarn "  CONFIG_UNIX=y"
	ewarn
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, pgo, lto, patch-additions
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
