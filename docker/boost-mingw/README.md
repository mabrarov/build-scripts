# Builder of Boost C++ Libraries with MinGW

Docker image for building [Boost C++ Libraries](http://www.boost.org/) with MinGW.

## Building

```bash
docker build -t abrarov/boost-mingw docker/boost-mingw
```

## Usage

Download source archive, build all combinations (x86, x64, shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-mingw-target` folder of Docker Host:  

```bash
docker run --rm \
-v C:/Users/Public/Documents/boost-mingw-target:C:/target \
abrarov/boost-mingw
```
 
Use pre-downloaded source archive located at `C:\Users\Public\Documents\boost-mingw\download\boost_1_69_0.zip` file 
on Docker Host, build all combinations and put results of build into `C:\Users\Public\Documents\boost-mingw\target` 
folder of Docker Host:
 
```bash
docker run --rm \
-v C:/Users/Public/Documents/boost-mingw/target:C:/target \
-v C:/Users/Public/Documents/boost-mingw/download/boost_1_69_0.zip:C:/download/boost_1_69_0.zip \
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
