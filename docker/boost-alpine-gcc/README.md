# Builder of Boost C++ Libraries with GCC and musl libc

Docker image for building [Boost C++ Libraries](http://www.boost.org/) with GCC 9 and [musl libc](https://musl.libc.org/) shipped with [Alpine Linux](https://alpinelinux.org/).

## Building

```bash
docker build -t abrarov/boost-alpine-gcc docker/boost-alpine-gcc/src
```

## Usage

### Environment variable

| Name | Meaning of variable | Possible values | Default value | Comments |
|------|---------------------|-----------------|---------------|----------|
| BOOST_VERSION | Version of Boost to build | One of: `1.70.0`, `1.71.0`, `1.72.0`, `1.73.0`, `1.74.0`, `1.75.0` | `1.75.0` | |
| BOOST_LINKAGE | Linkage of built libraries | One of: `shared`, `static` | Undefined | When undefined then both `shared` and `static` (in the same order) are built |
| BOOST_RUNTIME_LINKAGE | Linkage of C/C++ runtime | One of: `shared`, `static` | Undefined | When undefined then `shared` is built, when `BOOST_LINKAGE` is `shared` then `static` value of `BOOST_RUNTIME_LINKAGE` is ignored |
| B2_OPTIONS | Extra options for Boost.Jam | Any extra options separated with space and passed to Boost.Jam | `--without-mpi --without-graph_parallel` | | 

### Paths and volumes

| Path in Docker image | Meaning of path | Comments |
|----------------------|-----------------|----------|
| /target | Location of built Boost libraries, i.e. output directory | Usually is mapped to external directory to retrieve results of build |
| /download | Location of downloaded Boost source archive | May be mapped to external directory for caching / speedup |
| /build | Location where the building of Boost is performed | May be mapped to external directory for debug |

### Examples

Download source archive, build all combinations (x64, shared and static libraries) 
and put results of build into the current directory of Docker Host:

```bash
docker run --rm -v "$(pwd):/target" abrarov/boost-alpine-gcc
```
