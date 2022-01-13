# Microsoft Visual C++ 2022
 
Docker image with Microsoft Visual C++ 2022 installed as part of Microsoft Visual Studio Build Tools 2022.

Contains:

1. Microsoft Visual Studio Build Tools 2022 with installed packages for desktop development with Visual C++
1. [Visual Studio Locator](https://github.com/Microsoft/vswhere) (`vswhere` tool) for locating of folders where Visual Studio is installed

## Building

```bash
docker build -t abrarov/msvc-2022 docker/msvc-2022/src
```

## Usage

Run windows command prompt inside Docker container in interactive mode:

```bash
docker run --rm -it abrarov/msvc-2022 cmd
```

Get folder where Microsoft Visual Studio Build Tools 2022 are installed:

```bash
docker run --rm \
abrarov/msvc-2022 \
vswhere -latest \
-products Microsoft.VisualStudio.Product.BuildTools \
-version '[17.0,18.0)' \
-property installationPath
```
