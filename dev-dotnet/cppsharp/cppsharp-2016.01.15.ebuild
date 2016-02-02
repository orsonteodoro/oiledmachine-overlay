# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit mono-env eutils git-r3 mono

DESCRIPTION="CppSharp"
HOMEPAGE="https://github.com/mono/CppSharp"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug abi_x86_64 abi_x86_32 abi_x86_x32"

RDEPEND=">=dev-lang/mono-4"
DEPEND="${RDEPEND}
	>=dev-lang/mono-4
	>=dev-util/premake-5
	>=sys-devel/llvm-9999
"

RESTRICT="fetch"

S="${WORKDIR}/${PN}-${PV}"

pkg_setup() {
	if [[ ! -f "/usr/include/clang/Driver/ToolChain.h" ]]; then
		die "You can only use the llvm package from the oiled machine overlay"
	fi
}

src_unpack() {
        #EGIT_CHECKOUT_DIR="${WORKDIR}"
        EGIT_REPO_URI="https://github.com/mono/CppSharp.git"
        EGIT_BRANCH="master"
        EGIT_COMMIT="bbe7c1cb725868d1b1ec640833026b06ce55c1c9"
        git-r3_fetch
        git-r3_checkout

}

src_prepare() {
	mydebug="release"
	if use debug; then
		mydebug="debug"
	fi

	cd "${S}"/build
	#echo "c1316b6adfbb17b961a3bee357e728ca0d4d1c96" > LLVM-commit
	sed -i -e 's|path.join(LLVMRootDirDebug, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDirDebug, "include"),|g' LLVM.lua
	sed -i -e 's|path.join(LLVMRootDirRelease, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDirRelease, "include"),|g' LLVM.lua
	sed -i -e 's|path.join(LLVMRootDir, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDir, "include"),|g' LLVM.lua
	sed -i -e 's|error("Error finding an LLVM build")|--error("Error finding an LLVM build")|g' LLVM.lua

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|require \"..\/Helpers\"|require \"..\/Helpers\"\nlocal basedir = os.getcwd\(\) .. \"\/..\"|g" scripts/LLVM.lua
	#premake5 --file=scripts/LLVM.lua download_llvm || "premake5 download_llvm failed"
	#ln -s "${S}"/build/scripts/llvm-*-linux-Release  "${S}"/deps/llvm
	premake5 --file=premake4.lua gmake || "premake5 gmake failed"

	sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ALL_CXXFLAGS \+= \$\(CXXFLAGS\) \$\(ALL_CFLAGS\) -fno-rtti|ALL_CXXFLAGS += \$(CXXFLAGS) \$(ALL_CFLAGS) -fno-rtti -fPIC|g' gmake/projects/CppSharp.CppParser.make
	#sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ALL_LDFLAGS \+= \$\(LDFLAGS\) -L\/usr\/lib64 -L..\/..\/..\/deps\/llvm\/build\/lib -m64 -shared|ALL_LDFLAGS += \$(LDFLAGS) -L\/usr\/lib64 -L..\/..\/..\/deps\/llvm\/build\/lib -m64 -shared -fPIC|g' gmake/projects/CppSharp.CppParser.make
	#sed -i -r -e ':a' -e 'N' -e '$!ba' -e 's|ALL_LDFLAGS \+= \$\(LDFLAGS\) -L\/usr\/lib32 -L..\/..\/..\/deps\/llvm\/build\/lib -m32 -shared|ALL_LDFLAGS += \$(LDFLAGS) -L\/usr\/lib32 -L..\/..\/..\/deps\/llvm\/build\/lib -m32 -shared -fPIC|g' gmake/projects/CppSharp.CppParser.make

	cd "${S}"
	sed -i -r -e ':a' -e 'N' -e '$!ba' -e "s|options.addIncludeDirs\(path\);|options.addIncludeDirs(path);options.addSystemIncludeDirs(\"\/usr\/lib\/clang\/$(ls /usr/lib/clang/)\/include\/\");|g" src/Generator.Tests/GeneratorTest.cs
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
	elif use abi_x86_x32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

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
	elif use abi_x86_x32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

        ebegin "Installing dlls into the GAC"


	cd "${S}"
	sn -k "${PN}-keypair.snk"
	mkdir -p "${D}/usr/share/${PN}/"
	cp "${PN}-keypair.snk" "${D}/usr/share/${PN}/"

	cp "${S}"/src/Generator/Passes/verbs.txt "${S}/build/gmake/lib/${mydebug}_${myabi}/"

	cd "${S}/build/gmake/lib/${mydebug}_${myabi}/"
	for FILE in $(ls *.dll)
	do
		strong_sign "${S}/${PN}-keypair.snk" "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}"
	        gacutil -i "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}" -root "${D}/usr/$(get_libdir)" \
	                -gacdir "/usr/$(get_libdir)" -package "${PN}" #|| die "failed"
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

        #mono_multilib_comply
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

	ilasm /dll /key:"${1}" /output:"${2}" "${2}.il" #|| die "ilasm failed"
	#rm "${2}.orig"
	#rm "${2}.il"
	popd
}
