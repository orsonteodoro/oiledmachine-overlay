# Copyright 2022 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild still exists for the muslx32 overlay for subdir_mount USE flag.

# genkernel-9999        -> latest Git branch "master"
# genkernel-VERSION     -> normal genkernel release

# The original version of this ebuild is 4.0.10::gentoo
# modified with subdir_mount, crypt_root_plain, llvm changes.  Revision
# bumps may change on the oiledmachine-overlay.

EAPI=8

inherit bash-completion-r1

# Whenever you bump a GKPKG, check if you have to move
# or add new patches!
VERSION_BOOST="1.73.0"
VERSION_BTRFS_PROGS="5.6.1"
VERSION_BUSYBOX="1.31.1"
VERSION_COREUTILS="8.32"
VERSION_CRYPTSETUP="2.3.3"
VERSION_DMRAID="1.0.0.rc16-3"
VERSION_DROPBEAR="2020.80"
VERSION_EXPAT="2.2.9"
VERSION_E2FSPROGS="1.45.6"
VERSION_FUSE="2.9.9"
VERSION_GPG="1.4.23"
VERSION_ISCSI="2.0.878"
VERSION_JSON_C="0.13.1"
VERSION_KMOD="27"
VERSION_LIBAIO="0.3.112"
VERSION_LIBGCRYPT="1.8.6"
VERSION_LIBGPGERROR="1.38"
VERSION_LVM="2.02.187"
VERSION_LZO="2.10"
VERSION_MDADM="4.1"
VERSION_POPT="1.18"
VERSION_STRACE="5.7"
VERSION_THIN_PROVISIONING_TOOLS="0.8.5"
VERSION_UNIONFS_FUSE="2.0"
VERSION_UTIL_LINUX="2.35.2"
VERSION_XFSPROGS="5.6.0"
VERSION_ZLIB="1.2.11"
VERSION_ZSTD="1.4.5"

COMMON_URI="
	https://boostorg.jfrog.io/artifactory/main/release/${VERSION_BOOST}/source/boost_${VERSION_BOOST//./_}.tar.bz2
	https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/btrfs-progs-v${VERSION_BTRFS_PROGS}.tar.xz
	https://www.busybox.net/downloads/busybox-${VERSION_BUSYBOX}.tar.bz2
	mirror://gnu/coreutils/coreutils-${VERSION_COREUTILS}.tar.xz
	https://www.kernel.org/pub/linux/utils/cryptsetup/v$(ver_cut 1-2 ${VERSION_CRYPTSETUP})/cryptsetup-${VERSION_CRYPTSETUP}.tar.xz
	https://people.redhat.com/~heinzm/sw/dmraid/src/dmraid-${VERSION_DMRAID}.tar.bz2
	https://dev.gentoo.org/~whissi/dist/dropbear/dropbear-${VERSION_DROPBEAR}.tar.bz2
	https://github.com/libexpat/libexpat/releases/download/R_${VERSION_EXPAT//\./_}/expat-${VERSION_EXPAT}.tar.xz
	https://www.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v${VERSION_E2FSPROGS}/e2fsprogs-${VERSION_E2FSPROGS}.tar.xz
	https://github.com/libfuse/libfuse/releases/download/fuse-${VERSION_FUSE}/fuse-${VERSION_FUSE}.tar.gz
	mirror://gnupg/gnupg/gnupg-${VERSION_GPG}.tar.bz2
	https://github.com/open-iscsi/open-iscsi/archive/${VERSION_ISCSI}.tar.gz -> open-iscsi-${VERSION_ISCSI}.tar.gz
	https://s3.amazonaws.com/json-c_releases/releases/json-c-${VERSION_JSON_C}.tar.gz
	https://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-${VERSION_KMOD}.tar.xz
	https://releases.pagure.org/libaio/libaio-${VERSION_LIBAIO}.tar.gz
	mirror://gnupg/libgcrypt/libgcrypt-${VERSION_LIBGCRYPT}.tar.bz2
	mirror://gnupg/libgpg-error/libgpg-error-${VERSION_LIBGPGERROR}.tar.bz2
	https://mirrors.kernel.org/sourceware/lvm2/LVM2.${VERSION_LVM}.tgz
	https://www.oberhumer.com/opensource/lzo/download/lzo-${VERSION_LZO}.tar.gz
	https://www.kernel.org/pub/linux/utils/raid/mdadm/mdadm-${VERSION_MDADM}.tar.xz
	http://ftp.rpm.org/popt/releases/popt-1.x/popt-${VERSION_POPT}.tar.gz
	https://github.com/strace/strace/releases/download/v${VERSION_STRACE}/strace-${VERSION_STRACE}.tar.xz
	https://github.com/jthornber/thin-provisioning-tools/archive/v${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz -> thin-provisioning-tools-${VERSION_THIN_PROVISIONING_TOOLS}.tar.gz
	https://github.com/rpodgorny/unionfs-fuse/archive/v${VERSION_UNIONFS_FUSE}.tar.gz -> unionfs-fuse-${VERSION_UNIONFS_FUSE}.tar.gz
	https://www.kernel.org/pub/linux/utils/util-linux/v${VERSION_UTIL_LINUX:0:4}/util-linux-${VERSION_UTIL_LINUX}.tar.xz
	https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-${VERSION_XFSPROGS}.tar.xz
	https://zlib.net/zlib-${VERSION_ZLIB}.tar.gz
	https://github.com/facebook/zstd/archive/v${VERSION_ZSTD}.tar.gz -> zstd-${VERSION_ZSTD}.tar.gz
"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://anongit.gentoo.org/git/proj/${PN}.git"
	inherit git-r3
	S="${WORKDIR}/${P}"
	SRC_URI="${COMMON_URI}"
else
	SRC_URI="https://dev.gentoo.org/~whissi/dist/genkernel/${P}.tar.xz
		${COMMON_URI}"
	# KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86"
	# Disabled because of security issue with internal dependencies
fi

DESCRIPTION="Gentoo automatic kernel building scripts"
HOMEPAGE="https://wiki.gentoo.org/wiki/Genkernel https://gitweb.gentoo.org/proj/genkernel.git/"

LICENSE="GPL-2"
SLOT="0"
RESTRICT=""
IUSE+=" ibm +firmware"
IUSE+=" crypt_root_plain"			# Added by oteodoro.
IUSE+=" subdir_mount"				# Added by the muslx32 overlay.
IUSE+=" +llvm +lto cfi shadowcallstack"		# Added by the oiledmachine-overlay.
EXCLUDE_SCS=(
	alpha
	amd64
	arm
	hppa
	ia64
	mips
	ppc
	ppc64
	s390
	sparc
	x86
)
REQUIRED_USE+="
	cfi? (
		llvm
		lto
	)
	lto? (
		llvm
	)
	shadowcallstack? (
		cfi
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

# Note:
# We need sys-devel/* deps like autoconf or automake at _runtime_
# because genkernel will usually build things like LVM2, cryptsetup,
# mdadm... during initramfs generation which will require these
# things.
RDEPEND+="
	${DEPEND}
	>=app-misc/pax-utils-1.2.2
	app-arch/cpio
	app-portage/elt-patches
	sys-apps/sandbox
	sys-devel/autoconf
	sys-devel/autoconf-archive
	sys-devel/automake
	sys-devel/libtool
	virtual/pkgconfig
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
"

if [[ ${PV} == 9999* ]]; then
	DEPEND="${DEPEND} app-text/asciidoc"
fi

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
		-e "s:VERSION_ISCSI:${VERSION_ISCSI}:"\
		-e "s:VERSION_JSON_C:${VERSION_JSON_C}:"\
		-e "s:VERSION_KMOD:${VERSION_KMOD}:"\
		-e "s:VERSION_LIBAIO:${VERSION_LIBAIO}:"\
		-e "s:VERSION_LIBGCRYPT:${VERSION_LIBGCRYPT}:"\
		-e "s:VERSION_LIBGPGERROR:${VERSION_LIBGPGERROR}:"\
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
		-e "s:VERSION_ZLIB:${VERSION_ZLIB}:"\
		-e "s:VERSION_ZSTD:${VERSION_ZSTD}:"\
		"${S}"/defaults/software.sh \
		|| die "Could not adjust versions"

	eapply "${FILESDIR}/${PN}-4.2.3-compiler-noise.patch"

	if use subdir_mount ; then # conditional and codeblock and use flag added by muslx32 overlay
		eapply "${FILESDIR}/${PN}-4.0.10-subdir-mount.patch"
	fi

	if use crypt_root_plain ; then
		eapply "${FILESDIR}/${PN}-4.0.10-dmcrypt-plain-support-v3.patch"
	fi

	if use llvm ; then
		eapply "${FILESDIR}/${PN}-4.0.10-llvm-support-v6.patch"
	fi

	cp -aT "${FILESDIR}/genkernel-4.0.x" "${S}/patches" || die
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
	ewarn "You must load all modules by removing \"nodetect\" from the kernel"
	ewarn "parameter list for grub or have the drivers built in to use the kernel"
	ewarn "with the crypt_root_plain USE flag."
	ewarn

	ewarn
	ewarn "The identifiers in /dev/disk/by-id/ have changed between genkernel 4.2.x"
	ewarn "and this version.  Please update the kernel parameters provided to for"
	ewarn "grub when switching between the two versions.  Go to shell mode and"
	ewarn "\`ls /dev/disk/by-id\`.  Then, take a photo of the changes and manually"
	ewarn "edit grub."
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
	ewarn "can be found in genkernel-4.0.10-llvm-support-v3.patch.  Either fork the"
	ewarn "ebuild, supply a user patch, or send the option as an issue request for"
	ewarn "review."
	ewarn

	einfo
	einfo "The --clang, --llvm, --clang-kernel, ---llvm-kernel do not imply"
	einfo "--lto.  You must add --lto if you want to automatically"
	einfo "configure and build with the lto and llvm."
	einfo

	ewarn
	ewarn "The current crypt_root_plain will be deprecated for security reasons."
	ewarn "It will be announced later when the replacement is ready and require"
	ewarn "upgrading."
	ewarn

	ewarn
	ewarn "For proper mdev and /dev/disk/{by-id,by-uuid,...} support the"
	ewarn "following changes should be made so that it is built-in the"
	ewarn "kernel and not as a module in the kernel config:"
	ewarn
	ewarn "  CONFIG_NET=y"
	ewarn "  CONFIG_UNIX=y"
	ewarn
}

# OILEDMACHINE-OVERLAY-META:  LEGAL-PROTECTIONS
# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  ebuild, pgo, lto, patch-additions
