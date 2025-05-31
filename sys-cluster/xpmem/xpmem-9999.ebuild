# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

# U18, U22, U24

BUILD_PARAMS="KDIR=${KERNEL_DIR}"
BUILD_TARGETS="all"
DKMS_MODULES=(
	"xpmem kernel /kernel/../updates/"
)
FLAG_O_MATIC_STRIP_UNSUPPORTED_FLAGS=1
MODULE_NAMES="knem(misc:${S}/driver/linux)"

inherit autotools check-compiler-switch flag-o-matic linux-mod linux-info toolchain-funcs udev

if [[ ${PV} =~ "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/openucx/xpmem.git"
	inherit git-r3
else
	KEYWORDS="~amd64"
	SRC_URI="
https://github.com/openucx/xpmem/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="XPMEM is a Linux kernel module that enables a process to map the \
memory of another process into its virtual address space."
HOMEPAGE="
	https://github.com/openucx/xpmem
"
LICENSE="
	all-rights-reserved
	BSD
	LGPL-2
	GPL-2
"
# all-rights-reserved GPL-2 - kernel/xpmem_attach.c
# BSD - NEWS.  The LICENSE file is likely from the ucx project but missing from xpmem project.
# BSD - test/gtest/common/googletest/src/gtest-all.cc
# The distro's GPL-2 license template does not contain all rights reserved.
SLOT="0"
IUSE="
compress debug modules sign-modules
ebuild_revision_2
"
RDEPEND="
	sys-apps/kmod[tools]
	virtual/udev
"
DEPEND="
	virtual/linux-sources
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
	if grep -q "vendor_id.*AuthenticAMD" "/proc/cpuinfo" ; then
einfo "Detected AMD CPU.  Displaying results for the MMU_NOTIFIER requirement."
		CONFIG_CHECK="
			~PCI
			~ACPI
			~AMD_IOMMU
			~AMD_IOMMU_V2
		"
		WARNING_PCI="CONFIG_PCI is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_ACPI="CONFIG_ACPI is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_PCI="CONFIG_PCI is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_ACPI="CONFIG_ACPI is needed by the xpmem module for MMU_NOTIFIER."
		check_extra_config
	elif grep -q "vendor_id.*GenuineIntel" "/proc/cpuinfo" ; then
einfo "Detected Intel CPU.  Displaying results for the MMU_NOTIFIER requirement."
		CONFIG_CHECK="
			~PCI
			~ACPI
			~PCI_MSI
			~INTEL_IOMMU
			~INTEL_IOMMU_SVM
		"
		WARNING_PCI="CONFIG_PCI is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_ACPI="CONFIG_ACPI is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_PCI_MSI="CONFIG_PCI_MSI is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_INTEL_IOMMU="CONFIG_INTEL_IOMMU is needed by the xpmem module for MMU_NOTIFIER."
		WARNING_INTEL_IOMMU_SVM="CONFIG_INTEL_IOMMU_SVM is needed by the xpmem module for MMU_NOTIFIER."
		check_extra_config
	else
ewarn "TODO:  Document MMU_NOTIFIER enablement on ARCH=${ARCH}"
	fi

	CONFIG_CHECK="
		~MMU_NOTIFIER
		~MODULES
		~DEVTMPFS
		~PROC_FS
		~!TRIM_UNUSED_KSYMS
	"
	WARNING_MMU_NOTIFIER="CONFIG_MMU_NOTIFIER is needed by the xpmem module."
	WARNING_MODULES="CONFIG_MODULES is needed to load the xpmem module."
	#WARNING_MULTIUSER="CONFIG_MULTIUSER is needed for xpmem user"
	WARNING_DEVTMPFS="CONFIG_DEVTMPFS is needed for /dev support"
	WARNING_PROC_FS="CONFIG_PROC_FS is needed for /proc support"
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
			rm -f "${built_name}.ko"{".gz",".xz",".zst"}
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
	check-compiler-switch_start
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

	if [[ -e "${KERNEL_DIR}/.config" ]] ; then
		export CC=$(grep -E -e "CONFIG_CC_VERSION_TEXT" "${KERNEL_DIR}/.config" \
			| cut -f 1 -d " " \
			| cut -f 2 -d "=" \
			| sed -e "s/[\"|']//g")
		export CPP="${CC} -E"
einfo "PATH (before):  ${PATH}"
		if tc-is-gcc ; then
			local slot=$(gcc-major-version)
			local path="/usr/${CHOST}/gcc-bin/${slot}"
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -e "\|/usr/lib/llvm/|d" \
				| sed -e "\|/usr/${CHOST}/gcc-bin/|d" \
				| sed -e "s|/usr/local/sbin|${path}\n/usr/local/sbin|g" \
				| tr "\n" ":")
		else
			local slot=$(clang-major-version)
			local path="/usr/lib/llvm/${slot}/bin"
			export PATH=$(echo "${PATH}" \
				| tr ":" "\n" \
				| sed -e "\|/usr/lib/llvm/|d" \
				| sed -e "\|/usr/${CHOST}/gcc-bin/|d" \
				| sed -e "s|/usr/local/sbin|${path}\n/usr/local/sbin|g" \
				| tr "\n" ":")
		fi
einfo "PATH (after):  ${PATH}"
		strip-unsupported-flags
einfo "CC: ${CC}"
	fi

	local myconf=(
		--disable-silent-rules
		--with-kerneldir="${KERNEL_DIR}"
	)
	econf ${myconf[@]}
}

src_compile() {
	default
	if use modules ; then
		cd "${S}" || die
		linux-mod_src_compile || die "Failed to build driver"
	fi
}

src_install() {
	default
	if use modules ; then
		cd "${S}" || die
		linux-mod_src_install || die "Failed to install driver"
		use sign-modules && signing_modules "${KERNEL_DIR_SUFFIX}"
		use compress && _compress_modules "/lib/modules/${KERNEL_RELEASE}"
	fi
	udev_dorules "${S}/56-xpmem.rules"
	rm -rf \
		"${ED}/etc/.version" \
		"${ED}/etc/init.d"
}

# Update module dependencies
_pkg_postinst_one() {
	local k="${1}"
	KERNEL_DIR="/usr/src/linux-${k}"
	KV_FULL=$(cat "${KERNEL_DIR}/include/config/kernel.release")
	linux-mod-r1_pkg_postinst
}

pkg_postinst() {
	_pkg_postinst_one "${KERNEL_DIR_SUFFIX}"
	udev_reload
}

pkg_postrm() {
	udev_reload
}
