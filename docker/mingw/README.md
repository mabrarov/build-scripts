# MinGW
 
Docker image with MinGW. Contains:

1. [MinGW](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/) targeting Win64
1. [MinGW](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/) targeting Win32

## Examples of usage

Get version of MinGW x64 compiler:

```bash
docker run --rm abrarov/mingw "C:\mingw64\bin\g++" --version
```

Get version of MinGW x86 compiler:

```bash
docker run --rm abrarov/mingw "C:\mingw32\bin\g++" --version
```
