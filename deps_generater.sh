#########################################################################
#
#              Author: b51
#                Mail: b51live@gmail.com
#            FileName: deps_generater.sh
#
#          Created On: 2018年02月07日 星期三 15时04分39秒
#
#########################################################################

#!/bin/bash

SOURCE_ROOT=`pwd`
INSTALL_ROOT=$(dirname $SOURCE_ROOT)/GoogleDeps

rm -rf $INSTALL_ROOT
mkdir -p $INSTALL_ROOT

#echo -e "\e[1;32mBuild Lua.\e[0m"
##---------------------------------------------------#
#LUA_ROOT=$SOURCE_ROOT/lua-5.3.5
#cd $LUA_ROOT
#make linux
#sudo make install
##===================================================#

echo -e "\e[1;32mInstall Lua.\e[0m"
#---------------------------------------------------#
sudo apt install lua5.3 liblua5.3-dev -y
#===================================================#

echo -e "\e[1;32mInstall dependences.\e[0m"
#---------------------------------------------------#
sudo apt install libsuitesparse-dev ninja-build libmetis-dev -y
#===================================================#

echo -e "\e[1;32mBuild and install protobuf.\e[0m"
##---------------------------------------------------#
./install_proto3.sh
#cd $SOURCE_ROOT
#PROTOBUF_ROOT=$SOURCE_ROOT/protobuf-3.0.0
#rm -rf $PROTOBUF_ROOT
#tar zxvf protobuf-cpp-3.0.0.tar.gz
#cd $PROTOBUF_ROOT
#./configure --prefix=$INSTALL_ROOT
#make -j4
#make install
#===================================================#

echo -e "\e[1;32mBuild and install ceres.\e[0m"
#---------------------------------------------------#
CERES_ROOT=$SOURCE_ROOT/ceres-solver
cd $CERES_ROOT
rm -rf build install
mkdir build && cd build
cmake -GNinja -std=c++11 -DCMAKE_INSTALL_PREFIX=$INSTALL_ROOT ..
ninja install
#===================================================#

echo -e "\e[1;32mBuild and install cartographer.\e[0m"
#---------------------------------------------------#
cd $SOURCE_ROOT/cartographer
rm -rf build
mkdir build && cd build && cmake -GNinja -DCMAKE_INSTALL_PREFIX=$INSTALL_ROOT ..
ninja install

echo -e "\e[1;32mCopy ros pkgs.\e[0m"
cp $SOURCE_ROOT/rospkg/CMakeLists.txt.pkg $INSTALL_ROOT/CMakeLists.txt
cp $SOURCE_ROOT/rospkg/package.xml.pkg    $INSTALL_ROOT/package.xml
