Instructions for using the scripts folder.

1. From this directory set PATH="$(pwd):${PATH}"
2. From ${CATEGORY}/${PN} run either `npm_updater_update_locks.sh` or `yarn_updater_update_locks.sh`
   2a. (Optional) Prefix one of the `*updater_update_locks.sh` with either NPM_UPDATER_VERSIONS="1.0.1 ... 2.0.0" or YARN_UPDATER_VERSIONS="1.0.1 ... 2.0.0".
