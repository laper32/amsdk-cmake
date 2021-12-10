# In CMakeLists.txt always include this phrase first!
# include(amsdk-cmake/Configure.cmake)
# I will show an example to you
if (SOURCE2)
else()
    include(${CMAKE_CURRENT_LIST_DIR}/Source1/ConfigureSource1.cmake)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/AlliedModders/AlliedModders.cmake)

add_library(smsdk_ext INTERFACE)
target_sources(smsdk_ext INTERFACE ${SOURCEMOD_PATH}/public/smsdk_ext.cpp)
target_compile_definitions(smsdk_ext INTERFACE -DSDK_EXPORTS -DSOURCEMOD_BUILD -DSOURCE_ENGINE=${HL2SDK_ENGINE_VERSION})
target_link_libraries(smsdk_ext INTERFACE smsdk tier0 tier1 mathlib vstdlib interfaces mmsdk)

add_library(amsdk INTERFACE)
target_link_libraries(amsdk INTERFACE smsdk_ext)
target_link_libraries(amsdk INTERFACE CDetour hl2sdk_protobuf_csgo)