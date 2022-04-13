# oiledmachine-overlay

## About

This portage overlay contains various ebuilds for the Gentoo Linux
distribution.  It focuses on optimized ebuilds, some game development, 
software used in computer science courses, C#, Electron apps, and other legacy 
software and hardware.

The name of the repo comes from "well-oiled machine."  A (Gentoo) computer 
should not feel like molasses under high memory pressure or heavy IO 
utilization.  It should run smoothly.

## Adding the repo
<pre>
cd /usr/local
git clone https://github.com/orsonteodoro/oiledmachine-overlay.git

Edit /etc/portage/repos.conf/layman.conf and add the following:
[oiledmachine-overlay]
location = /usr/local/oiledmachine-overlay
layman-type = git
auto-sync = No
</pre>

## Keep in sync by
<pre>
cd /usr/local/oiledmachine-overlay
git pull
</pre>

## Important stuff

Many of these packages have special licenses and EULAs attached to them.  I 
recommend that you edit your /etc/portage/make.conf so it looks like this 
ACCEPT_LICENSE="-*" and manually accept each of the licenses.  Licenses can 
be found in the licenses folder of this overlay and the remaining 
[licenses](https://gitweb.gentoo.org/repo/gentoo.git/tree/licenses) can be 
found on the 
[official gentoo overlay](https://gitweb.gentoo.org/repo/gentoo.git/tree/) 
in their license folder too.

Many of these packages especially non-free software also require you to 
manually obtain the installer or files to install and may require you to 
register on their website.  The required files are listed in the ebuild.

The dev-dotnet folder contains fixes for both dotnet overlay and shnurise 
overlay ebuilds.  They many of the ebuilds in that folder in this overlay 
are dependencies for the latest stable MonoDevelop and for MonoGame.

## Broken / Still in development

### NPM / Electron apps

If it complains about "emerge: there are no ebuilds to satisfy" and 
refers to @npm-security-update.  You can remove the deleted package by 
editing /etc/portage/sets/npm-security-update.

If you can't unemerge a npm or electron ebuild from this overlay, please 
read the `eselect news` item 
["Manual removal of npm or electron based packages required"](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/metadata/news/2020-07-19-manual-removal-npm-and-electron/2020-07-19-manual-removal-npm-and-electron.en.txt).

See 
[npm-secaudit.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/npm-secaudit.eclass), 
[npm-utils.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/npm-utils.eclass), 
[electron-app.eclass](https://github.com/orsonteodoro/oiledmachine-overlay/blob/master/eclass/electron-app.eclass) 
for ways to control vulnerability patching using per-package environmental variables.

The app-portage/npm-secaudit package is optional but provides adding npm and 
electron packages to the @npm-security-update set if a vulnerability was found.

### .NET Framework stack or .NET Core stack

(May be revised)

This section applies only to this overlay.  It is decided that the entire
.NET Core stack or any packages that sits on top of .NET Core on the
oiledmachine-overlay will be removed for the difficulty of getting a source
only build primarily, and due to critical vulnerabilities.  Some packages will
be modded to remove dotnet or C# support.

Packages that rely alone on mono (.NET Framework) but not .NET Core may be kept.

Some packages will be moved to 
[oiledmachine-overlay-legacy](https://github.com/orsonteodoro/oiledmachine-overlay-legacy).

## Legacy packages

Old packages can be found at 
[oiledmachine-overlay-legacy](https://github.com/orsonteodoro/oiledmachine-overlay-legacy).

A package may be moved to oiledmachine-overlay-legacy if bundled dependencies
are not fixed within several following discoveries of critical vulnerabilties
typically in several months.

A package also moves to legacy if the project is defunct.

A package does not move to legacy if a newer different package replacement is
found or same ebuild found in the gentoo-overlay.

A package does not move to legacy if the project's source code or possibly the
dependency's source code was deleted.

## Enhanced ebuild metadata.xml info

Some of the ebuilds in this repo contain improved comprehensive information
describing USE flags, developer API documentation info, or special per-package
environmental variables that improve the build process that can be found in
the metadata.xml, or obtainable through `epkginfo -x =dev-games/box2d-2.4.1-r2`
for example.  Some of that information is only obtained by inspecting the
comments of that file.  See `epkginfo --help` for details.

## Security policy

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
one.

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

## PGO packages

The following list contains ebuilds modified by this overlay with PGO (Profile
Guided Optimization) support, with additional patches from others listed in
the metadata.xml.

* media-libs/libaom
* media-libs/libjpeg-turbo
* media-libs/libspng
* media-libs/libvpx
* media-video/ffmpeg
* media-gfx/blender (WIP)
* net-libs/nodejs
* sys-devel/clang (WIP)
* sys-devel/llvm (WIP)
* sys-kernel/ot-sources
* sys-kernel/genkernel
* sys-libs/zlib
* www-client/chromium (1 stage PGO yes, 3 stage PGO WIP)
* net-libs/webkit-gtk (WIP)

## Packages

| package | description |
| --- | --- |
| app-arch/AppImageKit | Contains appimagetool to package apps in the AppImage format. |
| app-arch/appimaged | Contains the daemon to load appimage packaged programs.  Deprecated but more reliable. |
| app-arch/appimageupdate | Used to update AppImages |
| app-arch/go-appimage | Contains the daemon to load appimage packaged programs and appimagetool.  AppImage is used for container-like sandboxed portable Linux or Electron apps ideal for LiveCDs or USB transport.  This package is still in development. |
| app-editors/epic-journal | This is an Electron based encrypted journal. |
| app-editors/nano-ycmd | This is a modified GNU nano that uses ycmd.  It is still experimental. |
| app-emacs/emacs-ycmd | This is a major mode (extension) to GNU Emacs that allows you to use ycmd. |
| app-eselect/eselect-emscripten | Allows to use a particular Emscripten version as the current one. |
| app-eselect/eselect-nodejs | Allows to use a particular Node.js as the current one. |
| app-eselect/eselect-opengl | Deprecated |
| app-eselect/eselect-typescript | Allows to use a particular TypeScript version as the current one.  Used for ycmd. |
| app-portage/npm-secaudit | A simple postsync script to check npm and Electron apps for security updates. |
| app-shells/emoji-cli | This is an emoji autocompletion plugin for Zsh.  You might want to combine it with emojify. |
| app-shells/emojify | This is a BASH shell script to convert emoji aliases described in English words into Unicode equivalent to display the emoji. |
| app-shells/oh-my-zsh | Oh My Zsh are extra themes and plugins to enhance Zsh.  This ebuild allows to pick specific themes and plugins and to get rid of the ones you don't need. |
| dev-db/nanodbc | A dependency for Urho3D. |
| dev-dotnet/aforgedotnet | This is the AForge.NET library containing computer vision and aritificial intelligence algorithms.  Kinect (via libfreenect) support untested.  References to FFmpeg were untested.  The package needs testing.  The author said that the video isn't feature complete on Mono for Linux. |
| dev-dotnet/assimp-net | For loading 3D models in dotnet games or simulations |
| dev-dotnet/atitextureconverter | You don't need the actual proprietary library to compile MonoGame.  The wrapper alone will do fine in order to use MonoGame.  You need to manually install the proprietary library if you have the hardware.  Instructions are provided in the library to obtain and place it. |
| dev-dotnet/beatdetectorforgames | This is a FMOD based beat detector which may be useful for rhythm games.  It has support for both C++ and C#.  The C# is a wrapper around the FMOD library.  The author said there wasn't Linux support but it could happen because there is a FMOD library in the main Gentoo overlay.  It still needs testing. |
| dev-dotnet/BulletSharpPInvoke | This is a C# wrapper for libbulletc used for realistic physics in games. |
| dev-dotnet/farseer-physics-engine | This is a physics engine based on Box2D and is a C# library.  This one also has support for MonoGame. |
| dev-dotnet/fna | This is an XNA4 ebuild which just produces a C# assembly.  This project sadly doesn't have a MonoDevelop add-in.  This ebuild is provided for others to fix and expand. |
| dev-dotnet/freeimagenet | This is for loading textures in C# for games or multimedia apps. |
| dev-dotnet/libfreenect | This is a C# wrapper for the libfreenect for the XBox Kinect camera. |
| dev-dotnet/libgit2sharp | TBA |
| dev-dotnet/mono-addins | TBA |
| dev-dotnet/monogame | This is probably the only portage overlay that has it.  If you use the add-in for MonoGame 3.5.1, it could only work for MonoDevelop 5.x series.  MonoGame 3.6 add-in should work for MonoDevelop 6.x series.  This one requires that mono, monodevelop, nvidia-texture-tools from this overlay.  I disabled NUnit on those and split it off into its own ebuild.  The latest LLVM is required for CppSharp.   You also need to set LIBGL_DRIVERS_PATH environmental variable in your MonoDevelop or wrapper script to /usr/lib/dri before running the app. <br /><br /> The package still needs testing.  I striped out lidgren and made an ebuild for it and use lidgren-network-gen3.  The OpenTK and Tao Framework were binary only and I used a compiled version from my ebuilds for the GamePad library.  SDL 1 is required for the GamepadConfig since Tao Framework uses SDL1.  The SDL2 is also required for the OpenTK library.  <br /><br />  If you create a new solution in MonoGame, you should answer no to override the Tao.Sdl.dll.config and OpenTK.dll.config File Conflicts Dialog Box.  The one provided has absolute paths to the required libraries and Linux support.  <br /><br />  If you get a red x dot in MonoDevelop complaining about an assembly (nvorbis for example) for MonoGame, the game will compile and run still.  <br /><br />  The ebuild uses dev-dotnet/managed-pvrtc without USE flag.  Please read the dev-dotnet/managed-pvrtc below before distributing or using  it.  <br /><br />  Again, I need people who have used this library to test this ebuild and the tools (mgcb, pipeline).  <br /><br />  Also, this is a Linux only ebuild which means it will only build games for Linux.  You cannot use it to port to other platforms (Android, Apple TV, iOS) because Xamarin Studio is not in Linux which required to port to mobile. |
| dev-dotnet/monogame-extended |  This contains several common modules found in game engines like a particle engine, based on Mercury Particle Engine, and a tiled map loader for maps created by the Tiled Map Editor.  Currently a vanilla build of MonoGame stable doesn't support shaders on Linux so some features will not work for this assembly. |
| dev-dotnet/ndesk-options | TBA |
| dev-dotnet/nvorbis | TBA |
| dev-dotnet/opentk | TBA |
| dev-dotnet/pvrtexlibnet | You should stay away from this one but it may be required for compiling MonoGame which I didn't take the time to turn off.  Basically pvrtexlibnet is another C# wrapper around the propretary PVRTexLib library blob from Imagination Technlogies.  You need to download the library there.  The binary library blob uses the PVRTC compression (https://en.wikipedia.org/wiki/PVRTC) which is patented.  The license in those libraries are restricted.  There is a bindist flag for this one.  Using the bindist will not install the propretary library and proprietary documentation just the wrapper.  Delete the PVRTexLib from that this ebuild uses and use the one from Imagination Technlogies. |
| dev-dotnet/sfmldotnet | TBA |
| dev-dotnet/sharpfont | TBA |
| dev-dotnet/sharpnav | This library is a AI pathfinding library in C# useful for games. |
| dev-dotnet/tesseract | This is a C# binding to the Tesseract OCR (Optical Character Recognition) software which will allow your program to read material produced by typewriters and from books. |
| dev-dotnet/tiledsharp | This library is a map loader in C# for the Tiled Map Editor. |
| dev-dotnet/xwt | TBA |
| dev-games/box2d | Box2D is used for realistic 2D game physics.  This contains multilib and static-libs support. |
| dev-games/enigma | Enigma is a Game Development environment that is similar to GameMaker.  More information can be found in https://enigma-dev.org/docs/Wiki/ENIGMA .  Basically LateralGM is the Level Editor like GameMaker's and ENIGMA is a toolchain and collection of projects.  ENIGMA will compile scripting portion of EDL which is the counterpart to GML with C++.  LateralGM is written in Java and ENIGMA is written in C++.  ENIGMA is a plugin that plugs into LateralGM.  EDL is mostly backwards compatibile with GMK scripting language.  It is GPL-3 licensed. <br /><br /> Currently compiling by command line is broken.  You must use LateralGM to build your ENIGMA game.  I am currently trying to fix this. |
| dev-games/radialgm | Another frontend for ENIGMA written in Qt/C++ providing for more native desktop feel but in development.  This is basically the level editor and action editor for drag-and-drop game AI programming. |
| dev-games/gdevelop | This is a game development software using Electron or web browser as the IDE to produce HTML5 games. |
| dev-games/godot | Godot is an open source alternative to the Unity Game Engine.  This one is the 2.0 beta.  It also installs the demos in /usr/share/godot.  I recommend the platformer demo to test the sound and hardware accelerated OpenGL. |
| dev-games/lateralgm | LateralGM is a frontend for ENIGMA in Java for portability ready for production.  This is basically the level editor and action editor for drag-and-drop game AI programming. |
| dev-games/lgmplugin | This is the ENIGMA plugin wrapper.  It is a middle man between LateralGM and the ENIGMA compiler.  The lgmplugin can be used by GUI (through LateralGM) or CLI (command line) but currently the CLI is broken.  It was written in Java.  I am investigating why it is broken. |
| dev-games/libmaker | This is the Library editor for ENIGMA and GameMaker to customize and add button actions for the drag and drop scripting.  It was written in Java.  More information can be found at https://enigma-dev.org/docs/Wiki/Library_Maker. |
| dev-games/mojoshader | Used to allow for compatible usage for Direct3D shaders on non-Windows platforms to produce post-production special effects. |
| dev-games/recastnavigation | This is a AI pathfinding library for C++.  Use this if you want your AI to walk around walls and obstacles. |
| dev-games/urho3d | Urho3D is another game engine.  Android and Raspberry PI support on the ebuild level is incomplete but left for Gentoo community to help finish.  The system libraries are preferred because the internal libraries are several years old.  There may be quirks when using the system libraries.  If you see any that bother you, then use the internal dependency instead. |
| dev-lang/gambas | Gambas is based on the BASIC programming language dialect.  It is basically a Visual Basic clone.  Version 3.8.4 is in this overlay.  Use the `ide` USE flag to build the IDE.  You can make games with it and has support for OpenGL. |
| dev-lang/lua | This is a lua library with Urho3D changes necessary for coroutines |
| dev-lang/luajit | This is a luajit library with Urho3D changes necessary for coroutines |
| dev-lang/typescript | TBA |
| dev-libs/asmlib | TBA |
| dev-libs/hyphen | TBA |
| dev-libs/leveldb | TBA |
| dev-libs/libfreenect | TBA |
| dev-libs/log4c | TBA |
| dev-libs/nxjson | A JSON parser library for C.  Used in nano-ycmd. |
| dev-libs/pugixml | A XML parser library for C++. |
| dev-libs/rapidjson | A JSON parser in C++.  Used in Urho3D. |
| dev-lua/luasqlite3 | TBA |
| dev-python/pocket | This is the Pocket API for Python. |
| dev-python/py-stackexchange | A Python library to interact with StackExchange, Stack Overflow, etc. |
| dev-python/python-plexapi | TBA |
| dev-python/soundcloud-python | A Python library to interact with SoundCloud |
| dev-util/bear | TBA |
| dev-util/carbon-now-cli | This is a command line Node.js app that will create prettified code screenshots to share using the https://carbon.now.sh/ service. |
| dev-util/emacs-ycmd | This is a ycmd client for GNU Emacs. |
| dev-util/emscripten | Emscripten allows to run C/C++ apps on a web browser.  It is typically used by game engines port games into web browsers. |
| dev-util/emscripten-fastcomp | For asm.js support.  Deprecated. |
| dev-util/grex | grex is a regular expression generator |
| dev-util/gycm | Gycm is a Geany plugin and ycmd client to improve IntelliSense support on top of the stock completer. |
| dev-util/lepton | This is a programmer reusable code snipplet manager based on Electron and able to sync with Gist. |
| dev-util/objconv | TBA |
| dev-util/ycm-generator | You need this if you want C, C++, ObjC, ObjC++ support with your ycmd client.  It is mandatory for those languages. |
| dev-util/ycmd | This is a YouCompleteMe server.  Just add your ycmd client to your text editor then you have code completion support.  The 2014 ebuild is for older clients.  The 2017 ebuilds require clients use the new HMAC header calculation.  It supports C#, C, C++, Objective C, Objective C++, Rust, Go, JavaScript, TypeScript, Python.  If you use the `javascript` or `typescript` USE flag, then you need to add the jm-overlay to pull in the dev-nodejs packages. |
| dev-vcs/breezy | This is a Bazaar client in Python v3. |
| liri-base/liri-meta | This is the meta package for installing the Liri desktop environment. |
| media-fonts/noto-color-emoji | This currently supports Emoji 5.0.  This one you can use to compile noto color emoji.  The benefit is that you can get updated emojis.  This one also contains a black smiling face emoji to replace the text presentation unlike the -bin.  `emerge noto-color-emoji-config` to apply emojis as default. |
| media-fonts/noto-color-emoji-bin | This one has been precompiled containing old or new emoji aesthetic as in round or jellybean style.  `emerge noto-color-emoji-config` to apply emojis as default. |
| media-fonts/noto-color-emoji-config | This package will apply fontconfig fixes to firefox, google chrome, etc systemwide.  You can use Gentoo's noto-emoji package instead of the one on this overlay. |
| media-gfx/blender | Ebuild was fork designed to multislotted and comprehensive to match the feature release enablement upstream.  Use the `virtual/blender-lts` or `virtual/blender-stable` to choose the update path. |
| media-gfx/blockbench | This is an Electron based boxy 3D modeler and animator program used in games |
| media-gfx/caesiumclt | This is a command line image compressor for PNG and JPEG files. |
| media-gfx/nvidia-texture-tools | This one builds the C# language binding and nvtt native library required for MonoGame.  You need to install this one from the repository for MonoGame to compile correctly.  This ebuild generates Nvidia.TextureTools.dll per each vc{10,8,9,12,monogame} because upstream don't delete one of them so a consumer may depend on the old one.  You need to enable the `monogame` USE flag to generate the proper older Nvidia.TextureTools.dll. |
| media-gfx/texturelab | This is an Electron based GPU accelerated texture maker. |
| media-libs/glfw | TBA |
| media-libs/libcaca | This library contains an experimental special 256 color patch from Ben Wiley Sittler.  I don't know if the patch actually works from emperical tests.  Maybe it is just me or I forward patched it wrong.  I use the experimental 256 color for facy to render Facebook photos, animated GIFs, and Facebook videos to try to better render skin color.  I still think Termpic colors rendering is better. |
| media-libs/libcaesium | For caesium image compression. |
| media-libs/libfishsound | For multilib tizonia. |
| media-libs/embree | For amd-radeon-prorender-blender plugin. |
| media-libs/libmp4v2 | For multilib tizonia |
| media-libs/liboggz | For multilib tizonia |
| media-libs/libyuv | For xpra compression |
| media-libs/mozjpeg | A JPEG encoding library for higher visual quality and smaller file sizes.  It is a superset of libjpegturbo. |
| media-libs/nestegg | TBA |
| media-libs/openimageio | TBA |
| media-libs/opusfile | TBA |
| media-libs/mozjpeg | This is a dependency for CaesiumCLT. |
| media-libs/libspng | This is another alternative png library that has been fuzzed to eliminate security holes. |
| media-libs/theorafile | This is a system library for the dotnet package. |
| media-libs/theoraplay | This needs testing. |
| media-libs/vips | Kept for TypeScript. |
| media-plugins/bitlbee-facebook | TBA |
| media-plugins/gst-plugins-omx | TBA |
| media-plugins/RadeonProRenderBlenderAddon | You still need to manually enable the plugin. |
| media-plugins/RadeonProRenderMaterialLibrary | Assets for the addon |
| media-sound/puddletag | This is a mp3 metatag editor.  Autosaves edits and doesn't need to be explicity be told to save.  This is the PyQt5 version.  |
| media-sound/tizonia | This is both a command line media player and an OpenMAX library. |
| media-sound/w3crapcli-lastfm | These are shell scripts to allow for Last.fm support for mpv.  This one was modified a bit for Last.fm 2.0 API.  You need your own an developer API key from last fm to use it.  It has last played support as well.  The one on w3crapcli Github repository uses an external bloated dependency. |
| media-video/epcam | Epcam is a driver for support for webcams based on EP800/SE402/SE401 chip.  It uses sources from https://github.com/orsonteodoro/gspca_ep800.  This driver differs from the main kernel driver in that it supports the newer reference firmware.  It still needs testing for runtime breakage. |
| media-video/obs-studio | This is an ebuild fork for better checks for hardware accelerated x264/vaapi encoding support, and better modular support for showing a webpage as a source used typically used in news reporting, showing fan sites, or donations. |
| net-analyzer/wireshark | This ebuild integrats MTP (Media Transfer Protocol) packet filter.  It also warns of MTPz authentication handshake points in the Expert info.  You may need to modify in the source code level the interface number, vendor ID, device ID for your USB to match your particular device since I didn't write the GUI interface for that yet. |
| net-im/caprine | This package is an Electron based Facebook Messenger. |
| net-libs/cef-bin | Chromium Embedded Framework with prebuilt chromium.  Used in obs-studio. |
| net-libs/nodejs | This is a multslot ebuild fork of Node.js.  Tracks all latest LTS releases. |
| net-libs/webkit-gtk | This ebuild has multi-ABI support meaning it can build 32-bit webkit-gtk on a 64-bit machine and both 64-bit and 32-bit builds can be present.  You may also choose to build just one ABI.  This ebuild mod also allows you to build the MiniBrowser frontend. |
| net-misc/googler | This is a Google command line client. |
| net-misc/rainbowstream | This is a Twitter command line client. |
| sci-geosciences/google-earth-pro | This is a working ebuild of Google Earth Pro.  The Gentoo overlay had abandoned the old Google Earth ebuild. |
| sci-physics/bullet | This library is a dependency for BulletSharpPInvoke.  It combines all modules, which were originally seperate dlls, into one shared object/dll. |
| sys-apps/oomd | This is an intelligent userspace daemon to prevent halting by terminating memory leaks or heavy IO based on a decision tree before they happen.  It can be extended with custom coded modules. |
| sys-kernel/genkernel | This is a modified genkernel with `subdir_mount` use flag to mount the system from a folder other than `/` and `crypt_root_plain` use flag to mount plain mode dm-crypt.  For crypt_root_plain kernel option, you provide the path from /dev/disk/by-id/ .  For subdir_mount, you provide the path to the folder.  See https://github.com/orsonteodoro/muslx32#notes for details on how to use subdir_mount. |
| sys-kernel/ot-sources | This package contains a collection of patches.  It contains UKSM, zen-tune, GraySky2's kernel_gcc_patch, MuQSS CPU scheduler, PDS CPU scheduler, genpatches (kernel updates), BFQ updates, TRESOR cold boot resistant patch, O3 optimize harder patch, CVE fixes.  The TRESOR patch is experimental for x86_64 arch which is just the x86 generic that has been modified for x86_64 generic; and has passed the self tests.  Use the `ot-sources-lts` or `ot-sources-stable` to choose the type of update path. |
| sys-power/cpupower-gui | This is a package for a graphical user interface (GUI) for changing the CPU frequency limits and the governor.  It needs elevated privileges to use it like with sudo. |
| sys-process/psdoom-ng | This is a process killer based on Chocolate Doom 2.2.1 with man file and simple wrapper. |
| www-client/chromium | This ebuild mod has multi-ABI support meaning it can build 32-bit Chromium on a 64-bit machine and both 64-bit and 32-bit builds be present.  You may also choose to build just one ABI.|
| www-client/firefox | This ebuild mod has multi-ABI support meaning it can build 32-bit Firefox on a 64-bit machine and both 64-bit and 32-bit builds be present.  You may also choose to build just one ABI.|
| www-client/surf | **WARNING!!! If you emerge this, it may delete your saved config located in /etc/portage/savedconfig/www-client/{surf-2.0,surf-0.6-r2}.  Backup it up.** surf is a WebkitGTK based browser.  This package contains added built-in ad-blocking support even in SSL.  Fixes were added to support for Facebook.  Support was added for GTK3 smooth scrolling.  Additional added support for external apps for desktop environment MIME to program association, external Flash video for some sites [helper scripts may require updating], and link highlighting.  <br /><br />The 0.6-r2 in this overlay has new window fixes.  It also doesn't create a new instances of itself.  It uses WebKit2 to handle that.  When it creates windows, it uses only one surf instance and new windows act like tabs.  The one by czarkoff and kaihendry and the original surf both create new windows and new WebKitWebProcesses per each new window.  So, my version has a lower memory footprint.  <br /><br />Read the licenses/SURF-community before emerging it.  <br /><br />To update the surf adblocker you need to go to /etc/surf/scripts/adblock and run the update.sh script. <br /><br /> In the 2.0 ebuild, I removed the patches to GTK3 but it most likely doesn't use the custom GTK3 patches in 0.6-r2.  |
| www-misc/ddgr | This is a command line DuckDuckGo similiar to googler. |
| www-misc/googler | Kept around for latest updates. |
| www-misc/instatron | This is a Instagram uploader in Electron. |
| www-misc/rtv | This is a command line Reddit client which has been updated. |
| www-misc/socli | This is a Stack Overflow command line client. |
| www-servers/civetweb | Kept around for Urho3D. |
| x11-wm/dwm | This ebuild fixes the emoji titlebar crash and has integrated Fibonacci layout patch applied. |
| x11-wm/xpra | This is an alternative VNC like client.  It's kept around for Firejail. |
