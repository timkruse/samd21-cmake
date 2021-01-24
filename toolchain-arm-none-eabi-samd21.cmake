# A CMake toolchain file so we can cross-compile for the Atmel SAMD21 bare-metal
# https://www.valvers.com/open-software/raspberry-pi/bare-metal-programming-in-c-part-3/

# usage
# cmake -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm-none-eabi.cmake ../

# The Generic system name is used for embedded targets (targets without OS) in CMake
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR SAMD21)

# Set a toolchain path. You only need to set this if the toolchain isn't in your system path.
# set(GCC_PREFIX "" CACHE PATH "Path to the root of the cross compiler (gcc)" FORCE)
if (GCC_PREFIX STREQUAL "")
    message(FATAL_ERROR "GCC_PREFIX not set - required. (Set before -DCMAKE_TOOLCHAIN_FILE")
endif()

# append trailing slash if not existing
if(NOT GCC_PREFIX MATCHES "/$")
    string(APPEND GCC_PREFIX "/")
endif()

# append subfolder bin
if(NOT GCC_PREFIX MATCHES "bin/$")
    string(APPEND GCC_PREFIX "bin/")
endif()

# The toolchain prefix for all toolchain executables
set(CROSS_COMPILE ${GCC_PREFIX}arm-none-eabi-)

# specify the cross compiler. We force the compiler so that CMake doesn't
# attempt to build a simple test program as this will fail without us using
# the -nostartfiles option on the command line

set( CMAKE_CXX_COMPILER ${CROSS_COMPILE}g++.exe )
set( CMAKE_C_COMPILER ${CROSS_COMPILE}gcc.exe )
set( CMAKE_ASM_COMPILER ${CROSS_COMPILE}gcc.exe )

# Because the cross-compiler cannot directly generate a binary without complaining, just test
# compiling a static library instead of an executable program
set( CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY )

# We must set the OBJCOPY setting into cache so that it's available to the
# whole project. Otherwise, this does not get set into the CACHE and therefore
# the build doesn't know what the OBJCOPY filepath is

set( CMAKE_OBJCOPY  ${CROSS_COMPILE}objcopy    CACHE FILEPATH "The toolchain objcopy command " FORCE )
set( CMAKE_OBJDUMP  ${CROSS_COMPILE}objdump    CACHE FILEPATH "The toolchain objdump command " FORCE )
set( CMAKE_SIZE     ${CROSS_COMPILE}size       CACHE FILEPATH "The toolchain size command " FORCE )
set( CMAKE_NM       ${CROSS_COMPILE}nm         CACHE FILEPATH "The toolchain nm command " FORCE )

# Set the common build flags

# Set the CMAKE Compiler flags
# Since the toolchain file is executed twice, check if it has been set already
if(NOT DEFINED TOOLCHAIN_COMPILER_FLAGS)
    list(APPEND TOOLCHAIN_COMMON_FLAGS
        "-ffreestanding"
        "-ffunction-sections"
        "-fdata-sections"
        "--specs=nano.specs"
    )
    list(APPEND TOOLCHAIN_ARCH_FLAGS
        "-mthumb"
        "-march=armv6-m"
        "-mcpu=cortex-m0plus"
        "-mfloat-abi=soft"
    )
    list(APPEND TOOLCHAIN_WARNING_FLAGS
        "-Wall"
        "-Wextra"
        "-Wno-unused-parameter"
    )

    list(APPEND TOOLCHAIN_CXX_FLAGS
        "-fno-exceptions"
        "-fno-rtti"
    )

    list(APPEND TOOLCHAIN_COMPILER_FLAGS ${TOOLCHAIN_ARCH_FLAGS} 
                                        ${TOOLCHAIN_WARNING_FLAGS} 
                                        ${TOOLCHAIN_COMMON_FLAGS}
                                        )
                                        
    string(REPLACE ";" " " CMAKE_ASM_FLAGS "${TOOLCHAIN_COMPILER_FLAGS}")
    string(REPLACE ";" " " CMAKE_C_FLAGS "${TOOLCHAIN_COMPILER_FLAGS}")
    string(REPLACE ";" " " CMAKE_CXX_FLAGS "${TOOLCHAIN_COMPILER_FLAGS} ${TOOLCHAIN_CXX_FLAGS}")
endif()



set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}" CACHE STRING "" )
set( CMAKE_C_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" )
set( CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS}" CACHE STRING "" )