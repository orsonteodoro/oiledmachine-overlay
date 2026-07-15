# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Missing:
# sci-visualization/dash[testing]

# To update lockfile
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="0.0.12" npm_updater_update_locks.sh

DISTUTILS_USE_PEP517="setuptools"
NODE_SLOT="24" # Upstream uses node 12.  14, 18 works
NPM_AUDIT_FATAL=0
NPM_SLOT=2 # Limited by React 16.14.0.
NPM_TARBALL="${P}.tar.gz"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12
REACT_PV="16.14.0" # Supports up to node 14 used for testing.  node 14 uses npm 6.14.18 which is lockfile v1.
#REACT_PV="18.3.1" # Supports up to node 17

inherit distutils-r1 edo npm secure-version

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
IUSE="
test
ebuild_revision_9
"
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
	>=net-libs/nodejs-${NODEJS_24_PV}:${NODE_SLOT}[webassembly(+)]
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
	# CE = Code Execution
	# DoS = Denial of Service
	# DT = Data Tampering
	# ID = Information Disclosure
	# ZC = Zero Click Attack

	local pkgs=(
		# webpack
		"loader-utils@^1.4.2"				# CVE-2022-37601; DoS, DT, ID; Critical

		# watchpack
		"braces@^3.0.3"					# CVE-2024-4068; DoS; High

		"tough-cookie@^4.1.3"				# CVE-2023-26136; DT, ID; Moderate

		# npm
#		"ansi-regex@^4.1.1"				# CVE-2021-3807; DoS; High
#		"got@^11.8.5"					# CVE-2022-33987; DT; Moderate
#		"ip@^1.1.9"					# CVE-2023-42282; DoS, DT, ID; High # For npm

		# css loader
		"postcss@^8.4.31"				# CVE-2023-44270; DT; Moderate

		# cheerio, parent webpack
		# lodash.pick					# CVE-2020-8203; DT, ID; High
		"cheerio@^1.0.0"				# Bumped version to prune lodash.pick

		# Bump parent packages to remove vulnerable dependencies while node 14.x compatible
#		"npm@^8.12.2"

		"webpack@^4.47.0"				# 4.x series
		"webpack-cli@^4.10.0"
		"webpack-serve@^4.0.0"


		"pbkdf2@^3.1.3"					# CVE-2025-6547; ZC, VS(DT), SS(DoS, DT, ID)
								# CVE-2025-6545; ZC, VS(DT, ID), SS(DoS, DT, ID); Critical
		"http-proxy-middleware@^2.0.8"			# CVE-2025-32996; DoS; Moderate
		"koa@^2.16.1"					# CVE-2025-32379; DoS, DT, ID; Moderate
		"undici@^7.28.0"				# CVE-2025-47279; DoS; Low
								# CVE-2026-9697; ZC, DoS, DT; High
								# CVE-2026-6734; DoS, DT, ID; High
								# CVE-2026-9678; ZC, ID; Moderate
								# CVE-2026-9679; ZC, DT; Moderate
								# CVE-2026-11525; ZC, DT; Low
								# CVE-2026-6733; ZC, DT; Low

		"tmp@^0.2.6"					# CVE-2025-54798; DT; Low
								# CVE-2026-44705; ZC, VS(ID); High
		"koa@^2.16.2"					# CVE-2025-8129; DT
		"flatted@^3.4.2"				# CVE-2026-33228; ZC, VS(DoS, DT, ID); High
		"serialize-javascript@^7.0.5"			# CVE-2024-11831; DT, ID; Moderate
								# CVE-2026-34043; ZC, DoS; Moderate
								# GHSA-5c6j-r48x-rmvq; CE, VS(DoS, DT, ID); High

		"ws@^7.5.11"					# CVE-2026-48779; ZC, DoS; High

		"js-yaml@^3.15.0"				# CVE-2026-53550; ZC, DoS; Moderate
		"@babel/plugin-transform-modules-systemjs@^7.29.4"	# CVE-2026-44728; DoS, DT, ID; High
		"@babel/core@^7.29.6"				# CVE-2026-49356; ID; Low
	)
	enpm install "${pkgs[@]}" -D --prefer-offline

	local pkgs=(
		"npm"
	# request EOL so remove it				# CVE-2023-28155; DT, ID; Moderate
		"request"					# CVE-2023-28155; DT, ID; Moderate
		"request-promise"
	)
	enpm uninstall "${pkgs[@]}" -D --prefer-offline

	# Reapply

	enpm dedupe

	# When `npm install <package>` or `npm dedupe` gets called, it may undo lockfile edits.
	localfile_edits

	# Same vulnerability count before and after
	npm audit || npm_die
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
