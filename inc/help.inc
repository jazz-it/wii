What's In It? wii v2.2.2 by jazz.com+wii@gmail.com

Usage:
======
  wii [-h]                             # help
      [-a|d|e|f|i|p|r|v]               # predefined extensions
      [-x "<custom extension(s)>"]     # custom extensions
      [-c "<argument(s) for 'find'>"]  # advanced mode
      [-C|D|F|G|S|T <integer value>]   # altering defaults

Examples:
=========
wii has 3 different modes of operation which should be used independently

1) Predefined extensions:
$ wii -av
-a: audio    (mp3 flac m4a mpa aif ogg wav wma dsd dsf dff)
-d: document (doc docx xls xlsx rtf ppt pptx pps pdf csv mdb ods odp odt txt)
-e: ebook    (epub mobi azw azw3 iba pdf lrs lrf lrx fb2 djvu lit rft)
-f: font     (ttf otf fon fnt)
-i: image    (jpg jpeg png gif bmp tif tiff svg ai webp)
-p: coding   (php py c cs cpp css htm html java js theme module inc pl sh)
-r: archive  (7z rar zip arj deb tar gz z iso)
-v: video    (mp4 mov mpg mpeg mkv m4v avi 3gp 3g2 h264 wmv vob)

2) Custom extensions:
$ wii -x "bkp log tmp dmp py~"

3) Advanced mode:
$ wii -c "-type f -name '*tmp*'"
$ wii -c "-type f -mtime -7 -size +1M -name '*.log'"
$ wii -c "( -type f -size +1M -iname '*.pdf' -printf 'wii' ) -o ( -type f -size +1M -iname '*.odt' -printf 'wii' )"
Parameter of the -c flag will be passed to find directly with a single exception only:
in multiple conditions as per above example, you should always use -printf 'wii'

Altering defaults:
$ wii -D 10 -F 5 -T 20 -S 0 -avd
-C: <integer>: 0 = no colors, 1 = use colors, default: 1
-F: <integer>: maximum number of files listed per each directory, default: 10
-D: <integer>: maximum number of directories listed, default: 20
-T: <integer>: maximum number of files listed in total summary, default: 30
-G: <integer>: 0 = group by filenames, 1 = group by extensions, default: 1
-S: <integer>: 0 = don't use spinner, 1 = use spinner, default: 1
