include(FindPackageHandleStandardArgs)

set(ENV{LUA_DIR}
  ${GoogleDeps_SOURCE_PREFIX})

find_package(Ceres REQUIRED PATHS "${GoogleDeps_SOURCE_PREFIX}")

include(${GoogleDeps_SOURCE_PREFIX}/include/cartographer/cmake/functions.cmake)

find_package(Ceres REQUIRED PATHS "${GoogleDeps_SOURCE_PREFIX}")

set(CMAKE_MODULE_PATH
  ${CMAKE_MODULE_PATH}
  ${GoogleDeps_SOURCE_PREFIX}/include/cartographer/cmake/modules)

set(LUA_INCLUDE_DIR
  ${GoogleDeps_SOURCE_PREFIX}/include)

find_package(LuaGoogle REQUIRED)

find_library(CARTO_LIBRARIES
  NAMES cartographer
  PATHS ${GoogleDeps_SOURCE_PREFIX}/lib)

set(GOOGLE_INCLUDE_DIRS
  ${GoogleDeps_SOURCE_PREFIX}/include)

set(GOOGLE_LIBS
  ${CARTO_LIBRARIES}
  ${LUA_LIBRARIES}
  ${CERES_LIBRARIES}
  gflags
  glog
)
