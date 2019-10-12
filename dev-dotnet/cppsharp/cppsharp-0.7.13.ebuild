# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="Tools and libraries to glue C/C++ APIs to high-level languages "
HOMEPAGE="https://github.com/mono/CppSharp"
LICENSE="MIT"
KEYWORDS="~amd64 ~x86"
PROJECT_NAME="CppSharp"
SLOT="0"
USE_DOTNET="net45"
IUSE="${USE_DOTNET} abi_x86_64 abi_x86_32 debug +gac developer"
REQUIRED_USE="|| ( ${USE_DOTNET} ) abi_x86_64? ( !abi_x86_32 ) gac gac? ( net45 )"
DEPEND="${RDEPEND}
	>=dev-util/premake-5.0.0_alpha10
	>=sys-devel/clang-3.9.0
	>=sys-devel/llvm-3.9.0[codegen]
	 !sys-devel/llvm:0/9999"
inherit dotnet eutils flag-o-matic mono toolchain-funcs
SRC_URI="https://github.com/mono/${PROJECT_NAME}/archive/${PV}.tar.gz -> ${P}.tar.gz"
inherit gac
RESTRICT="mirror"
S="${WORKDIR}/${PROJECT_NAME}-${PV}"

pkg_setup() {
	dotnet_pkg_setup
	if [[ ! -f "/usr/include/clang/Driver/ToolChain.h" ]]; then
		die "You can only use the llvm package from the oiledmachine overlay"
	fi
}

src_prepare() {
	default
	mydebug=$(usex debug "debug" "release")

	eapply "${FILESDIR}/cppsharp-9999.20160115-llvm-9999-smallstring.patch"
	#eapply "${FILESDIR}/cppsharp-9999.20160115-llvm-9999-toolchain.patch"

	eapply "${FILESDIR}"/cppsharp-9999.20161221-stdarg-search-path.patch
	sed -i -e "s|/usr/lib/clang/3.9.1/include|/usr/lib/clang/$(clang-fullversion)/include|g" src/Generator.Tests/GeneratorTest.cs || die p14

	cd "${S}"/build || die
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

	#inject strong name and force net version
	FILES=$(grep -l -r -e "FLAGS = /unsafe" ./)
	for f in $FILES
	do
		einfo "Patching $f..."
		sed -i -r -e "s|FLAGS = /unsafe|FLAGS = -sdk:${EBF} -keyfile:\"${DISTDIR}/mono.snk\" /unsafe|g" "$f" || die
	done

	#inject strong name and force net version
	FILES=$(grep -l -r -e "/nologo" ./)
	for f in $FILES
	do
		einfo "Patching $f..."
		sed -i -r -e "s|/nologo|-sdk:${EBF} -keyfile:\"${DISTDIR}/mono.snk\" /nologo|g" "$f" || die
	done

	#inject public key into assembly
        public_key=$(sn -tp "${DISTDIR}/mono.snk" | tail -n 7 | head -n 5 | tr -d '\n')
        echo "pk is: ${public_key}"
	FILES=$(grep -l -r -e "InternalsVisibleTo" ./)
	for f in $FILES
	do
		einfo "Attempting to inject public key into $f..."
		sed -i -r -e "s|\[assembly\:InternalsVisibleTo\(\"CppSharp.Parser\"\)\]|\[assembly:InternalsVisibleTo(\"CppSharp.Parser, PublicKey=${public_key}\")\]|" "$f"
		sed -i -r -e "s|\[assembly\:InternalsVisibleTo\(\"CppSharp.Parser.CSharp\"\)\]|\[assembly:InternalsVisibleTo(\"CppSharp.Parser.CSharp, PublicKey=${public_key}\")\]|" "$f"
	done

	#this needs testing
	#also the key needs to be fixed but we generate new keys per emerge because users can inject their own patches
	sed -i -r -e "s|\[assembly\:InternalsVisibleTo\(\\\\\"CppSharp.Parser\\\\\"\)\]|\[assembly:InternalsVisibleTo(\\\\\"CppSharp.Parser, PublicKey=${public_key}\\\\\")\]|" ./src/CppParser/ParserGen/ParserGen.cs || die
	sed -i -r -e "s|\[assembly\:InternalsVisibleTo\(\\\\\"\{library\}\\\\\"\)\]|\[assembly:InternalsVisibleTo(\\\\\"\{library\}, PublicKey=${public_key}\\\\\")\]|" ./src/Generator/Generators/CSharp/CSharpSources.cs || die
	sed -i -r -e "s|\[assembly\:InternalsVisibleTo\(\\\\\"NamespacesDerived.CSharp\\\\\"\)\]|\[assembly:InternalsVisibleTo(\\\\\"NamespacesDerived.CSharp, PublicKey=${public_key}\\\\\")\]|" ./tests/NamespacesDerived/NamespacesDerived.cs || die
}

src_compile() {
	mydebug=$(usex debug "debug" "release")
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
	mydebug=$(usex debug "Debug" "Release")

	myabi="x64"
	if use abi_x86_32; then
		myabi="x32"
	elif use abi_x86_64; then
		myabi="x64"
	fi

        ebegin "Installing dlls into the GAC"

	cp "${S}"/src/Generator/Passes/verbs.txt "${S}/build/gmake/lib/${mydebug}_${myabi}/"

	cd "${S}/build/gmake/lib/${mydebug}_${myabi}/"
	for FILE in $(ls *.dll)
	do
		for x in ${USE_DOTNET} ; do
			FW_UPPER=${x:3:1}
			FW_LOWER=${x:4:1}
			egacinstall "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}"
			insinto "/usr/$(get_libdir)/mono/${PN}"
			use developer && doins "${S}/build/gmake/lib/${mydebug}_${myabi}/${FILE}.mdb"
		done
	done

	eend

	cd "${S}/build/gmake/lib/${mydebug}_${myabi}/"
	mkdir -p "${D}/usr/$(get_libdir)/mono/CppSharp/"
	for FILE in $(ls *.exe)
	do
		cp "${FILE}" "${D}/usr/$(get_libdir)/mono/CppSharp/"
		use developer && cp "${FILE}.mdb" "${D}/usr/$(get_libdir)/mono/CppSharp/"
	done

	cd "${S}"
	dodoc docs/* LICENSE README.md

	dotnet_multilib_comply
}
