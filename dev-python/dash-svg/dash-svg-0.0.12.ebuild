# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Missing:
# sci-visualization/dash[testing]

NPM_SLOT=2 # Limited by React 16.14.0.
NPM_TARBALL="${P}.tar.gz"
NODE_VERSION=18 # Upstream uses node 12.  14 works
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12
REACT_PV="16.14.0" # Supports up to node 14 used for testing.  node 14 uses npm 6.14.18 which is lockfile v1.
#REACT_PV="18.3.1" # Supports up to node 17

inherit distutils-r1 edo npm

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/stevej2608/dash-svg/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="SVG support library for Plotly/Dash"
HOMEPAGE="
https://github.com/stevej2608/dash-svg
https://pypi.org/project/dash-svg/
"
LICENSE="MIT" # https://github.com/stevej2608/dash-svg/blob/0.0.12/DESCRIPTION#L8
RESTRICT="mirror test" # Missing sci-visualization/dash[testing]
SLOT="0"
IUSE="test ebuild_revision_5"
RDEPEND+="
	>=dev-python/twine-3.7.1[${PYTHON_USEDEP}]
	>=dev-python/keyrings-alt-4.1.0[${PYTHON_USEDEP}]
	>=sci-visualization/dash-1.15.0[${PYTHON_USEDEP},dev(+)]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	net-libs/nodejs:${NODE_VERSION}[webassembly(+)]
	sys-apps/npm:${NPM_SLOT}
	test? (
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/selenium[${PYTHON_USEDEP}]
	)
"

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

npm_unpack_post() {
	pushd "${S}" >/dev/null 2>&1 || die
		eapply "${FILESDIR}/dash-svg-0.0.12-use-fetch-api.patch"	# Untested patch
	popd >/dev/null 2>&1 || die
}

npm_update_lock_audit_post() {
	localfile_edits() {
		sed -i -e "s|\"loader-utils\": \"^1.1.0\"|\"loader-utils\": \"^1.4.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"^1.2.3\"|\"loader-utils\": \"^1.4.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"loader-utils\": \"1.2.3\"|\"loader-utils\": \"^1.4.2\"|g" "package-lock.json" || die

		sed -i -e "s|\"braces\": \"~3.0.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
		sed -i -e "s|\"braces\": \"^2.3.2\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die
		sed -i -e "s|\"braces\": \"^2.3.1\"|\"braces\": \"^3.0.3\"|g" "package-lock.json" || die

		sed -i -e "s|\"ansi-regex\": \"^4.1.0\"|\"ansi-regex\": \"^4.1.1\"|g" "package-lock.json" || die
		sed -i -e "s|\"ansi-regex\": \"^3.0.0\"|\"ansi-regex\": \"^4.1.1\"|g" "package-lock.json" || die
		sed -i -e "s|\"ansi-regex\": \"^2.0.0\"|\"ansi-regex\": \"^4.1.1\"|g" "package-lock.json" || die

		sed -i -e "s|\"postcss\": \"^7.0.32\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.14\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.5\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die
		sed -i -e "s|\"postcss\": \"^7.0.6\"|\"postcss\": \"^8.4.31\"|g" "package-lock.json" || die

		sed -i -e "s|\"tough-cookie\": \"~2.5.0\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die
		sed -i -e "s|\"tough-cookie\": \"^2.3.3\"|\"tough-cookie\": \"^4.1.3\"|g" "package-lock.json" || die

#		sed -i -e "s|\"got\": \"^6.7.1\"|\"got\": \"^11.8.5\"|g" "package-lock.json" || die

		# Use v8 which is backwards compatible with v1 lockfile
		sed -i -e "s|\"npm\": \"^6.1.0\"|\"npm\": \"8.12.2\"|g" "package-lock.json" || die

#		sed -i -e "s|\"ip\": \"1.1.5\"|\"ip\": \"1.1.9\"|g" "package-lock.json" || die
#		sed -i -e "s|\"ip\": \"^1.1.5\"|\"ip\": \"1.1.9\"|g" "package-lock.json" || die

		sed -i -e "s|\"cheerio\": \"^0.22.0\"|\"cheerio\": \"1.0.0\"|g" "package-lock.json" || die

		sed -i -e "s|\"serialize-javascript\": \"^4.0.0\"|\"serialize-javascript\": \"^6.0.2\"|g" "package-lock.json" || die

		sed -i -e "s|\"pbkdf2\": \"^3.1.2\"|\"pbkdf2\": \"3.1.3\"|" "package-lock.json" || die
		sed -i -e "s|\"http-proxy-middleware\": \"^1.0.3\"|\"http-proxy-middleware\": \"2.0.8\"|g" "package-lock.json" || die
		sed -i -e "s|\"undici\": \"^6.19.5\"|\"undici\": \"6.21.2\"|g" "package-lock.json" || die

		sed -i -e "s|\"tmp\": \"^0.0.33\"|\"tmp\": \"0.2.4\"|g" "package-lock.json" || die
		sed -i -e "s|\"koa\": \"^2.5.3\"|\"koa\": \"^2.16.2\"|g" "package-lock.json" || die
		sed -i -e "s|\"koa\": \"^2.16.1\"|\"koa\": \"^2.16.2\"|g" "package-lock.json" || die
	}
	localfile_edits

	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	# ZC = Zero Click Attack

	local pkgs=(
		# webpack
		"loader-utils@^1.4.2"			# CVE-2022-37601			# DoS, DT, ID

		# watchpack
		"braces@^3.0.3"				# CVE-2024-4068				# DoS

		"tough-cookie@^4.1.3"			# CVE-2023-26136			# DT, ID

		# npm
#		"ansi-regex@^4.1.1"			# CVE-2021-3807				# DoS
#		"got@^11.8.5"				# CVE-2022-33987			# DT
#		"ip@^1.1.9"				# CVE-2023-42282			# DoS, DT, ID # For npm

		# css loader
		"postcss@^8.4.31"			# CVE-2023-44270			# DT

		# cheerio, parent webpack
		# lodash.pick				# CVE-2020-8203				# DT, ID
		"cheerio@1.0.0"				# Bumped version to prune lodash.pick

		# Bump parent packages to remove vulnerable dependencies while node 14.x compatible
#		"npm@8.12.2"

		"webpack@^4.47.0"			# 4.x series
		"webpack-cli@^4.10.0"
		"webpack-serve@^4.0.0"

		"serialize-javascript@6.0.2"		# CVE-2024-11831			# DT, ID

		"pbkdf2@3.1.3"				# CVE-2025-6547				# ZC, VS(DT), SS(DoS, DT, ID)
							# CVE-2025-6545				# ZC, VS(DT, ID), SS(DoS, DT, ID)
		"http-proxy-middleware@2.0.8"		# CVE-2025-32996			# DoS
		"koa@2.16.1"				# CVE-2025-32379			# DoS, DT, ID
		"undici@6.21.2"				# CVE-2025-47279			# DoS

		"tmp@0.2.4"				# CVE-2025-54798			# DT
		"koa@^2.16.2"				# CVE-2025-8129				# DT
	)
	enpm install "${pkgs[@]}" -D --prefer-offline

	local pkgs=(
		"npm"
	# request EOL so remove it			# CVE-2023-28155			# DT, ID
		"request"				# CVE-2023-28155			# DT, ID
		"request-promise"
	)
	enpm uninstall "${pkgs[@]}" -D --prefer-offline

	# Reapply

	localfile_edits

	enpm dedupe

	# When `npm install <package>` or `npm dedupe` gets called, it may undo lockfile edits.
	localfile_edits

	# Same vulnerability count before and after
	enpm audit
}

src_unpack() {
	npm_src_unpack
}

src_compile() {
	npm_hydrate
	enpm run build
	distutils-r1_src_compile
	find "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" -name "dash_svg.dev.js" | grep -q "dash_svg.dev.js" || die
	find "${WORKDIR}/${PN}-${PV}-${EPYTHON/./_}/install" -name "dash_svg.min.js" | grep -q "dash_svg.min.js" || die
}

src_test() {
	pytest || die
}

src_install() {
	distutils-r1_src_install
}
