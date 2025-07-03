# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# We don't bump to avoid pulling numpy 2.x

NPM_TARBALL="${P}.tar.gz"
NODE_VERSION=16 # Upstream uses node 16
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..12} ) # Lists up to 3.12

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
IUSE="dev pandas ebuild_revision_3"
RDEPEND+="
	>=sci-visualization/dash-2.0.0[${PYTHON_USEDEP},dev(+)]
	pandas? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	>=dev-python/setuptools-42[${PYTHON_USEDEP}]
	dev-python/invoke[${PYTHON_USEDEP}]
	dev-python/semver[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	net-libs/nodejs:${NODE_VERSION}[webassembly(+)]
	dev? (
		>=sci-visualization/dash-2.0.0[${PYTHON_USEDEP},dev(+)]
		dev-python/build[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]

		>=dev-python/pytest-6.0[${PYTHON_USEDEP}]
		dev-python/black[${PYTHON_USEDEP}]
	)
"

#distutils_enable_tests "pytest"

pkg_setup() {
	python_setup
	npm_pkg_setup
}

src_unpack() {
	npm_src_unpack
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
		}
		patch_lockfile

		local pkgs
		pkgs=(
			"@babel/runtime@^7.26.10"
		)
		npm install "${pkgs[@]}" -P --prefer-offline

		pkgs=(
			"webpack-dev-server@5.2.1"
			"http-proxy-middleware@^2.0.8"
		)
		npm install "${pkgs[@]}" -D
		patch_lockfile
	fi
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
}
