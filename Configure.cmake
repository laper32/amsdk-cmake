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
target_compile_definitions(smsdk_ext INTERFACE -DSDK_EXPORTS -DSOURCEMOD_BUILD)
target_link_libraries(smsdk_ext INTERFACE smsdk source1_sdk mmsdk CDetour)

add_library(amsdk INTERFACE)
target_link_libraries(amsdk INTERFACE smsdk_ext)
