# You don't want to use local folder.
if (NOT SM_USE_VENDOR)
    if (DEFINED ENV{"SOURCEMOD"})
        set(SOURCEMOD_PATH_STRING $ENV{"SOURCEMOD"})
    else()
        message(FATAL_ERROR "You want to use environment variable but it does not exist. Check environment variable: SOURCEMOD")
    endif()
else()
    # You can modify by your self.
    set(SOURCEMOD_PATH_STRING "${CMAKE_SOURCE_DIR}/sourcemod")
endif()

if (NOT MMS_USE_VENDOR)
    if (DEFINED ENV{"METAMOD-SOURCE"})
        set(METAMOD_SOURCE_PATH_STRING $ENV{"METAMOD-SOURCE"})
    else()
        message(FATAL_ERROR "You want to use environment variable but it does not exist. Check environment variable: METAMOD_SOURCE")
    endif()
else()
    set(METAMOD_SOURCE_PATH_STRING "${CMAKE_SOURCE_DIR}/metamod-source")
endif()

set(SOURCEMOD_PATH ${SOURCEMOD_PATH_STRING})
set(METAMOD_SOURCE_PATH ${METAMOD_SOURCE_PATH_STRING})

include(${CMAKE_CURRENT_LIST_DIR}/MetaMod.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/SourceMod.cmake)