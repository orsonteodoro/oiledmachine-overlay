#!/bin/bash

# Converts cargo.lock to a format used by CRATES variable used by the cargo.eclass.
# cargo-ebuild is broken

CATEGORY="dev-db"
MY_PN="paradedb"
PN="pg_search"
PV="${1}" # left
MY_PV="${2}" # right

# - has ambiguous means
declare -A CARGO_PATHS=(
[datafusion-catalog]="datafusion-%commit%/datafusion/catalog"
[datafusion-catalog-listing]="datafusion-%commit%/datafusion/catalog-listing"
[datafusion-common]="datafusion-%commit%/datafusion/common"
[datafusion-common-runtime]="datafusion-%commit%/datafusion/common-runtime"
[datafusion-datasource-arrow]="datafusion-%commit%/datafusion/datasource-arrow"
[datafusion-datasource-csv]="datafusion-%commit%/datafusion/datasource-csv"
[datafusion-datasource]="datafusion-%commit%/datafusion/datasource"
[datafusion-datasource-json]="datafusion-%commit%/datafusion/datasource-json"
[datafusion-doc]="datafusion-%commit%/datafusion/doc"
[datafusion-execution]="datafusion-%commit%/datafusion/execution"
[datafusion-expr-common]="datafusion-%commit%/datafusion/expr-common"
[datafusion-expr]="datafusion-%commit%/datafusion/expr"
[datafusion-functions-aggregate-common]="datafusion-%commit%/datafusion/functions-aggregate-common"
[datafusion-functions-aggregate]="datafusion-%commit%/datafusion/functions-aggregate"
[datafusion-functions]="datafusion-%commit%/datafusion/functions"
[datafusion-functions-table]="datafusion-%commit%/datafusion/functions-table"
[datafusion-functions-window-common]="datafusion-%commit%/datafusion/functions-window-common"
[datafusion-functions-window]="datafusion-%commit%/datafusion/functions-window"
[datafusion]="datafusion-%commit%/datafusion/core"
[datafusion-macros]="datafusion-%commit%/datafusion/macros"
[datafusion-optimizer]="datafusion-%commit%/datafusion/optimizer"
[datafusion-physical-expr-adapter]="datafusion-%commit%/datafusion/physical-expr-adapter"
[datafusion-physical-expr-common]="datafusion-%commit%/datafusion/physical-expr-common"
[datafusion-physical-expr]="datafusion-%commit%/datafusion/physical-expr"
[datafusion-physical-optimizer]="datafusion-%commit%/datafusion/physical-optimizer"
[datafusion-physical-plan]="datafusion-%commit%/datafusion/physical-plan"
[datafusion-proto-common]="datafusion-%commit%/datafusion/proto-common"
[datafusion-proto]="datafusion-%commit%/datafusion/proto"
[datafusion-pruning]="datafusion-%commit%/datafusion/pruning"
[datafusion-session]="datafusion-%commit%/datafusion/session"
[ownedbytes]="tantivy-%commit%/ownedbytes"
[tantivy-bitpacker]="tantivy-%commit%/bitpacker"
[tantivy-columnar]="tantivy-%commit%/columnar"
[tantivy-common]="tantivy-%commit%/common"
[tantivy-fst]="fst-%commit%"
[tantivy]="tantivy-%commit%"
[tantivy-query-grammar]="tantivy-%commit%/query-grammar"
[tantivy-sstable]="tantivy-%commit%/sstable"
[tantivy-stacker]="tantivy-%commit%/stacker"
[tantivy-tokenizer-api]="tantivy-%commit%/tokenizer-api"
)

main() {
	unset IFS
	local l

	csplit \
		--quiet \
		--prefix=pg_search-config \
		--suffix-format=%02d.txt  \
		/var/tmp/portage/${CATEGORY}/${PN}-${PV}/work/${MY_PN}-${MY_PV}/Cargo.lock \
		/^$/ \
		{*}

	echo "Done splitting"

	local NL=$(grep -v -l -F "git+" pg_search-config*.txt)
	local L=$(grep -l -F "git+" pg_search-config*.txt)

	local s_live=""
	local s_nlive=""
	local live_packages=()

	# live (GIT_CRATES)
	local L=$(grep -l -F "git+" pg_search-config*.txt)
	for l in ${L[@]} ; do
		local name=$(grep "name = " ${l} \
			| cut -f 2 -d '"')
		local version=$(grep "version = " ${l} \
			| cut -f 2 -d '"')
		local source=$(grep "source = " ${l} \
			| cut -f 2 -d '"' \
			| sed -r \
				-e "s|git[+]||g" \
				-e "s|[?]branch=[a-zA-Z0-9.]+||" \
				-e "s|#|;|g" \
				-e "s|[?]rev=[a-zA-Z0-9]{0,40}||" \
				-e "s|\.git||")
		[[ -z "${version}" ]] && continue
		cargo_path="${CARGO_PATHS[${name}]}"
		s_live+="[${name}]=\"${source};${cargo_path}\" # ${version}\n"
		live_packages+=("${name}")
	done

	# non-live (CRATES)
	for l in ${NL[@]} ; do
		local name=$(grep "name = " ${l} | cut -f 2 -d '"')
		local version=$(grep "version = " ${l} | cut -f 2 -d '"')

		local is_live=0
		local x
		for x in ${live_packages[@]} ; do
			if [[ "${x}" == "${name}" ]] ; then
				is_live=1
			fi
		done

		[[ "${name}" =~ "gst-plugin-" ]] && continue # internal
		[[ -z "${name}" ]] && continue
		[[ "${is_live}" == "1" ]] && continue
		s_nlive+="${name}-${version}\n"
	done

	echo
	echo "Non-live:"
	echo
	echo -e "${s_nlive}" | sort

	echo
	echo "Live:"
	echo
	echo -e "${s_live}" | sort

	echo ""

	rm pg_search-config*.txt
}

main
