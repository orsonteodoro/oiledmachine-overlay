# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CFLAGS_HARDENED_USE_CASES="language-runtime security-critical sensitive-data untrusted-data"
CFLAGS_HARDENED_VULNERABILITY_HISTORY="CE DF FS HO IO SO UAF"
GCC_SLOT=12
LLVM_COMPAT=( {19..15} )
LLVM_MAX_SLOT=${LLVM_COMPAT[0]}
PHP_MV="$(ver_cut 1)"
POSTGRES_COMPAT=( {15..17} )
# ARM/Windows functions (bug 923335)
QA_CONFIG_IMPL_DECL_SKIP=(
	__crc32d
	_controlfp
	_controlfp_s
)
# Functions from alternate iconv implementations (bug 925268)
QA_CONFIG_IMPL_DECL_SKIP+=(
	iconv_ccs_init
	cstoccsid
)
# We can build the following SAPIs in the given order
SAPIS="cli cgi embed fpm apache2 phpdbg" # cli is built first to distribute pgo profile
SAPIS_DEFAULTS="+cli +cgi -embed -fpm -apache2 +phpdbg"
UOPTS_SUPPORT_EBOLT=0
UOPTS_SUPPORT_EPGO=0
UOPTS_SUPPORT_TBOLT=1
UOPTS_SUPPORT_TPGO=1
WANT_AUTOMAKE="none"

inherit autotools cflags-hardened flag-o-matic llvm multilib postgres systemd uopts

KEYWORDS="
~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390
~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos
"
export BENCHMARKING_DATA_COMMIT="abfbebbf1a771df2b925fbb04ef7a3a8e3f55d74"
BENCHMARKING_SYMFONY_DEMO_2_2_3="7979f0def39dfde24afebbd29ad205f6c32ea795"
BENCHMARKING_WORDPRESS_6_2="ef263dad5e1e6bbc78885cb6707c0a4d07ad5fc6"
SRC_URI="
	https://www.php.net/distributions/${P}.tar.xz
	trainer-benchmark? (
https://github.com/php/benchmarking-data/archive/${BENCHMARKING_DATA_COMMIT}.tar.gz
	-> php-benchmarking-data-${BENCHMARKING_DATA_COMMIT:0:7}.tar.gz
https://github.com/php/benchmarking-symfony-demo-2.2.3/archive/${BENCHMARKING_SYMFONY_DEMO_2_2_3}.tar.gz
	-> php-benchmarking-symfony-demo-2_2_3-${BENCHMARKING_SYMFONY_DEMO_2_2_3:0:7}.tar.gz
https://github.com/php/benchmarking-wordpress-6.2/archive/${BENCHMARKING_WORDPRESS_6_2}.tar.gz
	-> php-benchmarking-wordpress-6.2-${BENCHMARKING_WORDPRESS_6_2:0:7}.tar.gz
	)
"

DESCRIPTION="The PHP language runtime engine"
HOMEPAGE="https://www.php.net/"
LICENSE="
	PHP-3.01
	BSD
	Zend-2.0
	bcmath? (
		LGPL-2.1+
	)
	fpm? (
		BSD-2
	)
	unicode? (
		BSD-2
		LGPL-2.1
	)
"
RESTRICT="
	!test? (
		test
	)
"
SLOT="$(ver_cut 1-2)"
# SAPIs and SAPI-specific USE flags (cli SAPI is default on):
IUSE+="
${SAPIS_DEFAULTS}
-acl -apparmor -argon2 -avif -bcmath -berkdb -bzip2 -calendar -capstone -cdb
+ctype -curl debug -enchant -exif -ffi +fileinfo +filter
+flatfile -ftp -gd -gdbm +gmp +iconv -inifile -intl -iodbc -ipv6 +jit jpeg
-ldap -ldap-sasl -libedit -lmdb -mhash -mssql -mysql -mysqli -nls
-odbc +opcache +opcache-jit -pcntl +pdo +phar png +posix -postgres -qdbm
-readline selinux +session session-mm -sharedmem +simplexml -snmp -soap -sockets
-sodium -spell +sqlite -ssl -sysvipc -systemd test -tidy threads +tokenizer
-tokyocabinet -truetype -unicode valgrind -webp +xml +xmlreader +xmlwriter -xpm
-xslt -zip -zlib
clang
trainer-all
trainer-basic
trainer-benchmark
trainer-ext
trainer-ext-com_dotnet
trainer-ext-date
trainer-ext-dom
trainer-ext-standard
trainer-ext-random
trainer-ext-reflection
trainer-ext-spl
trainer-ext-standard
trainer-zend
ebuild_revision_11
"
# Without USE=readline or libedit, the interactive "php -a" CLI will hang.
REQUIRED_USE_BENCHMARK_SYMFONY_DEMO="
	(
		ctype
		iconv
		pdo
		sqlite
		session
		simplexml
		tokenizer
	)
"
REQUIRED_USE_BENCHMARK_WORDPRESS="
	(
		mysql
		phar
	)
"
REQUIRED_USE="
	!cli? (
		?? (
			libedit
			readline
		)
	)
	bolt? (
		cli
		^^ (
			trainer-all
			trainer-basic
			trainer-benchmark
		)
	)
	cli? (
		^^ (
			libedit
			readline
		)
	)
	gd? (
		zlib
	)
	ldap-sasl? (
		ldap
	)
	mssql? (
		pdo
	)
	mysql? (
		|| (
			mysqli
			pdo
		)
	)
	pgo? (
		cli
		^^ (
			trainer-all
			trainer-basic
			trainer-benchmark
		)
	)
	qdbm? (
		!gdbm
	)
	session-mm? (
		!threads
		session
	)
	simplexml? (
		xml
	)
	soap? (
		xml
	)
	test? (
		cli
	)
	trainer-benchmark? (
		${REQUIRED_USE_BENCHMARK_SYMFONY_DEMO}
		${REQUIRED_USE_BENCHMARK_WORDPRESS}
		cli
		cgi
		gmp
	)
	trainer-ext? (
		trainer-basic
	)
	trainer-ext-com_dotnet? (
		trainer-basic
	)
	trainer-ext-date? (
		trainer-basic
	)
	trainer-ext-dom? (
		trainer-basic
	)
	trainer-ext-random? (
		trainer-basic
	)
	trainer-ext-reflection? (
		trainer-basic
	)
	trainer-ext-spl? (
		trainer-basic
	)
	trainer-ext-standard? (
		trainer-basic
	)
	trainer-all? (
		|| (
			pgo
			bolt
		)
	)
	trainer-basic? (
		|| (
			pgo
			bolt
		)
	)
	trainer-zend? (
		trainer-basic
	)
	xmlreader? (
		xml
	)
	xmlwriter? (
		xml
	)
	xslt? (
		xml
	)
	|| (
		apache2
		cgi
		cli
		embed
		fpm
		phpdbg
	)
"

# The supported (that is, autodetected) versions of BDB are listed in
# the ./configure script. Other versions *work*, but we need to stick to
# the ones that can be detected to avoid a repeat of bug #564824.
COMMON_DEPEND="
	app-eselect/eselect-php[apache2?,fpm?]
	dev-libs/libpcre2[jit?,unicode]
	virtual/libcrypt:=
	fpm? (
		acl? (
			sys-apps/acl
		)
		apparmor? (
			sys-libs/libapparmor
		)
		selinux? (
			sys-libs/libselinux
		)
	)
	apache2? (
		www-servers/apache[apache2_modules_unixd(+),threads=]
	)
	argon2? (
		app-crypt/argon2:=
	)
	berkdb? (
		|| (
			sys-libs/db:5.3
			sys-libs/db:4.8
		)
	)
	bzip2? (
		app-arch/bzip2:0=
	)
	capstone? (
		dev-libs/capstone
	)
	cdb? (
		|| (
			dev-db/cdb dev-db/tinycdb
		)
	)
	curl? (
		net-misc/curl
	)
	enchant? (
		app-text/enchant:2
	)
	ffi? (
		dev-libs/libffi:=
	)
	gd? (
		>=media-libs/gd-2.3.3-r4[avif?,jpeg?,png?,truetype?,webp?,xpm?]
	)
	gdbm? (
		sys-libs/gdbm:0=
	)
	gmp? (
		dev-libs/gmp:0=
	)
	iconv? (
		virtual/libiconv
	)
	intl? (
		dev-libs/icu:=
	)
	ldap? (
		net-nds/openldap:=
	)
	ldap-sasl? (
		dev-libs/cyrus-sasl
	)
	libedit? (
		dev-libs/libedit
	)
	lmdb? (
		dev-db/lmdb:=
	)
	mssql? (
		dev-db/freetds[mssql]
	)
	nls? (
		sys-devel/gettext
	)
	odbc? (
		!iodbc? (
			dev-db/unixODBC
		)
		iodbc? (
			dev-db/libiodbc
		)
	)
	postgres? (
		${POSTGRES_DEP}
	)
	qdbm? (
		dev-db/qdbm
	)
	readline? (
		sys-libs/readline:0=
	)
	session-mm? (
		dev-libs/mm
	)
	snmp? (
		net-analyzer/net-snmp
	)
	sodium? (
		dev-libs/libsodium:=[-minimal(-)]
	)
	spell? (
		app-text/aspell
	)
	sqlite? (
		dev-db/sqlite
	)
	ssl? (
		dev-libs/openssl:0=
	)
	tidy? (
		app-text/htmltidy
	)
	tokyocabinet? (
		dev-db/tokyocabinet
	)
	truetype? (
		media-libs/freetype
	)
	unicode? (
		dev-libs/oniguruma:=
	)
	valgrind? (
		dev-debug/valgrind
	)
	xml? (
		dev-libs/libxml2
	)
	xslt? (
		dev-libs/libxslt
	)
	zip? (
		dev-libs/libzip:=
	)
	zlib? (
		sys-libs/zlib:0=
	)
"
IDEPEND="
	app-eselect/eselect-php[apache2?,fpm?]
"
RDEPEND="
	${COMMON_DEPEND}
	virtual/mta
	fpm? (
		selinux? (
			sec-policy/selinux-phpfpm
		)
		systemd? (
			sys-apps/systemd
		)
	)
"
# Bison isn't actually needed when building from a release tarball
# However, the configure script will warn if it's absent or if you
# have an incompatible version installed. See bug 593278.
DEPEND="
	${COMMON_DEPEND}
	app-arch/xz-utils
	sys-devel/bison
	trainer-benchmark? (
		dev-debug/valgrind
	)
"
gen_clang_bdepend() {
	local s
	for s in ${LLVM_COMPAT[@]} ; do
		echo "
			(
				=llvm-runtimes/compiler-rt-sanitizers-${s}*[profile]
				llvm-core/clang:${s}
				sys-devel/gcc:${GCC_SLOT}
				llvm-core/lld:${s}
				llvm-core/llvm:${s}[bolt?]
			)
		"
	done
}
BDEPEND="
	virtual/pkgconfig
	bolt? (
		|| (
			$(gen_clang_bdepend)
		)
	)
	pgo? (
		|| (
			!clang? (
				sys-devel/gcc:${GCC_SLOT}
			)
			clang? (
				$(gen_clang_bdepend)
			)
		)
	)
"
PATCHES=(
)

php_install_ini() {
	local phpsapi="${1}"

	# Work out where we are installing the ini file
	php_set_ini_dir "${phpsapi}"

	# Always install the production INI file, bug 611214.
	local phpinisrc="php.ini-production-${phpsapi}"
	cp \
		"php.ini-production" \
		"${phpinisrc}" \
		|| die

	# Set the include path to point to where we want to find PEAR
	# packages
	local sed_src='^;include_path = ".:/php.*'
	local include_path="."
	include_path+=":${EPREFIX}/usr/share/php${PHP_MV}"
	include_path+=":${EPREFIX}/usr/share/php"
	local sed_dst="include_path = \"${include_path}\""
	sed -i \
		-e "s|${sed_src}|${sed_dst}|" \
		"${phpinisrc}" \
		|| die

	insinto "${PHP_INI_DIR#${EPREFIX}}"
	newins "${phpinisrc}" "php.ini"

	elog "Installing php.ini for ${phpsapi} into ${PHP_INI_DIR#${EPREFIX}}"
	elog

	dodir "${PHP_EXT_INI_DIR#${EPREFIX}}"
	dodir "${PHP_EXT_INI_DIR_ACTIVE#${EPREFIX}}"

	if use opcache ; then
		elog "Adding opcache to $PHP_EXT_INI_DIR"
		echo \
			"zend_extension = opcache.so" \
			>> \
			"${D}/${PHP_EXT_INI_DIR}/opcache.ini"
		dosym \
			"../ext/opcache.ini" \
			"${PHP_EXT_INI_DIR_ACTIVE#${EPREFIX}}/opcache.ini"
	fi

	# SAPI-specific handling
	if [[ "${sapi}" == "fpm" ]] ; then
einfo "Installing FPM config files php-fpm.conf and www.conf"
		insinto "${PHP_INI_DIR#${EPREFIX}}"
		doins sapi/fpm/php-fpm.conf
		insinto "${PHP_INI_DIR#${EPREFIX}}/fpm.d"
		doins sapi/fpm/www.conf
	fi

	dodoc php.ini-{development,production}
}

php_set_ini_dir() {
	PHP_INI_DIR="${EPREFIX}/etc/php/${1}-php${SLOT}"
	PHP_EXT_INI_DIR="${PHP_INI_DIR}/ext"
	PHP_EXT_INI_DIR_ACTIVE="${PHP_INI_DIR}/ext-active"
}

use_dba() {
	if \
		   use berkdb \
		|| use cdb \
		|| use flatfile \
		|| use gdbm \
		|| use inifile \
		|| use lmdb \
		|| use qdbm \
		|| use tokyocabinet \
	; then
		return 0
	else
		return 1
	fi
}

pkg_setup() {
	use postgres && postgres_pkg_setup

	if use pgo || use bolt ; then
		llvm_pkg_setup
einfo "Disabling ccache"
		export CCACHE_DISABLE=1
einfo "PATH:  ${PATH} (before)"
		export PATH=$(echo "${PATH}" \
			| tr ":" "\n" \
			| sed -E -e "/ccache/d" \
			| tr "\n" ":" \
			| sed -e "s|/opt/bin|/opt/bin:${ESYSROOT}${EROCM_LLVM_PATH}/bin|g")
einfo "PATH:  ${PATH} (after)"
		if use trainer-benchmark ; then
ewarn
ewarn "The trainer-benchmark USE flag requires the following *sql settings"
ewarn "for benchmarking to avoid clobbering www-apps/wordpress installation:"
ewarn
ewarn "  mysql -u root -p -e \"CREATE DATABASE IF NOT EXISTS trainer_benchmark\""
ewarn "  mysql -u root -p -e \"CREATE USER 'trainer-benchmark'@'localhost' IDENTIFIED BY 'trainer-benchmark'; FLUSH PRIVILEGES;\""
ewarn "  mysql -u root -p -e \"GRANT ALL PRIVILEGES ON *.* TO 'trainer-benchmark'@'localhost' WITH GRANT OPTION;\""
ewarn
		fi
ewarn "${PN} may need to be temporarly unemerged for PGO training to work."
	fi
	uopts_setup
}

src_unpack() {
	unpack ${A}
	if use trainer-benchmark ; then
		mkdir -p "${S}/benchmark/repos"
		mv \
			"${WORKDIR}/benchmarking-data-${BENCHMARKING_DATA_COMMIT}" \
			"${S}/benchmark/repos/data" \
			|| die
		mv \
			"${WORKDIR}/benchmarking-symfony-demo-2.2.3-${BENCHMARKING_SYMFONY_DEMO_2_2_3}" \
			"${S}/benchmark/repos/symfony-demo-2.2.3" \
			|| die
		mv \
			"${WORKDIR}/benchmarking-wordpress-6.2-${BENCHMARKING_WORDPRESS_6_2}" \
			"${S}/benchmark/repos/wordpress-6.2" \
			|| die

		local loc
		loc=$(grep -n -e "DB_NAME" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			| cut -f 1 -d ":")
		sed -i \
			-e "${loc}d" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			|| die
		sed -i \
			-e "${loc}i define( 'DB_NAME', 'trainer_benchmark' );" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			|| die

		loc=$(grep -n -e "DB_USER" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			| cut -f 1 -d ":")
		sed -i \
			-e "${loc}d" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			|| die
		sed -i \
			-e "${loc}i define( 'DB_USER', 'trainer-benchmark' );" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			|| die

		loc=$(grep -n -e "DB_PASSWORD" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			| cut -f 1 -d ":")
		sed -i \
			-e "${loc}d" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			|| die
		sed -i \
			-e "${loc}i define( 'DB_PASSWORD', 'trainer-benchmark' );" \
			"${S}/benchmark/repos/wordpress-6.2/wp-config.php" \
			|| die

		loc=$(grep -n -e "--admin_user=wordpress" \
			"${S}/benchmark/benchmark.php" \
			| cut -f 1 -d ":")
		sed -i \
			-e "${loc}d" \
			"${S}/benchmark/benchmark.php" \
			|| die
		sed -i \
			-e "${loc}i '--admin_user=trainer-benchmark'," \
			"${S}/benchmark/benchmark.php" \
			|| die

		loc=$(grep -n -e "--admin_password=wordpress" \
			"${S}/benchmark/benchmark.php" \
			| cut -f 1 -d ":")
		sed -i \
			-e "${loc}d" \
			"${S}/benchmark/benchmark.php" \
			|| die
		sed -i \
			-e "${loc}i '--admin_password=trainer-benchmark'," \
			"${S}/benchmark/benchmark.php" \
			|| die

		loc=$(grep -n -e "--admin_email=benchmark@php.net" \
			"${S}/benchmark/benchmark.php" \
			| cut -f 1 -d ":")
		sed -i \
			-e "${loc}d" \
			"${S}/benchmark/benchmark.php" \
			|| die
		sed -i \
			-e "${loc}i '--admin_email=trainer-benchmark@trainer-benchmark.net'," \
			"${S}/benchmark/benchmark.php" \
			|| die
	fi
}

src_prepare() {
	default

	# In php-8.x, the FPM pool configuration files have been split off
	# of the main config. By default the pool config files go in
	# e.g. /etc/php-fpm.d, which isn't slotted. So here we move the
	# include directory to a subdirectory "fpm.d" of $PHP_INI_DIR. Later
	# we'll install the pool configuration file "www.conf" there.
	php_set_ini_dir fpm
	sed -i \
		-e "s~^include=.*$~include=${PHP_INI_DIR}/fpm.d/*.conf~" \
		"sapi/fpm/php-fpm.conf.in" \
		|| die 'failed to move the include directory in php-fpm.conf'

	local deleted_files=(
	# fails in a network sandbox,
	#
	#   https://github.com/php/php-src/issues/11662
	#
		ext/sockets/tests/bug63000.phpt

	# Tests ignoring the "-n" flag we pass to run-tests.php,
	#
	#   https://github.com/php/php-src/pull/11669
	#
		ext/standard/tests/file/bug60120.phpt
		ext/standard/tests/general_functions/proc_open_null.phpt
		ext/standard/tests/general_functions/proc_open_redirect.phpt
		ext/standard/tests/general_functions/proc_open_sockets1.phpt
		ext/standard/tests/general_functions/proc_open_sockets2.phpt
		ext/standard/tests/general_functions/proc_open_sockets3.phpt
		ext/standard/tests/ini_info/php_ini_loaded_file.phpt
		sapi/cli/tests/016.phpt
		sapi/cli/tests/023.phpt
		sapi/cli/tests/bug65275.phpt
		sapi/cli/tests/bug74600.phpt
		sapi/cli/tests/bug78323.phpt

	# Most tests failing with an external libgd have been fixed,
	# but there are a few stragglers:
	#
	#  * https://github.com/php/php-src/issues/11252
	#
		ext/gd/tests/bug43073.phpt
		ext/gd/tests/bug48732.phpt
		ext/gd/tests/bug48732-mb.phpt
		ext/gd/tests/bug48801.phpt
		ext/gd/tests/bug48801-mb.phpt
		ext/gd/tests/bug53504.phpt
		ext/gd/tests/bug65148.phpt
		ext/gd/tests/bug73272.phpt

	# One-off, somebody forgot to update a version constant
		ext/reflection/tests/ReflectionZendExtension.phpt

	)
	rm -v ${deleted_files[@]} || die

	for sapi in ${SAPIS} ; do
		cp -a "${S}" "${S}_${sapi}" || die
		if use cgi ; then
			if [[ "${sapi}" == "cgi" || "${sapi}" == "cli" ]] ; then
				UOPTS_IMPLS="_${sapi}"
			else
				UOPTS_IMPLS="_cgi"
			fi
		fi
		uopts_src_prepare
	done


	eautoconf --force
}

src_configure() { :; }

check_libstdcxx() {
	local gcc_current_profile=$(gcc-config -c)
	local gcc_current_profile_slot=${gcc_current_profile##*-}

	if ver_test "${gcc_current_profile_slot}" -ne "${GCC_SLOT}" ; then
eerror
eerror "You must switch to >= ${GCC_SLOT}.  Do"
eerror
eerror "  eselect gcc set ${CHOST}-${GCC_SLOT}"
eerror "  source /etc/profile"
eerror
eerror "This is a temporary for ${PN}:${SLOT}.  You must restore it back"
eerror "to the default immediately after this package has been merged."
eerror
		die
	fi
}

_src_configure_compiler() {
	if use clang ; then
		export CC="${CHOST}-clang-${LLVM_SLOT}"
		export CXX="${CHOST}-clang++-${LLVM_SLOT}"
		export CPP="${CC} -E"
		export AR="llvm-ar"
		export NM="llvm-nm"
		export OBJCOPY="llvm-objcopy"
		export OBJDUMP="llvm-objdump"
		export READELF="llvm-readelf"
		export STRIP="llvm-strip"
		filter-flags '-fuse-ld=*'
		append-ldflags -fuse-ld=lld
		strip-unsupported-flags
		if [[ "${PGO_PHASE}" == "PGI" ]] ; then
			append-flags -mllvm -vp-counters-per-site=8 # Unbreak test suite
		fi
	fi
	if ! use clang ; then
		# Breaks with gcc-13 (libstdcxx)
		export CC="${CHOST}-gcc-${GCC_SLOT}"
		export CXX="${CHOST}-gcc-${GCC_SLOT}"
		export CPP="${CC} -E"
		export AR="ar"
		export NM="nm"
		export OBJCOPY="objcopy"
		export OBJDUMP="objdump"
		export READELF="readelf"
		export STRIP="strip"
		strip-unsupported-flags
		append-ldflags -lgcov
		append-flags -Wno-error=coverage-mismatch # Unbreak configure check
	fi
}

_src_configure() {
	check_libstdcxx
	if use cgi ; then
		if [[ "${sapi}" == "cgi" || "${sapi}" == "cli" ]] ; then
			UOPTS_IMPLS="_${sapi}"
		else
			UOPTS_IMPLS="_cgi"
		fi
	fi
	uopts_src_configure # Wipes -fprofile*
	if use clang ; then
		if [[ "${PGO_PHASE}" == "PGI" || "${PGO_PHASE}" == "PGO" ]] ; then
			# Broken.  It still stalls.
eerror "Bugged optimized version.  Disable either clang USE flag or both bolt and pgo USE flags."
			append-flags -fprofile-list="${FILESDIR}/exclude-instr.txt"
			die
		fi
	fi
	cflags-hardened_append
	einfo "CFLAGS:  ${CFLAGS}"
	einfo "CXXFLAGS:  ${CXXFLAGS}"
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn

	# https://bugs.gentoo.org/866683, https://bugs.gentoo.org/913527
	filter-lto

	PHP_DESTDIR="${EPREFIX}/usr/$(get_libdir)/php${SLOT}"

	# Don't allow ./configure to detect and use an existing version
	# of PHP; this can lead to all sorts of weird unpredictability
	# as in bug 900210.
	export ac_cv_prog_PHP=""

	# The slotted man/info pages will be missed by the default list of
	# docompress paths.
	docompress "${PHP_DESTDIR}/man" "${PHP_DESTDIR}/info"

	local our_conf=(
		$(use_enable bcmath)
		$(use_enable calendar)
		$(use_enable ctype)
		$(use_enable debug)
		$(use_enable exif)
		$(use_enable fileinfo)
		$(use_enable filter)
		$(use_enable ftp)
		$(use_enable intl)
		$(use_enable ipv6)
		$(use_enable opcache)
		$(use_enable opcache-jit)
		$(use_enable pcntl)
		$(use_enable phar)
		$(use_enable pdo)
		$(use_enable posix)
		$(use_enable sharedmem shmop)
		$(use_enable simplexml)
		$(use_enable soap)
		$(use_enable sockets)
		$(use_enable sysvipc sysvmsg)
		$(use_enable sysvipc sysvsem)
		$(use_enable sysvipc sysvshm)
		$(use_enable threads zts)
		$(use_enable tokenizer)
		$(use_enable unicode mbstring)
		$(use_enable xml)
		$(use_enable xml dom)
		$(use_enable xmlreader)
		$(use_enable xmlwriter)
		$(use_with apparmor fpm-apparmor)
		$(use_with argon2 password-argon2 "${EPREFIX}/usr")
		$(use_with bzip2 bz2 "${EPREFIX}/usr")
		$(use_with capstone)
		$(use_with curl)
		$(use_with enchant)
		$(use_with ffi)
		$(use_with gmp gmp "${EPREFIX}/usr")
		$(use_with iconv iconv \
			$(use elibc_glibc || use elibc_musl || echo "${EPREFIX}/usr"))
		$(use_with mhash mhash "${EPREFIX}/usr")
		$(use_with nls gettext "${EPREFIX}/usr")
		$(use_with postgres pgsql "$("${PG_CONFIG:-true}" --bindir)/..")
		$(use_with selinux fpm-selinux)
		$(use_with snmp snmp "${EPREFIX}/usr")
		$(use_with sodium)
		$(use_with sqlite sqlite3)
		$(use_with ssl openssl)
		$(use_with tidy tidy "${EPREFIX}/usr")
		$(use_with xml libxml)
		$(use_with xslt xsl)
		$(use_with zip)
		$(use_with zlib zlib "${EPREFIX}/usr")
		$(use_with valgrind)
	# The php-fpm config file wants localstatedir to be ${EPREFIX}/var
	# and not the Gentoo default ${EPREFIX}/var/lib. See bug 572002.
		--infodir="${PHP_DESTDIR}/info"
		--mandir="${PHP_DESTDIR}/man"
		--prefix="${PHP_DESTDIR}"
		--libdir="${PHP_DESTDIR}/lib"
		--localstatedir="${EPREFIX}/var"
		--with-libdir="$(get_libdir)"
		--without-pear
		--without-valgrind
		--with-external-libcrypt
	)

	# Override autoconf cache variables for libcrypt algorithms.These
	# otherwise cannot be detected when cross-compiling. Bug 931884.
	our_conf+=(
		ac_cv_crypt_blowfish=yes
		ac_cv_crypt_des=yes
		ac_cv_crypt_ext_des=yes
		ac_cv_crypt_md5=yes
		ac_cv_crypt_sha512=yes
		ac_cv_crypt_sha256=yes
	)

	# DBA support
	if use_dba ; then
		our_conf+=( "--enable-dba" )
	fi

	# DBA drivers support
	our_conf+=(
		$(use_enable flatfile)
		$(use_enable inifile)
		$(use_with berkdb db4 "${EPREFIX}/usr")
		$(use_with cdb)
		$(use_with gdbm gdbm "${EPREFIX}/usr")
		$(use_with lmdb lmdb "${EPREFIX}/usr")
		$(use_with qdbm qdbm "${EPREFIX}/usr")
		$(use_with tokyocabinet tcadb "${EPREFIX}/usr")
	)

	# Use the system copy of GD. The autoconf cache variable overrides
	# allow cross-compilation to proceed since the corresponding
	# features cannot be detected by running a program.
	our_conf+=(
		$(use_enable gd gd)
		$(use_with gd external-gd)
		php_cv_lib_gd_gdImageCreateFromAvif=$(usex avif)
		php_cv_lib_gd_gdImageCreateFromBmp=yes
		php_cv_lib_gd_gdImageCreateFromJpeg=$(usex jpeg)
		php_cv_lib_gd_gdImageCreateFromPng=$(usex png)
		php_cv_lib_gd_gdImageCreateFromTga=yes
		php_cv_lib_gd_gdImageCreateFromWebp=$(usex webp)
		php_cv_lib_gd_gdImageCreateFromXpm=$(usex xpm)
	)

	# LDAP support
	if use ldap ; then
		our_conf+=(
			$(use_with ldap ldap "${EPREFIX}/usr")
			$(use_with ldap-sasl)
		)
	fi

	# MySQL support
	our_conf+=( $(use_with mysqli) )

	local mysqlsock="${EPREFIX}/var/run/mysqld/mysqld.sock"
	if use mysql || use mysqli ; then
		our_conf+=( $(use_with mysql mysql-sock "${mysqlsock}") )
	fi

	# ODBC support
	if use odbc && use iodbc ; then
	# Obtain the correct -l and -I flags for the actual build from
	# pkg-config. We use the "generic" library type to avoid the
	# (wrong) hard-coded include dir for iodbc.
	#
	# We set the pdo_odbc_def_incdir variable because the
	# ./configure script checks for the headers using "test -f" and
	# ignores your CFLAGS... and pdo_odbc_def_libdir prevents the
	# build system from appending a nonsense -L flag.
		local iodbc_ldflags=$(pkg-config --libs libiodbc)
		local iodbc_cflags=$(pkg-config --cflags libiodbc)
		our_conf+=(
			pdo_odbc_def_libdir="${EPREFIX}/usr/$(get_libdir)"
			pdo_odbc_def_incdir="${EPREFIX}/usr/include/iodbc"
			$(use_with pdo pdo-odbc "generic,,iodbc,${iodbc_ldlags},${iodbc_cflags}")
			--with-iodbc
			--without-unixODBC
		)
	elif use odbc ; then
		our_conf+=(
			$(use_with pdo pdo-odbc "unixODBC,${EPREFIX}/usr")
			--with-unixODBC="${EPREFIX}/usr"
			--without-iodbc
		)
	else
		our_conf+=(
			--without-iodbc
			--without-pdo-odbc
			--without-unixODBC
		)
	fi

	# PDO support
	if use pdo ; then
		our_conf+=(
			$(use_with mssql pdo-dblib "${EPREFIX}/usr")
			$(use_with mysql pdo-mysql "mysqlnd")
			$(use_with oci8-instant-client pdo-oci)
			$(use_with postgres pdo-pgsql)
			$(use_with sqlite pdo-sqlite)
		)
	fi

	# readline/libedit support
	our_conf+=(
		$(use_with libedit)
		$(use_with readline readline "${EPREFIX}/usr")
	)

	# Session support
	if use session ; then
		our_conf+=( $(use_with session-mm mm "${EPREFIX}/usr") )
	else
		our_conf+=( $(use_enable session) )
	fi

	# Use pic for shared modules such as apache2's mod_php
	our_conf+=( --with-pic )

	# we use the system copy of pcre
	# --with-external-pcre affects ext/pcre
	our_conf+=(
		--with-external-pcre
		$(use_with jit pcre-jit)
	)

	# Catch CFLAGS problems
	# Fixes bug #14067.
	# Changed order to run it in reverse for bug #32022 and #12021.
	replace-cpu-flags "k6*" "i586"

	# Support user-passed configuration parameters
	our_conf+=( ${EXTRA_ECONF:-} )

	# Support the Apache2 extras, they must be set globally for all
	# SAPIs to work correctly, especially for external PHP extensions

	# Create separate build trees for each enabled SAPI. The upstream
	# build system doesn't do this, but we have to do it to use a
	# different php.ini for each SAPI (see --with-config-file-path and
	# --with-config-file-scan-dir below). The path winds up define'd
	# in main/build-defs.h which is included in main/php.h which is
	# included by basically everything; so, avoiding a rebuild after
	# changing it is not an easy job.
	#
	# The upstream build system also does not support building the
	# apache2 and embed SAPIs at the same time, presumably because they
	# both produce a libphp.so.

	local _sapi
	mkdir -p "${WORKDIR}/sapis-build" || true

	# Cache/isolate the ./configure test results between SAPIs.
	mkdir -p "${T}/${sapi}" || true
	our_conf+=( --cache-file="${T}/${sapi}/config.cache" )

	php_set_ini_dir "${sapi}"

	# The BUILD_DIR variable is used to determine where to output
	# the files that autotools creates. This was all originally
	# based on the autotools-utils eclass.
	BUILD_DIR="${WORKDIR}/sapis-build/${sapi}"
	cp -a "${S}_${sapi}" "${BUILD_DIR}" || die
	cd "${BUILD_DIR}" || die

	local sapi_conf=(
		--with-config-file-path="${PHP_INI_DIR}"
		--with-config-file-scan-dir="${PHP_EXT_INI_DIR_ACTIVE}"
	)

	for _sapi in ${SAPIS} ; do
		case "${_sapi}" in
			cli|cgi|embed|fpm|phpdbg)
				if [[ "${sapi}" == "${_sapi}" ]] ; then
					sapi_conf+=( "--enable-${_sapi}" )
					if [[ "fpm" == "${_sapi}" ]] ; then
						sapi_conf+=(
							$(use_with acl fpm-acl)
							$(use_with systemd fpm-systemd)
						)
					fi
				else
					sapi_conf+=( "--disable-${_sapi}" )
				fi
				;;

			apache2)
				if [[ "${sapi}" == "${_sapi}" ]] ; then
					sapi_conf+=( --with-apxs2="${EPREFIX}/usr/bin/apxs" )
				else
					sapi_conf+=( --without-apxs2 )
				fi
				;;
		esac
	done

	# Construct the $myeconfargs array by concatenating $our_conf
	# (the common args) and $sapi_conf (the SAPI-specific args).
	local myeconfargs=( "${our_conf[@]}" )
	myeconfargs+=( "${sapi_conf[@]}" )

	pushd "${BUILD_DIR}" > /dev/null || die
einfo "Running econf in ${BUILD_DIR}"
		econf ${myeconfargs[@]}
	popd > /dev/null || die
}

_src_compile() {
	# snmp seems to run during src_compile, too (bug #324739)
	addpredict /usr/share/snmp/mibs/.index #nowarn
	addpredict /var/lib/net-snmp/mib_indexes #nowarn
	emake -C "${WORKDIR}/sapis-build/${sapi}"
}

src_compile() {
	local sapi
	for sapi in ${SAPIS} ; do
		if use ${sapi} ; then
			if use cgi ; then
				if [[ "${sapi}" == "cgi" || "${sapi}" == "cli" ]] ; then
					UOPTS_IMPLS="_${sapi}"
				else
					UOPTS_IMPLS="_cgi"
				fi
			fi
			uopts_src_compile
		fi
	done
}

_tpgo_custom_clean() {
	:
	rm -f "${T}/${sapi}/config.cache"
}

_src_test() {
	local mode="${1}"
	if [[ "${sapi}" == "cli" ]] ; then
		_src_test_cli "${mode}"
	elif [[ "${sapi}" == "cgi" ]] ; then
		_src_test_cgi "${mode}"
	fi
}

_src_test_cgi() {
	local mode="${1}"
	export TEST_PHP_EXECUTABLE="${WORKDIR}/sapis-build/cli/sapi/cli/php"

	if [[ -x "${WORKDIR}/sapis-build/cgi/sapi/cgi/php-cgi" ]] ; then
		export TEST_PHP_CGI_EXECUTABLE="${WORKDIR}/sapis-build/cgi/sapi/cgi/php-cgi"
	fi

	if [[ "${mode}" == "pgo" ]] ; then
		if use trainer-benchmark ; then
			"${TEST_PHP_EXECUTABLE}" "${S}/benchmark/benchmark.php" "true" "${TEST_PHP_CGI_EXECUTABLE}" || die
		fi
	fi
	unset TEST_PHP_EXECUTABLE
	unset TEST_PHP_CGI_EXECUTABLE
}

_src_test_cli() {
	local mode="${1}"
	export TEST_PHP_EXECUTABLE="${WORKDIR}/sapis-build/cli/sapi/cli/php"

	# Sometimes when the sub-php launches a sub-sub-php, it uses these.
	# Without an "-n" in all instances, the *live* php.ini can be loaded,
	# pulling in *live* zend extensions. And those can be incompatible
	# with the thing we just built.
	export TEST_PHP_EXTRA_ARGS="-n"

	if [[ -x "${WORKDIR}/sapis-build/cgi/sapi/cgi/php-cgi" ]] ; then
		export TEST_PHP_CGI_EXECUTABLE="${WORKDIR}/sapis-build/cgi/sapi/cgi/php-cgi"
	fi

	if [[ -x "${WORKDIR}/sapis-build/phpdbg/sapi/phpdbg/phpdbg" ]] ; then
		export TEST_PHPDBG_EXECUTABLE="${WORKDIR}/sapis-build/phpdbg/sapi/phpdbg/phpdbg"
	fi

	# The IO capture tests need to be disabled because they fail when
	# std{in,out,err} are redirected (as they are within portage).
	#
	# One -n applies to the top-level "php", while the other applies
	# to any sub-php that get invoked by the test runner.
	if [[ "${mode}" == "default" ]] ; then
		REPORT_EXIT_STATUS=1 \
		SKIP_IO_CAPTURE_TESTS=1 \
		SKIP_PERF_SENSITIVE=1 \
		"${TEST_PHP_EXECUTABLE}" -n \
			"${WORKDIR}/sapis-build/cli/run-tests.php" \
			--offline \
			-n \
			-q \
			-d "session.save_path=${T}" \
			|| die "tests failed"
	elif [[ "${mode}" == "pgo" ]] ; then
# See https://qa.php.net/running-tests.php
		local test_list=()
		if use trainer-basic ; then
			test_list+=(
				"tests/basic"
				"tests/classes"
				"tests/func"
				"tests/lang"
				"tests/lang/integer_literals"
				"tests/lang/operators"
				"tests/lang/string"
				"tests/output"
				"tests/run-test"
				"tests/security"
				"tests/strings"
			)
		fi
		if use trainer-ext ; then
			test_list+=(
#				"ext/skeleton/tests" # do not use
			)
			if use bcmath ; then
				test_list+=(
					"ext/bcmath/tests"
				)
			fi
			if use bzip2 ; then
				test_list+=(
					"ext/bz2/tests"
				)
			fi
			if use calendar ; then
				test_list+=(
					"ext/calendar/tests"
				)
			fi
			if use cgi ; then
				test_list+=(
					"sapi/cgi/tests"
				)
			fi
			if use cli ; then
				test_list+=(
					"sapi/cli/tests"
				)
			fi
			if use ctype ; then
				test_list+=(
					"ext/ctype/tests"
				)
			fi
			if use curl ; then
				test_list+=(
					"ext/curl/tests"
				)
			fi
			if use_dba ; then
				test_list+=(
					"ext/dba/tests"
				)
			fi
			if use enchant ; then
				test_list+=(
					"ext/enchant/tests"
				)
			fi
			if use exif ; then
				test_list+=(
					"ext/exif/tests"
				)
			fi
			if use ffi ; then
				test_list+=(
					"ext/ffi/tests"
				)
			fi
			if use fileinfo ; then
				test_list+=(
					"ext/fileinfo/tests"
				)
			fi
			if use filter ; then
				test_list+=(
					"ext/filter/tests"
				)
			fi
			if use fpm ; then
				test_list+=(
					"sapi/fpm/tests"
				)
			fi
			if use ftp ; then
				test_list+=(
					"ext/ftp/tests"
				)
			fi
			if use gd ; then
				test_list+=(
					"ext/gd/tests"
				)
			fi
			if use gmp ; then
				test_list+=(
					"ext/gmp/tests"
				)
			fi
			if use iconv ; then
				test_list+=(
					"ext/iconv/tests"
				)
			fi
			if use imap ; then
				test_list+=(
					"ext/imap/tests"
				)
			fi
			if use intl ; then
				test_list+=(
					"ext/intl/tests"
					"ext/intl/uchar/tests"
				)
			fi
#			if use json ; then
				test_list+=(
					"ext/json/tests"
				)
#			fi
			if use ldap ; then
				test_list+=(
					"ext/ldap/tests"
				)
			fi
			if use mbstring ; then
				test_list+=(
					"ext/mbstring/tests"
				)
			fi
			if use mhash ; then
				test_list+=(
					"ext/hash/tests"
			)
			fi
			if use mysqli ; then
				test_list+=(
					"ext/mysqli/tests"
				)
			fi
			if use nls ; then
				test_list+=(
					"ext/gettext/tests"
				)
			fi
			if use oci8-instant-client ; then
				test_list+=(
					"ext/oci8/tests"
				)
			fi
			if use odbc ; then
				test_list+=(
					"ext/odbc/tests"
				)
			fi
			if use opcache ; then
				test_list+=(
					"ext/opcache/tests"
				)
			fi
			if use opcache ; then
				test_list+=(
					"ext/opcache/tests/jit"
				)
			fi
			if use openssl ; then
				test_list+=(
					"ext/openssl/tests"
				)
			fi
			if use pcntl ; then
				test_list+=(
					"ext/pcntl/tests"
				)
			fi
			if use pcre ; then
				test_list+=(
					"ext/pcre/tests"
				)
			fi
			if use pdo ; then
				test_list+=(
					"ext/pdo/tests"
				)
			fi
			if use pdo && use mssql ; then
				test_list+=(
					"ext/pdo_dblib/tests"
				)
			fi
			if use pdo && use oci8-instant-client ; then
				test_list+=(
					"ext/pdo_oci/tests"
				)
			fi
			if use pdo && use odbc ; then
				test_list+=(
					"ext/pdo_odbc/tests"
				)
			fi
			if use pdo && use postgres ; then
				test_list+=(
					"ext/pdo_pgsql/tests"
				)
			fi
			if use pdo && use sqlite ; then
				test_list+=(
					"ext/pdo_sqlite/tests"
				)
			fi
			if use phar ; then
				test_list+=(
					"ext/phar/tests"
					"ext/phar/tests/cache_list"
					"ext/phar/tests/tar"
					"ext/phar/tests/zip"
				)
			fi
			if use phpdbg ; then
				test_list+=(
					"sapi/phpdbg/tests"
				)
			fi
			if use posix ; then
				test_list+=(
					"ext/posix/tests"
				)
			fi
			if use postgres ; then
				test_list+=(
					"ext/pgsql/tests"
				)
			fi
			if use readline ; then
				test_list+=(
					"ext/readline/tests"
				)
			fi
			if use session ; then
				test_list+=(
					"ext/session/tests"
					"ext/session/tests/user_session_module"
				)
			fi
			if use sharedmem ; then
				test_list+=(
					"ext/shmop/tests"
				)
			fi
			if use simplexml ; then
				test_list+=(
					"ext/simplexml/tests"
				)
			fi
			if use soap ; then
				test_list+=(
					"ext/soap/tests"
					"ext/soap/tests/bugs"
					"ext/soap/tests/interop/Round2/Base"
					"ext/soap/tests/interop/Round2/GroupB"
					"ext/soap/tests/interop/Round3/GroupD"
					"ext/soap/tests/interop/Round3/GroupE"
					"ext/soap/tests/interop/Round3/GroupF"
					"ext/soap/tests/interop/Round4/GroupH"
					"ext/soap/tests/interop/Round4/GroupI"
					"ext/soap/tests/schema"
					"ext/soap/tests/soap12"
				)
			fi
			if use sockets ; then
				test_list+=(
					"ext/sockets/tests"
				)
			fi
			if use sodium ; then
				test_list+=(
					"ext/sodium/tests"
				)
			fi
			if use spell ; then
				test_list+=(
					"ext/pspell/tests"
				)
			fi
			if use sqlite ; then
				test_list+=(
					"ext/sqlite3/tests"
				)
			fi
			if use sysvipc ; then
				test_list+=(
					"ext/sysvmsg/tests"
					"ext/sysvsem/tests"
				)
			fi
			if use tidy ; then
				test_list+=(
					"ext/tidy/tests"
				)
			fi
			if use tokenizer ; then
				test_list+=(
					"ext/tokenizer/tests"
				)
			fi
			if use xml ; then
				test_list+=(
					"ext/xml/tests"
					"ext/libxml/tests"
				)
			fi
			if use xmlreader ; then
				test_list+=(
					"ext/xmlreader/tests"
				)
			fi
			if use xmlwriter ; then
				test_list+=(
					"ext/xmlwriter/tests"
				)
			fi
			if use xslt ; then
				test_list+=(
					"ext/xsl/tests"
				)
			fi
			if use zip ; then
				test_list+=(
					"ext/zip/tests"
				)
			fi
			if use zlib ; then
				test_list+=(
					"ext/zlib/tests"
				)
			fi
		fi
		if use trainer-ext-com_dotnet ; then
			test_list+=(
				"ext/com_dotnet"
			)
		fi
		if use trainer-ext-date ; then
			test_list+=(
				"ext/date/tests"
			)
		fi
		if use trainer-ext-dom ; then
			test_list+=(
				"ext/dom/tests"
			)
		fi
		if use trainer-ext-random ; then
			test_list+=(
				"ext/random/tests"
				"ext/random/tests/01_functions"
				"ext/random/tests/02_engine"
				"ext/random/tests/03_randomizer"
				"ext/random/tests/03_randomizer/methods"
			)
		fi
		if use trainer-ext-reflection ; then
			test_list+=(
				"ext/reflection/tests"
			)
		fi
		if use trainer-ext-spl ; then
			test_list+=(
				"ext/spl/tests"
				"ext/spl/tests/SplFileObject"
			)
		fi
		if use trainer-ext-standard ; then
			test_list+=(
				"ext/standard/tests"
				"ext/standard/tests/array"
				"ext/standard/tests/assert"
				"ext/standard/tests/class_object"
				"ext/standard/tests/crypt"
				"ext/standard/tests/dir"
				"ext/standard/tests/directory"
				"ext/standard/tests/file"
				"ext/standard/tests/filters"
				"ext/standard/tests/general_functions"
				"ext/standard/tests/http"
				"ext/standard/tests/hrtime"
				"ext/standard/tests/image"
				"ext/standard/tests/ini_info"
				"ext/standard/tests/mail"
				"ext/standard/tests/math"
				"ext/standard/tests/misc"
				"ext/standard/tests/network"
				"ext/standard/tests/password"
				"ext/standard/tests/serialize"
				"ext/standard/tests/streams"
				"ext/standard/tests/strings"
				"ext/standard/tests/time"
				"ext/standard/tests/url"
				"ext/standard/tests/versioning"
			)
		fi
		if use trainer-zend ; then
			test_list+=(
				"ext/zend_test/tests"
				"Zend/tests"
				"Zend/tests/anon"
				"Zend/tests/arg_unpack"
				"Zend/tests/array_unpack"
				"Zend/tests/arrow_functions"
				"Zend/tests/assert"
				"Zend/tests/attributes"
				"Zend/tests/attributes/override"
				"Zend/tests/closures"
				"Zend/tests/constants"
				"Zend/tests/constants/final_constants"
				"Zend/tests/constexpr"
				"Zend/tests/enum"
				"Zend/tests/fibers"
				"Zend/tests/float_to_int"
				"Zend/tests/function_arguments"
				"Zend/tests/generators"
				"Zend/tests/generators/errors"
				"Zend/tests/generators/finally"
				"Zend/tests/gh10168"
				"Zend/tests/grammar"
				"Zend/tests/in-de-crement"
				"Zend/tests/list"
				"Zend/tests/multibyte"
				"Zend/tests/named_params"
				"Zend/tests/nullable_types"
				"Zend/tests/nullsafe_operator"
				"Zend/tests/numeric_strings"
				"Zend/tests/object_types"
				"Zend/tests/parameter_default_values"
				"Zend/tests/prop_const_expr"
				"Zend/tests/readonly_classes"
				"Zend/tests/readonly_props"
				"Zend/tests/restrict_globals"
				"Zend/tests/return_types"
				"Zend/tests/stack_limit"
				"Zend/tests/traits"
				"Zend/tests/try"
				"Zend/tests/type_declarations"
				"Zend/tests/type_declarations/dnf_types"
				"Zend/tests/type_declarations/intersection_types"
				"Zend/tests/type_declarations/intersection_types/invalid_types"
				"Zend/tests/type_declarations/intersection_types/redundant_types"
				"Zend/tests/type_declarations/intersection_types/variance"
				"Zend/tests/type_declarations/iterable"
				"Zend/tests/type_declarations/literal_types"
				"Zend/tests/type_declarations/mixed"
				"Zend/tests/type_declarations/mixed/casting"
				"Zend/tests/type_declarations/mixed/inheritance"
				"Zend/tests/type_declarations/mixed/syntax"
				"Zend/tests/type_declarations/mixed/validation"
				"Zend/tests/type_declarations/union_types"
				"Zend/tests/type_declarations/union_types/redundant_types"
				"Zend/tests/type_declarations/union_types/variance"
				"Zend/tests/type_declarations/variance"
				"Zend/tests/use_const"
				"Zend/tests/use_function"
				"Zend/tests/variadic"
				"Zend/tests/varSyntax"
				"Zend/tests/weakrefs"
				"Zend/tests/zend_ini"
			)
		fi
		if use trainer-all || use trainer-basic ; then
			REPORT_EXIT_STATUS=1 \
			SKIP_IO_CAPTURE_TESTS=1 \
			SKIP_PERF_SENSITIVE=1 \
			SKIP_SLOW_TESTS=1 \
			"${TEST_PHP_EXECUTABLE}" -n \
				"${WORKDIR}/sapis-build/cli/run-tests.php" \
				--offline \
				-n \
				-q \
				-d "session.save_path=${T}" \
				-d "sendmail_path=echo >/dev/null" \
				${test_list[@]} \
				|| die "tests failed"
		fi
	fi

# Prevent error:
# /bin/sh: - : invalid option
	unset TEST_PHP_EXECUTABLE
	unset TEST_PHP_EXTRA_ARGS
	unset TEST_PHP_CGI_EXECUTABLE
	unset TEST_PHPDBG_EXECUTABLE
}

train_trainer_custom() {
	_src_test "pgo"
}

src_test() {
	_src_test "default"
}

_install_single_sapi() {
	use "${sapi}" || return
einfo "Installing SAPI: ${sapi}"
	cd "${WORKDIR}/sapis-build/${sapi}" || die

	if [[ "${sapi}" == "apache2" ]] ; then
		# We're specifically not using emake install-sapi as libtool
		# may cause unnecessary relink failures (see bug #351266)
		insinto "${PHP_DESTDIR#${EPREFIX}}/apache2/"
		newins \
			".libs/libphp$(get_libname)" \
			"libphp${PHP_MV}$(get_libname)"
		keepdir "/usr/$(get_libdir)/apache2/modules"
	else
		# needed each time, php_install_ini would reset it
		local dest="${PHP_DESTDIR#${EPREFIX}}"
		into "${dest}"
		case "$sapi" in
			cli)
				source="sapi/cli/php"
				# Install the "phar" archive utility.
				if use phar ; then
					emake \
						INSTALL_ROOT="${D}" \
						install-pharcmd
					dosym \
						"..${dest#/usr}/bin/phar" \
						"/usr/bin/phar${SLOT}"
				fi
				;;
			cgi)
				source="sapi/cgi/php-cgi"
				;;
			embed)
				source="libs/libphp$(get_libname)"
				;;
			fpm)
				source="sapi/fpm/php-fpm"
				;;
			phpdbg)
				source="sapi/phpdbg/phpdbg"
				;;
			*)
				die "unhandled sapi in src_install"
				;;
		esac

		if [[ "${source}" == *"$(get_libname)" ]] ; then
			dolib.so "${source}"
		else
			dobin "${source}"
			local name="$(basename ${source})"
			dosym "..${dest#/usr}/bin/${name}" "/usr/bin/${name}${SLOT}"
		fi
	fi

	php_install_ini "${sapi}"

	# construct correct SAPI string for php-config
	# thanks to ferringb for the bash voodoo
	if [[ "${sapi}" == "apache2" ]] ; then
		sapi_list="${sapi_list:+${sapi_list} }apache2handler"
	else
		sapi_list="${sapi_list:+${sapi_list} }${sapi}"
	fi
}

src_install() {
	# see bug #324739 for what happens when we don't have that
	addpredict /usr/share/snmp/mibs/.index #nowarn

	# grab the first SAPI that got built and install common files from there
	local first_sapi=""
	local sapi=""
	for sapi in $SAPIS ; do
		if use $sapi ; then
			first_sapi=$sapi
			break
		fi
	done

	# Install SAPI-independent targets
	cd "${WORKDIR}/sapis-build/$first_sapi" || die
	emake INSTALL_ROOT="${D}" \
		install-build install-headers install-programs
	use opcache && emake INSTALL_ROOT="${D}" install-modules

	# Create the directory where we'll put version-specific php scripts
	keepdir "/usr/share/php${PHP_MV}"

	local sapi_list=""

	for sapi in ${SAPIS} ; do
		_install_single_sapi
	done

	# Install env.d files
	newenvd "${FILESDIR}/20php5-envd" "20php${SLOT}"
	sed -i \
		-e "s|/lib/|/$(get_libdir)/|g" \
		"${ED}/etc/env.d/20php${SLOT}" \
		|| die
	sed -i \
		-e "s|php5|php${SLOT}|g" \
		"${ED}/etc/env.d/20php${SLOT}" \
		|| die

	# set php-config variable correctly (bug #278439)
	sed -i \
		-e "s:^\(php_sapis=\)\".*\"$:\1\"${sapi_list}\":" \
		"${ED}/usr/$(get_libdir)/php${SLOT}/bin/php-config" \
		|| die

	if use fpm ; then
		if use systemd ; then
			systemd_newunit \
				"${FILESDIR}/php-fpm_at.service" \
				"php-fpm@${SLOT}.service"
		else
			systemd_newunit \
				"${FILESDIR}/php-fpm_at-simple.service" \
				"php-fpm@${SLOT}.service"
		fi
	fi

	for sapi in ${SAPIS} ; do
		if use cgi ; then
			if [[ "${sapi}" == "cgi" || "${sapi}" == "cli" ]] ; then
				UOPTS_IMPLS="_${sapi}"
			else
				UOPTS_IMPLS="_cgi"
			fi
		fi
		uopts_src_install
	done
}

pkg_postinst() {
	uopts_pkg_postinst
	# Output some general info to the user
	if use apache2 ; then
elog
elog "To enable PHP in apache, you will need to add \"-D PHP\" to your apache2"
elog "command. OpenRC users can append that string to APACHE2_OPTS in"
elog "/etc/conf.d/apache2."
elog
elog "The apache module configuration file 70_mod_php.conf is provided (and"
elog "maintained) by eselect-php."
elog
	fi

	# Create the symlinks for php
	local m
	for m in ${SAPIS} ; do
		[[ "${m}" == "embed" ]] && continue;
		if use ${m} ; then
			local ci=$(eselect php show ${m})
			if [[ -z "${ci}" ]] ; then
				eselect php set ${m} php${SLOT} || die
einfo "Switched ${m} to use php:${SLOT}"
			elif [[ "${ci}" != "php${SLOT}" ]] ; then
einfo
einfo "To switch $m to use php:${SLOT}, run"
einfo
einfo "    eselect php set $m php${SLOT}"
einfo
			fi
		fi
	done

	# Remove dead symlinks for SAPIs that were just disabled. For
	# example, if the user has the cgi SAPI enabled, then he has an
	# eselect-php symlink for it. If he later reinstalls PHP with
	# USE="-cgi", that symlink will break. This call to eselect is
	# supposed to remove that dead link per bug 572436.
	eselect php cleanup || die

	if ! has "php${SLOT/./-}" ${PHP_TARGETS} ; then
einfo
einfo "To build extensions for this version of PHP, you will need to"
einfo "add php${SLOT/./-} to your PHP_TARGETS USE_EXPAND variable."
einfo
	fi

	# Warn about the removal of PHP_INI_VERSION if the user has it set.
	if [[ -n "${PHP_INI_VERSION}" ]] ; then
ewarn
ewarn "The PHP_INI_VERSION variable has been phased out. You may remove it from"
ewarn "your configuration at your convenience.  For more information, see"
ewarn
ewarn "  https://bugs.gentoo.org/611214"
ewarn
	fi
einfo
einfo "For details on how version slotting works, please see"
einfo "the wiki:"
einfo
einfo "  https://wiki.gentoo.org/wiki/PHP"
einfo
}

pkg_postrm() {
	# This serves two purposes. First, if we have just removed the last
	# installed version of PHP, then this will remove any dead symlinks
	# belonging to eselect-php. Second, if a user upgrades slots from
	# (say) 5.6 to 7.0 and depcleans the old slot, then this will update
	# his existing symlinks to point to the new 7.0 installation. The
	# latter is bug 432962.
	#
	# Note: the eselect-php package may not be installed at this point,
	# so we can't die() if this command fails.
	eselect php cleanup
}

# OILEDMACHINE-OVERLAY-META-EBUILD-CHANGES:  pgo, bolt (WIP)
