# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit mono-env eutils git-r3 mono gac toolchain-funcs flag-o-matic

DESCRIPTION="CppSharp"
HOMEPAGE="https://github.com/mono/CppSharp"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} debug abi_x86_64 abi_x86_32 +gac"
REQUIRED_USE="|| ( ${USE_DOTNET} ) abi_x86_64? ( !abi_x86_32 ) gac"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	>=dev-util/premake-5.0.0_alpha10
	>=sys-devel/llvm-3.9.0[codegen]
	>=sys-devel/clang-3.9.0
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"

pkg_setup() {
	if [[ ! -f "/usr/include/clang/Driver/ToolChain.h" ]]; then
		die "You can only use the llvm package from the oiledmachine overlay"
	fi
}

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/mono/CppSharp.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="66c3acc2f6a0257cfba1bf3ba95a3ee5e174b876"
        git-r3_fetch
        git-r3_checkout
}

src_prepare() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	eapply "${FILESDIR}/cppsharp-9999.20160115-llvm-9999-smallstring.patch"
	#eapply "${FILESDIR}/cppsharp-9999.20160115-llvm-9999-toolchain.patch"

	cd "${S}"/build
	#echo "c1316b6adfbb17b961a3bee357e728ca0d4d1c96" > LLVM-commit
	sed -i -e 's|path.join(LLVMRootDirDebug, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDirDebug, "include"),|g' LLVM.lua || die p1
	sed -i -e 's|path.join(LLVMRootDirRelease, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDirRelease, "include"),|g' LLVM.lua || die p2
	sed -i -e 's|path.join(LLVMRootDir, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDir, "include"),|g' LLVM.lua || die p3
	sed -i -e 's|error("Error finding an LLVM build")|--error("Error finding an LLVM build")|g' LLVM.lua || die p4

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|require \"..\/Helpers\"|require \"..\/Helpers\"\nlocal basedir = os.getcwd\(\) .. \"\/..\"|g" scripts/LLVM.lua || die p5
	#premake5 --file=scripts/LLVM.lua download_llvm || "premake5 download_llvm failed" || die p6
	#ln -s "${S}"/build/scripts/llvm-*-linux-Release  "${S}"/deps/llvm || die p7
	premake5 --file=premake5.lua gmake || "premake5 gmake failed" || die p8

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ALL_CXXFLAGS \+= \$\(CXXFLAGS\) \$\(ALL_CFLAGS\) -fno-rtti|ALL_CXXFLAGS += \$(CXXFLAGS) \$(ALL_CFLAGS) -fno-rtti -fPIC|g' gmake/projects/CppSharp.CppParser.make || die p9
	#sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ALL_LDFLAGS \+= \$\(LDFLAGS\) -L\/usr\/lib64 -L..\/..\/..\/deps\/llvm\/build\/lib -m64 -shared|ALL_LDFLAGS += \$(LDFLAGS) -L\/usr\/lib64 -L..\/..\/..\/deps\/llvm\/build\/lib -m64 -shared -fPIC|g' gmake/projects/CppSharp.CppParser.make || die p10
	#sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ALL_LDFLAGS \+= \$\(LDFLAGS\) -L\/usr\/lib32 -L..\/..\/..\/deps\/llvm\/build\/lib -m32 -shared|ALL_LDFLAGS += \$(LDFLAGS) -L\/usr\/lib32 -L..\/..\/..\/deps\/llvm\/build\/lib -m32 -shared -fPIC|g' gmake/projects/CppSharp.CppParser.make || die p11

	cd "${S}"
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|options.addIncludeDirs\(path\);|options.addIncludeDirs(path);options.addSystemIncludeDirs(\"\/usr\/lib\/clang\/$(ls /usr/lib/clang/)\/include\/\");|g" src/Generator.Tests/GeneratorTest.cs || die p12

	sed -i -e "s|-I/usr/lib/clang/3.9.0/include|-I/usr/lib/clang/$(clang-fullversion)/include|g" ./build/gmake/projects/CppSharp.CppParser.make || die p13

	eapply "${FILESDIR}"/cppsharp-9999.20161221-stdarg-search-path.patch
	sed -i -e "s|/usr/lib/clang/3.9.1/include|/usr/lib/clang/$(clang-fullversion)/include|g"

	genkey

	eapply_user
}

src_compile() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi
	cd "${S}"/build/gmake

	myabi="x64"
	if use abi_x86_32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

	C=clang CXX=clang++ \
	make config=${mydebug}_${myabi} all verbose=1 || die "emake failed"
}

src_install() {
	mydebug="Release"
	if use debug; then
		mydebug="Debug"
	fi

	myabi="x64"
	if use abi_x86_32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

        ebegin "Installing dlls into the GAC"

	savekey

	cp "${S}"/src/Generator/Passes/verbs.txt "${S}/build/gmake/lib/${mydebug}_${myabi}/"

	cd "${S}/build/gmake/lib/${mydebug}_${myabi}/"
	for FILE in $(ls *.dll)
	do
		strong_sign "${S}/${PN}-keypair.snk" "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}"

		for x in ${USE_DOTNET} ; do
        	        FW_UPPER=${x:3:1}
	                FW_LOWER=${x:4:1}
	                egacinstall "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}"
	        done
	done

	eend

	cd "${S}/build/gmake/lib/${mydebug}_${myabi}/"
	mkdir -p "${D}/usr/lib/mono/CppSharp/"
	for FILE in $(ls *.exe)
	do
		cp "${FILE}" "${D}/usr/lib/mono/CppSharp/"
		cp "${FILE}.mdb" "${D}/usr/lib/mono/CppSharp/"
	done

	cd "${S}"
	dodoc docs/* LICENSE README.md
}

function genkey() {
        einfo "Generating Key Pair"
        cd "${S}"
        sn -k "${PN}-keypair.snk"
}

function savekey() {
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"
}

function strong_sign() {
	pushd "$(dirname ${2})"
	ikdasm "${2}" > "${2}.il" || die "monodis failed"
	mv "${2}" "${2}.orig"
	grep -r -e "permissionset" "${2}.il" #permissionset not supported
	if [[ "$?" == "0" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|.permissionset.*\n.*\}\}||g' "${2}.il"
	fi
	grep -e "\[opt\] bool public" "${2}.il" #broken mangling
	if [[ "$?" == "0" ]]; then
		sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|\[opt\] bool public|[opt] bool \'public\'|g" "${2}.il"
	fi

	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" || die "ilasm failed"
	#rm "${2}.orig"
	#rm "${2}.il"
	popd
}
