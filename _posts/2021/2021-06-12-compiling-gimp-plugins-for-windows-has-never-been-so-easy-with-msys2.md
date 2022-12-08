---
post_id: 5461
title: 'Compiling GIMP plugins for Windows has never been so easy with msys2'
date: '2021-06-12T17:23:44+02:00'
last_modified_at: '2021-06-12T17:23:44+02:00'
author: 'Rémi Peyronnet'
layout: post
guid: '/?p=5461'
slug: compiling-gimp-plugins-for-windows-has-never-been-so-easy-with-msys2
permalink: /2021/06/compiling-gimp-plugins-for-windows-has-never-been-so-easy-with-msys2/
image: /files/2017/10/gimp_1508001517.png
categories:
    - Informatique
tags:
    - GIMP
    - GitHub
    - Plugin
    - action
    - compilation
    - development
    - environment
    - msys2
    - pacman
lang: en
---

If you are a GIMP for Windows enthusiastic user, you may know how difficult it can be to get plugins working for the Windows version. There is no more a GIMP registry and whereas building GIMP plugins from source is very easy under Linux with gimptool, it has been for years rather difficult for Windows.

As the author of the [Fourier](/gimp_plugin_en/) GIMP plugin, I have experiences in 2002 a lot of different [compiling techniques and development environments](/2005/02/gimp_devpack_en/) but none of them was either easy or maintained through the years. And although GIMP API is pretty stable (I have nearly not modified my plugins’ code since the original version in 2002), the binaries are not, and I need to recompile my plugins each 2-3 years. And each time I nearly have to re-learn everything…

A spark of hope is coming from the msys2 environment and the gimp development package available in its package registry. If you don’t know [msys2](https://www.msys2.org/) it is a Software Distribution and Building Platform for Windows, with the aim to work as closely as possible with native Windows, unlike Cygwin. It integrates also nicely [mingw-w64](http://mingw-w64.org/) (Minimalist GNU for Windows) compiler for Windows that compiles code to native Windows executables without the need of an additional adaptation layer or DLL. It also comes with a [GitHub action](https://github.com/msys2/setup-msys2) that helps to integrate it in a continuous integration pipe.

# Use msys2 to compile GIMP plugins

First thing is to install [msys2](https://www.msys2.org/). You may use the installer available on the msys2 website, or use [scoop.sh](https://scoop.sh/) that ships also msys2 (`scoop install msys2` ).

Then you will need a compiler toolchain and the gimp library. There is two different toolchains to build 32bits or 64bits application. The 32bits one is called `mingw-w64-i686` and the 64bits one `mingw-w64-x86_64` . You will need to prefix all the packages with the one you want to use and to repeat the operations if you want both. msys2 package system use pacman package manager (Arch Linux package manager). Do not forget to also install extra libraries your plugin may need.

In msys2 shell:

```
pacman -S mingw-w64-x86_64-toolchain mingw-w64-x86_64-gimp
```

Then to build your plugin, there are two little tricks to use gimptool:

- first, you must start msys2 with the build system you want to use `msys2 -mingw32` for 32bits or `msys2 -mingw64` for 64bits
- then, for an unknown reason, gimptool adds surrounding simple quotes to your file name and you will get a file not found error (at least at the time I am writing this article, this may be fixed later) ; to cope with that, we will pile the resulting command to sh that will handle this. We can also adds extra library and compiler options that your plugin may need, for instance for the fourier plugin: `echo $(gimptool-2.0 -n –build fourier.c) -lfftw3 -O3 | sh`

If you want to integrate in a script, you may call `msys2 -c ` followed by the command line you want, and add `–noconfirm` to pacman to avoid interactive questions.

Result for 32 bits for fourier plugin:

```
msys2 -c "pacman -S --noconfirm mingw-w64-i686-toolchain"
msys2 -c "pacman -S --noconfirm mingw-w64-i686-gimp"
msys2 -c "pacman -S --noconfirm mingw-w64-i686-fftw"
msys2 -mingw32 -c 'echo $(gimptool-2.0 -n --build fourier.c) -lfftw3 -O3 | sh'
msys2 -mingw32 -c 'cp /mingw32/bin/libfftw3-3.dll .'
```

And for 64 bits for fourier plugin:

```
msys2 -c "pacman -S --noconfirm mingw-w64-x86_64-toolchain"
msys2 -c "pacman -S --noconfirm mingw-w64-x86_64-gimp"
msys2 -c "pacman -S --noconfirm mingw-w64-x86_64-fftw"
msys2 -mingw64 -c 'echo $(gimptool-2.0 -n --build fourier.c) -lfftw3 -O3 | sh'
msys2 -mingw64 -c 'cp /mingw64/bin/libfftw3-3.dll .'
```

If you want to compile for a specific GIMP version you can provide the version in the pacman command : <span class=" decode:true crayon-inline">pacman -S mingw-w64-x86\_64-gimp**=2.10.24**</span>

And if you want to get the version that was used, you can also ask pacman : `pacman -Q mingw-w64-i686-gimp | cut -d ‘ ‘ -f 2`

Many thanks to the msys2 team and the [gimp package](https://packages.msys2.org/package/mingw-w64-x86_64-gimp?repo=mingw64) maintainer (Christoph Reiter) and other upstream packages maintainers for providing a such simple GIMP plugin development environment.

# Create a GitHub action to build automatically

Since all this is pretty simple and scriptable, this may be easily integrated into a CI chain. I have tested it with GitHub actions, but it should be easily adapted to any other CI.

GitHub provides a Windows build environment ([windows-latest](https://github.com/actions/virtual-environments/blob/main/images/win/Windows2019-Readme.md)) with quite an interesting list of development tools (including Visual Studio Enterprise compiler). And msys2 provides a [GitHub action](https://github.com/msys2/setup-msys2) to improve this environment for msys2 with package caching and many other things I am not using.

Also to build 32bits and 64bits at once, you may use the strategy matrix feature. It should be possible to add multiple GIMP version builds with this feature by adding a gimpversion field to be used in pacman.

Full working example in <https://github.com/rpeyron/plugin-gimp-fourier/blob/main/.github/workflows/main.yml> ; it simply:

- set-up msys2 environment and need packages (toolchain, gimp development library)
- build the plugin (with the `| sh trick` explained above)
- package the resulting plugin and dependencies
- upload the files in a GitHub artifact with GIMP version in the name (artifacts are available in the Action workflow; they will be deleted after the retention period, so you will need to download them and create a release)

```yaml
name: CI

# Controls when the action will run. 
on:
  # Triggers the workflow on push or pull request events but only for the main branch
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

env:
  CI: true

jobs:
  win:
    strategy:
      fail-fast: false
      max-parallel: 2
      matrix:
        include: [
          {msystem: MINGW32, toolchain: mingw-w64-i686, version: x32 },
          {msystem: MINGW64, toolchain: mingw-w64-x86_64, version: x64 },
        ]
    runs-on: windows-latest
    defaults:
      run:
        shell: msys2 {0}
    steps:
    - name: Install msys2 build environment
      uses: msys2/setup-msys2@v2
      with:
        msystem: ${{ matrix.msystem }}
        update: false
        install: base-devel git ${{ matrix.toolchain }}-toolchain ${{ matrix.toolchain }}-gimp ${{ matrix.toolchain }}-fftw 
          
    - run: git config --global core.autocrlf input
      shell: bash
      
    - uses: actions/checkout@v2
    
    - name: Build plugin
      shell: msys2 {0}
      run: |
        echo $(gimptool-2.0 -n --build fourier.c) -lfftw3 -O3 | sh
        cp `which libfftw3-3.dll` .
  
    - name: Get GIMP version
      shell: msys2 {0}
      run: echo "GIMPVER=$(pacman -Q  ${{ matrix.toolchain }}-gimp | cut -d ' ' -f 2)" >> $GITHUB_ENV
        
    - uses: actions/upload-artifact@v2
      with:
        name: fourier_gimp${{ env.GIMPVER }}_${{ matrix.version }}
        path: |
          ./fourier.exe
          ./libfftw3-3.dll
```