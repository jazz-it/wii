# wii
What's In It? by Jazz

Prints a short summary of any given content types within tree structure by listing number of files that match your search for each directory. The script will sort results by size of requested data in reverse order.

This project is also a demonstration for people working on `du` project to sketch a need for `--filter` parameter, where a user would be able to check the volume of certain file types within his directory tree.

Usage: 

`wii.sh [--help|-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--archive|-r] [--font|-f] [--programming|-p] [extension(s)]`

example for using a custom extension: `wii.sh mp3`

example for using multtiple extensions: `wii.sh php theme module inc js`

Extensions (mp3) and predefined parameters (`--audio`, `--video` etc.) may not be combined with either other predefined parameters or keywords. Only extensions alone could be added multiple times if needed.

Therefore, `wii.sh -a -v` or `wii.sh -a doc` will not work, but i.e. `wii.sh mp3 wav m4a` or `wii.sh -a` should work as expected.
