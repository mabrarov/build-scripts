# Builder of Boost C++ Libraries with MinGW

Docker image for building [Boost C++ Libraries](http://www.boost.org/) with MinGW.

## Building

```bash
docker build -t abrarov/boost-mingw docker/boost-mingw/src
```

## Usage

### Environment variable

| Name | Meaning of variable | Possible values | Default value | Comments |
|------|---------------------|-----------------|---------------|----------|
| BOOST_VERSION | Version of Boost to build | One of: `1.70.0`, `1.71.0`, `1.72.0`, `1.73.0`, `1.74.0`, `1.75.0`, `1.76.0`, `1.77.0`, `1.78.0`, `1.79.0`, `1.80.0`, `1.82.0` | `1.82.0` |
| BOOST_ADDRESS_MODEL | CPU architecture | One of: `32`, `64` | Undefined | When undefined then both `64` and `32` (in the same order) are built |
| BOOST_LINKAGE | Linkage of built libraries | One of: `shared`, `static` | Undefined | When undefined then both `shared` and `static` (in the same order) are built |
| BOOST_RUNTIME_LINKAGE | Linkage of C/C++ runtime | One of: `shared`, `static` | Undefined | When undefined then both `shared` and `static` (in the same order) are built, when `BOOST_LINKAGE` is `shared` then `static` value of `BOOST_RUNTIME_LINKAGE` is ignored |
| B2_OPTIONS | Extra options for Boost.Jam | Any extra options separated with space and passed to Boost.Jam | `--without-python --without-mpi --without-graph_parallel` | | 

### Paths and volumes

| Path in Docker image | Meaning of path | Comments |
|----------------------|-----------------|----------|
| C:\target | Location of built Boost libraries, i.e. output directory | Usually is mapped to external directory to retrieve results of build |
| C:\download | Location of downloaded Boost source archive | May be mapped to external directory for caching / speedup |
| C:\build | Location where the building of Boost is performed | May be mapped to external directory for debug |

### Examples

Download source archive, build all combinations (x86, x64, shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-mingw-target` folder of Docker Host:

```bash
docker run --rm \
-v C:/Users/Public/Documents/boost-mingw-target:C:/target \
abrarov/boost-mingw
```
 
Use pre-downloaded source archive located at `C:\Users\Public\Documents\boost-mingw\download\boost_1_74_0.zip` file 
on Docker Host, build all combinations and put results of build into `C:\Users\Public\Documents\boost-mingw\target` 
folder of Docker Host:
 
```bash
docker run --rm \
-v C:/Users/Public/Documents/boost-mingw/target:C:/target \
-v C:/Users/Public/Documents/boost-mingw/download/boost_1_74_0.zip:C:/download/boost_1_74_0.zip \
abrarov/boost-mingw
```

Download source archive, build all combinations for x64 platform (shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-mingw\target` folder of Docker Host:

```bash
docker run --rm \
-e BOOST_ADDRESS_MODEL=64 \
-v C:/Users/Public/Documents/boost-mingw/target:C:/target \
abrarov/boost-mingw
```

Download source archive, build static libraries with shared C/C++ runtime for x64 platform and put results of build into 
`C:\Users\Public\Documents\boost-mingw\target` folder of Docker Host:

```bash
docker run --rm \
-e BOOST_ADDRESS_MODEL=64 \
-e BOOST_LINKAGE=static \
-e BOOST_RUNTIME_LINKAGE=shared \
-v C:/Users/Public/Documents/boost-mingw/target:C:/target \
abrarov/boost-mingw
```
