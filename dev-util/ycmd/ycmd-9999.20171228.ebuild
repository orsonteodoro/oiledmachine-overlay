# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit eutils python-r1 cmake-utils flag-o-matic

DESCRIPTION="A code-completion & code-comprehension server"
HOMEPAGE=""
COMMIT="e5d696e9b58729d89df60fadebc15fc38e18c466"
SRC_URI="https://github.com/Valloric/ycmd/archive/${COMMIT}.zip -> ${P}.zip"
KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-3"

IUSE="system-boost system-clang csharp omnisharp-server omnisharp-roslyn go javascript rust c++ c objc objc++ python typescript debug tests net46 net45 netcore10"
REQUIRED_USE="system-clang system-clang? ( || ( c c++ objc objc++ ) ) csharp? ( ^^ ( omnisharp-server omnisharp-roslyn ) ) omnisharp-roslyn? (  ^^ ( net46 netcore10 ) ) omnisharp-server? ( net45 ) ^^ ( net45 net46 netcore10 )"

COMMON_DEPEND="
	${PYTHON_DEPS}
	system-clang? ( >=sys-devel/clang-5.0 )
	system-boost? ( >=dev-libs/boost-1.63.0[python,threads,${PYTHON_USEDEP}] )
"
RDEPEND="
	${COMMON_DEPEND}
	python? ( >=dev-python/jedihttp-9999.20171217[${PYTHON_USEDEP}] )
	csharp? ( omnisharp-server? ( dev-dotnet/omnisharp-server )
		  omnisharp-roslyn? ( dev-dotnet/omnisharp-roslyn[net46] )
                )
	dev-python/argparse[${PYTHON_USEDEP}]
	>=dev-python/bottle-0.12.7[${PYTHON_USEDEP}]
	dev-python/frozendict[${PYTHON_USEDEP}]
	go? ( dev-go/gocode
		  dev-go/godef )
	dev-python/future[${PYTHON_USEDEP}]
	rust? ( dev-rust/racerd
                dev-lang/rust[ycmd] )
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/sh[${PYTHON_USEDEP}]
	=dev-python/waitress-0.8.10-r2[${PYTHON_USEDEP}]
        javascript? ( >=dev-nodejs/tern-0.17.0
                      net-libs/nodejs[npm] )
        typescript? ( >=dev-lang/typescript-1.5 )
	system-clang? (
	        c? ( sys-devel/clang )
	        c++? ( sys-devel/clang )
	        objc? ( sys-devel/clang )
	        objc++? ( sys-devel/clang )
	)
	tests? ( dev-python/pyhamcrest
		 dev-python/webtest
		 dev-python/flake8
		 dev-python/mock
		 dev-python/nose
		 dev-python/nose-exclude
        )
"
DEPEND="
	${COMMON_DEPEND}
"

S="${WORKDIR}/${PN}-${COMMIT}"

src_prepare() {
	eapply "${FILESDIR}/${PN}-9999.20170107-skip-thirdparty-check.patch"
	eapply "${FILESDIR}/${PN}-9999.20171228-exe-paths.patch"
	eapply "${FILESDIR}/${PN}-9999.20170107-no-third-party-folder-check.patch"
	eapply "${FILESDIR}/${PN}-9999.20170107-force-python-libs-path.patch"
	eapply "${FILESDIR}/${PN}-9999.20170107-core-version-path.patch"

	#eapply "${FILESDIR}/${PN}-9999.20170107-bottle-0.12.11.patch"

	if use omnisharp-roslyn; then
		epatch "${FILESDIR}/${PN}-9999.20170117-omnisharp-roslyn-support.patch"
	fi

	if use csharp ; then
		if use net45 ; then
			cp -a "${FILESDIR}/omnisharp.sh.net45" "${WORKDIR}/omnisharp.sh"
			sed -i -e "s|GENTOO_OMNISHARP_SERVER_PATH|/usr/$(get_libdir)/mono/omnisharp-server|g"  "${WORKDIR}/omnisharp.sh"
		elif use net46 ; then
			cp -a "${FILESDIR}/omnisharp.sh.net46" "${WORKDIR}/omnisharp.sh"

			FRAMEWORK_FOLDER="net46"
			sed -i -e "s|GENTOO_OMNISHARP_ROSLYN_NET46_PATH|/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g"  "${WORKDIR}/omnisharp.sh"
		elif use netcore10 ; then
			cp -a "${FILESDIR}/omnisharp.sh.netcore10" "${WORKDIR}/omnisharp.sh"

			NETCORE_VERSION="1.0.1"
			FRAMEWORK_FOLDER="netcoreapp1.0"
			sed -i -e "s|GENTOO_DOTNET_CLI_NETCORE_PATH|/opt/dotnet_cli/shared/Microsoft.NETCore.App/${NETCORE_VERSION}|g"  "${WORKDIR}/omnisharp.sh"
			sed -i -e "s|GENTOO_OMNISHARP_ROSLYN_NETCORE10_PATH|/usr/$(get_libdir)/mono/omnisharp-roslyn/${FRAMEWORK_FOLDER}|g"  "${WORKDIR}/omnisharp.sh"
		fi
	fi

	eapply "${FILESDIR}/${PN}-9999.20170117-no-prepend-mono.patch"
	eapply "${FILESDIR}/${PN}-9999.20171228-jedi-path-fix.patch"

	eapply_user

	python_copy_sources

	python_foreach_impl python_prepare_all
}

python_prepare_all() {
	cd "${WORKDIR}/${PN}-${COMMIT}-${EPYTHON//./_}"

	sed -i -e "s|lib64|$(get_libdir)|g" ycmd/completers/cs/cs_completer.py
	sed -i -e "s|lib64|$(get_libdir)|g" ycmd/completers/javascript/tern_completer.py
	sed -i -e "s|0.20.0|$(ls /usr/$(get_libdir)/node/tern/ | tail -n 1)|g" ycmd/completers/javascript/tern_completer.py
	if [[ "${EPYTHON}" != "python2.7" ]] ; then
		use system-boost && sed -i -e "s|python3|python|g" cpp/ycm/CMakeLists.txt
	fi

	if use csharp ; then
		sed -i -e "s|GENTOO_OMNISHARP|/usr/$(get_libdir)/${EPYTHON}/site-packages/ycmd/completers/cs/omnisharp.sh|g" ycmd/completers/cs/cs_completer.py || die
	fi

	cp "${FILESDIR}/default_settings.json" ycmd/default_settings.json

	sed -i -e "s|GENTOO_PYTHON_LIBRARY_PATH|/usr/$(get_libdir)/lib${EPYTHON}.so|g" build.py

	sed -i -e "s|HFJ1aRMhtCX/DMYWYkUl9g==|$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c16 | base64)|g" ycmd/default_settings.json
	sed -i -e "s|/usr/bin/python3.4|/usr/bin/${EPYTHON}|g" ycmd/default_settings.json

	if use system-clang ; then
		sed -i -e "s|EXTERNAL_LIBCLANG_PATH \${TEMP}|EXTERNAL_LIBCLANG_PATH \"$(ls /usr/lib/llvm/5/$(get_libdir)/libclang.so* | head -1)\"|g" cpp/ycm/CMakeLists.txt
	fi
}

src_configure() {
	python_foreach_impl python_configure_all
}

python_configure_all()
{
	strip-flags -O0 -O1 -O3 -O4
	append-cxxflags -O2
	append-cflags -O2

        #We need to do this ourselves instead of rely on the build script.  The build script has racing error when it tries to do it through emerge.
        local mycmakeargs=(
                -DUSE_SYSTEM_LIBCLANG=$(usex system-clang)
                -DUSE_SYSTEM_BOOST=$(usex system-boost)
                -DUSE_CLANG_COMPLETER=$(usex system-boost)
        )
        if [[ "${EPYTHON}" == "python2.7" ]] ; then
                mycmakeargs+=(
                        -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython2.7.so
                        -DPYTHON_INCLUDE_DIR=/usr/include/python2.7
                        -DUSE_PYTHON2=ON
                )
        elif [[ "${EPYTHON}" == "python3.4" ]] ; then
                if [ -f /usr/$(get_libdir)/libpython3.4m.so ]; then
                        mycmakeargs+=( -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython3.4m.so )
                        mycmakeargs+=( -DPYTHON_INCLUDE_DIR=/usr/include/python3.4m )
                else
                    	mycmakeargs+=( -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython3.4.so )
                        mycmakeargs+=( -DPYTHON_INCLUDE_DIR=/usr/include/python3.4 )
                fi
                mycmakeargs+=( -DUSE_PYTHON2=OFF )
        elif [[ "${EPYTHON}" == "python3.5" ]] ; then
                if [ -f /usr/$(get_libdir)/libpython3.5m.so ]; then
                        mycmakeargs+=( -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython3.5m.so )
                        mycmakeargs+=( -DPYTHON_INCLUDE_DIR=/usr/include/python3.5m )
                else
                    	mycmakeargs+=( -DPYTHON_LIBRARY=/usr/$(get_libdir)/libpython3.5.so )
                        mycmakeargs+=( -DPYTHON_INCLUDE_DIR=/usr/include/python3.5 )
                fi
                mycmakeargs+=( -DUSE_PYTHON2=OFF )
        fi

	if use c || use c++ || use objc || use objc++ ; then
                mycmakeargs+=( -DUSE_CLANG_COMPLETER=ON )
        fi
	if use debug ; then
                mycmakeargs+=(
                        -DCMAKE_BUILD_TYPE=Debug
                        -DUSE_DEV_FLAGS=ON
                )
        fi
	CMAKE_USE_DIR="${WORKDIR}/${PN}-${COMMIT}-${EPYTHON//./_}/cpp" \
        cmake-utils_src_configure
}

src_compile() {
	#bypass setup.py check
	python_foreach_impl python_compile_all
}

python_compile_all() {
	cd "${WORKDIR}/${PN}-${COMMIT}-${EPYTHON//./_}"
	myargs=""
	use system-boost && myargs+=" --system-boost"
	use system-clang && myargs+=" --system-libclang"
	if use c || use c++ || use objc || use objc++ ; then
		myargs+=" --clang-completer"
	fi
	use debug && myargs+=" --enable-debug"

	cmake-utils_src_compile
	#./build.py ${myargs}
	mkdir "${WORKDIR}/${EPYTHON}"
	cp -a "ycm_core.so" "${WORKDIR}/${EPYTHON}"
}

src_install() {
	#bypass setup.py check
	python_foreach_impl python_install_all
}

python_install_all() {
	cd "${WORKDIR}/${PN}-${COMMIT}-${EPYTHON//./_}"
	mkdir -p "${D}/$(python_get_sitedir)/ycmd"
	cp "${WORKDIR}/${EPYTHON}/ycm_core.so" "${D}/$(python_get_sitedir)"
	cp "CORE_VERSION" "${D}/$(python_get_sitedir)/ycmd"

	cp -a "cpp/ycm/.ycm_extra_conf.py" "${D}/$(python_get_sitedir)/ycmd"
	if use csharp ; then
		cp -a "${WORKDIR}/omnisharp.sh" "ycmd/completers/cs/"
	fi

	rm -rf "ycmd/tests"
	rm -rf "ycmd/completers/general/tests"

	python_domodule ycmd

	if use csharp ; then
		chmod 755 "${D}/$(python_get_sitedir)/ycmd/completers/cs/omnisharp.sh"
	fi

	cp -a clang_includes cpp "${D}/$(python_get_sitedir)/"
	cp -a libclang.so.5* "${D}/$(python_get_sitedir)/"
}

src_test() {
	#disabled because tests are poor quality
	#python_foreach_impl python_install_all
	true
}
python_test_all() {
	cp "${WORKDIR}/${EPYTHON}" ./
	cp "${S}/CORE_VERSION" ./ycmd
	./run_tests.py --skip-build
}

pkg_postinst() {
	einfo "Examples of the .json files can be found at targeting particular python version:"
	if use python_targets_python2_7 ; then
		einfo "/usr/$(get_libdir)/python2.7/site-packages/ycmd/default_settings.json"
	elif use python_targets_python3_4 ; then
		einfo "/usr/$(get_libdir)/python3.4/site-packages/ycmd/default_settings.json"
	elif use python_targets_python3_5 ; then
		einfo "/usr/$(get_libdir)/python3.5/site-packages/ycmd/default_settings.json"
	fi

	if use c || use c++ || use objc || use objc++ ; then
		einfo ""
		einfo "You need to edit the global_ycm_extra_conf property in your .json file per project to the full path of the .ycm_extra_conf.py."

		einfo ""
		einfo "Examples of the .ycm_extra_conf.py which should be defined per project can be found at:"
		if use python_targets_python2_7 ; then
			einfo "/usr/$(get_libdir)/python2.7/site-packages/ycmd/.ycm_extra_conf.py"
		elif use python_targets_python3_4 ; then
			einfo "/usr/$(get_libdir)/python3.4/site-packages/ycmd/.ycm_extra_conf.py"
		elif use python_targets_python3_5 ; then
			einfo "/usr/$(get_libdir)/python3.5/site-packages/ycmd/.ycm_extra_conf.py"
		fi

		einfo ""
		einfo "Consider emerging ycm-generator to properly generate a .ycm_extra_conf.py which is mandatory for c/c++/objc/objc++."
		einfo "After generating it, it may need to be slightly modified."
	fi

	if use csharp ; then
		einfo "You need a .sln file in your project for C# support"
	fi

	if use javascript ; then
		einfo "You need a .tern-project in your project for javascript support."
	fi
}
