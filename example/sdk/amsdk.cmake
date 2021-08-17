#[[
#   SourceMod extension development build script, CMake version.
#   
#   Copyright (c) 2020-Now laper32, MoeMod, and all contributors, all rights reserved.
#   
#   This script is used for CMake build, which may useful for those people 
#   who are perferring using CMake to compile extensions.
#   
#   You have been assumed that you have enough knowledge about how to use CMake, 
#   and how to use CMake to build files. 
#   If you do not really know how to use it, please see these projects for 
#   referencing:
#       z4d - https://github.com/MoeMod/z4d
#   
#   This program is free software; you can redistribute it and/or modify it under
#   the terms of the GNU General Public License, version 3.0, as published by the
#   Free Software Foundation.
#   
#   This program is distributed in the hope that it will be useful, but WITHOUT
#   ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#   FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#   details.
#
#   You should have received a copy of the GNU General Public License along with
#   this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   As a special exception, AlliedModders LLC gives you permission to link the
#   code of this program (as well as its derivative works) to "Half-Life 2," the
#   "Source Engine," the "SourcePawn JIT," and any Game MODs that run on software
#   by the Valve Corporation.  You must obey the GNU General Public License in
#   all respects for all other code used.  Additionally, AlliedModders LLC grants
#   this exception to all derivative works.  AlliedModders LLC defines further
#   exceptions, found in LICENSE.txt (as of this writing, version JULY-31-2007),
#   or <http://www.sourcemod.net/license.php>.
#]]

# You should, and always should, configure HL2SDK_PATH, METAMOD_SOURCE_PATH, and SOURCEMOD_PATH by your own.
set(HL2SDK_PATH "${CMAKE_SOURCE_DIR}/sdk/hl2sdk-csgo" CACHE PATH "Path to hl2sdk-csgo")
set(SOURCEMOD_PATH "${CMAKE_SOURCE_DIR}/sdk/sourcemod" CACHE PATH "Path to sourcemod")
set(METAMOD_SOURCE_PATH "${CMAKE_SOURCE_DIR}/sdk/metamod-source" CACHE PATH "Path to sourcemm")
set(HL2SDK_ENGINE_BRANCH "CSGO" CACHE STRING "Specific engine branch for further configuration.")
set(TARGET_ARCH "x86" CACHE STRING "(Only works for non-windows for now) Specific platform for target build, for non-windows, aka, Linux, and Mac.")
set(ENABLE_OPTIMIZATION OFF "Whether enable optimization (ON/OFF)")

# Each engine version generally contains differ include files.
if (HL2SDK_ENGINE_BRANCH MATCHES "CSGO")
    set(HL2SDK_ENGINE_VERSION 12 FORCE)
# Hey you!
# Help me for further configuration!
# For specific engine!
#elseif(HL2SDK_ENGINE_BRANCH MATCHES "SpecificEngineVersion")
else()
    message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
endif()

# We are now using C++20
# So that by default, I will fill in with it
# You can modify it by yourself
set(CMAKE_CXX_STANDARD 20)

# MSVC specific
if (MSVC)
    add_compile_options(/wd4091 /wd4819 /wd4828 /wd5033 /permissive- /utf-8)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS=1)
else(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
    add_compile_options(-Wno-register)
endif()

# For non-windows
if (NOT WIN32)
    if (TARGET_ARCH MATCHES "x86_64")
        set(HL2SDK_64BIT ON)
        add_compile_options(-DPLATFORM_64BITS=1 -DX64BITS=1)
        message(STATUS "Building for 64 Bit")
    elseif (TARGET_ARCH MATCHES "x86")
        set(HL2SDK_64BIT OFF)
        message(STATUS "Building for 32 Bit")
    else()
        message(FATAL_ERROR "Unknown target arch")
    endif()
endif()

# Thought: Let CMAKE_SYSTEM_NAME -> TARGET_SYSTEM_NAME
# For someone who is using Mac but want to build .so for linux
# Because that Mac and Linux are similar, for mostly.
if(CMAKE_SYSTEM_NAME MATCHES "Darwin")
    message(STATUS "Are you really sure that you want to build extension on Mac?")
    message(STATUS "We will make a simple configuration for you, but not expected to work.")
    message(STATUS "You have been warned.")
    
    set(OSX ON)
    add_compile_options(-DOSX -D_OSX)
    set(HL2SDK_LIB_STATIC_EXT ".a")
    set(HL2SDK_LIB_SHARED_EXT ".dylib")
    set(HL2SDK_LIB_PREFIX "lib") # [lib]xxxxxx[.a, .so]

    # CSGO Specific
    if (HL2SDK_ENGINE_VERSION EQUAL 12)
        if (HL2SDK_64BIT)
            set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/osx64)
            set(HL2SDK_LIB_STATIC_SUFFIX "")
        else()
            message(FATAL_ERROR "Mac build now only supports x86_64")
            message(FATAL_ERROR "Check AMBuildScript of SourceMod, then you can know that why I do so.")
        endif()
    # =======================================================================================
    # Hey you there!
    # Help us filling in the <> for specific HL2SDK_ENGINE_VERSION to COMPLETE THE WHOLE SCRIPT
    # elseif (HL2SDK_ENGINE_VERSION EQUAL <>)
    # For example:
    # elseif (HL2SDK_ENGINE_VERSION EQUAL 1) # The specific version ID
    #       set(...) # Set things what you need
    # =======================================================================================
    else()
        message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
    endif()
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(LINUX ON)
    add_compile_options(-DLINUX -D_LINUX)
    set(HL2SDK_LIB_STATIC_EXT ".a")
    set(HL2SDK_LIB_SHARED_EXT ".so")
    set(HL2SDK_LIB_PREFIX "lib")

    if (HL2SDK_ENGINE_VERSION EQUAL 12)
        if (HL2SDK_64BIT)
            set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/linux64)
            set(HL2SDK_LIB_STATIC_SUFFIX "")
        else()
            set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/linux)
            set(HL2SDK_LIB_STATIC_SUFFIX "_i486")
        endif()
    # =======================================================================================
    # Hey you there!
    # Help us filling in the <> for specific HL2SDK_ENGINE_VERSION to COMPLETE THE WHOLE SCRIPT
    # elseif (HL2SDK_ENGINE_VERSION EQUAL <>)
    # For example:
    # elseif (HL2SDK_ENGINE_VERSION EQUAL 1) # The specific version ID
    #       set(...) # Set things what you need
    # =======================================================================================
    else()
        message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
    endif()
elseif(WIN32)
    set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/public)
    set(HL2SDK_LIB_STATIC_EXT ".lib")
    set(HL2SDK_LIB_SHARED_EXT ".dll")
    set(HL2SDK_LIB_STATIC_SUFFIX "")
# If have WIN64 then do further things
endif()

link_directories(${HL2SDK_LIB_DIR})

if(MSVC)
    add_compile_options(-DCOMPILER_MSVC)
    if(HL2SDK_64BIT)
        add_compile_options(-DCOMPILER_MSVC64)
     else()
        add_compile_options(-DCOMPILER_MSVC32)
     endif()
else()
    # GNUC
    add_compile_options(-DCOMPILER_GCC) ## clang or gcc
endif()

# for mingw
if(MINGW)
    add_compile_options(
            -Dmalloc_usable_size=_msize
            -DUSE_STDC_FOR_SIMD=1
    )
    add_compile_options(-fpermissive)
endif()

# Basic compile options
if (NOT WIN32)
    set(POSIX ON)
    
    add_compile_options(
        -DVPROF_LEVEL=1 -DSWDS -D_finite=finite -Dstricmp=strcasecmp -D_stricmp=strcasecmp
        -D_strnicmp=strncasecmp -Dstrnicmp=strncasecmp -D_vsnprintf=vsnprintf -D_alloca=alloca -Dstrcmpi=strcasecmp
        -Wno-narrowing -Wno-register
        )

    if (ENABLE_OPTIMIZATION)
        add_compile_options(-O3)
    endif()
endif()

if(POSIX)
    add_compile_options(-DPOSIX)
endif()

# Compliation flag is still incomplete
# HELP: Clang
if(MSVC)
    set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")
    add_compile_options(/wd4819 /wd4828 /wd5033 /permissive- /utf-8)
    add_compile_definitions(_CRT_SECURE_NO_WARNINGS=1)
elseif(${CMAKE_CXX_COMPILER_ID} MATCHES "Clang")
    add_compile_options(-Wno-implicit-int-float-conversion -Wno-deprecated-volatile -Wno-deprecated-register -Wno-deprecated
                        -Wno-inconsistent-missing-override -Wno-delete-non-virtual-dtor -Wno-implicit-exception-spec-mismatch
                        -Wno-sometimes-uninitialized
    )
elseif(${CMAKE_CXX_COMPILER_ID} MATCHES "GNU")
    add_compile_options(-Wno-volatile -fno-exceptions -fno-threadsafe-statics -Wno-unused-result -Wno-non-virtual-dtor
                        -Wno-overloaded-virtual -fvisibility-inlines-hidden -pipe -fno-strict-aliasing -Wall -Wno-unused
                        -Wno-switch -Wno-array-bounds -msse -fvisibility=hidden -mfpmath=sse
    )
    if (NOT HL2SDK_64BIT)
        add_compile_options(-m32)
        set(CMAKE_SHARED_LINKER_FLAGS  "${CMAKE_SHARED_LINKER_FLAGS} -m32")
    else()
        add_compile_options(-fPIC)
    endif()
endif()

add_library(tier0 INTERFACE)
# Differ SDK may have differ includes
if (HL2SDK_ENGINE_VERSION EQUAL 12)
    if (WIN32)
        target_include_directories(tier0 INTERFACE
            ${HL2SDK_PATH}/public
            ${HL2SDK_PATH}/public/tier0
            ${CMAKE_CURRENT_LIST_DIR}/wrapper/msvc
        )
    target_link_libraries(tier0 INTERFACE tier0${HL2SDK_LIB_STATIC_SUFFIX}${HL2SDK_LIB_STATIC_EXT})
    else()
        target_include_directories(tier0 INTERFACE
            ${HL2SDK_PATH}/public
            ${HL2SDK_PATH}/public/tier0
        )
        if (HL2SDK_64BIT)
            target_link_libraries(tier0 INTERFACE ${HL2SDK_LIB_PREFIX}tier0_client${HL2SDK_LIB_SHARED_EXT})
        else()
            target_link_libraries(tier0 INTERFACE ${HL2SDK_LIB_PREFIX}tier0${HL2SDK_LIB_SHARED_EXT})
        endif()
    endif()
else()
    message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
endif()

if (HL2SDK_ENGINE_VERSION EQUAL 12)
    add_library(tier1 STATIC
            ${HL2SDK_PATH}/tier1/bitbuf.cpp
            ${HL2SDK_PATH}/tier1/byteswap.cpp
            ${HL2SDK_PATH}/tier1/characterset.cpp
            ${HL2SDK_PATH}/tier1/checksum_crc.cpp
            ${HL2SDK_PATH}/tier1/checksum_md5.cpp
            ${HL2SDK_PATH}/tier1/commandbuffer.cpp
            ${HL2SDK_PATH}/tier1/convar.cpp
            ${HL2SDK_PATH}/tier1/datamanager.cpp
            ${HL2SDK_PATH}/tier1/diff.cpp
            ${HL2SDK_PATH}/tier1/generichash.cpp
            ${HL2SDK_PATH}/tier1/interface.cpp
            ${HL2SDK_PATH}/tier1/KeyValues.cpp
            ${HL2SDK_PATH}/tier1/mempool.cpp
            ${HL2SDK_PATH}/tier1/memstack.cpp
            ${HL2SDK_PATH}/tier1/NetAdr.cpp
            ${HL2SDK_PATH}/tier1/newbitbuf.cpp
            ${HL2SDK_PATH}/tier1/processor_detect.cpp
            ${HL2SDK_PATH}/tier1/rangecheckedvar.cpp
            ${HL2SDK_PATH}/tier1/stringpool.cpp
            ${HL2SDK_PATH}/tier1/strtools.cpp
            ${HL2SDK_PATH}/tier1/tier1.cpp
            ${HL2SDK_PATH}/tier1/undiff.cpp
            ${HL2SDK_PATH}/tier1/uniqueid.cpp
            ${HL2SDK_PATH}/tier1/utlbuffer.cpp
            ${HL2SDK_PATH}/tier1/utlbufferutil.cpp
            ${HL2SDK_PATH}/tier1/utlstring.cpp
            ${HL2SDK_PATH}/tier1/utlsymbol.cpp
            )
    target_link_libraries(tier1 tier0)
    target_include_directories(tier1 PUBLIC
            ${HL2SDK_PATH}/public
            ${HL2SDK_PATH}/public/tier1
            )
# =======================================================================================
# Hey you there!
# Help us filling in the <> for specific HL2SDK_ENGINE_VERSION to COMPLETE THE WHOLE SCRIPT
# elseif (HL2SDK_ENGINE_VERSION EQUAL <>)
# For example:
# elseif (HL2SDK_ENGINE_VERSION EQUAL 1) # The specific version ID
#       set(...) # Set things what you need
# =======================================================================================
else()
    message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
endif()

if (HL2SDK_ENGINE_VERSION EQUAL 12)
    add_library(mathlib STATIC
            ${HL2SDK_PATH}/mathlib/anorms.cpp
            ${HL2SDK_PATH}/mathlib/bumpvects.cpp
            ${HL2SDK_PATH}/mathlib/color_conversion.cpp
            ${HL2SDK_PATH}/mathlib/halton.cpp
            ${HL2SDK_PATH}/mathlib/IceKey.cpp
            ${HL2SDK_PATH}/mathlib/imagequant.cpp
            ${HL2SDK_PATH}/mathlib/lightdesc.cpp
            ${HL2SDK_PATH}/mathlib/mathlib_base.cpp
            ${HL2SDK_PATH}/mathlib/polyhedron.cpp
            ${HL2SDK_PATH}/mathlib/powsse.cpp
            ${HL2SDK_PATH}/mathlib/quantize.cpp
            ${HL2SDK_PATH}/mathlib/randsse.cpp
            ${HL2SDK_PATH}/mathlib/simdvectormatrix.cpp
            ${HL2SDK_PATH}/mathlib/sparse_convolution_noise.cpp
            ${HL2SDK_PATH}/mathlib/sse.cpp
            ${HL2SDK_PATH}/mathlib/sseconst.cpp
            ${HL2SDK_PATH}/mathlib/ssenoise.cpp
            ${HL2SDK_PATH}/mathlib/vector.cpp
            ${HL2SDK_PATH}/mathlib/vmatrix.cpp
            )
    if(NOT MSVC)
        target_compile_options(mathlib PRIVATE -Wno-c++11-narrowing)
    endif()
    target_link_libraries(mathlib PUBLIC tier0 tier1)
    target_include_directories(mathlib PUBLIC ${HL2SDK_PATH}/public/mathlib)
# =======================================================================================
# Hey you there!
# Help us filling in the <> for specific HL2SDK_ENGINE_VERSION to COMPLETE THE WHOLE SCRIPT
# elseif (HL2SDK_ENGINE_VERSION EQUAL <>)
# For example:
# elseif (HL2SDK_ENGINE_VERSION EQUAL 1) # The specific version ID
#       set(...) # Set things what you need
# =======================================================================================
else()
    message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
endif()



add_library(vstdlib INTERFACE)
if (HL2SDK_ENGINE_VERSION EQUAL 12)
    target_include_directories(vstdlib INTERFACE
        ${HL2SDK_PATH}/public
        ${HL2SD_PATH}/public/vstdlib
    )
    if (WIN32)
        target_link_libraries(vstdlib INTERFACE vstdlib${HL2SDK_LIB_STATIC_SUFFIX}${HL2SDK_LIB_STATIC_EXT})
    else()
        if (HL2SDK_64BIT)
            target_link_libraries(vstdlib INTERFACE ${HL2SDK_LIB_PREFIX}vstdlib_client${HL2SDK_LIB_SHARED_EXT})
        else()
            target_link_libraries(vstdlib INTERFACE ${HL2SDK_LIB_PREFIX}vstdlib${HL2SDK_LIB_SHARED_EXT})
        endif()
    endif()
else()
    message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_BRANCH}\"")
endif()

add_library(interfaces STATIC
        ${HL2SDK_PATH}/interfaces/interfaces.cpp
        )
target_include_directories(interfaces PUBLIC
        ${HL2SDK_PATH}/public
        ${HL2SDK_PATH}/public/interfaces
        )

if (HL2SDK_ENGINE_VERSION EQUAL 12)

    # brew install protobuf
    # vcpkg install protobuf
    #find_package(Protobuf REQUIRED)
    #include_directories(${Protobuf_INCLUDE_DIRS})
    #include_directories(${CMAKE_CURRENT_BINARY_DIR})
    # hack for msvc who can't find google/protobuf/*
    #set(Protobuf_IMPORT_DIRS ${Protobuf_IMPORT_DIRS} ${Protobuf_INCLUDE_DIRS})
    #protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS
    #        "${HL2SDK_PATH}/public/engine/protobuf/netmessages.proto"
    #        "${HL2SDK_PATH}/public/game/shared/csgo/protobuf/cstrike15_usermessages.proto"
    #        )
    set(PROTO_SRCS ${HL2SDK_PATH}/public/engine/protobuf/netmessages.pb.cc ${HL2SDK_PATH}/public/game/shared/csgo/protobuf/cstrike15_usermessages.pb.cc)
    set(PROTO_HDRS ${HL2SDK_PATH}/public/engine/protobuf/netmessages.pb.h ${HL2SDK_PATH}/public/game/shared/csgo/protobuf/cstrike15_usermessages.pb.h)

    add_library(hl2sdk_protobuf STATIC 
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/atomicops_internals_x86_gcc.cc         
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/atomicops_internals_x86_msvc.cc        
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/common.cc                              
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/once.cc                                
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/stringprintf.cc                        
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/extension_set.cc                             
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/generated_message_util.cc                    
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/message_lite.cc                              
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/repeated_field.cc                            
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/wire_format_lite.cc                          
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/coded_stream.cc                           
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/zero_copy_stream.cc                       
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/zero_copy_stream_impl_lite.cc
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/strutil.cc                             
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/substitute.cc                          
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/stubs/structurally_valid.cc                  
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/descriptor.cc                                
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/descriptor.pb.cc                             
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/descriptor_database.cc                       
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/dynamic_message.cc                           
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/extension_set_heavy.cc                       
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/generated_message_reflection.cc              
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/message.cc                                   
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/reflection_ops.cc                            
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/service.cc                                   
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/text_format.cc                               
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/unknown_field_set.cc                         
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/wire_format.cc                               
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/gzip_stream.cc                            
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/printer.cc                                
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/tokenizer.cc                              
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/io/zero_copy_stream_impl.cc                  
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/compiler/importer.cc                         
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src/google/protobuf/compiler/parser.cc
    )
    target_include_directories(hl2sdk_protobuf PUBLIC 
        ${HL2SDK_PATH}/common/protobuf-2.5.0/src
        )
    target_include_directories(hl2sdk_protobuf PRIVATE 
        ${CMAKE_CURRENT_LIST_DIR}/wrapper/protobuf
        )

    add_library(hl2sdk_protobuf_csgo STATIC ${PROTO_SRCS} ${PROTO_HDRS})
    target_include_directories(hl2sdk_protobuf_csgo PUBLIC 
        ${HL2SDK_PATH}/public/engine/protobuf
        ${HL2SDK_PATH}/public/game/shared/csgo/protobuf
        )
    target_link_libraries(hl2sdk_protobuf_csgo PUBLIC hl2sdk_protobuf)
endif()

add_library(amtl INTERFACE)
target_include_directories(amtl INTERFACE
        ${SOURCEMOD_PATH}/public/amtl
        ${SOURCEMOD_PATH}/public/amtl/amtl
        )

add_library(smsdk INTERFACE)
target_include_directories(smsdk INTERFACE
        ${SOURCEMOD_PATH}/core
        ${SOURCEMOD_PATH}/public
        ${SOURCEMOD_PATH}/sourcepawn/include
        )
target_link_libraries(smsdk INTERFACE amtl)

add_library(mmsdk INTERFACE)
target_include_directories(mmsdk INTERFACE
        ${METAMOD_SOURCE_PATH}/core
        ${METAMOD_SOURCE_PATH}/core/sourcehook
        )

add_library(smsdk_ext INTERFACE)
target_sources(smsdk_ext INTERFACE ${SOURCEMOD_PATH}/public/smsdk_ext.cpp)
target_compile_definitions(smsdk_ext INTERFACE 
        -DSE_EPISODEONE=1 -DSE_DARKMESSIAH=2 -DSE_ORANGEBOX=3 -DSE_BLOODYGOODTIME=4 -DSE_EYE=5 -DSE_CSS=6 -DSE_ORANGEBOXVALVE=7 -DSE_LEFT4DEAD=8 -DSE_LEFT4DEAD2=9 -DSE_ALIENSWARM=10 -DSE_PORTAL2=11 -DSE_CSGO=12)
target_compile_definitions(smsdk_ext INTERFACE
        -DSDK_EXPORTS -DSOURCEMOD_BUILD -DSOURCE_ENGINE=${HL2SDK_ENGINE_VERSION})
target_link_libraries(smsdk_ext INTERFACE smsdk tier0 tier1 mathlib vstdlib interfaces mmsdk)

add_library(libudis86 STATIC 
    ${SOURCEMOD_PATH}/public/libudis86/decode.c
    ${SOURCEMOD_PATH}/public/libudis86/decode.h
    ${SOURCEMOD_PATH}/public/libudis86/extern.h
    ${SOURCEMOD_PATH}/public/libudis86/itab.c
    ${SOURCEMOD_PATH}/public/libudis86/itab.h
    ${SOURCEMOD_PATH}/public/libudis86/syn.c
    ${SOURCEMOD_PATH}/public/libudis86/syn.h
    ${SOURCEMOD_PATH}/public/libudis86/syn-att.c
    ${SOURCEMOD_PATH}/public/libudis86/syn-intel.c
    ${SOURCEMOD_PATH}/public/libudis86/types.h
    ${SOURCEMOD_PATH}/public/libudis86/udint.h
    ${SOURCEMOD_PATH}/public/libudis86/udis86.c
    ${SOURCEMOD_PATH}/public/libudis86/udis86.h
)
target_include_directories(libudis86 PUBLIC ${SOURCEMOD_PATH}/public)

add_library(asm STATIC 
    ${SOURCEMOD_PATH}/public/asm/asm.c
    ${SOURCEMOD_PATH}/public/asm/asm.h
)
target_link_libraries(asm PRIVATE libudis86)
target_include_directories(asm PUBLIC ${SOURCEMOD_PATH}/public)

include(CheckIncludeFile)
check_include_file(stdint.h HAVE_STDINT_H)


add_library(CDetour INTERFACE)
target_sources(CDetour INTERFACE 
    ${SOURCEMOD_PATH}/public/CDetour/detourhelpers.h
    ${SOURCEMOD_PATH}/public/CDetour/detours.cpp
    ${SOURCEMOD_PATH}/public/CDetour/detours.h
    )
if(HAVE_STDINT_H)
    target_compile_definitions(smsdk_ext INTERFACE -DHAVE_STDINT_H=1)
endif()
target_link_libraries(CDetour INTERFACE asm)
