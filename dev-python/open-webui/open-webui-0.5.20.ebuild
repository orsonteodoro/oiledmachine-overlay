# Copyright 2025 Orson Teodoro <orsonteodoro@hotmail.com>
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

AT_TYPES_NODE_PV="20.11.30"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517="hatchling"
NODE_VERSION="${AT_TYPES_NODE_PV%%.*}"
PYTHON_COMPAT=( "python3_"{11..12} )

inherit distutils-r1 pypi

if [[ "${PV}" =~ "9999" ]] ; then
	EGIT_BRANCH="main"
	EGIT_CHECKOUT_DIR="${WORKDIR}/${P}"
	EGIT_REPO_URI="https://github.com/open-webui/open-webui.git"
	FALLBACK_COMMIT="506dc0149ca973e20768fa3d6f171afac289f606" # Jan 5, 2025
	IUSE+=" fallback-commit"
	S="${WORKDIR}/${P}"
	inherit git-r3
else
	#KEYWORDS="~amd64" # Still need to fix multiple instance of slot conflict in TODO.
	S="${WORKDIR}/${PN}-${PV}"
	SRC_URI="
https://github.com/open-webui/open-webui/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	"
fi

DESCRIPTION="A user-friendly AI interface with web search RAG, document RAG, AI image generation, Ollama, OpenAI API support"
HOMEPAGE="
	https://openwebui.com/
	https://github.com/open-webui/open-webui
	https://pypi.org/project/open-webui
"
LICENSE="
	BSD
"
RESTRICT="mirror"
SLOT="0/$(ver_cut 1-2 ${PV})"
IUSE+=" "
# For missing dev-python/moto[s3] rdepends
MOTO_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/moto-5.0.26[${PYTHON_USEDEP},s3(+)]
		>=dev-python/py-partiql-parser-0.6.1[${PYTHON_USEDEP}]
	')
"
# For missing >=dev-python/passlib-1.7.4[bcrypt(+)] rdepends
PASSLIB_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/passlib-1.7.4[${PYTHON_USEDEP},bcrypt(+)]
		dev-python/bcrypt[${PYTHON_USEDEP}]
	')
"
# For missing dev-python/pyjwt[crypto] rdepends
PYJWT_RDEPEND="
	$(python_gen_cond_dep '
		dev-python/cryptography[${PYTHON_USEDEP}]
	')
"
# For missing dev-python/uvicorn[standard] rdepends
UVICORN_RDEPEND="
	$(python_gen_cond_dep '
		>=dev-python/uvloop-0.14.0[${PYTHON_USEDEP}]
		>=dev-python/watchfiles-0.13[${PYTHON_USEDEP}]
	')
"
# Relaxed pymilvus
RDEPEND+="
	${PASSLIB_RDEPEND}
	${PYJWT_RDEPEND}
	${MOTO_RDEPEND}
	${UVICORN_RDEPEND}
	$(python_gen_cond_dep '
		>=dev-python/aiohttp-3.11.11[${PYTHON_USEDEP}]
		>=dev-python/alembic-1.14.0[${PYTHON_USEDEP}]
		>=dev-python/apscheduler-3.10.4[${PYTHON_USEDEP}]
		>=dev-python/argon2-cffi-23.1.0[${PYTHON_USEDEP}]
		>=dev-python/asgiref-3.8.1[${PYTHON_USEDEP}]
		>=dev-python/Authlib-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/azure-ai-documentintelligence-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/azure-identity-1.20.0[${PYTHON_USEDEP}]
		>=dev-python/azure-storage-blob-12.24.1[${PYTHON_USEDEP}]
		>=dev-python/bcrypt-4.3.0[${PYTHON_USEDEP}]
		>=dev-python/black-25.1.0[${PYTHON_USEDEP}]
		>=dev-python/boto3-1.35.53[${PYTHON_USEDEP}]
		>=dev-python/chromadb-0.6.2[${PYTHON_USEDEP}]
		>=dev-python/docker-7.1.0[${PYTHON_USEDEP}]
		>=dev-python/docx2txt-0.8[${PYTHON_USEDEP}]
		>=dev-python/duckduckgo-search-7.3.2[${PYTHON_USEDEP}]
		>=dev-python/einops-0.8.0[${PYTHON_USEDEP}]
		>=dev-python/elasticsearch-8.17.1[${PYTHON_USEDEP}]
		>=dev-python/fake-useragent-1.5.1[${PYTHON_USEDEP}]
		>=dev-python/fastapi-0.115.7[${PYTHON_USEDEP}]
		>=dev-python/firecrawl-py-1.12.0[${PYTHON_USEDEP}]
		>=dev-python/fpdf2-2.8.2[${PYTHON_USEDEP}]
		>=dev-python/ftfy-6.2.3[${PYTHON_USEDEP}]
		>=dev-python/gcp-storage-emulator-2024.08.03[${PYTHON_USEDEP}]
		>=dev-python/google-generativeai-0.7.2[${PYTHON_USEDEP}]
		>=dev-python/googleapis-common-protos-1.63.2[${PYTHON_USEDEP}]
		>=dev-python/langchain-0.3.19[${PYTHON_USEDEP}]
		>=dev-python/langchain-community-0.3.18[${PYTHON_USEDEP}]
		>=dev-python/langfuse-2.44.0[${PYTHON_USEDEP}]
		>=dev-python/ldap3-2.9.1[${PYTHON_USEDEP}]
		>=dev-python/loguru-0.7.2[${PYTHON_USEDEP}]
		>=dev-python/markdown-3.7[${PYTHON_USEDEP}]
		>=dev-python/nltk-3.9.1[${PYTHON_USEDEP}]
		>=dev-python/openpyxl-3.1.5[${PYTHON_USEDEP}]
		>=dev-python/opensearch-py-2.8.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-2.2.3[${PYTHON_USEDEP}]
		>=dev-python/peewee-3.17.9[${PYTHON_USEDEP}]
		>=dev-python/peewee-migrate-1.12.2[${PYTHON_USEDEP}]
		>=dev-python/pgvector-0.3.5[${PYTHON_USEDEP}]
		>=dev-python/playwright-bin-1.49.1[${PYTHON_USEDEP}]
		>=dev-python/psycopg-2.9.9:2[${PYTHON_USEDEP}]
		>=dev-python/pydantic-2.10.6[${PYTHON_USEDEP}]
		>=dev-python/pyjwt-2.10.1[${PYTHON_USEDEP},crypto(+)]
		>=dev-python/pymdown-extensions-10.14.2[${PYTHON_USEDEP}]
		>=dev-python/pymysql-1.1.1[${PYTHON_USEDEP}]
		>=dev-python/pypandoc-1.13[${PYTHON_USEDEP}]
		>=dev-python/pypdf-4.3.1[${PYTHON_USEDEP}]
		>=dev-python/pytest-8.3.2[${PYTHON_USEDEP}]
		>=dev-python/pytest-docker-3.1.1[${PYTHON_USEDEP}]
		>=dev-python/python-jose-3.4.0[${PYTHON_USEDEP}]
		>=dev-python/python-multipart-0.0.18[${PYTHON_USEDEP}]
		>=dev-python/python-pptx-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/python-socketio-5.11.3[${PYTHON_USEDEP}]
		>=dev-python/pytube-15.0.0[${PYTHON_USEDEP}]
		>=dev-python/pyxlsb-1.0.10[${PYTHON_USEDEP}]
		>=dev-python/qdrant-client-1.12.0[${PYTHON_USEDEP}]
		>=dev-python/rank-bm25-0.2.2[${PYTHON_USEDEP}]
		>=dev-python/rapidocr-onnxruntime-1.3.24[${PYTHON_USEDEP}]
		>=dev-python/RestrictedPython-8.0[${PYTHON_USEDEP}]
		>=dev-python/soundfile-0.13.1[${PYTHON_USEDEP}]
		>=dev-python/uvicorn-0.34.0[${PYTHON_USEDEP},standard(+)]
		>=dev-python/requests-2.32.3[${PYTHON_USEDEP}]
		>=dev-python/sqlalchemy-2.0.38[${PYTHON_USEDEP}]
		>=dev-python/unstructured-0.16.17[${PYTHON_USEDEP}]
		>=dev-python/validators-0.34.0[${PYTHON_USEDEP}]
		>=dev-python/xlrd-2.0.1[${PYTHON_USEDEP}]
		>=dev-python/youtube-transcript-api-0.6.3[${PYTHON_USEDEP}]
		>=media-libs/opencv-4.11.0[${PYTHON_USEDEP},python]
		dev-python/aiocache[${PYTHON_USEDEP}]
		dev-python/aiofiles[${PYTHON_USEDEP}]
		dev-python/anthropic[${PYTHON_USEDEP}]
		dev-python/async-timeout[${PYTHON_USEDEP}]
		dev-python/extract-msg[${PYTHON_USEDEP}]
		dev-python/google-api-python-client[${PYTHON_USEDEP}]
		dev-python/google-auth-httplib2[${PYTHON_USEDEP}]
		dev-python/google-auth-oauthlib[${PYTHON_USEDEP}]
		dev-python/openai[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pydub[${PYTHON_USEDEP}]
		dev-python/pymongo[${PYTHON_USEDEP}]
		dev-python/redis[${PYTHON_USEDEP}]
		sci-ml/sentencepiece[${PYTHON_USEDEP}]
		dev-python/tiktoken[${PYTHON_USEDEP}]
	')
	>=dev-python/colbert-ai-0.2.21[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/faster-whisper-1.1.1[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/pymilvus-2.4.0[${PYTHON_SINGLE_USEDEP}]
	>=dev-python/sentence-transformers-3.3.1[${PYTHON_SINGLE_USEDEP}]
	sci-ml/transformers[${PYTHON_SINGLE_USEDEP}]
"
DEPEND+="
	${RDEPEND}
"
BDEPEND+="
	net-libs/nodejs:${NODE_VERSION}[npm]
"
DOCS=( "CHANGELOG.md" "README.md" )

src_unpack() {
	if [[ "${PV}" =~ "9999" ]] ; then
		use fallback-commit && EGIT_COMMIT="${FALLBACK_COMMIT}"
		git-r3_fetch
		git-r3_checkout
	else
		unpack ${A}
	fi
}

src_install() {
	distutils-r1_src_install
	docinto "licenses"
	dodoc "LICENSE"
}

# OILEDMACHINE-OVERLAY-META:  CREATED-EBUILD
# OILEDMACHINE-OVERLAY-TEST:  UNTESTED
