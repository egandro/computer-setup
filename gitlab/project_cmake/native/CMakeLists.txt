cmake_minimum_required(VERSION 3.11.0)
project (hello)

IF(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    # rasberry pi floods warnings
    # idea from here - https://stackoverflow.com/questions/15100351/changing-cmake-cxx-flags-in-project
    SET ( CMAKE_CXX_FLAGS "-Wno-psabi" )
ENDIF()


include(FetchContent)

FetchContent_Declare(json
  GIT_REPOSITORY https://github.com/ArthurSonzogni/nlohmann_json_cmake_fetchcontent
  GIT_TAG v3.7.3)

FetchContent_GetProperties(json)
if(NOT json_POPULATED)
  FetchContent_Populate(json)
  add_subdirectory(${json_SOURCE_DIR} ${json_BINARY_DIR} EXCLUDE_FROM_ALL)
endif()

add_executable(hello helloworld.cpp)

target_link_libraries(hello nlohmann_json::nlohmann_json)
