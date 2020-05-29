if(NOT CMAKE_BUILD_TYPE)
	set(CMAKE_BUILD_TYPE MinSizeRel)
endif()

cmake_minimum_required(VERSION 3.0)
project(kdnn C)

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -DKXVER=3")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -DKXVER=3")

set(MY_LIBRARY_NAME kdnn)
file(GLOB SRC_FILES src/*.c) # Do not add 'socket_pair.c' since it gets included
set_source_files_properties(${SRC_FILES} PROPERTIES LANGUAGE C)

include_directories (
    src/
    ${CMAKE_BINARY_DIR}
)

file(DOWNLOAD "https://github.com/KxSystems/kdb/raw/master/c/c/k.h" "${CMAKE_BINARY_DIR}/k.h" )

if (MSVC)
    set(INSTALL_SCRIPT "install.bat")
    file(DOWNLOAD "https://github.com/KxSystems/kdb/raw/master/w64/q.lib" "${CMAKE_BINARY_DIR}/q.lib" )
    set(LINK_LIBS "${CMAKE_BINARY_DIR}/q.lib")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /W3 /D WIN32_LEAN_AND_MEAN /D _CRT_SECURE_NO_WARNINGS /D _CRT_NONSTDC_NO_DEPRECATE /D _WINSOCK_DEPRECATED_NO_WARNINGS") 
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /W3 /D WIN32_LEAN_AND_MEAN /D _CRT_SECURE_NO_WARNINGS /D _CRT_NONSTDC_NO_DEPRECATE /D _WINSOCK_DEPRECATED_NO_WARNINGS")
else()
    set(INSTALL_SCRIPT "install.sh")
    set(LINK_LIBS "")
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-strict-aliasing")
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wno-strict-aliasing")
endif()
    
add_library (${MY_LIBRARY_NAME} SHARED ${SRC_FILES})

IF(APPLE)
   set_target_properties(${MY_LIBRARY_NAME} PROPERTIES LINK_FLAGS "-undefined dynamic_lookup")
   set_target_properties(${MY_LIBRARY_NAME} PROPERTIES SUFFIX .so)
   set(OSFLAG m)
elseif(WIN32)
   set(OSFLAG w)
else()
   set(OSFLAG l)
endif()

set_target_properties(${MY_LIBRARY_NAME} PROPERTIES PREFIX "")

# Minimum build/install move binary and q-script to $QHOME & $QHOME/<QARCH>
install(TARGETS ${MY_LIBRARY_NAME} DESTINATION "$ENV{QHOME}/${OSFLAG}64/" CONFIGURATIONS MinSizeRel)

install(TARGETS ${MY_LIBRARY_NAME} DESTINATION ${PROJECT_BINARY_DIR}/kdnn/lib CONFIGURATIONS Release)
install(FILES ${INSTALL_SCRIPT} DESTINATION ${PROJECT_BINARY_DIR}/kdnn/ CONFIGURATIONS Release)

