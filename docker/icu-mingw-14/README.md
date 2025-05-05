# Builder of ICU4C with MinGW 14

Docker image for building [ICU4C](http://site.icu-project.org/) with MinGW 14.

## Building

```bash
docker build -t abrarov/icu-mingw-14 docker/icu-mingw-14/src
```

## Usage

### Environment variable

| Name | Meaning of variable | Possible values | Default value | Comments |
|------|---------------------|-----------------|---------------|----------|
| ICU_VERSION | Version of ICU to build | `77.1` | `77.1` | |
| ICU_ADDRESS_MODEL | CPU architecture | One of: `32`, `64` | Undefined | When undefined then both `64` and `32` (in the same order) are built |
| ICU_LINKAGE | Linkage of built libraries | One of: `shared`, `static` | Undefined | When undefined then both `shared` and `static` (in the same order) are built, `static` build uses static C/C++ runtime |
| ICU_PATCH_FILE | Path to file in container with path applied to ICU before building |  | Undefined | When undefined then patch is chosen among embedded patches based on version of ICU. Embedded patches are located in `C:\app\patches` directory of image |
| ICU_TEST | Flag to run tests during build | Any value or empty string | Empty string | When is not empty string then tests are executed during build with `check` goal of Makefile executed before `install` goal |

### Paths and volumes

| Path in Docker image | Meaning of path | Comments |
|----------------------|-----------------|----------|
| C:\target | Location of built ICU, i.e. output directory | Usually is mapped to external directory to retrieve results of build |
| C:\download | Location of downloaded ICU source archive | May be mapped to external directory for caching / speedup |
| C:\build | Location where the building of ICU is performed | May be mapped to external directory for debug |

### Examples

Download source archive, build all combinations (x86, x64, shared and static libraries) and put results of build into 
`C:\Users\Public\icu-mingw-14\target` folder of Docker Host:

```bash
docker run --rm \
-v /C:/Users/Public/icu-mingw-14/target:C:/target \
abrarov/icu-mingw-14
```

Download source archive, build x64 shared libraries and put results of build into `C:\Users\Public\icu-mingw-14\target` 
folder of Docker Host:

```bash
docker run --rm \
-e ICU_ADDRESS_MODEL=64 \
-e ICU_LINKAGE=shared \ 
-v /C:/Users/Public/icu-mingw-14/target:C:/target \
abrarov/icu-mingw-14
```
