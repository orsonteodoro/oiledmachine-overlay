## Broken / Still in development

### Python

Several packages hard depend on Python 3.9 and will emit
"No supported implementation in PYTHON_COMPAT" because of the eager version
bump of this version which is not EOL until Oct 2025 by the Python language
developers but EOL on this distro.

You will need to uninstall these packages.

The maximum slot will not be auto bumped by scripts in this overlay anymore.

Python maximums for PYTHON_COMPAT in this overlay are upstream set listed
in python.py + proof of test (aka summary of the test result(s) passed)
which are listed in the footer of the ebuild as the standard in this
overlay.  This overlay may downgrade the PYTHON_COMPAT if no proof is
provided.

### .NET Framework stack or .NET Core stack

It was decided to keep these packages around; however, they are not tested
in actual programs.

Since there is no official distro package developer guide or eclass for
.NET 6.0+ packages, the install locations may be off for ebuilds in this
overlay.
