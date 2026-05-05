### 2020 policy

In 2020 for this overlay only, it was decided that ebuild-packages would be
dropped or migrated into oiledmachine-legacy to ideally eliminate
vulnerable packages.

Packages are updated if a critical vulnerability has been announced.
Send an [issue request](https://github.com/orsonteodoro/oiledmachine-overlay/issues)
if you find one.

Web engines and browsers such as firefox, chromium, webkit-gtk, cef-bin,
CEF/Electron web based apps, are updated everytime a critical
vulnerability is announced or after several strings of high vulnerabilties.

ot-kernel is updated every release to minimize unpatched 0-day exploits.  Old
ebuilds are removed intentionally and assume to contain one or an unannounced
one by comparing keywords in the kernel changelog with the
[CWE Top 25 Most Dangerous Software Weaknesses (2022)](https://cwe.mitre.org/top25/archive/2022/2022_cwe_top25.html)
list.

Packages are updated based on [GLSA](https://security.gentoo.org/glsa) and
random [NVD](https://nvd.nist.gov/vuln/search) searches.

Any binary package with dependencies with critical or high security
advisories matching the version of the dependency will be mentioned in
the ebuild at the time of packaging.  Only upstream can fix those problems
especially if dependencies are statically linked.

Some packages or ebuilds may be hard masked in 
[profiles/package.mask](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/profiles/package.mask)
if the package still has some utility but unable to be removed, or
contains a known infamous critical vulnerability.
