add_library(mmsdk INTERFACE)
target_include_directories(mmsdk INTERFACE
    ${METAMOD_SOURCE_PATH}/core
    ${METAMOD_SOURCE_PATH}/core/sourcehook
)