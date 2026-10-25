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

* 2026-10-25 - [Electron advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-25-electron-advisory/2026-10-25-electron-advisory.txt)
* 2026-10-25 - [signal-desktop advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-25-signal-desktop-advisory/2026-10-25-signal-desktop-advisory.txt)
* 2026-10-24 - [kernel 0-day advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-24-kernel-0-day-advisory/2026-10-24-kernel-0-day-advisory.txt)
* 2026-10-23 - [curl advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-23-curl-advisory/2026-10-23-curl-advisory.txt)
* 2026-10-23 - [Ruby advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-23-ruby-advisory/2026-10-23-ruby-advisory.txt)
* 2026-10-22 - [LiteLLM advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-22-litellm-advisory/2026-10-22-litellm-advisory.txt)
* 2026-10-22 - [Next.js advisory](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-22-next-js-advisory/2026-10-22-next-js-advisory.txt)
* 2026-10-21 - [Update kernel PwnEscape](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-21-update-kernel-pwnescape/2026-10-21-update-kernel-pwnescape.txt)
* 2026-10-21 - [Perl default](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-21-perl-default/2026-10-21-perl-default.txt)
* 2026-10-21 - [Update Node](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-21-update-node/2026-10-21-update-node.txt)
* 2026-10-21 - [Update PHP (Updated Oct 23, 3 CVEs)](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-10-21-update-php/2026-10-21-update-php.txt)
* 2026-08-03 - [Update Perl](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-08-03-update-perl/2026-08-03-update-perl.txt)
* 2026-07-01 - [Split-usr users, update util-linux and others](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2026-07-01-update-util-linux-and-others/2026-06-19-update-util-linux-and-others.txt)

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
