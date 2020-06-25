# PKGBUILD

## pacman.conf

```text
[glarch]
SigLevel = Never
Server = https://gitlab.com/glatan/pkgbuild/-/raw/master/release/
Server = https://pkgbuild.glatan.vercel.app/
```

## Packages

|Name|Version|
|-|-|
|deno|1.1.1|
|numix-icon-theme|20.06.07|
|numix-icon-theme-circle|20.06.07|
|starship|0.42.0|
|ttf-cica|5.0.1|
|wasm-pack|0.9.1|
|wasmtime|0.16.0|
|yay|10.0.1|

## Makefile

%: pkgname

### p.build

Build Podman container.

### %.build

Build package.

### %.new

Init new package.

### %.updatepkgsums

Update checksums.

### check.update

Check repository-source update.

### clean

Remove untracked files.

### run.bash

Run GNU bash on Podman container.
