# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 udev

DESCRIPTION="Cross-platform tool and drivers for liquid coolers and other devices"
HOMEPAGE="https://github.com/liquidctl/liquidctl"
SRC_URI="https://github.com/liquidctl/liquidctl/releases/download/v${PV}/${P}.tar.gz"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
# U 22.04
UDEV_PV="249.11"
RDEPEND="
	>=dev-libs/libusb-1.0.25
	>=dev-python/crcmod-1.7[${PYTHON_USEDEP}]
	dev-python/colorlog[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/hidapi[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyusb[${PYTHON_USEDEP}]
	sys-apps/i2c-tools[${PYTHON_USEDEP},python]
	|| (
		>=sys-apps/systemd-${UDEV_PV}
		>=sys-apps/systemd-utils-${UDEV_PV}[udev]
	)
"
BDEPEND="
	>=dev-python/setuptools-45[${PYTHON_USEDEP}]
	>=dev-python/setuptools-scm-6.2[${PYTHON_USEDEP}]
	dev-python/pip[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	# Without this variable, it attempts to write to /var/run and fails.
	XDG_RUNTIME_DIR="${T}/xdg" \
	distutils-r1_src_test \
		|| die
}

python_install_all() {
	distutils-r1_python_install_all
	dodoc docs/*.md
	dodoc -r docs/linux/
	udev_dorules extra/linux/71-liquidctl.rules
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
