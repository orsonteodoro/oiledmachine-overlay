# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8} )
# slot 0 old hmac calculation, new one is
#	 426833360adec8db72ed6cef9d7aa7f037e6a5b8 of (ycmd/hmac_plugin.py)
# slot 1 racerd, gocode, godef
# slot 2 (racerd) -> (rls) ; (gocode, godef) -> (gopls)
SLOT="2"
USE_DOTNET="net472 netcoreapp21"
IUSE="c clangd csharp cuda cxx docs debug examples go java javascript libclang \
lsp minimal objc objcxx python regex rust system-bottle system-boost system-clangd \
system-go-tools system-jedi system-libclang system-lsp system-mrab-regex \
system-requests system-omnisharp-roslyn system-rls system-tern \
system-typescript system-waitress test typescript vim"
DOCS=( COPYING.txt JAVA_SUPPORT.md README.md )

CLANG_V="9.0"
inherit python-r1 dotnet
REQUIRED_USE="
	c? ( || ( clangd libclang ) )
	clangd? ( lsp )
	csharp? ( || ( ${USE_DOTNET} ) )
	cxx? ( || ( clangd libclang ) )
	go? ( lsp )
	java? ( lsp )
	objc? ( || ( clangd libclang ) )
	objcxx? ( || ( clangd libclang ) )
	rust? ( lsp )
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
	system-boost? ( >=dev-libs/boost-1.70.1:=[python,threads,${PYTHON_USEDEP}] )
	system-libclang? ( >=sys-devel/clang-${CLANG_V} )
	system-clangd? ( >=sys-devel/clang-${CLANG_V} )"
# gopls is 0.1.7
RDEPEND="${CDEPEND}
	>=dev-python/future-0.15.2_p20150911[${PYTHON_USEDEP}]
	java? ( virtual/jre:1.8 )
	javascript? ( net-libs/nodejs )
	system-bottle? ( >=dev-python/bottle-0.12.13[${PYTHON_USEDEP}] )
	system-go-tools? ( dev-go/go-tools )
	system-jedi? ( >=dev-python/jedi-0.15.0_p20190811[${PYTHON_USEDEP}]
			>=dev-python/numpydoc-0.9.0_p20190408[${PYTHON_USEDEP}]
			>=dev-python/parso-0.5.0_p20190620[${PYTHON_USEDEP}] )
	system-mrab-regex? ( >=dev-python/mrab-regex-2019.06.08_p20190725[${PYTHON_USEDEP}] )
	system-omnisharp-roslyn? ( >=dev-dotnet/omnisharp-roslyn-1.34.2[net472?,netcoreapp21?] )
	system-requests? ( >=dev-python/requests-2.20.1_p20181108[${PYTHON_USEDEP}] )
	system-rls? ( >=dev-lang/rust-1.35.0[rls] )
	system-tern? ( >=dev-nodejs/tern-0.21.0 )
	system-typescript? ( >=dev-lang/typescript-3.7.2 )
	system-waitress? ( >=dev-python/waitress-1.1.0_p20171010[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	javascript? ( net-libs/nodejs[npm] )
	typescript? ( net-libs/nodejs[npm] )
	lsp? ( net-libs/nodejs[npm] )
	test? ( >=dev-python/codecov-2.0.5[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.2[${PYTHON_USEDEP}]
		>=dev-python/flake8-3.0[${PYTHON_USEDEP}]
		=dev-python/flake8-comprehensions-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/flake8-ycm-0.1.0[${PYTHON_USEDEP}]
		=dev-python/future-0.15.2[${PYTHON_USEDEP}]
		>=dev-python/mock-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/nose-1.3.7[${PYTHON_USEDEP}]
		>=dev-python/nose-exclude-0.4.1[${PYTHON_USEDEP}]
		>=dev-python/ordereddict-1.1[${PYTHON_USEDEP}]
		!=dev-python/psutil-5.0.1[${PYTHON_USEDEP}]
		>=dev-python/psutil-3.3.0[${PYTHON_USEDEP}]
		>=dev-python/pyhamcrest-1.8.5[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0.20[${PYTHON_USEDEP}] )
		net-libs/nodejs[npm]"
EGIT_COMMIT="d3378ca3a3103535c14b104cb916dcbcdaf93eeb"
EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"

inherit cmake-utils eutils flag-o-matic git-r3
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	if \
	! use system-boost \
	|| ! use system-clangd \
	|| ! use system-go-tools \
	|| ! use system-jedi \
	|| ! use system-libclang \
	|| ! use system-omnisharp-roslyn \
	|| ! use system-rls \
	|| ! use system-tern \
	|| ! use system-typescript \
	|| use test ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to download\n\
the internal dependencies."
		fi
	fi
}

src_prepare() {
	default
	# Apply all patches

	# Required for deterministic build.
	eapply "${FILESDIR}/ycmd-42_p20200108-skip-thirdparty-check.patch"

	ewarn "This ebuild is a Work in Progress and may not work at all."
	if use go && ! use system-go-tools ; then
		ewarn "flaky go servers may prevent gopls from installing or existing.  Try again."
	fi

	if use clangd ; then
		ewarn "Clangd is experimental and not recommended at this time."
	fi

	if use system-libclang ; then
		eapply "${FILESDIR}/${PN}-9999.20170107-force-python-libs-path.patch"
		LIBCLANG_PATH=$(\
			ls /usr/lib/llvm/*/$(get_libdir)/libclang.so* | head -1)
		sed -i -e "s|\
EXTERNAL_LIBCLANG_PATH \${TEMP}|\
EXTERNAL_LIBCLANG_PATH \"${LIBCLANG_PATH}\"|g" \
			cpp/ycm/CMakeLists.txt || die
	fi
	CMAKE_USE_DIR="${S}/cpp" \
	cmake-utils_src_prepare

	if use system-go-tools ; then
		ewarn \
"The system-go-tools USE flag is untested for this version.  It's\n\
recommended to use the internal instead."
		eapply "${FILESDIR}/${PN}-42_p20200108-system-go.path"
		sed -i -e "s|GENTOO_GOPLS_BIN|/usr/bin/gopls|g" \
			ycmd/completers/go/go_completer.py || die
	fi

	if use system-omnisharp-roslyn ; then
		ewarn \
"The system-omnisharp-roslyn USE flag is untested for this version.  It's\n\
recommended to use the internal instead."

		eapply "${FILESDIR}/${PN}-42_p20200108-system-omnisharp-roslyn.path"
		eapply "${FILESDIR}/${PN}-42_p20200108-no-prepend-mono.patch"

		if use net472 ; then
			cp -a "${FILESDIR}/omnisharp.sh.netfx" \
				omnisharp.sh
			FRAMEWORK_FOLDER="net472"
			sed -i -e "s|\
GENTOO_OMNISHARP_ROSLYN_NETFX_PATH|\
/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" \
				omnisharp.sh
		elif use netcoreapp21 ; then
			cp -a "${FILESDIR}/omnisharp.sh.netcoreapp" \
				omnisharp.sh
			NETCORE_VERSION="2.1.0"
			FRAMEWORK_FOLDER="netcoreapp2.1"
			sed -i -e "s|\
GENTOO_DOTNET_CLI_NETCOREAPP_PATH|\
/opt/dotnet_cli/shared/Microsoft.NETCore.App/${NETCORE_VERSION}|g" \
				omnisharp.sh
			sed -i -e "s|\
GENTOO_OMNISHARP_ROSLYN_NETCOREAPP_PATH|\
/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" \
				omnisharp.sh
		fi
	fi

	if use rust ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-system-rust.path"
		sed -i -e "s|GENTOO_RUST_BIN|/usr/bin/rustc|g" \
			ycmd/completers/rust/rust_completer.py || die
		sed -i -e "s|GENTOO_RLS_BIN|/usr/bin/rls|g" \
			ycmd/completers/rust/rust_completer.py || die
	else
		ewarn \
"Using the internal rust.  You are responsible for maintaining the security\n\
of the rust micropackages those built with them."
	fi

	if use system-tern ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-system-tern.path"
		sed -i -e "s|GENTOO_TERN_BIN|/usr/bin/tern|g" \
			ycmd/completers/javascript/tern_completer.py || die
	fi

	cp "${FILESDIR}/default_settings.json" \
		ycmd/default_settings.json || die

	if ! use vim ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-remove-ultisnips.patch"
		sed -i -e 's|"use_ultisnips_completer": 1,||g' \
			ycmd/default_settings.json || die
	fi

	python_copy_sources
	python_prepare_all() {
		cd "${BUILD_DIR}" || die
		if use system-omnisharp-roslyn ; then
			sed -i -e "s|\
GENTOO_OMNISHARP_BIN|\
/usr/$(get_libdir)/${EPYTHON}/site-packages/ycmd/completers/cs/omnisharp.sh|g" \
				ycmd/completers/cs/cs_completer.py || die
		fi
		sed -i -e "s|\
GENTOO_PYTHON_LIBRARY_PATH|\
/usr/$(get_libdir)/lib${EPYTHON}.so|g" \
			build.py
		sed -i -e "s|\
HFJ1aRMhtCX/DMYWYkUl9g==|\
$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" \
			ycmd/default_settings.json
		sed -i -e "s|/usr/bin/python3.6|/usr/bin/${EPYTHON}|g" \
			ycmd/default_settings.json
	}
	python_foreach_impl python_prepare_all
}


src_configure() {
	if use developer ; then
		DOCS+=( CODE_OF_CONDUCT.md CONTRIBUTING.md )
	fi
	python_configure_all()
	{
		strip-flags -O0 -O1 -O3 -O4
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
		if ! use regex ; then
			myargs+=" --no-regex"
		fi
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
		cd "${BUILD_DIR}"
		${EPYTHON} run_tests.py || die
	}
	python_foreach_impl python_test_all
}

_shrink_install() {
	local arg_docs="-false"
	if use docs ; then
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
	find {third_party/bottle,third_party/jedi_deps,third_party/requests_deps,third_party/waitress,ycmd} \
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
				-o ${arg_docs} \
				-o ${arg_developer} \
				-o ${arg_legal} \) \
			-exec rm -f "{}" +
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
	if use system-go-tools ; then
		einfo "Cleaning go-tools"
		find cpp ! \(	-executeable \
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
		rm -rf "third_party/rls/lib/rustlib/src/rust/src/stdarch/ci" || die
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
		if ! use lsp ; then
			rm -rf language_server || die
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
			"third_party/tern_runtime/node_modules/errno/build.js" || die
	fi
	rm -rf third_party/requests_deps/urllib3/dummyserver || die

	einfo "Cleaning out test folders"
	find {third_party,ycmd} -path "*/*test*/*" \
		-exec rm -rf "{}" +

	einfo "Cleaning out unused platforms"
	if use java ; then
		rm -rf third_party/eclipse.jdt.ls/target/repository/config_{mac,win} || die
	fi

	find . -empty -type f -delete
	find . -empty -type d -delete
}

src_install() {
	python_install_all() {
		cd "${BUILD_DIR}" || die
		local bd="$(python_get_sitedir)/ycmd/${SLOT}"
		python_moduleinto ycmd
		python_domodule CORE_VERSION
		exeinto "${bd}"
		doexe ycm_core.so
		if use system-omnisharp-roslyn \
			&& use csharp ; then
			exeinto "${bd}/ycmd/completers/cs/"
			doexe omnisharp.sh
		fi
		if use minimal ; then
			_shrink_install
		fi
		python_domodule ycmd/${SLOT}
		insinto "/usr/share/${PN}"
		if use examples ; then
			doins -r examples
		fi

		python_moduleinto "ycmd/${SLOT}/third_party"
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
		fi

		if ! use system-mrab-regex \
			&& use regex ; then
			python_domodule third_party/cregex
		fi

		if ! use system-libclang \
			&& ( use c || use cxx || use objc || use objcxx ) \
			&& use libclang ; then
			python_domodule third_party/clang
			fperms 755 "${bd}/third_party/clang/lib/libclang.so.8"
		fi

		if ! use system-lsp \
			&& use lsp ; then
			python_domodule third_party/generic_server
		fi

		if ! use system-go-tools \
			&& use go ; then
			python_domodule third_party/go
			fperms 755 \
		"${bd}/third_party/go/src/golang.org/x/tools/cmd/gopls/gopls"
		fi

		if ! use system-jedi \
			&& use python ; then
			python_domodule third_party/jedi_deps
		fi

		if ! use system-omnisharp-roslyn \
			&& use csharp ; then
			python_domodule third_party/omnisharp-roslyn
		fi

		if ! use system-requests ; then
			python_domodule third_party/requests_deps
		fi

		if ! use system-rls \
			&& use rust ; then
			python_domodule third_party/rls

			local arch=""
			if [[ "${ABI}" == x86 ]] ; then
				arch="i686"
			elif [[ "${ABI}" == amd64 ]] ; then
				arch="x86_64"
			else
				die \
"This ABI (${ABI}) is currently not supported as an internal Rust\
dependency.  Contact the ebuild maintainer or use the system-rls USE flag."
			fi

			fperms 755 \
			"${bd}/third_party/rls/lib/rustlib/src/rust/src/libcore/unicode/printable.py" \
			"${bd}/third_party/rls/lib/rustlib/src/rust/src/libcore/unicode/unicode.py" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/codegen-backends/librustc_codegen_llvm-emscripten.so" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/codegen-backends/librustc_codegen_llvm-llvm.so" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/lib/librustc_driver-859926a7780138cb.so" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/lib/librustc_macros-1ea7012aad3f78b4.so" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/lib/libstd-763271b142020d6a.so" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/lib/libtest-73f108977db97b26.so" \
			"${bd}/third_party/rls/lib/rustlib/${arch}-unknown-linux-gnu/bin/rust-lld" \
			"${bd}/third_party/rls/bin/cargo-clippy" \
			"${bd}/third_party/rls/bin/rustfmt" \
			"${bd}/third_party/rls/bin/rls" \
			"${bd}/third_party/rls/bin/rust-gdb" \
			"${bd}/third_party/rls/bin/rustdoc" \
			"${bd}/third_party/rls/bin/rustc" \
			"${bd}/third_party/rls/bin/clippy-driver" \
			"${bd}/third_party/rls/bin/rust-gdbgui" \
			"${bd}/third_party/rls/bin/rust-lldb" \
			"${bd}/third_party/rls/bin/cargo-fmt" \
			"${bd}/third_party/rls/bin/cargo"
		fi

		if ! use system-tern \
			&& use javascript ; then
			python_domodule third_party/tern_runtime
			fperms 755 \
			"${bd}/third_party/tern_runtime/node_modules/errno/cli.js" \
			"${bd}/third_party/tern_runtime/node_modules/acorn/bin/acorn" \
			"${bd}/third_party/tern_runtime/node_modules/tern/bin/condense" \
			"${bd}/third_party/tern_runtime/node_modules/tern/bin/tern"
		fi

		if ! use system-typescript \
			&& use typescript ; then
			python_domodule third_party/tsserver
			fperms 755 \
			"${bd}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsc" \
			"${bd}/third_party/tsserver/$(get_libdir)/node_modules/typescript/bin/tsserver"
		fi

		if ! use system-waitress ; then
			python_domodule third_party/waitress
		fi
		python_optimize
	}
	python_foreach_impl python_install_all
}

pkg_postinst() {
	local m=\
"Examples of the .json files can be found at targeting particular python\n\
version:\n\
\n\
/usr/$(get_libdir)/python*/site-packages/ycmd/default_settings.json\n"

	if use c || use cxx || use objc || use objcxx ; then
		m+="\
\n\
You need to edit the global_ycm_extra_conf property in your .json file per\n\
project to the full path of the .ycm_extra_conf.py.\n\
\n\
Examples of the .ycm_extra_conf.py which should be defined per project can be\n\
found at:\n\
\n\
/usr/share/${PN}/examples/.ycm_extra_conf.py\n\
\n\
or\n\
\n\
https://github.com/ycm-core/ycmd/blob/master/.ycm_extra_conf.py
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
