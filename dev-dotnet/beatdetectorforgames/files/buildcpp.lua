solution "BeatDetectorForGames"
   configurations { "DebugSharedLib", "ReleaseSharedLib", "DebugStaticLib", "ReleaseStaticLib" }

project "BeatDetectorForGames"
      language "C++"
      includedirs { "../FMOD/", "/opt/fmodex/api/inc/"  }
      files { "**.cpp", "/opt/fmodex/api/inc/**.hpp" }
      location "build"
      buildoptions { "-std=c++11" }

      configuration "DebugSharedLib"
         defines { "DEBUG" }
         symbols "On"
         kind "SharedLib"
         links { "c" }
 
      configuration "ReleaseSharedLib"
         defines { "NDEBUG" }
         symbols "Off"
         kind "SharedLib"
         links { "c" }

      configuration "DebugStaticLib"
         defines { "DEBUG" }
         symbols "On"
         kind "StaticLib"
         links { "c" }
 
      configuration "ReleaseStaticLib"
         defines { "NDEBUG" }
         symbols "Off"
         kind "StaticLib"
         links { "c" }

