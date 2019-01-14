# Package

version       = "0.1.0"
author        = "nepeckman"
description   = "A serving file editor"
license       = "AGPL-3.0-or-later"
srcDir        = "src"
bin           = @["dew"]


# Dependencies

requires "nim >= 0.19.9"
requires "jester 0.4.1"
requires "cligen 0.9.18"
requires "karax 1.0.0"

proc folderSetup() =
  mkdir("./build")
  mkdir("./build/client")
  mkdir("./build/server")
  exec "chmod o+r ./build/client"

proc devClient() =
  folderSetup()
  exec "touch src/client/main.nim"
  exec "./node_modules/.bin/parcel build src/client/index.html --no-source-maps -d build/client --public-url ./client"

proc devServer() =
  exec "rm -rf ./build"
  folderSetup()
  if not existsFile("./build/client/index.html"):
    devClient()
  exec "nimble c -o:build/server/dew src/dewdrop.nim"

proc prodServer() =
  folderSetup()
  devClient()
  exec "nimble c -o:build/server/dew -d:release src/dewdrop.nim"

task devClient, "Builds client code":
  devClient()

task devServer, "Builds the server":
  devServer()

task dev, "Builds the project":
  devClient()
  devServer()

task prod, "Builds the project":
  prodServer()

task clean, "Remove build folder":
  exec "rm -rf ./build"

task run, "Run dewdrop":
  exec "./build/server/dew testfiles/test.js"
