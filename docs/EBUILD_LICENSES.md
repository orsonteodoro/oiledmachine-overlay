## Ebuild licenses

Many of these packages have special licenses and EULAs attached to them.  I 
recommend that you edit your /etc/portage/make.conf so it looks like this 
ACCEPT_LICENSE="-*" and manually accept each of the licenses.

Licenses can be found in the following locations:

* [The distro overlay license folder](https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses)
* [The oiledmachine-overlay license folder](https://github.com/orsonteodoro/oiledmachine-overlay/tree/master/licenses)

It is assumed that the distro license folders exists on the local system.

The copyright notices are contained in the source code of downloaded
tarballs and in the about section of the program.

The identifier **custom** is recognized by this overlay and used in several
Linux distros in their community package sets with their LICENSE variable.
It is a catch all used when no license template contains the exact phase
or clause.  The ebuild will contain the keywords to find the custom license.
You can use repo search feature in that project to find the license file
and the location of the text before emerging the package.  You may try to
find the text in the monolithic license file (a file containing all the
licenses and copyright notices) referenced in the LICENSE variable.  If
the license text is buried in a git submodule, you need to manually scan
each module or try to do a search engine scan.  You can also try to do the
following in the command line template:

```
#OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/usr/local/oiledmachine-overlay"} # if using the old README.md instructions
OILEDMACHINE_OVERLAY_ROOT=${OILEDMACHINE_OVERLAY_ROOT:-"/var/db/repos/oiledmachine-overlay"} # if using eselect repository
cd "${OILEDMACHINE_OVERLAY_ROOT}"
cd ${PN}
ebuild ${PN}-${PV}.ebuild unpack
grep -l -i -r -e "<KEYWORDS>" "<WORKDIR>"
```

to scan the package locally to find the license file before merge.

Many of these packages especially non-free software also require you to 
manually obtain the installer or files to install and may require you to 
register on their website.  The required files are listed in the ebuild but
may require some mental gynmanstics to find the actual name.
