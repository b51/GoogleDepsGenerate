#########################################################################
#
#              Author: b51
#                Mail: b51live@gmail.com
#            FileName: carto_deps.sh
#
#          Created On: Mon 17 Jun 2019 06:16:02 PM CST
#
#########################################################################

#!/bin/bash

echo -e "\e[1;32mUsage: ./carto_deps.sh [path/to/install].\e[0m"
SOURCE_ROOT=`pwd`
INSTALL_ROOT=${1:-$(dirname $SOURCE_ROOT)}/GoogleDeps
echo $INSTALL_ROOT

if [ ! -d "$INSTALL_ROOT" ]; then
  mkdir -p $INSTALL_ROOT
fi

echo -e "\e[1;32mBuild and install cartographer.\e[0m"
#---------------------------------------------------#
cd $SOURCE_ROOT/cartographer
rm -rf build
mkdir build && cd build && cmake -GNinja -DCMAKE_INSTALL_PREFIX=$INSTALL_ROOT ..
ninja install

echo -e "\e[1;32mCopy ros pkgs.\e[0m"
cp $SOURCE_ROOT/rospkg/CMakeLists.txt.pkg $INSTALL_ROOT/CMakeLists.txt
cp $SOURCE_ROOT/rospkg/package.xml.pkg    $INSTALL_ROOT/package.xml
