# wii
**What's In It?**

Prints a short summary of specific content types recursively by listing corresponding disk usage for each directory. The script will sort results by size in reverse order. If there are many directories found, the script will limit the output to top 50 largest directories.

> This project may be used as a demonstration for `du` project as a usecase for a new `--include` parameter. 
> Users would be able to measure disk usage of specific file types, which is currently not supported.

## Usage: 

```
wii.sh [--help|-h] 
       [--image|-i] 
       [--audio|-a] 
       [--video|-v] 
       [--document|-d] 
       [--ebook|-e] 
       [--archive|-r] 
       [--font|-f] 
       [--programming|-p] 
       [custom extension(s)]
```


## Examples:

Custom extension: `wii.sh php theme module inc js`

Predefined extensions: `wii.sh -a`


Custom extensions (`mp3`, `jpg`, etc.) and predefined extensions (`--audio`, `--video` etc.) can not be combined. Only custom extensions may be used multiple times if needed.

> Therefore, `wii.sh -a -v` or `wii.sh -a doc` are invalid options and as per `wii.sh -a jpg gif` 🠖 
> `jpg gif` would be ignored. Only alphanumeric, space, underscore, dash and tilde are accepted as valid characters.


## Demo:

![wii demo](https://media1.giphy.com/media/f3eRDZtNeBl39hFb50/giphy.gif)


## Installation:

 1. **Clone with GIT**
```
$ mkdir ~/utils
$ cd ~/utils
$ git clone https://github.com/madjoe/wii.git
$ chmod 755 ./wii/wii.sh ./wii/inc/spinner.sh
$ touch ~/.profile
$ echo "[ -d $HOME/utils/wii ] && PATH=\"$HOME/utils/wii:\$PATH\"" >> ~/.profile 
```
> Log out and log in again.

--------------

 2. **Download ZIP**
```
$ mkdir ~/utils
$ cd ~/utils
$ wget https://github.com/madjoe/wii/archive/master.zip -O wii.zip
$ unzip wii.zip
$ mv -i wii-master wii
$ rm wii.zip
$ chmod 755 ./wii/wii.sh ./wii/inc/spinner.sh
$ touch ~/.profile
$ echo "[ -d $HOME/utils/wii ] && PATH=\"$HOME/utils/wii:\$PATH\"" >> ~/.profile 
```
> Log out and log in again.

--------------
