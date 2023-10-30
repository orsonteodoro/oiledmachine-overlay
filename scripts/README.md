## Script purposes

* npm_updater_update_locks.sh - Updates npm lockfiles for ebuilds
* yarn_updater_update_locks.sh - Updates yarn lockfiles for ebuilds
* rocm_find_missing_rpath - Finds missing rpaths for multislot ROCm ebuild packages
* npm_dedupe.sh - Dedupes URIs in NPM_EXTERNAL_URIS.
* yarn_dedupe.sh - Dedupes URIs in YARN_EXTERNAL_URIS.
* check-ebuild-update - Checks if new versions are available
* lintrepo - Checks if ebuilds have wrong syntax, possible red flags, or security weaknesses
* use-linter - Checks for malformed metadata.xml
* optimize.sh - A script found alongside an ebuild to automate or to simplify multiple emerge optimization

## OILEDMACHINE_OVERLAY_ROOT

In the examples below, you can change the root directory to the repositories or
replace the default literals:

* `OILEDMACHINE_OVERLAY_ROOT="/var/db/repos/oiledmachine-overlay"` for newer eselect repository instructions
* `OILEDMACHINE_OVERLAY_ROOT="/usr/local/oiledmachine-overlay"` for older README.md instructions

## Examples

### npm_updater_update_locks.sh

* Purpose:  To save, update, fix some vulnerabilites in package-lock.json for packages using the yarn package manager.
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd media-gfx/upscayl
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
NPM_UPDATER_VERSIONS="2.9.1" npm_updater_update_locks.sh
```

New ebuilds that inherit npm eclass must have the following code template:
```
inherit npm

# UPDATER_START_NPM_EXTERNAL_URIS
NPM_EXTERNAL_URIS="
"
# UPDATER_END_NPM_EXTERNAL_URIS
SRC_URI="
${NPM_EXTERNAL_URIS}
...
"

# Use the following template to manually update npm lockfiles controlling audit
# fix and lock file generation.
src_unpack() {
        if [[ "${NPM_UPDATE_LOCK}" == "1" ]] ; then
		#...
		die
	else
		#...
	fi
}
```

npm_updater_transform_uris.sh is used to help generate URIs and not intended to be called directly.

### yarn_updater_update_locks.sh

* Purpose:  To save/update yarn.lock for packages using the yarn package manager.
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd dev-util/theia
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
YARN_UPDATER_VERSIONS="1.43.0" yarn_updater_update_locks.sh
```

New ebuilds that inherit yarn eclass must have the following code template:
```
inherit yarn

# UPDATER_START_YARN_EXTERNAL_URIS
YARN_EXTERNAL_URIS="
"
# UPDATER_END_YARN_EXTERNAL_URIS
SRC_URI="
${YARN_EXTERNAL_URIS}
...
"

# Use the following template to manually update yarn lockfiles controlling audit
# fix and lock file generation.
src_unpack() {
        if [[ "${YARN_UPDATE_LOCK}" == "1" ]] ; then
		#...
		die
	else
		#...
	fi
}
```

yarn_updater_transform_uris.sh is used to help generate URIs and not intended to be called directly.

### npm_dedupe.sh

* Purpose:  Dedupe and sort NPM_UPDATER_VERSIONS for ebuilds that inherit npm eclass.
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd media-gfx/upscayl
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
NPM_UPDATER_VERSIONS="2.9.1" npm_dedupe.sh
```

### yarn_dedupe.sh

* Purpose:  Dedupe and sort YARN_UPDATER_VERSIONS for ebuilds that inherit yarn eclass.
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd dev-util/theia
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
YARN_UPDATER_VERSIONS="1.43.0" yarn_dedupe.sh
```

### rocm_find_missing_rpath.sh

* Purpose:  To list all libraries containing missing rpaths.  The list is used to fix multislot rocm/hip packages.
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
rocm_find_missing_rpath.sh
equery b <libname>
# Add rocm_fix_rpath to ebuild's pkg_postinst()
```

### optimize.sh for sys-devel/llvm-roc

* Purpose:  To PGO or BOLT optimize the llvm-roc package.
* Stakeholders:  end user admin

```
# Add the following script settings /etc/portage/env/llvm-roc.conf:

LLVM_ROC_TRAINERS="rocPRIM rocRAND rocSPARSE"
#ROCM_OVERLAY_DIR="/usr/local/oiledmachine-overlay" # if using older README.md instructions
ROCM_OVERLAY_DIR="/var/db/repos/oiledmachine-overlay" # if overlay was added through eselect repository
```

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd sys-devel/llvm-roc
LLVM_ROC_PHASES="PGI PGT PGO" ROCM_SLOTS="5.5" ./optimize.sh
```

See metadata.xml for documentation or customization.

### optimize.sh for sys-devel/clang

* Purpose:  To PGO or BOLT optimize clang, llvm, lld packages.
* Stakeholders:  end user admin

```
# Add the following script settings to /etc/portage/env/clang-pgo-training.conf:

#ROCM_OVERLAY_DIR="/usr/local/oiledmachine-overlay" # if using older README.md instructions
ROCM_OVERLAY_DIR="/var/db/repos/oiledmachine-overlay" # if using eselect repository
PORTAGE_OVERLAY_DIR="/usr/portage" # if using old instructions
```

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd sys-devel/clang
CLANG_PHASES="PGI PGT PGO" CLANG_SLOTS="18" ./optimize.sh
```

See metadata.xml for documentation or customization.

### check-ebuild-update

* Purpose:  To find quickly new point releases to bump
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
./check-ebuild-update
```

The script module check-ebuild-update-scrapers contains functions to obtain
version info per ebuild package.

The check-ebuild-update is a manger script that contains library functions or
manages general version retrieval.

### lintrepo

* Purpose:  Find syntax, red flags, security weaknesses in .ebuild files
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
./lintrepo
```

The name is pronounced [lint](https://en.wikipedia.org/wiki/Lint_(software)) repo.

### use-linter

* Purpose:  Find syntax errors in metadata.xml
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
./use-linter
```

