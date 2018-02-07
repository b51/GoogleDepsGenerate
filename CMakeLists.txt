cmake_minimum_required(VERSION 3.2.12)  # Ships with Ubuntu 14.04 (Trusty)

set(ENV{LUA_DIR}
  ${PROJECT_SOURCE_DIR}/install)

set(PROTOBUF_PROTOC_EXECUTABLE
  ${PROJECT_SOURCE_DIR}/install/bin/protoc)
set(PROTOBUF_INCLUDE_DIR
  ${PROJECT_SOURCE_DIR}/install/include)
set(PROTOBUF_LIBRARY
  ${PROJECT_SOURCE_DIR}/install/lib)

add_subdirectory(cartographer)
