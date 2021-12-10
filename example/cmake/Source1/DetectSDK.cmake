# Ref: AMBuildScript
#[[
PossibleSDKs = {
    #					    sdk,				 ext,		    aDef,		name,			platform,		    dir
    'episode1':		SDK('HL2SDK',			    '2.ep1',		'1',	'EPISODEONE',		WinLinux,		'episode1'),
    'darkm':		SDK('HL2SDK-DARKM',		    '2.darkm',		'2',	'DARKMESSIAH',		WinOnly,		'darkm'),
    'ep2':			SDK('HL2SDK-OB',			'2.ep2',		'3',	'ORANGEBOX',		WinLinux,		'orangebox'),
    'bgt':			SDK('HL2SDK-BGT',		    '2.bgt',		'4',	'BLOODYGOODTIME',	WinOnly,		'bgt'),
    'eye':			SDK('HL2SDK-EYE',		    '2.eye',		'5',	'EYE',				WinOnly,		'eye'),
    'css':			SDK('HL2SDK-CSS',		    '2.css',		'6',	'CSS',				WinLinuxMac,	'css'),
    'hl2dm':		SDK('HL2SDK-HL2DM',		    '2.hl2dm',		'7',	'HL2DM',			WinLinuxMac,	'hl2dm'),
    'dods':			SDK('HL2SDK-DODS',		    '2.dods',		'8',	'DODS',				WinLinuxMac,	'dods'),
    'sdk2013':		SDK('HL2SDK-2013',		    '2.sdk2013',	'9',	'SDK2013',			WinLinuxMac,	'sdk2013'),
    'bms':			SDK('HL2SDK-BMS',		    '2.bms',		'10',	'BMS',				WinLinux,		'bms'),
    'tf2':			SDK('HL2SDK-TF2',		    '2.tf2',		'11',	'TF2',				WinLinuxMac,	'tf2'),
    'l4d':			SDK('HL2SDK-L4D',		    '2.l4d',		'12',	'LEFT4DEAD',		WinLinuxMac,	'l4d'),
    'nucleardawn':	SDK('HL2SDK-ND',		    '2.nd',			'13',	'NUCLEARDAWN',		WinLinuxMac,	'nucleardawn'),
    'contagion':	SDK('HL2SDK-CONTAGION',	    '2.contagion',	'14',	'CONTAGION',		WinOnly,		'contagion'),
    'l4d2':			SDK('HL2SDK-L4D2',		    '2.l4d2',		'15',	'LEFT4DEAD2',		WinLinuxMac,	'l4d2'),
    'swarm':		SDK('HL2SDK-SWARM',		    '2.swarm',		'16',	'ALIENSWARM',		WinOnly,		'swarm'),
    'portal2':		SDK('HL2SDK-PORTAL2',	    '2.portal2',	'17',	'PORTAL2',			[],				'portal2'),
    'blade':		SDK('HL2SDK-BLADE',		    '2.blade',		'18',	'BLADE',			Blade,			'blade'),
    'insurgency':	SDK('HL2SDK-INSURGENCY',    '2.insurgency', '19',	'INSURGENCY',		Insurgency,		'insurgency'),
    'doi':			SDK('HL2SDK-DOI',		    '2.doi',		'20',	'DOI',				WinLinuxMac,	'doi'),
    'csgo':			SDK('HL2SDK-CSGO',		    '2.csgo',		'21',	'CSGO',				CSGO,			'csgo'),
    'dota':			SDK('HL2SDK-DOTA',		    '2.dota',		'22',	'DOTA',				[],				'dota'),
    'mock':         SDK('HL2SDK-MOCK',          '2.mock',       '999',  'MOCK',             Mock,           'mock'),
}
]]

#
# Purpose: Configure source engine definitions.
#

#
# Purpose: Configure Source 1 engine branch.
# Available options: episode1, darkm, ep2, bgt, eye, css, hl2dm, dods, sdk2013, bms, tf2, l4d,
#               nucleardawn, contagion, l4d2, swarm, portal2, blade, insurgency, doi, csgo, dota, mock
# Note: The variable has also converted to lower.
#
string(TOLOWER "${HL2SDK_ENGINE_NAME}" HL2SDK_ENGINE_NAME)
set_property(CACHE HL2SDK_ENGINE_NAME PROPERTY STRINGS "episode1;darkm;orangebox;bgt;eye;css;hl2dm;dods;sdk2013;bms;tf2;l4d;nucleardawn;contagion;l4d2;swarm;portal2;blade;insurgency;doi;csgo;dota;mock")
add_definitions(-DSE_EPISODE1=1     -DSE_DARKM=2        -DSE_EP2=3              -DSE_BGT=4
                -DSE_EYE=5          -DSE_CSS=6          -DSE_HL2DM=7            -DSE_DODS=8
                -DSE_SDK2013=9      -DSE_BMS=10         -DSE_TF2=11             -DSE_L4D=12
                -DSE_NUCLEARDAWN=13 -DSE_CONTAGION=14   -DSE_L4D2=15            -DSE_SWARM=16
                -DSE_PORTAL2=17     -DSE_BLADE=18       -DSE_INSURGENCY=19      -DSE_DOI=20
                -DSE_CSGO=21        -DSE_DOTA=22        -DSE_MOCK=999
        )
set(HL2SDK_FOLDER "hl2sdk/${HL2SDK_ENGINE_NAME}")

#
# Purpose: Determine HL2SDK location
#
if (HL2SDK_ENGINE_NAME MATCHES "mock")
    message("Engine is under mock mode.")
    set(HL2SDK_ENGINE_VERSION 999 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "dota")
    message("Engine detected: DOTA")
    set(HL2SDK_ENGINE_VERSION 22 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "csgo")
    set(HL2SDK_ENGINE_VERSION 21 CACHE INTERNAL "Engine version")
    message("Engine detected: Counter-Strike: Global Offensive")
elseif (HL2SDK_ENGINE_NAME MATCHES "doi")
    message("Engine detected: Day of Infamy")
    set(HL2SDK_ENGINE_VERSION 20 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "insurgency")
    message("Engine detected: Insurgency")
    set(HL2SDK_ENGINE_VERSION 19 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "blade")
    message("Engine detected: Blade Symphony")
    set(HL2SDK_ENGINE_VERSION 18 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "portal2")
    message("Engine detected: Portal 2")
    set(HL2SDK_ENGINE_VERSION 17 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "swarm")
    message("Engine detected: Alien Swarm")
    set(HL2SDK_ENGINE_VERSION 16 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "l4d2")
    message("Engine detected: Left 4 Dead 2")
    set(HL2SDK_ENGINE_VERSION 15 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "contagion")
    message("Engine detected: Contagion")
    set(HL2SDK_ENGINE_VERSION 14 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "nd")
    message("Engine detected: Nuclear Dawn")
    set(HL2SDK_ENGINE_VERSION 13 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "l4d")
    message("Engine detected: Left 4 Dead")
    set(HL2SDK_ENGINE_VERSION 12 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "tf2")
    message("Engine detected: Team Fortress 2")
    set(HL2SDK_ENGINE_VERSION 11 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "bms")
    message("Engine detected: Black Mesa Multiplayer")
    set(HL2SDK_ENGINE_VERSION 10 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "sdk2013")
    message("Engine detected: Source SDK 2013")
    set(HL2SDK_ENGINE_VERSION  9 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "dods")
    message("Engine detected: Day of Defeat: Source")
    set(HL2SDK_ENGINE_VERSION  8 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "hl2dm")
    message("Engine detected: Half-Life 2 Deathmatch")
    set(HL2SDK_ENGINE_VERSION  7 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "css")
    message("Engine detected: Counter-Strike: Source")
    set(HL2SDK_ENGINE_VERSION  6 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "eye")
    message("Engine detected: E.Y.E Divine Cybermancy")
    set(HL2SDK_ENGINE_VERSION  5 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "bgt")
    message("Engine detected: Bloody Good Time")
    set(HL2SDK_ENGINE_VERSION  4 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "ep2")
    message("Engine detected: Orange Box")
    set(HL2SDK_ENGINE_VERSION  3 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "darkm")
    message("Engine detected: Dark Messiah")
    set(HL2SDK_ENGINE_VERSION  2 CACHE INTERNAL "Engine version")
elseif (HL2SDK_ENGINE_NAME MATCHES "ep1")
    message("Engine detected: Episode 1")
    set(HL2SDK_ENGINE_VERSION  1 CACHE INTERNAL "Engine version")
else ()
    message("Unknown engine version")
    set(HL2SDK_ENGINE_VERSION  0 CACHE INTERNAL "Engine version")
endif()

add_definitions(-DSOURCE_ENGINE=${HL2SDK_ENGINE_VERSION})

# But we need to configure with the case that: We are not using vendor.
# For someone who want to build with system pre-configured folder.
if (NOT SDK_USE_VENDOR)
    # Require: HL2SDK-${specific_engine_name}
    # Please follow this rule to preconfigure your SDK path.
    set(HL2SDK_ENVVAR "hl2sdk-${HL2SDK_ENGINE_NAME}")
    string(TOUPPER "${HL2SDK_ENVVAR}" HL2SDK_ENVVAR)

    # Then, here you are.
    if (DEFINED ENV{${HL2SDK_ENVVAR}})
        set(HL2SDK_PATH_STRING $ENV{${HL2SDK_ENVVAR}})
        string(REPLACE "\\" "/" HL2SDK_PATH_STRING "${HL2SDK_PATH_STRING}")
    else()
        message(FATAL_ERROR "You want to use environment variable but it does not exist. Check environment variable: ${HL2SDK_ENVVAR}")
    endif()
else()
    # And here we go.
    set(HL2SDK_PATH_STRING "${CMAKE_SOURCE_DIR}/${HL2SDK_FOLDER}")
endif()

# Everything is OK, now set it onto HL2SDK_PATH, and cache the file path
set(HL2SDK_PATH ${HL2SDK_PATH_STRING} CACHE PATH "Path to Half life 2 SDK" FORCE)

if (TARGET_ARCH MATCHES "x64")
    set(HL2SDK_64BIT ON)
elseif(TARGET_ARCH MATCHES "x86")
    set(HL2SDK_64BIT OFF)
else()
    message(FATAL_ERROR "Unsupported target architecture: ${TARGET_ARCH}")
endif()