# Builder of OpenSSL with Microsoft Visual C++ 2017

Docker image for building [OpenSSL](https://www.openssl.org/) with Microsoft Visual C++ 2017.

## Building

```bash
docker build -t abrarov/openssl-msvc-2017 docker/openssl-msvc-2017/src
```

## Usage

### Environment variable

| Name | Meaning of variable | Possible values | Default value | Comments |
|------|---------------------|-----------------|---------------|----------|
| OPENSSL_VERSION | Version of OpenSSL to build | One of: `3.5.0` | `3.5.0` | |
| OPENSSL_ADDRESS_MODEL | CPU architecture | One of: `32`, `64` | Undefined | When undefined then both `64` and `32` (in the same order) are built |
| OPENSSL_LINKAGE | Linkage of built libraries | One of: `shared`, `static` | Undefined | When undefined then both `shared` and `static` (in the same order) are built, `static` build uses static C/C++ runtime |
| OPENSSL_PATCH_FILE | Path to file in container with path applied to OpenSSL before building |  | Undefined | When undefined then patch is chosen among embedded patches based on version of OpenSSL. Embedded patches are located in `C:\app\patches` directory of image | 
| OPENSSL_TEST | Flag to run tests during build | Any value or empty string | Empty string | When is not empty string then tests are executed during build with `test` goal of Makefile executed before `install` goal |

### Paths and volumes

| Path in Docker image | Meaning of path | Comments |
|----------------------|-----------------|----------|
| C:\target | Location of built OpenSSL, i.e. output directory | Usually is mapped to external directory to retrieve results of build |
| C:\download | Location of downloaded OpenSSL source archive | May be mapped to external directory for caching / speedup |
| C:\build | Location where the building of OpenSSL is performed | May be mapped to external directory for debug |

### Examples

Download source archive, build all combinations (x86, x64, shared and static libraries) and put results of build into 
`C:\Users\Public\openssl-msvc-2017\target` folder of Docker Host:

```bash
docker run --rm \
-v C:/Users/Public/openssl-msvc-2017/target:C:/target \
abrarov/openssl-msvc-2017
```

Download source archive, build x64 shared libraries and put results of build into `C:\Users\Public\openssl-msvc-2017\target` 
folder of Docker Host:

```bash
docker run --rm \
-e OPENSSL_ADDRESS_MODEL=64 \
-e OPENSSL_LINKAGE=shared \
-v C:/Users/Public/openssl-msvc-2017/target:C:/target \
abrarov/openssl-msvc-2017
```
