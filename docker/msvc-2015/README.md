# Microsoft Visual C++ 2015
 
Docker image with Microsoft Visual C++ 2015 installed as part of Microsoft Visual Studio 2015 Community. 

Contains:

1. Microsoft Visual Studio 2015 Community with installed packages for desktop development with Visual C++
1. [Visual Studio Locator](https://github.com/Microsoft/vswhere) (`vswhere` tool) for locating of folders where Visual Studio is installed

## Building

```bash
docker build -t abrarov/msvc-2015 docker/msvc-2015/src
```

## Usage

Run windows command prompt inside Docker container in interactive mode:

```bash
docker run --rm -it abrarov/msvc-2015 cmd
```

Get folder where MS Visual Studio 2015 is installed:

```bash
docker run --rm \
abrarov/msvc-2015 \
vswhere -legacy -latest \
-version '[14.0,15.0)' \
-property installationPath
```
