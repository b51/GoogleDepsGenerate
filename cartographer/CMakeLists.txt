# Copyright 2016 The Cartographer Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 2.8.12)  # Ships with Ubuntu 14.04 (Trusty)

project(cartographer)

set(CARTOGRAPHER_MAJOR_VERSION 1)
set(CARTOGRAPHER_MINOR_VERSION 0)
set(CARTOGRAPHER_PATCH_VERSION 0)
set(CARTOGRAPHER_VERSION ${CARTOGRAPHER_MAJOR_VERSION}.${CARTOGRAPHER_MINOR_VERSION}.${CARTOGRAPHER_PATCH_VERSION})
set(CARTOGRAPHER_SOVERSION ${CARTOGRAPHER_MAJOR_VERSION}.${CARTOGRAPHER_MINOR_VERSION})

include("${PROJECT_SOURCE_DIR}/cartographer/cmake/functions.cmake")
google_initialize_cartographer_project()

find_package(Boost REQUIRED COMPONENTS iostreams)
find_package(Ceres REQUIRED COMPONENTS SparseLinearAlgebraLibrary PATHS "${CERES_INSTALL_DIR}")
find_package(Eigen3 REQUIRED)
find_package(LuaGoogle REQUIRED)
find_package(Protobuf 3.0.0 REQUIRED)

set(CARTOGRAPHER_CONFIGURATION_FILES_DIRECTORY ${PROJECT_SOURCE_DIR}/configuration_files
  CACHE PATH ".lua configuration files directory")

file(GLOB_RECURSE ALL_LIBRARY_HDRS "*.h")
file(GLOB_RECURSE ALL_LIBRARY_SRCS "*.cc")
file(GLOB_RECURSE ALL_LIBRARY_CMAKES "Find*.cmake")
set(INSTALL_SOURCE_HDRS ${ALL_LIBRARY_HDRS})

# Install catkin package.xml

file(GLOB_RECURSE ALL_PROTOS "*.proto")

set(ALL_PROTO_SRCS)
set(ALL_PROTO_HDRS)
foreach(ABS_FIL ${ALL_PROTOS})
  file(RELATIVE_PATH REL_FIL ${PROJECT_SOURCE_DIR} ${ABS_FIL})
  get_filename_component(DIR ${REL_FIL} DIRECTORY)
  get_filename_component(FIL_WE ${REL_FIL} NAME_WE)

  list(APPEND ALL_PROTO_SRCS "${PROJECT_BINARY_DIR}/${DIR}/${FIL_WE}.pb.cc")
  list(APPEND ALL_PROTO_HDRS "${PROJECT_BINARY_DIR}/${DIR}/${FIL_WE}.pb.h")

  add_custom_command(
    OUTPUT "${PROJECT_BINARY_DIR}/${DIR}/${FIL_WE}.pb.cc"
           "${PROJECT_BINARY_DIR}/${DIR}/${FIL_WE}.pb.h"
    COMMAND  ${PROTOBUF_PROTOC_EXECUTABLE}
    ARGS --cpp_out  ${PROJECT_BINARY_DIR} -I
      ${PROJECT_SOURCE_DIR} ${ABS_FIL}
    DEPENDS ${ABS_FIL}
    COMMENT "Running C++ protocol buffer compiler on ${ABS_FIL}"
    VERBATIM
  )
endforeach()
set_source_files_properties(${ALL_PROTO_SRCS} ${ALL_PROTO_HDRS} PROPERTIES GENERATED TRUE)
list(APPEND ALL_LIBRARY_HDRS ${ALL_PROTO_HDRS})
list(APPEND ALL_LIBRARY_SRCS ${ALL_PROTO_SRCS})

set(INSTALL_GENERATED_HDRS ${ALL_PROTO_HDRS})

set(INSTALL_SOURCE_CMAKES
  ${ALL_LIBRARY_CMAKES}
  ${PROJECT_SOURCE_DIR}/cartographer/cmake/functions.cmake)

add_library(${PROJECT_NAME} ${ALL_LIBRARY_HDRS} ${ALL_LIBRARY_SRCS})

configure_file(
  ${PROJECT_SOURCE_DIR}/cartographer/common/config.h.cmake
  ${PROJECT_BINARY_DIR}/cartographer/include/config.h)

include_directories(
  ${PROJECT_SOURCE_DIR}
)

target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC
  "${EIGEN3_INCLUDE_DIR}")

target_link_libraries(${PROJECT_NAME} PUBLIC ${EIGEN3_LIBRARIES})
target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC
  "${LUA_INCLUDE_DIR}")

target_link_libraries(${PROJECT_NAME} PUBLIC ${LUA_LIBRARIES})

target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC
  "${Boost_INCLUDE_DIRS}")

target_link_libraries(${PROJECT_NAME} PUBLIC ${Boost_LIBRARIES})

target_link_libraries(${PROJECT_NAME} PUBLIC glog)
target_link_libraries(${PROJECT_NAME} PUBLIC gflags)

target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC
  "${CERES_INCLUDE_DIRS}")
target_link_libraries(${PROJECT_NAME} PUBLIC ${CERES_LIBRARIES})

target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC
  ${PROTOBUF_INCLUDE_DIR})
target_link_libraries(${PROJECT_NAME} PUBLIC ${PROTOBUF_LIBRARY} pthread)

# Add the binary directory first, so that port.h is included after it has
# been generated.
target_include_directories(${PROJECT_NAME} PUBLIC
    $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}>
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:include>
)

set(TARGET_COMPILE_FLAGS "${TARGET_COMPILE_FLAGS} ${GOOG_CXX_FLAGS}")
set_target_properties(${PROJECT_NAME} PROPERTIES
  COMPILE_FLAGS ${TARGET_COMPILE_FLAGS})

foreach(HDR ${INSTALL_SOURCE_HDRS})
  file(RELATIVE_PATH REL_FIL ${PROJECT_SOURCE_DIR} ${HDR})
  get_filename_component(DIR ${REL_FIL} DIRECTORY)
  configure_file(
    ${HDR}
    ${PROJECT_BINARY_DIR}/${REL_FIL}
)
endforeach()

foreach(HDR ${INSTALL_GENERATED_HDRS})
  file(RELATIVE_PATH REL_FIL ${PROJECT_BINARY_DIR} ${HDR})
  get_filename_component(DIR ${REL_FIL} DIRECTORY)
  install(
    FILES ${HDR}
    DESTINATION include/${DIR}
  )
endforeach()

foreach(CMAKE ${INSTALL_SOURCE_CMAKES})
  file(RELATIVE_PATH REL_FIL ${PROJECT_SOURCE_DIR} ${CMAKE})
  get_filename_component(DIR ${REL_FIL} DIRECTORY)
  configure_file(
    ${CMAKE}
    ${PROJECT_BINARY_DIR}/${REL_FIL}
)
endforeach()
