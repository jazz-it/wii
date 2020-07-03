# wii
What's In It? by Jazz

Prints a short summary of specific content types within the whole tree structure by listing corresponding disk usage for each directory. The script will sort results by size of requested data in reverse order. If there are many directories found, the script will limit the output to top 50 largest directories.

This project may be used as a demonstration for people working on `du` project as a usecase for a new `--include` parameter. Users would be able to measure disk usage of specific file types per each directory (recursively).

Usage: 

`wii.sh [--help|-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--archive|-r] [--font|-f] [--programming|-p] [extension(s)]`

example for using a custom extension: `wii.sh php theme module inc js`

example for using predefined extensions: `wii.sh -a`

Custom extensions (`mp3`, `jpg`, etc.) and predefined extensions (`--audio`, `--video` etc.) can not be combined. Only custom extensions may be used multiple times if needed.

Therefore, `wii.sh -a -v` or `wii.sh rtf -d` are invalid options and as per `wii.sh -d jpg gif` -> `jpg gif` would be ignored.


![](https://imgur.com/mVeYzWC)
