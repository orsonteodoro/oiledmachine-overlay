# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYPI_PN="APScheduler"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit distutils-r1 pypi

KEYWORDS="~amd64 ~arm64"

DESCRIPTION="In-process task scheduler with Cron-like capabilities"
HOMEPAGE="
	https://github.com/agronholm/apscheduler/
	https://pypi.org/project/APScheduler/
"
LICENSE="MIT"
RESTRICT="test" # Required for toml compatibility with python 3.10
SLOT="0"
IUSE+="
doc etcd gevent mongodb redis rethinkdb sqlalchemy test tornado twisted
zookeeper
"
REQUIRED_USE+="
	test? (
		etcd
		mongodb
		redis
		rethinkdb
		sqlalchemy
		tornado
		zookeeper
	)
"
RDEPEND="
	>=dev-python/tzlocal-3.0[${PYTHON_USEDEP}]
	etcd? (
		dev-python/etcd3[${PYTHON_USEDEP}]
		<=dev-python/protobuf-3.21.0[${PYTHON_USEDEP}]
	)
	gevent? (
		dev-python/gevent[${PYTHON_USEDEP}]
	)
	mongodb? (
		>=dev-python/pymongo-3.0[${PYTHON_USEDEP}]
	)
	redis? (
		>=dev-python/redis-3.0[${PYTHON_USEDEP}]
	)
	rethinkdb? (
		>=dev-python/rethinkdb-2.4.0[${PYTHON_USEDEP}]
	)
	sqlalchemy? (
		>=dev-python/sqlalchemy-1.4[${PYTHON_USEDEP}]
	)
	tornado? (
		>=dev-python/tornado-4.3[${PYTHON_USEDEP}]
	)
	twisted? (
		dev-python/twisted[${PYTHON_USEDEP}]
	)
	zookeeper? (
		dev-python/kazoo[${PYTHON_USEDEP}]
	)

"
BDEPEND="
	>=dev-python/setuptools-64[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.4[${PYTHON_USEDEP}]
	doc? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/sphinx-rtd-theme-1.3.0[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		>=dev-python/anyio-4.5.2[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/pyside-6[${PYTHON_USEDEP}]
		' python3_{10..13})
		$(python_gen_cond_dep '
			dev-python/gevent[${PYTHON_USEDEP}]
		' python3_{10..13})
		dev-python/pytz[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			dev-python/twisted[${PYTHON_USEDEP}]
		' python3_{10..13})
	)
"

distutils_enable_tests "pytest"

PATCHES=(
	# Disable test fixtures using external servers (mongodb, redis...)
	"${FILESDIR}/${PN}-3.11.0-external-server-tests.patch"
	"${FILESDIR}/${PN}-3.11.0-toml-compat.patch"
)

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest -p "anyio"
}
