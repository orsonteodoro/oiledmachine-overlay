# Copyright 2024-2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# TODO package (optional):
# aeneas
# phonetisaurus
# hazm
# mishkal
# codernitydb3
# conllu

DISTUTILS_USE_PEP517="setuptools"
LANGS=(
	"ar"
	"ca"
	"cs"
	"de"
	"en"
	"es"
	"fa"
	"fr"
	"it"
	"lb"
	"nl"
	"pt"
	"ru"
	"sv"
	"sw"
)
PYTHON_COMPAT=( "python3_"{10..12} ) # Upstream only list up to 3.9

inherit distutils-r1

KEYWORDS="~amd64"
S="${WORKDIR}/${PN}-${PV}"
SRC_URI="
https://github.com/rhasspy/gruut/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
"

DESCRIPTION="A tokenizer, text cleaner, and phonemizer for many human languages."
HOMEPAGE="
	https://github.com/rhasspy/gruut
	https://pypi.org/project/gruut
"
LICENSE="
	MIT
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
${LANGS[@]/#/l10n_}
align g2p train
"
REQUIRED_USE="
	l10n_en
"
RDEPEND+="
	>=dev-python/babel-2.8.0[${PYTHON_USEDEP}]
	>=dev-python/dateparser-1.1.1[${PYTHON_USEDEP}]
	>=dev-python/gruut-ipa-0.12.0[${PYTHON_USEDEP}]
	>=dev-python/jsonlines-1.2.0[${PYTHON_USEDEP}]
	>=dev-python/networkx-2.5.0[${PYTHON_USEDEP}]
	>=dev-python/num2words-0.5.10[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.19.0[${PYTHON_USEDEP}]
	>=dev-python/python-crfsuite-0.9.7[${PYTHON_USEDEP}]
	align? (
		>=dev-python/aeneas-1.7.3.0[${PYTHON_USEDEP}]
		>=dev-python/pydub-0.24.1[${PYTHON_USEDEP}]
	)
	g2p? (
		>=dev-python/phonetisaurus-0.3.0[${PYTHON_USEDEP}]
	)
	l10n_fa? (
		>=dev-python/hazm-0.7.0[${PYTHON_USEDEP}]
	)
	l10n_ar? (
		>=dev-python/mishkal-0.4.0[${PYTHON_USEDEP}]
		>=dev-python/codernitydb3-0.6.0[${PYTHON_USEDEP}]
	)
	train? (
		>=dev-python/conllu-4.4[${PYTHON_USEDEP}]
		>=dev-python/rapidfuzz-2.11.1[${PYTHON_USEDEP}]
	)
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
"
DOCS=( "README.md" )

src_compile() {
	S="${WORKDIR}/${PN}-${PV}"
	distutils-r1_src_compile
	local lang
	for lang in ${LANGS[@]} ; do
		if use "l10n_${lang}" ; then
			S="${WORKDIR}/${PN}-${PV}/gruut-lang-${lang}"
			pushd "${S}" >/dev/null 2>&1 || die
				distutils-r1_src_compile
			popd || die
		fi
	done
}

python_install() {
	[[ "${SKIP}" == "1" ]] && return
	distutils-r1_python_install
	delete_tests() {
		local path=$(python_get_sitedir)
		rm -rf "${ED}/${path}/tests" || die
	}
	python_foreach_impl delete_tests
}

src_install() {
	SKIP=0
	S="${WORKDIR}/${PN}-${PV}"
	distutils-r1_src_install
	SKIP=1
	local lang
	for lang in ${LANGS[@]} ; do
		if use "l10n_${lang}" ; then
einfo "Installing gruut-lang-${lang}"
			install_lang() {
				pushd "${S}/gruut-lang-${lang}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages" >/dev/null 2>&1 || die
					insinto "/usr/lib/${EPYTHON}/site-packages"
					doins -r *
				popd >/dev/null 2>&1 || die
			}

			python_foreach_impl install_lang

		fi
	done
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
