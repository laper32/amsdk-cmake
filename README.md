# AMSDK-Cmake

AlliedModders SDK toolchains, CMake version.

Modified by this version: [Teleporter](https://github.com/MoeMod/smsdk_ext-cmake)

I have modified it, and make it compilable on Linux.

The sample can be found via here: [Teleporter](https://github.com/MoeMod/z4d)

Feel free to contribute it.

Check [**HERE**](https://github.com/laper32/amsdk-cmake-example) for example referencing.

Noting that we have been reversed Source 2 slot, that once Source 2 is ready, we can
switch to Source 2 and drop Source 1 immediately.

But, these things that you must beware:
1. The compilation time, which will take much longer than you expected, because this is built from source.
2. You have been assumed that you know how to use CMake, and also know how to use CMake to build project.
3. This script is still incomplete (Other version of SDK supportance, etc).
4. In general, this is used by myself, which means that it is possible that this toolchain does not fit you.
5. WARNING: In *nix system(Linux, Mac, etc), you MUST modify from '-' to '_' if you want to use environment variable.