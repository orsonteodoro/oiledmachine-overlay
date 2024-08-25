# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

BUILD_PARAMS="KDIR=${KERNEL_DIR}"
BUILD_TARGETS="all"
MODULE_NAMES="knem(misc:${S}/driver/linux)"

inherit autotools linux-mod linux-info toolchain-funcs udev

if [[ ${PV} =~ "9999" ]] ; then
	EGIT_REPO_URI="https://gforge.inria.fr/git/knem/knem.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~riscv ~x86"
	SRC_URI="https://gitlab.inria.fr/knem/knem/uploads/4a43e3eb860cda2bbd5bf5c7c04a24b6/${P}.tar.gz"
fi

DESCRIPTION="High-Performance Intra-Node MPI Communication"
HOMEPAGE="https://knem.gforge.inria.fr/"
LICENSE="
	all-rights-reserved
	BSD
	LGPL-2
	GPL-2
"
# all-rights-reserved - driver/linux/knem_hal.h
SLOT="0"
IUSE="
compress debug modules sign-modules
ebuild-revision-1
"
DEPEND="
	sys-apps/hwloc:=
	virtual/linux-sources
"
RDEPEND="
	sys-apps/hwloc:=
	sys-apps/kmod[tools]
"

check_udev() {
	CONFIG_CHECK="
		~BLOCK
		~NET
		~UNIX
		~PROC_FS
		~SYSFS
		~!IDE
		~BLK_DEV_BSG
		~DEVTMPFS
		~INOTIFY_USER
		~!SYSFS_DEPRECATED
		~!SYSFS_DEPRECATED_V2
		~SIGNALFD
		~EPOLL
		~FHANDLE
		~NET
		~!FW_LOADER_USER_HELPER
	"
	WARNING_BLOCK="CONFIG_BLOCK is needed for udev support."
	WARNING_NET="CONFIG_NET is needed for udev support."
	WARNING_UNIX="CONFIG_UNIX is needed for udev support."
	WARNING_PROC_FS="CONFIG_PROC_FS is needed for udev support."
	WARNING_SYSFS="CONFIG_SYSFS is needed for udev support."
	WARNING_IDE="CONFIG_IDE should be disabled for udev support."
	WARNING_BLK_DEV_BSG="CONFIG_BLK_DEV_BSG is needed for udev support."
	WARNING_DEVTMPFS="CONFIG_DEVTMPFS is needed for udev support."
	WARNING_INOTIFY_USER="CONFIG_INOTIFY_USER is needed for udev support."
	WARNING_SYSFS_DEPRECATED="CONFIG_SYSFS_DEPRECATED should be disabled for udev support."
	WARNING_SYSFS_DEPRECATED_V2="CONFIG_SYSFS_DEPRECATED_V2 should be disabled for udev support."
	WARNING_SIGNALFD="CONFIG_SIGNALFD is needed for udev support."
	WARNING_EPOLL="CONFIG_EPOLL is needed for udev support."
	WARNING_FHANDLE="CONFIG_FHANDLE is needed for udev support."
	WARNING_NET="CONFIG_NET is needed for udev support."
	WARNING_FW_LOADER_USER_HELPER="CONFIG_FW_LOADER_USER_HELPER should be disabled for udev support."
	check_extra_config
}

check_module() {
	CONFIG_CHECK="
		~DMA_ENGINE
		~MODULES
		~MULTIUSER
		~DEVTMPFS
		~PROC_FS
		~!TRIM_UNUSED_KSYMS
	"
	WARNING_MODULES="CONFIG_MODULES is needed to load the knem module."
	WARNING_MULTIUSER="CONFIG_MULTIUSER is needed for the rdma group."
	WARNING_DEVTMPFS="CONFIG_DEVTMPFS is needed for /dev support."
	WARNING_PROC_FS="CONFIG_PROC_FS is needed for /proc support."
	WARNING_TRIM_UNUSED_KSYMS="CONFIG_TRIM_UNUSED_KSYMS should be disabled for external modules support."
	check_extra_config
}

check_sign_module() {
	if use sign-modules ; then
		CONFIG_CHECK="
			~MODULE_SIG
			~MODULE_SIG_FORCE
		"
	fi
	WARNING_MODULE_SIG="CONFIG_MODULE_SIG is needed for module signature support."
	WARNING_MODULE_SIG_FORCE="CONFIG_MODULE_SIG_FORCE is needed for module signature support in production."
	check_extra_config
}

sign_module() {
	local module_path="${1}"
	einfo "Signing $(basename ${module_path})"
	/usr/src/linux-${k}/scripts/sign-file \
		"${module_sig_hash}" \
		"${key_path}" \
		"${cert_path}" \
		"${module_path}" \
		|| die
}

signing_modules() {
	local k="${1}" # ${kv}-${extraversion}
	KERNEL_DIR="/usr/src/linux-${k}"
	get_version
	linux_config_exists
	if linux_chkconfig_builtin "MODULE_SIG" && use sign-modules ; then
		local kernel_path="/usr/src/linux-${k}"
		local kernel_release=$(cat "${kernel_path}/include/config/kernel.release") # ${PV}-${EXTRAVERSION}-${ARCH}
		local modules_path="/lib/modules/${kernel_release}"
		local module_sig_hash=$(grep \
			-Po '(?<=CONFIG_MODULE_SIG_HASH=").*(?=")' \
			"${kernel_path}/.config")
		local module_sig_key=$(grep \
			-Po '(?<=CONFIG_MODULE_SIG_KEY=").*(?=")' \
			"${kernel_path}/.config")
		module_sig_key="${module_sig_key:-certs/signing_key.pem}"
		if [[ "${module_sig_key#pkcs11:}" == "${module_sig_key}" \
			&& "${module_sig_key#/}" == "${module_sig_key}" ]]; then
			local key_path="${kernel_path}/${module_sig_key}"
		else
			local key_path="${module_sig_key}"
		fi
		local cert_path="${kernel_path}/certs/signing_key.x509"

		# If you get No such file or directory:  crypto/bio/bss_file.c,
		# This means that the kernel module location changed.  Set below
		# paths in amd/dkms/dkms.conf.

		IFS=$'\n'
		local x
		for x in ${DKMS_MODULES[@]} ; do
			local built_name=$(echo "${x}" | cut -f 1 -d " ")
			local built_location=$(echo "${x}" | cut -f 2 -d " ")
			local dest_location=$(echo "${x}" | cut -f 3 -d " ")
			sign_module \
				"${modules_path}${dest_location}/${built_name}.ko" \
				|| die
		done
		IFS=$' \t\n'
	fi
}

_compress_modules() {
	use compress || return
	IFS=$'\n'
	local x
	local modules_path="${1}"
	for x in ${DKMS_MODULES[@]} ; do
		local built_name=$(echo "${x}" | cut -f 1 -d " ")
		local built_location=$(echo "${x}" | cut -f 2 -d " ")
		local dest_location=$(echo "${x}" | cut -f 3 -d " ")
		pushd "${modules_path}${dest_location}" || die
			rm -f "${built_name}.ko"{.gz,.xz,.zst}
			if linux_chkconfig_present "MODULE_COMPRESS_ZSTD" && has_version "sys-apps/kmod[zstd]" && has_version "app-arch/zstd" ; then
				# .ko.zst
				zstd -T0 --rm -f -q "${built_name}.ko"
			elif linux_chkconfig_present "MODULE_COMPRESS_XZ" && has_version "sys-apps/kmod[lzma]" && has_version "app-arch/xz-utils" ; then
				# .ko.xz
				xz --lzma2=dict=2MiB -f "${built_name}.ko"
			elif linux_chkconfig_present "MODULE_COMPRESS_GZIP" && has_version "sys-apps/kmod[zlib]" && has_version "app-arch/gzip" ; then
				# .ko.gz
				gzip -n -f "${built_name}.ko"
			fi
		popd
	done
	IFS=$' \t\n'
}

pkg_setup() {
	linux-info_pkg_setup
	check_module
	check_sign_module
	check_udev

	einfo "KERNEL_DIR:  ${KERNEL_DIR}"
	einfo "KERNEL_VERSION:  ${KV_MAJOR}.${KV_MINOR}.${KV_PATCH}${KV_EXTRA}"

	linux-mod_pkg_setup
	ARCH="$(tc-arch-kernel)"
	ABI="${KERNEL_ABI}"
}

src_prepare() {
	sed 's:driver/linux::g' -i "Makefile.am" || die
	eautoreconf
	default
}

src_configure() {
	local f="${KERNEL_DIR}/include/config/kernel.release"
	if [[ -e "${f}" ]] ; then
		export KERNEL_RELEASE=$(cat "${f}")
		local KERNEL_DIR_SUFFIX=$(echo "${KERNEL_RELEASE}" | cut -f 1-2 -d "-")
einfo "KERNEL_RELEASE:  ${KERNEL_RELEASE}"
einfo "KERNEL_DIR_SUFFIX:  ${KERNEL_DIR_SUFFIX}"
	fi
	local myconf=(
		$(use_enable debug)
		--enable-hwloc
		--with-linux="${KERNEL_DIR}"
		--with-linux-release=${KV_FULL}
	)
	econf ${myconf[@]}
}

src_compile() {
	default
	if use modules; then
		cd "${S}/driver/linux"
		linux-mod_src_compile || die "failed to build driver"
	fi
}

src_install() {
	default
	if use modules; then
		cd "${S}/driver/linux"
		linux-mod_src_install || die "failed to install driver"
		use sign-modules && signing_modules "${KERNEL_DIR_SUFFIX}"
		use compress && _compress_modules "/lib/modules/${KERNEL_RELEASE}"
	fi
	# Drop funny unneded stuff \
	rm "${ED}/usr/sbin/knem_local_install" || die
	rmdir "${ED}/usr/sbin" || die
	udev_dorules "${FILESDIR}/45-knem.rules"
	rm "${ED}/etc/10-knem.rules" || die
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
