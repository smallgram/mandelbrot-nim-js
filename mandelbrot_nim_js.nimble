# import nimscript
# Package
mode = ScriptMode.Verbose

version       = "0.1.0"
author        = "smallgram"
description   = "mandelbrot set implementation in nim with html5 canvas backend"
license       = "MIT"
srcDir        = "src"
namedBin      = {"mandelbrot_nim_js": "mb.js"}.toTable()
binDir        = "bin"

backend       = "js"

# Dependencies

requires "nim >= 0.20.2"
requires "html5_canvas >= 1.3"

before build:
    echo("checking for bin dir")

    # make sure that the "bin" directory exists
    if not dirExists("bin"):
        echo("created bin dir")
        mkDir("bin")

    # exec("nimble build")

    # exec("start index.html")
