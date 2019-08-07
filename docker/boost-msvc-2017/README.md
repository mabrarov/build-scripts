# Builder of Boost C++ Libraries with MS Visual C++ 2017

Docker image for building [Boost C++ Libraries](http://www.boost.org/) with Microsoft Visual C++ 2017.

## Building

```powershell
docker build -t abrarov/boost-msvc-2017 docker/boost-msvc-2017
```

## Usage

Download source archive, build all combinations (x86, x64, shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-msvc2017-target` folder of Docker Host:  

```powershell
docker run --rm -v C:/Users/Public/Documents/boost-msvc2017-target:C:/target abrarov/boost-msvc-2017
```
 
Use pre-downloaded source archive located at `C:\Users\Public\Documents\boost-msvc-2017\download\boost_1_69_0.zip` file 
on Docker Host, build all combinations and put results of build into `C:\Users\Public\Documents\boost-msvc-2017\target` 
folder of Docker Host:
 
```powershell
docker run --rm -v C:/Users/Public/Documents/boost-msvc-2017/target:C:/target -v C:/Users/Public/Documents/boost-msvc-2017/download/boost_1_69_0.zip:C:/download/boost_1_69_0.zip abrarov/boost-msvc-2017
```

Download source archive, build all combinations for x64 platform (shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-msvc2017\target` folder of Docker Host:

```powershell
docker run --rm -v C:/Users/Public/Documents/boost-msvc2017/target:C:/target -e BOOST_ADDRESS_MODEL=64 abrarov/boost-msvc-2017
```

Download source archive, build static libraries with shared C/C++ runtime for x64 platform and put results of build into 
`C:\Users\Public\Documents\boost-msvc2017\target` folder of Docker Host:

```powershell
docker run --rm -v C:/Users/Public/Documents/boost-msvc2017/target:C:/target -e BOOST_ADDRESS_MODEL=64 -e BOOST_LINKAGE=static -e BOOST_RUNTIME_LINKAGE=shared abrarov/boost-msvc-2017
```
