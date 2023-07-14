#!/bin/bash
echo "$0 entered"
. ./config.sh

EW_DIR=/zsata/vcs/easy-wallet-v6
EW_EXT_DIR=${EW_DIR}/cw_shared_external/ios/External/android
EW_HAVEN_EXT_DIR=${EW_DIR}/cw_haven/ios/External/android
EW_MONERO_EXT_DIR=${EW_DIR}/cw_monero/ios/External/android
for arch in "aarch" "aarch64" "i686" "x86_64"
do
echo "arch $arch started"

PREFIX=${WORKDIR}/prefix_${arch}
ABI=""

case $arch in
	"aarch"	)
		ABI="armeabi-v7a";;
	"aarch64"	)
		ABI="arm64-v8a";;
	"i686"		)
		ABI="x86";;
	"x86_64"	)
		ABI="x86_64";;
esac

LIB_DIR=${EW_EXT_DIR}/${ABI}/lib
INCLUDE_DIR=${EW_EXT_DIR}/${ABI}/include
LIBUNBOUND_PATH=${PREFIX}/lib/libunbound.a

mkdir -pv $LIB_DIR
mkdir -pv $INCLUDE_DIR

cp -rv ${PREFIX}/lib/* $LIB_DIR
cp -rv ${PREFIX}/include/* $INCLUDE_DIR

if [ -f "$LIBUNBOUND_PATH" ]; then
 cp -v $LIBUNBOUND_PATH ${LIB_DIR}/monero
fi
echo "arch $arch done"
done

mkdir -pv ${EW_HAVEN_EXT_DIR}/include
mkdir -pv ${EW_MONERO_EXT_DIR}/include

cp -v $EW_EXT_DIR/x86/include/monero/wallet2_api.h ${EW_MONERO_EXT_DIR}/include
cp -v $EW_EXT_DIR/x86/include/haven/wallet2_api.h ${EW_HAVEN_EXT_DIR}/include
echo "$0 leaving"
