# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python{3_6,3_7,3_8} )
SLOT="0/${PV}"
USE_DOTNET="net472 netcoreapp21"
IUSE="c cxx clangd csharp debug go java javascript libclang lsp objc objcxx \
python regex rust system-bottle system-boost system-libclang system-clangd \
system-go system-jedi system-lsp system-mrab-regex system-requests \
system-omnisharp-roslyn system-rls system-tern system-typescript \
system-waitress test typescript"

CLANG_V="9.0"
inherit python-r1 dotnet
REQUIRED_USE="
	system-clangd? ( || ( c cxx objc objcxx ) )
	system-go? ( go )
	system-jedi? ( python )
	system-libclang? ( || ( c cxx objc objcxx ) )
	system-mrab-regex? ( regex )
	system-omnisharp-roslyn? ( csharp || ( ${USE_DOTNET} ) )
	system-rls? ( rust )
	system-tern? ( javascript )"
# Versions must match
# https://github.com/ycm-core/ycmd/blob/master/cpp/BoostParts/boost/version.hpp
CDEPEND="${PYTHON_DEPS}
	system-boost? ( >=dev-libs/boost-1.70.1[python,threads,${PYTHON_USEDEP}] )
	system-libclang? ( >=sys-devel/clang-${CLANG_V} )
	system-clangd? ( >=sys-devel/clang-${CLANG_V} )"
# gopls is 0.1.7
RDEPEND="${CDEPEND}
	>=dev-python/future-0.15.2_p20150911[${PYTHON_USEDEP}]
	go? ( dev-go/go-tools )
	java? ( virtual/jre:1.8 )
	javascript? ( net-libs/nodejs )
	rust? ( >=dev-lang/rust-1.35.0 )
	system-bottle? ( >=dev-python/bottle-0.12.13[${PYTHON_USEDEP}] )
	system-jedi? ( >=dev-python/jedi-0.15.0_p20190811
			>=dev-python/numpydoc-0.9.0_p20190408
			>=dev-python/parso-0.5.0_p20190620 )
	system-mrab-regex? ( >=dev-python/mrab-regex-2019.06.08_p20190725 )
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
		>=dev-python/webtest-2.0.20[${PYTHON_USEDEP}] )"
EGIT_COMMIT="38bb02f369d21207c3e7512d005287ff07e143ae"
EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"

# lock down for a deterministic build
#EGIT_OVERRIDE_COMMIT_YCM_CORE_YCMD="38bb02f369d21207c3e7512d005287ff07e143ae"
EGIT_OVERRIDE_COMMIT_DEFNULL_BOTTLE="7423aa0f64e381507d1e06a6bcab48888baf9a7b"
EGIT_OVERRIDE_COMMIT_PYLONS_WAITRESS="7bb27bb66322fc564e14005d29cb6fddd76a0ab6"
EGIT_OVERRIDE_COMMIT_REQUESTS_REQUESTS="6cfbe1aedd56f8c2f9ff8b968efe65b22669795b"
EGIT_OVERRIDE_COMMIT_DAVIDHALTER_JEDI="35e5cf2c2aa7c2f2c8ea08d74ef64f681582e49e"
EGIT_OVERRIDE_COMMIT_DAVIDHALTER_TYPESHED="3319cadf85012328f8a12b15da4eecc8de0cf305"
EGIT_OVERRIDE_COMMIT_NUMPY_NUMPYDOC="c8513c5db6088a305711851519f944b33f7e1b25"
EGIT_OVERRIDE_COMMIT_SCIPY_SCIPY_SPHINX_THEME="bc3b4b8383d4cd676fe75b7ca8c3e11d6afa8d97"
EGIT_OVERRIDE_COMMIT_DAVIDHALTER_PARSO="59df3fab4358d5889556c2450c2d1deb36facdb7"
EGIT_OVERRIDE_COMMIT_YCM_CORE_REGEX="cc538bb6d0fcf0a6411537a5522d13cc9b86789d"
EGIT_OVERRIDE_COMMIT_URLLIB3_URLLIB3="a6ec68a5c5c5743c59fe5c62c635c929586c429b"
EGIT_OVERRIDE_COMMIT_CHARDET_CHARDET="9b8c5c2fb118d76c6beeab9affd01c332732a530"
EGIT_OVERRIDE_COMMIT_CERTIFI_PYTHON_CERTIFI="5b9e05c06e69fe5c7835052cfc3ae1c899dfc8b1"
EGIT_OVERRIDE_COMMIT_KJD_IDNA="0f50bdcea71e6602bf4cd22897970d71fc4074d9"
EGIT_OVERRIDE_COMMIT_GOLANG_TOOLS="58d531046acdc757f177387bc1725bfa79895d69"

inherit cmake-utils eutils flag-o-matic git-r3
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"

pkg_setup() {
	if \
	! use system-boost \
	|| ! use system-clangd \
	|| ! use system-go \
	|| ! use system-jedi \
	|| ! use system-libclang \
	|| ! use system-omnisharp-roslyn \
	|| ! use system-rls \
	|| ! use system-tern \
	|| ! use system-typescript ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to download\n\
the internal dependencies."
		fi
	fi
}

src_prepare() {
	default
	ewarn "This ebuild is a Work in Progress and may not work at all."

	# Apply all patches

	# Required for deterministic build.
	eapply "${FILESDIR}/ycmd-42_p20200108-skip-thirdparty-check.patch"

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

	if use system-go ; then
		ewarn \
"The system-go USE flag is untested for this version.  It's\n\
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
			&& ! use system-go ; then
			myargs+=" --go-completer"
		fi
		if use java ; then
			myargs+=" --java-completer"
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
		if use typescript ; then
			myargs+=" --ts-completer"
		fi
		if \
			! use system-boost \
			|| ! use system-clangd \
			|| ! use system-go \
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
		${EPYTHON} run_tests.py || die
	}
	python_foreach_impl python_test_all
}

src_install() {
	python_install_all() {
		cd "${BUILD_DIR}" || die
		dodir "$(python_get_sitedir)/ycmd"
		insinto "$(python_get_sitedir)"
		doins ycm_core.so
		insinto "$(python_get_sitedir)/ycmd"
		doins CORE_VERSION cpp/ycm/.ycm_extra_conf.py
		if use system-omnisharp-roslyn \
			&& use csharp ; then
			cp -a omnisharp.sh "ycmd/completers/cs/"
		fi
		rm -rf "ycmd/tests" || die
		python_domodule ycmd
		if use system-omnisharp-roslyn \
			&& use csharp ; then
			fperms 755 \
			"$(python_get_sitedir)/ycmd/completers/cs/omnisharp.sh"
		fi
		insinto "$(python_get_sitedir)"
		doins -r clang_includes cpp libclang.so.$(ver_cut 1 ${CLANG_V})*

		insinto "$(python_get_sitedir)/third_party"
		if ! use system-bottle ; then
			doins -r third_party/bottle
		fi

		if ! use system-clangd \
			&& ( use c || use cxx || use objc || use objcxx ) ; then
			doins -r third_party/clangd
		fi

		if ! use system-mrab-regex \
			&& use regex ; then
			doins -r third_party/cregex
		fi

		if ! use system-libclang \
			&& ( use c || use cxx || use objc || use objcxx ) ; then
			doins -r third_party/clang
		fi

		if ! use system-lsp \
			&& use lsp ; then
			doins -r third_party/generic_server
		fi

		if ! use system-go \
			&& use go ; then
			doins -r third_party/go
		fi

		if ! use system-jedi \
			&& use python ; then
			doins -r third_party/jedi_deps
		fi

		if ! use system-omnisharp-roslyn \
			&& use csharp ; then
			doins -r third_party/omnisharp-roslyn
		fi

		if ! use system-requests ; then
			doins -r third_party/requests_deps
		fi

		if ! use system-rls \
			&& use rust ; then
			doins -r third_party/rls
		fi

		if ! use system-tern \
			&& use javascript ; then
			doins -r third_party/turn_runtime
		fi

		if ! use system-waitress ; then
			doins -r third_party/waitress
		fi
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
/usr/$(get_libdir)/python*/site-packages/ycmd/.ycm_extra_conf.py\n\
\n\
Consider emerging ycm-generator to properly generate a .ycm_extra_conf.py\n\
which is mandatory for c/c++/objc/objc++.\n\
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
