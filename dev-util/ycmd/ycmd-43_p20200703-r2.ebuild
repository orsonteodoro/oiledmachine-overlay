# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Last commit before 44

EAPI=7
DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
# The vanilla MIT license doesn't contain all rights reserved but it is stated in the .target(s), .prop files., .dll files (System.ComponentModel.Composition)
# Additional licenses on internal omnisharp-rosyln refer to .target(s), .rsp, .config files
LICENSE="GPL-3+ BSD
	clangd? ( !system-clangd? ( Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA ) )
	csharp? ( !system-omnisharp-roslyn? ( all-rights-reserved MIT Apache-2.0 ) )
	examples? ( Apache-2.0 )
	go? ( !system-go-tools? ( BSD ) )
	java? ( Apache-1.1 Apache-2.0 BSD BSD-2 BSD-4 CPL-1.0 dom4j EPL-2.0 icu MPL-1.1 NAIST-IPADIC unicode W3C W3C-document )
	javascript? ( !system-tern? ( MIT ) )
	libclang? ( !system-libclang? ( Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA ) )
	python? ( !system-jedi? ( BSD-2 MIT PSF-2 ) )
	regex? ( !system-mrab-regex? ( all-rights-reserved CNRI PSF-2 ) )
	rust? ( !system-rust? ( || ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA ) )
	!system-bottle? ( MIT )
	!system-libclang? ( Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA )
	!system-mono? ( all-rights-reserved MIT )
	!system-pathtools? ( BSD MIT ZPL )
	!system-requests? ( Apache-2.0 BSD LGPL-2.1+ MIT MPL-2.0 PSF-2 Unicode-DFS )
	!system-waitress? ( ZPL )
	!system-watchdog? ( Apache-2.0 )
	test? ( BSD GPL-3+ )"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8,9} )
# slot 0 old hmac calculation, new one is
#	 426833360adec8db72ed6cef9d7aa7f037e6a5b8 of (ycmd/hmac_plugin.py)
# slot 1 racerd, (gocode, godef); python 2.x or 3.x ; compatible with current
#        (20200201) emacs-ycmd, nano-ycmd, gycm
# slot 2 (racerd) -> (rls) ; (gocode, godef) -> (gopls) ; python 3 only
SLOT="2"
USE_DOTNET="net472 netcoreapp21"
IUSE="c clangd csharp cuda cxx debug developer doc examples go java javascript libclang \
minimal objc objcxx python regex rust system-bottle system-boost system-clangd \
system-go-tools system-jedi system-libclang system-mono system-mrab-regex \
system-requests system-omnisharp-roslyn system-pathtools system-rls \
system-rust system-tern system-typescript system-waitress system-watchdog test \
typescript vim"
IUSE+=" ${USE_DOTNET}"
CLANG_V="10.0"
CLANG_V_MAJ=$(ver_cut 1 ${CLANG_V})
PV_MAJ=$(ver_cut 1 ${PV})
inherit python-r1
REQUIRED_USE="
	c? ( || ( clangd libclang ) )
	clangd? ( || ( c cxx objc objcxx ) )
	csharp? ( || ( ${USE_DOTNET} ) )
	cxx? ( || ( clangd libclang ) )
	libclang? ( || ( c cxx objc objcxx ) )
	objc? ( || ( clangd libclang ) )
	objcxx? ( || ( clangd libclang ) )
	system-clangd? ( || ( c cxx objc objcxx ) clangd )
	system-go-tools? ( go )
	system-jedi? ( python )
	system-libclang? ( || ( c cxx objc objcxx ) libclang )
	system-mrab-regex? ( regex )
	system-omnisharp-roslyn? ( csharp )
	system-rls? ( rust )
	system-tern? ( javascript )"
# Versions must match
# https://github.com/ycm-core/ycmd/blob/master/cpp/BoostParts/boost/version.hpp
CDEPEND="${PYTHON_DEPS}
	system-boost? ( >=dev-libs/boost-1.72:=[python,threads,${PYTHON_USEDEP}] )
	system-libclang? ( sys-devel/clang:${CLANG_V_MAJ} )
	system-clangd? ( sys-devel/clang:${CLANG_V_MAJ} )"
# gopls is 0.4.1
# See build.py for dependency versions.

# For the rust version see src/bootstrap/channel.rs in https://github.com/rust-lang
# and build.py in archive for nightly date.  Use committer-date:YYYY-MM-DD to search

RDEPEND="${CDEPEND}
	java? ( virtual/jre:1.8 )
	javascript? ( net-libs/nodejs )
	system-bottle? ( >=dev-python/bottle-0.12.18[${PYTHON_USEDEP}] )
	system-go-tools? ( >=dev-go/go-tools-0_pre20200701 )
	system-jedi? ( >=dev-python/jedi-0.17.0[${PYTHON_USEDEP}]
			>=dev-python/numpydoc-0.9.0_pre20200408[${PYTHON_USEDEP}]
			>=dev-python/parso-0.7.0[${PYTHON_USEDEP}] )
	csharp? (
		system-mono? (
			net472? ( >=dev-lang/mono-5.10 )
			netcoreapp21? (
				>=dev-lang/mono-5.4
				|| (
					dev-dotnet/cli-tools
					dev-dotnet/dotnetcore-sdk-bin
				)
			)
		)
	)
	system-mrab-regex? (
		>=dev-python/regex-2019.06.08[${PYTHON_USEDEP}]
	)
	system-omnisharp-roslyn? ( >=dev-dotnet/omnisharp-roslyn-1.35.3[net472?,netcoreapp21?] )
	system-pathtools? ( >=dev-python/pathtools-0.1.1_pre20161006 )
	system-requests? ( >=dev-python/requests-2.23.0[${PYTHON_USEDEP}] )
	system-rls? ( >=dev-lang/rust-1.44.0_pre20200417[rls] )
	system-tern? ( >=dev-nodejs/tern-0.21.0 )
	system-typescript? ( >=dev-lang/typescript-3.8.3 )
	system-waitress? ( >=dev-python/waitress-1.4.3[${PYTHON_USEDEP}] )
	system-watchdog? ( >=dev-python/watchdog-0.10.2 )"
# The versioning for dev-python/regex is messed up we have some people padding
# the day and month with 0 and gentoo overlay not doing it.  We stick to the
# upstream versioning.
# The versioning for mrab-regex is based on __version__ in regex.py.
DEPEND="${CDEPEND}
	javascript? ( net-libs/nodejs[npm] )
	typescript? ( net-libs/nodejs[npm] )
	test? ( >=dev-python/codecov-2.0.5[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.0[${PYTHON_USEDEP}]
		dev-python/flake8-comprehensions[${PYTHON_USEDEP}]
		>=dev-python/flake8-ycm-0.1.0[${PYTHON_USEDEP}]
		>=dev-python/psutil-5.6.6[${PYTHON_USEDEP}]
		>=dev-python/pyhamcrest-1.10.1[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-cov[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0.20[${PYTHON_USEDEP}] )"
#		<dev-python/coverage-4.4[${PYTHON_USEDEP}] # goes in test?
EGIT_COMMIT="ef48cfe1b63bcc07b88e537fb5b6d17b513e319c"
EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"
inherit cmake-utils eutils flag-o-matic git-r3
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( JAVA_SUPPORT.md README.md )
BD_REL="ycmd/${SLOT}"
BD_ABS=""

pkg_setup() {
	if \
	! use system-boost \
	|| ! use system-clangd \
	|| ! use system-go-tools \
	|| ! use system-libclang \
	|| ! use system-omnisharp-roslyn \
	|| ! use system-rls \
	|| ! use system-tern \
	|| ! use system-typescript \
	|| use test ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download the internal dependencies."
		fi
	fi
	python_setup
}

src_prepare() {
	default
	local sitedir="$(python_get_sitedir)"

	# Required for deterministic build.
	eapply "${FILESDIR}/${PN}-42_p20200108-skip-thirdparty-check.patch"

	eapply "${FILESDIR}/${PN}-43_p20200516-system-third-party.patch"
	eapply "${FILESDIR}/${PN}-43_p20200516-flatten-watchdog-path.patch"

	ewarn "This ebuild is a Work in Progress and may not work at all."
	if use go && ! use system-go-tools ; then
		ewarn \
"Flaky go servers may prevent gopls from installing or existing.  Try again."
	fi

	if use clangd ; then
		ewarn "Clangd is experimental and not recommended at this time."
	fi

	cat "${FILESDIR}/default_settings.json.42_p20200108" \
		> ycmd/default_settings.json || die

	if use system-libclang ; then
		eapply \
		"${FILESDIR}/${PN}-9999.20170107-force-python-libs-path.patch"
		LIBCLANG_PATH=$(\
			ls /usr/$(get_libdir)/llvm/*/$(get_libdir)/libclang.so* | head -1)
		sed -i -e "s|\
EXTERNAL_LIBCLANG_PATH \${TEMP}|\
EXTERNAL_LIBCLANG_PATH \"${LIBCLANG_PATH}\"|g" \
			cpp/ycm/CMakeLists.txt || die
		eapply \
		"${FILESDIR}/${PN}-43_p20200516-system-libclang.patch"
		sed -i -e "s|\
__LIBCLANG_LIB_DIR__|\
/usr/$(get_libdir)/llvm/${CLANG_V_MAJ}/$(get_libdir)/|" ycmd/utils.py || die
	fi

	CMAKE_USE_DIR="${S}/cpp" \
	cmake-utils_src_prepare

	if use system-clangd ; then
		sed -i -e "s|\
___CLANGD_BIN_PATH___|\
/usr/$(get_libdir)/llvm/${CLANG_V_MAJ}/bin/clangd|g" \
			ycmd/default_settings.json || die
	fi

	if use system-go-tools ; then
		ewarn \
"The system-go-tools USE flag is untested for this version.  It's\n\
recommended to use the internal instead."
		eapply "${FILESDIR}/${PN}-43_p20200516-system-go.patch"
		sed -i -e "s|___GOPLS_BIN_PATH___|/usr/bin/gopls|g" \
			ycmd/completers/go/go_completer.py || die
		sed -i -e "s|___GOPLS_BIN_PATH___|/usr/bin/gopls|g" \
			ycmd/default_settings.json || die
	fi

	if use system-mrab-regex ; then
		ewarn "Using system-mrab-regex is WIP"
		sed -i -e "s|  BuildRegexModule|  #BuildRegexModule|" \
			build.py || die
	fi

	if use system-omnisharp-roslyn ; then
		ewarn \
"The system-omnisharp-roslyn USE flag is untested for this version.  It's\n\
recommended to use the internal instead."

		eapply \
		"${FILESDIR}/${PN}-43_p20200516-system-omnisharp-roslyn.patch"

		if use net472 ; then
			# todo
			cp -a "${FILESDIR}/omnisharp.sh.netfx" \
				omnisharp.sh
			FRAMEWORK_FOLDER="net472"
			sed -i -e "s|\
___OMNISHARP_DIR_PATH___|\
/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" \
				omnisharp.sh || die
		elif use netcoreapp21 ; then
			ewarn "netcoreapp21 location is tentative."
			local _dotnet
			if [ -d /opt/dotnet ] ; then
				# built from source code: dev-dotnet/cli-tools
				_dotnet="dotnet"
			else
				# precompiled: dev-dotnet/dotnetcore-sdk-bin
				_dotnet="dotnet_core"
			fi

			cp -a "${FILESDIR}/omnisharp.sh.netcoreapp" \
				omnisharp.sh
			NETCORE_VERSION="2.1.0"
			FRAMEWORK_FOLDER="netcoreapp2.1"
			sed -i -e "s|\
___NETCOREAPP_LIB_PATH___|\
/opt/${_dotnet}/shared/Microsoft.NETCore.App/${NETCORE_VERSION}|g" \
				omnisharp.sh || die
			sed -i -e "s|\
___OMNISHARP_DIR_PATH___|\
$(realpath /opt/${_dotnet}/sdk/NuGetFallbackFolder/omnisharp-roslyn/*/ref/\
${FRAMEWORK_FOLDER} \
				| sort | tail -n 1)
|g" \
				omnisharp.sh || die
		fi
		sed -i -e "s|\
___OMNISHARP_DIR_PATH___|\
/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" \
			ycmd/completers/cs/cs_completer.py || die
	fi

	if use system-rls ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-system-rust.patch"
		sed -i -e "s|___RUSTC_BIN_PATH___|/usr/bin/rustc|g" \
			ycmd/completers/rust/rust_completer.py || die
		sed -i -e "s|___RLS_BIN_PATH___|/usr/bin/rls|g" \
			ycmd/completers/rust/rust_completer.py || die
		sed -i -e "s|___RUSTC_BIN_PATH___|/usr/bin/rustc|g" \
			ycmd/default_settings.json || die
		sed -i -e "s|___RLS_BIN_PATH___|/usr/bin/rls|g" \
			ycmd/default_settings.json || die
	else
		ewarn \
"Using the internal rust.  You are responsible for maintaining the security\n\
of internal rust and associated packages."
	fi

	if use system-tern ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-system-tern.patch"
		sed -i -e "s|___TERN_BIN_PATH___|/usr/bin/tern|g" \
			ycmd/completers/javascript/tern_completer.py || die
	fi

	if ! use vim ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-remove-ultisnips.patch"
		sed -i -e 's|"use_ultisnips_completer": 1,||g' \
			ycmd/default_settings.json || die
	fi

	if use system-typescript ; then
		sed -i -e "s|___TSSERVER_BIN_PATH___|/usr/bin/tsserver|g" \
			ycmd/default_settings.json || die
	fi

	if use system-watchdog ; then
		ewarn "Using system-watchdog is WIP"
		sed -i -e "s|  CompileWatchdog|  #CompileWatchdog|" \
			build.py || die
	fi

	sed -i -e "s|\
___HMAC_SECRET___|\
$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" \
		ycmd/default_settings.json || die

	sed -i -e "s|___GLOBAL_YCMD_EXTRA_CONF___|/tmp/.ycm_extra_conf.py|" \
		ycmd/default_settings.json || die

	python_copy_sources
}


src_configure() {
	if use developer ; then
		DOCS+=( CODE_OF_CONDUCT.md CONTRIBUTING.md )
	fi
	python_configure_all()
	{
		cd "${BUILD_DIR}" || die
		local sitedir="$(python_get_sitedir)"
		BD_ABS="$(python_get_sitedir)/${BD_REL}"

		if use system-bottle ; then
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'bottle' \)|\
${sitedir}/bottle|g" \
				ycmd/server_utils.py || die
		fi

		if ! use system-clangd ; then
			sed -i -e "s|\
___CLANGD_BIN_PATH___|\
${BD_ABS}/third_party/clangd/output/bin/clangd|g" \
			ycmd/default_settings.json || die
		fi

		if ! use system-go-tools ; then
			sed -i -e "s|\
___GOPLS_BIN_PATH___|\
${BD_ABS}/third_party/go/bin/gopls|g" \
				ycmd/default_settings.json || die
		fi

		if use system-jedi ; then
			sed -i -e "s|\
p.join( DIR_OF_THIRD_PARTY, 'jedi_deps', 'jedi' )|\
${sitedir}/jedi|g" \
				ycmd/server_utils.py || die
			sed -i -e "s|\
p.join( DIR_OF_THIRD_PARTY, 'jedi_deps', 'numpydoc' )|\
${sitedir}/numpydoc|g" \
				ycmd/server_utils.py || die
			sed -i -e "s|\
p.join( DIR_OF_THIRD_PARTY, 'jedi_deps', 'parso' )|\
${sitedir}/parso|g" \
				ycmd/server_utils.py || die
		fi

		if use system-mrab-regex ; then
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'cregex', 'regex_3' \)|\
${sitedir}/regex|g" \
				ycmd/server_utils.py || die
		fi

		if use system-omnisharp-roslyn ; then
			sed -i -e "s|\
___OMNISHARP_BIN_ABSPATH___|\
${BD_ABS}/ycmd/completers/cs/omnisharp.sh|g" \
				ycmd/completers/cs/cs_completer.py || die
			sed -i -e "s|\
___OMNISHARP_BIN_ABSPATH___|\
${BD_ABS}/ycmd/completers/cs/omnisharp.sh|g" \
				ycmd/default_settings.json || die
		fi

		if use system-pathtools ; then
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'pathtools' \)|\
${sitedir}/pathtools|g" \
				ycmd/server_utils.py || die
		fi

		if use system-requests ; then
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'requests_deps', 'requests' \)|\
${sitedir}/requests|g" \
				ycmd/server_utils.py || die
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'requests_deps', 'chardet' \)|\
${sitedir}/chardet|g" \
				ycmd/server_utils.py || die
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'requests_deps', 'certifi' \)|\
${sitedir}/certifi|g" \
				ycmd/server_utils.py || die
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'requests_deps', 'idna' \)|\
${sitedir}/idna|g" \
				ycmd/server_utils.py || die
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'requests_deps', 'urllib3', 'src' \)|\
${sitedir}/urllib3|g" \
				ycmd/server_utils.py || die
		fi

		if ! use system-typescript ; then
			sed -i -e "s|\
___TSSERVER_BIN_PATH___|\
${BD_ABS}/third_party/tsserver/lib64/node_modules/typescript/bin/tsserver|g" \
				ycmd/default_settings.json || die
		fi

		if use system-waitress ; then
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'waitress' \)|\
${sitedir}/waitress|g" \
				ycmd/server_utils.py || die
		fi

		if use system-watchdog ; then
			sed -i -e "s|\
p.join\( DIR_OF_THIRD_PARTY, 'watchdog', 'build', 'lib3' \)|\
${sitedir}/watchdog|g" \
				ycmd/server_utils.py || die
		fi

		sed -i -e "s|___PYTHON_BIN_PATH___|/usr/bin/${EPYTHON}|g" \
			ycmd/default_settings.json || die

		sed -i -e "s|\
___PYTHON_LIB_PATH___|\
/usr/$(get_libdir)/lib${EPYTHON}.so|g" \
			build.py || die

		# ---

		filter-flags -O0 -O1 -O3 -O4
		append-cxxflags -O2
		append-cflags -O2
		# We need to do this ourselves instead of rely on the build
		# script.  The build script has racing error when it tries to
		# do it through emerge.
		local mycmakeargs=(
			-DUSE_CLANG_COMPLETER=$(usex system-boost)
			-DUSE_DEV_FLAGS=$(usex debug)
			-DUSE_SYSTEM_BOOST=$(usex system-boost)
			-DUSE_SYSTEM_LIBCLANG=$(usex system-libclang)
			-DCMAKE_BUILD_TYPE=$(usex debug "Debug" "Release")
		)
		local pyv=$(echo "${EPYTHON}" | sed -e "s|python||")
		if [ -f /usr/$(get_libdir)/libpython${pyv}m.so ]; then
			mycmakeargs+=\
( -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython${pyv}m.so )
			mycmakeargs+=\
( -DPYTHON_INCLUDE_DIR=/usr/include/python${pyv}m )
		else
			mycmakeargs+=\
( -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython${pyv}.so )
			mycmakeargs+=\
( -DPYTHON_INCLUDE_DIR=/usr/include/python${pyv} )
		fi
		if use c || use cxx || use objc || use objcxx ; then
			mycmakeargs+=( -DUSE_CLANG_COMPLETER=ON )
		fi
		CMAKE_USE_DIR="${BUILD_DIR}/cpp" \
		cmake-utils_src_configure
	}
	python_foreach_impl python_configure_all
}

src_compile() {
	python_compile_all() {
		cd "${BUILD_DIR}"
		local myargs=""
		if use c || use cxx || use objc || use objcxx ; then
			if use clangd ; then
				myargs+=" --clangd-completer"
			fi
			if use libclang ; then
				myargs+=" --clang-completer"
			fi
		fi
		if use csharp \
			&& ! use system-omnisharp-roslyn ; then
			myargs+=" --cs-completer"
		fi
		if use debug ; then
			myargs+=" --enable-debug"
		fi
		if use go \
			&& ! use system-go-tools ; then
			myargs+=" --go-completer"
		fi
		if use java ; then
			myargs+=" --java-completer"
		fi
		if use javascript \
			&& ! use system-tern ; then
			myargs+=" --tern-completer"
		fi
#		if ! use regex ; then
#			myargs+=" --no-regex"
#		fi
		if use rust \
			&& ! use system-rls ; then
			myargs+=" --rust-completer"
		fi
		if use system-boost ; then
			myargs+=" --system-boost"
		fi
		if use system-libclang ; then
			myargs+=" --system-libclang"
		fi
		if use typescript \
			&& ! use system-typescript ; then
			myargs+=" --ts-completer"
		fi
		if \
			! use system-boost \
			|| ! use system-clangd \
			|| ! use system-go-tools \
			|| ! use system-jedi \
			|| ! use system-libclang \
			|| ! use system-omnisharp-roslyn \
			|| ! use system-rls \
			|| ! use system-tern \
			|| ! use system-typescript ; then
			einfo "Path A: Running build.py"
			${EPYTHON} build.py ${myargs}
		elif use system-libclang ; then
			einfo "Path B: Running cmake-utils_src_compile"
			cmake-utils_src_compile
		fi
	}
	python_foreach_impl python_compile_all
}

src_test() {
	python_test_all() {
		local allowed_completers=""
		if use c || use cxx || use objc || use objcxx ; then
			allowed_completers+=" cfamily"
		fi
		if use csharp ; then
			allowed_completers+=" cs"
		fi
		if use java ; then
			allowed_completers+=" java"
		fi
		if use python ; then
			allowed_completers+=" python"
		fi
		if use typescript ; then
			allowed_completers+=" typescript"
		fi
		cd "${BUILD_DIR}" || die
		${EPYTHON} run_tests.py --skip-build --completers ${allowed_completers} || die
	}
	python_foreach_impl python_test_all
}

_shrink_install() {
	local arg_docs="-false"
	if use doc ; then
		arg_docs=' -ipath "*/*doc*/*"'
	fi
	local arg_developer="-false"
	if use developer ; then
		arg_developer=' -iname "*CODE_OF_CONDUCT*"'
		arg_developer+=' -o -iname "*CONTRIBUT*"'
		arg_developer+=' -o -iname "*TODO*"'
	fi
	local arg_legal=' -iname "*AUTHORS*"'
	arg_legal+=' -o -iname "*CHANGELOG*"'
	arg_legal+=' -o -iname "*COPYING*"'
	arg_legal+=' -o -iname "*COPYRIGHT*"'
	arg_legal+=' -o -iname "*HISTORY*"'
	arg_legal+=' -o -iname "*license*"'
	arg_legal+=' -o -iname "*PATENTS*"'
	arg_legal+=' -o -iname "*README*"'
	einfo "Cleaning third_party"
	find {third_party/bottle,third_party/jedi_deps,\
third_party/requests_deps,third_party/waitress,ycmd} \
		! \( -name "*.py" \
			-o -name "*.pyc" \
			-o -name "*.pyi" \
			-o -name "*.so" \
			-o -name "*.so.*" \
			-o -iname "default_settings.json" \
			-o -path "*/*.egg-info/*" \
			-o ${arg_docs} \
			-o ${arg_developer} \
			-o ${arg_legal} \) \
		-exec rm -f "{}" +
	rm -rf third_party/jedi_deps/jedi/scripts || die
	rm -rf third_party/bottle/plugins || die
	if use csharp \
		&& ! use system-omnisharp-roslyn ; then
		einfo "Cleaning omnisharp-roslyn"
		find third_party/omnisharp-roslyn \
			! \(	-name "*.dll" \
				-o -name "*.so" \
				-o -name "*.config" \
				-o -name "*.pdb" \
				-o -name "*.exe" \
				-o -name "config" \
				-o -name "run" \
				-o -name "machine.config" \
				-o ${arg_docs} \
				-o ${arg_developer} \
				-o ${arg_legal} \) \
			-exec rm -f "{}" +
		if ! use system-mono ; then
			rm -rf third_party/omnisharp-roslyn/{bin,lib,etc} || die
			# remove?
			#rm -rf third_party/omnisharp-roslyn/omnisharp/.msbuild || die
		fi
	fi
	if use regex \
		&& ! use system-mrab-regex ; then
		einfo "Cleaning regex"
		find third_party/cregex \
			!\( -name "*.so" \
				-o -path "*/*.egg-info/*" \
				-o -name "*.pyc" \
				-o -name "*.py" \
				-o ${arg_legal} \) \
			-exec rm -f "{}" +
	fi
	if use system-watchdog ; then
		einfo "Cleaning watchdog"
		rm -rf third_party/watchdog_deps/watchdog || die
	fi
	if use system-pathtools ; then
		einfo "Cleaning pathtools"
		rm -rf third_party/watchdog_deps/pathtools || die
	fi

	einfo "Cleaning out cpp build time files"
	rm -rf cpp || die

	if use go ; then
		einfo "Cleaning out go folders"
		find go ! \( -executable \
			-o ${arg_legal} \) \
			-exec rm "{}" +
	fi

	einfo "Cleaning out VCS, CI, testing"
	find . \( -name ".git*" \
			-o -name "azure" \
			-o -name "azure-pipelines.yml" \
			-o -name "_travis" \
		\) \
		-exec rm -rf "{}" +
	if use rust \
		&& ! use system-rls ; then
		rm -rf "third_party/rls/lib/rustlib/src/rust/src/stdarch/ci" \
			|| die
	fi

	einfo "Cleaning out installer files"
	find . \( -name "setup.py" \) \
		-exec rm -rf "{}" +

	einfo "Cleaning out completers"
	pushd ycmd/completers || die
		if ! use c ; then
			rm -rf c || die
		fi
		if ! use cxx ; then
			rm -rf cpp || die
		fi
		if ! use csharp ; then
			rm -rf cs || die
		fi
		if ! use cuda ; then
			rm -rf cuda || die
		fi
		if ! use go ; then
			rm -rf go || die
		fi
		if ! use java ; then
			rm -rf java || die
		fi
		if ! use javascript ; then
			rm -rf javascript || die
		fi
		if ! use objc ; then
			rm -rf objc || die
		fi
		if ! use objcxx ; then
			rm -rf objcpp || die
		fi
		if ! use python ; then
			rm -rf python || die
		fi
		if ! use rust ; then
			rm -rf rust || die
		fi
		if ! use typescript ; then
			rm -rf typescript typescriptreact || die
		fi
		if ! use vim ; then
			rm -rf general/ultisnips_completer.py || die
		fi
	popd

	einfo "Cleaning out test files"
	find . \( -name "conftest.py" \
			-o -name "test.py" \) \
		-delete
	if use javascript \
		&& ! use system-tern ; then
		rm -rf "third_party/tern_runtime/node_modules/tern/bin/test" \
			"third_party/tern_runtime/node_modules/errno/build.js" \
			|| die
	fi
	rm -rf third_party/requests_deps/urllib3/dummyserver || die
	rm -rf third_party/generic_server

	einfo "Cleaning out test folders"
	find {third_party,ycmd} -path "*/*test*/*" \
		-exec rm -rf "{}" +

	einfo "Cleaning out unused platforms"
	if use java ; then
		rm -rf \
		third_party/eclipse.jdt.ls/target/repository/config_{mac,win} \
		|| die
	fi

	einfo "Cleaning out cached archives"
	if use clangd \
		&& ! use system-clangd ; then
		rm -rf third_party/clangd/cache
	fi

	find . -empty -type f -delete
	find . -empty -type d -delete
}

src_install() {
	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	python_install_all() {
		cd "${BUILD_DIR}" || die
		BD_ABS="$(python_get_sitedir)/${BD_REL}"
		python_moduleinto "${BD_REL}"
		python_domodule CORE_VERSION
		exeinto "${BD_ABS}"
		doexe ycm_core.so
		if use system-omnisharp-roslyn \
			&& use csharp ; then
			exeinto "${BD_ABS}/ycmd/completers/cs/"
			doexe omnisharp.sh
		fi
		if use minimal ; then
			_shrink_install
		fi
		python_domodule ycmd
		insinto "/usr/share/${PN}-${PV_MAJ}"
		if use examples ; then
			doins -r examples
		fi

		python_moduleinto "${BD_REL}"

		if ! use system-libclang \
			&& ( use c || use cxx || use objc || use objcxx ) \
			&& use libclang ; then
			python_domodule lib
			fperms 755 "${BD_ABS}/lib/libclang.so.${CLANG_V_MAJ}"
			python_moduleinto "${BD_REL}/third_party"
			python_domodule third_party/clang
			fperms 755 "${BD_ABS}/third_party/clang/lib/libclang.so.${CLANG_V_MAJ}"
		else
			# prevent from raising exception
			sed -i -e "s|^CLANG_RESOURCE_DIR = GetClangResourceDir|#CLANG_RESOURCE_DIR = GetClangResourceDir|g" \
				"${ED}/${BD_ABS}/ycmd/utils.py" || die
		fi

		python_moduleinto "${BD_REL}/third_party"
		if use java ; then
			python_domodule third_party/eclipse.jdt.ls
		fi

		if ! use system-bottle ; then
			python_domodule third_party/bottle
		fi

		if ! use system-clangd \
			&& ( use c || use cxx || use objc || use objcxx ) \
			&& use clangd ; then
			python_domodule third_party/clangd
			fperms 755 \
				"${BD_ABS}/third_party/clangd/output/bin/clangd"
		fi

		if ! use system-mrab-regex \
			&& use regex ; then
			python_domodule third_party/cregex
			fperms 755 \
				"${BD_ABS}/third_party/cregex/regex_3/_regex.so"
		fi

		if ! use system-go-tools \
			&& use go ; then
			python_domodule third_party/go
			fperms 755 \
		"${BD_ABS}/third_party/go/bin/gopls"
		fi

		if ! use system-jedi \
			&& use python ; then
			python_domodule third_party/jedi_deps
		fi

		if ! use system-omnisharp-roslyn \
			&& use csharp ; then
			use system-mono && \
			eapply \
		"${FILESDIR}/${PN}-43_p20200516-omnisharp-use-system-omnisharp-run.patch"
			python_domodule third_party/omnisharp-roslyn
			fperms 755 \
		"${BD_ABS}/third_party/omnisharp-roslyn/bin/mono" \
		"${BD_ABS}/third_party/omnisharp-roslyn/run"
			fperms 755 \
		"${BD_ABS}/third_party/omnisharp-roslyn/omnisharp/"*.dll
			fperms 755 \
		"${BD_ABS}/third_party/omnisharp-roslyn/omnisharp/"*.so
		fi

		if ! use system-requests ; then
			python_domodule third_party/requests_deps
		fi

		if ! use system-rls \
			&& use rust ; then
			python_domodule third_party/rls

			local chost=$(get_abi_CHOST ${ABI})
			local arch="${chost%%-*}"
			local abi="${chost##*-}"
			fperms 755 \
"${BD_ABS}/third_party/rls/lib/rustlib/src/rust/src/libcore/unicode/printable.py" \
"${BD_ABS}/third_party/rls/lib/rustlib/${arch}-unknown-linux-${abi}/lib/" \
"${BD_ABS}/third_party/rls/lib/\
libLLVM-9-rust-1.44.0-nightly.so" \
"${BD_ABS}/third_party/rls/lib/\
librustc_driver-f47c73470ac1c2cb.so" \
"${BD_ABS}/third_party/rls/lib/\
librustc_macros-c9cb73ec8dd6b95d.so" \
"${BD_ABS}/third_party/rls/lib/\
libstd-0bccc96528cef91b.so" \
"${BD_ABS}/third_party/rls/lib/\
libtest-f4e0b559442209ef.so" \
"${BD_ABS}/third_party/rls/lib/rustlib/${arch}-unknown-linux-${abi}/lib/\
libLLVM-9-rust-1.44.0-nightly.so" \
"${BD_ABS}/third_party/rls/lib/rustlib/${arch}-unknown-linux-${abi}/lib/\
libtest-f4e0b559442209ef.so" \
"${BD_ABS}/third_party/rls/lib/rustlib/${arch}-unknown-linux-${abi}/lib/\
libstd-0bccc96528cef91b.so" \
"${BD_ABS}/third_party/rls/lib/rustlib/${arch}-unknown-linux-${abi}/bin/rust-lld" \
"${BD_ABS}/third_party/rls/bin/cargo" \
"${BD_ABS}/third_party/rls/bin/cargo-clippy" \
"${BD_ABS}/third_party/rls/bin/cargo-fmt" \
"${BD_ABS}/third_party/rls/bin/clippy-driver" \
"${BD_ABS}/third_party/rls/bin/rls" \
"${BD_ABS}/third_party/rls/bin/rustc" \
"${BD_ABS}/third_party/rls/bin/rustdoc" \
"${BD_ABS}/third_party/rls/bin/rustfmt" \
"${BD_ABS}/third_party/rls/bin/rust-gdb" \
"${BD_ABS}/third_party/rls/bin/rust-gdbgui" \
"${BD_ABS}/third_party/rls/bin/rust-lldb"
		fi

		if ! use system-tern \
			&& use javascript ; then
			python_domodule third_party/tern_runtime
			fperms 755 \
	"${BD_ABS}/third_party/tern_runtime/node_modules/errno/cli.js" \
	"${BD_ABS}/third_party/tern_runtime/node_modules/acorn/bin/acorn" \
	"${BD_ABS}/third_party/tern_runtime/node_modules/tern/bin/condense" \
	"${BD_ABS}/third_party/tern_runtime/node_modules/tern/bin/tern"
		fi

		if ! use system-typescript \
			&& use typescript ; then
			python_domodule third_party/tsserver
			fperms 755 \
"${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsc" \
"${BD_ABS}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
		fi

		if ! use system-waitress ; then
			python_domodule third_party/waitress
		fi
		#python_optimize
	}
	python_foreach_impl python_install_all

	if ! use system-libclang ; then
		cat <<-EOF > "${T}"/50${P}-ycmd-${SLOT}
			LDPATH="${BD_ABS}/lib"
		EOF
		doenvd "${T}"/50${P}-ycmd-${SLOT}
	fi

	if use doc ; then
		einstalldocs
	fi
	docinto licenses
	dodoc COPYING.txt
	if use developer ; then
		docinto developer
		dodoc CODE_OF_CONDUCT.md CONTRIBUTING.md DEBUG.md TESTS.md
	fi
	if [[ "${old_dotglob}" == "on" ]] ; then
		shopt -s dotglob
	else
		shopt -u dotglob
	fi
}

pkg_postinst() {
	local m=\
"Examples of the .json files can be found at:\n\
\n\
/usr/$(get_libdir)/python*/site-packages/${BD_REL}/ycmd/default_settings.json\n"

	if use c || use cxx || use objc || use objcxx ; then
		m+="\
\n\
You need to edit the global_ycm_extra_conf property in your .json file per\n\
project to the full path of the .ycm_extra_conf.py.\n\
\n\
Examples of the .ycm_extra_conf.py which should be defined per project can be\n\
found at:\n\
\n\
/usr/share/${PN}-${PV_MAJ}/examples/.ycm_extra_conf.py\n\
\n\
or\n\
\n\
https://github.com/ycm-core/ycmd/blob/master/.ycm_extra_conf.py\n\
\n\
Consider emerging ycm-generator to properly generate a .ycm_extra_conf.py\n\
which is mandatory for the c/c++/objc/objc++ completer.\n\
\n\
After generating it, it may need to be slightly modified.\n"
	fi

	if use csharp ; then
		m+="\
\n\
You need a .sln file in your project for C# support\n"
	fi

	if use javascript ; then
		m+="\
\n\
You need a .tern-project in your project for javascript support.\n"
	fi
	einfo "${m}"
}
