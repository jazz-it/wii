# wii
What's In It? by Jazz

Prints a short summary of specific content types recursively by listing corresponding disk usage for each directory. The script will sort results by size in reverse order. If there are many directories found, the script will limit the output to top 50 largest directories.

This project may be used as a demonstration for `du` project as a usecase for a new `--include` parameter. Users would be able to measure disk usage of specific file types, which is currently not supported.

Usage: 

`wii.sh [--help|-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--archive|-r] [--font|-f] [--programming|-p] [extension(s)]`


## Examples:

Custom extension: `wii.sh php theme module inc js`

Predefined extensions: `wii.sh -a`



Custom extensions (`mp3`, `jpg`, etc.) and predefined extensions (`--audio`, `--video` etc.) can not be combined. Only custom extensions may be used multiple times if needed.

Therefore, `wii.sh -a -v` or `wii.sh -a doc` are invalid options and as per `wii.sh -a jpg gif` -> `jpg gif` would be ignored. Only alphanumeric, space, underscore, dash and tilda are accepted as valid custom extensions.


![wii demo](https://media1.giphy.com/media/f3eRDZtNeBl39hFb50/giphy.gif)


## Installation:

 - Clone with GIT
```
$ mkdir ~/scripts
$ cd ~/scripts
$ git clone https://github.com/madjoe/wii.git
$ touch ~/.profile
$ echo "[ -d ~/scripts/wii ] && PATH=\"~/scripts/wii:\$PATH\"" >> ~/.profile 
```
Log out and log in again.

--------------

  - Download ZIP
```
$ mkdir ~/scripts
$ cd ~/scripts
$ wget https://github.com/madjoe/wii/archive/master.zip -O wii.zip
$ unzip wii.zip
$ mv -i wii-master wii
$ rm wii.zip
$ touch ~/.profile
$ echo "[ -d ~/scripts/wii ] && PATH=\"~/scripts/wii:\$PATH\"" >> ~/.profile 
```
Log out and log in again.
