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
* All local variables and loop variables should be declared explicit local.
* All local names should be lower case with underscore separating words.
* All global names should be capitalized with underscores separating words.
* The metadata.xml
  - 2 space indent to emphasize detailed oriented and detailed reviewed ebuild.
  - Symmetrical block style

1. Header
   - Must contain copyright notice

2. Comments
   - TODO list
   - FIXME objectives

4. Pre inherits

3. User defined global variables

4. General eclass inherits

5. Download section
   - Typically conditional PV == *9999*
   - Live repo info (optional)
     - inherit git
   - Stable download info
     - KEYWORDS
     - SRC_URI

6. Required basic global variables
   - DESCRIPTION
     - It should be the same style
     - Typically an adjective phrase
   - IUSE
     - For live ebuilds, fallback-commit should be available.
   - RDEPEND
   - DEPEND
   - BDEPEND
   - PDEPEND
   - DOCS
   - PATCHES

7. Ebuild phases
   - These should be in chronological order.
   - src_setup()
   - src_unpack()
     - For live ebuilds, it should have a fallback-commit.
   - src_configure()
   - src_compile()
   - src_install()

