# MinGW-w64 14

Docker image with MinGW-w64 from [niXman mingw-builds](https://github.com/niXman/mingw-builds-binaries).

Contains:

1. MinGW-w64 targeting Win32
1. MinGW-w64 targeting Win64

## Building

```bash
docker build -t abrarov/mingw-14 docker/mingw-14/src
```

## Usage

Get version of MinGW x64 compiler:

```bash
docker run --rm abrarov/mingw-14 "C:\mingw64\bin\g++" --version
```

Get version of MinGW x86 compiler:

```bash
docker run --rm abrarov/mingw-14 "C:\mingw32\bin\g++" --version
```
