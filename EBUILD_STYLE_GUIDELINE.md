# Overlay ebuild style guidelines

* Symmetrical everywhere
  - Symmetrical above and below
  - Symmetrical left and right
* Arrays are symmetrical.
* Strings are symmetrical.
* Indents are tabs only.
* The ebuild coding style should resemble similar higher level programming languages coding styles to reduce the learning curve of patching software at code level.
* Ebuild explicit and verbose syntax is preferred to encourage fixing code level bugs.
* 80 characters per line.
* Comments indented either tab 0 or 1st tab and no more.
- Comments should be in formal language.
* Loops and algorithms can only be O(1), O(n).
* No more than 2 tabs indents.
* Generators should be used instead of repeated blocks of strings.
* All local variables and loop variables should be declared explicitly local.
* All local names should be lower case with underscore separating words.
* All global names should be capitalized with underscores separating words.
* An ASCII inspired sort should be used whenever possible to the following
  - arrays
  - assocative arrays
  - *DEPENDs
  - if-else chains
  - In metadata.xml in the
    - use flag section
    - upstream section
  - IUSE
  - LICENSE
  - REQUIRED_USE
  - SRC_URI
  - switch-case
  - User defined global variables
* Strings are double quoted.
* Versions are double quoted.
* File/folder paths are typically double quoted from start to end.
* The metadata.xml style
  - 2 space indent to emphasize detailed oriented and detailed reviewed ebuild.
  - Symmetrical block style
* Simplification by removing explicit phase functions is preferred.
* The oldest CI image is the fallback image if no specific versions specified in
  build files but images are in CI.  If no CI testing is being done, then you
  don't need to specify the version unless the code requires it
  (e.g. gui-libs/gtk:4).

  - For example,

    - U24 has libgcrypt 1.10.3
    - U22 has libgcrypt 1.9.4
    - D12 has libgcrypt 1.10.1

    If the build files say libgcrypt and image D24 is only being tested, then use
    `>=dev-libs/libgcrypt-1.10.3` for RDEPENDs.

    If the build files say libgcrypt and image D12 and D24 are being tested, then
    use `>=dev-libs/libgcrypt-1.94` for RDEPENDs.

    If the build files say just libgcrypt and no images or CI testing, you
    may use just `dev-libs/libgcrypt` for RDEPENDs.

    If the build files say libgcrypt with minimum version, you may use that
    instead.

* PYTHON_COMPAT fallbacks.
  - If setup.py contains only python3, you may list only stable Python KEYWORDS,
    or include up to Python 12 which U24 uses, or include up to Python 11 which
    D12 uses.
  - If setup.py contains Python 3.9 only, you may only list the tested version
    and earlier.  The package by some packagers is considered EOL or a defunct
    project.
  - If setup.py contains Python 3.9, 3.10, but you tested 3.11, you
    may specify `PYTHON_COMPAT=( "python3_"{10..11} )` but you need to
    leave a comment that you tested it or specify which package exactly needs it.
    Otherwise, I revert it back to upstream tested version list.  I assume that
    you made a typo that will introduce a non-reproducable build.
  - If setup.py contains Python 3.9, 3.10, you should put
    `PYTHON_COMPAT=( "python3_10" )` as the default fallback since Python 3.9 is not
    available on distro due to python-utils-r1.eclass restrictions.
* If an ebuild references a PYTHON_SINGLE_USEDEP in *DEPENDs, the ebuild should
  use either `DISTUTILS_SINGLE_IMPL=1` with `inherit distutils-r1` or
  `inherit python-single-r1`.  This edge case is not well documented.
* If a package contains an uncommon license or legal changes that introduce a
  new phrase or clause, it should be documented as a comment near the LICENSE
  variable.
* Live ebuilds should have fallback-commit support to reduce GH issue spam and
  to improve reproducibility for projects without version tags.
* Using sed patches is strongly discouraged.  Use patch files instead.
* Network based daemons should be considered for sandboxing or confinement for
  new projects or packages with high reported vulnerabilities or to prevent
  Information Discloure (ID) or Data Tampering (DT) based path traversal
  attacks.
* Daemons need to be run as non-root user.
* For web apps that require user login, the ssl USE flag should be made
  available and implemented properly if the project does not document it.
* The ebuild should be polished to improve stability and to hide/disable
  unfinshed features at the code level.
* The CFLAGS should be changed with `filter-flags` or `replace-flags` to
  prevent Denial of Service (e.g. crash).
* If -O3 or -Ofast causes a crash, then the CFLAG must be downgraded to -O2 or
  whatever is necessary to prevent a crash.
* The CFLAGS must be bumped or boosted if degraded runtime performance is
  severe.
* If below 24 FPS, then bump the -Oflag minimum allowed.
* If computation is longer than expected, then bump the -Oflag minimum allowed.
* Performance expectations:
  - Servers:  6 days minimum uptime, +60 days uptime preferred
  - Gaming newer titles:  60 FPS
  - Gaming older titles:  30 FPS
  - Hardcore mode gaming:  +60 days uptime
  - Sports:  30 FPS
  - News and vlogs:  30 FPS
  - Movies:  24 FPS
  - Audio production:  No jitter, no studder
  - Live radio reporting:  No jitter, no studder
  - Ebuild compliation time: < 24 hours
  - Scrolling:  No delay, no lag
  - Workstation:  48 hours minimum uptime for all nighter scenario

# Ebuild organization

1. Header
   - A copyright notice is required

2. Comments (optional)
   - TODO list
   - FIXME objectives

4. Pre inherits (optional)

3. User defined global variables

4. General eclass inherits

5. Download section
   - Typically a conditional with PV == *9999*
   - Live repo info (optional)
     - EGIT_BRANCH
     - EGIT_REPO_URI
     - EGIT_CHECKOUT_DIR
     - inherit git-r3
     - IUSE+=" fallback-commit"
   - Stable download info
     - KEYWORDS
     - SRC_URI

6. Commonly used global variables
   - DESCRIPTION
     - Typically an adjective phrase
     - It should be simplified if too long
   - LICENSE
     - List licence commentary below this variable.
   - SLOT
   - RESTRICT
   - IUSE
   - REQUIRED_USE
   - RDEPEND
   - DEPEND
   - BDEPEND
   - PDEPEND
   - DOCS
   - PATCHES

7. Ebuild phases
   - These should be in chronological order.
   - pkg_setup()
   - pkg_nofetch()
   - src_unpack()
     - For live ebuilds, it should have a fallback-commit.
   - src_configure()
   - src_compile()
   - src_install()

