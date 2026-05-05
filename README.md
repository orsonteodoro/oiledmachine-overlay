# oiledmachine-overlay

## Important special note

Work on this repo may cease or be infrequent.  Please see issue request.

## About

This portage overlay contains various ebuilds for the Gentoo Linux
distribution.  It focuses on optimized ebuilds, some game development, 
software used in computer science courses, C#, Electron apps, and other legacy 
software and hardware support packages.

The name of the repo comes from "well-oiled machine."  A (Gentoo) computer 
should not feel like molasses under high memory pressure or heavy IO 
utilization.  It should run smoothly.

## Adding the repo

```
emerge app-eselect/eselect-repository
eselect repository add oiledmachine-overlay git https://github.com/orsonteodoro/oiledmachine-overlay.git
```

## Keep in sync by

```
emaint sync -A
```

or

```
emaint sync --repo oiledmachine-overlay
```

## Important stuff

## Overlay bugs/fixes/news

Overlay bugs and fixes are addressed with the `eselect news` command, a feature
that I almost never use.  This overlay uses this system to post
**_critical bugs and fixes_** that cannot be simply fixed through automated means
but by required manual intervention.  You may read the full text by navigating
to the .txt file at:

* https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/metadata/news

The selected first 5 news items:

* 2025-01-16 - [Rotate passwords immediately](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2025-01-16-rotate-passwords/2025-01-16-rotate-passwords.txt)
* 2023-11-05 - [ot-sources PGO patch debug output breaks emerge because the distro's linux-info eclass doesn't perform data validation (It addresses the GCC_PGO_PHASE message spam also.)](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2023-11-05-fix-emerge-at-world/2023-11-05-fix-emerge-at-world.txt)
* 2020-07-19 - [Manual removal of npm or electron based packages required](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2020-07-19-manual-removal-npm-and-electron/2020-07-19-manual-removal-npm-and-electron.en.txt)

## Docs

* For the security policy, see [SECURITY.md](SECURITY.md)
* For contributing ebuilds, see [CONTRIBUTING.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/CONTRIBUTING.md)
* For package list, see [PACKAGE_LIST.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/PACKAGE_LIST.md)
* For the 2025 policy, see [2025_POLICY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/2025_POLICY.md)
* For the 2023 policy, see [2023_POLICY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/2023_POLICY.md)
* For the 2020 policy, see [2020_POLICY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/2020_POLICY.md)
* For PGO/BOLT support info, see [PGO_BOLT.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/PGO_BOLT.md)
* For finding ebuild documentation, see [EBUILD_DOCUMENTATION.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_DOCUMENTATION.md)
* For ebuild licenses info, see [EBUILD_LICENSES.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_LICENSES.md)
* For ebuild quality info, see [QUALITY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/QUALITY.md)
* For broken ebuilds info, see [QUALITY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/BROKEN.md)
* For legacy packages, see [LEGACY_PACKAGES.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/LEGACY_PACKAGES.md)
