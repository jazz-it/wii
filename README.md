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
$ mkdir "$HOME"/utils
$ cd "$HOME"/utils
$ git clone https://github.com/madjoe/wii.git
```
> Continue with step 3.

--------------

 2. **Download ZIP**
```
$ mkdir "$HOME"/utils
$ cd "$HOME"/utils
$ wget https://github.com/madjoe/wii/archive/master.zip -O wii.zip
$ unzip wii.zip
$ mv -i wii-master wii
$ rm wii.zip
```
> Continue with step 3.

--------------

 3. **Integration with shell**
```
$ OK="Installation complete!"; NOZSH="You don't use zsh. Try with the next command."; NOBASH="You don't use bash either. Please update your \$PATH manually."
$ chmod 755 "$HOME"/utils/wii/wii.sh "$HOME"/utils/wii/inc/spinner.sh
$ [ "$SHELL" = *"zsh" ] && echo "[ -d \"\$HOME\"/utils/wii ] && export PATH=\"\$HOME/utils/wii:\$PATH\"" >> "$HOME"/.zshrc && echo "$OK" || echo "$NOZSH"
$ [ "$SHELL" = *"bash" ] && echo "[ -d \"\$HOME\"/utils/wii ] && PATH=\"\$HOME/utils/wii:\$PATH\"" >> "$HOME"/.bashrc && echo "$OK" || echo "$NOBASH"
```
> If one of the last two commands returned "Installation complete!" then you have 
> successfully installed the script and you may start using it. Try: `cd && wii.sh -d`

--------------

## How do I uninstall wii.sh?

```
$ rm -rf "$HOME"/utils/wii
$ [ "$(ls -A "$HOME"/utils 2> /dev/null)" == "" ] && rm -rf "$HOME"/utils || echo "Directory ~/utils is not empty."
$ [ "$SHELL" = *"zsh" ] && nano "$HOME"/.zshrc
$ [ "$SHELL" = *"bash" ] && nano "$HOME"/.bashrc
```
> Go to the bottom of the file and delete the entire line that contains `"PATH="$HOME/utils/wii:$PATH"`
