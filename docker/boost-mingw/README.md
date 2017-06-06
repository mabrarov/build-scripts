# Builder of Boost C++ Libraries with MinGW

This docker image can be used for building of Boost C++ Libraries with help of MinGW.

## Examples of usage

Download source archive, build all combinations (x86, x64, shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-mingw-target` folder of Docker Host:  

```bash
docker run --rm -v /C:/Users/Public/Documents/boost-mingw-target:C:/target abrarov/boost-mingw
```
 
Use pre-downloaded source archive located at `C:\Users\Public\Documents\boost-mingw\download\boost_1_64_0.zip` file 
on Docker Host, build all combinations and put results of build into `C:\Users\Public\Documents\boost-mingw\target` 
folder of Docker Host:
 
```bash
docker run --rm -v /C:/Users/Public/Documents/boost-mingw/target:C:/target -v /C:/Users/Public/Documents/boost-mingw/download/boost_1_64_0.zip:C:/download/boost_1_64_0.zip abrarov/boost-mingw
```

Download source archive, build all combinations for x64 platform (shared and static libraries, shared and static C/C++ runtime) 
and put results of build into `C:\Users\Public\Documents\boost-mingw\target` folder of Docker Host:

```bash
docker run --rm -v /C:/Users/Public/Documents/boost-mingw/target:C:/target -e BOOST_ADDRESS_MODEL=64 abrarov/boost-mingw
```

Download source archive, build static libraries with shared C/C++ runtime for x64 platform and put results of build into 
`C:\Users\Public\Documents\boost-mingw\target` folder of Docker Host:

```bash
docker run --rm -v /C:/Users/Public/Documents/boost-mingw/target:C:/target -e BOOST_ADDRESS_MODEL=64 -e BOOST_LINKAGE=static -e BOOST_RUNTIME_LINKAGE=shared abrarov/boost-mingw
```
