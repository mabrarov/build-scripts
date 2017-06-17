# Builder of OpenSSL with Microsoft Visual C++ 2017

This docker image can be used for building of [OpenSSL](https://www.openssl.org/) with help of Microsoft Visual C++ 2017.

## Examples of usage

Download source archive, build all combinations (x86, x64, shared and static libraries) and put results of build into 
`C:\Users\Public\openssl-msvc-2017\target` folder of Docker Host:  

```bash
docker run --rm -v /C:/Users/Public/openssl-msvc-2017/target:C:/target abrarov/openssl-msvc-2017
```

Download source archive, build x64 shared libraries and put results of build into `C:\Users\Public\openssl-msvc-2017\target` 
folder of Docker Host:
 
```bash
docker run --rm -v /C:/Users/Public/openssl-msvc-2017/target:C:/target -e OPENSSL_ADDRESS_MODEL=64 -e OPENSSL_LINKAGE=shared abrarov/openssl-msvc-2017
```
