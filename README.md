# swbox

A command line interface for interacting with ScraperWiki boxes

## Features (in priority order)

* `swbox mount <boxName>` – mount a box as a drive, using `sshfs`
* `swbox unmount <boxName>` – unmount a box previously mounted using `sshfs`
* `swbox link <localDirectory> <boxName>` – pair a local directory to a box, for later syncing
* `swbox sync` (run from inside a previously `link`ed directory) – rsync directory contents up to box 