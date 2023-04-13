Instructions for using the scripts folder.

1. From this directory set PATH="$(pwd):${PATH}"
2. From ${CATEGORY}/${PN} run either `npm_updater_update_locks.sh` or
`yarn_updater_update_locks.sh`
3. (Optional) Prefix one of the `*updater_update_locks.sh` with either
NPM_UPDATER_VERSIONS="1.0.1 ... 2.0.0"
or 
YARN_UPDATER_VERSIONS="1.0.1 ... 2.0.0".
If not specified it will update all lockfiles for all ebuilds in the folder.
