## Ebuild quality

Most ebuilds in this ebuild are assumed production ready.

Disabled KEYWORDS has ambiguous meanings.  It can mean that it is either a live
ebuild, or is incomplete, etc.

### Markings for not production ready

To clarify which ebuilds are not production ready, this overlay has added to the
footer the following metainfo:

```
# OILEDMACHINE-OVERLAY-EBUILD-FINISHED:  NO
```

To see a list which ebuilds are not production ready, run the following at the
root of this overlay:
```
grep -l --exclude-dir=.git -r -e "OILEDMACHINE-OVERLAY-EBUILD-FINISHED:.*NO" ./
```

KEYWORDS does the same thing but it has different meanings over time.  It could
mean fresh install without problems or widely tested.

Production ready means that it simply installs and the package is working
acceptably without necessarily running test suites with minimal install
features or the arbitrary tested USE flag combination at that time.

But in this overlay, running test suites are optional but done so for mostly
library packages or packages that are rarely used with unknown runtime
correctness.  Many python packages in this overlay have been tested but for
other programming languages this has not been done.  In this overlay, it is
planned to prioritize PGO capable first, running test-suites for libraries
next, smaller/trivial packages next, then high MLOC packages over time.
This testing will be limited to only latest stable for dependencies.  This
overlay has fixed missing required USE flags and applied regressions fixes
as a result of running test suites.  These test suites are also inspected
for usefulness (e.g. a benchmark, demos, or similar real world tasks) in
PGO optimization on the ebuild level which some ebuilds exploit.

### Markings for test-suite testing or interactive testing

Test-suite testing is done randomly.  Tentative details can be found at the
footer of the ebuild:

For interactive testing, some most used functionality will be tested.

```
# OILEDMACHINE-OVERLAY-EBUILD-TESTED-VERSIONS:  1.2.1 1.2.1[python_targets_python3_10] commit-id
# OILEDMACHINE-OVERLAY-TEST:  PASS (INTERACTIVE) 113.0.1 (May 15, 2023)
```
