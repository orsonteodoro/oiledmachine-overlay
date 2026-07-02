# oiledmachine-overlay

## About

This ebuild overlay contains various ebuilds for the Gentoo Linux distribution.
It focuses on appropriate security and performance, game development,
the AI boom, JS based desktop apps, and legacy hardware support.

The name of the repo comes from "a well oiled machine", running smoothly and
efficient under high memory pressure or heavy IO while maintaining overall
happiness.

## AI notice

This ebuild overlay uses AI generated code and synthetic data in the ebuilds,
patches, and documentation.

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

## Overlay bug fixes and news

Overlay bugs and fixes are addressed with the `eselect news` command, a feature
that I almost never use.  This overlay uses this system to post
**_critical bugs and fixes_** that cannot be simply fixed through automated means
but by required manual intervention.  You may read the full text by navigating
to the .txt file at:

* https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/metadata/news

The selected first news items:

* 2026-07-01 - [Split-usr users, update util-linux and others](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-07-01-update-util-linux-and-others/2026-06-19-update-util-linux-and-others.txt)
* 2026-06-19 - [Use split-usr](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-06-19-use-split-usr/2026-06-19-use-split-usr.txt)
* 2026-06-14 - [Use FFmpeg live](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-06-14-use-ffmpeg-live/2026-06-14-use-ffmpeg-live.txt)
* 2026-06-02 - [Firejail env-max-count](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-06-02-firejail-maxenvs/2026-06-02-firejail-maxenvs.txt)
* 2026-05-14 - [Rebuild the kernel against 0-day vulnerabilities (Fragnesia mitigation)](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-05-14-update-kernel/2026-05-14-update-kernel.txt)
* 2026-05-09 - [Rebuild and restart coolercontrold as non-root](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-05-09-coolercontrold-update/2026-05-09-coolercontrold-update.txt)
* 2026-05-09 - [Rebuild libpcre2 dependencies](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-05-09-rebuild-libpcre2-dependencies/2026-05-09-rebuild-libpcre2-dependencies.txt)
* 2025-01-16 - [Rotate passwords immediately](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2025-01-16-rotate-passwords/2025-01-16-rotate-passwords.txt)
* 2023-11-05 - [ot-sources PGO patch debug output breaks emerge because the distro's linux-info eclass doesn't perform data validation (It addresses the GCC_PGO_PHASE message spam also.)](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2023-11-05-fix-emerge-at-world/2023-11-05-fix-emerge-at-world.txt)

## Docs

* For the security policy, see [SECURITY.md](SECURITY.md)
* For contributing ebuilds, see [CONTRIBUTING.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/CONTRIBUTING.md)
* For the package list, see [PACKAGE_LIST.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/PACKAGE_LIST.md)
* For the 2025 policy, see [2025_POLICY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/2025_POLICY.md)
* For the 2023 policy, see [2023_POLICY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/2023_POLICY.md)
* For the 2020 policy, see [2020_POLICY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/2020_POLICY.md)
* For PGO/BOLT support info, see [PGO_BOLT.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/PGO_BOLT.md)
* For ebuild licenses info, see [EBUILD_LICENSES.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_LICENSES.md)
* For the support matrix, see [SUPPORT_MATRIX.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/SUPPORT_MATRIX.md)
* For the overlay comparison, see [OVERLAY_COMPARISON.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/OVERLAY_COMPARISON.md)
* For ebuild quality info, see [EBUILD_QUALITY.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_QUALITY.md)
* For broken ebuilds info, see [BROKEN.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/BROKEN.md)
* For finding ebuild documentation, see [EBUILD_DOCUMENTATION.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_DOCUMENTATION.md)
* For the overlay ebuild-package development guide, see [EBUILD_PACKAGE_DEVEL_GUIDE.md](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/docs/EBUILD_PACKAGE_DEVEL_GUIDE.md)
