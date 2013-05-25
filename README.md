# swbox

A command line interface for interacting with ScraperWiki boxes.

Supports two alternative workflows, allowing you to edit files on your box using all your usual (local) applications.

1. Copying the remote box files to your local machine, then pushing changes.
2. Mounting the remote box as a local filesystem, using SSHFS.

## Examples

`swbox clone fegy5tq` – Makes a local copy of fegy5tq@box.scraperwiki.com

`swbox clone g6ut126@free` - Makes a local copy of g6ut126@free.scraperwiki.com

`swbox mount fegy5tq` - Mounts fegy5tq@box.scraperwiki.com as a local filesystem

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

#### 0.0.8 – post box

* `swbox push --preview` will show a preview of what would be created/updated/deleted, without changing anything on the remote box.

#### 0.0.7 – heart shaped box

* `<boxName>` can now include an optional `@boxServer` suffix, allowing you to clone and mount boxes on free.scraperwiki.com and ds.scraperwiki.com (eg: via `swbox clone abcd123@free` or `swbox mount wxyz789@ds`)

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
