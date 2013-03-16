# swbox

A command line interface for interacting with ScraperWiki boxes

## Requirements

Mounting boxes as local drives requires **Fuse** and **SSHFS**. Both are available on the [Fuse for OS X homepage](http://osxfuse.github.com/)

The `swbox` command line client requires [Node.js](http://nodejs.org) and [CoffeeScript](http://coffeescript.org) to be installed.

## How to use

1. Git clone this repo and put it somewhere safe.

2. Add swbox to your $PATH by running this from inside the repo: `ln -s $(pwd)/swbox.coffee /usr/local/bin/swbox`

3. Read the documentation by running `swbox help`

## Coming soon

* Tab-completion of commands
* Tab-completion of boxNames (based on previously-mounted boxNames)
* `swbox link <localDirectory> <boxName>` – pair a local directory to a box, for later syncing
* `swbox sync` (run from inside a previously `link`ed directory) – rsync directory contents up to box

## Changelog

#### 0.0.3
* added `-oworkaround=rename` to sshfs options, to allow `rsync` and `git` to rename/update files

#### 0.0.2
* `swbox update` command to download the latest version of swbox

#### 0.0.1 – Initial release
* mounting and unmounting boxes as sshfs drives
* license, help and docs
