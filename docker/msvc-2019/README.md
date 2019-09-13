# Microsoft Visual C++ 2019
 
Docker image with Microsoft Visual C++ 2019 installed as part of Microsoft Visual Studio 2019 Community. 

Contains:

1. Microsoft Visual Studio 2019 Community with installed packages for desktop development with Visual C++
1. [Visual Studio Locator](https://github.com/Microsoft/vswhere) (`vswhere` tool) for locating of folders where Visual Studio is installed

## Building

```bash
docker build -t abrarov/msvc-2019 docker/msvc-2019/src
```

## Usage

Run windows command prompt inside Docker container in interactive mode:

```bash
docker run --rm -it abrarov/msvc-2019 cmd
```

Get folder where MS Visual Studio 2019 is installed:

```bash
docker run --rm \
abrarov/msvc-2019 \
vswhere -latest \
-products Microsoft.VisualStudio.Product.Community \
-version '[16.0,17.0)' \
-property installationPath
```
