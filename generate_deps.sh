#########################################################################
#
#              Author: b51
#                Mail: b51live@gmail.com
#            FileName: build_lua.sh
#
#          Created On: 2018年02月07日 星期三 15时04分39秒
#
#########################################################################

#!/bin/bash

SOURCE_ROOT=`pwd`
INSTALL_ROOT=$SOURCE_ROOT/../GoogleDeps
BIN_ROOT=$INSTALL_ROOT/bin
INCLUDE_ROOT=$INSTALL_ROOT/include
LIB_ROOT=$INSTALL_ROOT/lib
CMAKE_ROOT=$INSTALL_ROOT/cmake

rm -rf $INSTALL_ROOT
mkdir -p $BIN_ROOT $INCLUDE_ROOT $LIB_ROOT $CMAKE_ROOT

echo -e "\e[1;32mBuild Lua.\e[0m"
#---------------------------------------------------#
LUA_ROOT=$SOURCE_ROOT/lua-5.3.4
cd $LUA_ROOT
rm -rf install && make clean
make linux
make install
cp -rf install/bin/* $BIN_ROOT
cp -rf install/include/* $INCLUDE_ROOT
cp -rf install/lib/lib* $LIB_ROOT
#===================================================#

echo -e "\e[1;32mBuild and install protobuf.\e[0m"
#---------------------------------------------------#
PROTOBUF_ROOT=$SOURCE_ROOT/protobuf-3.0.0
cd $PROTOBUF_ROOT
rm -rf install
make clean
./configure --prefix=$PROTOBUF_ROOT/install
make -j8
make install
cp -rf install/bin/* $BIN_ROOT
cp -rf install/include/* $INCLUDE_ROOT
cp -rf install/lib/libprotobuf.so* $LIB_ROOT
#===================================================#

echo -e "\e[1;32mBuild and install ceres.\e[0m"
#---------------------------------------------------#
CERES_ROOT=$SOURCE_ROOT/ceres-solver
cd $CERES_ROOT
rm -rf build install
mkdir build && cd build
cmake -DCXX11=ON -DCMAKE_INSTALL_PREFIX=$INSTALL_ROOT ..
make -j8 && make install
#===================================================#

echo -e "\e[1;32mBuild and install cartographer.\e[0m"
#---------------------------------------------------#
cd $SOURCE_ROOT
rm -rf build
mkdir build && cd build && cmake ..
make -j8
cp -rf cartographer/cartographer $INCLUDE_ROOT
cp -rf cartographer/lib* $LIB_ROOT
cp $SOURCE_ROOT/cartographer/cartographer/cmake/functions.cmake $INCLUDE_ROOT/cartographer/cmake/

echo -e "\e[1;32mCopy ros pkgs.\e[0m"
cp $SOURCE_ROOT/rospkg/cmake/GoogleDeps.cmake $CMAKE_ROOT
cp $SOURCE_ROOT/rospkg/CMakeLists.txt.pkg   $INSTALL_ROOT
cp $SOURCE_ROOT/rospkg/package.xml.pkg $INSTALL_ROOT
