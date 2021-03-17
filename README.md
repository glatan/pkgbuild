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
|linux-ripemd|5.11.6.arch1-1|
|linux-ripemd-docs|5.11.6.arch1-1|
|linux-ripemd-headers|5.11.6.arch1-1|
|mint|0.10.0-2|
|numix-icon-theme|20.06.07-1|
|numix-icon-theme-circle|20.09.19-1|
|starship|0.50.0-1|
|ttf-cica|5.0.2-1|
|wasm-pack|0.9.1-1|
|wasmtime|0.25.0-1|
|xkcp-git|r311.574bc73-1|
|yay|10.1.2-1|

### linux-ripemd

core/linuxをベースにRIPEMD-{128, 160, 256, 320}を利用するために、以下の設定を有効にしたもの。

```
CONFIG_CRYPTO_USER=y
CONFIG_CRYPTO_USER_API=y
CONFIG_CRYPTO_USER_API_HASH=y
CONFIG_CRYPTO_USER_API_SKCIPHER=y
CONFIG_CRYPTO_USER_API_RNG=y
CONFIG_CRYPTO_USER_API_AEAD=y
CONFIG_CRYPTO_RMD128=y
CONFIG_CRYPTO_RMD160=y
CONFIG_CRYPTO_RMD256=y
CONFIG_CRYPTO_RMD320=y
```

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
