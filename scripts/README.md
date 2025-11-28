## Script purposes

* npm_updater_update_locks.sh - Updates npm lockfiles for ebuilds
* yarn_updater_update_locks.sh - Updates yarn lockfiles for ebuilds
* rocm_find_missing_rpath - Finds missing rpaths for multislot ROCm ebuild packages
* check-ebuild-update - Checks if new versions are available
* lintrepo - Checks if ebuilds have wrong syntax, possible red flags, or security weaknesses
* use-linter - Checks for malformed metadata.xml
* optimize.sh - A script found alongside an ebuild to automate or to simplify multiple emerge optimization
* autobump-patch-versions.sh - A script that auto updates ebuilds.
* rpath_verify.sh - A script that verifies multislot dynamic linking

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
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd media-gfx/upscayl
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
NPM_UPDATER_VERSIONS="2.9.1" npm_updater_update_locks.sh
```

New ebuilds that inherit npm eclass must have the following code template:
```
inherit npm

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

### rocm_find_missing_rpath.sh

* Purpose:  To list all libraries containing missing rpaths.  The list is used to fix multislot rocm/hip packages.
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
PATH="${OILEDMACHINE_OVERLAY_ROOT}/scripts:${PATH}"
rocm_find_missing_rpath.sh
equery b <libname>
# Add rocm_fix_rpath to the ebuild's src_install()
```

### optimize.sh for sys-devel/llvm-roc

* Purpose:  To PGO or BOLT optimize the llvm-roc package.
* Stakeholders:  end user admin

```
# Add the following script settings to /etc/portage/env/llvm-roc.conf:

#ROCM_OVERLAY_DIR="/usr/local/oiledmachine-overlay" # if using older README.md instructions
ROCM_OVERLAY_DIR="/var/db/repos/oiledmachine-overlay" # if overlay was added through eselect repository
```

```
#
# "WARN:  You may need to disable ebolt/epgo if the 3 step process is not"
# "WARN:  complete and want to merge normally."
#
# "WARN:  Not doing so may result in emerge sandbox violations."
#
# Do the following on the command line:
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
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
#
# "WARN:  You may need to disable ebolt/epgo if the 3 step process is not"
# "WARN:  complete and want to merge normally."
#
# "WARN:  Not doing so may result in emerge sandbox violations."
#
# Do the following on the command line:
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd sys-devel/clang
CLANG_PHASES="PGI PGT PGO" CLANG_SLOTS="18" ./optimize.sh
```

See metadata.xml for documentation or customization.

### check-ebuild-update

* Purpose:  To find quickly new point releases to bump
* Stakeholders:  ebuild developers

```
PORTAGE_DIR="/usr/portage"
STABLE_ARCH="amd64"
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
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
PORTAGE_DIR="/usr/portage"
LAYMAN_DIR="/var/lib/layman"
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
./lintrepo
```

The name is pronounced [lint](https://en.wikipedia.org/wiki/Lint_(software)) repo.

### use-linter

* Purpose:  Find syntax errors in metadata.xml
* Stakeholders:  ebuild developers

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
./use-linter
```

### autobump-patch-versions

* Purpose:  Simplify ebuild updates
* Stakeholders:  ebuild developers

The initial motivation of this script is to automate trivial bumping of patch
versions through a single root script where the *DEPENDs do not change between
patch versions.

When you auto-bump, there is still a chance of a mispatch.  It may happen
because the commit has been backported and the same backport commit patch is
applied again, or a dev copies a patch from the repo and integrates it in that
release, or the context where the patching takes place has changed.  You will
need to shallow test the patching process to make sure that the ebuild works.
This can be done by manually running `ebuild ... clean unpack prepare` or
running `autobump-patch-versions.sh` with TEST_MISPATCH=1 environment variable.

If TEST_MISPATCH=1, then mispatches will be logged in
/var/log/autobump/mispatch.log.

The two sections below are a discussion about if a package should or should not
be autobumped.

#### It is okay to make a package support autobump if
1. No specific version(s) in *DEPENDs are required for BUMP_POLICY="latest-version".
2. The *DEPENDs do not change in major.minor versions for BUMP_POLICY="new-patch-versions-per-minor-major".
3. The package uses semver versioning properly.

#### It is not okay to make a package support autobump if
1. The package contains only a live 9999 ebuild.
2. The package requires to manually update the patches all the time for patched versions or any bump.
3. If the *DEPENDs changes in the third component of a.b.c versioning, it is not recommended to use autobumping.
4. If the upstream code quality is poor as in fails to build all the time or requires patching all the time, do not autobump.
5. The project is controlled by doubious people or possibly controlled by malicious threat actors.
6. The license, typically proprietary, disallows it directly, indirectly, or lists similar actions.
7. The package contains .gitmodules that may change *DEPENDs if bumping the patch component of the version string.
```
Contents of ${OILEDMACHINE_OVERLAY_ROOT}/${CATEGORY}/${PN}/autobump/description:
# The description file stores information for both custom script and the root script autobump-patch-versions.sh
CATEGORY - # The ebuild category (REQUIRED)
PN - # The ebuild name (REQUIRED)
AUTOBUMP - 0 to disable, 1 to enable [default] (OPTIONAL)
BUMP_POLICY - custom, latest-version, new-patch-versions-per-minor-major (REQUIRED)
SLOT_COMPONENTS - the range or position from left-to-right considered a slot in the versioning where the *DEPENDs remains unchanged for that slot acceptable by the `cut -f` command. (e.g 1-2 or 1-3 or 3) (OPTIONAL, 1-2 is the default)
```

```
Contents of ${OILEDMACHINE_OVERLAY_ROOT}/${CATEGORY}/${PN}/autobump/get_latest_patch_version.sh:
# Code template
# This file is required if BUMP_POLICY="new-patch-versions-per-minor-major"
get_latest_patch_version() {
        local ver="${1}" # ${1} is typically a major and minor version.
	# You must echo or print a single version string without v prefix.
	# Parse the RSS or git tag version here.
	# The versioning must be in distro canonical/standard form.
	# See https://dev.gentoo.org/~ulm/pms/head/pms.html#section-3.2
}

get_latest_patch_version ${1}
```

```
Contents of ${OILEDMACHINE_OVERLAY_ROOT}/${CATEGORY}/${PN}/autobump/custom.sh:
# This file is required if BUMP_POLICY="custom"
# This script is responsible for the following:
# (1) Autobumping patchsets, autobumping lockfiles for micropackages
# (2) Autobumping ebuilds.
# (3) Commiting changes to oiledmachine-overlay

get_latest_version() {
	...
}

get_latest_patch_version() {
	...
}

# Use get_latest_version or get_latest_patch_version in the function below.
main() {
	...
}

main
```

```
Contents of ${OILEDMACHINE_OVERLAY_ROOT}/${CATEGORY}/${PN}/autobump/get_latest_version.sh:
#!/bin/bash
# This file is required if BUMP_POLICY="latest-version"
get_latest_version() {
	# You must echo or print a single version string without v prefix.
	# Parse the RSS or git tag version here.
	# The versioning must be in distro canonical/standard form.
	# See https://dev.gentoo.org/~ulm/pms/head/pms.html#section-3.2
}

get_latest_version
```

```
# TEST_MISPATCH - 1 to enable testing patches or 0 to disable testing patches.  Enabling will increase time cost.
# DRY_RUN - 0 for reporting version bump but no commit or changes; 1 for actual bumping and commiting changes.
TEST_MISPATCH=0 DRY_RUN=0 ./autobump-patch-versions.sh
```
