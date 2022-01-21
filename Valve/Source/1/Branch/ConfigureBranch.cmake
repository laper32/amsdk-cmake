#
# Configuration instruction:
#
# 1. For all SDK export, you MUST export the name as: source1_sdk_wrapper, and includes everything what we needed to BUILD!
# 2. Check CSGO/ as example, for you to build other engine branches.
#
# Have fun!

# Different SDK may have Different includes
if (HL2SDK_ENGINE_NAME MATCHES "dota")
    message(FATAL_ERROR "Not provided.")
elseif (HL2SDK_ENGINE_NAME MATCHES "csgo")
    include(${CMAKE_CURRENT_LIST_DIR}/CSGO/CSGO.cmake)
elseif (HL2SDK_ENGINE_NAME MATCHES "doi")
elseif (HL2SDK_ENGINE_NAME MATCHES "insurgency")
elseif (HL2SDK_ENGINE_NAME MATCHES "blade")
elseif (HL2SDK_ENGINE_NAME MATCHES "portal2")
elseif (HL2SDK_ENGINE_NAME MATCHES "swarm")
elseif (HL2SDK_ENGINE_NAME MATCHES "l4d2")
elseif (HL2SDK_ENGINE_NAME MATCHES "contagion")
elseif (HL2SDK_ENGINE_NAME MATCHES "nd")
elseif (HL2SDK_ENGINE_NAME MATCHES "l4d")
elseif (HL2SDK_ENGINE_NAME MATCHES "tf2")
elseif (HL2SDK_ENGINE_NAME MATCHES "bms")
elseif (HL2SDK_ENGINE_NAME MATCHES "sdk2013")
elseif (HL2SDK_ENGINE_NAME MATCHES "dods")
elseif (HL2SDK_ENGINE_NAME MATCHES "hl2dm")
elseif (HL2SDK_ENGINE_NAME MATCHES "css")
elseif (HL2SDK_ENGINE_NAME MATCHES "eye")
elseif (HL2SDK_ENGINE_NAME MATCHES "bgt")
elseif (HL2SDK_ENGINE_NAME MATCHES "ep2")
elseif (HL2SDK_ENGINE_NAME MATCHES "darkm")
elseif (HL2SDK_ENGINE_NAME MATCHES "ep1")
else()
    message(FATAL_ERROR "Unknown engine version found: \"${HL2SDK_ENGINE_NAME}\"")
endif()