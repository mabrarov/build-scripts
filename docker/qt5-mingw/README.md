# Builder of Qt 5.x with MinGW

Docker image for building [Qt](https://www.qt.io) 5.x with help of MinGW.

## Building

```bash
docker build -t abrarov/qt5-mingw docker/qt5-mingw
```

## Usage

todo

```bash
docker run --rm \
-v C:/Users/Public/build-scripts/qt5/target:C:/target \
-v C:/Users/Public/build-scripts/qt5/download:C:/download \
-v C:/Users/Public/build-scripts/qt5/depend:C:/depend:ro \
abrarov/qt5-mingw
```

`MAKE_OPTIONS` environment variable can be used to pass extra build options to `mingw32-make` tool, for example
to build in 4 threads:

```bash
docker run --rm \
-e MAKE_OPTIONS="-j4" \
-v C:/Users/Public/build-scripts/qt5/target:C:/target \
-v C:/Users/Public/build-scripts/qt5/download:C:/download \
-v C:/Users/Public/build-scripts/qt5/depend:C:/depend:ro \
abrarov/qt5-mingw
```
