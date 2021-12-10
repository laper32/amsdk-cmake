add_library(Example SHARED
    ${CMAKE_CURRENT_LIST_DIR}/extension.cpp
)

target_include_directories(Example PUBLIC
    ./
)

target_link_libraries(Example PUBLIC amsdk)
set_target_properties(Example PROPERTIES PREFIX "" SUFFIX ".ext.2.${HL2SDK_ENGINE_NAME}${HL2SDK_LIB_SHARED_EXT}")