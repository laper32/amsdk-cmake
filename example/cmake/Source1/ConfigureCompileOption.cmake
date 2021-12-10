#
# Purpose: Determine compiler.
#
if(MSVC)
    add_compile_options(-DCOMPILER_MSVC)
    if(TARGET_ARCH MATCHES "x86_64")
        add_compile_options(-DCOMPILER_MSVC64)
    else()
        add_compile_options(-DCOMPILER_MSVC32)
    endif()
else()
    add_compile_options(-DCOMPILER_GCC) ## clang or gcc
endif()

#
# Purpose: Check stdint.h
#
include(CheckIncludeFile)
check_include_file(stdint.h HAVE_STDINT_H)
if (HAVE_STDINT_H)
    add_compile_options(-DHAVE_STDINT_H)
endif()

#
# Purpose: Determine basic macro for UNIX System
#
if(NOT WIN32)
    if (HL2SDK_ENGINE_NAME MATCHES "sdk2013" OR HL2SDK_ENGINE_NAME MATCHES "bms" AND CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        add_compile_options(
                -DPOSIX                 -DVPROF_LEVEL=1             -DSWDS                  -D_finite=finite
                -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp      -D_alloca=alloca        -Dstrcmpi=strcasecmp
                -DGNUC
        )
    else()
        add_compile_options(
                -DPOSIX                 -DVPROF_LEVEL=1             -DSWDS                  -D_finite=finite
                -Dstricmp=strcasecmp    -D_stricmp=strcasecmp       -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp
                -D_vsnprintf=vsnprintf  -D_alloca=alloca            -Dstrcmpi=strcasecmp    -D_snprintf=snprintf
                -DGNUC
        )
    endif()

    if (TARGET_ARCH MATCHES "x86")
        add_compile_options(-m32)
        add_link_options(-m32)
    endif()

    add_compile_options(-Wno-narrowing -Wno-register -O3 -pipe -Wno-uninitialized -Wno-unused 
    -Wno-switch -msse -fPIC -Wno-non-virtual-dtor -Wno-overloaded-virtual -Wno-unused-result -Wno-ignored-attributes
    -fno-strict-aliasing
    )
    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_compile_options(-fvisibility=hidden -fvisibility-inlines-hidden -Wno-delete-non-virtual-dtor)
    endif()
    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        add_compile_options(-mfpmath=sse -Wno-volatile)
    endif()
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_compile_options(-Wno-implicit-int-float-conversion -Wno-tautological-overlap-compare -Wno-deprecated-volatile
        -Wno-implicit-exception-spec-mismatch -Wno-expansion-to-defined -Wno-inconsistent-missing-override -Wno-deprecated-register
        -Wno-ambiguous-reversed-operator -Wno-tautological-undefined-compare -Wno-enum-compare-switch -Wno-c++11-narrowing
        )
    endif()
endif()

#
# Purpose: Configure MSVC compiler options
#
if (MSVC)
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")
    add_compile_options(/wd4819 /wd4828 /wd5033 /permissive- /utf-8 /wd4005)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS=1 _CRT_SECURE_NO_DEPRECATE=1 _CRT_NONSTDC_NO_DEPRECATE=1)
endif()

if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    set(OSX ON)
    add_compile_options(-DOSX -D_OSX)
elseif (CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(LINUX ON)
    add_compile_options(-DLINUX -D_LINUX -D_FILE_OFFSET_BITS=64)

    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        add_link_options(-static-libgcc)
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        add_link_options(-lgcc_eh)
    endif()

elseif(WIN32)
    add_compile_options(-DWIN32 -D_WINDOWS)
endif()