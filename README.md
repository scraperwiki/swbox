# swbox

A command line interface for interacting with ScraperWiki boxes

## Functions

`swbox mount <boxName>` – Mount `<boxName>` as an sshfs drive on your Mac
  
`swbox unmount <boxName>` – Unmount the `<boxName>` sshfs drive 

`swbox update` – Download latest version of swbox

`swbox [-v|--version]` – Show version & license info

`swbox help` – Show documentation

## Coming soon

`swbox clone <boxName>` – Make a local copy of the entire contents of `<boxName>`

`swbox sync` (from inside a local clone) – Synchronise the local clone with the original box

## How to use

1. Git clone this repo and put it somewhere safe.

2. Add swbox to your $PATH by running this from inside the repo: `ln -s $(pwd)/swbox.coffee /usr/local/bin/swbox`

3. Read the documentation by running `swbox help`

## Requirements

Mounting boxes as local drives requires **Fuse** and **SSHFS**. Both are available on the [Fuse for OS X homepage](http://osxfuse.github.com/)

The `swbox` command line client requires [Node.js](http://nodejs.org) and [CoffeeScript](http://coffeescript.org) to be installed.

## Changelog

#### 0.0.3
* added `-oworkaround=rename` to sshfs options, to allow `rsync` and `git` to rename/update files

#### 0.0.2
* `swbox update` command to download the latest version of swbox

#### 0.0.1 – Initial release
* mounting and unmounting boxes as sshfs drives
* license, help and docs
