# Then this is the mistake they have taken by spliting the whole project into SM+MM.
# Even they know something like SH::List coule be ke::List
# But why they didn't use STL?
# Do these guys thinking that they are much more talented then ISO?
# Oh yeah, just forget, dvander is in v8 dev team, that's why.
# Hard to say
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

if (NOT WIN32)
    target_compile_options(libudis86 PRIVATE -Wno-implicit-function-declaration)
endif()

add_library(asm STATIC 
    ${SOURCEMOD_PATH}/public/asm/asm.c
    ${SOURCEMOD_PATH}/public/asm/asm.h
)
target_link_libraries(asm PRIVATE libudis86)
target_include_directories(asm PUBLIC ${SOURCEMOD_PATH}/public)
if (MSVC)
    target_compile_options(asm PRIVATE /wd4018)
endif()

add_library(CDetour INTERFACE)
target_sources(CDetour INTERFACE
    ${SOURCEMOD_PATH}/public/CDetour/detourhelpers.h
    ${SOURCEMOD_PATH}/public/CDetour/detours.cpp
    ${SOURCEMOD_PATH}/public/CDetour/detours.h
    )
target_link_libraries(CDetour INTERFACE asm)