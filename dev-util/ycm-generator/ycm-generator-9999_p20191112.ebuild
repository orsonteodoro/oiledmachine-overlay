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
						GPL-2
						BSD
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
					GPL-2
					BSD-2
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
			>=dev-libs/glib-2.72.0:2
			>=dev-libs/libxml2-2.7.8
			>=gnome-base/gnome-desktop-43
			>=gui-libs/libadwaita-1.3.0
			>=media-libs/gexiv2-0.14.0
			>=x11-libs/gdk-pixbuf-2.30.0
			dev-util/cmake
			gui-libs/gtk:4
			media-libs/gstreamer:1.0
			media-libs/gst-plugins-base:1.0
			virtual/pkgconfig
		)
	)
"
LIBREMINES_PV="1.10.0"
EGIT_COMMIT="7c0f5701130f4178cb63d10da88578b9b705fbb1"
EXTPLANE_DIGEST="a1428feb9916d6acad8d"
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
	python_copy_sources
}

src_compile() {
	:;
}

test_autotools() {
	use make || return
	einfo "Testing autotools"
	config_gen.py \
		"${WORKDIR}/vim-qt-package-${VIM_QT_PV}" \
		--verbose \
		-o .ycm_extra_conf-autotools.py \
		|| die
	local actual_autotools=$(cat .ycm_extra_conf-autotools.py \
		| sed -r -e "s|at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]+||g" \
		| sha1sum \
		| cut -f 1 -d " ")
	local expected_autotools=""
	if [[ "${actual_autotools}" != "${expected_autotools}" ]] ; then
eerror
eerror "Test result mismatch for autotools"
eerror
eerror "Expected fingerprint:  ${expected_autotools}"
eerror "Actual fingerprint:  ${actual_autotools}"
eerror
		die
	fi
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
	einfo "Testing cmake with ninja"
	rm -f .ycm_extra_conf-cmake.py
	config_gen.py \
		"${WORKDIR}/LibreMines-${LIBREMINES_PV}" \
		--verbose \
		--configure_opts="${qtarg}" \
		-o .ycm_extra_conf-cmake.py \
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
	local actual_kbuild=$(cat .ycm_extra_conf-kbuild.py \
		| sed -r -e "s|at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]+||g" \
		| sha1sum \
		| cut -f 1 -d " ")
	local expected_kbuild=""
	if [[ "${actual_kbuild}" != "${expected_kbuild}" ]] ; then
eerror
eerror "Test result mismatch for kbuild"
eerror
eerror "Expected fingerprint:  ${expected_kbuild}"
eerror "Actual fingerprint:  ${actual_kbuild}"
eerror
		die
	fi
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
	local actual_meson=$(cat .ycm_extra_conf-meson.py \
		| sed -r -e "s|at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]+||g" \
		| sha1sum \
		| cut -f 1 -d " ")
	local expected_meson=""
	if [[ "${actual_meson}" != "${expected_meson}" ]] ; then
eerror
eerror "Test result mismatch for meson"
eerror
eerror "Expected fingerprint:  ${expected_meson}"
eerror "Actual fingerprint:  ${actual_meson}"
eerror
		die
	fi
}

test_qmake() {
	use qmake || return
	if use qt6 ; then
		:;
	elif use qt5 ; then
		:;
	else
einfo "Skipping qmake test"
		return
	fi
	einfo "Testing Qmake"
	config_gen.py \
		"${WORKDIR}/ExtPlane-untagged-${EXTPLANE_DIGEST}" \
		--verbose \
		-o .ycm_extra_conf-qmake.py \
		|| die
	local actual_qmake=$(cat .ycm_extra_conf-qmake.py \
		| sed -r -e "s|at [0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}.[0-9]+||g" \
		| sha1sum \
		| cut -f 1 -d " ")
	local expected_qmake
	if use qt6 ; then
		expected_qmake="ea54dba2c8ecd8cb4165426ad866bfe7d4263294"
	elif use qt5 ; then
eerror "Incomplete:  Please report the fingerprint for qt5"
		expected_qmake="FIXME"
	fi
	if [[ "${actual_qmake}" != "${expected_qmake}" ]] ; then
eerror
eerror "Test result mismatch for qmake"
eerror
eerror "Expected fingerprint:  ${expected_qmake}"
eerror "Actual fingerprint:  ${actual_qmake}"
eerror
		die
	fi
}

test_wmake() {
	use wmake || return
	einfo "Testing wmake"
	export PATH="${WORKDIR}/OpenFOAM-$(ver_cut 1-2 ${OPENFOAM_PV}).x-version-${OPENFOAM_PV}/wmake:${PATH}"

#	if use amd64 ; then
#		export WM_ARCH="linux64"
#	elif use x86 ; then
#		export WM_ARCH="linux"
#	fi
#	export WM_CC="gcc"
#	export WM_COMPILE_OPTION="Opt"
#	export WM_COMPILER="Gcc"
#	export WM_CXX="g++"
#	export WM_LABEL_SIZE="32"
#	export WM_LABEL_OPTION="Int${WM_LABEL_SIZE}"
#	export WM_LINK_LANGUAGE="c++"
#	export WM_PRECISION_OPTION="DP"

	export WM_DIR="${WORKDIR}/OpenFOAM-$(ver_cut 1-2 ${OPENFOAM_PV}).x-version-${OPENFOAM_PV}/wmake"
#	export WM_OPTIONS="${WM_ARCH}${WM_COMPILER}${WM_PRECISION_OPTION}${WM_LABEL_OPTION}${WM_COMPILE_OPTION}"
#	export WM_PROJECT="OpenFOAM"
#	export WM_PROJECT_DIR="${WORKDIR}/OpenFOAM-$(ver_cut 1-2 ${OPENFOAM_PV}).x-version-${OPENFOAM_PV}"
#	mkdir -p "${WM_PROJECT_DIR}" || die

	"${WM_DIR}/etc/config/settings.sh"

	IFS=$'\n'
	local p
	for p in $(find "${WORKDIR}" -path "*/Make/options") ; do
einfo "Processing ${p}"
		[[ "${p}" =~ "/etc/" ]] && continue
		local len=$(echo "${p}" \
			| tr "/" "\n" \
			| wc -l)
		len=$((${len} - 2))
		rm -f .ycm_extra_conf-wmake.py
		config_gen.py \
			$(echo "${p}" | cut -f 1-${len} -d "/") \
			--verbose \
			-e \
			-o .ycm_extra_conf-wmake.py \
			|| die
	done
	IFS=$' \r\t'
}

src_test() {
	if has_version "dev-qt/qtbase" ; then
		PATH="/usr/lib64/qt6/bin:${PATH}"
	elif has_version "dev-qt/qtcore:5" ; then
		PATH="/usr/lib64/qt5/bin:${PATH}"
	fi
	PATH="${S}:${PATH}"

	test_qmake
	test_wmake # Broken
#	test_autotools # Infinite loop during configure
#	test_kbuild # Broken for 6.1 kernel
	test_meson
	test_cmake
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
