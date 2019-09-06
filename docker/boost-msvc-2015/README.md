# Builder of Boost C++ Libraries with MS Visual C++ 2015

Docker image for building [Boost C++ Libraries](http://www.boost.org/) with Microsoft Visual C++ 2015.

## Building

```bash
docker build -t abrarov/boost-msvc-2015 docker/boost-msvc-2015/src
```

## Usage

Download source archive, build all combinations (x86, x64, shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-msvc-2015-target` folder of Docker Host:  

```bash
docker run --rm \
-v C:/Users/Public/Documents/boost-msvc-2015-target:C:/target \
abrarov/boost-msvc-2015
```
 
Use pre-downloaded source archive located at `C:\Users\Public\Documents\boost-msvc-2015\download\boost_1_69_0.zip` file 
on Docker Host, build all combinations and put results of build into `C:\Users\Public\Documents\boost-msvc-2015\target` 
folder of Docker Host:
 
```bash
docker run --rm \
-v C:/Users/Public/Documents/boost-msvc-2015/target:C:/target \
-v C:/Users/Public/Documents/boost-msvc-2015/download/boost_1_69_0.zip:C:/download/boost_1_69_0.zip \
abrarov/boost-msvc-2015
```

Download source archive, build all combinations for x64 platform (shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-msvc2015\target` folder of Docker Host:

```bash
docker run --rm \
-e BOOST_ADDRESS_MODEL=64 \
-v C:/Users/Public/Documents/boost-msvc2015/target:C:/target \
abrarov/boost-msvc-2015
```

Download source archive, build static libraries with shared C/C++ runtime for x64 platform and put results of build into 
`C:\Users\Public\Documents\boost-msvc2015\target` folder of Docker Host:

```bash
docker run --rm \
-e BOOST_ADDRESS_MODEL=64 \
-e BOOST_LINKAGE=static \
-e BOOST_RUNTIME_LINKAGE=shared \
-v C:/Users/Public/Documents/boost-msvc2015/target:C:/target \
abrarov/boost-msvc-2015
```
