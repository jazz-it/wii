#!/bin/bash
# What's In It? by Jazz v2.0.1
# Prints a short summary of the content of any directory by listing extensions and the number of files for each type found

color=False
me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$DIR/inc/spinner.sh" 2> /dev/null
shopt -s extglob # enable extglob whilst running the script in non-interactive shell (enabled by default for interactive one)!

# check if stdout is a terminal...
if test -t 1; then

    # see if it supports colors...
    ncolors=$(tput colors)

    if test -n "$ncolors" && test $ncolors -ge 8; then
        color=True
    fi
fi

# helper function for _wii_core(): constructing crucial parts of find command
_wii_set_bundle() {
if [ ! -z "${1}" ]
then
  bundle="\\( -type f -iname \"*.${1//+( )/\" -printf "'"%D:%i\\0%b\\0%h\\0%f\\0"'" \\) -o \\( -type f -iname \"*.}\" -printf '%D:%i\0%b\0%h\0%f\0' \\)" # extglob "+( )"
fi
}


# Main function
_wii_core() {
bundle=0
local s="${1:-0}"            # parameters
local desc=""                # description of predefined extensions
local help=0                 # counter of matching directories that contain the queried file type(s)
local start=$(date +%s)      # start measuring elapsed time

ss=${s//[^[:alnum:] _\-~]/}  # sanitize user's input

if [ "${ss}" != "${s}" ]
then
  printf "%s: invalid characters -- '%s'\n" "${me}" "${s}"
  printf "Try '%s --help' for more information.\n" "${me}"
  return 0
fi

case $s in

  0)
    desc=""
    bundle="\\( -type f -iname \"*.*\" -printf '%D:%i\0%b\0%h\0%f\0' \\)"
    ;;

  --help | -h)
    help=1 # Don't display a summary
    echo "What's In It? wii v2.0.1 by Jazz"
    echo
    echo "Usage:"
    echo "======"
    echo "wii.sh [-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--ebook|-e] [--archive|-r] [--font|-f] [--programming|-p] [custSom extension(s)]"
    echo
    echo "Examples:"
    echo "========="
    echo "Custom extension: wii.sh php theme module inc js"
    echo "Predefined extensions: wii.sh -a"
    echo
    echo "Custom extensions (mp3, jpg, etc.) and predefined extensions (--audio, --video etc.) can not be combined."
    echo "Therefore, 'wii.sh -a -v' or 'wii.sh -a doc' are invalid options and as per 'wii.sh -a jpg gif' -> 'jpg gif' would be ignored. Only alphanumeric, space, underscore, dash and tilde are accepted as valid custom extensions."
    ;;

  --image | -i)
    desc=" common image"
    bundle="jpg jpeg png gif bmp tif tiff svg ai webp"
    _wii_set_bundle "${bundle}"
    ;;

  --audio | -a)
    desc=" common audio"
    bundle="mp3 flac m4a mpa aif ogg wav wma dsd dsf dff"
    _wii_set_bundle "${bundle}"
    ;;

  --video | -v)
    desc=" common video"
    bundle="mp4 mov mpg mpeg mkv m4v avi 3gp 3g2 h264 wmv vob"
    _wii_set_bundle "${bundle}"
    ;;

  --document | -d)
    desc=" common document"
    bundle="doc docx xls xlsx rtf ppt pptx pps pdf csv mdb ods odp odt txt"
    _wii_set_bundle "${bundle}"
    ;;

  --ebook | -e)
    desc=" common ebook"
    bundle="epub mobi azw azw3 iba pdf lrs lrf lrx fb2 djvu lit rft"
    _wii_set_bundle "${bundle}"
    ;;

  --archive | -r)
    desc=" common archive"
    bundle="7z rar zip arj deb tar gz z iso"
    _wii_set_bundle "${bundle}"
    ;;

  --font | -f)
    desc=" common font"
    bundle="ttf otf fon fnt"
    _wii_set_bundle "${bundle}"
    ;;

  --programming | -p)
    desc=" common programming"
    bundle="php py css htm html js theme module inc sh"
    _wii_set_bundle "${bundle}"
    ;;

  *)
    args=$@
    desc=""
    bundle="${args[*]}"
    if [ "$(grep -c "\w*\-\w*" <<< "${bundle}")" == 0 ]  # check if user is mixing predefined extensions with custom ones
    then
      _wii_set_bundle "${bundle}"
    else
      printf "%s: invalid option -- '%s'\n" "${me}" "${bundle}"
      printf "Try '%s --help' for more information.\n" "${me}"
      return 0
    fi
    ;;
esac

if [ "$help" != 1 ] # don't proceed if we printed help
then
  LC_ALL=C eval "find . ${bundle}" | gawk -v desc="${desc}" -v color="${color}" -v 'RS=\0' -v OFS='\t' -v max=50 '
    BEGIN {
      if (! color) {
        red=""
        lightred=""
        lightcyan=""
        nc=""
      } else {
        red="\033[0;31m"
        lightred="\033[2;91m"
        lightcyan="\033[0;96m"
        nc="\033[0m"
      }
    }
    function human(x) {
        if (x<1000) {return x} else {x/=1024}
        s="KMGTEPZY";
        while (x>=1000 && length(s)>1)
            {x/=1024; s=substr(s,2)}
        return sprintf("%5.4g",x+0.5) nc lightred substr(s,1,1) "B"
    }
    {
      inum = $0
      getline du
      getline dir
      getline file
      pos=match(file, "\\.[^\\/\\\\:\\.]+$")
      if(pos != 0) {
        ext=substr(file,pos+1)
      }
    }
    ! seen[inum]++ {
      gsub(/\\/, "&&", dir)
      gsub(/\n/, "\\n", dir)
      total += du
      sum[dir] += du
      cnt[dir][ext]++
      extensions[ext]++
    }
    END {
      n = 0
      PROCINFO["sorted_in"] = "@val_num_desc"
      for (dir in sum) {
        m = 0
        printf "%s[%s%s] %s%s%s\n", lightred, red, human(sum[dir] * 512), lightcyan, gensub(/^\.\//, "", "g", dir), nc
        for (ext in cnt[dir]) {
          printf "%9g %s\n", cnt[dir][ext], ext
          if (++m >= max) break
        }
        if (++n >= max) break
      }
      if (total > 0 && length(sum) > 1) {
        n = 0
        print "———————————————"
        printf "%s[%s%s] %stotal%s\n", lightred, red, human(total * 512), lightred, nc
        for (ext in extensions) {
          printf "%9g %s\n", extensions[ext], ext
          if (++n >= max) break
        }
      } else if (total > 0 && length(sum) == 1) {
      } else {
        printf "%sNo%s files found.%s\n", red, desc, nc
      }
    }'
fi
end=$(date +%s)
runtime=$((end-start))
[ "${runtime}" -gt 9 ] && printf "\nElapsed time: %dh:%dm:%ds\n" $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60))
}


# Wrapper
# Check if the spinner function exists (bash specific)
if declare -f "spinner" > /dev/null && [ "${1}" != "-h" ] && [ "${1}" != "--help" ]
then
  # Call _wii_core in the background with the same arguments, call the spinner
  set +m
  _wii_core "$@" &
  pid=$!
  spinner $pid
  set -m
else
  # Avoid spinner
  _wii_core "$@"
fi
