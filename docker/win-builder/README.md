# win-builder
 
Base Docker image for Docker images building on Windows. 

Contains:

1. [7-Zip](https://www.7-zip.org)
1. [MSYS2](http://www.msys2.org/)

## Building

```powershell
docker build -t abrarov/win-builder docker/win-builder
```

## Usage

It's a base image with common tools, which is intended to be inherited by other images building on Windows.

Test 7-Zip setup:

```powershell
docker run --rm abrarov/win-builder "C:\Program Files\7-Zip\7z.exe"
```