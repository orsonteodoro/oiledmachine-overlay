## Script purposes

* npm_updater_update_locks.sh - Updates npm lockfiles for ebuilds
* yarn_updater_update_locks.sh - Updates yarn lockfiles for ebuilds
* rocm_find_missing_rpath - Finds missing rpaths for multislot ROCm ebuild packages

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
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd sys-devel/llvm-roc
LLVM_ROC_PHASES="PGI PGT PGO" ROCM_SLOT="5.5" ./optimize.sh
```

See metadata.xml for documentation.

### optimize.sh for sys-devel/clang

* Purpose:  To PGO or BOLT optimize clang, llvm, lld packages.
* Stakeholders:  end user admin

```
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"}
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd sys-devel/clang
CLANG_PHASES="PGI PGT PGO" CLANG_SLOTS="18" ./optimize.sh
```

See metadata.xml for documentation.
