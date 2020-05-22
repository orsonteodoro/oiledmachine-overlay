# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE="https://ycm-core.github.io/ycmd/"
# The Ms-PL license doesn't contain all rights reserved but it is stated in the source code
LICENSE="GPL-3+ BSD
	csharp? ( !system-omnisharp? ( all-rights-reserved MIT Ms-PL ) )
	examples? ( Apache-2.0 )
	go? ( !system-gocode? ( MIT ) )
	go? ( !system-godef? ( BSD ) )
	java? ( Apache-1.1 Apache-2.0 BSD BSD-2 BSD-4 CPL-1.0 dom4j EPL-2.0 icu MPL-1.1 NAIST-IPADIC unicode W3C W3C-document )
	javascript? ( !system-tern? ( MIT ) )
	libclang? ( !system-libclang? ( Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA ) )
	regex? ( system-mrab-regex? ( all-rights-reserved CNRI PSF-2 ) )
	rust? ( !system-racerd? ( Apache-2.0 MIT Unlicense ) )
	python? ( !system-jedi? ( MIT PSF-2 ) )
	!system-bottle? ( MIT )
	!system-frozendict? ( MIT )
	!system-future? ( MIT )
	!system-libclang? ( Apache-2.0-with-LLVM-exceptions MIT UoI-NCSA )
	!system-requests? ( Apache-2.0 )
	!system-waitress? ( ZPL )
	test? ( Apache-2.0 GPL-3+ )"
KEYWORDS="~amd64 ~arm ~arm64 ~mips ~mips64 ~ppc ~ppc64 ~x86"
PYTHON_COMPAT=( python3_{6,7,8} )
# slot 0 old hmac calculation, new one is
#	 426833360adec8db72ed6cef9d7aa7f037e6a5b8 of (ycmd/hmac_plugin.py)
# slot 1 racerd, (gocode, godef); python 2.x or 3.x ; compatible with current
#        (20200201) emacs-ycmd, nano-ycmd, gycm
# slot 2 (racerd) -> (rls) ; (gocode, godef) -> (gopls) ; python 3 only
SLOT="1"
USE_DOTNET="net40"
IUSE="c csharp cuda cxx debug doc examples go java javascript libclang \
minimal objc objcxx python regex rust system-bottle system-boost \
system-frozendict system-future system-gocode system-godef system-jedi \
system-libclang system-mrab-regex system-requests system-omnisharp \
system-racerd system-rust system-tern system-typescript system-waitress test \
typescript vim"
IUSE+=" ${USE_DOTNET}"
CLANG_V="6.0"
CLANG_V_MAJ=$(ver_cut 1 ${CLANG_V})
PV_MAJ=$(ver_cut 1 ${PV})
inherit python-r1
REQUIRED_USE="
	c? ( libclang )
	csharp? ( || ( ${USE_DOTNET} ) )
	cxx? ( libclang )
	objc? ( libclang )
	objcxx? ( libclang )
	system-gocode? ( go system-godef )
	system-godef? ( go system-gocode )
	system-jedi? ( python )
	system-libclang? ( || ( c cxx objc objcxx ) libclang )
	system-mrab-regex? ( regex )
	system-omnisharp? ( csharp )
	system-racerd? ( rust )
	system-tern? ( javascript )
	typescript? ( system-typescript )"
# Versions must match
# https://github.com/ycm-core/ycmd/blob/master/cpp/BoostParts/boost/version.hpp
CDEPEND="${PYTHON_DEPS}
	system-boost? ( >=dev-libs/boost-1.68.0:=[python,threads,${PYTHON_USEDEP}] )
	system-libclang? ( sys-devel/clang:${CLANG_V_MAJ} )"
RDEPEND="${CDEPEND}
	java? ( virtual/jre:1.8 )
	javascript? ( net-libs/nodejs )
	system-bottle? ( >=dev-python/bottle-0.12.13[${PYTHON_USEDEP}] )
	system-frozendict? ( >=dev-python/frozendict-0.3 )
	system-future? ( >=dev-python/future-0.15.2[${PYTHON_USEDEP}] )
	system-gocode? ( >=dev-go/gocode-9999_p20170425 )
	system-godef? ( >=dev-go/godef-9999_p20170920 )
	system-jedi? ( >=dev-python/jedi-0.12.0_p20180620[${PYTHON_USEDEP}]
			>=dev-python/parso-0.2.1[${PYTHON_USEDEP}] )
	system-mrab-regex? ( >=dev-python/mrab-regex-2.4.140[${PYTHON_USEDEP}] )
	system-omnisharp? ( >=dev-dotnet/omnisharp-1.0.0.0_p20150829[net40] )
	system-requests? ( >=dev-python/requests-2.9.1[${PYTHON_USEDEP}] )
	system-racerd? ( >=dev-rust/racerd-2.1.0 )
	system-tern? ( >=dev-nodejs/tern-0.21.0 )
	system-typescript? ( >=dev-lang/typescript-1.5 )
	system-waitress? ( >=dev-python/waitress-1.1.0[${PYTHON_USEDEP}] )"
DEPEND="${CDEPEND}
	javascript? ( net-libs/nodejs[npm] )
	typescript? ( net-libs/nodejs[npm] )
	test? ( >=dev-python/coverage-4.2[${PYTHON_USEDEP}]
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
		>=dev-python/unittest2-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/webtest-2.0.20[${PYTHON_USEDEP}] )
		net-libs/nodejs[npm]"
EGIT_COMMIT="386915288616fddcc60a46b49e6c6e71a118542b"
EGIT_REPO_URI="https://github.com/ycm-core/ycmd.git"
inherit cmake-utils eutils flag-o-matic git-r3
S="${WORKDIR}/${PN}-${PV}"
RESTRICT="mirror"
DOCS=( JAVA_SUPPORT.md README.md )
BD_REL="ycmd/${SLOT}"
BD_ABS=""

pkg_setup() {
	if ! use system-boost ; then
		ewarn "Using internal boost my have vulnerabilities."
	fi
	if \
	! use system-boost \
	|| ! use system-gocode \
	|| ! use system-godef \
	|| ! use system-libclang \
	|| ! use system-omnisharp \
	|| ! use system-racerd \
	|| ! use system-tern \
	|| ! use system-typescript \
	|| use test ; then
		if has network-sandbox $FEATURES ; then
			die \
"FEATURES=\"-network-sandbox\" must be added per-package env to be able to\n\
download the internal dependencies."
		fi
	fi

	ewarn \
"This version of ycmd is near EOL on this repo.  It will be removed once all\n\
clients are updated to be compatible with the latest."
	python_setup
	BD_ABS="$(python_get_sitedir)/${BD_REL}"
}

src_prepare() {
	default
	local sitedir="$(python_get_sitedir)"
	local ycmd_sitedir="${sitedir}/ycmd/"

	# Required for deterministic build.
	eapply "${FILESDIR}/${PN}-42_p20200108-skip-thirdparty-check.patch"

	ewarn "This ebuild is a Work in Progress and may not work at all."

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

	cat "${FILESDIR}/default_settings.json.39_p20180821" \
		> ycmd/default_settings.json || die

	if use system-godef && use system-gocode ; then
		ewarn \
"The system-godef and system-gocode USE flag is untested for this version.\n\
It's recommended to use the internal instead."
		eapply "${FILESDIR}/${PN}-39_p20180821-system-go.patch"
	fi

	if use system-gocode ; then
		sed -i -e "s|___GOCODE_BIN_PATH___|/usr/bin/gocode|g" \
			ycmd/default_settings.json || die
	else
		sed -i -e "s|\
___GOCODE_BIN_PATH___|\
${BD_ABS}/third_party/gocode/gocode|g" \
			ycmd/default_settings.json || die
	fi

	if use system-godef ; then
		sed -i -e "s|___GODEF_BIN_PATH___|/usr/bin/godef|g" \
			ycmd/default_settings.json || die
	else
		sed -i -e "s|\
___GODEF_BIN_PATH___|\
${BD_ABS}/third_party/godef/godef|g" \
			ycmd/default_settings.json || die
	fi

	if use system-mrab-regex ; then
		eapply "${FILESDIR}/${PN}-39_p20180821-flatten-regex-path.patch"

		ewarn "Using system-mrab-regex is WIP"
		sed -i -e "s|\
p.join\( DIR_OF_CURRENT_SCRIPT, '..', 'third_party', 'cregex', 'regex_{}'.format\( sys.version_info\[ 0 \] \) \)|\
${sitedir}/regex|g" \
			ycmd/server_utils.py || die
		sed -i -e "s|  BuildRegexModule|  #BuildRegexModule|" \
			build.py || die
	fi

	if use system-omnisharp ; then
		ewarn \
"The system-omnisharp USE flag is untested for this version.  It's\n\
recommended to use the internal instead."

		eapply "${FILESDIR}/${PN}-39_p20180821-system-omnisharp.patch"

		if use net40 ; then
			cp -a "${FILESDIR}/omnisharp.sh.netfx" \
				omnisharp.sh || die
			FRAMEWORK_FOLDER="net472"
			sed -i -e "s|\
___OMNISHARP_DIR_PATH___|\
/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g" \
				omnisharp.sh || die

		fi
		sed -i -e "s|\
___OMNISHARP_BIN_ABSPATH___|\
${BD_ABS}/ycmd/completers/cs/omnisharp.sh|g" \
			ycmd/completers/cs/cs_completer.py || die
	fi

	if use system-racerd ; then
		eapply "${FILESDIR}/${PN}-39_p20180821-system-rust.patch"
		sed -i -e "s|___RACERD_BIN_ABSPATH___|/usr/bin/racerd|g" \
			ycmd/completers/rust/rust_completer.py || die
	else
		ewarn \
"Using the internal rust.  You are responsible for maintaining the security\n\
of internal rust and associated packages."
	fi
	sed -i -e "s|___RUST_SRC_PATH___|/usr/share/rust/src|g" \
		ycmd/default_settings.json || die

	if use system-tern ; then
		eapply "${FILESDIR}/${PN}-42_p20200108-system-tern.patch"
		sed -i -e "s|___TERN_BIN_PATH___|/usr/bin/tern|g" \
			ycmd/completers/javascript/tern_completer.py || die
	else
		sed -i -e "s|\
___TERN_BIN_PATH___|\
${BD_ABS}/third_party/tern_runtime/tern|g" \
			ycmd/completers/javascript/tern_completer.py || die
	fi

	if use system-racerd ; then
		sed -i -e "s|___RACERD_BIN_PATH___|/usr/bin/racerd|g" \
			ycmd/default_settings.json || die
	else
		sed -i -e "s|\
___RACERD_BIN_PATH___|\
${BD_ABS}/third_party/racerd/racerd|g" \
			ycmd/default_settings.json || die
	fi

	if ! use vim ; then
		eapply "${FILESDIR}/${PN}-39_p20180821-remove-ultisnips.patch"
		sed -i -e 's|"use_ultisnips_completer": 1,||g' \
			ycmd/default_settings.json || die
	fi

	sed -i -e "s|\
___HMAC_SECRET___|\
$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" \
		ycmd/default_settings.json || die

	sed -i -e "s|___PYTHON_BIN_PATH___|/usr/bin/${EPYTHON}|g" \
		ycmd/default_settings.json || die

	sed -i -e "s|\
___PYTHON_LIB_PATH___|\
/usr/$(get_libdir)/lib${EPYTHON}.so|g" \
		build.py || die

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
			if use libclang ; then
				myargs+=" --clang-completer"
			fi
		fi
		if use csharp \
			&& ! use system-omnisharp ; then
			myargs+=" --cs-completer"
		fi
		if use debug ; then
			myargs+=" --enable-debug"
		fi
		if use go \
			&& ! use system-gocode \
			&& ! use system-godef \
			 ; then
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
			&& ! use system-racerd ; then
			myargs+=" --rust-completer"
		fi
		if use system-boost ; then
			myargs+=" --system-boost"
		fi
		if use system-libclang ; then
			myargs+=" --system-libclang"
		fi
#		if use typescript \
#			&& ! use system-typescript ; then
#			myargs+=" --ts-completer"
#		fi
		if \
			! use system-boost \
			|| ! use system-gocode \
			|| ! use system-godef \
			|| ! use system-jedi \
			|| ! use system-libclang \
			|| ! use system-omnisharp \
			|| ! use system-rust \
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
	find {third_party/bottle,third_party/frozendict,third_party/jedi,\
third_party/parso,third_party/python-future,third_party/requests,\
third_party/waitress,ycmd} \
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
	rm -rf third_party/jedi/scripts || die
	rm -rf third_party/bottle/plugins || die
	if use csharp \
		&& ! use system-omnisharp ; then
		einfo "Cleaning OmniSharp"
		find third_party/OmniSharpServer \
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

	einfo "Cleaning out cpp build time files"
	rm -rf cpp || die

	if use go ; then
		einfo "Cleaning out go folders"
		find gocode godef ! \(	-executable \
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

	einfo "Cleaning out installer files"
	find . \( -name "setup.py" \) \
		-exec rm -rf "{}" +
	if use rust \
		&& ! use system-racerd ; then
		einfo "Cleaning racerd"
		rm -rf "third_party/racerd/"{appveyor.yml,Cargo.lock,Cargo.toml}
		rm -rf "third_party/racerd/"{scripts,src,tests}
	fi

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
	rm -rf third_party/requests/urllib3/dummyserver || die

	einfo "Cleaning out test folders"
	find {third_party,ycmd} -path "*/*test*/*" \
		-exec rm -rf "{}" +

	einfo "Cleaning out unused platforms"
	if use java ; then
		rm -rf \
	third_party/eclipse.jdt.ls/target/repository/config_{mac,win} || die
	fi

	find . -empty -type f -delete
	find . -empty -type d -delete
}

src_install() {
	local old_dotglob=$(shopt dotglob | cut -f 2)
	shopt -s dotglob # copy hidden files
	python_install_all() {
		cd "${BUILD_DIR}" || die
		python_moduleinto "${BD_REL}"
		python_domodule CORE_VERSION
		exeinto "${BD_ABS}"
		doexe ycm_core.so
		if use system-omnisharp \
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
			python_domodule lib clang_includes
			fperms 755 "${BD_ABS}/lib/libclang.so.${CLANG_V}"
		fi

		python_moduleinto "${BD_REL}/third_party"
		if ! use system-frozendict ; then
			python_domodule third_party/frozendict
		fi
		if ! use system-future ; then
			python_domodule third_party/python-future
		fi
		if use java ; then
			python_domodule third_party/eclipse.jdt.ls
		fi

		if ! use system-bottle ; then
			python_domodule third_party/bottle
		fi

		if ! use system-mrab-regex \
			&& use regex ; then
			python_domodule third_party/cregex
		fi

		if ! use system-gocode \
			&& use go ; then
			python_domodule third_party/gocode
			fperms 755 \
		"${BD_ABS}/third_party/gocode/gocode"
		fi

		if ! use system-godef \
			&& use go ; then
			python_domodule third_party/godef
			fperms 755 \
		"${BD_ABS}/third_party/godef/godef"
		fi

		if ! use system-jedi \
			&& use python ; then
			python_domodule third_party/jedi \
				third_party/parso
		fi

		if ! use system-omnisharp \
			&& use csharp ; then
			python_domodule third_party/OmniSharpServer
		fi

		if ! use system-requests ; then
			python_domodule third_party/requests
		fi

		if ! use system-rust \
			&& use rust ; then
			python_domodule third_party/racerd
			fperms 755 \
			third_party/racerd/target/release/racerd
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
		python_optimize

		doins COPYING.txt
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
"Examples of the .json files can be found at targeting particular python\n\
version:\n\
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
