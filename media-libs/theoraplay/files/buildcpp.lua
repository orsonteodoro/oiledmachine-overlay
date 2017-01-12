solution "theoraplay"
   configurations { "DebugSharedLib", "ReleaseSharedLib", "DebugStaticLib", "ReleaseStaticLib" }

project "theoraplay"
      language "C++"
      includedirs {  }
      files { "theoraplay.c", }
      location "build"
      buildoptions { "-O2 -std=c99 -Wall -Wno-implicit-function-declaration -Wl,--no-undefined" }

      configuration "DebugSharedLib"
         defines { "DEBUG" }
         symbols "On"
         kind "SharedLib"
         links { "ogg", "vorbis", "theoradec" }

      configuration "ReleaseSharedLib"
         defines { "NDEBUG" }
         symbols "Off"
         kind "SharedLib"
         links { "ogg", "vorbis", "theoradec" }

      configuration "DebugStaticLib"
         defines { "DEBUG" }
         symbols "On"
         kind "StaticLib"
         links { "ogg", "vorbis", "theoradec" }

      configuration "ReleaseStaticLib"
         defines { "NDEBUG" }
         symbols "Off"
         kind "StaticLib"
         links { "ogg", "vorbis", "theoradec" }
