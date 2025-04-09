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
  - IUSE
  - REQUIRED_USE
  - switch-case
  - User defined global variables
* Strings are double quoted.
* Versions are double quoted.
* File/folder paths are typically double quoted from start to end.
* The metadata.xml
  - 2 space indent to emphasize detailed oriented and detailed reviewed ebuild.
  - Symmetrical block style
* Simplification by removing explicit phase functions is preferred.

# Ebuild organization

1. Header
   - A copyright notice is required

2. Comments (optional)
   - TODO list
   - FIXME objectives

4. Pre inherits (optional)

3. User defined global variables above

4. General eclass inherits

5. Download section
   - Typically a conditional with PV == *9999*
   - Live repo info (optional)
     - # User defined globals above
     - EGIT_BRANCH
     - EGIT_REPO_URI
     - EGIT_CHECKOUT_DIR
     - inherit git-r3
     - # Common globals below
     - IUSE+=" fallback-commit"
   - Stable download info
     - KEYWORDS
     - SRC_URI

6. Commonly used global variables below
   - DESCRIPTION
     - It should be the same style
     - Typically an adjective phrase
     - It should be simplified if too long
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
   - src_setup()
   - src_unpack()
     - For live ebuilds, it should have a fallback-commit.
   - src_configure()
   - src_compile()
   - src_install()

