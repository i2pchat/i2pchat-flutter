#!/bin/bash

echo "$0 entered"

MONERO_COM=monero.com
CAKEWALLET=cakewallet
HAVEN=haven
EW=fosswallet
CONFIG_ARGS=""

case $APP_ANDROID_TYPE in
        $MONERO_COM)
                CONFIG_ARGS="--monero"
                ;;
        $CAKEWALLET)
                CONFIG_ARGS="--monero --bitcoin --haven"
                ;;
        $HAVEN)
                CONFIG_ARGS="--haven"
                ;;
        $EW)
                CONFIG_ARGS="--monero --bitcoin --haven"
                ;;
esac

cd ../..
cp -vrf pubspec_description.yaml pubspec.yaml
echo "flutter pub get"
flutter pub get
echo "dart run tool/generate_pubspec.dart"
dart run tool/generate_pubspec.dart
echo "flutter pub get"
flutter pub get
echo "dart run tool/configure.dart $CONFIG_ARGS"
dart run tool/configure.dart $CONFIG_ARGS
cd scripts/android
echo "$0 leave"