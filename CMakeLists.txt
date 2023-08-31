cmake_minimum_required(VERSION 3.15)
cmake_policy(SET CMP0091 NEW)

project(pawn-redis)

list(APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/lib/cmake-modules")

# required for fmt library
# set(CMAKE_CXX_STANDARD 11)

if (MSVC)
	add_link_options(/INCREMENTAL:NO /NODEFAULTLIB:MSVCRT)
	set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
	set(MSVC_RUNTIME_LIBRARY_CONFIG "/MD")
elseif(UNIX)
	#set(CMAKE_CXX_FLAGS "-m32 -fvisibility=hidden -std=c++14")
	#set(CMAKE_C_FLAGS "-m32 -fvisibility=hidden")
	#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32 -std=gnu++98 -pedantic -fvisibility=hidden")
	#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32 -std=gnu89 -pedantic -fvisibility=hidden")
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -m32 -fvisibility=hidden")
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -m32 -fvisibility=hidden")
	set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS OFF)

	# link runtime statically
	set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
	add_link_options(
		"-static-libgcc"
		"-static-libstdc++"
	)
	set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-rpath='$ORIGIN'")
endif()

# removes the sprintf warnings from plugin-natives
add_definitions(-D_CRT_SECURE_NO_WARNINGS)

set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build/plugins)
set(LIBRARY_OUTPUT_PATH ${CMAKE_SOURCE_DIR}/build/plugins)
#set(CMAKE_BUILD_TYPE Release)
set(BUILD_SHARED_LIBS 0)
set(LOGGING_ENABLED OFF)

set(BUILD_EXAMPLES OFF)
set(BUILD_TESTS OFF)

include_directories(lib/cpp_redis/tacopie/includes)
add_subdirectory(lib/cpp_redis)
include_directories(lib/cpp_redis/includes)

add_subdirectory(src)
