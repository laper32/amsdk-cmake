#
# Purpose: Configure link library
#
if (CMAKE_SYSTEM_NAME MATCHES "Darwin")
    message(FATAL_ERROR "Sorry, we don't provide any support on MacOS: The arch of MacOS has been switched to ARM instead of x86, aka, we can't support it anymore.")
elseif(CMAKE_SYSTEM_NAME MATCHES "Linux")
    set(HL2SDK_LIB_STATIC_EXT ".a")
    set(HL2SDK_LIB_SHARED_EXT ".so")
    set(HL2SDK_LIB_PREFIX "lib")

    if (HL2SDK_64BIT)
        set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/linux64)
        set(HL2SDK_LIB_STATIC_SUFFIX "")
    else()
        set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/linux)
        set(HL2SDK_LIB_STATIC_SUFFIX "_i486")
    endif()
elseif(WIN32)
    set(HL2SDK_LIB_DIR ${HL2SDK_PATH}/lib/public)
    set(HL2SDK_LIB_STATIC_EXT ".lib")
    set(HL2SDK_LIB_SHARED_EXT ".dll")
    set(HL2SDK_LIB_STATIC_SUFFIX "")
    # If have WIN64 then do further things
endif()

link_directories(${HL2SDK_LIB_DIR})

#
# Purpose: Tier 0 library
#
add_library(tier0 INTERFACE)
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

#
# Purpose: Tier 1 library
#
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


#
# Purpose: Mathlib library
#
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
if (MSVC)
    target_compile_options(mathlib PRIVATE /wd4838)
else()
    target_compile_options(mathlib PRIVATE -Wno-c++11-narrowing)
endif()
target_link_libraries(mathlib PUBLIC tier0 tier1)
target_include_directories(mathlib PUBLIC ${HL2SDK_PATH}/public/mathlib)

#
# Purpose: vstdlib library
#
add_library(vstdlib INTERFACE)
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

#
# Purpose: Interfaces library
#
add_library(interfaces STATIC
        ${HL2SDK_PATH}/interfaces/interfaces.cpp
        )
target_include_directories(interfaces PUBLIC
        ${HL2SDK_PATH}/public
        ${HL2SDK_PATH}/public/interfaces
        )

#
# Purpose: Protobuf library
#

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
if (MSVC)
    target_compile_options(hl2sdk_protobuf PRIVATE /wd4018 /wd4996 /wd4244)
endif()
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
if(MSVC)
    target_compile_options(hl2sdk_protobuf_csgo PRIVATE /wd4996)
endif()
target_link_libraries(hl2sdk_protobuf_csgo PUBLIC hl2sdk_protobuf)

#
# Make an wrapper for activating the build
#
add_library(source1_sdk INTERFACE)
target_include_directories(source1_sdk INTERFACE
    ${HL2SDK_PATH}/public
    ${HL2SDK_PATH}/public/engine
    ${HL2SDK_PATH}/game
    ${HL2SDK_PATH}/public/game
    ${HL2SDK_PATH}/public/game/server
    ${HL2SDK_PATH}/public/game/shared
)
target_link_libraries(source1_sdk INTERFACE tier0 tier1 vstdlib mathlib interfaces hl2sdk_protobuf_csgo)