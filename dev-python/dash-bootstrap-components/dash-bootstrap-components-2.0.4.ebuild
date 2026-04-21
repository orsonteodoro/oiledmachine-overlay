# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# To update lockfile:
# PATH=$(realpath "../../scripts")":${PATH}"
# NPM_UPDATER_VERSIONS="2.0.4" npm_updater_update_locks.sh

DISTUTILS_USE_PEP517="hatchling"
NPM_AUDIT_FATAL=0
NPM_TARBALL="${P}.tar.gz"
NODE_SLOT="22" # Upstream uses node 22
PYTHON_COMPAT=( "python3_"{10..13} ) # Lists up to 3.13

inherit distutils-r1 npm

KEYWORDS="~amd64"
S="${WORKDIR}/${P}"
SRC_URI="
https://github.com/facultyai/dash-bootstrap-components/archive/refs/tags/${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="Bootstrap components for Plotly Dash"
HOMEPAGE="
https://dash-bootstrap-components.opensource.faculty.ai/
https://github.com/facultyai/dash-bootstrap-components
https://pypi.org/project/dash-bootstrap-components/
"
LICENSE="Apache-2.0"
RESTRICT="mirror test" # Did not test
SLOT="0"
IUSE="
dev pandas
ebuild_revision_5
"
RDEPEND+="
	>=sci-visualization/dash-3.0.4[${PYTHON_USEDEP},dev(+)]
	pandas? (
		>=dev-python/numpy-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/pandas-2.2.3[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	net-libs/nodejs:${NODE_SLOT}[webassembly(+)]
	dev? (
		>=dev-python/pytest-8.3.4[${PYTHON_USEDEP}]
		>=dev-python/semver-3.0.2[${PYTHON_USEDEP}]
		>=dev-util/ruff-0.8.5
		>=sci-visualization/dash-2.0.0[${PYTHON_USEDEP},dev(+)]
	)
"
DOCS=( "README.md" )

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

npm_dedupe_post() {
	if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		patch_lockfile() {
			sed -i -e "s|\"@babel/runtime\": \"^7.0.0\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.5.5\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.6.3\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.8.4\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.8.7\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.9.2\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.12.5\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.24.7\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium
			sed -i -e "s|\"@babel/runtime\": \"^7.26.0\"|\"@babel/runtime\": \"^7.26.10\"|g" "package-lock.json" || die			# CVE-2025-27789; DoS; Medium


			sed -i -e "s|\"webpack-dev-server\": \"^4.7.4\"|\"webpack-dev-server\": \"5.2.1\"|g" "package-lock.json" || die			# CVE-2025-30360; ID; Medium
																			# CVE-2025-30359; ID; Medium

			sed -i -e "s|\"http-proxy-middleware\": \"^2.0.3\"|\"http-proxy-middleware\": \"^2.0.8\"|g" "package-lock.json" || die		# CVE-2025-27789; DoS; Medium

			sed -i -e "s|\"flatted\": \"^3.2.9\"|\"flatted\": \"^3.4.2\"|g" "package-lock.json" || die					# CVE-2026-33228; VS(DoS, DT, ID); High
			sed -i -e "s|\"lodash\": \"^4.17.21\"|\"lodash\": \"^4.18.0\"|g" "package-lock.json" || die					# CVE-2026-4800; DoS, DT, ID; High

			sed -i -e "s|\"minimatch\": \"^3.0.2\"|\"minimatch\": \"^10.2.2\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.0.4\"|\"minimatch\": \"^10.2.2\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.1.1\"|\"minimatch\": \"^10.2.2\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.1.2\"|\"minimatch\": \"^10.2.2\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
			sed -i -e "s|\"minimatch\": \"^3.1.5\"|\"minimatch\": \"^10.2.2\"|g" "package-lock.json" || die					# CVE-2026-27903; ZC, DoS; High
		}
		patch_lockfile

		local pkgs
		pkgs=(
			"@babel/runtime@^7.26.10"
		)
		enpm install "${pkgs[@]}" -P --prefer-offline

		pkgs=(
			"webpack-dev-server@5.2.1"
			"http-proxy-middleware@^2.0.8"
			"flatted@^3.4.2"
			"lodash@^4.18.0"
			"minimatch@^10.2.2"
		)
		enpm install "${pkgs[@]}" -D
		patch_lockfile
	fi
}

src_unpack() {
	npm_src_unpack
}

src_compile() {
	npm_hydrate
	enpm run build
	distutils-r1_src_compile
	grep -q -e "WARNING warning: no files found matching" "${T}/build.log" && die "Detected error"
	grep -q -e "ModuleNotFoundError: No module named" "${T}/build.log" && die "Detected error"
}

src_install() {
	distutils-r1_src_install
	insinto "licenses"
	doins "LICENSE"
	doins "NOTICE.txt"
}
