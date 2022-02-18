# wii
**What's In It?**

Prints a short summary of specific content types recursively by listing corresponding disk usage per each directory. The script will print results grouped by extensions or by actual file names - ordered by size in reverse order. If you run the script without any arguments and if many directories are found, the output will be truncated to top 20 largest directories (by default), but this could be overriden easily by setting the appropriate parameter.

> This project may be used as a demonstration for `du` project as a usecase for a new `--include` parameter.
> Users would be able to measure disk usage of specific file types, which is currently not supported.

## Usage:

```
wii [-h]                             # help
    [-a|d|e|f|i|p|r|v]               # mode 1: predefined extensions
    [-x "<custom extension(s)>"]     # mode 2: custom extensions
    [-c "<argument(s) for `find`>"]  # mode 3: advanced mode
    [-C|D|F|G|M|S|T <integer value>]   # altering defaults
```

***wii has 3 different modes of operation which should be used independently:***
We use the optional `-F2 -D3 -T3` flags just for purposes of the demo below (to make results entirely visible on screen).\
It overrides the defaults: `-F10 -D20 -T30`.\
`F`=Files, `D`=Directories, `T`=Total files. See [Altering defaults](#altering-defaults-optional).

## Demo:

### 1) Predefined extensions:
![wii v2.2.x predefined extensions demo](https://media1.giphy.com/media/lOOmNP1azjZREzlp8b/giphy.gif)
```
$ wii -av
```
> `-a`: audio    (`mp3 flac m4a mpa aif ogg wav wma dsd dsf dff`)\
> `-d`: document (`doc docx xls xlsx rtf ppt pptx pps pdf csv mdb ods odp odt txt`)\
> `-e`: ebook    (`epub mobi azw azw3 iba pdf lrs lrf lrx fb2 djvu lit rft`)\
> `-f`: font     (`ttf otf fon fnt`)\
> `-i`: image    (`jpg jpeg png gif bmp tif tiff svg ai webp`)\
> `-p`: coding   (`php py c cs cpp css htm html java js theme module inc pl sh`)\
> `-r`: archive  (`7z rar zip arj deb tar gz z iso`)\
> `-v`: video    (`mp4 mov mpg mpeg mkv m4v avi 3gp 3g2 h264 wmv vob`)\
> You may combine the flags e.g. `wii -ie`, for listing all image and ebook files.

### 2) Custom extensions:
![wii v2.2.x custom extensions demo](https://media3.giphy.com/media/f5wR72IruPEP9ylJ5i/giphy.gif)
```
$ wii -x "bkp log tmp dmp py~"
```
> In case you don't find predefined extensions fit for the job, you could
> manually enter as many keywords as you like, using a whitespace as a delimiter.\
> Note: you should avoid using commas, or leading dots in front of each extension.

### 3) Advanced mode:
![wii v2.2.x advanced mode demo](https://media2.giphy.com/media/jOyxiOXaKIB8VB31PO/giphy.gif)
```
$ wii -c "-type f -iname '*.txt'"
$ wii -c "-type f -mtime -7 -size +2M -name '*log*'"
$ wii -c "\( -type f -iname '*.pdf' -printf 'wii' \) -o \( -type f -iname '*.doc*' -printf 'wii' \)"
```
> **Important**: Parameter of the `-c` flag will be passed to `find` with a few modifications:\
> in multiple conditions as per above example, you should use `-printf 'wii'` for each multi-condition.\
> The parameter for `-c` flag should contain almost everything that you would normally put into `<arguments>` as per
> `find <path> <arguments>`. However, it's crucial to know that **`wii` requires an exact format of an output
> from `find`**. At first, it will try to replace automatically all existing occurrences of `-printf 'something'`
> with the appropriate format. Then it will search for all `printf` and if it doesn't find any, `wii` will
> append the required `-printf` to the very end of the parameter.

[**find**](https://man7.org/linux/man-pages/man1/find.1.html) - check the syntax of `find` and apply the important notes from above accordingly


In case you accidentally mix the 3 modes of operation from above, `wii` will follow the order below and always favor the highest priority only:
 - `HIGH`: Advanced mode
 - `MEDIUM`: Custom extensions
 - `LOW`: Predefined extensions

### Altering defaults (optional):
```
$ wii -C 0 -D 10 -F 0 -T 5 -S 0 -avd
```
> `-C`: integer: `0` = no colors, `1` = use colors, `default: 1`\
> `-G`: integer: `0` = group by filenames, `1` = group by extensions, `default: 1`\
> `-F`: integer: maximum number of largest items listed per each directory, `default: 10`\
> `-M`: integer: maxdepth value (0=unlimited depth, 1=current dir only) , `default: 0`\
> `-D`: integer: maximum number of directories listed, `default: 20`\
> `-T`: integer: maximum number of largest items listed in total summary, `default: 30`\
> `-S`: integer: `0` = don't use a spinner, `1` = use spinner, `default: 1`


## Advanced Examples

```
$ wii -x "jpg png mp4" -M 1
```
> Common example when you need to lock your query to the current directory only (-maxdepth=1).


```
$ wii -c "\( -type f -iname '*.tmp' -printf 'wii' \) -o \( -type f -iname '*~' -printf 'wii' \)" -G 1 -D 5 -F 1 -T 3
[592.5KB] Documents/Bookstore/temp/shared/common/includes/sys
        1 tmp
[ 64.5KB] Documents/Books/Python Workout/code/chapter 10
       17 py~
[ 56.5KB] Documents/Books/Python Workout/code/chapter 09
       14 py~
[ 56.5KB] Documents/Books/Python Workout/code/chapter 07
       14 py~
[ 40.5KB] .gnupg
        1 kbx~
———————————————
[996.5KB] total
       96 py~
        1 tmp
        1 kbx~
```
> `-G 1`: group results by extensions\
> `-D 5`: list max. 5 largest directories\
> `-F 1`: list max. 1 largest files (by extensions) per each directory\
> `-T 3`: list max. 3 largest accumulated file sizes (by extensions) in total summary


```
$ wii -C 0 -G 1 -D 0 -F 0 -T 5 -S 0 -avd
———————————————
[36.43GB] total
     4672 txt
      512 mp4
      354 pdf
      333 mp3
      138 csv
```
> `-C 0`: don't use colors for output\
> `-G 1`: group results by extensions\
> `-D 0`: don't list directories\
> `-F 0`: don't list files (by extensions) per each directory\
> `-T 5`: list max. 5 largest accumulated file sizes (by extensions) in total summary\
> `-S 0`: don't use spinner\
> `-avd`: list all audio, video and document files


```
$ wii -C 0 -G 0 -D 0 -F 0 -T 5 -S 0 -avd
———————————————
[36.43GB] total
  1.542GB project_yachts_intro.m4v (1)
  476.4MB 20190527_120808.mp4 (1)
  465.2MB 20200322_101232.mp4 (2)
    322MB 20200101_000948.mp4 (2)
  310.6MB 20200701_164008.mp4 (1)
```
> Similar as per previous example, only one parameter has been changed:\
> `-G 0`: group results by filenames\
> We may notice there are multiple files found within the structure that use the same filename.


```
$ wii -D 5 -F 3 -T 4 -c "-type f -mtime -7 -iname '*log*'"
[12.89MB] .config/chromium/Profile 1/Local Extension Settings/gighmnpiopklfepjosnamgckbiglidom
  12.88MB 041367.log
    8.5KB LOG
    4.5KB LOG.old
[4.984MB] .local/share/TelegramDesktop/tdata/user_data/cache/0
  4.984MB binlog
[ 3.25MB] .config/Rambox/Partitions/whatsapp_1/IndexedDB/https_web.whatsapp.com_0.indexeddb.leveldb
  3.238MB 013778.log
    8.5KB LOG
    4.5KB LOG.old
[2.898MB] .config/chromium/Profile 1/Local Extension Settings/ghbmnmjobekpmoecnmnilmnbdlolhkhi
  2.891MB 000007.log
    4.5KB LOG.old
    4.5KB LOG
[2.684MB] .config/chromium/Profile 1/Extension State
  2.676MB 007638.log
    4.5KB LOG.old
    4.5KB LOG
———————————————
[34.62MB] total
  12.88MB 041367.log (1)
  6.941MB 000007.log (24)
  5.164MB binlog (2)
  3.238MB 016779.log (1)
```
> `-D 5`: list max. 5 largest directories\
> `-F 3`: don't list files (by extensions) per each directory\
> `-T 4`: list max. 4 largest accumulated files (by filenames) in total summary\
> `-c`: custom arguments for find: list all files that are at least 7 days old and contain *log* in their names\
> Note '-G 0' was not set explicitly, but it will be the default for advanced mode of operation (-c), unless we set it to '-G 1'.


## Dependencies:

[**gawk**](https://opensource.com/article/18/8/how-install-software-linux-command-line) - you need to have it installed prior proceeding with installation of `wii`


## Installation:

 1. **Clone with GIT**
```
$ mkdir "$HOME"/utils
$ cd "$HOME"/utils
$ git clone https://github.com/jazz-it/wii.git
```
> If successful, skip the next step and continue with `step 3`.

--------------

 2. **Download ZIP**
```
$ mkdir "$HOME"/utils
$ cd "$HOME"/utils
$ wget https://github.com/jazz-it/wii/archive/master.zip -O wii.zip
$ unzip wii.zip
$ mv -i wii-master wii
$ rm wii.zip
```
> Continue with `step 3`.

--------------

 3. **Integration with shell**
```
$ OK="Installation complete!"; NOZSH="You don't use zsh. Try with the next command."; NOBASH="You don't use bash either. Please update your \$PATH manually."
$ chmod 755 "$HOME"/utils/wii/wii "$HOME"/utils/wii/inc/spinner.sh
$ [ "$SHELL" = *"zsh" ] && echo "[ -d \"\$HOME\"/utils/wii ] && export PATH=\"\$HOME/utils/wii:\$PATH\"" >> "$HOME"/.zshrc && echo "$OK" && source "$HOME"/.zshrc || echo "$NOZSH"
$ [ "$SHELL" = *"bash" ] && echo "[ -d \"\$HOME\"/utils/wii ] && PATH=\"\$HOME/utils/wii:\$PATH\"" >> "$HOME"/.bashrc && echo "$OK" && source "$HOME"/.bashrc || echo "$NOBASH"
```
> If one of the last two commands returned "Installation complete!" then you have
> successfully installed the script and you may start using it. Try: `cd && wii`

--------------

## Be up-to-date with the newest version
```
$ cd "$HOME"/utils/wii && git pull origin master
$ [ "$SHELL" = *"zsh" ] && echo "$OK" && source "$HOME"/.zshrc
$ [ "$SHELL" = *"bash" ] && echo "$OK" && source "$HOME"/.bashrc

```

## How do I uninstall `wii`?

```
$ rm -rf "$HOME"/utils/wii
$ [ "$(ls -A "$HOME"/utils 2> /dev/null)" == "" ] && rm -rf "$HOME"/utils || echo "Directory ~/utils is not empty."
$ [ "$SHELL" = *"zsh" ] && nano "$HOME"/.zshrc
$ [ "$SHELL" = *"bash" ] && nano "$HOME"/.bashrc
```
> Go to the bottom of the file and delete the entire line that contains `"PATH="$HOME/utils/wii:$PATH"`
