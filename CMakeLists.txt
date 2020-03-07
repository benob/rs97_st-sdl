cmake_minimum_required(VERSION 3.10) # CMP0083 NEW

project(STSDL
  VERSION 0.3.0
  LANGUAGES C)

option(ASAN "Enable address sanitizer" ON)
option(UBSAN "Enable undefined behaviour sanitizer" ON)

if(CMAKE_BUILD_TYPE MATCHES "Release")

  # Enable link-time optimization if supported.
  include(CheckIPOSupported)
  check_ipo_supported(RESULT ipo_supported OUTPUT ipo_check_output)
  if(ipo_supported)
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
  else()
    message(WARNING "LTO is not supported: ${ipo_check_output}\n")
  endif()

  set(ASAN OFF)
  set(UBSAN OFF)
endif()

set(STSDL_SRCS
  font.c
  keyboard.c
  msg_queue.c
  st.c)

find_package(SDL REQUIRED)

add_library(st-preload SHARED st-preload.c)
target_include_directories(st-preload PRIVATE ${SDL_INCLUDE_DIR})
target_link_libraries(st-preload PRIVATE ${SDL_LIBRARY})

set(BIN_TARGET st)
add_executable(${BIN_TARGET} ${STSDL_SRCS})
set_target_properties(${BIN_TARGET} PROPERTIES
    C_STANDARD 99
    C_STANDARD_REQUIRED YES
    C_EXTENSIONS NO)

target_include_directories(${BIN_TARGET} PRIVATE ${SDL_INCLUDE_DIR})
target_link_libraries(${BIN_TARGET} PRIVATE ${SDL_LIBRARY} dl util st-preload)

if(TARGET_PLATFORM STREQUAL "retrofw")
  include(CMake/retrofw_defs.cmake)
elseif(TARGET_PLATFORM STREQUAL "rg350")
  include(CMake/rg350_defs.cmake)
endif()

foreach(
  def_name
  SCREEN_WIDTH
  SCREEN_HEIGHT
  ENABLE_LINE_DOUBLING
  AUTOSCALE
  TERMNAME
  KEY_UP
  KEY_DOWN
  KEY_LEFT
  KEY_RIGHT
  KEY_ENTER
  KEY_TOGGLE
  KEY_BACKSPACE
  KEY_SHIFT
  KEY_LOCATION
  KEY_ACTIVATE
  KEY_QUIT
  KEY_HELP
)
  if(DEFINED ${def_name})
    list(APPEND def_list ${def_name}=${${def_name}})
  endif()
endforeach(def_name)
target_compile_definitions(${BIN_TARGET} PRIVATE ${def_list})
target_compile_definitions(${BIN_TARGET} PRIVATE VERSION="${PROJECT_VERSION}")

if(ASAN)
target_compile_options(${BIN_TARGET} PUBLIC -fsanitize=address -fsanitize-recover=address)
target_link_libraries(${BIN_TARGET} PUBLIC -fsanitize=address -fsanitize-recover=address)
endif()

if(UBSAN)
target_compile_options(${BIN_TARGET} PUBLIC -fsanitize=undefined)
target_link_libraries(${BIN_TARGET} PUBLIC -fsanitize=undefined)
endif()

add_executable(sdl_test sdl_test.c)
target_include_directories(sdl_test PUBLIC ${SDL_INCLUDE_DIR})
target_link_libraries(sdl_test PRIVATE ${SDL_LIBRARY})
