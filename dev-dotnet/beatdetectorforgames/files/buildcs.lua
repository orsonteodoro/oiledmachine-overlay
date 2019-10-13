solution "BeatDetectorForGames"
   configurations { "DebugSharedLib", "ReleaseSharedLib", "DebugStaticLib", "ReleaseStaticLib" }

project "BeatDetectorForGames"
      language "C#"
      files { "**.cs" }
      location "build"
      buildoptions { "-sdk:4.5", "-keyfile:@DISTDIR@/mono.snk" }

      configuration "DebugSharedLib"
         defines { "DEBUG" }
         symbols "On"
         kind "SharedLib"
         links { "System", "System.Core" }
 
      configuration "ReleaseSharedLib"
         defines { "NDEBUG" }
         symbols "Off"
         kind "SharedLib"
         links { "System", "System.Core" }

      configuration "DebugStaticLib"
         defines { "DEBUG" }
         symbols "On"
         kind "StaticLib"
         links { "System", "System.Core" }
 
      configuration "ReleaseStaticLib"
         defines { "NDEBUG" }
         symbols "Off"
         kind "StaticLib"
         links { "System", "System.Core" }

