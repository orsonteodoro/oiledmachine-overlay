# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO: Split the "/usr/bin/shiboken2" binding generator from the
# "/usr/lib64/libshiboken2-*.so" family of shared libraries. The former
# requires everything (including Clang) at runtime; the latter only requires
# Qt and Python at runtime. Note that "pip" separates these two as well. See:
# https://doc.qt.io/qtforpython/shiboken2/faq.html#is-there-any-runtime-dependency-on-the-generated-binding
# Once split, the PySide2 ebuild should be revised to require
# "/usr/bin/shiboken2" at build time and "libshiboken2-*.so" at runtime.
# TODO: Add PyPy once officially supported. See also:
#     https://bugreports.qt.io/browse/PYSIDE-535
PYTHON_COMPAT=( python3_{8..11} )
LLVM_MAX_SLOT=16
LLVM_SLOTS=( 16 15 14 13 12 11 )

inherit cmake flag-o-matic llvm python-r1 toolchain-funcs

MY_P="pyside-setup-opensource-src-${PV}"
# Minimal supported version of Qt.
QT_PV="$(ver_cut 1-2)*:5"

DESCRIPTION="Python binding generator for C++ libraries"
HOMEPAGE="https://wiki.qt.io/PySide2"
SRC_URI="https://download.qt.io/official_releases/QtForPython/pyside2/PySide2-${PV%_*}-src/${MY_P/_p/-}.tar.xz"
# The "sources/shiboken2/libshiboken" directory is triple-licensed under the
# GPL v2, v3+, and LGPL v3. All remaining files are licensed under the GPL v3
# with version 1.0 of a Qt-specific exception enabling shiboken2 output to be
# arbitrarily relicensed. (TODO)
LICENSE="
	GPL-3
	|| (
		GPL-2
		GPL-3+
		LGPL-3
	)
"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="
+docstrings numpy test vulkan
${LLVM_SLOTS[@]/#/llvm-}
+llvm-16
"
# llvm-n should be the latest stable
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	^^ (
		${LLVM_SLOTS[@]/#/llvm-}
	)
"
# Since Clang is required at both build- and runtime, BDEPEND is omitted here.
RDEPEND="
	${PYTHON_DEPS}
	=dev-qt/qtcore-${QT_PV}
	docstrings? (
		>=dev-libs/libxml2-2.6.32
		>=dev-libs/libxslt-1.1.19
		=dev-qt/qtxml-${QT_PV}
		=dev-qt/qtxmlpatterns-${QT_PV}
	)
	numpy? (
		dev-python/numpy[${PYTHON_USEDEP}]
	)
	vulkan? (
		dev-util/vulkan-headers
	)
"
gen_llvm_rdepend() {
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		echo "
			llvm-${s}? (
				=sys-devel/clang-runtime-${s}*:=
				sys-devel/clang:${s}=
			)
		"
	done
}
RDEPEND+="
	$(gen_llvm_rdepend)
"
DEPEND="
	${RDEPEND}
	test? (
		=dev-qt/qttest-${QT_PV}
	)
"
BDEPEND="
	dev-util/patchelf
"
S="${WORKDIR}/pyside-setup-opensource-src-${PV%_*}/sources/shiboken2"
RESTRICT="test mirror"
PATCHES=(
	"${FILESDIR}/${PN}-5.15.5-python311-1.patch"
	"${FILESDIR}/${PN}-5.15.5-python311-2.patch"
	"${FILESDIR}/${PN}-5.15.5-python311-3.patch"
	"${FILESDIR}/${PN}-5.15.5-add-numpy-1.23-compatibility.patch"
	"${FILESDIR}/${PN}-5.12.2.1-oflag.patch"
)
DOCS=( AUTHORS )

# Ensure the path returned by get_llvm_prefix() contains clang as well.
llvm_check_deps() {
	has_version "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	# TODO: File upstream issue requesting a sane way to disable NumPy support.
	if ! use numpy; then
		sed -i -e '/\bprint(os\.path\.realpath(numpy))/d' \
			libshiboken/CMakeLists.txt || die
	fi

	# Shiboken2 assumes Vulkan headers live under either "$VULKAN_SDK/include"
	# or "$VK_SDK_PATH/include" rather than "${EPREFIX}/usr/include/vulkan".
	if use vulkan; then
		sed -i -e "s~\bdetectVulkan(&headerPaths);~headerPaths.append(HeaderPath{QByteArrayLiteral(\"${EPREFIX}/usr/include/vulkan\"), HeaderType::System});~" \
			ApiExtractor/clangparser/compilersupport.cpp || die
	fi

	# Shiboken2 assumes the "/usr/lib/clang/${CLANG_NEWEST_VERSION}/include/"
	# subdirectory provides Clang builtin includes (e.g., "stddef.h") for the
	# currently installed version of Clang, where ${CLANG_NEWEST_VERSION} is
	# the largest version specifier that exists under the "/usr/lib/clang/"
	# subdirectory. This assumption is false in edge cases, including when
	# users downgrade from newer Clang versions but fail to remove those
	# versions with "emerge --depclean". See also:
	#     https://github.com/leycec/raiagent/issues/85
	#
	# Sadly, the clang-* family of functions exported by the "toolchain-funcs"
	# eclass are defective, returning nonsensical placeholder strings if the
	# end user has *NOT* explicitly configured their C++ compiler to be Clang.
	# PySide2 does *NOT* care whether the end user has done so or not, as
	# PySide2 unconditionally requires Clang in either case. See also:
	#     https://bugs.gentoo.org/619490
	sed -i -e 's~(findClangBuiltInIncludesDir())~(QStringLiteral("'"${EPREFIX}"'/usr/lib/clang/'$(CPP=clang clang-fullversion)'/include"))~' \
		ApiExtractor/clangparser/compilersupport.cpp || die

	cmake_src_prepare
}

has_gold() {
	if ( has_version "sys-devel/llvm[binutils-plugin]" || has_version "sys-devel/llvm[gold]" ) \
                && has_version "sys-devel/llvmgold" \
                && has_version "sys-devel/binutils[gold,plugins]" ; then
		return 0
	fi
	return 1
}

use_gold() {
	if [[ "${LDFLAGS}" =~ "-fuse-ld=lld" ]] ; then
		einfo "Converting -fuse-ld=lld -> -fuse-ld=gold"
		replace-flags "-fuse-ld=lld" "-fuse-ld=gold"
	fi
	if [[ "${CXXFLAGS}" =~ "-flto=thin" ]] ; then
		einfo "Converting -flto=thin -> -flto=full"
		replace-flags "-flto=thin" "-flto=full"
	fi
}

use_bfd() {
	if [[ "${LDFLAGS}" =~ "-fuse-ld=lld" ]] ; then
		einfo "Converting -fuse-ld=lld -> -fuse-ld=bfd"
		replace-flags "-fuse-ld=lld" "-fuse-ld=bfd"
	fi
	if [[ "${CXXFLAGS}" =~ "-flto=thin" ]] ; then
		einfo "Converting -flto=thin -> -flto=full"
		replace-flags "-flto=thin" "-flto=full"
	fi
}

src_configure() {
	# Minimal tests for now, 2 failing with the extended version
	# FIXME Subscripted generics cannot be used with class and instance checks
	local mycmakeargs=(
		-DBUILD_TESTS=$(usex test)
		-DDISABLE_DOCSTRINGS=$(usex !docstrings)
	)

	local _PATH=$(echo "${PATH}" \
		| tr ":" "\n" \
		| sed -E -e "\|llvm\/[0-9]+|d")
	export LLVM_PATH=""
	local s
	for s in ${LLVM_SLOTS[@]} ; do
		if use "llvm-${s}" ; then
			_PATH=$(echo -e "${_PATH}\n/usr/lib/llvm/${s}/bin" | tr "\n" ":")
			export PATH="${_PATH}"
			LLVM_PATH="/usr/lib/llvm/${s}"
			break
		fi
	done

	export CC="${CHOST}-clang-${s}"
	export CXX="${CHOST}-clang++-${s}"
	export STRIP="/bin/true" # do not strip
	strip-unsupported-flags

	# ld.lld: error: /usr/lib/llvm/14/bin/../lib/libclang.so is incompatible with elf64-x86-64
	if has_version "sys-devel/clang[default-lld]" && has_gold ; then
		einfo "GOLD: yes"
		use_gold
	elif has_version "sys-devel/clang[default-lld]" ; then
		einfo "GOLD: no"
		use_bfd
	elif has_gold && has_version "sys-devel/lld" ; then
		einfo "GOLD: yes"
		use_gold
	else
		einfo "GOLD: no"
		use_bfd
	fi

	# It's picking up the wrong version
	export LD_LIBRARY_PATH="${LLVM_PATH}/$(get_libdir)/:${LD_LIBRARY_PATH}"

	clang --version || die
	shiboken2_configure() {
		local mycmakeargs=(
			"${mycmakeargs[@]}"
			-DPYTHON_CONFIG_SUFFIX="-${EPYTHON}"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DUSE_PYTHON_VERSION="${EPYTHON#python}"
		)
		# CMakeLists.txt expects LLVM_INSTALL_DIR as an environment variable.
		local -x LLVM_INSTALL_DIR="${LLVM_PATH}"
		cmake_src_configure
	}
einfo "PATH:\t\t${PATH}"
einfo "CFLAGS:\t\t${CFLAGS}"
einfo "CXXFLAGS:\t\t${CXXFLAGS}"
einfo "LDFLAGS:\t\t${LDFLAGS}"
einfo "LLVM_PATH:\t\t${LLVM_PATH}"
	python_foreach_impl shiboken2_configure
}

src_compile() {
	python_foreach_impl cmake_src_compile
}

src_test() {
	python_foreach_impl cmake_src_test
}

src_install() {
	shiboken2_install() {
		cmake_src_install
		python_optimize

		# Uniquify the "shiboken2" executable for the current Python target,
		# preserving an unversioned "shiboken2" file arbitrarily associated
		# with the last Python target.
		cp "${ED}"/usr/bin/${PN}{,-${EPYTHON}} || die

		# Uniquify the Shiboken2 pkgconfig file for the current Python target,
		# preserving an unversioned "shiboken2.pc" file arbitrarily associated
		# with the last Python target. See also:
		#     https://github.com/leycec/raiagent/issues/73
		cp "${ED}/usr/$(get_libdir)"/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl shiboken2_install

	# CMakeLists.txt installs a "Shiboken2Targets-gentoo.cmake" file forcing
	# downstream consumers (e.g., PySide2) to target one "libshiboken2-*.so"
	# library and one "shiboken2" executable linked to one Python interpreter.
	# See also:
	#     https://bugreports.qt.io/browse/PYSIDE-1053
	#     https://github.com/leycec/raiagent/issues/74
	sed -i \
		-e 's~shiboken2-python[[:digit:]]\+\.[[:digit:]]\+~shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		-e 's~/bin/shiboken2~/bin/shiboken2${PYTHON_CONFIG_SUFFIX}~g' \
		"${ED}/usr/$(get_libdir)"/cmake/Shiboken2*/Shiboken2Targets-${CMAKE_BUILD_TYPE,,}.cmake || die

	# Remove the broken "shiboken_tool.py" script. By inspection, this script
	# reduces to a noop. Moreover, this script raises the following exception:
	#     FileNotFoundError: [Errno 2] No such file or directory: '/usr/bin/../shiboken_tool.py': '/usr/bin/../shiboken_tool.py'
	rm "${ED}"/usr/bin/shiboken_tool.py || die

	# Cannot be done here because llvm-strip is possibly bugged.
	# There is a libclang.so.13 in clang:14 and in clang:13
	export STRIP="/bin/true" # do not strip
	einfo "Setting rpath"
	einfo "rpath: ${LLVM_PATH}/$(get_libdir)"
	for f in $(find "${ED}/usr/bin" -executable) ; do
		if file "${f}" | grep -q -E -e "ELF.*executable" ; then
			einfo "rpath before for ${f}:"
			patchelf --print-rpath "${f}" || die
			patchelf --set-rpath "${LLVM_PATH}/$(get_libdir)" "${f}" || die
			einfo "rpath after for ${f}:"
			patchelf --print-rpath "${f}" || die
		fi
	done
}

# OILEDMACHINE-OVERLAY-META-REVDEP:  openusd
