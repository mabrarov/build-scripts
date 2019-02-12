# MinGW
 
Docker image with MinGW from MinGW-builds. 

Contains:

1. [MinGW](https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win32/Personal%20Builds/mingw-builds/) targeting Win32
1. MinGW targeting Win64

## Building

```bash
docker build -t abrarov/win-builder docker/win-builder
```

## Usage

It's a base image with common tools, which is intended to be inherited by other images building on Windows.

Test 7-Zip setup:

```bash
docker run --rm abrarov/win-builder "C:\Program Files\7-Zip\7z.exe"
```