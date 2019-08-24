# windows-dev
 
Base Docker image for Docker images building on Windows. 

Contains:

1. [Chocolatey](https://chocolatey.org)
1. [7-Zip](https://www.7-zip.org)
1. [MSYS2](http://www.msys2.org) with base-devel Pacman package group
1. [ActivePerl](https://www.activestate.com/products/activeperl)
1. [Python 2.x and 3.x](https://www.python.org)

## Building

```bash
docker build -t abrarov/windows-dev docker/windows-dev
```

## Usage

It's a base image with common tools, which is intended to be inherited by other images building on Windows.

Test 7-Zip setup:

```bash
docker run --rm abrarov/windows-dev "C:\Program Files\7-Zip\7z.exe"
```