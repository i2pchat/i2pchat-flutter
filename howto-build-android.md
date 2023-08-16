# Building FossWallet for Android

## Requirements and Setup

The following are the system requirements to build FossWallet for your Android device.

 * Ubuntu >= 16.04 
 * Android SDK 28
 * Android NDK 17c

```
: dart  --version
Dart SDK version: 2.19.0 (stable) (Mon Jan 23 11:29:09 2023 -0800) on "linux_x64"
: flutter --version
Flutter 3.7.0 • channel stable • https://github.com/flutter/flutter.git
Framework • revision b06b8b2710 (7 месяцев назад) • 2023-01-23 16:55:55 -0800
Engine • revision b24591ed32
Tools • Dart 2.19.0 • DevTools 2.20.1
```

## Building FossWallet on Android

These steps will help you configure and execute a build of FossWallet from its source code.

### 1. Installing Package Dependencies

FossWallet cannot be built without the following packages installed on your build system.

  - curl
  - unzip
  - automake
  - build-essential
  - file
  - pkg-config
  - git
  - python
  - libtool
  - libtinfo5
  - cmake
  - openjdk-8-jre-headless
  - clang

You may easily install them on your build system with the following command:

`sudo apt-get install -y curl unzip automake build-essential file pkg-config git python libtool libtinfo5 cmake openjdk-8-jre-headless clang`

### 2. Installing Android Studio and Android toolchain

You may download and install the latest version of Android Studio [here](https://developer.android.com/studio#downloads). After installing, start Android Studio, and go through the "Setup Wizard." This installs the latest Android SDK, Android SDK Command-line Tools, and Android SDK Build-Tools, which are required by FossWallet. **Be sure you are installing SDK version 28 or later when stepping through the wizard**

### 3. Installing Flutter

 * (not needed) Install dart sdk from https://storage.googleapis.com/dart-archive/channels/stable/release/2.19.0/sdk/dartsdk-linux-x64-release.zip
 * Install flutter from https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.7.0-stable.tar.xz (includes 
   dart sdk at bin/cache/)

Need to install flutter with version `3.7.0`. For this please check section [Install Flutter manually](https://docs.flutter.dev/get-started/install/linux#install-flutter-manually).

### 4. Verify Installations

Verify that the Android toolchain, Flutter, and Android Studio have been correctly installed on your system with the following command:

`flutter doctor`

The output of this command will appear like this, indicating successful installations. If there are problems with your installation, they **must** be corrected before proceeding.
```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.10.4, on Ubuntu 20.04.6 LTS 5.4.0-153-generic)
[✓] Android toolchain - develop for Android devices (Android SDK version 28)
[✓] Android Studio (version 4.0)
```

### 5. Generate a secure keystore for Android

`keytool -genkey -v -keystore $HOME/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`

You will be prompted to create two passwords. First you will be prompted for the "store password", followed by a "key password" towards the end of the creation process. **TAKE NOTE OF THESE PASSWORDS!** You will need them in later steps. 

### 6. Acquiring the FossWallet Source Code

Create the directory that will be use to store the FossWallet source...

```bash
mkdir ~/vcs
cd ~/vcs
```

...and download the source code into that directory.

`$ git clone https://github.com/foss-wallet/foss-wallet-v6.git --branch main`

Proceed into the source code before proceeding with the next steps:

`$ cd foss-wallet-v5/scripts/android`

### 7. Installing Android NDK

`./install_ndk.sh`

### 8. Execute Build & Setup Commands for FossWallet

We need to generate project settings like app name, app icon, package name, etc. For this need to setup environment variables and configure project files. 

Please pick what app you want to build: cakewallet or monero.com or fosswallet.

`source ./app_env.sh fosswallet`

Then run configuration script for setup app name, app icon and etc:

`./app_config.sh`

Build the Monero libraries and their dependencies:

`./build_all.sh`

Now the dependencies need to be copied into the FossWallet project with this command:

`./copy_monero_deps.sh`

It is now time to change back to the base directory of the FossWallet source code:

`cd ../..`

Install Flutter package dependencies with this command:

`flutter pub get`

Your FossWallet binary will be built with cryptographic salts, which are used for secure encryption of your data.
You may generate these secret salts with the following command:

`dart run tool/generate_new_secrets.dart`

Next, we must generate key properties based on the secure keystore you generated for Android (in step 5).
**MODIFY THE FOLLOWING COMMAND** with the "store password" and "key password" you assigned when creating your keystore (in step 5).

`dart run tool/generate_android_key_properties.dart keyAlias=key storeFile=$HOME/key.jks storePassword=<store password> keyPassword=<key password>`

**REMINDER:** The *above* command will **not** succeed unless you replaced the `storePassword` and `keyPassword` variables
with the correct passwords for your keystore.

Then we need to generate localization files.

`dart run tool/generate_localization.dart`

Lastly, we will generate mobx models for the project.

`./model_generator.sh`

### 9. Build!

`flutter build apk --release`

Copyright (c) 2022 Cake Technologies LLC.
Copyright (c) 2023 FossWallet team. All Rights Reserved.
