# Builder of ICU4C with Microsoft Visual C++ 2017

Docker image for building [ICU4C](http://site.icu-project.org/) with Microsoft Visual C++ 2017.

## Building

```powershell
docker build -t abrarov/icu-msvc-2017 docker/icu-msvc-2017
```

## Usage

Download source archive, build all combinations (x86, x64, shared and static libraries) and put results of build into 
`C:\Users\Public\icu-msvc-2017\target` folder of Docker Host:  

```bash
docker run --rm -v C:/Users/Public/icu-msvc-2017/target:C:/target abrarov/icu-msvc-2017
```

Download source archive, build x64 shared libraries and put results of build into `C:\Users\Public\icu-msvc-2017\target` 
folder of Docker Host:
 
```bash
docker run --rm -v C:/Users/Public/icu-msvc-2017/target:C:/target -e ICU_ADDRESS_MODEL=64 -e ICU_LINKAGE=shared abrarov/icu-msvc-2017
```
