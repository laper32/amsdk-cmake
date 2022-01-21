include(${CMAKE_CURRENT_LIST_DIR}/Global.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/CompileOption.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/AlliedModders/AlliedModders.cmake)

add_library(smsdk_ext INTERFACE)
target_sources(smsdk_ext INTERFACE ${SOURCEMOD_PATH}/public/smsdk_ext.cpp)
target_compile_definitions(smsdk_ext INTERFACE -DSDK_EXPORTS -DSOURCEMOD_BUILD)
target_link_libraries(smsdk_ext INTERFACE smsdk mmsdk CDetour)

if (USE_SDK)
	include(${CMAKE_CURRENT_LIST_DIR}/Valve/Source/SourceEngine.cmake)
	target_link_libraries(smsdk_ext INTERFACE smsdk_ext source_sdk)
endif()

add_library(amsdk INTERFACE)
target_link_libraries(amsdk INTERFACE smsdk_ext)




