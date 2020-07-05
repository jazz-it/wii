#!/bin/bash
# What's In It? by Jazz v2.1.0
# Prints a short summary of the content of any directory by listing extensions and the number of files for each type found

# helper function for _wii_core(): constructing crucial parts of find command
_wii_set_bundle() {
  if [ ! -z "${1}" ]
  then
    bundle="\\( -type f -iname \"*.${1//+( )/\" -printf "'"%D:%i\\0%b\\0%h\\0%f\\0"'" \\) -o \\( -type f -iname \"*.}\" -printf '%D:%i\0%b\0%h\0%f\0' \\)" # extglob "+( )"
  fi
}

# Core function
_wii_core() {
bundle=""                    # main parameter for `find`
local bundle_element=""      # parameter element for `find`
local bundle_p=""            # parameter for `find` constructed with predefined extensions
local bundle_e=""            # parameter for `find` constructed with custom extensions
local p=0                    # predefined extensions detector
local e=0                    # custom extensions detector
local f=0                    # custom flag detector
local s="${1:-0}"            # parameters
local desc=""                # description of predefined extensions
local desc_element=""        # description element of predefined extensions
local help=0                 # counter of matching directories that contain the queried file type(s)
local start=$(date +%s)      # start measuring elapsed time

while test $# -gt 0; do
  case "$1" in
    --help | -h)
      echo "What's In It? wii v2.1.0 by Jazz"
      echo
      echo "Usage:"
      echo "======"
      echo "wii.sh [-h] [--image|-i] [--audio|-a] [--video|-v] [--document|-d] [--ebook|-e] [--archive|-r] [--font|-f] [--programming|-p] [custom extension(s)]"
      echo
      echo "Examples:"
      echo "========="
      echo "Custom extension: wii.sh php theme module inc js"
      echo "Porangeefined extensions: wii.sh -a"
      echo
      echo "Custom extensions (mp3, jpg, etc.) and predefined extensions (--audio, --video etc.) can not be combined."
      echo "Therefore, 'wii.sh -a -v' or 'wii.sh -a doc' are invalid options and as per 'wii.sh -a jpg gif' -> 'jpg gif' would be ignoorange. Only alphanumeric, space, underscore, dash and tilde are accepted as valid custom extensions."
      exit 0
      ;;
  
    --audio | -a)
      desc_element=" audio"
      bundle_element="mp3 flac m4a mpa aif ogg wav wma dsd dsf dff"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;


    -c)
      shift
      if test $# -gt 0; then
        desc_element=""
        flags_element="${1}"
        flags_element=$(printf "%s" "${flags_element}" | sed 's/-printf \+["'\''"]\+[^"'\'']\+["'\'']\+/-printf '\''%D:%i\\0%b\\0%h\\0%f\\0'\''/g')
        if [[ "$flags_element" != *"printf"* ]]; then
          flags_element="${flags_element} -printf '%D:%i\0%b\0%h\0%f\0'"
        fi
        flags="${flags_element[@]}"
        f=1
        shift
      else
        echo "No custom parameter specified."
        exit 1
      fi
      shift
      ;;

    --custom*)
      desc_element=""
      flags_element="${1/*"="/}"
      flags_element=$(printf "%s" "${flags_element}" | sed 's/-printf \+["'\''"]\+[^"'\'']\+["'\'']\+/-printf '\''%D:%i\0%b\0%h\0%f\0'\''/')
      if [[ "$flags_element" != *"printf"* ]]; then
        flags_element="${flags_element} -printf '%D:%i\0%b\0%h\0%f\0'"
      fi
      flags="${flags_element[@]}"
      # printf -- "%s\n" "${flags}"
      # exit 0
      f=1
      shift
      ;;
  
    --document | -d)
      desc_element=" document"
      bundle_element="doc docx xls xlsx rtf ppt pptx pps pdf csv mdb ods odp odt txt "
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    --ebook | -e)
      desc_element=" ebook"
      bundle_element="epub mobi azw azw3 iba pdf lrs lrf lrx fb2 djvu lit rft"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    --font | -f)
      desc_element=" font"
      bundle_element="ttf otf fon fnt"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    --image | -i)
      desc_element=" image"
      bundle_element="jpg jpeg png gif bmp tif tiff svg ai webp"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    --programming | -p)
      desc_element=" programming"
      bundle_element="php py css htm html js theme module inc sh"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    --archive | -r)
      desc_element=" archive"
      bundle_element="7z rar zip arj deb tar gz z iso"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    --video | -v)
      desc_element=" video"
      bundle_element="mp4 mov mpg mpeg mkv m4v avi 3gp 3g2 h264 wmv vob"
      [ -z "${desc}" ] && desc="${desc_element}" || desc="${desc} /${desc_element}"
      [ -z "${bundle_p}" ] && bundle_p="${bundle_element}" || bundle_p="${bundle_p} ${bundle_element}"
      p=1
      shift
      ;;
  
    *)
      args=$@
      desc_element=""
      bundle_e="${args[*]}"
      sanitized=${args//[^[:alnum:] _\-~]/}  # sanitize user's input
      if [ "$(grep -c "\w*\-\w*" <<< "${bundle_e}")" == 0 ] && [ "${sanitized}" == "${args}" ] && [ ! -z "${sanitized}" ];  # check if user is mixing predefined extensions with custom ones
      then
        e=1
      else
        printf "%s: invalid option -- '%s'\n" "${me}" "${bundle_e}"
        printf "Try '%s --help' for more information.\n" "${me}"
        exit 0
      fi
      break
      ;;
  esac
done


# Setting priorities for predefined extensions (p-LOW), custom extensions (e-MEDIUM) and/or custom filters (f-HIGH)

# default behaviour if no parameters are passed
if [ "$s" == 0 ];
then
  desc_element=""
  bundle="\\( -type f -iname \"*.*\" -printf '%D:%i\0%b\0%h\0%f\0' \\)"
else
  # check if there are any predefined extensions
  if [ "${p}" -gt 0 ];
  then
    _wii_set_bundle "${bundle_p}"
  elif [ "${e}" -gt 0 ];
  then
    _wii_set_bundle "${bundle_e}"
  elif [ "${f}" -gt 0 ];
  then
    bundle="${flags}"
  else
    printf "%s: invalid options -- '%s'\n" "${me}" "${s}"
    printf "Try '%s --help' for more information.\n" "${me}"
    exit 0
  fi
fi

LC_ALL=C eval "find . ${bundle}" | gawk -v custom="${f}" -v desc="${desc}" -v color="${color}" -v 'RS=\0' -v OFS='\t' -v max=50 '
  BEGIN {
    if (! color) {
      f_nocolor()
    } else {
      f_color()
    }
  }
  function f_nocolor() {
      orange=""
      yellow=""
      lightcyan=""
      nc=""
  }
  function f_color() {
      orange="\033[38;5;214m"
      yellow="\033[38;5;3m"
      lightcyan="\033[0;96m"
      nc="\033[0m"
  }
  function human(x) {
      if (x<1000) {return x} else {x/=1024}
      s="KMGTEPZY";
      while (x>=1000 && length(s)>1)
          {x/=1024; s=substr(s,2)}
      return sprintf("%5.4g",x+0.5) nc yellow substr(s,1,1) "B"
  }
  {
    inum = $0
    getline du
    getline dir
    getline file
    if (custom != 0) {
      pos=0
      ext=file
    } else {
      pos=match(file, "\\.[^\\/\\\\:\\.]+$")
    }
    if(pos != 0) {
      ext=substr(file,pos+1)
    }
  }
  ! seen[inum]++ {
    gsub(/\\/, "&&", dir)
    gsub(/\n/, "\\n", dir)
    total += du
    sum[dir] += du
    if (custom != 0) {
      cnt[dir][ext] = du
    } else {
      cnt[dir][ext]++
    }
    if (custom != 0) {
      extensions[ext] += du
      num[ext]++
    } else {
      extensions[ext]++
    }
  }
  END {
    n = 0
    PROCINFO["sorted_in"] = "@val_num_desc"
    for (dir in sum) {
      m = 0
      printf "%s[%s%s] %s%s%s\n", yellow, orange, human(sum[dir] * 512), lightcyan, gensub(/^\.\//, "", "g", dir), nc
      for (ext in cnt[dir]) {
        if (custom != 0) {
          f_nocolor()
          printf "  %s %s\n", human(cnt[dir][ext] * 512), ext
          f_color()
        } else {
          printf "%9g %s\n", cnt[dir][ext], ext
        }
        if (++m >= max) break
      }
      if (++n >= max) break
    }
    if (total > 0 && length(sum) > 1) {
      n = 0
      print "———————————————"
      printf "%s[%s%s] %stotal%s\n", yellow, orange, human(total * 512), yellow, nc
      for (ext in extensions) {
        if (custom != 0) {
          summary_size = human(extensions[ext] * 512)
          printf "  %s%s %s%s %s(%s)%s\n", orange, summary_size, nc, ext, yellow, num[ext], nc
        } else {
          printf "%9g %s\n", extensions[ext], ext
        }
        if (++n >= max) break
      }
    } else if (total > 0 && length(sum) == 1) {
    } else {
      printf "%sNo%s files found.%s\n", orange, desc, nc
    }
  }'

  end=$(date +%s)
  runtime=$((end-start))
  [ "${runtime}" -gt 9 ] && printf "\nElapsed time: %dh:%dm:%ds\n" $(($runtime/3600)) $(($runtime%3600/60)) $(($runtime%60))
}


wii() {
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
}


# bash vs. zsh support
if [ "${BASH_SOURCE[0]}" == "$0" ]; then
  wii "$@"
else
  export -f wii
fi
