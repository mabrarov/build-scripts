# Builder of Qt 5.x with MS Visual C++ 2017

Docker image for building [Qt](https://www.qt.io) 5.x with with Microsoft Visual C++ 2017.

## Building

```bash
docker build -t abrarov/qt5-msvc-2017 docker/qt5-msvc-2017/src
```

## Usage

todo

```bash
docker run --rm \
--storage-opt "size=200GB" \
-v C:/Users/Public/build-scripts/qt5/target:C:/target \
-v C:/Users/Public/build-scripts/qt5/download:C:/download \
-v C:/Users/Public/build-scripts/qt5/depend:C:/depend:ro \
abrarov/qt5-msvc-2017
```

`JOM_OPTIONS` environment variable can be used to pass extra build options to 
[`jom`](https://wiki.qt.io/Jom), for example to build in 4 threads:

```bash
docker run --rm \
--storage-opt "size=200GB" \
-e JOM_OPTIONS="-j4" \
-v C:/Users/Public/build-scripts/qt5/target:C:/target \
-v C:/Users/Public/build-scripts/qt5/download:C:/download \
-v C:/Users/Public/build-scripts/qt5/depend:C:/depend:ro \
abrarov/qt5-msvc-2017
```
