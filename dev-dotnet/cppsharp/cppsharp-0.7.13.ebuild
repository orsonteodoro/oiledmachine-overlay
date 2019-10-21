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

# todo convert into patch file
src_prepare() {
	default
	local mydebug=$(usex debug "debug" "release")

	multilib_copy_sources

	ml_prepare1() {
		dotnet_copy_sources
	}
	multilib_foreach_impl ml_prepare1

	ml_prepare2() {
		netfx_prepare2() {
			eapply \
		"${FILESDIR}/cppsharp-9999.20160115-llvm-9999-smallstring.patch"
#			eapply \
#		"${FILESDIR}/cppsharp-9999.20160115-llvm-9999-toolchain.patch"

			eapply \
		"${FILESDIR}"/cppsharp-9999.20161221-stdarg-search-path.patch
			sed -i \
-e "s|/usr/lib/clang/3.9.1/include|/usr/lib/clang/$(clang-fullversion)/include|g" \
				src/Generator.Tests/GeneratorTest.cs || die

			pushd build || die
				#echo "c1316b6adfbb17b961a3bee357e728ca0d4d1c96" > LLVM-commit
				sed -i \
-e 's|path.join(LLVMRootDirDebug, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDirDebug, "include"),|g' \
	LLVM.lua || die
				sed -i \
-e 's|path.join(LLVMRootDirRelease, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDirRelease, "include"),|g' \
	LLVM.lua || die
				sed -i \
-e 's|path.join(LLVMRootDir, "include"),|path.join("/usr/lib/clang/3.9.0/include/"),path.join("/usr/include/llvm"),path.join("/usr/include/clang"),path.join(LLVMRootDir, "include"),|g' \
	LLVM.lua || die
				sed -i \
-e 's|error("Error finding an LLVM build")|--error("Error finding an LLVM build")|g' \
	LLVM.lua || die

				sed -i -r -e ':a' -e 'N' -e '$!ba' \
-e "s|require \"..\/Helpers\"|require \"..\/Helpers\"\nlocal basedir = os.getcwd\(\) .. \"\/..\"|g" \
	scripts/LLVM.lua || die p5
#				premake5 --file=scripts/LLVM.lua download_llvm \
#					|| "premake5 download_llvm failed" \
#					|| die
#				ln -s "${S}"/build/scripts/llvm-*-linux-Release \
#					deps/llvm || die
				premake5 --file=premake5.lua gmake \
					|| die "premake5 gmake failed"

				sed -i -r -e ':a' -e 'N' -e '$!ba' \
-e 's|ALL_CXXFLAGS \+= \$\(CXXFLAGS\) \$\(ALL_CFLAGS\) -fno-rtti|ALL_CXXFLAGS += \$(CXXFLAGS) \$(ALL_CFLAGS) -fno-rtti -fPIC|g' \
	gmake/projects/CppSharp.CppParser.make || die
#				sed -i -r -e ':a' -e 'N' -e '$!ba' \
# -e 's|ALL_LDFLAGS \+= \$\(LDFLAGS\) -L\/usr\/lib64 -L..\/..\/..\/deps\/llvm\/build\/lib -m64 -shared|ALL_LDFLAGS += \$(LDFLAGS) -L\/usr\/lib64 -L..\/..\/..\/deps\/llvm\/build\/lib -m64 -shared -fPIC|g' \
# gmake/projects/CppSharp.CppParser.make || die
#				sed -i -r -e ':a' -e 'N' -e '$!ba' \
# -e 's|ALL_LDFLAGS \+= \$\(LDFLAGS\) -L\/usr\/lib32 -L..\/..\/..\/deps\/llvm\/build\/lib -m32 -shared|ALL_LDFLAGS += \$(LDFLAGS) -L\/usr\/lib32 -L..\/..\/..\/deps\/llvm\/build\/lib -m32 -shared -fPIC|g' \
# gmake/projects/CppSharp.CppParser.make || die
			popd

			sed -i -r -e ':a' -e 'N' -e '$!ba' \
-e "s|options.addIncludeDirs\(path\);|options.addIncludeDirs(path);options.addSystemIncludeDirs(\"\/usr\/lib\/clang\/$(ls /usr/lib/clang/)\/include\/\");|g" \
			src/Generator.Tests/GeneratorTest.cs || die
			sed -i \
-e "s|-I/usr/lib/clang/3.9.0/include|-I/usr/lib/clang/$(clang-fullversion)/include|g" \
			build/gmake/projects/CppSharp.CppParser.make || die

			#inject strong name and force net version
			FILES=$(grep -l -r -e "FLAGS = /unsafe" ./)
			for f in $FILES
			do
				einfo "Patching $f..."
				sed -i -r \
-e "s|FLAGS = /unsafe|FLAGS = -sdk:${EBF} -keyfile:\"${DISTDIR}/mono.snk\" /unsafe|g" \
					"$f" || die
			done

			#inject strong name and force net version
			FILES=$(grep -l -r -e "/nologo" ./)
			for f in $FILES
			do
				einfo "Patching $f..."
				sed -i -r \
-e "s|/nologo|-sdk:${EBF} -keyfile:\"${DISTDIR}/mono.snk\" /nologo|g" \
					"$f" || die
			done

			#inject public key into assembly
		        public_key=$(sn -tp "${DISTDIR}/mono.snk" | tail -n 7 | head -n 5 | tr -d '\n')
		        echo "pk is: ${public_key}"
			FILES=$(grep -l -r -e "InternalsVisibleTo" ./)
			for f in $FILES
			do
				einfo "Attempting to inject public key into $f..."
				sed -i -r \
-e "s|\[assembly\:InternalsVisibleTo\(\"CppSharp.Parser\"\)\]|\[assembly:InternalsVisibleTo(\"CppSharp.Parser, PublicKey=${public_key}\")\]|" \
					"$f"
				sed -i -r \
-e "s|\[assembly\:InternalsVisibleTo\(\"CppSharp.Parser.CSharp\"\)\]|\[assembly:InternalsVisibleTo(\"CppSharp.Parser.CSharp, PublicKey=${public_key}\")\]|" \
					"$f"
			done

			# this needs testing
			# also the key needs to be fixed but we generate new
			# keys per emerge because users can inject their own
			# patches
			sed -i -r \
-e "s|\[assembly\:InternalsVisibleTo\(\\\\\"CppSharp.Parser\\\\\"\)\]|\[assembly:InternalsVisibleTo(\\\\\"CppSharp.Parser, PublicKey=${public_key}\\\\\")\]|" \
				src/CppParser/ParserGen/ParserGen.cs || die
			sed -i -r \
-e "s|\[assembly\:InternalsVisibleTo\(\\\\\"\{library\}\\\\\"\)\]|\[assembly:InternalsVisibleTo(\\\\\"\{library\}, PublicKey=${public_key}\\\\\")\]|" \
			src/Generator/Generators/CSharp/CSharpSources.cs || die
			sed -i -r \
-e "s|\[assembly\:InternalsVisibleTo\(\\\\\"NamespacesDerived.CSharp\\\\\"\)\]|\[assembly:InternalsVisibleTo(\\\\\"NamespacesDerived.CSharp, PublicKey=${public_key}\\\\\")\]|" \
			tests/NamespacesDerived/NamespacesDerived.cs || die
		}
		dotnet_foreach_impl netfx_prepare2
	}
	multilib_foreach_impl ml_prepare2
}

src_compile() {
	local mydebug=$(usex debug "debug" "release")
	ml_compile() {
		netfx_compile_impl() {
			cd build/gmake
			local myabi
			if [[ "${ABI}" == "amd64" ]] ; then
				myabi="x64"
			elif [[ "${ABI}" == "x86" ]] ; then
				myabi="x32"
			fi

			C=clang CXX=clang++ \
			make config=${mydebug}_${myabi} all verbose=1 \
				|| die "emake failed"
		}
	}
	dotnet_foreach_impl netfx_compile_impl
	multilib_foreach_impl ml_compile_impl
}

src_install() {
	local mydebug=$(usex debug "Debug" "Release")
	ml_install_impl() {
		netfx_install_impl() {
			dotnet_install_loc
			local myabi
			if [[ "${ABI}" == "amd64" ]] ; then
				myabi="x64"
			elif [[ "${ABI}" == "x86" ]] ; then
				myabi="x32"
			else
				die "ABI is not supported"
			fi

			# huh?
			# cp "${S}"/src/Generator/Passes/verbs.txt \
				"${S}/build/gmake/lib/${mydebug}_${myabi}/"

			pushd build/gmake/lib/${mydebug}_${myabi} || die
				# todo dlls
				egacinstall *.dll
				doins *.dll
				if use developer ; then
					doins *.mdb
				fi
				doexe *.exe
				if use developer ; then
					doins *.mdb
					# todo distribute in gac
				fi
			popd
			dodoc docs/* LICENSE README.md
		}
		dotnet_foreach_impl netfx_install_impl
	}
	multilib_foreach_impl ml_install_impl
	dotnet_multilib_comply
}
