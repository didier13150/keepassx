set(CMAKE_SYSTEM_NAME Windows)

set( WIN_BUILD_ARCH "x86_64" )
set( WIN_ARCH_BITS "64" )
set( WIN_ARCH "x64" )
set(COMPILER_PREFIX "${WIN_BUILD_ARCH}-w64-mingw32")

# Which compilers to use for C and C++
set(CMAKE_C_COMPILER ${COMPILER_PREFIX}-gcc)
set(CMAKE_CXX_COMPILER ${COMPILER_PREFIX}-g++)
set(CMAKE_RC_COMPILER ${COMPILER_PREFIX}-windres)

# Here is the target environment located
set(CMAKE_FIND_ROOT_PATH /usr/${COMPILER_PREFIX} /usr/${COMPILER_PREFIX}/sys-root/mingw)

# Adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
