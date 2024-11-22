# Copyright 2024 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( "python3_"{10..13} )

inherit python-single-r1

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="master"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/mezbaul-h/june.git"
	FALLBACK_COMMIT="1e70efd3305479572148cb0bcb8e5e6c15359fa8" # Jul 30, 2024
	IUSE=" fallback-commit"
	inherit git-r3
else
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/mezbaul-h/june/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
	inherit pypi
fi

DESCRIPTION="Local voice chatbot for engaging conversations, powered by Ollama, Hugging Face Transformers, and Coqui TTS Toolkit"
HOMEPAGE="
	https://github.com/mezbaul-h/june
"
LICENSE="
	MIT
"
RESTRICT="mirror test" # untested
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+="
alsa dev jack oss test
ebuild-revision-1
"
REQUIRED_USE="
	test? (
		dev
	)
	|| (
		alsa
		jack
		oss
	)
"
RDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/click-8.1.7[${PYTHON_USEDEP}]
		>=dev-python/colorama-0.4.6[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.26.4[${PYTHON_USEDEP},lapack]
		>=dev-python/ollama-0.2.1[${PYTHON_USEDEP}]
		>=dev-python/pyaudio-0.2.14[${PYTHON_USEDEP}]
		>=dev-python/pydantic-settings-2.3.1[${PYTHON_USEDEP}]
		>=dev-python/pygame-2.5.2[${PYTHON_USEDEP}]
	')
	>=dev-python/coqui-tts-0.24.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/pytorch-2.3.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/torchaudio-2.3.1[${PYTHON_SINGLE_USEDEP}]
	>=sci-libs/transformers-4.40.2[${PYTHON_SINGLE_USEDEP}]
	media-libs/portaudio[alsa?,jack?,oss?]
	app-misc/ollama
	|| (
		sci-libs/mkl
		sci-libs/openblas[eselect-ldso,openmp]
	)
"
DEPEND+="

	${RDEPEND}
"
BDEPEND+="
	$(python_gen_cond_dep '
		>=dev-python/setuptools-69.1.0[${PYTHON_USEDEP}]
		dev? (
			>=dev-python/bandit-1.7.8[${PYTHON_USEDEP},toml(+)]
			>=dev-python/black-24.4.2[${PYTHON_USEDEP},jupyter(+)]
			>=dev-python/coverage-7.5.3[${PYTHON_USEDEP}]
			>=dev-python/isort-5.13.2[${PYTHON_USEDEP},colors(+)]
			>=dev-python/mypy-1.10.0[${PYTHON_USEDEP}]
			>=dev-python/pylint-3.2.2[${PYTHON_USEDEP}]
			>=dev-python/pytest-8.2.2[${PYTHON_USEDEP}]
		)
	')
"
DOCS=( "README.md" )
PATCHES=(
	"${FILESDIR}/${PN}-0.0.1-model-environment-variable.patch"
)

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_configure() {
	local june_default_model=${JUNE_DEFAULT_MODEL:-"llama3.1:8b-instruct-q4_0"}
einfo "JUNE_DEFAULT_MODEL:  ${june_default_model}"
	sed -i -e "s|llama3.1:8b-instruct-q4_0|${june_default_model}|g" "june_va/settings.py" || die
}

src_compile() {
	:
}

src_install() {
	python_moduleinto "june_va"
	python_domodule "june_va/"*
	dodir "/usr/bin"
cat <<EOF > "${ED}/usr/bin/june-va"
#!/bin/bash
export OLLAMA_HOST=\${OLLAMA_HOST:-"http://localhost:11434"}
${EPYTHON} -c "from june_va.cli import main; main()" \$@
EOF
	fperms 0755 "/usr/bin/june-va"
	fowners "root:root" "/usr/bin/june-va"
	docinto "licenses"
	dodoc "LICENSE"
}

pkg_postinst() {
ewarn
ewarn "The default mic needs to be set or a \"Input overflowed\" error may appear.  For ALSA see"
ewarn
ewarn "  https://wiki.archlinux.org/title/Advanced_Linux_Sound_Architecture/Troubleshooting#Setting_the_default_microphone/capture_device"
ewarn "  https://wiki.gentoo.org/wiki/ALSA#Test_microphone"
ewarn

# There is a bug where it takes 22 min to do conversion.
ewarn "The selected LAPACK should match the vendor so that SST (speech-to-text"
ewarn "performance) is in acceptable conversion time."
ewarn
ewarn "sci-libs/mkl - For Intel CPUs/GPUs"
ewarn "sci-libs/openblas - For non-Intel CPUs"
ewarn
	if cat "/proc/cpuinfo" | grep -q "GenuineIntel" ; then
		if ! eselect lapack show | grep -q "mkl" ; then
ewarn "Run \`eselect lapack set mkl\` to optimize for Intel CPUs/GPUs."
		fi
	elif cat "/proc/cpuinfo" | grep -q "AuthenticAMD" ; then
		if ! eselect lapack show | grep -q "openblas" ; then
ewarn "Run \`eselect lapack set openblas\` to optimize for AMD CPUs."
		fi
	else
		if ! eselect lapack show | grep -q "openblas" ; then
ewarn "Run \`eselect lapack set openblas\` to optimize for ${ARCH}."
		fi
	fi
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
