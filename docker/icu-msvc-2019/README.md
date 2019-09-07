# Builder of ICU4C with Microsoft Visual C++ 2019

Docker image for building [ICU4C](http://site.icu-project.org/) with Microsoft Visual C++ 2019.

## Building

```bash
docker build -t abrarov/icu-msvc-2019 docker/icu-msvc-2019/src
```

## Usage

### Environment variable

| Name | Meaning of variable | Possible values | Default value | Comments |
|------|---------------------|-----------------|---------------|----------|
| ICU_VERSION | Version of ICU to build | One of: `57.1`, `58.2`, `64.2` | `64.2` | |
| ICU_ADDRESS_MODEL | CPU architecture | One of: `32`, `64` | Undefined | When undefined then both `64` and `32` (in the same order) are built |
| ICU_LINKAGE | Linkage of built libraries | One of: `shared`, `static` | Undefined | When undefined then both `shared` and `static` (in the same order) are built, `static` build uses static C/C++ runtime |
| ICU_BUILD_TYPE | Linkage of C/C++ runtime | One of: `release`, `debug` | Undefined | When undefined then both `release` and `debug` (in the same order) are built. If both are built then `bin` subdirectory is populated with binaries of `release` only |
| ICU_PATCH_FILE | Path to file in container with path applied to ICU before building |  | Undefined | When undefined the patch is chosen among embedded patches based on version of ICU. Embedded patches are located in `C:\app\pathes` directory of image | 

### Paths and volumes

| Path in Docker image | Meaning of path | Comments |
|----------------------|-----------------|----------|
| C:\target | Location of built ICU, i.e. output directory | Usually is mapped to external directory to retrieve results of build |
| C:\downloads | Location of downloaded ICU source archive | May be mapped to external directory for caching / speedup |
| C:\build | Location where the building of ICU is performed | May be mapped to external directory for debug |

### Examples

Download source archive, build all combinations (x86, x64, shared and static libraries) and put results of build into 
`C:\Users\Public\icu-msvc-2019\target` folder of Docker Host:

```bash
docker run --rm \
-v C:/Users/Public/icu-msvc-2019/target:C:/target \
abrarov/icu-msvc-2019
```

Download source archive, build x64 shared libraries and put results of build into `C:\Users\Public\icu-msvc-2019\target` 
folder of Docker Host:
 
```bash
docker run --rm \
-e ICU_ADDRESS_MODEL=64 \
-e ICU_LINKAGE=shared \ 
-v C:/Users/Public/icu-msvc-2019/target:C:/target \
abrarov/icu-msvc-2019
```
