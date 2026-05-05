## Enhanced ebuild metadata.xml info

Some of the ebuilds in this repo contain improved comprehensive information
describing USE flags, developer API documentation info, or special per-package
environmental variables that improve the build process that can be found in
the metadata.xml, or obtainable through `epkginfo -x =games-engines/box2d-2.4.1-r2`
for example.  Some of that information is only obtained by inspecting the
comments of that file.  See `epkginfo --help` for details.

Additional troubleshooting details can also be found by inspecting the header
and footer of the ebuild.
