# ARM Cortex M0+ - Atmel SAMD21 template (Building with CMake)

This project serves as a template for the SAMD21J18A.
A cmake toolchain file sets up the toolchain settings for the SAMD21 MCUs in general.

## Dependencies

For building in general

- [arm-none-eabi-gcc compiler](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads)
- [Atmel Software Framework 3](https://www.microchip.com/en-us/development-tools-tools-and-software/libraries-code-examples-and-more/advanced-software-framework-for-sam-devices)

The project was created in Visual Studio Code with the extensions

- [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
- [CMake Tools](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cmake-tools)

## Building inside VS Code

Adjust the paths in the *.json files in the .vscode folder and build with cmake inside VS Code.

## Building from the CMD line

Configure:

$ mkdir build
$ cd build
$ D:\apps\dev\cmake-3.19.2-win64-x64\bin\cmake.exe -DCMAKE_C_COMPILER=D:/apps/dev/arm/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-gcc.exe -DCMAKE_CXX_COMPILER=D:/apps/dev/arm/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-g++.exe -DCMAKE_TOOLCHAIN_FILE=d:/programming/vscode/samd21-playground-cmake/toolchain-arm-none-eabi-samd21.cmake -DASF_PREFIX=D:/apps/dev/arm/xdk-asf-3.49.1 -DCMAKE_BUILD_TYPE=Debug -G Ninja ..

Build:
	$ cmake --build .

## Flashing

	$ ~/Applications/arm-dev/gcc-arm-none-eabi-9-2020-q2-update/bin/arm-none-eabi-gdb -iex "target extended-remote localhost:3333" -ex load -ex "monitor reset" -ex "kill inferiors 1" -ex "quit" build/samd21playground

## Debugging

	$ ~/Applications/arm-dev/gcc-arm-none-eabi-9-2020-q2-update/bin/arm-none-eabi-gdb -iex "target extended-remote localhost:3333" -ex load build/samd21playground

