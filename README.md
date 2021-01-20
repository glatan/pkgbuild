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
|mint|0.10.0-2|
|numix-icon-theme|20.06.07-1|
|numix-icon-theme-circle|20.09.19-1|
|starship|0.48.0-1|
|ttf-cica|5.0.2-1|
|wasm-pack|0.9.1-1|
|wasmtime|0.22.1-1|
|xkcp-git|r311.574bc73-1|
|yay|10.1.2-1|

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
