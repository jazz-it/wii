# wii
What's In It? by Jazz
Prints a short summary of the content of any subdirectory by listing extensions and the number of files for each match. 
This project is also a demonstration for people working on `du` project to sketch a need for `--filter` parameter, where a user would be able to check the volume of certain file types within his directory tree.

Usage: 

`wii.sh [--help|-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--archive|-r] [--font|-f] [--programming|-p] [extension(s)]`

example for using a custom extension: `wii.sh mp3`
example for using multtiple extensions: `wii.sh php theme module inc js`
Extensions (mp3) and predefined parameters (--audio, --video etc.) can not be combined. Keywords have a higher priority than extension(s).
Therefore, `wii.sh -a -v` or `wii.sh -a doc` will not work, but `wii.sh mp3 doc` will work as expected.
