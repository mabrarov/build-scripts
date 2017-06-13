# MinGW
 
Docker image with MinGW. Contains:

1. [MinGW](https://bintray.com/mabrarov/generic/MinGW) targeting Win64 from [MinGW-builds](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/)
1. [MinGW](https://bintray.com/mabrarov/generic/MinGW) targeting Win32 from [MinGW-builds](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/)

## Examples of usage

Get version of MinGW x64 compiler:

```bash
docker run --rm abrarov/mingw "/C:\mingw64\bin\g++" --version
```

Get version of MinGW x86 compiler:

```bash
docker run --rm abrarov/mingw "/C:\mingw32\bin\g++" --version
```
