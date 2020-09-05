# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Dynamic kernel patching for Linux"
HOMEPAGE="https://github.com/dynup/kpatch"
LICENSE="GPL-2+"
KEYWORDS="~amd64"
SLOT="0"
IUSE="contrib debug kmod +kpatch +kpatch-build test"
RESTRICT="!test? ( test )"
RDEPEND="app-crypt/pesign
	 sys-apps/pciutils
	 sys-libs/zlib"
DEPEND="${RDEPEND}
	dev-libs/elfutils
	sys-devel/bison
	test? ( dev-util/shellcheck-bin )"
inherit flag-o-matic linux-mod
SRC_URI=\
"https://github.com/dynup/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
PATCHES=( "${FILESDIR}/kpatch-0.9.1-use-sandboxed-patchtesting-v1.5.patch"
	  "${FILESDIR}/kpatch-0.9.1-ERROR-to-WARNING-message.patch"
	  "${FILESDIR}/kpatch-0.9.1-skip-tmp-o-for-kpatch-gcc.patch" )

pkg_setup() {
	if use kpatch-build ; then
# See kpatch-build/kpatch-build
		CONFIG_CHECK=\
"!GCC_PLUGIN_LATENT_ENTROPY !GCC_PLUGIN_RANDSTRUCT !DEBUG_INFO_SPLIT"
		ERROR_DEBUG_INFO_SPLIT=\
"CONFIG_DEBUG_INFO_SPLIT must be disabled in the kernel's config file."
		ERROR_GCC_PLUGIN_LATENT_ENTROPY=\
"CONFIG_GCC_PLUGIN_LATENT_ENTROPY must be disabled in the kernel's config file."
		ERROR_GCC_PLUGIN_RANDSTRUCT=\
"CONFIG_GCC_PLUGIN_RANDSTRUCT must be disabled in the kernel's config file."
		check_extra_config
	fi
	if use kmod ; then
		if kernel_is gt 3 9 0; then
			if ! linux_config_exists; then
eerror "Unable to check the currently running kernel for kpatch support"
eerror "Please be sure a .config file is available in the kernel src dir"
eerror "and ensure the kernel has been built."
			else
# Fail to build if these kernel options are not enabled
# (see kmod/core/core.c)
				CONFIG_CHECK=\
"FUNCTION_TRACER HAVE_FENTRY KALLSYMS_ALL MODULES SYSFS STACKTRACE"
				ERROR_FUNCTION_TRACER=\
"CONFIG_FUNCTION_TRACER must be enabled in the kernel's config file"
				ERROR_HAVE_FENTRY=\
"CONFIG_HAVE_FENTRY must be enabled in the kernel's config file"
				ERROR_KALLSYMS_ALL=\
"CONFIG_KALLSYMS_ALL must be enabled in the kernel's config file"
				ERROR_MODULES=\
"CONFIG_MODULES must be enabled in the kernel's config file"
				ERROR_STACKTRACE=\
"CONFIG_STACKTRACE must be enabled in the kernel's config file"
				ERROR_SYSFS=\
"CONFIG_SYSFS must be enabled in the kernel's config file"
			fi
		else
			eerror
			eerror \
"kpatch is not available for Linux kernels below 4.0.0"
			eerror
			die \
"Upgrade the kernel sources before installing kpatch."
		fi
		check_extra_config
	fi
# See https://github.com/torvalds/linux/blob/master/kernel/livepatch/Kconfig
	# Requirements for live patch
	CONFIG_CHECK=\
"DYNAMIC_FTRACE_WITH_REGS KALLSYMS_ALL LIVEPATCH MODULES SYSFS !TRIM_UNUSED_KSYMS"
	ERROR_DYNAMIC_FTRACE_WITH_REGS=\
"CONFIG_DYNAMIC_FTRACE_WITH_REGS must be enabled in the kernel's config file"
	ERROR_KALLSYMS_ALL=\
"CONFIG_KALLSYMS_ALL must be enabled in the kernel's config file"
	ERROR_LIVEPATCH=\
"CONFIG_LIVEPATCH must be enabled in the kernel's config file"
	ERROR_MODULES=\
"CONFIG_MODULES must be enabled in the kernel's config file"
	ERROR_SYSFS=\
"CONFIG_SYSFS must be enabled in the kernel's config file"
	ERROR_UNUSED_KSYMS=\
"CONFIG_TRIM_UNUSED_KSYMS must be disabled in the kernel's config file"
	check_extra_config
}

src_prepare() {
	if use debug ; then
		replace-flags '-O?' '-O1'
		replace-flags '-Ofast' '-O1'
		filter-flags -fomit-frame-pointer
	else
		replace-flags '-O?' '-Og'
		replace-flags '-Ofast' '-Og'
	fi
	default
}

src_compile() {
	use kpatch-build && emake -C kpatch-build
	use kpatch && emake -C kpatch
	use kmod && set_arch_to_kernel && emake -C kmod
	use contrib && emake -C contrib
	use test && emake check
}

src_install() {
	if use kpatch-build; then
		emake DESTDIR="${ED}" PREFIX="/usr" install -C kpatch-build
		insinto /usr/share/${PN}/patch
		doins kmod/patch/kpatch{.lds.S,-macros.h,-patch.h,-patch-hook.c}
		doins kmod/patch/{livepatch-patch-hook.c,Makefile,patch-hook.c}
		doins kmod/core/kpatch.h
		doman man/kpatch-build.1
	fi
	if use kpatch; then
		emake DESTDIR="${ED}" PREFIX="/usr" install -C kpatch
		doman man/kpatch.1
	fi
	use kmod && set_arch_to_kernel \
		&& emake DESTDIR="${ED}" PREFIX="/usr" install -C kmod
	use contrib && emake DESTDIR="${ED}" PREFIX="/usr" install -C contrib
	dodoc README.md doc/patch-author-guide.md
}
