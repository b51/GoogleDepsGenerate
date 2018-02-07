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
rm -rf install
mkdir -p $SOURCE_ROOT/install/bin $SOURCE_ROOT/install/include $SOURCE_ROOT/install/lib

echo -e "\e[1;32mBuild Lua.\e[0m"
#---------------------------------------------------#
LUA_ROOT=$SOURCE_ROOT/lua-5.3.4
cd $LUA_ROOT
rm -rf install && make clean
make linux
make install
cp -rf install/bin/* $SOURCE_ROOT/install/bin
cp -rf install/include/* $SOURCE_ROOT/install/include
cp -rf install/lib/lib* $SOURCE_ROOT/install/lib
#===================================================#

echo -e "\e[1;32mBuild and install protobuf.\e[0m"
#---------------------------------------------------#
PROTOBUF_ROOT=$SOURCE_ROOT/protobuf-3.0.0
cd $PROTOBUF_ROOT
rm -rf install
make clean
./configure --prefix=$PROTOBUF_ROOT/install
make -j4
make install
cp -rf install/bin/* $SOURCE_ROOT/install/bin
cp -rf install/include/* $SOURCE_ROOT/install/include
cp -rf install/lib/libprotobuf.so* $SOURCE_ROOT/install/lib
#===================================================#

echo -e "\e[1;32mBuild and install ceres.\e[0m"
#---------------------------------------------------#
CERES_ROOT=$SOURCE_ROOT/ceres-solver
cd $CERES_ROOT
rm -rf build install
mkdir build && cd build
cmake -DCXX11=ON -DCMAKE_INSTALL_PREFIX=$CERES_ROOT/install ..
make -j4 && make install

cp -rf $CERES_ROOT/install/include/* $SOURCE_ROOT/install/include
cp -rf $CERES_ROOT/install/lib/lib* $SOURCE_ROOT/install/lib
cp -rf $CERES_ROOT/install/lib/cmake* $SOURCE_ROOT/install/lib
#===================================================#

echo -e "\e[1;32mBuild and install cartographer.\e[0m"
#---------------------------------------------------#
cd $SOURCE_ROOT
rm -rf build
mkdir build && cd build && cmake ..
make -j4
cp -rf cartographer/cartographer $SOURCE_ROOT/install/include
cp -rf cartographer/lib* $SOURCE_ROOT/install/lib
