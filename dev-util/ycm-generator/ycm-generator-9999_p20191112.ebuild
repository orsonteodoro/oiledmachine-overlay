# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 git-r3

DESCRIPTION="Generates config files for YouCompleteMe"
HOMEPAGE="https://github.com/rdnetto/YCM-Generator"

# Live ebuilds don't get KEYWORDed

LICENSE="
	GPL-3
	Unlicense
	test? (
		GPL-2+
		make? (
			GPL-2+
			kbuild? (
				GPL-2
				(
					Linux-syscall-note
					LGPL-2+
				)
				(
					all-rights-reserved
					BSD
					|| (
						BSD
						GPL-2
					)
				)
				(
					all-rights-reserved
					MIT
					|| (
						GPL-2
						MIT
					)
				)
				(
					custom
					GPL-2+
				)
				0BSD
				Apache-2.0
				all-rights-reserved
				BSD
				BSD-2
				Clear-BSD
				ISC
				LGPL-2.1
				MIT
				Prior-BSD-License
				unicode
				Unlicense
				ZLIB
				|| (
					BSD
					GPL-2
				)
				|| (
					GPL-2
					MIT
				)
				|| (
					BSD-2
					GPL-2
				)
			)
		)
		meson? (
			GPL-3+
			LGPL-2.1+
		)
		qmake? (
			GPL-3
		)
		wmake? (
			GPL-3+
		)
	)
"
# GPL-2+ - vim-qt
# GPL-2 BSD MIT ... - kernel, see also https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/ot-kernel.eclass#L117
# GPL-3 - ExtPlane
# GPL-3+ - openfoam
# GPL-3+ LGPL-2.1+ - nautilus
SLOT="0"
IUSE+="
+cmake +make kbuild +meson +qmake +wmake test

qt5 qt6 r4
"
REQUIRED_USE+="
	cmake? (
		test? (
			^^ (
				qt5
				qt6
			)
		)
	)
"
RDEPEND+="
	sys-devel/clang
	cmake? (
		dev-util/cmake
	)
	make? (
		sys-devel/make
	)
	meson? (
		dev-util/meson
		dev-util/ninja
	)
	qmake? (
		|| (
			qt6? (
				dev-qt/qtbase:6
			)
			qt5? (
				dev-qt/qtcore:5
			)
		)
	)
"
CDEPEND+="
	dev-python/future[${PYTHON_USEDEP}]
"
RDEPEND+="
	${CDEPEND}
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	${CDEPEND}
	test? (
		cmake? (
			|| (
				qt5? (
					dev-qt/qtcore:5
					dev-qt/qtmultimedia:5
					dev-qt/qtsvg:5
					dev-qt/qtwidgets:5
				)
				qt6? (
					dev-qt/qtbase:6[widgets]
					dev-qt/qtmultimedia:6
					dev-qt/qtsvg:6
				)
			)
			dev-vcs/git
		)
		meson? (
			>=app-arch/gnome-autoar-0.4.4
			>=app-misc/tracker-3.0
			>=dev-libs/glib-2.72.0:2
			>=dev-libs/libportal-0.5[gtk]
			>=dev-libs/libxml2-2.7.8
			>=gnome-base/gnome-desktop-43
			>=gui-libs/libadwaita-1.3.0
			>=media-libs/gexiv2-0.14.0
			>=net-libs/libcloudproviders-0.3.1
			>=x11-libs/gdk-pixbuf-2.30.0
			dev-util/cmake
			gui-libs/gtk:4
			media-libs/gstreamer:1.0
			media-libs/gst-plugins-base:1.0
			virtual/pkgconfig
		)
	)
"
EGIT_COMMIT="7c0f5701130f4178cb63d10da88578b9b705fbb1"
EXTPLANE_DIGEST="a1428feb9916d6acad8d"
LIBREMINES_PV="1.10.0"
LINUX_PV="6.1"
NAUTILUS_PV="44.2.1"
OPENFOAM_PV="3.0.1"
VIM_QT_PV="20170421"
SRC_URI="
https://github.com/rdnetto/YCM-Generator/archive/${EGIT_COMMIT}.tar.gz
	-> ${P}.tar.gz
https://github.com/PaulHaeger/YCM-Generator/commit/b5015162c2a2da45c7f24954716ad1211110f532.patch
	-> ycm-generator-b501516-fix-str-lt-comparison.patch
https://github.com/rdnetto/YCM-Generator/pull/103.patch
	-> ycm-generator-pr103-meson-ninja-support.patch
test? (
	make? (
		kbuild? (
https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1 ${LINUX_PV}).x/linux-${LINUX_PV}.tar.xz
		)
https://github.com/equalsraf/vim-qt/archive/${VIM_QT_PV}.tar.gz
	-> vim-qt-${VIM_QT_PV}.tar.gz
	)
	cmake? (
https://github.com/Bollos00/LibreMines/archive/refs/tags/v${LIBREMINES_PV}.tar.gz
	-> libremines-${LIBREMINES_PV}.tar.gz
	)
	meson? (
https://gitlab.gnome.org/GNOME/nautilus/-/archive/${NAUTILUS_PV}/nautilus-${NAUTILUS_PV}.tar.bz2
	)
	qmake? (
https://github.com/vranki/ExtPlane/archive/refs/tags/untagged-${EXTPLANE_DIGEST}.tar.gz
	-> extplane-${EXTPLANE_DIGEST}.tar.gz
	)
	wmake? (
https://github.com/OpenFOAM/OpenFOAM-$(ver_cut 1-2 ${OPENFOAM_PV}).x/archive/refs/tags/version-${OPENFOAM_PV}.tar.gz
	-> openfoam-3.0.1.tar.gz
	)
)
"
S="${WORKDIR}/YCM-Generator-${EGIT_COMMIT}"
RESTRICT="mirror"

src_unpack() {
	unpack ${P}.tar.gz
	if use test ; then
		if use cmake ; then
			unpack libremines-${LIBREMINES_PV}.tar.gz
		fi
		if use qmake ; then
			unpack extplane-${EXTPLANE_DIGEST}.tar.gz
		fi
		if use make ; then
			use kbuild && unpack linux-${LINUX_PV}.tar.xz
			unpack vim-qt-${VIM_QT_PV}.tar.gz
		fi
		if use meson ; then
			unpack nautilus-${NAUTILUS_PV}.tar.bz2
		fi
		if use wmake ; then
			unpack openfoam-${OPENFOAM_PV}.tar.gz
		fi
	fi
}

src_prepare() {
	ewarn "This package has reached End Of Life (EOL)"
	default
	futurize -0 -v -w "${S}" || die
	sed -i \
		-e "s|#!/usr/bin/env python2|#!/usr/bin/env python|" \
		config_gen.py || die
	eapply "${FILESDIR}/ycm-generator-9999_p20191112-r3-py3-fixes.patch"
	eapply "${FILESDIR}/ycm-generator-9999_p20191112-r3-qt6.patch"
	eapply "${DISTDIR}/ycm-generator-b501516-fix-str-lt-comparison.patch"
	eapply "${DISTDIR}/ycm-generator-pr103-meson-ninja-support.patch"
	eapply "${FILESDIR}/ycm-generator-9999_p20191112-r3-meson-configure-opts.patch"
	eapply "${FILESDIR}/ycm-generator-9999_p20191112-r3-cmake-makefiles.patch"
	eapply "${FILESDIR}/ycm-generator-9999_p20191112-fix-kbuild-version-check.patch"
	python_copy_sources
}

src_compile() {
	:;
}

test_autotools() {
ewarn "The autotools test will infinite loop.  Do not use at this time."
	use make || return
	einfo "Testing autotools"
	#tinfo ncurses termlib termcap curses
#		--configure_opts="--with-tlib=termcap" \
	config_gen.py \
		"${WORKDIR}/vim-qt-package-${VIM_QT_PV}" \
		--verbose \
		-o .ycm_extra_conf-autotools.py \
		|| die
	grep -q \
		-e "Generated by YCM Generator" \
		.ycm_extra_conf-autotools.py \
		|| die
}

test_cmake() {
	use cmake || return
	local qtarg=""
	if use qt6 ; then
		qtarg="-DUSE_QT6=ON"
	elif use qt5 ; then
		qtarg="-DUSE_QT6=OFF"
	else
einfo "Skipping cmake test"
		return
	fi
	cmake --help
	einfo "Testing cmake with make"
	config_gen.py \
		"${WORKDIR}/LibreMines-${LIBREMINES_PV}" \
		--verbose \
		--configure_opts=" -G \"Unix Makefiles\" ${qtarg}" \
		-o .ycm_extra_conf-cmake.py \
		|| die
	grep -q \
		-e "Generated by YCM Generator" \
		.ycm_extra_conf-cmake.py \
		|| die

	einfo "Testing cmake with ninja"
	rm -f .ycm_extra_conf-cmake.py
	config_gen.py \
		"${WORKDIR}/LibreMines-${LIBREMINES_PV}" \
		--verbose \
		--configure_opts="${qtarg}" \
		-o .ycm_extra_conf-cmake.py \
		|| die
	grep -q \
		-e "Generated by YCM Generator" \
		.ycm_extra_conf-cmake.py \
		|| die
}

get_karch() {
	if use alpha ; then
		echo "alpha"
	elif use amd64 ; then
		echo "x86"
	elif use arm64 ; then
		echo "arm64"
	elif use arm ; then
		echo "arm"
	elif use ia64 ; then
		echo "ia64"
	elif use loong ; then
		echo "loongarch"
	elif use mips ; then
		echo "mips"
	elif use ppc64 ; then
		echo "powerpc"
	elif use ppc ; then
		echo "powerpc"
	elif use s390 ; then
		echo "s390"
	elif use sparc ; then
		echo "sparc"
	elif use riscv ; then
		echo "riscv"
	fi
}

test_kbuild() {
	use make || return
	use kbuild || return
	einfo "Testing kbuild"
	pushd "${WORKDIR}/linux-${LINUX_PV}" || die
		ARCH="$(get_karch)" \
		make V=1 defconfig || die
	popd || die
	ARCH="$(get_karch)" \
	config_gen.py \
		"${WORKDIR}/linux-${LINUX_PV}" \
		--verbose \
		-e \
		-o .ycm_extra_conf-kbuild.py \
		|| die
	grep -q \
		-e "Generated by YCM Generator" \
		.ycm_extra_conf-kbuild.py \
		|| die
}

test_meson() {
	use meson || return
	einfo "Testing meson"
	config_gen.py \
		"${WORKDIR}/nautilus-${NAUTILUS_PV}" \
		--verbose \
		--configure_opts="-Dtests=none" \
		-e \
		-o .ycm_extra_conf-meson.py \
		|| die
	grep -q \
		-e "Generated by YCM Generator" \
		.ycm_extra_conf-meson.py \
		|| die
}

test_qmake() {
	use qmake || return
	einfo "Testing Qmake"
	config_gen.py \
		"${WORKDIR}/ExtPlane-untagged-${EXTPLANE_DIGEST}" \
		--verbose \
		-o .ycm_extra_conf-qmake.py \
		|| die
	grep -q \
		-e "Generated by YCM Generator" \
		.ycm_extra_conf-qmake.py \
		|| die
}

test_wmake() {
	use wmake || return
	einfo "Testing wmake"
	export PATH="${WORKDIR}/OpenFOAM-$(ver_cut 1-2 ${OPENFOAM_PV}).x-version-${OPENFOAM_PV}/wmake:${PATH}"

	if use amd64 ; then
		export WM_ARCH="linux64"
	elif use x86 ; then
		export WM_ARCH="linux"
	fi
	export WM_CC="gcc"
	export WM_COMPILE_OPTION="Opt"
	export WM_COMPILER="Gcc"
	export WM_CXX="g++"
	export WM_LABEL_SIZE="32"
	export WM_LABEL_OPTION="Int${WM_LABEL_SIZE}"
	export WM_LINK_LANGUAGE="c++"
	export WM_PRECISION_OPTION="DP"
	if use amd64 ; then
		export WM_ARCH_OPTION="64"
	elif use x86 ; then
		export WM_ARCH_OPTION="32"
	else
eerror "ARCH not supported for wmake"
		die
	fi

	export WM_PROJECT_DIR="${WORKDIR}/OpenFOAM-$(ver_cut 1-2 ${OPENFOAM_PV}).x-version-${OPENFOAM_PV}"
	export WM_DIR="${WM_PROJECT_DIR}/wmake"
	export WM_OPTIONS="${WM_ARCH}${WM_COMPILER}${WM_PRECISION_OPTION}${WM_LABEL_OPTION}${WM_COMPILE_OPTION}"
	export WM_PROJECT="OpenFOAM"

	# Selective only.  We can only evaluate per subfolder not starting at project root build file.
	local L=(
		$(find "${WM_PROJECT_DIR}" -path "*/Make/options" \
			| grep "/src/")
	)
	local p
	for p in ${L[@]} ; do
		local len=$(echo "${p}" | tr "/" "\n" | wc -l)
		len=$((${len} - 2))
		rm -f .ycm_extra_conf-wmake.py
		local subproject_path=$(echo "${p}" \
			| cut -f 1-${len} -d "/")
einfo "Processing ${subproject_path}"
		config_gen.py \
			"${subproject_path}" \
			--verbose \
			-e \
			-o .ycm_extra_conf-wmake.py \
			|| die
		grep -q \
			-e "Generated by YCM Generator" \
			.ycm_extra_conf-wmake.py \
			|| die
	done
}

src_test() {
	if use qt6 ; then
		PATH="/usr/lib64/qt6/bin:${PATH}"
	elif use qt5 ; then
		PATH="/usr/lib64/qt5/bin:${PATH}"
	fi
	PATH="${S}:${PATH}"

#	test_autotools # Still infinite loop during configure
	test_cmake
	test_qmake
	test_kbuild # Broken for 6.1 kernel
	test_meson
	test_wmake
}

src_install() {
	python_install_impl() {
		python_moduleinto "${PN}"
		python_domodule *.py fake-toolchain plugin
		fperms 0755 \
		"$(python_get_sitedir)/${PN}/fake-toolchain/Unix"/{cc,cxx,true} \
		"$(python_get_sitedir)/${PN}/config_gen.py"
		dodir "/usr/lib/python-exec/${EPYTHON}"
		dosym "$(python_get_sitedir)/${PN}/config_gen.py" \
			"/usr/lib/python-exec/${EPYTHON}/config_gen.py"
	}
	python_foreach_impl python_install_impl
	dosym "/usr/lib/python-exec/python-exec2" \
		"/usr/bin/config_gen.py"
}

# OILEDMACHINE-OVERLAY-TEST:  FAIL (custom tests) (20230627)
# cmake + ninja - passed
# cmake + make - passed
# make + autotools - failed
# make + kbuild - passed
# meson - maybe no.  failed to finish project to the end.  passed generating a .ycm_extra_conf-meson.py
# qmake - passed
# wmake - passed
