# swbox

A command line interface for interacting with ScraperWiki boxes

## Functions

`swbox mount <boxName>` – Mount `<boxName>` as an sshfs drive on your Mac
  
`swbox unmount <boxName>` – Unmount the `<boxName>` sshfs drive

`swbox clone <boxName>` – Make a local copy of the entire contents of `<boxName>`

`swbox push` (from inside a local clone) – Push changes from a local clone of a box back up to the original box

`swbox update` – Download latest version of swbox

`swbox [-v|--version]` – Show version & license info

`swbox help` – Show documentation

## Coming soon

`swbox watch` (from inside a local clone) – Synchronise changes to the local clone *as they are made*

## How to use

1. Git clone the swbox repo to somewhere safe.

    ```shell
    cd ~ # feel free to change this directory 
    git clone git://github.com/zarino/swbox.git
    cd swbox
    ```

2. Add swbox to your $PATH, so you can type "swbox" from anywhere on your filesystem.

    ```shell
    ln -s $(pwd)/swbox.coffee /usr/local/bin/swbox
    ```

3. Read the documentation by running `swbox help`

## Requirements

Mounting boxes as local drives requires **Fuse** and **SSHFS**. Both are available on the [Fuse for OS X homepage](http://osxfuse.github.com/).

The `swbox` command line client requires [Node.js](http://nodejs.org) and [CoffeeScript](http://coffeescript.org) to be installed. `swbox update` requires Git.

## Changelog

#### 0.0.6 – junction box

* `swbox sync` renamed to `swbox push` since it doesn't actually sync, it removes any files on the destination that aren't present on the local copy.
* fixed a bug that caused `swbox sync/push` to loop forever when invoked outside of a local box clone
* `swbox clone` no longer takes an optional destination directory – it will always create a clone, in new directory named after the box, in the current working directory
* removed `/swbox` symbolic link in root directory – it's no longer needed
* standardised display of required and optional arguments in help messages

#### 0.0.5 – hotbox

* `swbox sync` command to synchronise local changes inside a clone, back up to the original box

#### 0.0.4 – chocolate box

* `swbox clone` command to clone an entire box's contents to your local filesystem

#### 0.0.3 – cereal box
* added `-oworkaround=rename` to sshfs options, to allow `rsync` and `git` to rename/update files

#### 0.0.2 – cardboard box
* `swbox update` command to download the latest version of swbox

#### 0.0.1 – Initial release
* mounting and unmounting boxes as sshfs drives
* license, help and docs
