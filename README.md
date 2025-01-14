# odin-freetype
[Odin](https://github.com/odin-lang/Odin) bindings for [FreeType](https://www.freetype.org/index.html).

Freetype Version: 2.13.2

_**Note:** This is a work in progress. If additional bindings are required, please feel free to submit an issue or a pull request._

## Installation
Download this project and include it in your project

```bash
git clone https://github.com/dmitsuki/odin-freetype.git freetype
```

## Usage
Include folder for the pckage in your project and import the package.
```c
import "/freetype"
```

## Demo
The demo simply generates a bitmap using freetype and display it with raylib
```bash
cd demo
odin run .\
```