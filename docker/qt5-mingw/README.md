# Builder of Qt 5.x with MinGW

Docker image for building [Qt](https://www.qt.io) 5.x with help of MinGW.

## Building

```powershell
docker build -t abrarov/qt5-mingw docker/qt5-mingw
```

## Usage

todo

```powershell
docker run --rm -v C:/Users/Public/build-scripts/qt5/target:C:/target -v C:/Users/Public/build-scripts/qt5/download:C:/download -v C:/Users/Public/build-scripts/qt5/depend:C:/depend:ro -v C:/Users/Public/build-scripts/qt5/build:C:/build abrarov/qt5-mingw
```
